sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"incidentmanagementasug/incidents/test/integration/pages/IncidentsList",
	"incidentmanagementasug/incidents/test/integration/pages/IncidentsObjectPage"
], function (JourneyRunner, IncidentsList, IncidentsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('incidentmanagementasug/incidents') + '/test/flpSandbox.html#incidentmanagementasugincident-tile',
        pages: {
			onTheIncidentsList: IncidentsList,
			onTheIncidentsObjectPage: IncidentsObjectPage
        },
        async: true
    });

    return runner;
});

