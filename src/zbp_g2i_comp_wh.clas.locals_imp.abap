CLASS lhc_zg2i_comp_wh_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS ItemDetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZG2I_COMP_WH_ITEM~ItemDetails.

ENDCLASS.

CLASS lhc_zg2i_comp_wh_item IMPLEMENTATION.

  METHOD ItemDetails.

  READ ENTITIES OF ZG2I_COMP_WH IN LOCAL MODE
  ENTITY ZG2I_COMP_WH_ITEM
  FIELDS ( ItemCode ) with VALUE #( for key IN keys
                                            ( %key = key-%key
                                              %control = value #( ItemCode = if_abap_behv=>mk-on )
                                            )
                                  )
  RESULT DATA(lt_itemCode).

  LOOP AT lt_itemCode ASSIGNING FIELD-SYMBOL(<fs_item>).
  ENDLOOP.

  select single * from zg2_wh_items
  where item_code = @<fs_item>-ItemCode
  into @data(itemDetail).


  MODIFY ENTITIES OF ZG2I_COMP_WH in LOCAL MODE
  ENTITY ZG2I_COMP_WH_ITEM
  UPDATE FIELDS (  ItemName ItemType ItemCategory ItemBrand ItemModel ItemDescription )
  with value #( for result in lt_itemCode index into i
               (
               %key = keys[ i ]-%key
                        ItemName = itemDetail-item_name
                        ItemType = itemDetail-item_type
                        ItemCategory = itemDetail-item_category
                        ItemBrand = itemDetail-item_brand
                        ItemModel = itemDetail-item_model
                        ItemDescription = itemDetail-item_description
                 )
              )
              REPORTED DATA(lt_rpt)
              FAILED Data(lt_fld)
              Mapped DATA(lt_mpd).




*  ItemName,
*    ItemType,
*    ItemCategory,
*    ItemBrand,
*    ItemModel,
*    ItemDescription,
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZG2I_COMP_WH DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zg2i_comp_wh RESULT result.
    METHODS compdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zg2i_comp_wh~compdetails.

    METHODS warehousedetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zg2i_comp_wh~warehousedetails.
    METHODS validatestate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zg2i_comp_wh~validatestate.

ENDCLASS.

CLASS lhc_ZG2I_COMP_WH IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD CompDetails.

  READ ENTITIES OF ZG2I_COMP_WH IN LOCAL MODE
  ENTITY ZG2I_COMP_WH
  FIELDS ( OrgCode CompanyCode ) with VALUE #( for key IN keys
                                            ( %key = key-%key
                                              %control = value #( OrgCode = if_abap_behv=>mk-on )
                                            )
                                  )
  RESULT DATA(lt_orgCode).

  LOOP AT lt_orgCode ASSIGNING FIELD-SYMBOL(<fs_item>).
  ENDLOOP.

  select single * from zg2_company
  where org_code = @<fs_item>-OrgCode and company_code = @<fs_item>-CompanyCode
  into @data(compDetail).


  MODIFY ENTITIES OF ZG2I_COMP_WH in LOCAL MODE
  ENTITY ZG2I_COMP_WH
  UPDATE FIELDS ( CompanyName Country OrgLocation OrgCity OrgState OrgStatus )
  with value #( for result in lt_orgCode index into i
               (
               %key = keys[ i ]-%key
                        CompanyName = compDetail-company_name
                        OrgLocation = compDetail-org_location
                        OrgCity = compDetail-org_city
                        OrgState = compDetail-org_state
                        Country = compDetail-country
                        OrgStatus = 'ACTIVE'

                 )
              )
              REPORTED DATA(lt_rpt)
              FAILED Data(lt_fld)
              Mapped DATA(lt_mpd).

  ENDMETHOD.

  METHOD warehouseDetails.

   READ ENTITIES OF ZG2I_COMP_WH IN LOCAL MODE
  ENTITY ZG2I_COMP_WH
  FIELDS ( WarehouseCode ) with VALUE #( for key IN keys
                                            ( %key = key-%key
                                              %control = value #( WarehouseCode = if_abap_behv=>mk-on )
                                            )
                                  )
  RESULT DATA(lt_WarehouseCode).

  LOOP AT lt_WarehouseCode ASSIGNING FIELD-SYMBOL(<fs_item>).
  ENDLOOP.

  select single * from zg2_warehouse
  where warehouse_code = @<fs_item>-WarehouseCode
  into @data(whDetail).


  MODIFY ENTITIES OF ZG2I_COMP_WH in LOCAL MODE
  ENTITY ZG2I_COMP_WH
  UPDATE FIELDS ( WarehouseLocation WarehouseCity WarehouseState )
  with value #( for result in lt_WarehouseCode index into i
               (
               %key = keys[ i ]-%key
                        WarehouseLocation = whDetail-warehouse_location
                        WarehouseCity = whDetail-warehouse_city
                        WarehouseState = whDetail-warehouse_location


                 )
              )
              REPORTED DATA(lt_rpt)
              FAILED Data(lt_fld)
              Mapped DATA(lt_mpd).

  ENDMETHOD.

  METHOD validateState.

  READ ENTITIES OF ZG2I_COMP_WH IN LOCAL MODE
  ENTITY ZG2I_COMP_WH
  FIELDS ( OrgState WarehouseState ) with CORRESPONDING #( keys )
  RESULT DATA(lv_warehouse).

  LOOP AT lv_warehouse INTO DATA(ls_warehouse).

      IF ls_warehouse-OrgState <> ls_warehouse-WarehouseState.
        APPEND VALUE #( %tky = ls_warehouse-%tky ) TO failed-zg2i_comp_wh.
        APPEND VALUE #( %tky = ls_warehouse-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Warehouse State should be same as the Organization State' )
                       ) TO reported-zg2i_comp_wh.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
