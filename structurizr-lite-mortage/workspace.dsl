workspace {
    # !docs docs 

    # TODO Fix docs
    model {
        impliedRelationships true

        Applicant = person "Applicant" "Might be a customer or a prospect customer"
        enterprise "DigitalFinTechyBank" {
            MortgagePortal = softwareSystem "Mortgage Portal" "Allows applicants to fill in mortgage applications and apply for loan" {
                MortgageApplicationForm = container "Mortgage Application Form" "Application Form which guides the applicants through all the steps for the loan application" "Vue.JS" {
                    tags WebApp 
                }
                MortgageApi = container "Mortgage Application API" "Provides API for applying for loans" "Spring MVC Tomcat" {
                    MortgageApplicationController = component "Mortgage Application Controller" "Provides endpoints for creating, updating and submitting an loan application" "Spring MVC Controller"
                    MortgageApplicationService = component "Mortgage Application Service" "Orchistrates the flow of the application" "Spring Component" {
                        MortgageApplicationController -> this "creates, updates, and submits applications using"
                    }
                    DocumentComponent = component "Document Component" "Handles the document signing and archiving flow" "Spring Beans and Quartz Job" { 
                        MortgageApplicationService -> this "sends mortgage agreement document for signing and archinving"
                        this -> MortgageApplicationService "sends notification about signend and archived document to"
                    }
                    CreditDecisionEngine = component "Credit Decision Engine" "Holds the business rules for making an credit decison" "Drools" {
                        MortgageApplicationService -> this "delegates credit decison to"
                    }
                    AgreementPDFGenerator = component "Agreement PDF Generator" "Generates PDF based on HTML CSS template." "Flying Saucer PDF Rendering" {
                        MortgageApplicationService -> this "generates Agreement PDF with"
                    }
                    CreditScoringClient = component "Credit Scoring Component" "Component for scoring applicants" "Spring Bean" {
                        MortgageApplicationService -> this "get credit score for applicant from"
                    }
                    CoreBankingClient = component "Core Banking Component" "Component for creating loan accounts and register collateral" "Spring Bean" {
                        MortgageApplicationService -> this "create mortgage loan account and register collateral for mortgage"
                    }
                    NotificationClient = component "Notification Client" "Sends notifications to applicants via SMS" "Feign Client" {
                        MortgageApplicationService -> this "sends sms to applicant about decision and esigning link using"
                    }
                    MortgageApplicationRepository = component "Mortgage Application Repository" "Provides persistance for loan applications" "Spring JPA Repository" {
                        MortgageApplicationService -> this "persists applications using"
                    }
                    DocumentRepository = component "Document Repository" "Provides presistance document signing flow" "Spring JPA Repository" {
                        DocumentComponent -> this "persists metadata about documents pending signing using"
                    }
                }

                MortgageDatabase = container "Mortgage Application Database" "Stores loan applications, document metadata and Quartz sycronization data" "SQLServer 2019" {
                    tags Database
                    MortgageApplicationRepository -> this "writes applications to and reads them from" "JDBC"
                    DocumentRepository -> this "writes and reads metadata about documents pending siging"
                    DocumentComponent -> this "write and reads quartz syncronisation data" "JDBC"
                }
            }
            ComArch = softwareSystem "Complex Archive (ComArch)" "Provides an archive for important documents" ExternalSystem
            CoreBanking = softwareSystem "Core Foundation Banking Platform Arena" "Provides core banking services like loan accounts" ExternalSystem
        }
        CreditKarma = softwareSystem "Credit Karma" "Provides credit scoring of norwegian citizens and property valuation" ExternalCompany
        SigningDog = softwareSystem "SigningDog" "Provides electronic signing" ExternalCompany 
        KnotMobility = softwareSystem "Knot Mobility" "Provides a REST API for sending sms" ExternalCompany


        Applicant -> MortgageApplicationForm "Fills in personal and property information" 

        MortgageApplicationForm -> MortgageApplicationController "creates, updates and submits loan application" "HTTPS/JSON"
        CreditScoringClient -> CreditKarma "scores and applicant using" "SOAP"
        NotificationClient -> KnotMobility "notifies applicant about decision and send esigning link using" "HTTPS/JSON"
        CoreBankingClient -> CoreBanking "creates loan account and registrers collateral in" "AMQP"
        DocumentComponent -> SigningDog "checks for newly signed documents at" "SFTP"
        DocumentComponent -> ComArch "stores signed documents in" "HTTPS/multipart form data (Base64 encoding)"

        KnotMobility -> Applicant "notifies applicant about decision and send esigning link using"  
    }

    views {
        systemContext MortgagePortal "MortgagePortalContext" {
            include *
        }

        container MortgagePortal "MortgagePortalContainer" {
            include *
        }

        container MortgagePortal "MortgagePortalContainerWithoutExternal" {
            include *
            exclude element.tag==ExternalSystem element.tag==ExternalCompany
        }

        component MortgageApi "MortgageApiComponent" {
            include *
        }

        theme default
        styles {
            element ExternalSystem {
                background #DDDDDD
                color #222222   
            }
            element ExternalCompany {
                background #BB6655
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
