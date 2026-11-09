CLASS lhc_ZI_STUDENT_INFO DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validate_student_data
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZI_STUDENT_INFO~validate_student_data.

ENDCLASS.


CLASS lhc_ZI_STUDENT_INFO IMPLEMENTATION.

  METHOD validate_student_data.

    READ ENTITIES OF ZI_STUDENT_INFO IN LOCAL MODE
      ENTITY ZI_STUDENT_INFO
      FIELDS ( student_id student_name department age marks )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_students).

    LOOP AT lt_students INTO DATA(ls_student).

      DATA(lv_invalid) = abap_false.

      IF ls_student-student_id IS INITIAL.

        lv_invalid = abap_true.

        APPEND VALUE #(
          %tky = ls_student-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Student ID is required'
          )
          %element-student_id = if_abap_behv=>mk-on
        ) TO reported-zi_student_info.

      ENDIF.

      IF ls_student-student_name IS INITIAL.

        lv_invalid = abap_true.

        APPEND VALUE #(
          %tky = ls_student-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Student Name is required'
          )
          %element-student_name = if_abap_behv=>mk-on
        ) TO reported-zi_student_info.

      ENDIF.

      IF ls_student-department IS INITIAL.

        lv_invalid = abap_true.

        APPEND VALUE #(
          %tky = ls_student-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Department is required'
          )
          %element-department = if_abap_behv=>mk-on
        ) TO reported-zi_student_info.

      ENDIF.

      IF ls_student-age <= 0.

        lv_invalid = abap_true.

        APPEND VALUE #(
          %tky = ls_student-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Age must be greater than 0'
          )
          %element-age = if_abap_behv=>mk-on
        ) TO reported-zi_student_info.

      ENDIF.

      IF ls_student-marks < 0 OR ls_student-marks > 100.

        lv_invalid = abap_true.

        APPEND VALUE #(
          %tky = ls_student-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Marks must be between 0 and 100'
          )
          %element-marks = if_abap_behv=>mk-on
        ) TO reported-zi_student_info.

      ENDIF.

      IF lv_invalid = abap_true.

        APPEND VALUE #(
          %tky = ls_student-%tky
        ) TO failed-zi_student_info.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.