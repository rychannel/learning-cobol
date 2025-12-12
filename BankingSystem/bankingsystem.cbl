       identification division.
       program-id. banking-system.

       environment division.
       input-output section.
       file-control.
       fd CUSTOMER-FILE.
       01 CUSTOMER-RECORD.
          05 CUST-ID               pic 9(6).
          05 CUST-NAME             pic x(30).
          05 CUST-BALANCE          pic 9(8)v99.
       
       fd TRANSACTION-FILE.
       01 TRANSACTION-RECORD.
          05 TRANS-ID               pic 9(6).
          05 TRANS-CUST-ID          pic 9(6).
          05 TRANS-AMOUNT           pic 9(8)v99.
          05 TRANS-TYPE             pic x(10).

       working-storage section.
       01 WS-CUSTOMER-RECORD.
          05 WS-CUST-ID             pic 9(6).
          05 WS-CUST-NAME           pic x(30).
          05 WS-CUST-BALANCE        pic 9(8)v99.

       01 WS-TRANSACTION-RECORD.
          05 WS-TRANS-ID             pic 9(6).
          05 WS-TRANS-CUST-ID        pic 9(6).
          05 WS-TRANS-AMOUNT         pic 9(8)v99.
          05 WS-TRANS-TYPE           pic x(10).

       01 WS-EOF-FLAG               pic x value 'N'.
          88 EOF-REACHED            value 'Y'.
          88 NOT-EOF                value 'N'.

       01 WS-TRANSACTION-STATUS     pic xx.
       01 WS-CUSTOMER-STATUS        pic xx.
       01 WS-USER-CHOICE            pic x.

       procedure division.
       MAIN-LOGIC.
           perform DISPLAY-MENU.
    
           stop run.

       DISPLAY-MENU.
           display "Welcome to the Bank of RYAN Banking System".
           display "Please select an option:".
           display "-------------------------------------".
           display "1. Add New Customer".
           display "2. Add New Transaction".
           display "3. View Customer Accounts".
           display "4. View Transaction History".
           display "5. Exit".
           display "-------------------------------------".
           accept WS-USER-CHOICE.
           evaluate WS-USER-CHOICE
               when '1'
                   perform ADD-NEW-CUSTOMER
               when '2'
                   perform ADD-NEW-TRANSACTION
               when '3'
                   perform VIEW-CUSTOMER-ACCOUNTS
               when '4'
                   perform VIEW-TRANSACTION-HISTORY
               when '5'
                   display "Thank you for using the Banking System. Good
       -             "bye!"
                when other
                     display "Invalid option selected. Please try again."
              end-evaluate.