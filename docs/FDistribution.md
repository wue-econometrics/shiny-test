---
output: html_document
---

***

## Die F-Verteilung

Schreibweise:

$$ X \sim F_{k_1, k_2} \quad\text{mit}\quad k_1, k_2 \in \mathbb{R}^{>0} $$

Die F-Verteilung ist eine stetige Verteilung mit $k_1$ *Zähler-*
und $k_2$ *Nennerfreiheitsgraden*. Erwartungswert und Varianz sind gegeben durch:

$$ \text{E}(X) = \frac{k_2}{k_2 - 2}\quad\text{für}\quad k_2 > 2 \qquad\text{und}\qquad \text{Var}(X) = \frac{2k_2^2(k_1 + k_2 - 2)}{k_1(k_2 - 2)^2(k_2 - 4)}\quad\text{für}\quad k_2 > 4 $$

### Dichtefunktion

Die Dichtefunktion ist gegeben durch:

$$ f(x) = \begin{cases}
k_1^{\frac{k_1}{2}}k_2^{\frac{k_2}{2}}\cdot \frac{\Gamma\left(\frac{k_1}{2} + \frac{k_2}{2}\right)}{\Gamma\left(\frac{k_1}{2}\right)\cdot\Gamma\left(\frac{k_2}{2}\right)}\cdot
\frac{x^{\frac{k_1}{2}-1}}{(k_1x + k_2)^{\frac{k_1 + k_2}{2}}} & \text{für}\quad x \geq 0 \\\\
0 & \text{sonst}
\end{cases} $$

wobei $\Gamma(x) = \int^{+\infty}_0 t^{x-1}e^{-t} dt$ die Gammafunktion an der Stelle
$x$ bezeichnet.

Motivieren lässt sich die F-Verteilung alternativ durch die Tatsache, dass der
Quotient zweier $\chi^2$-verteilten Zufallsvariaben, jeweils geteilt durch deren
Freiheitsgrade gerade einer F-Verteilung folgt. Die F-Verteilung wird daher meist
definiert als:

$$ F_{k_1, k_2} = \frac{\frac{\chi^2_{k_1}}{k_1}}{\frac{\chi^2_{k_2}}{k_2}} = 
\frac{\chi^2_{k_1}}{\chi^2_{k_2}}\cdot \frac{k_2}{k_1}$$

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

#### Dichte- bzw. Verteilungsfunktion der F-Verteilung

+ `=F.VERT`($x$; $k_1$; $k_2$; **kumuliert**)

    + $x$ := Stelle $x$ an der die Funktion ausgewertet werden soll 
    + $k_1$ := Anzahl Zählerfreiheitsgrade
    + $k_2$ := Anzahl Nennerfreiheitsgrade
    + kumuliert = 1 := Wert der Verteilungsfunktion (eine Wahrscheinlichkeit)
    + kumuliert = 0 := Wert der Dichtefunktion (keine Wahrscheinlichkeit!)

#### Rechte Endfläche der F-Verteilung 

+ `=F.VERT.RE`($x$; $k_1$; $k_2$)

    + $x$ := Stelle $x$ an der die Funktion ausgewertet werden soll 
    + $k_1$ := Anzahl Zählerfreiheitsgrade
    + $k_2$ := Anzahl Nennerfreiheitsgrade
    
Die Funktion `F.VERT.RE` berechnet: $P(X \ge x)$

#### Quantilsfunktion der F-Verteilung

+ `=F.INV`($p$; $k_1$; $k_2$)

    + $p$ := Eine Wahrscheinlichkeit
    + $k_1$ := Anzahl Zählerfreiheitsgrade
    + $k_2$ := Anzahl Nennerfreiheitsgrade

#### Rechtseitiges Quantil der F-Verteilung

+ `=F.INV.RE`($p$; $k_1$; $k_2$)

    + $p$ := Eine Wahrscheinlichkeit
    + $k_1$ := Anzahl Zählerfreiheitsgrade
    + $k_2$ := Anzahl Nennerfreiheitsgrade
    
Die Funktion `F.INV.RE` berechnet: $x = F^{-1}[P(X > x)] = F^{-1}[1 - P(X \leq x)]$
