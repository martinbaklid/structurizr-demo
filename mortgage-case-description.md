# Case: Mortgage Application System

## 1. Context
A new and modern bank in Norway called DigitalFinTechyBank needs to create a new system providing customers (or prospect customers) the ability to apply for mortgaged loans. The following explains which systems needs to be hooked up. Both internal systems and systems from external vendors.

### 1.1 Credit Score and Property Valuation from Credit Karma
Credit Karma is an external company that provides a SOAP based service for Credit Scoring and an HTTPS/JSON (REST-ish) service for property Valuation.

### 1.2 Electronic signing from Signidog
Signidog is an external company that provides a service for sealing and electronically sign PDF documents. This old dog have trouble learning new tricks. So, PDF documents and signing-order metadata (xml) are sent and received over SFTP to a server on Signidogs side.

### 1.3 SMS Gateway from KnotMobility
Provides an SMS Gateway Service via HTTPS/JSON (REST-ish).

### 1.4 Core Foundation Banking Platform Framework Arena owned by the bank
DigitalFinTechyBank's most important system is the *Core Foundation Banking Platform Arena*. It is the arena where core and foundational services like loan accounts are implemented which creates a platform for creating omnipresent customer oriented value added services. The main interface with the banking platform is RabbitMQ.

### 1.5 Complex Archive (ComArch) owned by the bank
Archive for document. The complex archive has an HTTP interface accepts pdf documents and metadata as base64 encoded multipart/form-data.

## 2. Functional Requirements
1. Collect information directly from the applicant. Relevant information like address, phone number, debt, income and the property to be mortgaged needs to be collected directly from the applicant.
2. Check the applicant's credit karma, I mean credit score.
3. Check the valuation of the property to be mortgaged.
4. Make an automated credit decision based on the applicant's credit score, debt, income and the value of the property etc.
5. Notify the applicant about the credit decision, and loan activation with SMS.
6. Generate and enable the applicants to electronically sign the credit agreement PDF.
7. Archive the signed credit agreement in ComArch.
8. Create the loan account and register the collateral in the *Core Banking Platform Framework Arena*.

## 3. Non Functional Requirements
1. Performance
    - Most user request should be served within 1.0s. User interactions over 10 se  conds should be made asynchronously through notifications.
