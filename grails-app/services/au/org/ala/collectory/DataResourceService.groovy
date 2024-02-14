/*
 * Copyright (C) 2011 Atlas of Living Australia
 * All Rights Reserved.
 *
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 */
package au.org.ala.collectory


import grails.plugin.cache.Cacheable

class DataResourceService {

    static transactional = false

    def dataHubService

    /**
     * Returns a summary of the data provider including:
     * - id
     * - name
     * - acronym
     * - lsid if available
     * - description
     * - data provider name, id and uid
     *
     * @return CollectionSummary
     */
    DataResourceSummary buildSummary(DataResource dataResource) {
        DataResourceSummary drs = dataResource.init(new DataResourceSummary()) as DataResourceSummary
        drs.dataProvider = dataResource.dataProvider?.name
        drs.dataProviderId = dataResource.dataProvider?.id
        drs.dataProviderUid = dataResource.dataProvider?.uid
        drs.downloadLimit = dataResource.downloadLimit

        drs.hubMembership = dataHubService.listDataHubs().findAll {it.isDataResourceMember(dataResource.uid)}.collect { [uid: it.uid, name: it.name] }
        def consumers = dataResource.consumerInstitutions + dataResource.consumerCollections
        consumers.each {
            if (it.uid[0..1] == 'co') {
                drs.relatedCollections << [uid: it.uid, name: it.name]
            } else {
                drs.relatedInstitutions << [uid: it.uid, name: it.name]
            }
        }
        // for backward compatibility
        if (drs.relatedInstitutions) {
            drs.institution = drs.relatedInstitutions[0].name
            drs.institutionUid = drs.relatedInstitutions[0].uid
        }
        return drs
    }
}
