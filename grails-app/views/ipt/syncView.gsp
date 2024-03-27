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
                    <th>Title</th>
                    <th>Uid</th>
                    <th style="text-align: right">IPT published</th>
                    <th style="text-align: right">Atlas published</th>
                    <th style="text-align: right">IPT record count</th>
                    <th style="text-align: right">Atlas record count</th>
                </tr>
                <g:each in="${result}" var="item">
                    <tr>
                        <td>
                            <a href="/public/showDataResource/${item.uid}">${item.title}</a>
                        </td>
                        <td style="text-align: right">
                            ${item.uid}
                        </td>
                        <td style="text-align: right">
                            ${item.iptLastPublished}
                        </td>
                        <td style="text-align: right; <g:if test="${item.iptLastPublished != item.atlasLastPublished}">color: red</g:if>">
                            ${item.atlasLastPublished}
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
