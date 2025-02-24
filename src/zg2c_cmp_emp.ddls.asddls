@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'company employee projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZG2C_CMP_EMP as projection on ZG2I_CMP_EMP
{
    key CompanyCode,
    key EmployeeCode,
    key OrgCode,
    EmployeeName,
    EmployeeCity,
    EmployeeDob,
    EmployeeDoj,
    EmployeeStatus,
    EmployeeDesignation,
    EmployeeUsername,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _cmp : redirected to parent ZG2C_COMPANY
}
