package au.org.ala.collectory

import au.org.ala.collectory.resources.DataSourceLoad
import au.org.ala.collectory.resources.gbif.GbifDataSourceAdapter
import au.org.ala.collectory.resources.gbif.GbifRepatDataSourceAdapter
import groovy.json.JsonSlurper

class ManageController {

    def collectoryAuthService
    def externalDataService
    def gbifService
    def providerGroupService

    /**
     * Landing page for self-service management of entities.
     *
     * If the user is logged in, redirect to the cas-enabled 'list' action, so we can get roles.
     * Only users who are NOT logged in will see the 'index' page.
     *
     * @param noRedirect if present will override the redirect (for testing purposes only)
     */
    def index = {
        // forward if logged in
        if ((!grailsApplication.config.security.oidc.enabled.toBoolean()  || request?.getUserPrincipal()) && !params.noRedirect) {
            redirect(action: 'list')
        }
    }

    /**
     * Renders the view that allows a user to load all the gbif resources for a country
     */
    def repatriate = {
        DataSourceConfiguration configuration = new DataSourceConfiguration(
                guid: UUID.randomUUID().toString(),
                name: '',
                description: '',
                adaptorClass: GbifRepatDataSourceAdapter.class,
                endpoint: new URL(grailsApplication.config.gbifApiUrl),
                username: '',
                password: '',
                country: grailsApplication.config.getProperty(
                        'repatriate.defaults.country', String.class, Locale.default.getCountry()),
                recordType: 'OCCURRENCE',
                defaultDatasetValues: [:],
                keyTerms: [],
                resources: [],
                countries: gbifService.getCountryMap().keySet(),
                dataProviderUid: grailsApplication.config.getProperty(
                        'repatriate.defaults.dataProviderUId', String.class)
        )
        def adaptor = configuration.createAdaptor()
        render(view: "repatriate",
                model: [
                        repatriate: true,
                        configuration: configuration,
                        countryMap: gbifService.getCountryMap(),
                        datasetTypeMap: adaptor.datasetTypeMap,
                        adaptors: externalDataService.REPAT_ADAPTORMAP,
                        dataProviders: DataProvider.all.sort { it.name }
                ]
        )
    }

    /**
     * Renders the view that allows a user to load all the gbif resources for a country
     */
    def loadExternalResources = {
        DataSourceConfiguration configuration = new DataSourceConfiguration(
                guid: UUID.randomUUID().toString(),
                name: '',
                description: '',
                adaptorClass: GbifDataSourceAdapter.class,
                endpoint: new URL(grailsApplication.config.gbifApiUrl),
                username: '',
                password: '',
                country: Locale.default.getCountry(),
                recordType: 'OCCURRENCE',
                defaultDatasetValues: [:],
                keyTerms: [],
                resources: []
        )
        def adaptor = configuration.createAdaptor()
        render(view: "externalLoad",
               model: [
                    configuration: configuration,
                    countryMap: gbifService.getCountryMap(),
                    datasetTypeMap: adaptor.datasetTypeMap,
                    adaptors: externalDataService.ADAPTORMAP,
                    dataProviders: DataProvider.all.sort { it.name }
                ]
        )
    }

    def gbifCompare() {
        def dataResources = DataResource.findAllByGbifDataset(true)

        def countryDatasetMap = [:]
        dataResources.each { dr ->
            countryDatasetMap.merge(dr.repatriationCountry, [dr.gbifRegistryKey], List::plus)
        }

        def gbifDatasetRecordCountMap = [:]
        countryDatasetMap.each { country, datasets ->
            gbifDatasetRecordCountMap.putAll(gbifService.getDatasetRecordCounts(datasets, country))
        }

        def result = []
        def gbifTotalCount = 0
        def atlasTotalCount = 0

        dataResources.each { dr ->
            def atlasCountUrl = grailsApplication.config.biocacheServicesUrl +
                    "/occurrences/search?pageSize=0&fq=data_resource_uid:" + dr.uid
            def atlasCountJson = new JsonSlurper().parse(new URL(atlasCountUrl))

            def item = [
                    title: dr.name,
                    uid: dr.uid,
                    gbifKey: dr.gbifRegistryKey,
                    type: dr.resourceType,
                    repatriationCountry: dr.repatriationCountry,
                    gbifPublished: gbifService.getGbifDatasetLastUpdated(dr.gbifRegistryKey),
                    gbifCount: gbifDatasetRecordCountMap.getOrDefault(dr.gbifRegistryKey, 0),
                    atlasCount: atlasCountJson.totalRecords,
                    atlasPublished: dr.dataCurrency
            ]

            result << item
            gbifTotalCount += item.gbifCount
            atlasTotalCount += item.atlasCount
        }

        result.sort { it["title"] }

        ["result" : result,
         "gbifTotalCount": gbifTotalCount,
         "atlasTotalCount": atlasTotalCount]
    }

    /**
     * Search for resources that may be loaded from an external source
     */
    def searchForResources() {
        log.debug "Searching for resources from external source: ${params}"
        DataSourceConfiguration configuration = new DataSourceConfiguration(params)
        def dataResources = DataResource.all.findAll({ dr -> dr.resourceType == 'records' }).sort({ it.name })
        def resources = externalDataService.searchForDatasets(configuration)
        configuration.resources = resources
        def dataProvider = null
        if (configuration.dataProviderUid){
            dataProvider = DataProvider.findByUid(configuration.dataProviderUid)
        }
        render(view: 'externalLoadReview',
               model: [
                       loadGuid: UUID.randomUUID().toString(),
                       dataResources: dataResources,
                       dataProvider: dataProvider,
                       configuration: configuration
               ]
        )
    }

    /**
     * Search for resources that may be loaded from an external source
     */
    def searchForRepatResources() {
        log.debug "Searching for resources from external source: ${params}"

        // Use login credentials from configuration
        params.username = grailsApplication.config.gbifApiUser
        params.password = grailsApplication.config.gbifApiPassword

        DataSourceConfiguration configuration = new DataSourceConfiguration(params)
        def dataResources = DataResource.all.findAll({ dr -> dr.resourceType == 'records' }).sort({ it.name })
        def resources = externalDataService.searchForDatasets(configuration)
        configuration.resources = resources
        def dataProvider = null
        if (configuration.dataProviderUid){
            dataProvider = DataProvider.findByUid(configuration.dataProviderUid)
        }
        render(view: 'repatriateReview',
                model: [
                        loadGuid: UUID.randomUUID().toString(),
                        dataResources: dataResources,
                        dataProvider: dataProvider,
                        configuration: configuration
                ]
        )
    }

    /**
     * Update from an external source
     * <p>
     * The web pade
     */
    def updateFromExternalSources() {
        log.debug "Update resources from external source: ${params}"
        DataSourceConfiguration configuration = new DataSourceConfiguration(params)
        externalDataService.updateFromExternalSources(configuration, params.loadGuid)
        redirect(action: 'externalLoadStatus', params: [loadGuid: params.loadGuid])
    }

    /**
     *
     * @return
     */
    def loadDataset() {

        log.debug("Loading resources from GBIF: " + params)
        if (params.guid) {
            gbifService.downloadGbifDataset(
                    params.guid,
                    params.repatriationCountry)
            redirect(action: 'gbifDatasetLoadStatus', model: ['datasetKey': params.guid], params: ['datasetKey': params.guid])
        }
    }

    /**
     *
     * Display the load status for the supplied country
     * country - the country to supply the status for
     * @return
     */
    def gbifDatasetLoadStatus(){
        log.debug('key->' + params.datasetKey)
        def gbifSummary = gbifService.getDatasetKeyStatusInfoFor(params.datasetKey)
        log.debug(gbifSummary)
        [gbifSummary:gbifSummary,'datasetKey':params.datasetKey]
    }

    /**
     *
     * @return
     */
    def gbifDatasetDownload() {
        log.debug('Dataset id ' + params.id)
        def dr = DataResource.findByUid(params.id)
        render(view: "gbifDatasetDownload", model: ['uid': dr.uid, 'guid' : dr.guid, 'dr' : dr])
    }

    /**
     *
     * Display the load status for the supplied country
     * country - the country to supply the status for
     * @return
     */
    def gbifCountryLoadStatus(){
        def gbifSummary = gbifService.getStatusInfoFor(params.country)
        [country: params.country, gbifSummary:gbifSummary]
    }

    /**
     *
     * Display the load status for the supplied load
     */
    def externalLoadStatus(){
        DataSourceLoad load = externalDataService.getStatusInfoFor(params.loadGuid)
        [load :load, refreshInterval: externalDataService.POLL_INTERVAL]
    }

    /**
     * Landing page for self-service management of entities.
     *
     * @param show = user will display user login/cookie/roles details
     */
    def list = {
        // find the entities the user is allowed to edit
        def entities = collectoryAuthService.authorisedForUser(collectoryAuthService.username()).sorted

        log.debug("user ${collectoryAuthService.username()} has ${request.getUserPrincipal()?.attributes}")

        // get their contact details in case needed
        def contact = Contact.findByEmail(collectoryAuthService.username())

        [entities: entities, user: contact, show: params.show]
    }

    def show = {
        // assume it's a collection for now
        def instance = providerGroupService._get(params.id)
        if (!instance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'collection.label', default: 'Collection'), params?.id])}"
            redirect(controller: "manage", action: "list")
        } else {
            [instance: instance, changes: getChanges(instance.uid)]
        }
    }

    def getChanges(uid) {
        // get audit records
        return AuditLogEvent.findAllByUri(uid,[sort:'lastUpdated',order:'desc',max:20])
    }


}
