---
output: html_document
---

***

## Die Normalverteilung

Schreibweise:

$$ X \sim N(\mu, \sigma^2)$$

Die Normalverteilung ist eine stetige und um $\mu$ symmetrische Verteilung. Der Erwartungswert und die Varianz sind gegeben durch:

$$ \text{E}(X) = \mu \qquad\text{und}\qquad \text{Var}(X) = \sigma^2 $$

### Dichtefunktion

Die Dichtefunktion ist gegeben durch:

$$ f(x) = \frac{1}{\sqrt{2\pi}\sigma}\exp\left(-\frac{1}{2}\frac{(x - \mu)^2}{\sigma^2}\right) $$

### Verteilungsfunktion

Die Verteilungsfunktion ist definiert als:

$$ F(x) = P(X \leq x) = \int^{x}_{-\infty}f(t) dt $$

Der Wert der Verteilungsfunktion gibt an, mit welcher Wahrscheinlichkeit die 
Zufallsvariable $X$ einen Wert kleiner oder gleich $x$ annimmt.

### Quantilsfunktion

Die Quantilsfunktion gibt den Wert $x_p$ zurück, unterhalb dem $p$% der Wahrscheinlichkeitsmasse liegt. 
Formal ist die Quantilsfunktion die Umkehrfunktion der Verteilungsfunktion: 

$$ x_p = F^{-1}(p) = F^{-1}[P(X \leq x_p)] $$

---

### Excel Befehle

#### Dichte- bzw. Verteilungsfunktion der Normalverteilung

+ `=NORM.VERT`($x$; $\mu$; $\sigma$; **kumuliert**)

    + $x$ := Stelle $x$ an der die Funktion ausgewertet werden soll
    + $\mu$ := Mittelwert
    + $\sigma$ := Die Standardabweichung (nicht Varianz!)
    + kumuliert = 1 := Wert der Verteilungsfunktion (eine Wahrscheinlichkeit)
    + kumuliert = 0 := Wert der Dichtefunktion (keine Wahrscheinlichkeit!)

#### Dichte- bzw. Verteilungsfunktion der Standardnormalverteilung

+ `=NORM.S.VERT`($x$; **kumuliert**)

    + $x$ := Stelle $x$ an der die Funktion ausgewertet werden soll
    + kumuliert = 1 := Wert der Verteilungsfunktion (eine Wahrscheinlichkeit)
    + kumuliert = 0 := Wert der Dichtefunktion (keine Wahrscheinlichkeit!)

#### Quantilsfunktion der Normalverteilung

+ `=NORM.INV`($p$; $\mu$; $\sigma$)

    + $p$ := Eine Wahrscheinlichkeit
    + $\mu$ := Mittelwert
    + $\sigma$ := Standardabweichung (nicht Varianz!)

#### Quantilsfunktion der Standardnormalverteilung

+ `=NORM.S.INV`($p$)

    + $p$ := Eine Wahrscheinlichkeit
