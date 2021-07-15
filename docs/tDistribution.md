---
output: html_document
---

***

## Die t-Verteilung

Schreibweise:

$$ X \sim t_k \quad\text{mit}\quad k \in \mathbb{R}^{>0}$$

Die t-Verteilung ist eine stetige und symmetrische Verteilung mit $k$ *Freiheitsgraden*.
Die Form der t-Verteilung ist nur durch die Anzahl der Freiheitsgrade bestimmt.
Der Erwartungswert und die Varianz sind gegeben durch:

$$ \text{E}(X) = 0 \qquad\text{und}\qquad \text{Var}(X) = \frac{k}{k - 2}\quad\text{für}\quad k > 2 $$

### Dichtefunktion

Die Dichtefunktion ist gegeben durch:

$$ f(x) = \frac{\Gamma\left(\frac{k + 1}{2}\right)}{\sqrt{k\pi}\Gamma\left(\frac{k}{2}\right)}
\left( 1 + \frac{x^2}{k} \right)^{- \frac{k + 1}{2}} $$

wobei $\Gamma(x) = \int^{+\infty}_0 t^{x-1}e^{-t} dt$ die Gammafunktion an der Stelle
$x$ bezeichnet. Für $k\to\infty$ strebt die t-Verteilung gegen die Standardnormalverteilung, d.h.

$$ t_k \overset{d}{\longrightarrow} N(0, 1) $$

Faustregel: für $k \geq 30$ kann die t-Verteilung relativ gut durch die
Standardnormalverteilung approximiert werden.

Motivieren lässt sich die t-Verteilung auch als Spezialfall der F-Verteilung, 
denn falls

$$ \frac{\chi^2_1/1}{\chi^2_{k_2}/k_2} = X \sim F(1, k_2) $$

dann gilt

$$ \frac{Z}{\sqrt{\chi^2_{k_2}/k_2}} \sim t_k $$

wobei $Z \sim N(0,1)$. Symbolisch entspricht $Z$ der Wurzel aus einer $\chi^2_1$ Verteilung, sprich $Z = \sqrt{\chi^2_1}$. 
Analog entspricht die Wurzel aus $X$ gerade $\frac{Z}{\sqrt{\chi^2_{k_2}/k_2}}$. 
Allerdings ist die Notation symbolisch zu verstehen. Werden beispielsweise $n$ zufällige Wert 
aus $X$ gezogen und **anschließend** jeweils deren Wurzel gezogen, dann folgt diese **nicht** einer t-Verteilung!

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

#### Dichte- bzw. Verteilungsfunktion der t-Verteilung

+ `=T.VERT`($x$; $k$; **kumuliert**)

    + $x$ := Stelle $x$ an der die Funktion ausgewertet werden soll 
    + $k$ := Anzahl Freiheitsgrade
    + kumuliert = 1 := Wert der Verteilungsfunktion (eine Wahrscheinlichkeit)
    + kumuliert = 0 := Wert der Dichtefunktion (keine Wahrscheinlichkeit!)

#### Rechte Endfläche der t-Verteilung 

+ `=T.VERT.RE`($x$; $k$)

    + $x$ := Ein x-Wert
    + $k$ := Anzahl Freiheitsgrade
    
Die Funktion `T.VERT.RE` berechnet: $P(X \geq x)$

#### Linke und rechte Enfläche der t-Verteilung

+ `=T.VERT.2S`($x$; $k$)

    + $x$ := Stelle $x$ an der die Funktion ausgewertet werden soll
    + $k$ := Anzahl Freiheitsgrade

Die Funktion `T.VERT.2S` berechnet: $P(|X| \geq x) = P(X \leq -x) + P(X \geq x)$

#### Quantilsfunktion der t-Verteilung

+ `=T.INV`($p$; $k$)

    + $p$ := Eine Wahrscheinlichkeit
    + $k$ := Anzahl Freiheitsgrade

#### Zweiseitige Quantile der t-Verteilung

+ `=T.INV.2S`($p$; $k$)

    + $p$ := Eine Wahrscheinlichkeit
    + $k$ := Anzahl Freiheitsgrade
    
Die Funktion `T.INV.2S` berechnet: $x =  F^{-1}[P(|X| > x)]$

----

**Bemerkung**

1.  `T.VERT.RE` = `1 - T.VERT(...; WAHR)`
1.  `T.VERT.2S` = `2*(1 - T.VERT(...; WAHR))`

denn aufgrund der Symmetrie der t-Verteilung gilt:

$$\begin{align}
P(X \geq x) &= 1 - P(X \leq x) \\\\
P(|X| \leq x) &= P(X \leq -x) + P(X \geq x) = 1 - P(X \leq x) + (1 - P(X \leq x)) = 2(1 - P(X \leq x)) 
\end{align}$$
