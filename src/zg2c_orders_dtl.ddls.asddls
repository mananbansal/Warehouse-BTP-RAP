@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'orders detail proj'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZG2C_ORDERS_DTL as projection on ZG2I_ORDERS_DTL
{
    key OrderId,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_COMP_WH_ITEM', element: 'ItemCode' },
    
     additionalBinding: [
            {
                localElement: '_order.WarehouseCode',
                element: 'WarehouseCode'
            },
            {
                localElement: '_order.OrgCode',
                element: 'OrgCode'
            },
            {
                localElement: '_order.CompanyCode',
                element: 'CompanyCode'
            }
        ] } ]
   
    key ItemCode,
    ItemName,
    ItemType,
    ItemCategory,
    ItemBrand,
    ItemModel,
    ItemDescription,
    Unit,
    @Semantics.quantity.unitOfMeasure : 'unit'
    Quantity,
    Currency,
    @Semantics.amount.currencyCode : 'Currency'
    UnitRate,
    SaleCode,
    TaxCode,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_STATUS', element: 'Value' } } ]
    AmcStatus,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_AMC_CODE', element: 'Value' } } ]
    AmcCode,
    @Semantics.amount.currencyCode : 'Currency'
    Price,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    _order : redirected to parent ZG2C_ORDERS
}
