# Analiza cheltuielilor medii de consum în funcție de salariul mediu net și rata inflației

Acest proiect personal aplică metode statistice și econometrice pentru a analiza modul în care **salariul mediu net** și **rata inflației** influențează **cheltuielile medii de consum ale gospodăriilor** din România, în perioada **2015–2024**.

Scopul proiectului este atât explicativ (identificarea relațiilor dintre variabile), cât și predictiv (estimarea valorilor viitoare ale consumului), folosind modele de regresie multiplă și modele de tip ARIMAX.

## Structura repository-ului

- `Analiza-Cheltuieli-Consum/`
  - `data/`
    - `Date_prelucrate.xlsx`                                *(Fișierul cu datele (2015-2024))*
  - `scripts/`
    - `Regresie_multipla.R`                                 *(Codul R pentru regresie multiplă)*
    - `Model_ARIMAX.R`                                      *(Codul R pentru modelul ARIMAX (0,2,1))*
  - `Analiza_cheltuieli_medi_de_consum.pdf`                 *(Document rezumativ cu rezultate și concluzii)*
  - `.gitignore`
  - `README.md`                                             *(Acest fișier)*


### Metodologie aplicată

- **Regresie multiplă**:
  - Verificarea corelației dintre variabile
  - Testarea semnificației statistice a coeficienților
  - Evaluarea reziduurilor (normalitate, homoscedasticitate, influență)

- **Model ARIMAX (0,2,1)**:
  - Verificarea staționarității cu ADF
  - Încorporarea variabilelor exogene (salariu și inflație)
  - Diagnosticare reziduuri și validare model
  - Previziuni pentru următoarele 4 trimestre (2025)

####  Rezultate

- Regresia multiplă arată o corelație pozitivă între salariu și consum, dar semnificația coeficienților este moderată.
- Modelul ARIMAX oferă rezultate robuste și valide pentru prognoză, cu un AIC competitiv și reziduuri distribuite aproape normal.
- Predicțiile pentru cheltuielile medii de consum în 2025 indică o tendință de creștere, în concordanță cu traiectoria salariului net.

#####  Scopul proiectului

Acest proiect a fost realizat cu scop educațional și demonstrativ, pentru a fi inclus într-un portofoliu profesional (GitHub / LinkedIn). El reflectă abilități de:

- Programare în R
- Analiză de date economice
- Modelare statistică și previziuni
- Redactare tehnică și interpretare economică

###### Bibliografie sugerată

- Keynes, J. M. (1936). *The General Theory of Employment, Interest and Money*. Palgrave Macmillan.
- INSSE – Institutul Național de Statistică (2024). *Date statistice trimestriale*. Disponibil la: https://insse.ro
- R Core Team (2023). *R: A Language and Environment for Statistical Computing*. Vienna, Austria: R Foundation for Statistical Computing. Disponibil la: https://www.R-project.org/
- Gujarati, D. N. (2009). *Basic Econometrics* (5th ed.). McGraw-Hill. (Fragment utilizat pentru regresie multiplă)
- Brooks, C. (2019). *Introductory Econometrics for Finance* (4th ed.). Cambridge University Press. (Secțiuni despre modele ARIMA)
- Cod R și prelucrare proprie – autorul proiectului


!! Autor !!

Proiect personal realizat de David-Cristian Mătaru  
Data: 2025

Licență

Acest proiect este unul **personal**, realizat în scop educațional și de portofoliu.  
Codul și datele pot fi consultate liber pentru învățare sau inspirație, dar **nu sunt destinate reutilizării comerciale sau publicării fără acordul autorului**.
Dacă dorești să folosești elemente din proiect în scopuri academice sau profesionale, te rog să mă contactezi în prealabil.
