CLASS zcl_abapgit_gui_page_syntax DEFINITION PUBLIC FINAL CREATE PUBLIC
    INHERITING FROM zcl_abapgit_gui_page_codi_base.

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          io_repo TYPE REF TO zcl_abapgit_repo
        RAISING
          zcx_abapgit_exception,

      zif_abapgit_gui_event_handler~on_event
        REDEFINITION,

      zif_abapgit_gui_renderable~render
        REDEFINITION.

  PROTECTED SECTION.
    CONSTANTS: c_variant TYPE sci_chkv VALUE 'SYNTAX_CHECK'.

    METHODS:
      render_content REDEFINITION.

  PRIVATE SECTION.
    METHODS:
      build_menu
        RETURNING
          VALUE(ro_menu) TYPE REF TO zcl_abapgit_html_toolbar
        RAISING
          zcx_abapgit_exception,

      run_syntax_check
        RAISING
          zcx_abapgit_exception.
ENDCLASS.



CLASS ZCL_ABAPGIT_GUI_PAGE_SYNTAX IMPLEMENTATION.


  METHOD build_menu.

    ro_menu = build_base_menu( ).

  ENDMETHOD.


  METHOD constructor.
    super->constructor( ).
    ms_control-page_title = 'Syntax Check'.
    mo_repo = io_repo.
    run_syntax_check( ).
  ENDMETHOD.


  METHOD render_content.

    ri_html = NEW zcl_abapgit_html( ).

    ri_html->add( `<div class="repo">` ).
    ri_html->add( zcl_abapgit_gui_chunk_lib=>render_repo_top( mo_repo ) ).
    ri_html->add( `</div>` ).

    ri_html->add( '<div class="toc">' ).

    ri_html->add( render_variant( c_variant ) ).

    IF lines( mt_result ) = 0.
      ri_html->add( '<div class="dummydiv success">' ).
      ri_html->add( ri_html->icon( 'check' ) ).
      ri_html->add( 'No syntax errors' ).
      ri_html->add( '</div>' ).
    ELSE.
      render_result( ii_html   = ri_html
                     it_result = mt_result ).
    ENDIF.

  ENDMETHOD.


  METHOD run_syntax_check.

    DATA: li_syntax_check TYPE REF TO zif_abapgit_code_inspector.

    li_syntax_check = zcl_abapgit_factory=>get_code_inspector( mo_repo->get_package( ) ).
    mt_result = li_syntax_check->run( c_variant ).

  ENDMETHOD.


  METHOD zif_abapgit_gui_event_handler~on_event.

    CASE iv_action.
      WHEN c_actions-rerun.

        run_syntax_check( ).

        ei_page = me.
        ev_state = zcl_abapgit_gui=>c_event_state-re_render.

      WHEN OTHERS.
        super->zif_abapgit_gui_event_handler~on_event(
          EXPORTING
            iv_action             = iv_action
            iv_getdata            = iv_getdata
            it_postdata           = it_postdata
          IMPORTING
            ei_page               = ei_page
            ev_state              = ev_state ).
    ENDCASE.

  ENDMETHOD.


  METHOD zif_abapgit_gui_renderable~render.

    ms_control-page_menu = build_menu( ).
    ri_html = super->zif_abapgit_gui_renderable~render( ).

  ENDMETHOD.
ENDCLASS.
