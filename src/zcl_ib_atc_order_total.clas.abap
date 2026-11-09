"! Mesma regra de ZCL_IB_ATC_ORDER_TOTAL_RAW, sem os achados do ATC:
"! preços em tabela HASHED, preço ausente vira exceção, nada sem uso.
CLASS zcl_ib_atc_order_total DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES amount TYPE p LENGTH 15 DECIMALS 2.
    TYPES material TYPE c LENGTH 10.
    TYPES:
      BEGIN OF item,
        material TYPE material,
        quantity TYPE i,
      END OF item,
      items TYPE STANDARD TABLE OF item WITH EMPTY KEY.
    TYPES:
      BEGIN OF price,
        material TYPE material,
        price    TYPE amount,
      END OF price,
      prices TYPE HASHED TABLE OF price WITH UNIQUE KEY material.

    "! Soma de quantidade x preço de cada item.
    "! @raising zcx_ib_price_not_found | Item sem preço na tabela
    METHODS total
      IMPORTING items         TYPE items
                prices        TYPE prices
      RETURNING VALUE(result) TYPE amount
      RAISING   zcx_ib_price_not_found.

  PRIVATE SECTION.
    METHODS price_of
      IMPORTING material      TYPE material
                prices        TYPE prices
      RETURNING VALUE(result) TYPE amount
      RAISING   zcx_ib_price_not_found.
ENDCLASS.


CLASS zcl_ib_atc_order_total IMPLEMENTATION.

  METHOD total.
    result = REDUCE #( INIT sum = VALUE amount( )
                       FOR item IN items
                       NEXT sum = sum + price_of( material = item-material
                                                  prices   = prices ) * item-quantity ).
  ENDMETHOD.


  METHOD price_of.
    TRY.
        result = prices[ material = material ]-price.
      CATCH cx_sy_itab_line_not_found INTO DATA(not_found).
        RAISE EXCEPTION NEW zcx_ib_price_not_found( material = material
                                                    previous = not_found ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
