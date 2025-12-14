       identification division.
       program-id. banking-system.

       environment division.
       input-output section.
       file-control.
       select CUSTOMER-FILE
           assign to 'customers.dat'
           organization is line sequential
           file status is WS-CUSTOMER-STATUS.
       select TRANSACTION-FILE
           assign to 'transactions.dat'
           organization is line sequential
           file status is WS-TRANSACTION-STATUS.
      
       data division.
       file section.
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
       01 DISPLAY-TRANS-TYPE        pic x(10).

       procedure division.
       MAIN-LOGIC.
           perform DISPLAY-MENU.
    
           stop run.

       OPEN-FILES.
           display "Opening customer file...".
           open input CUSTOMER-FILE.
           display "Customer file opened.".
           display "Opening transaction file...".
           open input TRANSACTION-FILE.
           display "Transaction file opened.".

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
           display ":" with no advancing.
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
      -              "bye!"
               when other
                   display "Invalid option selected. Please try again."
                   perform DISPLAY-MENU
              end-evaluate.

       ADD-NEW-CUSTOMER.
      *    Generate new Customer ID
           move 0 to WS-CUST-ID.
           move 'N' to WS-EOF-FLAG.
           open input CUSTOMER-FILE.
           read CUSTOMER-FILE
               at end
                   move 0 to WS-CUST-ID
               not at end
                   perform until EOF-REACHED
                       if CUST-ID > WS-CUST-ID
                           move CUST-ID to WS-CUST-ID
                       end-if
                       read CUSTOMER-FILE
                           at end
                               move 'Y' to WS-EOF-FLAG
                       end-read
                   end-perform
           end-read.
           close CUSTOMER-FILE.
           add 1 to WS-CUST-ID.
           display "New Customer ID: " WS-CUST-ID.
           display "Enter Customer Name: ".
           accept WS-CUST-NAME.
           display "Enter Initial Balance: ".
           accept WS-CUST-BALANCE.

      *    Open Customer file or create if it doesn't exist.
           open extend CUSTOMER-FILE.
           if WS-CUSTOMER-STATUS not = '00'
               display "File doesn't exist. Creating new file."
               open output CUSTOMER-FILE
           end-if.

           move WS-CUST-ID to CUST-ID.
           move WS-CUST-NAME to CUST-NAME.
           move WS-CUST-BALANCE to CUST-BALANCE.
           write CUSTOMER-RECORD.
           close CUSTOMER-FILE.
           display "Customer added successfully.".
           perform DISPLAY-MENU.

       ADD-NEW-TRANSACTION.
      *    Generate new Transaction ID
           move 0 to WS-TRANS-ID.
           move 'N' to WS-EOF-FLAG.
           open input TRANSACTION-FILE.
           read TRANSACTION-FILE
               at end
                   move 0 to WS-TRANS-ID
                   move 'Y' to WS-EOF-FLAG
               not at end
                   perform until WS-EOF-FLAG = 'Y'
                       if TRANS-ID > WS-TRANS-ID
                           move TRANS-ID to WS-TRANS-ID
                       end-if
                       read TRANSACTION-FILE
                           at end
                               move 'Y' to WS-EOF-FLAG
                       end-read
                   end-perform
           end-read.
           close TRANSACTION-FILE.
           add 1 to WS-TRANS-ID.
           display "New Transaction ID: " WS-TRANS-ID.
           display "Enter Customer ID for Transaction: ".
           accept WS-TRANS-CUST-ID.
           display "Enter Transaction Amount: ".
           accept WS-TRANS-AMOUNT.
           move 'X' to WS-TRANS-TYPE.
           
           perform until 
              WS-TRANS-TYPE = 'D' 
              or WS-TRANS-TYPE = 'W' 
              or WS-TRANS-TYPE = 'd' 
              or WS-TRANS-TYPE = 'w'
              display "Enter Transaction Type ([D]eposit/[W]ithdraw): "
              accept WS-TRANS-TYPE
           end-perform.


      *    Check customer and update balance if possible, then write transaction
           open i-o CUSTOMER-FILE.
           move 'N' to WS-EOF-FLAG.
           move 0 to WS-CUST-BALANCE.
           perform until WS-EOF-FLAG = 'Y'
               read CUSTOMER-FILE
                   at end
                       move 'Y' to WS-EOF-FLAG
                       display "Customer not found."
                   not at end
                       if CUST-ID = WS-TRANS-CUST-ID
                           display "Customer ID found."
                           move CUST-BALANCE to WS-CUST-BALANCE
                           if WS-TRANS-TYPE = 'D' or WS-TRANS-TYPE = 'd'
                               add WS-TRANS-AMOUNT to WS-CUST-BALANCE
                               move WS-CUST-BALANCE to CUST-BALANCE
                               rewrite CUSTOMER-RECORD
                               move 'Y' to WS-EOF-FLAG
                               go to WRITE-TRANSACTION
                           else
                               if WS-TRANS-AMOUNT > WS-CUST-BALANCE
                                   display "Insufficient funds. Transaction cancelled."
                                   move 'Y' to WS-EOF-FLAG
                                   go to END-TRANSACTION
                               else
                                   subtract WS-TRANS-AMOUNT from WS-CUST-BALANCE
                                   move WS-CUST-BALANCE to CUST-BALANCE
                                   rewrite CUSTOMER-RECORD
                                   move 'Y' to WS-EOF-FLAG
                                   go to WRITE-TRANSACTION
                               end-if
                           end-if
                       end-if
               end-read
           end-perform.
           close CUSTOMER-FILE.

      END-TRANSACTION.
           display "Press Enter to return to menu.".
           accept WS-USER-CHOICE.
           perform DISPLAY-MENU.

      WRITE-TRANSACTION.
           open extend TRANSACTION-FILE.
           if WS-TRANSACTION-STATUS not = '00'
               display "Transaction file doesn't exist. Creating new file..."
               open output TRANSACTION-FILE
           end-if.
           move WS-TRANS-ID to TRANS-ID.
           move WS-TRANS-CUST-ID to TRANS-CUST-ID.
           move WS-TRANS-AMOUNT to TRANS-AMOUNT.
           move WS-TRANS-TYPE to TRANS-TYPE.
           write TRANSACTION-RECORD.
           close TRANSACTION-FILE.
           display "Transaction added successfully.".
           go to END-TRANSACTION.


       VIEW-CUSTOMER-ACCOUNTS.
           open input CUSTOMER-FILE.
           move 'N' to WS-EOF-FLAG.
           display "Customer Accounts:".
           display "-------------------".
           display "ID     Name                           Balance".
           display "--------------------------------------------------".
           read CUSTOMER-FILE
               at end
                   display "No customer records found."
               not at end
                   perform until EOF-REACHED
                       display CUST-ID " " CUST-NAME " " CUST-BALANCE
                       read CUSTOMER-FILE
                           at end
                               move 'Y' to WS-EOF-FLAG
                       end-read
                   end-perform
           end-read.
           close CUSTOMER-FILE.
           display "Press Enter to return to menu.".
           accept WS-USER-CHOICE.
           perform DISPLAY-MENU.

       VIEW-TRANSACTION-HISTORY.
           open input TRANSACTION-FILE.
           move 'N' to WS-EOF-FLAG.
           display "Transaction History:".
           display "---------------------".
           display "ID     Cust-ID   Amount      Type".
           display "--------------------------------------------------".
           read TRANSACTION-FILE
               at end
                   display "No transaction records found."
               not at end
                   perform until EOF-REACHED
                       if TRANS-TYPE = 'D' or TRANS-TYPE = 'd'
                           move 'Deposit' to DISPLAY-TRANS-TYPE
                       else
                           if TRANS-TYPE = 'W' or TRANS-TYPE = 'w'
                               move 'Withdrawal' to DISPLAY-TRANS-TYPE
                           else
                               move TRANS-TYPE to DISPLAY-TRANS-TYPE
                           end-if
                       end-if
                       display TRANS-ID " " TRANS-CUST-ID "    $" 
                       TRANS-AMOUNT " " DISPLAY-TRANS-TYPE
                       read TRANSACTION-FILE
                           at end
                               move 'Y' to WS-EOF-FLAG
                       end-read
                   end-perform
           end-read.
           close TRANSACTION-FILE.
           display "Press Enter to return to menu.".
           accept WS-USER-CHOICE.
           perform DISPLAY-MENU.
      
      