---
output: html_document
---

***

## Die $\chi^2$-Verteilung

Schreibweise:

$$ X \sim \chi^2_k \quad\text{mit}\quad k \in \mathbb{R}^{>0} $$

Die $\chi^2$-Verteilung ist eine stetige Verteilung mit $k$ *Freiheitsgraden*. 
Erwartungswert und Varianz sind gegeben durch:

$$ \text{E}(X) = k \qquad\text{und}\qquad \text{Var}(X) = 2k $$

### Dichtefunktion

Die Dichtefunktion ist gegeben durch:

$$ f(x) = \begin{cases}
\frac{x^{\frac{k}{2} - 1} \exp{-\frac{x}{2}}}{2^{\frac{k}{2}}\Gamma\left(\frac{k}{2}\right)} & \text{für}\quad x > 0 \\\\
0 & \text{sonst}
\end{cases} $$

wobei $\Gamma(x) = \int^{+\infty}_0 t^{x-1}e^{-t} dt$ die Gammafunktion an der Stelle
$x$ bezeichnet.

Motivieren lässt sich die $\chi^2$-Verteilung alternativ durch die Tatsache, dass eine *Summe
an stochastisch unabhängigen, quadrierten standardnormalverteilten Zufallsvariablen* gerade einer
$\chi^2$-Verteilung mit $k$ Freiheitsgraden folgt. Dabei ist $k$ die Anzahl der Summenglieder. 
Es gilt daher:

$$ \sum^k_{i = 1} z^2_i \sim \chi^2_k \quad\text{mit}\quad z_i \sim N(0,1)\quad\text{und}\quad\text{Cov}(z_i,z_j) = 0 \quad\forall i\neq j $$

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

#### Dichte- bzw. Verteilungsfunktion der $\chi^2$-Verteilung

+ `=CHIQU.VERT`($x$; $k$; **kumuliert**)

    + $x$ := Stelle $x$ an der die Funktion ausgewertet werden soll 
    + $k$ := Anzahl Freiheitsgrade
    + kumuliert = 1 := Wert der Verteilungsfunktion (eine Wahrscheinlichkeit)
    + kumuliert = 0 := Wert der Dichtefunktion (keine Wahrscheinlichkeit!)

#### Rechte Endfläche der $\chi^2$-Verteilung

+ `=CHIQU.VERT.RE`($x$; $k$)

    + $x$ := Stelle $x$ an der die Funktion ausgewertet werden soll 
    + $k$ := Anzahl Freiheitsgrade
        
Die Funktion `CHIQU.VERT.RE` berechnet: $P(X \ge x)$

#### Quantilsfunktion der $\chi^2$-Verteilung

+ `=CHIQU.INV`($p$; $k$)

    + $p$ := Eine Wahrscheinlichkeit
    + $k$ := Anzahl Freiheitsgrade
    

#### Zweiseitige Quantile der $\chi^2$-Verteilung

+ `=CHIQU.INV.RE`($p$; $k$)

    + $p$ := Eine Wahrscheinlichkeit
    + $k$ := Anzahl Freiheitsgrade
   
Die Funktion `CHIQU.INV.RE` berechnet: $x = F^{-1}[P(X > x)] = F^{-1}[1 - P(X \leq x)]$
