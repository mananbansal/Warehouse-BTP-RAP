@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'orders detail CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZG2I_ORDERS_DTL as select from zg2_orders_dtl
association to parent ZG2I_ORDERS as _order on $projection.OrderId = _order.OrderId
{
    key order_id as OrderId,
    key item_code as ItemCode,
    item_name as ItemName,
    item_type as ItemType,
    item_category as ItemCategory,
    item_brand as ItemBrand,
    item_model as ItemModel,
    item_description as ItemDescription,
    unit as Unit,
     @Semantics.quantity.unitOfMeasure : 'unit'
    quantity as Quantity,
    currency as Currency,
    @Semantics.amount.currencyCode : 'Currency'
    unit_rate as UnitRate,
    sale_code as SaleCode,
    tax_code as TaxCode,
    amc_status as AmcStatus,
    amc_code as AmcCode,
    @Semantics.amount.currencyCode : 'Currency'
    price as Price,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed as LocalLastChanged,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed as LastChanged,
    @Semantics.systemDateTime.createdAt: true
    created_on as CreatedOn,
     @Semantics.user.createdBy: true
    creation_user as CreationUser,
     @Semantics.user.lastChangedBy: true
    changed_user as ChangedUser,
    _order
}
