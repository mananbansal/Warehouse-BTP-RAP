CLASS lhc_zg2i_warehouse_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS ItemDetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZG2I_WAREHOUSE_ITEM~ItemDetails.

ENDCLASS.

CLASS lhc_zg2i_warehouse_item IMPLEMENTATION.

  METHOD ItemDetails.


  READ ENTITIES OF ZG2I_WAREHOUSE IN LOCAL MODE
  ENTITY ZG2I_WAREHOUSE_ITEM
  FIELDS ( ItemCode ) with VALUE #( for key IN keys
                                            ( %key = key-%key
                                              %control = value #( ItemCode = if_abap_behv=>mk-on )
                                            )
                                  )
  RESULT DATA(lt_ItemCode).

  LOOP AT lt_ItemCode ASSIGNING FIELD-SYMBOL(<fs_item>).
  ENDLOOP.

  select single * from zg2_wh_products where product_id = @<fs_item>-ItemCode into @data(itemDetail).


  MODIFY ENTITIES OF ZG2I_WAREHOUSE in LOCAL MODE
  ENTITY ZG2I_WAREHOUSE_ITEM
  UPDATE FIELDS ( ItemName ItemType ItemCategory ItemBrand ItemModel ItemDescription
                  Unit Currency UnitRate TaxCode AmcStatus )
  with value #( for result in lt_ItemCode index into i
               (
               %key = keys[ i ]-%key
                        ItemName = itemDetail-product_name
                        ItemType = itemDetail-product_type
                        ItemCategory = itemDetail-product_category
                        ItemBrand = itemDetail-product_brand
                        ItemModel = itemDetail-product_model
                        ItemDescription = itemDetail-product_description
                        Unit = itemDetail-unit
                        Currency = itemDetail-currency
                        UnitRate = itemDetail-unit_rate
                        TaxCode = itemDetail-tax_code
                        AmcStatus = itemDetail-amc_status
                 )
              )
              REPORTED DATA(lt_rpt)
              FAILED Data(lt_fld)
              Mapped DATA(lt_mpd).



  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZG2I_WAREHOUSE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zg2i_warehouse RESULT result.

ENDCLASS.

CLASS lhc_ZG2I_WAREHOUSE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
