       identification division.
       program-id. payroll-processor.

       environment division.
       input-output section.
       file-control.
       select EMPLOYEE-FILE 
           assign to 'employees.dat'
           organization is line sequential
           file status is WS-EMP-STATUS.

       select PAYROLL-REPORT
           assign to 'payroll.txt'
           organization is line sequential
           file status is WS-REPORT-STATUS.
       
       data division.
       file section.
       fd EMPLOYEE-FILE.
       01 EMPLOYEE-RECORD.
          05 EMP-ID               pic 9(6).
          05 EMP-NAME             pic x(30).
          05 EMP-HOURLY-RATE      pic 9(3)v99.
          05 EMP-HOURS-WORKED     pic 9(3)v99.

       fd PAYROLL-REPORT.
       01 REPORT-LINE             pic x(80).

       working-storage section.
       01 WS-EMP-STATUS           pic xx.
          88 EMP-SUCCESS          value '00'.
          88 EMP-EOF              value '10'.

       01 WS-REPORT-STATUS        pic xx.
          88 REPORT-SUCCESS       value '00'.
       
       01 WS-CALCULATED-PAY      pic 9(6)v99.
       01 WS-TOTAL-PAYROLL       pic 9(8)v99 value zero.
       01 WS-EMPLOYEE-COUNT      pic 9(5) value zero.

       01 WS-FORMATTED-PAY       pic $ZZZ,ZZ9.99.
       01 WS-FORMATTED-TOTAL     pic $ZZZ,ZZZ,ZZ9.99.

       procedure division.
       MAIN-LOGIC.
           perform OPEN-FILES.
           perform WRITE-REPORT-HEADER.
           perform PROCESS-EMPLOYEES.
           perform WRITE-REPORT-FOOTER.
           perform CLOSE-FILES.

           stop run.

       OPEN-FILES.
           open input EMPLOYEE-FILE
           if not EMP-SUCCESS
              display "Error opening employee file: 
      -              " "WS-EMP-STATUS
              stop run
           end-if

           open output payroll-report.
           if not REPORT-SUCCESS
              display "Error opening payroll report file: 
      -              " "WS-REPORT-STATUS
              stop run
           end-if.

       WRITE-REPORT-HEADER.
           move "EMPLOYEE PAYROLL REPORT" to REPORT-LINE.
           write REPORT-LINE.
           move all "=" to REPORT-LINE.
           write REPORT-LINE.
           move "ID     NAME                           Pay" 
           to REPORT-LINE.
           write REPORT-LINE.
           move all "-" to REPORT-LINE.
           write REPORT-LINE.

       PROCESS-EMPLOYEES.
           perform until EMP-EOF
             read EMPLOYEE-FILE
                at end
                   continue
                not at end
                   perform CALCULATE-AND-WRITE-PAY
             end-read
           end-perform.

       CALCULATE-AND-WRITE-PAY.
           multiply EMP-HOURLY-RATE by EMP-HOURS-WORKED
                giving WS-CALCULATED-PAY rounded.

           add WS-CALCULATED-PAY to WS-TOTAL-PAYROLL.
           add 1 to WS-EMPLOYEE-COUNT.

           move WS-CALCULATED-PAY to WS-FORMATTED-PAY.
           move spaces to REPORT-LINE.
           string EMP-ID delimited by size
                  " " delimited by size
                  EMP-NAME delimited by size
                  " " delimited by size
                  WS-FORMATTED-PAY delimited by size
                  into REPORT-LINE
           end-string.

           write REPORT-LINE.

       WRITE-REPORT-FOOTER.
           move spaces to REPORT-LINE.
           write REPORT-LINE.
           move all "=" to REPORT-LINE.
           write REPORT-LINE.

           move spaces to REPORT-LINE.
           move WS-TOTAL-PAYROLL to WS-FORMATTED-TOTAL.
           string "TOTAL PAYROLL: " delimited by size
                  WS-FORMATTED-TOTAL delimited by size
                  into REPORT-LINE
           end-string.
           write REPORT-LINE.

           move spaces to REPORT-LINE.
           string "EMPLOYEES PROCESSED:     " delimited by size
                  WS-EMPLOYEE-COUNT delimited by size
                  into REPORT-LINE
           end-string.

           write REPORT-LINE.

       CLOSE-FILES.
           close EMPLOYEE-FILE
           close PAYROLL-REPORT.
           display "Report generated successfully".
