---
title: "Calibration Report"
output: pdf_document
params:
  slope: NA
  intercept: NA
  r_squared: NA
  lod: NA
  loq: NA
  p_slope: NA
  p_intercept: NA
---

## Linear Regression Summary

This report summarizes the results of a linear regression calibration model.

### Model Coefficients

- **Slope**: 0.9
- **Intercept**: 3.3333333
- **R-squared**: 0.9959016

### Detection Limits

- **Limit of Detection (LOD)**: 2.116951
- **Limit of Quantification (LOQ)**: 6.415003

### Statistical Significance

- **P-value (Slope)**: 0.0407833
- **P-value (Intercept)**: 0.2279347


## Calibration Plot

![Regression curve](regression_plot.png){width=100%, height=100%}



## Residuals Plot

![Residuals](residual_plot.png){width=100%, height=100%}



