@EndUserText.label: 'Ticket'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity ZC_TICKET as projection on ZI_Ticket
{
    key TicketId,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Title'
    Title,
    @EndUserText.label: 'Description'
    Description,
    @EndUserText.label: 'Type'
    @Consumption.valueHelpDefinition: [{  entity: {   name: 'ZI_TYPE' ,
                                                          element: 'Type'  }     }]
    Type,
    @EndUserText.label: 'Status'
     @Consumption.valueHelpDefinition: [{  entity: {   name: 'ZI_STATUS' ,
                                                          element: 'Status'  }     }]
    Status,
    @EndUserText.label: 'Name'
    Name,
    @EndUserText.label: 'Contact Email'
    ContactEmail,
    CreatedBy,
    @EndUserText.label: 'Created At'
    CreatedAt,
   
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
