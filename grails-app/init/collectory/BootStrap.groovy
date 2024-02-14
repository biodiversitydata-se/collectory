package collectory

class BootStrap {
    def messageSource
    def application
    def grailsApplication

    def init = { servletContext ->
        messageSource.setBasenames(
                "file:///var/opt/atlas/i18n/collectory-plugin/messages",
                "file:///opt/atlas/i18n/collectory-plugin/messages",
                "WEB-INF/grails-app/i18n/messages",
                "classpath:messages",
                "${application.config.biocacheServicesUrl}/facets/i18n"
        )

        // gbifDefaultEntityCountry is mandatory. Not validating this value as 'ZZZ'
        if (!grailsApplication.config.gbifDefaultEntityCountry) {
            throw new MissingPropertyException("config `gbifDefaultEntityCountry` is not defined")
        }
    }
    def destroy = {
    }
}
