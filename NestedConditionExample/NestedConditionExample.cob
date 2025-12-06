       identification division.
       program-id. NestedConditionExample.

       data division.
       working-storage section.
       01 Num1 PIC s9(3) value 150.
       01 Num2 PIC s9(3) value -100.
       01 Result PIC X(10).
       01 SPECIAL-CASE  PIC X VALUE 'Y'.
       88 SPECIAL-CASE-TRUE VALUE 'Y'.

       procedure division.
           if Num1 > 100
                display 'Nested IF condition: Num 1 is greater than 100'
                if Num1 > Num2
                    display '-Nested relation: Num 1 is greater than 
      -    'Num2'
                end-if
           else
                display '-Num1 is not greater than 100'
           end-if.

           stop run.
