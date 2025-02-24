@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Method value help'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZG2I_COMMENT_TYPE as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZG2_COMMENT_TYPE' )
{
   key domain_name,
   key value_position,
   key language,
   value_low as Value,
   @Semantics.text: true
   text as Description
}
