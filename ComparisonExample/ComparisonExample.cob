       identification division.
       program-id. ComparisonExample.
       
       data division.
       working-storage section.
       01 Num1 PIC 9(3) VALUE 120.
       01 Num2 PIC 9(3) VALUE 256.
       01 Num3 PIC 9(3) VALUE 005.
       01 Num4 PIC 9(3) VALUE 078.

       procedure division.
           display "Num1: ", Num1.
           if Num1 equal to 100
               display 'Num1 is equal to 100.'
           else
               display 'Num1 is not equal to 100.'
           end-if.

           evaluate true
               when Num4 greater than 50
                   display 'Num4 is greater than 50'
               when Num4 less than 50
                   display 'Num4 is less than 50'
               when other
                   display 'unexpected condition'
           end-evaluate.

           if Num4 is numeric
               display 'Num4 is a numeric value'
           else
               display 'Num4 is nnot a numeric value'
           end-if.

       
       stop run.
