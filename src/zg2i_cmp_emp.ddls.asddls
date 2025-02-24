@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'company employee cds'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZG2I_CMP_EMP as select from zg2_cmp_emp
association to parent ZG2I_COMPANY as _cmp on $projection.CompanyCode = _cmp.CompanyCode
and $projection.OrgCode = _cmp.OrgCode
{
    key company_code as CompanyCode,
    key employee_code as EmployeeCode,
    key org_code as OrgCode,
    employee_name as EmployeeName,
    employee_city as EmployeeCity,
    employee_dob as EmployeeDob,
    employee_doj as EmployeeDoj,
    employee_status as EmployeeStatus,
    employee_username as EmployeeUsername,
    employee_designation as EmployeeDesignation,
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
