"! Testes da versão limpa. Com uma variante que inclua a verificação
"! ABAP Unit, o ATC também executa estes testes.
CLASS ltc_order_total DEFINITION FINAL FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_ib_atc_order_total.

    METHODS setup.
    METHODS sums_quantity_times_price FOR TESTING RAISING cx_static_check.
    METHODS empty_order_is_zero FOR TESTING RAISING cx_static_check.
    METHODS missing_price_raises FOR TESTING.
ENDCLASS.


CLASS ltc_order_total IMPLEMENTATION.

  METHOD setup.
    cut = NEW #( ).
  ENDMETHOD.


  METHOD sums_quantity_times_price.
    DATA(prices) = VALUE zcl_ib_atc_order_total=>prices( ( material = 'M1' price = '10.00' )
                                                        ( material = 'M2' price = '2.50' ) ).
    DATA(items) = VALUE zcl_ib_atc_order_total=>items( ( material = 'M1' quantity = 3 )
                                                      ( material = 'M2' quantity = 4 ) ).

    DATA(total) = cut->total( items = items prices = prices ).

    cl_abap_unit_assert=>assert_equals( exp = CONV zcl_ib_atc_order_total=>amount( '40.00' )
                                        act = total ).
  ENDMETHOD.


  METHOD empty_order_is_zero.
    DATA(total) = cut->total( items = VALUE #( ) prices = VALUE #( ) ).

    cl_abap_unit_assert=>assert_initial( total ).
  ENDMETHOD.


  METHOD missing_price_raises.
    TRY.
        cut->total( items  = VALUE #( ( material = 'M9' quantity = 1 ) )
                    prices = VALUE #( ) ).
        cl_abap_unit_assert=>fail( msg = 'ZCX_IB_PRICE_NOT_FOUND expected' ).
      CATCH zcx_ib_price_not_found.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
