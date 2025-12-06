       identification division.
       program-id. DataTypesExample.
       
       data division.
       working-storage section.
       01 NumericData PIC 9(5).
       01 AlphaNumericData PIC X(30).
       01 AlphabeticData PIC A(20).
       01 SignedData PIC S9(5).
       01 DecimalData PIC 9(3)V9(2).

       procedure division.
           move 12345 TO NumericData.
           move 'Hello, world!' to AlphabeticData.
           move 'abc123' TO AlphaNumericData.
           move -987 to SignedData.
           move 123.45 to DecimalData.

           display "Numeric Data: ", NumericData.
           display "Alphanumeric Data: ", AlphaNumericData.
           display "Alphabetic Data: ", AlphabeticData.
           display "Signed Data: ", SignedData.
           display "Decimal Data: ", DecimalData.

           stop run.
