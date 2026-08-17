# DST 334 Final Project - Minneapolis Near-Surface Temperature Regression
# Data: gridded meteorological reanalysis data, subset to the Minneapolis grid cell [108, 91]

load("data/data_training.RData")

## PART 1: Exploratory scatter plots ##
par(mfrow = c(3, 3))

plot(data_training$TLML[108, 91, ], data_training$ALBEDO[108, 91, ],
     main = "TLML vs ALBEDO", xlab = "TLML", ylab = "ALBEDO")
plot(data_training$TLML[108, 91, ], data_training$CLDHGH[108, 91, ],
     main = "TLML vs CLDHGH", xlab = "TLML", ylab = "CLDHGH")
plot(data_training$TLML[108, 91, ], data_training$CLDMID[108, 91, ],
     main = "TLML vs CLDMID", xlab = "TLML", ylab = "CLDMID")
plot(data_training$TLML[108, 91, ], data_training$CLDLOW[108, 91, ],
     main = "TLML vs CLDLOW", xlab = "TLML", ylab = "CLDLOW")
plot(data_training$TLML[108, 91, ], data_training$SWGDN[108, 91, ],
     main = "TLML vs SWGDN", xlab = "TLML", ylab = "SWGDN")
plot(data_training$TLML[108, 91, ], data_training$PRECTOT[108, 91, ],
     main = "TLML vs PRECTOT", xlab = "TLML", ylab = "PRECTOT")
plot(data_training$TLML[108, 91, ], data_training$QLML[108, 91, ],
     main = "TLML vs QLML", xlab = "TLML", ylab = "QLML")
plot(data_training$TLML[108, 91, ], data_training$SPEED[108, 91, ],
     main = "TLML vs SPEED", xlab = "TLML", ylab = "SPEED")
plot(data_training$TLML[108, 91, ], data_training$PRECSNO[108, 91, ],
     main = "TLML vs PRECSNO", xlab = "TLML", ylab = "PRECSNO")

## PART 2: Extract Minneapolis grid cell and build the correlation matrix ##
TLML_minneapolis    <- data_training$TLML[108, 91, ]
ALBEDO_minneapolis  <- data_training$ALBEDO[108, 91, ]
CLDHGH_minneapolis  <- data_training$CLDHGH[108, 91, ]
CLDMID_minneapolis  <- data_training$CLDMID[108, 91, ]
CLDLOW_minneapolis  <- data_training$CLDLOW[108, 91, ]
SWGDN_minneapolis   <- data_training$SWGDN[108, 91, ]
PRECTOT_minneapolis <- data_training$prectot[108, 91, ]
QLML_minneapolis    <- data_training$QLML[108, 91, ]
SPEED_minneapolis   <- data_training$speed[108, 91, ]
PRECSNO_minneapolis <- data_training$precsno[108, 91, ]

continuous_vars <- data.frame(
  TLML_minneapolis, ALBEDO_minneapolis, CLDHGH_minneapolis, CLDMID_minneapolis,
  CLDLOW_minneapolis, SWGDN_minneapolis, PRECTOT_minneapolis, QLML_minneapolis,
  SPEED_minneapolis, PRECSNO_minneapolis
)

cor_matrix <- cor(continuous_vars)
print(cor_matrix)

## PART 3: Model building ##

# Full model
model_v1 <- lm(TLML_minneapolis ~ ALBEDO_minneapolis + CLDHGH_minneapolis + SWGDN_minneapolis +
                 PRECTOT_minneapolis + QLML_minneapolis + SPEED_minneapolis)
summary(model_v1)

# Backward elimination
model_v2 <- lm(TLML_minneapolis ~ ALBEDO_minneapolis + CLDHGH_minneapolis +
                 PRECTOT_minneapolis + QLML_minneapolis + SPEED_minneapolis)
summary(model_v2)

# Final model: natural spline on humidity to capture nonlinearity
library(splines)
model_v3 <- lm(TLML_minneapolis ~ ALBEDO_minneapolis + CLDHGH_minneapolis +
                 PRECTOT_minneapolis + ns(QLML_minneapolis, df = 5) + SPEED_minneapolis)
summary(model_v3)

## PART 4: LINE assumption diagnostics on the final model ##

# LINEARITY
par(mfrow = c(3, 2))
plot(ALBEDO_minneapolis, residuals(model_v3), main = "Residuals vs ALBEDO", xlab = "ALBEDO", ylab = "Residuals")
plot(CLDHGH_minneapolis, residuals(model_v3), main = "Residuals vs CLDHGH", xlab = "CLDHGH", ylab = "Residuals")
plot(PRECTOT_minneapolis, residuals(model_v3), main = "Residuals vs PRECTOT", xlab = "PRECTOT", ylab = "Residuals")
plot(QLML_minneapolis, residuals(model_v3), main = "Residuals vs QLML", xlab = "QLML", ylab = "Residuals")
plot(SPEED_minneapolis, residuals(model_v3), main = "Residuals vs SPEED", xlab = "SPEED", ylab = "Residuals")

# INDEPENDENCE
plot(residuals(model_v3), type = "l")

# NORMALITY
qqnorm(residuals(model_v3))
qqline(residuals(model_v3), col = "red")
hist(residuals(model_v3), breaks = 20)

# EQUAL VARIANCE
plot(fitted(model_v3), residuals(model_v3), main = "Residuals vs Fitted Values", xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, col = "red")

## PART 5: Prediction on held-out data ##
data_prediction <- readRDS("data/data_prediction.RData")

TLML_minneapolis_pred    <- data_prediction$TLML[108, 91, ]
ALBEDO_minneapolis_pred  <- data_prediction$ALBEDO[108, 91, ]
CLDHGH_minneapolis_pred  <- data_prediction$CLDHGH[108, 91, ]
CLDMID_minneapolis_pred  <- data_prediction$CLDMID[108, 91, ]
CLDLOW_minneapolis_pred  <- data_prediction$CLDLOW[108, 91, ]
SWGDN_minneapolis_pred   <- data_prediction$SWGDN[108, 91, ]
PRECTOT_minneapolis_pred <- data_prediction$prectot[108, 91, ]
QLML_minneapolis_pred    <- data_prediction$QLML[108, 91, ]
SPEED_minneapolis_pred   <- data_prediction$speed[108, 91, ]
PRECSNO_minneapolis_pred <- data_prediction$precsno[108, 91, ]

data_pred <- data.frame(
  TLML_minneapolis = TLML_minneapolis_pred,
  ALBEDO_minneapolis = ALBEDO_minneapolis_pred,
  CLDHGH_minneapolis = CLDHGH_minneapolis_pred,
  CLDMID_minneapolis = CLDMID_minneapolis_pred,
  CLDLOW_minneapolis = CLDLOW_minneapolis_pred,
  SWGDN_minneapolis = SWGDN_minneapolis_pred,
  PRECTOT_minneapolis = PRECTOT_minneapolis_pred,
  QLML_minneapolis = QLML_minneapolis_pred,
  SPEED_minneapolis = SPEED_minneapolis_pred,
  PRECSNO_minneapolis = PRECSNO_minneapolis_pred
)
data_pred$QLML_spline <- ns(data_pred$QLML_minneapolis, df = 5)

predictions <- predict(model_v3, newdata = data_pred)
print(predictions)
