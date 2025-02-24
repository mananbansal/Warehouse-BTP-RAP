@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Comments CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZG2I_WH_COMMENTS as select from zg2_wh_comments
association to parent ZG2I_ORDERS as _order on $projection.OrderId = _order.OrderId
{
    key order_id as OrderId,
    item_code as ItemCode,
    item_name as ItemName,
    warehouse_comment_type as WarehouseCommentType,
    warehouse_comment as WarehouseComment,
    customer_comment_type as CustomerCommentType,
    customer_comment as CustomerComment,
    comment_created_on as CommentCreatedOn,
    local_last_changed as LocalLastChanged,
    last_changed as LastChanged,
    created_on as CreatedOn,
    creation_user as CreationUser,
    changed_user as ChangedUser,
    _order
}
