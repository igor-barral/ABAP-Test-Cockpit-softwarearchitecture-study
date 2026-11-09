"! Item do pedido sem preço: erro de negócio previsível, CX_STATIC_CHECK.
CLASS zcx_ib_price_not_found DEFINITION PUBLIC
  INHERITING FROM cx_static_check FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    DATA material TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING previous LIKE previous OPTIONAL
                material TYPE csequence OPTIONAL.

    METHODS get_text REDEFINITION.
ENDCLASS.


CLASS zcx_ib_price_not_found IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    me->material = material.
  ENDMETHOD.

  METHOD get_text.
    result = |No price found for material { material }|.
  ENDMETHOD.

ENDCLASS.
