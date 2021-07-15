---
output: html_document
---

***

## Die stetige Gleichverteilung

Schreibweise:

$$ X \sim \text{SG}(a, b) \quad\text{mit}\quad a, b \in \mathbb{R}\quad\text{und}\quad a \neq b$$

Die stetige Gleichverteilung hängt von zwei Verteilungsparameter ab: $a$ die *untere Grenze*
und $b$ die *obere Grenze*. Der Erwartungswert und die Varianz sind gegeben durch:

$$ \text{E}(X) = \frac{b + a}{2} \qquad\text{und}\qquad \text{Var}(X) = \frac{(b - a)^2}{12} $$

### Dichtefunktion

Die Dichtefunktion ist gegeben durch:

$$ f(x) = \begin{cases} \frac{1}{b-a} & \text{für}\quad a \leq x \leq b \\\\ 0 & \text{sonst} \end{cases} $$

### Verteilungsfunktion

Die Verteilungsfunktion ist definiert als:

$$ F(x) = P(X \leq x) = \int^{x}_{-\infty} f(t) dt = \frac{x-a}{b-a} $$

Der Wert der Verteilungsfunktion gibt an, mit welcher Wahrscheinlichkeit die 
Zufallsvariable $X$ einen Wert kleiner oder gleich $x$ annimmt.

### Quantilsfunktion

Die Quantilsfunktion gibt den Wert $x_p$ zurück, unterhalb dem $p$% der Wahrscheinlichkeitsmasse liegt. 
Formal ist die Quantilsfunktion die Umkehrfunktion der Verteilungsfunktion:

$$ x_p = F^{-1}(p) = F^{-1}[P(X \leq x_p)] $$

---

### Excel Befehle

#### Dichte der stetigen Gleichverteilung

+ `=1/(b-a)`

    + $a$ := Untere Grenze
    + $b$ := Obere Grenze

#### Verteilungsfunktion der stetigen Gleichverteilung

+ `=(x-a)/(b-a)`

    + $x$ := Stelle $x$ an der die Funktion ausgewertet werden soll 
    + $a$ := Untere Grenze
    + $b$ := Obere Grenze

#### Quantilsfunktion der stetigen Gleichverteilung

+ `=a + (b-a)*p`

    + $p$ := Eine Wahrscheinlichkeit
    + $a$ := Untere Grenze
    + $b$ := Obere Grenze
