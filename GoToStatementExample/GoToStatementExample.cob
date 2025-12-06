       identification division.
       program-id. GoToStatementExample.
       
       data division.
       working-storage section.
       01 Counter PIC 9(2) value 1.

       procedure division.
           perform 100-process until Counter > 5.
           stop run.

       100-process.
           display 'Go to Statement: ',Counter.
           add 1 to Counter.
           if Counter > 3 then
               go to 200-end-of-process.
           display 'Processing continues...'.
           go to 100-process.

       200-end-of-process.
           Display 'Processing completed'.
