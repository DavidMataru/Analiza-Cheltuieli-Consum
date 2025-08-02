# Regresie multiplă pentru analiza cheltuielilor medii de consum
# Data: 2015–2024, România
# Sursa datelor: Date_prelucrate.xlsx

# 1. Instalarea bibliotecii "readxl" pentru citirea sursei de date
install.packages("readxl")
library(readxl)

# 2. Citirea datelor
date <- read_excel("C:/Analiza-Cheltuieli-Consum/data/Date_prelucrate.xlsx")

# 3. Calcularea statisticilor descriptive

# Instalarea bibliotecii "moments"
install.packages("moments")
library(moments)

serie_Chelt <- ts(date$`Cheltuieli medii de consum - lei`, start=c(2015, 1), end=c(2024, 4), frequency=4)
summary(serie_Chelt)
sd(date$`Cheltuieli medii de consum - lei`)  # Devierea standard
IQR(date$`Cheltuieli medii de consum - lei`) # Interval interquartil
skewness(date$`Cheltuieli medii de consum - lei`)  # Asimetrie
kurtosis(date$`Cheltuieli medii de consum - lei`)  # Coef. de aplatizare

serie_Sal <- ts(date$`Salariul mediu net - lei/salariat`, start=c(2015, 1), end=c(2024, 4), frequency=4)
summary(serie_Sal)
sd(date$`Salariul mediu net - lei/salariat`)  # Devierea standard
IQR(date$`Salariul mediu net - lei/salariat`) # Interval interquartil
skewness(date$`Salariul mediu net - lei/salariat`)  # Asimetrie
kurtosis(date$`Salariul mediu net - lei/salariat`)  # Coef. de aplatizare

serie_Infl <- ts(date$`Rata inflatiei %`, start=c(2015, 1), end=c(2024, 4), frequency=4)
summary(serie_Infl)
sd(date$`Rata inflatiei %`)  # Devierea standard
IQR(date$`Rata inflatiei %`) # Interval interquartil
skewness(date$`Rata inflatiei %`)  # Asimetrie
kurtosis(date$`Rata inflatiei %`)  # Coef. de aplatizare

# 4. Testarea stationaritatii

install.packages("tseries")
library(tseries)

adf_cheltuieli <- adf.test(date$`Cheltuieli medii de consum - lei`, alternative = "stationary")
adf_salariu <- adf.test(date$`Salariul mediu net - lei/salariat`, alternative = "stationary")
adf_inflatie <- adf.test(date$`Rata inflatiei %`, alternative = "stationary")
print(adf_cheltuieli)
print(adf_salariu)
print(adf_inflatie)

# 5. Prima diferentiere (seriile nu sunt stationare)

# Calculeaza diferentele
date_diff <- data.frame(
  Cheltuieli_diff = diff(date$`Cheltuieli medii de consum - lei`),
  Salariu_diff = diff(date$`Salariul mediu net - lei/salariat`),
  Inflatie_diff = diff(date$`Rata inflatiei %`)
)

adf_cheltuieli_diff <- adf.test(date_diff$Cheltuieli_diff, alternative = "stationary")
adf_salariu_diff <- adf.test(date_diff$Salariu_diff, alternative = "stationary")
adf_inflatie_diff <- adf.test(date_diff$Inflatie_diff, alternative = "stationary")
print(adf_cheltuieli_diff)
print(adf_salariu_diff)
print(adf_inflatie_diff)

# 6. A doua diferentiere
date_diff2 <- data.frame(
  Cheltuieli_diff2 = diff(date_diff$Cheltuieli_diff),
  Salariu_diff2 = diff(date_diff$Salariu_diff),
  Inflatie_diff2 = diff(date_diff$Inflatie_diff)
)

adf_cheltuieli_diff2 <- adf.test(date_diff2$Cheltuieli_diff2, alternative = "stationary")
adf_salariu_diff2 <- adf.test(date_diff2$Salariu_diff2, alternative = "stationary")
adf_inflatie_diff2 <- adf.test(date_diff2$Inflatie_diff2, alternative = "stationary")
print(adf_cheltuieli_diff2)
print(adf_salariu_diff2)
print(adf_inflatie_diff2)

# 7. Model de regresie liniara multipla

model_diff2 <- lm(Cheltuieli_diff2 ~ Salariu_diff2 + Inflatie_diff2, data = date_diff2)
summary(model_diff2)

# 8. Testarea ipotezelor statistice, pe baza modelului

par(mfrow = c(2,2))
plot(model_diff2)

# 9. Testarea multicoliniaritatii - coeficientul VIF

library(car)
VIF_model_diff2 <- vif(model_diff2)
VIF_model_diff2
plot(VIF_model_diff2)

# 10. Realizarea unei predictii pe baza modelului de regresie multipla

# Estimari ipotetice diferentiate de ordin 2
Salariu_diff2_pred <- c(30, 35, 40, 38)
Inflatie_diff2_pred <- c(0.2, 0.1, -0.05, 0.0)

# Pregatire date noi pentru predictie
newdata <- data.frame(Salariu_diff2 = Salariu_diff2_pred, Inflatie_diff2 = Inflatie_diff2_pred)

# Predictii diferentiate (diff2)
predictii_diff2 <- predict(model_diff2, newdata = newdata)

# Reconstructie serie:
C_t_minus_2 <- tail(date$`Cheltuieli medii de consum - lei`, 2)[1]
C_t_minus_1 <- tail(date$`Cheltuieli medii de consum - lei`, 2)[2]

delta1 <- C_t_minus_1 - C_t_minus_2
diff1_pred <- delta1 + cumsum(predictii_diff2)
cheltuieli_pred <- C_t_minus_1 + cumsum(diff1_pred)

# Etichetare trimestre
trimestre <- c("2025 Q1", "2025 Q2", "2025 Q3", "2025 Q4")

# Tabel final cu rezultate si afisare
df_pred <- data.frame(
  Trimestru = trimestre,
  `Cheltuieli medii previzionate (lei)` = round(cheltuieli_pred, 2)
)

print("Previziuni pentru Cheltuieli medii de consum:")
print(df_pred)

