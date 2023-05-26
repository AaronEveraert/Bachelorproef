CLASS lhc_zi_ticket DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validatContactEmailIsFilled FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_Ticket~validatContactEmailIsFilled.

    METHODS validateType FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_Ticket~validateType.

    METHODS validateTitle FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_Ticket~validateTitle.

    METHODS validatNameIsFilled FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_Ticket~validatNameIsFilled.
    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZI_Ticket~setInitialStatus.

ENDCLASS.

CLASS lhc_zi_ticket IMPLEMENTATION.

  METHOD validatContactEmailIsFilled.
  DATA matcher TYPE REF TO cl_abap_matcher.



    READ ENTITIES OF ZI_Ticket IN LOCAL MODE
          ENTITY ZI_Ticket
          FIELDS ( contactemail ) WITH CORRESPONDING #( keys )
          RESULT DATA(tickets).

    LOOP AT tickets INTO DATA(ticket).

      matcher = cl_abap_matcher=>create(
            pattern = `\w+(\.\w+)*@(\w+\.)+(\w{2,4})`
            ignore_case = 'X'
            text = ticket-contactemail ).

      IF matcher->match( ) IS INITIAL.

        APPEND VALUE #( %tky = ticket-%tky ) TO failed-ZI_Ticket.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                            %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                                                          text = 'Given Contact Email is not a valid email' )
                           ) TO reported-ZI_Ticket.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateType.
    READ ENTITIES OF ZI_Ticket IN LOCAL MODE
         ENTITY ZI_Ticket
         FIELDS ( Type ) WITH CORRESPONDING #( keys )
         RESULT DATA(tickets).

    LOOP AT tickets INTO DATA(ZI_Ticket).
      SELECT SINGLE * FROM zi_Type
          WHERE Type = @ZI_Ticket-Type
          INTO @DATA(ls_call).
      IF sy-subrc NE 0.
        APPEND VALUE #( %tky = ZI_Ticket-%tky ) TO failed-ZI_Ticket.
        APPEND VALUE #( %tky = ZI_Ticket-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'Status is not valid' )
                       ) TO reported-ZI_Ticket.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateTitle.
  READ ENTITIES OF ZI_Ticket IN LOCAL MODE
          ENTITY ZI_Ticket
          FIELDS ( Title ) WITH CORRESPONDING #( keys )
          RESULT DATA(tickets).

    LOOP AT tickets INTO DATA(ticket).

      IF ticket-Title = ''.
        APPEND VALUE #( %tky = ticket-%tky ) TO failed-ZI_Ticket.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                            %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                                                          text = 'Title is Mandatory' )
                           ) TO reported-ZI_Ticket.
      ENDIF.

      IF ticket-Title IS NOT INITIAL AND strlen( ticket-Title ) < 3 .
        APPEND VALUE #( %tky = ticket-%tky ) TO failed-ZI_Ticket.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                            %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                                                          text = 'Title must have 3 or more characters' )
                           ) TO reported-ZI_Ticket.

      ENDIF.


    ENDLOOP.
  ENDMETHOD.

  METHOD validatNameIsFilled.
  READ ENTITIES OF ZI_Ticket IN LOCAL MODE
          ENTITY ZI_Ticket
          FIELDS ( Name ) WITH CORRESPONDING #( keys )
          RESULT DATA(tickets).

    LOOP AT tickets INTO DATA(ticket).

      IF ticket-Name = ''.
        APPEND VALUE #( %tky = ticket-%tky ) TO failed-ZI_Ticket.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                            %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                                                          text = 'Name is Mandatory' )
                           ) TO reported-ZI_Ticket.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD setInitialStatus.
   READ ENTITIES OF ZI_Ticket IN LOCAL MODE
   ENTITY ZI_Ticket
   FIELDS ( Status )
   WITH CORRESPONDING #( keys )
   RESULT DATA(tickets).

   loop AT tickets INTO DATA(ticketss).
   ENDLOOP.


   if ticketss-Status is INITIAL.
   MODIFY ENTITIES OF ZI_Ticket IN LOCAL MODE
   ENTITY ZI_Ticket
     UPDATE
       FIELDS ( Status )
       WITH VALUE #( FOR ticket IN tickets
                     ( %tky         = ticket-%tky
                       Status = 'New' ) )
   REPORTED DATA(update_reported).
  ENDIF.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
