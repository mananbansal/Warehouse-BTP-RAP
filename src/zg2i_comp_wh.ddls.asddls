@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'company warehouse cds'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZG2I_COMP_WH as select from zg2_comp_wh
composition [0..*] of ZG2I_COMP_WH_ITEM as _item
{
    key company_code as CompanyCode,
    key org_code as OrgCode,
    key warehouse_code as WarehouseCode,
    company_name as CompanyName,
    warehouse_location as WarehouseLocation,
    warehouse_city as WarehouseCity,
    warehouse_state as WarehouseState,
    country as Country,
    org_location as OrgLocation,
    org_city as OrgCity,
    org_state as OrgState,
    org_contact_person as OrgContactPerson,
    org_contact_email as OrgContactEmail,
    org_contact_phone as OrgContactPhone,
    org_status as OrgStatus,
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
    _item // Make association public
}
