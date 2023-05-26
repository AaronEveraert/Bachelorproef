using my.Tickets as my from '../db/data-model';


service ReportService {
    entity Tickets  as projection on my.Tickets;    
}

annotate ReportService.Tickets with @(
    UI: {
        HeaderInfo: {
            TypeName: 'Ticket',
            TypeNamePlural: 'Tickets',
            Title: { Value: ID },
            Description: { Value: title }
        },
        SelectionFields: [ ID, title ],
        LineItem: [
            { Value: ID },
            { Value: title },
            { Value: name },
            { Value: status },
            { Value: email }               
        ],
        Facets: [
            {
                $Type: 'UI.CollectionFacet',
                Label: 'Book Info',
                Facets: [
                    {$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Main', Label: 'Main Facet'}
                ]
            }
        ],        
        FieldGroup#Main: {
            Data: [
                { Value: ID },
                { Value: title },
                { Value: description },
                { Value: name },
                { Value: email }               
            ]
        }
    }
);