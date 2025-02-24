@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'orders CSD'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZG2I_ORDERS as select from zg2_orders
composition [0..*] of ZG2I_ORDERS_DTL as _dtl
composition [0..*] of ZG2I_WH_COMMENTS as _cmt
{
    key order_id as OrderId,
    employee_id as EmployeeId,
    company_code as CompanyCode,
    org_code as OrgCode,
    warehouse_code as WarehouseCode,
    order_date as OrderDate,
    order_status as OrderStatus,
    currency as Currency,
    @Semantics.amount.currencyCode : 'Currency'
    order_amount as OrderAmount,
    payment_method as PaymentMethod,
    order_note as OrderNote,
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
    _dtl,
    _cmt
}
