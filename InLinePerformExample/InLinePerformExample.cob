       identification division.
       program-id. InLinePerformExample.
       
       data division.
       working-storage section.
       01 Counter PIC 9(2) value 1.

       procedure division.
           perform 5 times
               display 'In-Line Perform: ', Counter
               add 1 to Counter
           end-perform.
           stop run.
