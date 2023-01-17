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

import org.apache.http.HttpStatus


class AdminRoleInterceptor {

    CollectoryAuthService collectoryAuthService

    AdminRoleInterceptor(){
        match(controller: 'admin')
    }

    boolean before() {
        // check roles using userInRoles.userInRole methods also returns true if user has the application configured ROLE_ADMIN.
        if (collectoryAuthService?.userInRole(grailsApplication.config.ROLE_ADMIN)) {
            return true
        }
        response.sendError(HttpStatus.SC_UNAUTHORIZED)
        return false
    }



    boolean after() { true }

    void afterView() {
        // no-op
    }
}
