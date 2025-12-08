       identification division.
       program-id. output-employees.

       environment division.
       input-output section.
       file-control.
       select EMPLOYEE-FILE
           assign to 'employees.dat'
           organization is line sequential
           file status is WS-EMP-STATUS.

       data division.
       file section.
       fd EMPLOYEE-FILE.
       01 EMPLOYEE-RECORD.
          05 EMP-ID               pic 9(6).
          05 EMP-NAME             pic x(30).
          05 EMP-HOURLY-RATE      pic 9(3)v99.
          05 EMP-HOURS-WORKED     pic 9(3)v99.

       working-storage section.    
       01 WS-EMP-STATUS          pic xx.
          88 EMP-SUCCESS         value '00'.
          88 EMP-EOF             value '10'.

       procedure division.
       MAIN-LOGIC.
           open output EMPLOYEE-FILE
           if not EMP-SUCCESS
              display "Error opening employee file: 
      -             " "WS-EMP-STATUS
              stop run
           end-if

           move 000001 to EMP-ID
           move "Ryan Murphy" to EMP-NAME
           move 62.50 to EMP-HOURLY-RATE
           move 38.75 to EMP-HOURS-WORKED
           write EMPLOYEE-RECORD

           move 000002 to EMP-ID
           move "Gary Rogers" to EMP-NAME
           move 79.00 to EMP-HOURLY-RATE
           move 42.00 to EMP-HOURS-WORKED
           write EMPLOYEE-RECORD 

           close EMPLOYEE-FILE

           display "Employee records written successfully."
           
           stop run.
           