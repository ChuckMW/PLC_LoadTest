# PLC Load Test

A deliberately heavy IEC 61131-3 Structured Text (ST) program designed to stress test a PLC's CPU and memory handling capabilities.

## Overview

`PLC_LoadTest` exercises a PLC by performing large array initializations, an O(n³) matrix multiplication, and memory-intensive array operations. It is intended as a stress/benchmark test rather than production logic.

## What It Does

1. **Matrix initialization** — Fills two 200×200 `REAL` matrices with pseudo-random values derived from sine and cosine functions.
2. **Array initialization** — Populates part of a 100,000-element `REAL` array with square-root/sine-derived values.
3. **Matrix multiplication** — Computes `matrixC = matrixA * matrixB`, a triple-nested loop performing 200 × 200 × 200 = **8,000,000** multiply-accumulate operations.
4. **Memory operations** — Runs a single bubble-sort pass (adjacent swaps) over the first 999 elements of the large array.
5. **Checksum/anti-optimization** — Sums the first 1,000 elements and computes an average so the compiler cannot eliminate the loops.

## Variables

| Name | Type | Purpose |
| --- | --- | --- |
| `i, j, k` | `INT` | Loop counters |
| `sum, avg, temp` | `REAL` | Calculation and swap temporaries |
| `matrixA`, `matrixB` | `ARRAY[1..200, 1..200] OF REAL` | Input matrices |
| `matrixC` | `ARRAY[1..200, 1..200] OF REAL` | Result matrix |
| `largeArray` | `ARRAY[1..100000] OF REAL` | Memory-operation buffer |

## Resource Notes

- **Memory footprint** — The three 200×200 matrices consume ~480 KB (assuming 4-byte `REAL`), and the large array consumes ~400 KB. Total ~880 KB.
- **Execution time** — Dominated by the matrix multiplication (8M iterations). Runtime scales with the target PLC's processing power.
- **Watchdog risk** — Because everything runs in a single scan, a PLC with a short cycle watchdog may fault. Consider splitting the work across scan cycles or disabling the watchdog during the test.

## Usage

1. Import `PLC_LoadTest` into a compatible IEC 61131-3 environment (e.g. CODESYS, TwinCAT, Beckhoff, Siemens with ST support).
2. Compile and download to the target device.
3. Call/run the program once and measure scan time, cycle overruns, and CPU temperature.
4. Observe whether the PLC completes the scan or triggers a watchdog timeout.

## Notes

- `REAL_TO_LREAL` conversions are used in initialization to widen values before the transcendental functions. Depending on the target, `SIN`/`COS`/`SQRT` may operate on `LREAL` (64-bit) while the matrices store 32-bit `REAL`.
- The final average divides by `100000.0` (the full array size) although only the first 1,000 elements are summed. This is intentional per the original code and does not affect the stress-test purpose.

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.
