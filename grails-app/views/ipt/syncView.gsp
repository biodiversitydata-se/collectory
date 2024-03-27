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
    </head>
    <body>
        <div class="body">
            <h1>${instance.name} vs Atlas</h1>
            <table>
                <tr>
                    <th>
                        <a href="/ipt/syncView?uid=${instance.uid}&sort=title&order=${sortBy=="title" && sortDirection=="asc" ? "desc" : "asc"}">Title</a>
                    </th>
                    <th>
                        <a href="/ipt/syncView?uid=${instance.uid}&sort=uid&order=${sortBy=="uid" && sortDirection=="asc" ? "desc" : "asc"}">Uid</a>
                    </th>
                    <th>
                        <a href="/ipt/syncView?uid=${instance.uid}&sort=type&order=${sortBy=="type" && sortDirection=="asc" ? "desc" : "asc"}">Type</a>
                    </th>
                    <th style="text-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&sort=iptPublished&order=${sortBy=="iptPublished" && sortDirection=="asc" ? "desc" : "asc"}">IPT published</a>
                    </th>
                    <th style="text-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&sort=atlasPublished&order=${sortBy=="atlasPublished" && sortDirection=="asc" ? "desc" : "asc"}">Atlas published</a>
                    </th>
                    <th style="text-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&sort=iptCount&order=${sortBy=="iptCount" && sortDirection=="asc" ? "desc" : "asc"}">IPT record count</a>
                    </th>
                    <th style="text-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&sort=atlasCount&order=${sortBy=="atlasCount" && sortDirection=="asc" ? "desc" : "asc"}">Atlas record count</a>
                    </th>
                </tr>
                <g:each in="${result}" var="item">
                    <tr>
                        <td>
                            <a href="/public/showDataResource/${item.uid}">${item.title}</a>
                        </td>
                        <td style="text-align: right">
                            ${item.uid}
                        </td>
                        <td>
                            ${item.type}
                        </td>
                        <td style="text-align: right">
                            ${item.iptPublished}
                        </td>
                        <td style="text-align: right; <g:if test="${item.iptPublished != item.atlasPublished}">color: red</g:if>">
                            ${item.atlasPublished}
                        </td>
                        <td style="text-align: right">
                            <g:formatNumber number="${item.iptCount}" format="###,###,##0" />
                        </td>
                        <td style="text-align: right; <g:if test="${item.iptCount != item.atlasCount}">color: red</g:if>">
                            <g:formatNumber number="${item.atlasCount}" format="###,###,##0" />
                        </td>
                    </tr>
                </g:each>
            </table>

    </body>
</html>
