---
output: html_document
---

***

## Die Binomialverteilung

Schreibweise:
  
  $$ X \sim \text{B}(n, p) \quad\text{mit}\quad n \in \mathbb{N} \quad\text{und}\quad 0 \leq p \leq 1 $$
  
Die Binomialverteilung ist eine diskrete Verteilung mit den Verteilungsparametern $n$ und $p$, wobei $n$ meist als die *Anzahl der "Versuche"* und $p$ als die *Erfolgswahrscheinlichkeit* bezeichnet wird.
Der Erwartungswert und die Varianz sind gegeben durch:

$$ \text{E}(X) = np \qquad\text{und}\qquad \text{Var}(X) = np(1-p) $$

### Wahrscheinlichkeitsfunktion

Die Wahrscheinlichkeitsfunktion ist gegeben durch:

$$ p(x) = P(X=x) = \begin{cases} \binom{n}{x}p^x (1 - p)^{n-x} & \text{für}\quad x \in \{0,1,2,\dots,n\} \\\\
0 & \text{sonst} \end{cases} $$
  
mit $x$ := Anzahl der "Treffer" und $\binom{n}{x}$ := Binomialkoeffizient. 

### Verteilungsfunktion

Die Verteilungsfunktion ist definiert als:
  
  $$ F(x) = P(X \leq x) = \sum_{x_i < x}P(X = x_i) $$

Der Wert der Verteilungsfunktion gibt an, mit welcher Wahrscheinlichkeit die 
Zufallsvariable $X$ einen Wert kleiner oder gleich $x$ annimmt.

### Quantilsfunktion

Die Quantilsfunktion gibt den Wert $x_p$ zurück, unterhalb dem $p$% der Wahrscheinlichkeitsmasse liegt. 
Formal ist die Quantilsfunktion die Umkehrfunktion der Verteilungsfunktion:

$$ x_p = F^{-1}(p) = F^{-1}[P(X \leq x_p)] $$

---

### Excel Befehle

#### Wahrscheinlichkeits- bzw. Verteilungsfunktion der Binomialverteilung

+ `=BINOM.VERT`($x$; $n$; $p$; **kumuliert**)

    + $x$ := Anzahl "Treffer"
    + $n$ := Anzahl "Versuche"
    + $p$ := Erfolgswahrscheinlichkeit
    + kumuliert = 1 := Wert der Verteilungsfunktion (eine Wahrscheinlichkeit)
    + kumuliert = 0 := Wert der Wahrscheinlichkeitsfunktion (eine Wahrscheinlichkeit)

#### Wahrscheinlichkeitsbereich 

+ `=BINOM.VERT.BEREICH`($n$; $p$; $x_1$; $x_2$)

    + $n$ := Anzahl "Versuche"
    + $p$ := Erfolgswahrscheinlichkeit
    + $x_1$ := Untere Grenze
    + $x_1$ := Obere Grenze
    
Die Funktion `BINOM.VERT.BEREICH` berechnet: $P(x_1 \leq X \leq x_2)$

#### Quantilsfunktion der Binomialverteilung

+ `=BINOM.INV`($n$; $p$; $\alpha$)

    + $n$ := Anzahl "Versuche"
    + $p$ := Erfolgswahrscheinlichkeit
    + $\alpha$ := Wahrscheinlichkeit

----

**Bemerkung**

`BINOM.VERT.BEREICH`($n$; $p$; $x_1$; $x_2$) = `BINOM.VERT`($x_2$; $n$; $p$; WAHR) - `BINOM.VERT`($x_1 - 1$; $n$; $p$; WAHR)

denn 

$$ P(x_1 \leq X \leq x_2) = P(X \leq x_2) - P(X < x_1) = P(X \leq x_2) - P(X \leq (x_1 - 1)) $$
