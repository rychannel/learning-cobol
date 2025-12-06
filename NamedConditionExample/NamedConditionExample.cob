       identification division.
       program-id. NamedConditionExample.
       
       data division.
       working-storage section.
       
       01 StatusCode PIC 99.
       88 SPECIAL-CASE VALUE 1.

       procedure division.
           display 'Enter status code:'.
           accept StatusCode.

           if SPECIAL-CASE
               display 'Special case condition is true'
           else
               display 'Special case condition is false'
           end-if.

           stop run.
