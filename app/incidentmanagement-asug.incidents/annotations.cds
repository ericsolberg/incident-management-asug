using IncidentService as service from '../../srv/incident-service';

// Add value help annotation for business partner field
annotate service.Incidents with {
    businessPartner @(
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'BusinessPartners',
            Label : 'Business Partners',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : businessPartner,
                    ValueListProperty : 'BusinessPartner'
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'BusinessPartnerFullName'
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'BusinessPartnerName'
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'BusinessPartnerCategory'
                }
            ]
        },
        Common.ValueListWithFixedValues : false,
        Common.Text : businessPartnerName,
        Common.TextArrangement : #TextFirst
    );
};

annotate service.Incidents with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'title',
                Value : title,
            },
            {
                $Type : 'UI.DataField',
                Label : 'description',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'status',
                Value : status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'urgency',
                Value : urgency,
            },
            {
                $Type : 'UI.DataField',
                Label : 'businessPartner',
                Value : businessPartner,
            },
            {
                $Type : 'UI.DataField',
                Label : 'businessPartnerName',
                Value : businessPartnerName,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'MessagesFacet',
            Label : 'Messages',
            Target : 'messages/@UI.LineItem',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'title',
            Value : title,
        },
        {
            $Type : 'UI.DataField',
            Label : 'description',
            Value : description,
        },
        {
            $Type : 'UI.DataField',
            Label : 'status',
            Value : status,
        },
        {
            $Type : 'UI.DataField',
            Label : 'urgency',
            Value : urgency,
            Criticality: {$edmJson: {$If: [
    {$Eq: [{$Path: 'urgency'}, 'CRITICAL']},
    1,
    {$If: [
        {$Eq: [{$Path: 'urgency'}, 'HIGH']},
        1,
        {$If: [
            {$Eq: [{$Path: 'urgency'}, 'MEDIUM']},
            2,
            {$If: [
                {$Eq: [{$Path: 'urgency'}, 'LOW']},
                3,
                0
            ]}
        ]}
    ]}
]}},
            CriticalityRepresentation : #WithIcon,
        },
        {
            $Type : 'UI.DataField',
            Label : 'businessPartner',
            Value : businessPartner,
        },
    ],
);

annotate service.Messages with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Author',
            Value : author,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Message',
            Value : message,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Timestamp',
            Value : timestamp,
        },
    ],
    UI.HeaderInfo : {
        $Type : 'UI.HeaderInfoType',
        TypeName : 'Message',
        TypeNamePlural : 'Messages',
        Title : {
            $Type : 'UI.DataField',
            Value : author,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : message,
        },
    },
);
