<div align="center">
<h1>HY380 - Αλγόριθμοι και Πολυπλοκότητα</h1>
<h2>Masters Theorem + Recursion Tree</h2>
</div>

### Masters Theorem

Το _Masters Theorem_ χρησιμοποιείται για να βρήσκουμε αναδρομικές σχέσεις κυρίως σε αλγορίθμους _Divide And Conquer_. Εφαρμόζεται σε αλγορίθμους όπου η συνάρτηση πολυπλοκότητας τους είναι της μορφής:

$$ T(n) = aT\left(\frac{n}{b}\right) + f(n) $$

- $a$: πόσα υποπροβλήματα δημιουργούνται
- $b$: πόσο μικραίνει το μέγεθος του προβλήματος
- $f(n)$: κόστος divide/combine
- $n^{\log_ba}$: το "_κριτήριο σύγκρισης_"

Η βασική ιδέα είναι να συγκρίνουμε τα 

$$ f(n) \quad \text{και} \quad n^{\log_ba} $$

Ανάλογα με πιο μεγαλώνει πιο γρήγορα, έχουμε 3 περιπτώσεις:

1. Το **_Recursion_** κυριαρχεί
  Το κόστος των recursive calls είναι μεγαλύτερο από το combine step, δηλαδή άν:
  $$ f(n) \in O(n^{\log_ba - \varepsilon}),~ \varepsilon > 0 \quad \text{τότε:} \quad \boxed{T(n) \in \Theta(n^{\log_ba})} $$
1. **_Ισσοροπία_**:
  Το recursive και το combine step έχουν περίπου το ίδιο κόστος, δηλαδή άν:
  $$ f(n) \in \Theta(n^{\log_ba}\log^kn),~k\geq 0 \quad \text{τότε:} \quad \boxed{T(n) \in \Theta(n^{\log_ba}\log^{k+1}n)} $$
1. Το **_Combine_** κυριαρχεί:
  Το non-recursive κόστος είναι το dominant μέρος, δηλαδή άν:
  $$ \begin{align*}
    f(n) &\in \Omega(n^{\log_ba+\varepsilon}),~ \varepsilon > 0 \\ &\text{και} \\ a f\left(\frac{n}{b}\right) &\leq cf(n),~c<1 
  \end{align*} \qquad \text{τότε:} \qquad \boxed{T(n) \in \Theta(f(n))} $$

#### Παραδείγματα:
- _Για πρώτη Περίπτωση_
  $$ T(n) = 4T\left(\frac{n}{2}\right) + n \qquad 
  \begin{cases}
    a &= 4 \\ b &= 2 \\ f(n) &= n
  \end{cases} $$
  Για $\varepsilon = 1$ έχουμε: $$n^{\log_ba - \varepsilon} = n^{\log_24 - 1} = n^1 = n$$
  Άρα $n \in O(n) \Rightarrow f(n) \in O(n^{\log_ba - \varepsilon})$ που σημαίνει ότι είμαστε στην **πρώτη** περίπτωση και:
  $$ \boxed{T(n) \in \Theta(n^2)} $$

- _Για Δεύτερη Περίπτωση_
  $$ T(n) = 2T\left(\frac{n}{2}\right) + n \qquad 
  \begin{cases}
    a &= 2 \\ b &= 2 \\ f(n) &= n
  \end{cases} $$
  Για $k=0$ έχουμε: $$ n^{\log_ba}\log^kn = n^{\log_2}\log^0n = n \cdot 1 = n $$ 
  Άρα $n \in \Theta(n) \Rightarrow f(n) \in \Theta(n^{\log_ba}\log^kn)$ που σημαίνει ότι είμαστε στην **δεύτερη** περίτπωση και:
  $$ \boxed{T(n) \in \Theta(n\log n)} $$

- _Για Τρίτη Περίπτωση_
  $$ T(n) = Τ\left(\frac{n}{3}\right) + n \log n \qquad 
  \begin{cases}
    a &= 1 \\ b &= 3 \\ f(n) &= n \log n
  \end{cases} $$
  Για $\varepsilon = 1$ έχουμε: $$n^{\log_ba + \varepsilon} = n^{\log_13 + 1} = n^1 = n$$
  και επίσης ισχύει το _regularity condition_ αφού για $c=1/2$:
  $$a f\left(\frac{n}{b}\right) \leq c f(n) \quad \Rightarrow \quad 1/3 \cdot \log 1/3 \leq 1/2 \cdot \log n $$
  Άρα $n \log n \in \Omega(n) \Rightarrow f(n) \in \Omega(n^{\log_ba + \varepsilon})$ που σημαίνει ότι είμαστε στην **τρίτη** περίπτωση και:
  $$ \boxed{T(n) \in \Theta(n \log n)} $$

#### Βήματα Εφαρμογής:
Μπορούμε να σπάσουμε όλη την διαδικασία σε 4 βήματα εφαρμογής, συγκεκριμμένα:
1. **Βήμα**: Γράφουμε το recurrence στην μορφη:
  $$ T(n) = a T(n/b) + f(n) $$
2. **Βήμα**: Βρίσκουμε το:
   $$ n^{\log_ba} $$
3. **Βήμα**: Συγκρίνουμε το $f(n)$ με το $n^{\log_ba}$
4. **Βήμα**: Ελέγχουμε σε ποια από τις τρείς περιτπώσεις βρισκόμαστε:
   
    | Περίπτωση | Συνθήκη | Αποτέλεσμα |
    |-|-|-|
    |1| $f(n)$ μικρότερο | $\Theta(n^{\log_ba})$ |
    |2| ίδιο μέγεθος | $\Theta(n^{\log_ba}\log n)$ |
    |3| $f(n)$ μεγαλύτερο | $\Theta(f(n))$ |

#### Πότε ΔΕΝ εφαρμόζεται
Το Masters Theorem δεν το χρησιμοποιούμε όταν:
- Τα υποπροβλήματα δεν είναι το ίδιο μέγεθος
- Το reccurence δεν είναι της μορφής $aT(n/b) + f(n)$
- υπάρχουν άλλες συναρτήσεις όπως: $T(n) = T(n/2)+T(n/3)+n$

---

### Recursion Tree
 
Το _Recursion Tree_ χρησιμοποιείται για να βρήσκουμε αναδρομικές σχέσεις, κυρίως όταν τα υποπροβλήματα **δεν** είναι του ίδιου μεγέθους. Εφαρμόζεται σε αναδρομές της γενικής μορφής:
 
$$ T(n) = \sum_{i} a_i \, T\!\left(\frac{n}{b_i}\right) + f(n) $$
 
- $a_i$: πόσα υποπροβλήματα δημιουργούνται για κάθε μέγεθος $n/b_i$
- $b_i$: πόσο μικραίνει το μέγεθος σε κάθε αναδρομική κλήση
- $f(n)$: το "_combine κόστος_" — το έργο που γίνεται εκτός των αναδρομικών κλήσεων
- $\sigma$: το "_κριτήριο σύγκρισης_" — βλ. παρακάτω
Η βασική ιδέα είναι να **ζωγραφίσουμε** το δέντρο των αναδρομικών κλήσεων και να αθροίσουμε το κόστος ανά επίπεδο.
 
#### Ο παράγοντας $\sigma$ (για γραμμικό $f(n) = cn$)
 
Όταν $f(n) = cn$, το κόστος ενός κόμβου μεγέθους $m$ είναι $c \cdot m$. Άρα το συνολικό κόστος ενός επιπέδου ισούται με $c \times$ (συνολικό μέγεθος του επιπέδου). Το συνολικό μέγεθος κάθε επιπέδου πολλαπλασιάζεται με τον παράγοντα:
 
$$ \sigma = \sum_{i} \frac{a_i}{b_i} $$
 
Έτσι τα κόστη ανά επίπεδο είναι η γεωμετρική σειρά $cn,~ cn\sigma,~ cn\sigma^2, \ldots$ και το ολικό κόστος είναι:
 
$$ T(n) = cn \sum_{k=0}^{\infty} \sigma^k $$
 
Ανάλογα με το αν $\sigma < 1$, $\sigma = 1$, ή $\sigma > 1$, έχουμε τρεις περιπτώσεις:
 
1. Το **_Combine_** κυριαρχεί:
  Η γεωμετρική σειρά _συγκλίνει_, το μεγαλύτερο κόστος είναι στη ρίζα, δηλαδή αν:
  $$ \sigma < 1 \qquad \text{τότε:} \qquad \boxed{T(n) \in \Theta(n)} $$
1. **_Ισορροπία_**:
  Κάθε επίπεδο κάνει _ίδιο_ κόστος $cn$, και το δέντρο έχει $\log n$ επίπεδα, δηλαδή αν:
  $$ \sigma = 1 \qquad \text{τότε:} \qquad \boxed{T(n) \in \Theta(n \log n)} $$
1. Το **_Recursion_** κυριαρχεί:
  Η γεωμετρική σειρά _αποκλίνει_, το μεγαλύτερο κόστος είναι στα φύλλα, δηλαδή αν:
  $$ \sigma > 1 \qquad \text{τότε:} \qquad \boxed{T(n) \in \Theta\!\left(n^{\alpha}\right)}, \quad \alpha > 1 $$
  όπου το $\alpha$ λύνει την εξίσωση $\sum_i a_i \cdot (1/b_i)^\alpha = 1$ (στην πράξη χρησιμοποιούμε το Masters Theorem αν τα $b_i$ είναι ίσα).
#### Παραδείγματα:
 
- _Για πρώτη Περίπτωση ($\sigma < 1$) — Άνισα υποπροβλήματα_
  $$ T(n) = T\!\left(\frac{n}{3}\right) + 2T\!\left(\frac{n}{4}\right) + 5n \qquad
  \begin{cases}
    a_1 = 1,~ b_1 = 3 \\
    a_2 = 2,~ b_2 = 4 \\
    f(n) = 5n
  \end{cases} $$
  Υπολογίζουμε:
  $$ \sigma = \frac{a_1}{b_1} + \frac{a_2}{b_2} = \frac{1}{3} + \frac{2}{4} = \frac{1}{3} + \frac{1}{2} = \frac{5}{6} < 1 $$
  Άρα τα κόστη ανά επίπεδο είναι $5n,~ 5n \cdot \frac{5}{6},~ 5n \cdot \left(\frac{5}{6}\right)^2, \ldots$ και:
  $$ T(n) = 5n \cdot \frac{1}{1 - \frac{5}{6}} = 5n \cdot 6 = 30n \quad \Rightarrow \quad \boxed{T(n) \in \Theta(n)} $$
- _Για δεύτερη Περίπτωση ($\sigma = 1$) — Ισορροπία_
  $$ T(n) = 3T\!\left(\frac{n}{3}\right) + 5n \qquad
  \begin{cases}
    a = 3,~ b = 3 \\
    f(n) = 5n
  \end{cases} $$
  Υπολογίζουμε:
  $$ \sigma = \frac{3}{3} = 1 $$
  Κάθε επίπεδο κάνει κόστος $5n$, και το δέντρο έχει ύψος $\log_3 n$, οπότε:
  $$ T(n) = 5n \cdot \log_3 n \quad \Rightarrow \quad \boxed{T(n) \in \Theta(n \log n)} $$
- _Για πρώτη Περίπτωση ($\sigma < 1$) — Άλλο παράδειγμα με άνισα_
  $$ T(n) = T\!\left(\frac{n}{2}\right) + T\!\left(\frac{n}{3}\right) + 4n \qquad
  \begin{cases}
    a_1 = 1,~ b_1 = 2 \\
    a_2 = 1,~ b_2 = 3 \\
    f(n) = 4n
  \end{cases} $$
  Υπολογίζουμε:
  $$ \sigma = \frac{1}{2} + \frac{1}{3} = \frac{5}{6} < 1 \quad \Rightarrow \quad \boxed{T(n) \in \Theta(n)} $$
#### Βήματα Εφαρμογής:
Μπορούμε να σπάσουμε όλη την διαδικασία σε 4 βήματα εφαρμογής, συγκεκριμένα:
1. **Βήμα**: Γράφουμε το recurrence στη μορφή:
  $$ T(n) = \sum_i a_i T(n/b_i) + f(n) $$
2. **Βήμα**: Ελέγχουμε αν το $f(n)$ είναι γραμμικό και υπολογίζουμε:
   $$ \sigma = \sum_i \frac{a_i}{b_i} $$
3. **Βήμα**: Συγκρίνουμε το $\sigma$ με $1$
4. **Βήμα**: Ελέγχουμε σε ποια από τις τρεις περιπτώσεις βρισκόμαστε:
    | Περίπτωση | Συνθήκη | Τι κυριαρχεί | Αποτέλεσμα |
    |-|-|-|-|
    |1| $\sigma < 1$ | ρίζα (combine) | $\Theta(n)$ |
    |2| $\sigma = 1$ | όλα τα επίπεδα | $\Theta(n \log n)$ |
    |3| $\sigma > 1$ | φύλλα (recursion) | $\Theta(n^\alpha),~ \alpha > 1$ |
#### Πότε ΔΕΝ εφαρμόζεται (με τον παράγοντα $\sigma$)
Η μέθοδος του $\sigma$ για γραμμικό κόστος δεν λειτουργεί όταν:
- Το $f(n)$ **δεν** είναι γραμμικό, π.χ. $f(n) = n^2$, $f(n) = \log n$, $f(n) = c$ (σταθερά)
  - Για _σταθερό_ $f(n) = c$: ο $\sigma$ δεν ισχύει — μετράμε τον **αριθμό φύλλων** αντί για το συνολικό μέγεθος
  - Για $f(n) = n^2$: το $\sigma$ αλλάζει σε $\sigma' = \sum_i a_i / b_i^2$ — αν $\sigma' < 1$ τότε $T(n) = \Theta(n^2)$
  - Για ίσα υποπροβλήματα $T(n) = aT(n/b) + f(n)$: χρησιμοποιούμε κατευθείαν το _Masters Theorem_