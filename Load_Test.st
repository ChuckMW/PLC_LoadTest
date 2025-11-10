//This program is setup to be a very stressful test for the PLC


PROGRAM PLC_LoadTest
VAR
    i, j, k : INT;
    sum, avg, temp : REAL;
    matrixA : ARRAY[1..200, 1..200] OF REAL;
    matrixB : ARRAY[1..200, 1..200] OF REAL;
    matrixC : ARRAY[1..200, 1..200] OF REAL;
    largeArray : ARRAY[1..100000] OF REAL;
END_VAR


// Initialize large arrays with pseudo-random values
FOR i := 1 TO 200 DO
    FOR j := 1 TO 200 DO
        matrixA[i, j] := SIN(REAL_TO_LREAL(i * j)) * 1000.0;
        matrixB[i, j] := COS(REAL_TO_LREAL(i + j)) * 1000.0;
    END_FOR;
END_FOR;

FOR i := 1 TO 1000 DO
    largeArray[i] := SQRT(REAL_TO_LREAL(i)) * SIN(REAL_TO_LREAL(i / 1000.0));
END_FOR;



// Perform heavy matrix multiplication
FOR i := 1 TO 200 DO
    FOR j := 1 TO 200 DO
        sum := 0.0;
        FOR k := 1 TO 200 DO
            sum := sum + matrixA[i, k] * matrixB[k, j];
        END_FOR;
        matrixC[i, j] := sum;
    END_FOR;
END_FOR;



// Perform additional memory operations (sorting-like swaps)
FOR i := 1 TO 999 DO
    IF largeArray[i] > largeArray[i + 1] THEN
        temp := largeArray[i];
        largeArray[i] := largeArray[i + 1];
        largeArray[i + 1] := temp;
    END_IF;
END_FOR;



// Compute average to keep compiler from optimizing away loops
sum := 0.0;
FOR i := 1 TO 1000 DO
    sum := sum + largeArray[i];
END_FOR;
avg := sum / 100000.0;


END_PROGRAM

