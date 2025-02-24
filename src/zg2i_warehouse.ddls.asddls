@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'warehouse'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZG2I_WAREHOUSE as select from zg2_warehouse
composition [0..*] of ZG2I_WAREHOUSE_ITEM as _wh_item
{
    key warehouse_code as WarehouseCode,
    warehouse_type as WarehouseType,
    warehouse_name as WarehouseName,
    warehouse_location as WarehouseLocation,
    warehouse_city as WarehouseCity,
    warehouse_state as WarehouseState,
    warehouse_region as WarehouseRegion,
    country as Country,
    warehouse_status as WarehouseStatus,
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
   _wh_item
}
