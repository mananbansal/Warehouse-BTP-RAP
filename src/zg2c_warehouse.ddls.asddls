@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'warehouse proj'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZG2C_WAREHOUSE as projection on ZG2I_WAREHOUSE
{
    key WarehouseCode,
    WarehouseType,
    WarehouseName,
    WarehouseLocation,
    WarehouseCity,
    WarehouseState,
    WarehouseRegion,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'I_CurrencyStdVh', element: 'Currency' } } ]
    Country,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_ORG_STATUS', element: 'Value' } } ]
    WarehouseStatus,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _wh_item : redirected to composition child ZG2C_WAREHOUSE_ITEM
}
