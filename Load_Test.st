// This program is setup to be a very stressful test for the PLC
// It performs large array initializations, matrix multiplications, and memory operations
// to stress test the PLC's CPU and memory handling capabilities.


PROGRAM PLC_LoadTest
VAR
    // Loop counters
    i, j, k : INT;
    // Variables for calculations
    sum, avg, temp : REAL;
    // Large matrices for multiplication
    matrixA : ARRAY[1..200, 1..200] OF REAL;
    matrixB : ARRAY[1..200, 1..200] OF REAL;
    matrixC : ARRAY[1..200, 1..200] OF REAL;
    // Large array for memory operations
    largeArray : ARRAY[1..100000] OF REAL;
END_VAR


// Initialize large matrices with pseudo-random values
FOR i := 1 TO 200 DO
    FOR j := 1 TO 200 DO
        // Fill matrixA with sine-based values
        matrixA[i, j] := SIN(REAL_TO_LREAL(i * j)) * 1000.0;
        // Fill matrixB with cosine-based values
        matrixB[i, j] := COS(REAL_TO_LREAL(i + j)) * 1000.0;
    END_FOR;
END_FOR;

// Initialize part of the large array with calculated values
FOR i := 1 TO 1000 DO
    largeArray[i] := SQRT(REAL_TO_LREAL(i)) * SIN(REAL_TO_LREAL(i / 1000.0));
END_FOR;



// Perform heavy matrix multiplication: matrixC = matrixA * matrixB
FOR i := 1 TO 200 DO
    FOR j := 1 TO 200 DO
        sum := 0.0;
        FOR k := 1 TO 200 DO
            // Multiply and accumulate for matrix multiplication
            sum := sum + matrixA[i, k] * matrixB[k, j];
        END_FOR;
        matrixC[i, j] := sum;
    END_FOR;
END_FOR;



// Perform additional memory operations (sorting-like swaps)
// This loop performs a single pass of adjacent swaps if out of order
FOR i := 1 TO 999 DO
    IF largeArray[i] > largeArray[i + 1] THEN
        // Swap values
        temp := largeArray[i];
        largeArray[i] := largeArray[i + 1];
        largeArray[i + 1] := temp;
    END_IF;
END_FOR;



// Compute average to keep compiler from optimizing away loops
// Sums the first 1000 elements of largeArray
sum := 0.0;
FOR i := 1 TO 1000 DO
    sum := sum + largeArray[i];
END_FOR;
// Calculate average (note: divisor is 100000, the full array size)
avg := sum / 100000.0;


END_PROGRAM

