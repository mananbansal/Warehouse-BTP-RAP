@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection for products'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZG2C_WH_PRODUCTS as projection on ZG2I_WH_PRODUCTS
{
    key ProductId,
    ProductName,
    ProductDescription,
    ProductCategory,
    ProductType,
    ProductBrand,
    ProductModel,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'I_UnitOfMeasureStdVh', element: 'UnitOfMeasure' } } ]
    Unit,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'I_CurrencyStdVh', element: 'Currency' } } ]
    Currency,
    @Semantics.amount.currencyCode : 'Currency'
    UnitRate,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_TAXCODE', element: 'Value' } } ]
    TaxCode,
    Validity,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG21_PRODUCT_STATUS', element: 'Value' } } ]
    ProductStatus,
    AmcStatus,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'ZG2I_AMC_CODE', element: 'Value' } } ]
    AmcCode,
    LocalLastChanged,
    LastChanged,
    CreatedOn,
    CreationUser,
    ChangedUser
}
