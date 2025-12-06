       identification division.
       program-id. PerformThruExample.

       data division.
       working-storage section.
       01 Counter PIC 9(3) value 100.

       procedure division.
           perform 100-THRU-200.
           stop run.
       100-THRU-200.
           if Counter <= 200
               display 'Processing Counter: ',Counter
               add 1 to Counter
               perform 100-THRU-200
           end-if.
       