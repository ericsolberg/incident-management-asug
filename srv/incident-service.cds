using { sap.incidentmanagement as my } from '../db/schema';
using API_BUSINESS_PARTNER_CC7 from './external/API_BUSINESS_PARTNER_CC7';

service IncidentService @(path: '/incident') {
  
  // Draft-enabled incidents entity
  @odata.draft.enabled
  entity Incidents as projection on my.Incidents {
    *,
    // Virtual association to BusinessPartner for navigation
    businessPartnerDetails : Association to BusinessPartners on businessPartnerDetails.BusinessPartner = businessPartner
  } actions {
    // Custom action to assign incident to a business partner
    action assignToBusinessPartner(businessPartnerID: String(10)) returns Incidents;
    // Custom action to add a message to the conversation log
    action addMessage(author: String(100), message: String(2000)) returns Incidents;
  };
  
  // Messages entity (accessible via composition from Incidents)
  entity Messages as projection on my.Messages;
  
  // Read-only BusinessPartners from external service
  @readonly 
  entity BusinessPartners as projection on API_BUSINESS_PARTNER_CC7.A_BusinessPartner {
    key BusinessPartner,
    BusinessPartnerFullName,
    BusinessPartnerName,
    BusinessPartnerCategory,
    CreationDate
  };
  
}
