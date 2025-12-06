       identification division.
       program-id. OutOfLLinePerformExample.

       data division.
       working-storage section.
       01 Counter PIC 9(2) value 1.
       procedure division.
           perform
               display 'Out-Of-Line Perform: ',Counter
               add 1 to  Counter
           end-perform

           stop run.
      