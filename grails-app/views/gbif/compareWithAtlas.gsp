<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="breadcrumbParent"
          content="${createLink(action: 'list', controller: 'manage')},${message(code: 'manage.list.title01')}"
    />
    <meta name="breadcrumbs"
          content="${createLink(action: 'show', controller: 'dataProvider', id:dataProvider.uid)},${dataProvider.name}"
    />
    <meta name="layout" content="${grailsApplication.config.skin.layout}" />
    <title>
        GBIF vs Atlas (${dataProvider})
    </title>
    <asset:stylesheet src="application.css" />
    <asset:javascript src="application-pages.js"/>
</head>
<body>
    <h1>GBIF vs Atlas (${dataProvider})</h1>
    <div>
        ${result.size} datasets &bull;
        ${pendingSyncCount} pending GBIF sync
            <g:if test="${pendingSyncCount > 0}">
                [ <a id="sync-now-link" href="javascript:void(0)">Sync now</a> ]
            </g:if>
            &bull;
        ${pendingIngestionCount} pending data ingestion
    </div>
    <div>
        <a href="/gbif/compareWithAtlas?uid=${dataProvider.uid}&onlyOutOfSync=${!onlyOutOfSync}">
            Show <g:if test="${onlyOutOfSync}">all</g:if><g:else>only out-of-sync</g:else> datasets
        </a>
    </div>
    <table id="dataset-table" class="table">
        <thead>
            <tr>
                <th>Title</th>
                <th>UID</th>
                <th>Type</th>
                <th>Repatriation country</th>
                <th>GBIF pub date</th>
                <th>Atlas last update</th>
                <th style="text-align: right">GBIF count</th>
                <th style="text-align: right">Atlas count</th>
                <th style="text-align: right">Diff</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <g:each in="${result}" var="item">
                <tr>
                    <td>
                        ${item.title}<br>
                        <a href="https://www.gbif.org/dataset/${item.gbifKey}">GBIF</a>&nbsp;&nbsp;
                        <a href="/public/showDataResource/${item.uid}">Atlas</a>
                    </td>
                    <td>
                        ${item.uid}
                    </td>
                    <td>
                        ${item.type}
                    </td>
                    <td>
                        ${item.repatriationCountry}
                    </td>
                    <td <g:if test="${item.gbifPublished > item.atlasPublished}">style="color: red"</g:if>>
                        <g:formatDate format="yyyy-MM-dd HH:mm" date="${item.gbifPublished}"/>
                    </td>
                    <td>
                        <g:formatDate format="yyyy-MM-dd HH:mm" date="${item.atlasPublished}"/>
                    </td>
                    <td style="text-align: right; <g:if test="${item.gbifCount != item.atlasCount}">color: red</g:if>">
                        <g:formatNumber number="${item.gbifCount}" format="###,###,##0" />
                    </td>
                    <td style="text-align: right;">
                        <g:formatNumber number="${item.atlasCount}" format="###,###,##0" />
                    </td>
                    <td style="text-align: right; color: red">
                        <g:if test="${item.gbifCount != item.atlasCount}">
                            <g:formatNumber number="${item.atlasCount - item.gbifCount}" format="+###,###,##0;-###,###,##0" />
                        </g:if>
                    </td>
                    <td style="color: red">
                        ${item.status}
                    </td>
                </tr>
            </g:each>
        </tbody>
        <tfoot>
            <tr>
                <td style="font-style: italic">
                    Total all datasets
                </td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td style="text-align: right; font-style: italic; <g:if test="${gbifTotalCount != atlasTotalCount}">color: red</g:if>">
                    <g:formatNumber number="${gbifTotalCount}" format="###,###,##0" />
                </td>
                <td style="text-align: right; font-style: italic;">
                    <g:formatNumber number="${atlasTotalCount}" format="###,###,##0" />
                </td>
                <td style="text-align: right; font-style: italic; color: red">
                    <g:if test="${gbifTotalCount != atlasTotalCount}">
                        <g:formatNumber number="${atlasTotalCount - gbifTotalCount}" format="+###,###,##0;-###,###,##0" />
                    </g:if>
                </td>
                <td></td>
            </tr>
        </tfoot>
    </table>
    <script type="text/javascript">
        $(document).ready(function() {
            $('#dataset-table').DataTable({
                paging: false,
                searching: false,
                info: false,
                columnDefs: [{ type: 'num-fmt', targets: [6, 7, 8] }],
            });

            $('#sync-now-link').on('click', function() {
                var scanUrl = '${grailsApplication.config.getProperty("grails.serverURL")}/ws/gbif/scan/${dataProvider.uid}'
                $.getJSON(scanUrl, function(data) {
                    location.href = '${grailsApplication.config.getProperty("grails.serverURL")}' + data.trackingUrl;
                });
            });
        });
    </script>
</body>
</html>
