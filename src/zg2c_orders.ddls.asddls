@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'orders proj'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZG2C_ORDERS as projection on ZG2I_ORDERS
{
    key OrderId,
    
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_COMPANY', element: 'CompanyCode' } } ]
    CompanyCode,
    
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_COMPANY', element: 'OrgCode' },
    additionalBinding: [
            {
                localElement: 'CompanyCode',
                element: 'CompanyCode'
            }
        ] } ]
    OrgCode,
    
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_CMP_EMP', element: 'EmployeeCode' },
    additionalBinding: [
            {
                localElement: 'OrgCode',
                element: 'OrgCode'
            },
            {
                localElement: 'CompanyCode',
                element: 'CompanyCode'
            }
        ] } ]
    EmployeeId,
    
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_COMP_WH', element: 'WarehouseCode' },
    additionalBinding: [
            {
                localElement: 'OrgCode',
                element: 'OrgCode'
            }
        ] } ]
    WarehouseCode,
    OrderDate,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_ORDER_STATUS', element: 'Value' } } ]
    OrderStatus,
    Currency,
    @Semantics.amount.currencyCode : 'Currency'
    OrderAmount,    
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_PG_PAYMENTMETHOD', element: 'Value' } } ]
    PaymentMethod,
    OrderNote,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    /* Associations */
    _dtl : redirected to composition child ZG2C_ORDERS_DTL,
    _cmt : redirected to composition child ZG2C_WH_COMMENTS
}
