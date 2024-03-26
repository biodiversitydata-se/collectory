<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="breadcrumbParent"
              content="${createLink(action: 'list', controller: 'manage')},${message(code: 'manage.list.title01')}"
        />
        <meta name="layout" content="${grailsApplication.config.skin.layout}" />
        <title></title>
        <asset:stylesheet src="application.css" />
    </head>
    <body>
        <div class="body">
            <h1>Sync view</h1>
            <table>
                <tr>
                    <th>Uid</th>
                    <th>Title</th>
                    <th>Gbif published</th>
                    <th>Atlas updated</th>
                    <th>Gbif count</th>
                    <th>Atlas count</th>
                </tr>
                <g:each in="${result}" var="item">
                    <tr>
                        <td style="text-align: right">${item.uid}</td>
                        <td><a href="/public/showDataResource/${item.uid}">${item.title}</a></td>
                        <td>${item.gbifLastPublished}</td>
                        <td <g:if test="${item.dateDiffer}">style="color: red"</g:if><g:else>style="color: green"</g:else>>${item.atlasLastUpdated}</td>
                        <td style="text-align: right">${item.gbifCount}</td>
                        <td style="text-align: right; <g:if test="${item.countDiffer}">color: red</g:if><g:else>color: green</g:else>">
                            ${item.atlasCount}
                        </td>
                    </tr>
                </g:each>
            </table>

    </body>
</html>
