const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {

    const { Incidents, BusinessPartners } = this.entities;

    // Helper function to lookup business partner name
    const lookupBusinessPartnerName = async (businessPartnerID) => {
        if (!businessPartnerID) return null;
        
        try {
            const bp = await SELECT.one.from(BusinessPartners)
                .columns('BusinessPartnerFullName')
                .where({ BusinessPartner: businessPartnerID });
            
            return bp ? bp.BusinessPartnerFullName : null;
        } catch (error) {
            console.error('Error looking up business partner:', error);
            return null;
        }
    };

    // Before CREATE: Set urgency to HIGH if title contains "urgent" and lookup business partner name
    this.before('CREATE', Incidents, async (req) => {
        const incident = req.data;
        
        if (incident.title && incident.title.toLowerCase().includes('urgent')) {
            incident.urgency = 'HIGH';
        }

        // Lookup business partner name if business partner is provided
        if (incident.businessPartner) {
            const businessPartnerName = await lookupBusinessPartnerName(incident.businessPartner);
            if (businessPartnerName) {
                incident.businessPartnerName = businessPartnerName;
            }
        }
    });

    // Before UPDATE/PATCH: Set urgency to HIGH if title contains "urgent" and lookup business partner name
    this.before(['UPDATE', 'PATCH'], Incidents, async (req) => {
        const incident = req.data;
        
        if (incident.title && incident.title.toLowerCase().includes('urgent')) {
            incident.urgency = 'HIGH';
        }

        // Lookup business partner name if business partner is provided
        if (incident.businessPartner) {
            const businessPartnerName = await lookupBusinessPartnerName(incident.businessPartner);
            if (businessPartnerName) {
                incident.businessPartnerName = businessPartnerName;
            }
        }
    });

    // Before UPDATE/PATCH: Prevent modification of closed incidents
    this.before(['UPDATE', 'PATCH'], Incidents, async (req) => {
        const { ID } = req.data;
        
        if (ID) {
            const currentIncident = await SELECT.one.from(Incidents).where({ ID });
            
            if (currentIncident && currentIncident.status === 'CLOSED') {
                req.error(400, 'Cannot modify a closed incident', 'INCIDENT_CLOSED');
            }
        }
    });

    // Before SAVE (for draft scenarios): Apply the same rules
    this.before('SAVE', Incidents, async (req) => {
        const incident = req.data;
        
        if (incident.title && incident.title.toLowerCase().includes('urgent')) {
            incident.urgency = 'HIGH';
        }

        // Lookup business partner name if business partner is provided
        if (incident.businessPartner) {
            const businessPartnerName = await lookupBusinessPartnerName(incident.businessPartner);
            if (businessPartnerName) {
                incident.businessPartnerName = businessPartnerName;
            }
        }
        
        if (incident.ID) {
            const currentIncident = await SELECT.one.from(Incidents).where({ ID: incident.ID });
            
            if (currentIncident && currentIncident.status === 'CLOSED') {
                req.error(400, 'Cannot modify a closed incident', 'INCIDENT_CLOSED');
            }
        }
    });

    // Custom action: Assign incident to business partner
    this.on('assignToBusinessPartner', Incidents, async (req) => {
        const { ID } = req.params[0];
        const { businessPartnerID } = req.data;
        
        const incident = await SELECT.one.from(Incidents).where({ ID });
        if (incident && incident.status === 'CLOSED') {
            req.error(400, 'Cannot assign a closed incident', 'INCIDENT_CLOSED');
        }

        // Lookup business partner name
        const businessPartnerName = await lookupBusinessPartnerName(businessPartnerID);
        
        await UPDATE(Incidents).set({
            businessPartner: businessPartnerID,
            businessPartnerName: businessPartnerName,
            status: 'ASSIGNED'
        }).where({ ID });
        
        return await SELECT.one.from(Incidents).where({ ID });
    });

    // Custom action: Add message to incident
    this.on('addMessage', Incidents, async (req) => {
        const { ID } = req.params[0];
        const { author, message } = req.data;
        
        const incident = await SELECT.one.from(Incidents).where({ ID });
        if (incident && incident.status === 'CLOSED') {
            req.error(400, 'Cannot add messages to a closed incident', 'INCIDENT_CLOSED');
        }
        
        const { Messages } = this.entities;
        await INSERT.into(Messages).entries({
            incident_ID: ID,
            author: author,
            message: message,
            timestamp: new Date().toISOString()
        });
        
        return await SELECT.one.from(Incidents).where({ ID });
    });

});
