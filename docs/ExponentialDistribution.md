---
output: html_document
---

***

## Die Exponentialverteilung

Schreibweise:

$$ X \sim \text{Ex}(\alpha) \quad\text{mit}\quad \alpha \in \mathbb{R}^{>0} $$

Die Exponentialverteilung ist eine stetige Verteilung mir dem Verteilungsparameter $\alpha$.
Erwartungswert und Varianz sind gegeben durch:

$$ \text{E}(X) = \frac{1}{\alpha} \qquad\text{und}\qquad \text{Var}(X) = \frac{1}{\alpha^2} $$

### Dichtefunktion

Die Dichtefunktion ist gegeben durch:

$$ f(x) = \begin{cases} \alpha \exp(-\alpha x) & \text{für}\quad x \geq 0 \\\\
0 & \text{sonst} \end{cases} $$

### Verteilungsfunktion

Die Verteilungsfunktion ist definiert als:

$$ F(x) = P(X \leq x) = \int^{x}_{-\infty}f(t) dt $$

Der Wert der Verteilungsfunktion gibt an, mit welcher Wahrscheinlichkeit die 
Zufallsvariable $X$ einen Wert kleiner oder gleich $x$ annimmt.

### Quantilsfunktion

Die Quantilsfunktion gibt den Wert $x_p$ zurück, unterhalb dem $p$% der Wahrscheinlichkeitsmasse liegt. 
Formal ist die Quantilsfunktion die Umkehrfunktion der Verteilungsfunktion:

$$ x_p = F^{-1}(p) = F^{-1}[P(X \leq x_p)]$$

---

### Excel Befehle

#### Dichte- bzw. Verteilungsfunktion der Exponentialverteilung

+ `=EXPON.VERT`($x$; $\alpha$; **kumuliert**)

    + $x$ := Stelle $x$ an der die Funktion ausgewertet werden soll 
    + $\alpha$ := Verteilungsparameter (in Excel: $\alpha$ =  $\lambda$)
    + kumuliert = 1 := Wert der Verteilungsfunktion (eine Wahrscheinlichkeit)
    + kumuliert = 0 := Wert der Dichtefunktion (keine Wahrscheinlichkeit!)
