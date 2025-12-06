       identification division.
       program-id. PerformUntilExample.
       
       data division.
       working-storage section.
       01 Counter PIC 9(2) value 1.

       procedure division.
           perform until Counter > 5
               display 'Perform Until: ',Counter
               add 1 to Counter
           end-perform
           stop run.
           