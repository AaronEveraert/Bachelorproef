CLASS zcl_generated_status DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_generated_status IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.

    INSERT  ztype from table @( value #(
    (
    type_id = 01
    type = 'Question'
    description = ' Researchers can apply to an active call'

    )
    (
    type_id = 02
    type = 'Incident'
    description = 'Researchers cannot apply to an inactive call'

    )
    ) ).

    SELECT * FROM ztype INTO TABLE @DATA(lt_sql_entries).
    IF sy-subrc = 0.
      DATA(numberofrecords) = lines( lt_sql_entries ).
      out->write( numberofrecords && ' entries inserted successfully ' ).
    ENDIF.


    "delete from zrap_call_aaron.
  ENDMETHOD.

ENDCLASS.
