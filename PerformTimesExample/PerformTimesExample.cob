       identification division.
       program-id. PerformTimesExample.
       
       data division.
       working-storage section.
       01 Counter PIC 9(2) value 1.

       procedure division.
           perform 3 times
               display 'Perform Tiimes: ',Counter
               add 1 to Counter
           end-perform.
           stop run.
           