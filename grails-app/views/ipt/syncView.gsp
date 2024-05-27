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
            <div>
                ${result.size} <g:if test="${onlyUnsynced}">unsynced</g:if> datasets &bull;
                <a href="/ipt/syncView?uid=${instance.uid}&sort=${sortBy}&order=${sortDirection}&onlyUnsynced=${!onlyUnsynced}">
                    Show <g:if test="${onlyUnsynced}">all</g:if><g:else>only unsynced</g:else> datasets
                </a>
            </div>
            <table style="margin-top: 8px">
                <tr>
                    <th>
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=title&order=${sortBy=="title" && sortDirection=="asc" ? "desc" : "asc"}">
                            Title
                        </a>
                    </th>
                    <th>
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=uid&order=${sortBy=="uid" && sortDirection=="asc" ? "desc" : "asc"}">
                            UID
                        </a>
                    </th>
                    <th>
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=type&order=${sortBy=="type" && sortDirection=="asc" ? "desc" : "asc"}">
                            Type
                        </a>
                    </th>
                    <th style="xtext-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=iptPublished&order=${sortBy=="iptPublished" && sortDirection=="asc" ? "desc" : "asc"}">
                            IPT date
                        </a>
                    </th>
                    <th style="xtext-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=atlasPublished&order=${sortBy=="atlasPublished" && sortDirection=="asc" ? "desc" : "asc"}">
                            Atlas date
                        </a>
                    </th>
                    <th style="text-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=iptCount&order=${sortBy=="iptCount" && sortDirection=="asc" ? "desc" : "asc"}">
                            IPT count
                        </a>
                    </th>
                    <th style="text-align: right">
                        <a href="/ipt/syncView?uid=${instance.uid}&onlyUnsynced=${onlyUnsynced}&sort=atlasCount&order=${sortBy=="atlasCount" && sortDirection=="asc" ? "desc" : "asc"}">
                            Atlas count
                        </a>
                    </th>
                </tr>
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
                            <g:if test="${item.iptCount != item.atlasCount}">
                                <br>
                                (<g:formatNumber number="${item.atlasCount - item.iptCount}" format="+###,###,##0;-###,###,##0" />)
                            </g:if>
                        </td>
                    </tr>
                </g:each>
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
                    <td style="text-align: right; font-style: italic; <g:if test="${iptTotalCount != atlasTotalCount}">color: red</g:if>">
                        <em><g:formatNumber number="${atlasTotalCount}" format="###,###,##0" /></em>
                        <g:if test="${iptTotalCount != atlasTotalCount}">
                            <br>
                            (<g:formatNumber number="${atlasTotalCount - iptTotalCount}" format="+###,###,##0;-###,###,##0" />)
                        </g:if>
                    </td>
                </tr>
            </table>

    </body>
</html>
