@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'warehouse item proj'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZG2C_WAREHOUSE_ITEM as projection on ZG2I_WAREHOUSE_ITEM
{
    key WarehouseCode,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_WH_PRODUCTS', element: 'ProductId' } } ]
    key ItemCode,
    ItemName,
    ItemType,
    ItemCategory,
    ItemBrand,
    ItemModel,
    ItemDescription,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'I_UnitOfMeasureStdVh', element: 'UnitOfMeasure' } } ]
    Unit,
    @Semantics.quantity.unitOfMeasure : 'unit'
    Quantity,
    ContFlag,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'I_CurrencyStdVh', element: 'Currency' } } ]
    Currency,
    @Semantics.amount.currencyCode : 'currency'
    UnitRate,
    SaleCode,
    TaxCode,
    AmcStatus,
    AmcCode,
    Validity,
    ItemStatus,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _warehouse : redirected to parent ZG2C_WAREHOUSE
}
