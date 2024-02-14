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

class CollectionService {

    static transactional = false

    def dataHubService

    /**
     * Returns a summary of the collection including:
     * - id
     * - name
     * - acronym
     * - lsid if available
     * - institution (id,uid, name & logo url) if available
     * - description
     * - provider codes for matching with biocache records
     *
     * @return CollectionSummary
     */
    CollectionSummary buildSummary(Collection collection) {
        CollectionSummary cs = collection.init(new CollectionSummary()) as CollectionSummary
        if (collection.institution) {
            cs.institutionName = collection.institution.name
            cs.institutionId = collection.institution.id
            cs.institutionUid = collection.institution.uid
            if (collection.institution.logoRef?.file) {
                cs.institutionLogoUrl = au.org.ala.collectory.Utilities.buildInstitutionLogoUrl(collection.institution.logoRef.file)
            }
        }

        cs.collectionId = cs.id
        cs.collectionUid = cs.uid
        cs.collectionName = cs.name

        cs.derivedInstCodes = collection.getListOfInstitutionCodesForLookup()
        cs.derivedCollCodes = collection.getListOfCollectionCodesForLookup()
        cs.hubMembership = dataHubService.listDataHubs().findAll {it.isCollectionMember(collection.uid)}.collect { [uid: it.uid, name: it.name] }
        (collection.providerDataResources + collection.providerDataProviders).each {
            if (it.uid[0..1] == 'dp') {
                cs.relatedDataProviders << [uid: it.uid, name: it.name]
            } else {
                cs.relatedDataResources << [uid: it.uid, name: it.name]
            }
        }
        return cs
    }

}
