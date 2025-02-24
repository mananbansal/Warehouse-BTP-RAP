CLASS lhc_ZG2I_ORDERS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zg2i_orders RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zg2i_orders RESULT result.

    METHODS approvestatus FOR MODIFY
      IMPORTING keys FOR ACTION zg2i_orders~approvestatus RESULT result.

    METHODS rejectstatus FOR MODIFY
      IMPORTING keys FOR ACTION zg2i_orders~rejectstatus RESULT result.

    METHODS validatecompcode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zg2i_orders~validatecompcode.

    METHODS validateempid FOR VALIDATE ON SAVE
      IMPORTING keys FOR zg2i_orders~validateempid.

    METHODS validateorgcode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zg2i_orders~validateorgcode.

    METHODS validatepaymethod FOR VALIDATE ON SAVE
      IMPORTING keys FOR zg2i_orders~validatepaymethod.

    METHODS validatewarehousecode FOR VALIDATE ON SAVE
      IMPORTING keys FOR zg2i_orders~validatewarehousecode.

ENDCLASS.

CLASS lhc_ZG2I_ORDERS IMPLEMENTATION.

  METHOD get_instance_authorizations.

    DATA: lv_username TYPE string,
          lv_desg     TYPE ZG2_CMP_EMP-employee_designation,
          lv_allowed  TYPE abp_behv_auth.

    TYPES: BEGIN OF ty_action,
             OrderId                 TYPE zg2_code,  " Replace with the actual type
             approvestatus  TYPE abp_behv_auth,
             rejectstatus  TYPE abp_behv_auth,
           END OF ty_action.

    DATA: lt_actions TYPE TABLE OF ty_action,
          ls_action  TYPE ty_action.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_data>).

      lv_username = cl_abap_context_info=>get_user_technical_name(  ).

      SELECT SINGLE employee_designation
        FROM ZG2_CMP_EMP
        WHERE employee_username = @lv_username
        INTO @lv_desg.

      lv_allowed = COND #( WHEN lv_desg = 'MANAGER'
                           THEN if_abap_behv=>auth-allowed
                           ELSE if_abap_behv=>auth-unauthorized
                         ).

      ls_action-OrderId = <ls_data>-OrderId.
      ls_action-approvestatus = lv_allowed.
      ls_action-rejectstatus = lv_allowed.

      APPEND ls_action TO lt_actions.

    ENDLOOP.

    " Append all the actions to the result
    LOOP AT lt_actions ASSIGNING FIELD-SYMBOL(<ls_action>).
      APPEND VALUE #( OrderId = <ls_action>-OrderId
                      %action-approvestatus = <ls_action>-approvestatus
                      %action-rejectstatus = <ls_action>-rejectstatus ) TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zg2i_orders IN LOCAL MODE
    ENTITY zg2i_orders
    FIELDS ( OrderStatus ) WITH CORRESPONDING #( keys )
    RESULT DATA(lv_doc_result)
     FAILED failed.

    result =
      VALUE #( FOR ls_status IN lv_doc_result
        ( %key = ls_status-%key
          %features = VALUE #( %action-approvestatus = COND #( WHEN ls_status-OrderStatus = 'IN PROGRES'
                                                        THEN if_abap_behv=>fc-o-enabled
                                                        ELSE if_abap_behv=>fc-o-disabled )
                               %action-rejectstatus = COND #( WHEN ls_status-OrderStatus = 'IN PROGRES'
                                                        THEN if_abap_behv=>fc-o-enabled
                                                        ELSE if_abap_behv=>fc-o-disabled )
         ) ) ).

  ENDMETHOD.

  METHOD approveStatus.

  READ ENTITIES OF ZG2I_ORDERS IN LOCAL MODE
            ENTITY ZG2I_ORDERS ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_hdr)
            FAILED Data(lt_fld).

            LOOP AT lt_hdr ASSIGNING FIELD-SYMBOL(<fs_hdr>).
            ENDLOOP.
        <fs_hdr>-OrderStatus = 'APPROVED'.

        MODIFY ENTITIES OF ZG2I_ORDERS IN LOCAL MODE
        ENTITY  ZG2I_ORDERS
         UPDATE FIELDS ( OrderStatus ) " The fields which we are updating will come here
         WITH VALUE #( FOR ls_result IN lt_hdr INDEX INTO i (
                            %key-OrderId = <fs_hdr>-%key-OrderId
                                OrderStatus = <fs_hdr>-OrderStatus

                          %control = VALUE #(
                          OrderStatus = if_abap_behv=>mk-on
                          )
         ) )
      FAILED lt_fld
      REPORTED DATA(lt_rpt)
      MAPPED DATA(lt_mpd).

  ENDMETHOD.

  METHOD rejectStatus.

  READ ENTITIES OF ZG2I_ORDERS IN LOCAL MODE
            ENTITY ZG2I_ORDERS ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_hdr)
            FAILED Data(lt_fld).

            LOOP AT lt_hdr ASSIGNING FIELD-SYMBOL(<fs_hdr>).
            ENDLOOP.
        <fs_hdr>-OrderStatus = 'REJECTED'.

        MODIFY ENTITIES OF ZG2I_ORDERS IN LOCAL MODE
        ENTITY  ZG2I_ORDERS
         UPDATE FIELDS ( OrderStatus ) " The fields which we are updating will come here
         WITH VALUE #( FOR ls_result IN lt_hdr INDEX INTO i (
                            %key-OrderId = <fs_hdr>-%key-OrderId
                                OrderStatus = <fs_hdr>-OrderStatus

                          %control = VALUE #(
                          OrderStatus = if_abap_behv=>mk-on
                          )
         ) )
      FAILED lt_fld
      REPORTED DATA(lt_rpt)
      MAPPED DATA(lt_mpd).

  ENDMETHOD.

  METHOD validateCompCode.

    READ ENTITIES OF ZG2I_ORDERS IN LOCAL MODE
            ENTITY ZG2I_ORDERS ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_hdr)
            FAILED Data(lt_fld).

    LOOP AT lt_hdr ASSIGNING FIELD-SYMBOL(<fs_hdr>).
            ENDLOOP.

    SELECT SINGLE CompanyCode FROM ZG2I_COMPANY WHERE CompanyCode = @<fs_hdr>-CompanyCode INTO @Data(lv_compcode).
    IF SY-SUBRC IS NOT INITIAL.
        INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
         text = 'Company Code is invalid' )
       ) INTO TABLE reported-zg2i_orders.
    ENDIF.

  ENDMETHOD.

  METHOD validateEmpId.

    READ ENTITIES OF ZG2I_ORDERS IN LOCAL MODE
            ENTITY ZG2I_ORDERS ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_hdr)
            FAILED Data(lt_fld).

    LOOP AT lt_hdr ASSIGNING FIELD-SYMBOL(<fs_hdr>).
            ENDLOOP.

    SELECT SINGLE EmployeeCode FROM ZG2I_CMP_EMP WHERE EmployeeCode = @<fs_hdr>-EmployeeId INTO @Data(lv_empid).
    IF SY-SUBRC IS NOT INITIAL.
        INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
         text = 'Employee ID is invalid' )
       ) INTO TABLE reported-zg2i_orders.
    ENDIF.

  ENDMETHOD.

  METHOD validateOrgCode.

    READ ENTITIES OF ZG2I_ORDERS IN LOCAL MODE
            ENTITY ZG2I_ORDERS ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_hdr)
            FAILED Data(lt_fld).

    LOOP AT lt_hdr ASSIGNING FIELD-SYMBOL(<fs_hdr>).
            ENDLOOP.

    SELECT SINGLE OrgCode FROM ZG2I_COMPANY WHERE OrgCode = @<fs_hdr>-OrgCode INTO @Data(lv_orgcode).
    IF SY-SUBRC IS NOT INITIAL.
        INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
         text = 'Organization Code is invalid' )
       ) INTO TABLE reported-zg2i_orders.
    ENDIF.

  ENDMETHOD.

  METHOD validatePayMethod.

    READ ENTITIES OF ZG2I_ORDERS IN LOCAL MODE
            ENTITY ZG2I_ORDERS ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_hdr)
            FAILED Data(lt_fld).

    LOOP AT lt_hdr ASSIGNING FIELD-SYMBOL(<fs_hdr>).
            ENDLOOP.

    SELECT SINGLE Value FROM ZG2I_PG_PAYMENTMETHOD WHERE Value = @<fs_hdr>-PaymentMethod INTO @Data(lv_payMethod).
    IF SY-SUBRC IS NOT INITIAL.
        INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
         text = 'Payment Method is invalid' )
       ) INTO TABLE reported-zg2i_orders.
    ENDIF.

  ENDMETHOD.

  METHOD validateWarehouseCode.

    READ ENTITIES OF ZG2I_ORDERS IN LOCAL MODE
            ENTITY ZG2I_ORDERS ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_hdr)
            FAILED Data(lt_fld).

    LOOP AT lt_hdr ASSIGNING FIELD-SYMBOL(<fs_hdr>).
            ENDLOOP.

    SELECT SINGLE WarehouseCode FROM ZG2I_COMP_WH WHERE WarehouseCode = @<fs_hdr>-WarehouseCode INTO @Data(lv_whcode).
    IF SY-SUBRC IS NOT INITIAL.
        INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
         text = 'Warehouse Code is invalid' )
       ) INTO TABLE reported-zg2i_orders.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
