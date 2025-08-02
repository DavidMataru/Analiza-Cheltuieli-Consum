# Model ARIMAX pentru analiza cheltuielilor medii de consum
# Data: 2015–2024, România
# Sursa datelor: Date_prelucrate.xlsx

# 1. Pachete

install.packages(c("readxl", "tseries", "forecast", "ggplot2", "gridExtra"))
library(readxl)
library(tseries)
library(forecast)
library(ggplot2)
library(gridExtra)

# 2. Citire date

date <- read_excel("C:/Analiza-Cheltuieli-Consum/data/Date_prelucrate.xlsx")

serie_Chelt <- ts(date$`Cheltuieli medii de consum - lei`, start = c(2015, 1), frequency = 4)
serie_Sal <- ts(date$`Salariul mediu net - lei/salariat`, start = c(2015, 1), frequency = 4)
serie_Infl <- ts(date$`Rata inflatiei %`, start = c(2015, 1), frequency = 4)

# 3. Test ADF

print("ADF pe seria originală Cheltuieli:")
print(adf.test(serie_Chelt))
print(adf.test(serie_Sal))
print(adf.test(serie_Infl))

# Diferențiere
diff2_Chelt <- diff(diff(serie_Chelt))
diff2_Sal <- diff(diff(serie_Sal))
diff2_Infl <- diff(diff(serie_Infl))

print("ADF după a doua diferențiere:")
print(adf.test(diff2_Chelt))
print(adf.test(diff2_Sal))
print(adf.test(diff2_Infl))

# 4. Model ARIMAX(0,2,1)

exog <- cbind(Salariu = serie_Sal, Inflatie = serie_Infl)
model_arimax <- Arima(serie_Chelt, order = c(0, 2, 1), xreg = exog)
summary(model_arimax)

# 5. Diagnosticare reziduuri (stil grafic unitar)

resid_arimax <- residuals(model_arimax)

# (1) Serie timp reziduuri
p1 <- autoplot(resid_arimax) +
  labs(title = "Reziduuri din regresia ARIMAX(0,2,1)", x = "Timp", y = "Reziduuri") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold")) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50")

# (2) ACF reziduuri
p2 <- ggAcf(resid_arimax, lag.max = 12) +
  labs(title = "ACF Reziduuri ARIMAX", x = "Lag", y = "ACF") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

# (3) Histogramă + densitate
p3 <- ggplot(data.frame(residuals = resid_arimax), aes(x = residuals)) +
  geom_histogram(aes(y = ..density..), bins = 20, fill = "#2C77BF", color = "white", alpha = 0.9) +
  geom_density(color = "#E63946", linewidth = 1.2) +
  labs(title = "Distribuția reziduurilor ARIMAX", x = "Reziduuri", y = "Densitate") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

# Test Ljung-Box
Box.test(resid_arimax, lag = 10, type = "Ljung-Box")

# Afișare grilă
grid.arrange(p1, p2, p3, nrow = 2)

# 6. Predicție ARIMAX

exog_future <- matrix(rep(tail(exog, 1), 4), nrow = 4, byrow = TRUE)
colnames(exog_future) <- c("Salariu", "Inflatie")
forecast_arimax <- forecast(model_arimax, h = 4, xreg = exog_future)

# Tabel predicții
trimestre <- c("Q1 2025", "Q2 2025", "Q3 2025", "Q4 2025")
predictii <- data.frame(
  Trimestru = trimestre,
  Cheltuieli_medii_prezise = round(as.numeric(forecast_arimax$mean), 2)
)
print(predictii)

# 7. Grafic predicții

istoric <- data.frame(
  Trimestru = seq(from = as.Date("2015-01-01"), by = "quarter", length.out = length(serie_Chelt)),
  Cheltuieli = as.numeric(serie_Chelt)
)
viitor <- data.frame(
  Trimestru = seq(from = as.Date("2025-01-01"), by = "quarter", length.out = 4),
  Cheltuieli = as.numeric(forecast_arimax$mean)
)
toate_datele <- rbind(istoric, viitor)

ggplot(toate_datele, aes(x = Trimestru, y = Cheltuieli)) +
  geom_line(color = "#1F77B4", size = 1.2) +
  geom_line(data = viitor, aes(x = Trimestru, y = Cheltuieli), color = "#FF7F0E", linetype = "dashed", size = 1.1) +
  geom_point(data = viitor, aes(x = Trimestru, y = Cheltuieli), color = "#FF7F0E", size = 2) +
  labs(
    title = "Previziune Cheltuieli Medii de Consum (ARIMAX 0,2,1)",
    x = "Trimestru", y = "Cheltuieli (lei)"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))
