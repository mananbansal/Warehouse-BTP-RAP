@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'company warehouse item cds'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZG2I_COMP_WH_ITEM as select from zg2_comp_wh_item
association to parent ZG2I_COMP_WH as _cmp on $projection.CompanyCode = _cmp.CompanyCode
                                          and $projection.OrgCode = _cmp.OrgCode
                                          and $projection.WarehouseCode = _cmp.WarehouseCode
{
    key company_code as CompanyCode,
    key org_code as OrgCode,
    key warehouse_code as WarehouseCode,
    key item_code as ItemCode,
    item_name as ItemName,
    item_type as ItemType,
    item_category as ItemCategory,
    item_brand as ItemBrand,
    item_model as ItemModel,
    item_description as ItemDescription,
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
    _cmp
}
