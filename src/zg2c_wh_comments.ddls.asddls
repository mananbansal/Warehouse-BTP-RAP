@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Comments proj'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZG2C_WH_COMMENTS as projection on ZG2I_WH_COMMENTS
{
    key OrderId,
    ItemCode,
    ItemName,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_COMMENT_TYPE', element: 'Value' } } ]
    WarehouseCommentType,
    WarehouseComment,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_COMMENT_TYPE', element: 'Value' } } ]
    CustomerCommentType,
    CustomerComment,
    CommentCreatedOn,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser,
    _order: redirected to parent ZG2C_ORDERS
}
