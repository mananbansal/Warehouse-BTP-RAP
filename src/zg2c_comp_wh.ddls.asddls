@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'company warehouse proj'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZG2C_COMP_WH as projection on ZG2I_COMP_WH
{
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_COMPANY', element: 'CompanyCode' } } ]
    key CompanyCode,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_COMPANY', element: 'OrgCode' },
     additionalBinding: [
            {
                localElement: 'CompanyCode',
                element: 'CompanyCode'
            }
        ]} ]
    key OrgCode,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_WAREHOUSE', element: 'WarehouseCode' } } ]
    key WarehouseCode,
    CompanyName,
    WarehouseLocation,
    WarehouseCity,
    WarehouseState,
    Country,
    OrgLocation,
    OrgCity,
    OrgState,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_ORG_STATUS', element: 'Value' } } ]
    OrgStatus,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _item : redirected to composition child ZG2C_COMP_WH_ITEM
}
