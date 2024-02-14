/*
 * Copyright (C) 2023 Atlas of Living Australia
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

class TempDataInterceptor {

    TempDataInterceptor(){
        match(controller: 'tempDataResource')
    }

    boolean before() {
        /** make sure that uid params point to an existing entity and json is parsable **/
        def uid = params.uid
        if (uid) {
            // it must exist
            def drt = TempDataResource.findByUid(uid)
            if (drt) {
                params.drt = drt
                return true
            } else {
                // doesn't exist
                notFound "no entity with uid = ${uid}"
                return false
            }
        }

        // check payload
        if (request.getContentLength() == 0) {
            // no payload so return OK as entity exists (if specified)
            success "no post body"
            return false
        }
        try {
            params.json = request.JSON
            return true
        } catch (Exception e) {
            if (request.getContentLength() > 0) {
                badRequest 'cannot parse request body as JSON'
                return false
            }
        }
        false
    }



    boolean after() { true }

    void afterView() {
        // no-op
    }
}
