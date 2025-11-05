using { cuid, managed, Currency, Country } from '@sap/cds/common';

namespace sap.incidentmanagement;

// Status enum for incident lifecycle
type IncidentStatus : String enum {
  new        = 'NEW';
  assigned   = 'ASSIGNED'; 
  inProgress = 'IN_PROGRESS';
  resolved   = 'RESOLVED';
  closed     = 'CLOSED';
}

// Urgency levels
type UrgencyLevel : String enum {
  low      = 'LOW';
  medium   = 'MEDIUM';
  high     = 'HIGH';
  critical = 'CRITICAL';
}

// Main incident entity
entity Incidents : cuid, managed {
  title              : String(100) not null;
  description        : String(1000);
  status             : IncidentStatus default #new;
  urgency            : UrgencyLevel default #medium;
  businessPartner    : String(10); // Foreign key to BusinessPartner
  businessPartnerName : String(220); // Cached name for performance
  
  // Composition relationship to messages (conversation log)
  messages           : Composition of many Messages on messages.incident = $self;
}

// Messages entity for conversation log
entity Messages : cuid, managed {
  incident     : Association to Incidents not null;
  author       : String(100) not null;
  message      : String(2000) not null;
  timestamp    : Timestamp default $now;
}
