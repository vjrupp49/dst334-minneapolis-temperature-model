### Minneapolis Near-Surface Temperature Regression Model

Statistical modeling final project for DST 334, Fall 2024-2025. Builds and validates a multiple regression model predicting near-surface air temperature (TLML) in Minneapolis from a set of meteorological reanalysis variables (cloud cover, precipitation, humidity, wind speed, and surface reflectivity).

#### Data

Gridded meteorological reanalysis data (a MERRA-2-style dataset), subset to the Minneapolis grid cell. Variables used: TLML (temperature at the lowest model level, the target), ALBEDO, CLDHGH/CLDMID/CLDLOW (high/mid/low cloud fraction), SWGDN (surface downward shortwave flux), PRECTOT (total precipitation), QLML (specific humidity), SPEED (wind speed), and PRECSNO (snowfall rate).

#### Approach

1. Exploratory scatter plots of each predictor against TLML, and a full correlation matrix to check for multicollinearity.
2. An initial multiple regression model (`model_v1`) using all candidate predictors.
3. Backward elimination to drop non-significant predictors (`model_v2`).
4. A natural spline term on humidity (QLML) to capture a nonlinear relationship (`model_v3`), the final model.
5. Full LINE assumption testing on the final model: linearity (residuals vs. each predictor), independence (residuals in sequence), normality (Q-Q plot, residual histogram), and equal variance (residuals vs. fitted values).
6. Out-of-sample prediction on a held-out prediction dataset using the final model.

#### Files

`analysis.R` - full R script: data loading, correlation matrix, all three model iterations, LINE assumption diagnostics, and final prediction.

#### Tech

R (base `lm`, `splines`)
