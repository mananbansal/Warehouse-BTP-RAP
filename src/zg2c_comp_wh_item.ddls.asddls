@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'company warehouse item proj'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZG2C_COMP_WH_ITEM as projection on ZG2I_COMP_WH_ITEM
{
    key CompanyCode,
    key OrgCode,
    key WarehouseCode,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_WAREHOUSE_ITEM', element: 'ItemCode' },
    additionalBinding: [
            {
                localElement: 'WarehouseCode',
                element: 'WarehouseCode'
            }
        ] } ]
    key ItemCode,
    ItemName,
    ItemType,
    ItemCategory,
    ItemBrand,
    ItemModel,
    ItemDescription,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _cmp : redirected to parent ZG2C_COMP_WH
}
