       identification division.
       program-id. PerformVaryingExample.
       data division.
       working-storage section.
       01 Counter PIC 9(2) value 1.

       procedure division.
           perform varying Counter from 1 by 1 until counter > 5
               display "Perform Varying: ",Counter
           end-perform
           stop run.
           