CLASS lhc_zg2i_orders_dtl DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.
    CLASS-METHODS calculatePrice
      IMPORTING UnitRate      TYPE zg2_rate
                SaleCode      TYPE zg2_sale_code
                AmcCode       TYPE zg2_amc_code
                Quantity      TYPE zg2_quantity
                TaxCode       TYPE zg2_tax_code
      RETURNING VALUE(result) TYPE zg2_rate.

  PRIVATE SECTION.

    METHODS itemDetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zg2i_orders_dtl~itemDetails.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zg2i_orders_dtl RESULT result.

    METHODS removeTax FOR MODIFY
      IMPORTING keys FOR ACTION zg2i_orders_dtl~removeTax RESULT result.
    METHODS checkAvailable FOR MODIFY
      IMPORTING keys FOR ACTION zg2i_orders_dtl~checkAvailable RESULT result.

ENDCLASS.

CLASS lhc_zg2i_orders_dtl IMPLEMENTATION.

  METHOD calculatePrice.

    result = ( ( ( UnitRate - ( UnitRate * ( SaleCode / 100 ) ) )
             + ( ( UnitRate - ( UnitRate * ( SaleCode / 100 ) ) ) * ( TaxCode / 100 ) ) ) * Quantity )
             + ( ( UnitRate - ( UnitRate * ( SaleCode / 100 ) ) ) * ( AmcCode / 100 ) ).
  ENDMETHOD.

  METHOD itemDetails.

    READ ENTITIES OF zg2i_orders IN LOCAL MODE
   ENTITY zg2i_orders_dtl
   FIELDS ( ItemCode ) WITH VALUE #( FOR key IN keys
                                             ( %key = key-%key
                                               %control = VALUE #( ItemCode = if_abap_behv=>mk-on )
                                             )
                                   )
   RESULT DATA(lt_ItemCode).

    LOOP AT lt_ItemCode ASSIGNING FIELD-SYMBOL(<fs_item>).
    ENDLOOP.

    SELECT SINGLE * FROM zg2i_warehouse_item
    WHERE ItemCode = @<fs_item>-ItemCode
    INTO @DATA(itemDetail).

    DATA: lv_UnitRate TYPE zg2_rate,
          lv_SaleCode TYPE zg2_sale_code,
          lv_AmcCode  TYPE zg2_amc_code,
          lv_Quantity TYPE zg2_quantity,
          lv_TaxCode  TYPE zg2_tax_code.

    lv_UnitRate = itemDetail-UnitRate.
    lv_SaleCode = itemDetail-SaleCode.
    lv_AmcCode = <fs_item>-AmcCode.
    lv_Quantity = <fs_item>-Quantity.
    lv_TaxCode = itemDetail-TaxCode.

    DATA(lv_Price) = lhc_zg2i_orders_dtl=>calculatePrice(
      EXPORTING
        UnitRate = lv_UnitRate
        SaleCode = lv_SaleCode
        AmcCode  = lv_AmcCode
        Quantity = lv_Quantity
        taxcode = lv_TaxCode ).


    MODIFY ENTITIES OF zg2i_orders IN LOCAL MODE
    ENTITY zg2i_orders_dtl
    UPDATE FIELDS ( ItemName ItemType ItemCategory ItemBrand ItemModel ItemDescription Unit
                          Currency UnitRate SaleCode TaxCode Price )
    WITH VALUE #( FOR result IN lt_ItemCode INDEX INTO i
                 (
                 %key = keys[ i ]-%key
                          ItemName = itemDetail-ItemName
                          ItemType = itemDetail-ItemType
                          ItemCategory = itemDetail-ItemCategory
                          ItemBrand = itemDetail-ItemBrand
                          ItemModel = itemDetail-ItemModel
                          ItemDescription = itemDetail-ItemDescription
                          Unit = itemDetail-unit
                          Currency = itemDetail-currency
                          UnitRate = itemDetail-UnitRate
                          TaxCode = itemDetail-TaxCode
                          SaleCode = itemDetail-SaleCode
                          Price = lv_Price
                  )
                )
                REPORTED DATA(lt_rpt)
                FAILED DATA(lt_fld)
                MAPPED DATA(lt_mpd).

  ENDMETHOD.


  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD removeTax.

    READ ENTITIES OF zg2i_orders IN LOCAL MODE
   ENTITY zg2i_orders_dtl
   ALL FIELDS  WITH VALUE #( FOR key IN keys
                                             ( %key = key-%key
                                               %control = VALUE #( ItemCode = if_abap_behv=>mk-on )
                                             )
                                   )
   RESULT DATA(lt_Item).

    LOOP AT lt_Item ASSIGNING FIELD-SYMBOL(<fs_item>).
    ENDLOOP.

    DATA(lv_Price) = lhc_zg2i_orders_dtl=>calculatePrice(
      EXPORTING
        UnitRate = <fs_item>-UnitRate
        SaleCode = <fs_item>-SaleCode
        AmcCode  = <fs_item>-AmcCode
        Quantity = <fs_item>-Quantity
        taxcode = 0 ).

    MODIFY ENTITIES OF zg2i_orders IN LOCAL MODE
    ENTITY zg2i_orders_dtl
    UPDATE FIELDS ( TaxCode Price )
    WITH VALUE #( FOR data IN lt_Item INDEX INTO i
                 (
                 %key = keys[ i ]-%key

                          TaxCode = 0
                          Price = lv_Price
                  )
                )
                REPORTED DATA(lt_rpt)
                FAILED DATA(lt_fld)
                MAPPED DATA(lt_mpd).

  ENDMETHOD.

  METHOD checkAvailable.

    READ ENTITIES OF zg2i_orders IN LOCAL MODE
    ENTITY zg2i_orders
    ALL FIELDS WITH VALUE #(
                              FOR key IN keys
                              ( %key = key-%key
                                %control = VALUE #( OrderId = if_abap_behv=>mk-on )
                              )
                            )
    RESULT DATA(lt_Orders).

    LOOP AT lt_Orders ASSIGNING FIELD-SYMBOL(<fs_order>).
    ENDLOOP.

    READ ENTITIES OF zg2i_orders IN LOCAL MODE
    ENTITY zg2i_orders_dtl
    ALL FIELDS  WITH VALUE #( FOR key IN keys
                                              ( %key = key-%key
                                                %control = VALUE #( ItemCode = if_abap_behv=>mk-on )
                                              )
                                    )
    RESULT DATA(lt_Item).

    LOOP AT lt_Item ASSIGNING FIELD-SYMBOL(<fs_item>).
    ENDLOOP.

    SELECT SINGLE * FROM zg2_wh_items
    WHERE item_code = @<fs_item>-ItemCode AND warehouse_code = @<fs_order>-WarehouseCode
    INTO @DATA(itemDetail).

    IF <fs_item>-Quantity > itemDetail-quantity.

      DATA : requiredQTY TYPE zg2_quantity .

      requiredQTY = <fs_item>-Quantity - itemDetail-quantity .

      SELECT SINGLE * FROM zg2_wh_items
      WHERE item_code = @<fs_item>-ItemCode AND quantity >= @requiredQTY AND warehouse_code NE @<fs_order>-WarehouseCode
      INTO @DATA(whDetail).

      IF sy-subrc IS INITIAL.

        INSERT VALUE #(
               %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
               text = |Item quantity not available in { <fs_order>-WarehouseCode } and { requiredQTY } required Item Availabe in { whdetail-warehouse_code }|  )
             ) INTO TABLE reported-zg2i_orders_dtl.

*        UPDATE zg2_wh_items
*          SET quantity = quantity + @requiredQTY
*          WHERE warehouse_code =  @<fs_order>-WarehouseCode
*          AND item_code =  @<fs_item>-ItemCode.
*
*        UPDATE zg2_wh_items
*        SET quantity = quantity - @requiredQTY
*        WHERE warehouse_code =  @whDetail-warehouse_code
*        AND item_code =  @<fs_item>-ItemCode.

      ELSE.

        INSERT VALUE #(
               %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
               text = 'item quantity Not Available in any warehouse' )
             ) INTO TABLE reported-zg2i_orders_dtl.

      ENDIF.
    ENDIF.


  ENDMETHOD.

ENDCLASS.


*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
