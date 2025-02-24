@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'products CDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZG2I_WH_PRODUCTS as select from zg2_wh_products
{
    key product_id as ProductId,
    product_name as ProductName,
    product_description as ProductDescription,
    product_category as ProductCategory,
    product_type as ProductType,
    product_brand as ProductBrand,
    product_model as ProductModel,
    unit as Unit,
    currency as Currency,
    @Semantics.amount.currencyCode : 'currency'
    unit_rate as UnitRate,
    sale_code as SaleCode,
    tax_code as TaxCode,
    validity as Validity,
    product_status as ProductStatus,
    amc_status as AmcStatus,
    amc_code as AmcCode,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed as LocalLastChanged,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed as LastChanged,
    @Semantics.systemDateTime.createdAt: true
    created_on as CreatedOn,
     @Semantics.user.createdBy: true
    creation_user as CreationUser,
     @Semantics.user.lastChangedBy: true
    changed_user as ChangedUser
}
