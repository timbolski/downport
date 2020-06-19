CLASS ltcl_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    METHODS: serialize FOR TESTING RAISING zcx_abapgit_exception.

ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD serialize.

    DATA: lo_cut  TYPE REF TO zcl_abapgit_objects_generic,
          lo_xml  TYPE REF TO zcl_abapgit_xml_output,
          ls_item TYPE zif_abapgit_definitions=>ty_item.

* assumption: this object exists in all SAP systems
    ls_item-obj_type = 'ASFC'.
    ls_item-obj_name = 'SAP_AS_TEST_001'.

    lo_cut = NEW #( is_item = ls_item ).

    lo_xml = NEW #( ).

    lo_cut->serialize( lo_xml ).
* checks that it does not dump

  ENDMETHOD.

* todo, implement tests for methods:
* DISTRIBUTE_NAME_TO_COMPONENTS
* GET_KEY_FIELDS
* GET_PRIMARY_TABLE
* GET_WHERE_CLAUSE
* SPLIT_VALUE_TO_KEYS

ENDCLASS.
