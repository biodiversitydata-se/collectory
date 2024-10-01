<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${grailsApplication.config.skin.layout}" />
        <meta name="breadcrumbParent"
              content="${createLink(action: 'list', controller: 'manage')},${message(code: 'manage.list.title01')}"
        />
        <meta name="breadcrumbs"
              content="${createLink(action: 'show', controller: 'dataProvider', id:instance.uid)},${instance.name}"
        />
        <title>${instance.name} vs Atlas</title>
        <asset:stylesheet src="application.css" />
        <asset:javascript src="application-pages.js"/>
    </head>
    <body>
        <div class="body">
            <h1>${instance.name} vs Atlas</h1>
            <div>
                ${result.size} <g:if test="${onlyUnsynced}">unsynced</g:if> datasets &bull;
                <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${!onlyUnsynced}">
                    Show <g:if test="${onlyUnsynced}">all</g:if><g:else>only unsynced</g:else> datasets
                </a>
            </div>
            <table id="dataset-table" class="table">
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>UID</th>
                        <th>Type</th>
                        <th>IPT date</th>
                        <th>Atlas date</th>
                        <th style="text-align: right">IPT count</th>
                        <th style="text-align: right">Atlas count</th>
                        <th style="text-align: right">Diff</th>
                    </tr>
                </thead>
                <tbody>
                    <g:each in="${result}" var="item">
                        <tr>
                            <td>
                                ${item.title}<br>
                                <a href="${item.iptUrl}">IPT</a>&nbsp;&nbsp;
                                <a href="/public/showDataResource/${item.uid}">Atlas</a>
                            </td>
                            <td>
                                ${item.uid}
                            </td>
                            <td>
                                ${item.type}
                            </td>
                            <td>
                                ${item.iptPublished}
                            </td>
                            <td <g:if test="${item.iptPublished != item.atlasPublished}">style="color: red"</g:if>>
                                ${item.atlasPublished}
                            </td>
                            <td style="text-align: right;">
                                <g:formatNumber number="${item.iptCount}" format="###,###,##0" />
                            </td>
                            <td style="text-align: right; <g:if test="${item.iptCount != item.atlasCount}">color: red</g:if>">
                                <g:formatNumber number="${item.atlasCount}" format="###,###,##0" />
                            </td>
                            <td style="text-align: right; color: red">
                                <g:if test="${item.iptCount != item.atlasCount}">
                                    <g:formatNumber number="${item.atlasCount - item.iptCount}" format="+###,###,##0;-###,###,##0" />
                                </g:if>
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
                        <td style="text-align: right">
                            <em><g:formatNumber number="${iptTotalCount}" format="###,###,##0" /></em>
                        </td>
                        <td style="text-align: right; <g:if test="${iptTotalCount != atlasTotalCount}">color: red</g:if>">
                            <em><g:formatNumber number="${atlasTotalCount}" format="###,###,##0" /></em>
                        </td>
                        <td style="text-align: right; color: red">
                            <g:if test="${iptTotalCount != atlasTotalCount}">
                                <em><g:formatNumber number="${atlasTotalCount - iptTotalCount}" format="+###,###,##0;-###,###,##0" /></em>
                            </g:if>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
        <script type="text/javascript">
            $(document).ready(function() {
                $('#dataset-table').DataTable({
                    paging: false,
                    searching: false,
                    info: false,
                    columnDefs: [{ type: 'num-fmt', targets: [5, 6, 7] }],
                });
            });
        </script>
    </body>
</html>
