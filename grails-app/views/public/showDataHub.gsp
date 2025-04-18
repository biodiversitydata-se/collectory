<%@ page contentType="text/html;charset=UTF-8" import="au.org.ala.collectory.DataHub"%>
<g:set var="orgNameLong" value="${grailsApplication.config.skin.orgNameLong}"/>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="layout" content="${grailsApplication.config.skin.layout}" />
    <link rel="canonical" href="${grailsApplication.config.getProperty('grails.serverURL')}/public/show/${instance.uid}" />
    <title>${fieldValue(bean: instance, field: "name")}</title>
    <script type="text/javascript" language="javascript" src="https://www.google.com/jsapi"></script>
    <asset:stylesheet src="application.css"/>
    <script type="text/javascript">
      // Global var SHOW_REC to pass GSP data to external JS file
      var SHOW_REC = {
          orgNameLong: "${orgNameLong}",
          biocacheServicesUrl: "${grailsApplication.config.biocacheServicesUrl}",
          biocacheWebappUrl: "${grailsApplication.config.biocacheUiURL}",
          loggerServiceUrl: "${grailsApplication.config.loggerURL}",
          loadLoggerStats: ${!grailsApplication.config.disableLoggerLinks.toBoolean()},
          instanceUuid: "${instance.uid}",
          instanceName:"${instance.name}"
      }

      biocacheServicesUrl = "${grailsApplication.config.biocacheServicesUrl}";
      biocacheWebappUrl = "${grailsApplication.config.biocacheUiURL}";
    </script>
    <script type="text/javascript">
      var COLLECTORY_CONF = {
        contextPath: "${request.contextPath}",
        locale: "${(org.springframework.web.servlet.support.RequestContextUtils.getLocale(request).toString())?:request.locale}",
        cartodbPattern: "${grailsApplication.config.cartodb.pattern}"
      };
    </script>
    <asset:javascript src="application-pages.js"/>
  </head>
  <body class="two-column-right">
    <div id="content">
      <div id="header" class="collectory">
        <cl:pageOptionsPopup instance="${instance}"/>
        <div class="row">
          <div class="col-md-8">
            <cl:h1 value="${instance.name}"/>
            <g:render template="editButton"/>
            <cl:valueOrOtherwise value="${instance.acronym}"><span class="acronym"><g:message code="public.sdh.header.span01" />: ${fieldValue(bean: instance, field: "acronym")}</span></cl:valueOrOtherwise>
            <g:if test="${instance.guid?.startsWith('urn:lsid:')}">
              <span class="lsid"><a href="#lsidText" id="lsid" class="local" title="Life Science Identifier (pop-up)"><g:message code="public.lsid" /></a></span>
              <div style="display:none; text-align: left;">
                  <div id="lsidText" style="text-align: left;">
                      <b><a class="external_icon" href="https://wayback.archive.org/web/20100515104710/http://lsids.sourceforge.net:80/" target="_blank"><g:message code="public.lsidtext.link" />:</a></b>
                      <p style="margin: 10px 0;"><cl:guid target="_blank" guid='${fieldValue(bean: instance, field: "guid")}'/></p>
                      <p style="font-size: 12px;"><g:message code="public.lsidtext.des" />. </p>
                  </div>
              </div>
            </g:if>
          </div>
          <div class="col-md-4">
            <!-- logo -->
            <g:if test="${fieldValue(bean: instance, field: 'logoRef') && fieldValue(bean: instance, field: 'logoRef.file')}">
                <section class="public-metadata">
                    <img class="institutionImage" src='${resource(absolute:"true", dir:"data/"+instance.urlForm()+"/",file:instance.logoRef.file)}' />
                </section>
            </g:if>
          </div>
        </div>
      </div><!--close header-->

      <div class="row">

      <div id="column-one" class="col-md-8">
      <div class="section">
        <g:if test="${instance.pubDescription}">
          <h2><g:message code="public.des" /></h2>
          <cl:formattedText>${fieldValue(bean: instance, field: "pubDescription")}</cl:formattedText>
          <cl:formattedText>${fieldValue(bean: instance, field: "techDescription")}</cl:formattedText>
        </g:if>
        <g:if test="${instance.focus}">
          <h2><g:message code="public.sdh.co.label02.param" args="${[grailsApplication.config.skin.orgNameShort]}" /></h2>
          <cl:formattedText>${fieldValue(bean: instance, field: "focus")}</cl:formattedText>
        </g:if>

        <h2><g:message code="public.sdh.co.label03" /></h2>
        <p>
          <span id="numBiocacheRecords"><g:message code="public.numbrs.des01" /></span> <g:message code="public.numbrs.des02" args="[orgNameLong]"/>.
          %{--<g:message code="public.sdh.co.des01" /> <span id="totalRecords"><g:message code="public.usage.des" />...</span> <g:message code="public.sdh.co.des03" />.--}%
            <a href="${grailsApplication.config.biocacheUiURL}/occurrences/search?q=data_hub_uid:${instance.uid}" class="btn btn-default"><g:message code="public.sdh.co.allrecords" /></a>
            %{--&nbsp;&nbsp;&nbsp;<button type=button id="showTimings">Show timings</button>--}%
        </p>
        <div id="charts" class="section vertical-charts">
        </div>

        <cl:lastUpdated date="${instance.lastUpdated}"/>

      </div><!--close section-->
    </div><!--close column-one-->
      <div id="column-two" class="col-md-4">
      <section class="section sidebar">
        <g:if test="${fieldValue(bean: instance, field: 'imageRef') && fieldValue(bean: instance, field: 'imageRef.file')}">
          <section class="public-metadata">
            <img alt="${fieldValue(bean: instance, field: "imageRef.file")}"
                    src="${resource(absolute:"true", dir:"data/"+instance.urlForm()+"/", file:instance.imageRef.file)}" />
            <cl:formattedText pClass="caption">${fieldValue(bean: instance, field: "imageRef.caption")}</cl:formattedText>
            <cl:valueOrOtherwise value="${instance.imageRef?.attribution}"><p class="caption">${fieldValue(bean: instance, field: "imageRef.attribution")}</p></cl:valueOrOtherwise>
            <cl:valueOrOtherwise value="${instance.imageRef?.copyright}"><p class="caption">${fieldValue(bean: instance, field: "imageRef.copyright")}</p></cl:valueOrOtherwise>
          </section>
        </g:if>

        <div id="dataAccessWrapper" style="display:none;">
          <g:render template="dataAccess" model="[instance:instance]"/>
        </div>

        <section class="public-metadata">
          <h4><g:message code="public.location" /></h4>
          <g:if test="${instance.address != null && !instance.address.isEmpty()}">
            <p>
              <cl:valueOrOtherwise value="${instance.address?.street}">${instance.address?.street}<br/></cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.city}">${instance.address?.city}<br/></cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.state}">${instance.address?.state}</cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.postcode}">${instance.address?.postcode}<br/></cl:valueOrOtherwise>
              <cl:valueOrOtherwise value="${instance.address?.country}">${instance.address?.country}<br/></cl:valueOrOtherwise>
            </p>
          </g:if>
          <g:if test="${instance.email}"><cl:emailLink>${fieldValue(bean: instance, field: "email")}</cl:emailLink><br/></g:if>
          <cl:ifNotBlank value='${fieldValue(bean: instance, field: "phone")}'/>
        </section>

        <!-- contacts -->
        <g:render template="contacts" bean="${instance.getPublicContactsPrimaryFirst()}"/>

        <!-- web site -->
        <g:if test="${instance.websiteUrl}">
          <section class="public-metadata">
            <h4><g:message code="public.website" /></h4>
            <div class="webSite">
              <a class='external_icon' target="_blank" href="${instance.websiteUrl}"><g:message code="public.sdh.ct.link01" /></a>
            </div>
          </section>
        </g:if>

        <!-- network membership -->
        <g:if test="${instance.networkMembership}">
          <section class="public-metadata">
            <h4><g:message code="public.network.membership.label" /></h4>
            <g:if test="${instance.isMemberOf('CHAEC')}">
              <p><g:message code="public.network.membership.des01" /></p>
              <img src="${resource(absolute:"true", dir:"data/network/",file:"butflyyl.gif")}"/>
            </g:if>
            <g:if test="${instance.isMemberOf('CHAH')}">
              <p><g:message code="public.network.membership.des02" /></p>
              <a target="_blank" href="http://www.chah.gov.au"><img src="${resource(absolute:"true", dir:"data/network/",file:"CHAH_logo_col_70px_white.gif")}"/></a>
            </g:if>
            <g:if test="${instance.isMemberOf('CHAFC')}">
              <p><g:message code="public.network.membership.des03" /></p>
            </g:if>
            <g:if test="${instance.isMemberOf('CHACM')}">
              <p><g:message code="public.network.membership.des04" /></p>
              <img src="${resource(absolute:"true", dir:"data/network/",file:"chacm.png")}"/>
            </g:if>
          </section>
        </g:if>
      </div>
    </div><!--close column-two-->
    </div>
  </div><!--close content-->
  <g:render template="charts" model="[facet:'data_hub_uid', instance: instance]" />
  </body>
</html>
