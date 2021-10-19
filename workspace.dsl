workspace {
    !docs docs

    model {
        impliedRelationships true
        

        User = person "Applicant" "Might be a customer or a prospect customer"
        
        MortgagePortal = softwareSystem "Mortgage Portal" "Allows applicants to fill in mortage applications and apply for loan" {
            MortgageApplicationForm = container "Mortgage Application Form" "Appication Form which guides the applicant throught all the steps for the loan applications" "Vue.JS" {
                tags WebApp 
            }
            MortgageApi = container "Mortgage Application API" "Provides API for applying for loans" "Spring MVC Tomcat" {
                MortgageApplicationController = component "Mortgage Application Controller" "Provides endpoints for creating, updating and submitting an loan application" "Spring MVC Controller" {
                    MortgageApplicationForm -> this "Submits loan application for processing"
                }
                MortgageApplicationService = component "Mortgage Application Service" "Controlls the flow of the applicaton" "Spring Component" {
                    MortgageApplicationController -> this "Creates, updates, and submits applications using"
                }
                MortgageApplicationRepository = component "Mortgage Application Repository" "Provides persistance for loan applications" "Spring JPA Repossitory" {
                    MortgageApplicationService -> this "Persists applications using"
                }
                CreditFacade = component "Credit Facade" "Provides an facade for credit scoring and decision" "Java Package" {
                    MortgageApplicationService -> this "Scores applicants and makes decisions using"
                }
                NotificationClient = component "Notification Client" "Provides notification features" "Java Package" {
                    MortgageApplicationService -> this "Sends notifications to customers using"
                }
            }
            MortgageDatabase = container "Mortgage Application Database" "Stores Incomplete Loan Applications" "SQLServer 2019" {
                tags Database
                MortgageApplicationRepository -> this "Writes applications to and reads them from" "JSON/HTTPS"
            }
        }
        
        CreditScoringSystem = softwareSystem "Credit Scoring System" "Scores an applicant" ExternalSystem
        CreditRuleSystem = softwareSystem "Credit Rule System" "Approves or rejects an application" ExternalSystem
        SmsGateway = softwareSystem "SMS Gateway" "Provides a REST API for sending sms" ExternalSystem

        User -> MortgageApplicationForm "Fills in personal and economic info"

        MortgageApplicationForm -> MortgageApi "Submits loan application for processing" "JSON/HTTPS"
        CreditClient -> CreditScoringSystem "Scores and applicant using" "SOAP"
        CreditClient -> CreditRuleSystem "Makes an decision using" "gRPC"
        NotificationClient -> SmsGateway "Sends sms notficatications to customers using" "JSON/HTTPS"
    }

    views {
        systemContext MortgagePortal "MortgagePortalContext" {
            include *
            autoLayout
        }

        container MortgagePortal "MortgagePortalContainer" {
            include *
            autoLayout
        }

        component MortgageApi "MortgageApiComponent" {
            include *
            autoLayout
        }
        theme default
        styles {
            element ExternalSystem {
                background #DDDDDD
                color #222222   
            }
            element WebApp {
                shape WebBrowser
            }

            element Database {
                shape Cylinder
            }
        }
    }

}