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
            <a href="/ipt/syncView?uid=${instance.uid}&sort=${sortBy}&order=${sortDirection}&onlyUnsynced=${!onlyUnsynced}">
                Show <g:if test="${onlyUnsynced}">all</g:if><g:else>only unsynced</g:else> datasets
            </a>
            <table style="margin-top: 8px">
                <tr>
                    <th>
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=title&order=${sortBy=="title" && sortDirection=="asc" ? "desc" : "asc"}">Title</a>
                    </th>
                    <th>
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=uid&order=${sortBy=="uid" && sortDirection=="asc" ? "desc" : "asc"}">Uid</a>
                    </th>
                    <th>
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=type&order=${sortBy=="type" && sortDirection=="asc" ? "desc" : "asc"}">Type</a>
                    </th>
                    <th style="text-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=iptPublished&order=${sortBy=="iptPublished" && sortDirection=="asc" ? "desc" : "asc"}">IPT published</a>
                    </th>
                    <th style="text-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=atlasPublished&order=${sortBy=="atlasPublished" && sortDirection=="asc" ? "desc" : "asc"}">Atlas published</a>
                    </th>
                    <th style="text-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=iptCount&order=${sortBy=="iptCount" && sortDirection=="asc" ? "desc" : "asc"}">IPT record count</a>
                    </th>
                    <th style="text-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=atlasCount&order=${sortBy=="atlasCount" && sortDirection=="asc" ? "desc" : "asc"}">Atlas record count</a>
                    </th>
                </tr>
                <g:each in="${result}" var="item">
                    <tr>
                        <td>
                            ${item.title}<br>
                            <a href="${item.iptUrl}">IPT</a>&nbsp;&nbsp;
                            <a href="/public/showDataResource/${item.uid}">Atlas</a>
                        </td>
                        <td style="text-align: right">
                            ${item.uid}
                        </td>
                        <td>
                            ${item.type}
                        </td>
                        <td style="text-align: right; <g:if test="${item.iptPublished != item.atlasPublished}">color: green</g:if>">
                            ${item.iptPublished}
                        </td>
                        <td style="text-align: right; <g:if test="${item.iptPublished != item.atlasPublished}">color: red</g:if>">
                            ${item.atlasPublished}
                        </td>
                        <td style="text-align: right; <g:if test="${item.iptCount != item.atlasCount}">color: green</g:if>">
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
