<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="breadcrumbParent"
          content="${createLink(action: 'list', controller: 'manage')},${message(code: 'manage.list.title01')}"
    />
    <meta name="layout" content="${grailsApplication.config.skin.layout}" />
    <title>
        GBIF vs Atlas
    </title>
    <asset:stylesheet src="application.css" />
</head>
<body>
    <h1>GBIF vs Atlas</h1>
    <table>
        <tr>
            <th>Title</th>
            <th>UID</th>
            <th>Type</th>
            <th>Repatriation country</th>
            <th>GBIF date</th>
            <th>Atlas date</th>
            <th style="text-align: right">GBIF count</th>
            <th style="text-align: right">Atlas count</th>
        </tr>
        <g:each in="${result}" var="item">
            <tr>
                <td>
                    ${item.title}<br>
                    <a href="https://www.gbif.org/dataset/${item.gbifKey}">GBIF</a>&nbsp;&nbsp;
                    <a href="/public/showDataResource/${item.uid}">Atlas</a>
                </td>
                <td>${item.uid}</td>
                <td>${item.type}</td>
                <td>${item.repatriationCountry}</td>
                <td>
                    <g:formatDate type="datetime" date="${item.gbifPublished}"/>
                </td>
                <td <g:if test="${item.gbifPublished != item.atlasPublished}">style="color: red"</g:if>>
                    <g:formatDate type="datetime" date="${item.atlasPublished}"/>
                </td>
                <td style="text-align: right;">
                    <g:formatNumber number="${item.gbifCount}" format="###,###,##0" />
                </td>
                <td style="text-align: right; <g:if test="${item.gbifCount != item.atlasCount}">color: red</g:if>">
                    <g:formatNumber number="${item.atlasCount}" format="###,###,##0" />
                    <g:if test="${item.gbifCount != item.atlasCount}">
                        <br>
                        (<g:formatNumber number="${item.atlasCount - item.gbifCount}" format="+###,###,##0;-###,###,##0" />)
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
            <td></td>
            <td style="text-align: right">
                <em><g:formatNumber number="${gbifTotalCount}" format="###,###,##0" /></em>
            </td>
            <td style="text-align: right; font-style: italic; <g:if test="${gbifTotalCount != atlasTotalCount}">color: red</g:if>">
                <em><g:formatNumber number="${atlasTotalCount}" format="###,###,##0" /></em>
                <g:if test="${gbifTotalCount != atlasTotalCount}">
                    <br>
                    (<g:formatNumber number="${atlasTotalCount - gbifTotalCount}" format="+###,###,##0;-###,###,##0" />)
                </g:if>
            </td>
        </tr>
    </table>
</body>
</html>
