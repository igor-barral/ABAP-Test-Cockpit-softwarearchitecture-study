"! COM ACHADOS INTENCIONAIS: total de um pedido (quantidade x preço) no
"! estilo encontrado em código antigo. Serve para rodar o ATC
"! (Ctrl+Shift+F2) e ver os achados. Cada [ATC-n] é explicado na seção 4
"! do README. Excluída do abaplint no abaplint.json.
CLASS zcl_ib_atc_order_total_raw DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_item,
             material TYPE c LENGTH 10,
             quantity TYPE i,
           END OF ty_item,
           tt_item TYPE STANDARD TABLE OF ty_item WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_price,
             material TYPE c LENGTH 10,
             price    TYPE p LENGTH 15 DECIMALS 2,
           END OF ty_price,
           tt_price TYPE STANDARD TABLE OF ty_price WITH DEFAULT KEY.
    TYPES ty_amount TYPE p LENGTH 15 DECIMALS 2.

    METHODS total
      IMPORTING it_items        TYPE tt_item
                it_prices       TYPE tt_price
      RETURNING VALUE(rv_total) TYPE ty_amount.
ENDCLASS.


CLASS zcl_ib_atc_order_total_raw IMPLEMENTATION.

  METHOD total.
    DATA ls_item  TYPE ty_item.
    DATA ls_price TYPE ty_price.
    DATA lv_count TYPE i.                                       " [ATC-1]

    TRY.
        LOOP AT it_items INTO ls_item.
          " [ATC-2] busca sequencial numa tabela STANDARD, dentro de LOOP
          READ TABLE it_prices INTO ls_price WITH KEY material = ls_item-material.
          " [ATC-3] sy-subrc não avaliado: sem preço, reaproveita o anterior
          rv_total = rv_total + ls_price-price * ls_item-quantity.
        ENDLOOP.
      CATCH cx_sy_arithmetic_overflow.                          " [ATC-4]
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
