    <%@ page import="au.org.ala.collectory.ExternalResourceBean; grails.converters.JSON; au.org.ala.collectory.ProviderGroup; au.org.ala.collectory.DataProvider" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="breadcrumbParent"
          content="${createLink(action: 'list', controller: 'manage')},${message(code: 'manage.list.title01')}"
    />
    <meta name="breadcrumbs"
          content="${createLink(action: 'repatriate', controller: 'manage')},Repatriation tools"
    />
    <meta name="layout" content="${grailsApplication.config.skin.layout}" />
    <title><g:message code="manage.extloadr.title" /></title>
    <asset:stylesheet src="application.css"/>
    <script type="text/javascript">
      var COLLECTORY_CONF = {
        contextPath: "${request.contextPath}",
        locale: "${(org.springframework.web.servlet.support.RequestContextUtils.getLocale(request).toString())?:request.locale}",
        cartodbPattern: "${grailsApplication.config.cartodb.pattern}"
      };
    </script>
    <asset:javascript src="application-pages.js"/>
</head>
<body>
<h1>
    <g:if test="${dataProvider?.name}">
        <g:message code="manage.extloadr.title01" args="${[ configuration.country, dataProvider?.name ?: 'none' ]}"/>
    </g:if>
    <g:else>
        <g:message code="manage.extloadr.title01.noprovider" />
    </g:else>
</h1>
<div>
    <g:form action="updateFromExternalSources" controller="manage">
        <g:hiddenField name="loadGuid" value="${loadGuid}"/>
        <g:hiddenField name="guid" value="${configuration.guid}"/>
        <g:hiddenField name="name" value="${configuration.name}"/>
        <g:hiddenField name="description" value="${configuration.description}"/>
        <g:hiddenField name="adaptorString" value="${configuration.adaptorString}"/>
        <g:hiddenField name="endpoint" value="${configuration.endpoint}"/>
        <g:hiddenField name="dataProviderUid" value="${configuration.dataProviderUid}"/>
        <g:hiddenField name="username" value="${configuration.username}"/>
        <g:hiddenField name="password" value="${configuration.password}"/>
        <g:hiddenField name="country" value="${configuration.country}"/>
        <g:hiddenField name="minRecordCount" value="${configuration.minRecordCount}"/>
        <g:hiddenField name="maxRecordCount" value="${configuration.maxRecordCount}"/>
        <table id="resource-table" class="resource-table table table-hover table-sm">
            <thead>
                <tr class="header">
                    <th>ID</th>
                    <th><g:message code="manage.extloadr.label01"/></th>
                    <th><g:message code="manage.extloadr.label03"/></th>
                    <th><g:message code="manage.extloadr.label10"/></th>
                    <th><g:message code="manage.extloadr.label04"/></th>
                    <th><g:message code="manage.extloadr.label05"/></th>
                    <th><g:message code="manage.extloadr.label06"/> <span class="btn btn-default btn-xs" onclick="invertColumn('.addResource'); return false">x</span></th>
                    <th><g:message code="manage.extloadr.label07"/> <span class="btn btn-default btn-xs" onclick="invertColumn('.updateMetadata'); return false">x</span></th>
                    <th><g:message code="manage.extloadr.label08"/> <span class="btn btn-default btn-xs" onclick="invertColumn('.updateConnection'); return false">x</span></th>
                    <th><g:message code="manage.extloadr.label09"/></th>
                </tr>
            </thead>
            <tbody>
            <g:if test="${configuration.resources}">
            <g:each in="${configuration.resources}" var="res" status="rs">
            <tr class="resource-scan-${res.status}">
                <td>
                    <small><a href="https://dx.doi.org/${res.source}"><g:fieldValue field="guid" bean="${res}"/></a></small>
                </td>
                <td>
                    <g:hiddenField id="resources-${rs}-uid" name="resources[${rs}].uid" value="${res.uid}"/>
                    <g:hiddenField name="resources[${rs}].guid" value="${res.guid}"/>
                    <g:hiddenField name="resources[${rs}].source" value="${res.source}"/>
                    <g:hiddenField name="resources[${rs}].country" value="${configuration.country}"/>
                    <g:textField class="resource-name col-xs-4" style="width: 24em" name="resources[${rs}].name" value="${res.name}" />
                </td>
                <td>${res.type}</td>
                <td><span title="<g:message code="manage.extstatus.${res.status}.detail"/>"><g:message code="manage.extstatus.${res.status}"/></span></td>
                <td class="resource-mapping"><span id="existing-${rs}"><g:if test="${res.uid}">
                    <g:link controller="dataResource" action="show" id="${res.uid}" target="_new"> <g:fieldValue field="uid" bean="${res}"/></g:link>
                    </g:if></span>
                    &nbsp; &nbsp; <span class="btn btn-default btn-xs" onclick="existingDialog('#existing-${rs}', '#resources-${rs}-uid'); return false"><g:message code="manage.extloadr.button01" default="..."/></span> </td>
                <td><g:formatDate type="datetime" date="${res.sourceUpdated}"/><g:if test="${res.existingChecked}">&nbsp;(<g:formatDate type="datetime" date="${res.existingChecked}"/>)</g:if></td>
                <td><g:checkBox name="resources[${rs}].addResource" value="${res.addResource}"/></td>
                <td><g:checkBox name="resources[${rs}].updateMetadata" value="${res.updateMetadata}"/></td>
                <td><g:checkBox name="resources[${rs}].updateConnection" value="${res.updateConnection}"/></td>
                <td><g:formatNumber number="${res.recordCount}" format="###,###,##0" /></td>
            </tr>
            </g:each>
            </g:if>
            </tbody>
        </table>
        <div>
            <g:if test="${configuration.resources}">
                <span class="button"><g:actionSubmit class="save btn btn-warning" controller="manage" action="updateFromExternalSources" value="${message(code: 'default.button.load.label', default: 'Load')}" onclick="return confirm('${message(code: 'default.button.load.confirm.message', default: 'Are you sure?')}');" /></span>
            </g:if>
        </div>
    </g:form>
</div>
<div class="hide">
<div id="existing-dialog" title="<g:message code="manage.extloadr.title02" default="Find Data Resource"/>">
    <table id="existing-dataresources" class="table table-striped">
    <thead>
    <tr><th></th><th><g:message code="manage.extloadr.label01"/></th></tr>
    </thead>
    <tbody>
<g:each in="${dataResources}" var="res" status="rs">
    <tr id="existing-row-${res.uid}"><td>${res.uid}</td><td><g:fieldValue field="name" bean="${res}"/></td></tr>
</g:each>
    </tbody>
    </table>
    <div class="buttons">
        <span id="existing-ok-button" class="btn btn-success"><g:message code="manage.extloadr.button.ok" default="Ok"/></span>
        <span id="existing-cancel-button" class="btn btn-default" onlcick="$('#existing-dialog').dialog('close')"><g:message code="manage.extloadr.button.cancel" default="Cancel"/></span>
    </div>
</div>
</div>
<script type="text/javascript">
    var existing_table, existing_dialog, resource_table;

    var width = $(window).width();
    width =  Math.ceil(Math.min(width * 0.9, Math.max(700, width * 0.4)));
    $(function () {
        existing_dialog = $('#existing-dialog').dialog({
            autoOpen: false,
            modal: true,
            width: width,
            zIndex: 2000
        });
        existing_table = $('#existing-dataresources').DataTable({
            select: "single"
        });
        resource_table = $('#resource-table').DataTable({
            "language": {
               "emptyTable": jQuery.i18n.prop('manage.extloadr.noresources'),
            },
            "columns": [
                {"orderable": false},
                null,
                null,
                null,
                null,
                null,
                {"orderable": false},
                {"orderable": false},
                {"orderable": false},
                null
            ]
        });
    } );

    function existingOk(existingId, uidId) {
        var selected = existing_table.rows({ selected: true});
        var uid = '';
        var name = '';
        if (selected.count() > 0) {
            var data = selected.data().toArray()[0];
            uid = data[0];
            name = data[0] + ' - ' + data[1];
        }
        $(uidId).val(uid);
        $(existingId).html(name);
    }

    function existingDialog(existingId, uidId) {
        var uid = $(uidId).val();
        var width = $(window).width();


        $('#existing-ok-button').off('click'); // jQuery click function *adds* handler
        $('#existing-ok-button').click( function() { existingOk(existingId, uidId); existing_dialog.dialog("close"); });
        existing_dialog.dialog("open");
        if (uid != null && uid != '') {
            var selected = existing_table.row('#existing-row-' + uid);
            selected.select();
        }
    }

    function invertColumn(suffix) {
        $('input:checkbox').each( function(index, element) {
            if (element.name.endsWith(suffix)) {
                element.checked = !element.checked;
            }
        });
    }

    /* Fix for curCSS bug */
    jQuery.curCSS = function(element, prop, val) {
        return jQuery(element).css(prop, val);
    };
</script>
</body>
</html>