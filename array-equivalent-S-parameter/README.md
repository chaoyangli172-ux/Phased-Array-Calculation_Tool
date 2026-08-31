# Equivalent S-Parameter Analysis for Antenna Arrays

When analyzing the **S-parameters of an antenna array**, the S-parameter of a single port cannot directly and accurately represent the overall performance of the entire array.

To address this issue, this repository provides an **equivalent S-parameter algorithm** for evaluating the overall S-parameter performance of an antenna array.

## Workflow

### 1. Export Active S-Parameters from HFSS

First, export the **active S-parameter of every port in dB** from HFSS and save the results as a CSV file.

An example of the required CSV format is provided in this repository.

The exported data should contain the active S-parameter corresponding to each array port under the required excitation/beamforming conditions.

### 2. Calculate the Equivalent Array S-Parameter

Run the provided **MATLAB script** after importing the exported CSV file.

The MATLAB algorithm processes the active S-parameter data from all ports and calculates the **equivalent S-parameter of the entire antenna array**.

The resulting equivalent S-parameter can then be used to evaluate the overall RF performance of the array more accurately.

## Why Equivalent S-Parameters?

For a large phased array, the S-parameter measured or calculated at a single port does not necessarily reflect the behavior of the entire array, especially when:

* Multiple ports are excited simultaneously
* Beamforming phase shifts are applied
* Amplitude tapering is used
* Mutual coupling between array elements is significant
* The active impedance varies with scan angle

HFSS can also provide **Accepted Power** in the antenna parameters report, which is useful for evaluating the array's power performance.

However, the equivalent S-parameter provides a more intuitive representation of the array's overall matching performance and makes it easier to analyze and compare the RF behavior of the array under different beamforming conditions.

## Summary

The recommended workflow is:

```text
HFSS
  │
  ├── Export active S-parameter of all ports
  │
  ▼
CSV File
  │
  ▼
MATLAB Equivalent S-Parameter Algorithm
  │
  ▼
Equivalent S-Parameter of the Entire Array
  │
  ▼
Array-Level RF Performance Analysis
```

This method is intended for **large phased-array and multi-port antenna systems**, where evaluating the S-parameter of individual ports alone is insufficient to characterize the overall array performance.
