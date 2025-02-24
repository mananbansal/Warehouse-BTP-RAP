@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'company projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZG2C_COMPANY as projection on ZG2I_COMPANY
{
    key CompanyCode,
    key OrgCode,
    CompanyName,
    OrgLocation,
    OrgCity,
    OrgState,
    Country,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _emp : redirected to composition child ZG2C_CMP_EMP
}
