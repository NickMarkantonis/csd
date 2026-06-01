<div align="center">
<h1>HY380 - Αλγόριθμοι και Πολυπλοκότητα</h1>
<h2>Complexity Classes</h2>
</div>

### Decision Problems

Όλη η θεωρία πολυπλοκότητας βασίζεται σε _προβλήματα απόφασης_ (decision problems), δηλαδή προβλήματα με απάντηση **YES/NO**.

Κάθε πρόβλημα βελτιστοποίησης (_optimization_) έχει μια αντίστοιχη _decision version_:

- _Optimization_: "Βρες το συντομότερο μονοπάτι από $s$ στο $t$"
- _Decision_: "Υπάρχει μονοπάτι από $s$ στο $t$ με κόστος $\leq k$;"

Λόγος που δουλεύουμε με decision problems: η θεωρία (Turing machines, certificates, αναγωγές) ορίζεται καθαρά μόνο σε YES/NO προβλήματα. Αν μπορούμε να λύσουμε το decision version γρήγορα, μπορούμε συνήθως να λύσουμε και το optimization (με binary search πάνω στο $k$).

### Η κλάση P (Polynomial time)

Η κλάση **P** περιέχει όλα τα decision problems που λύνονται σε πολυωνυμικό χρόνο:

$$ P = \{ L : \exists \text{ αλγόριθμος που αποφασίζει το } L \text{ σε χρόνο } O(n^k) \text{ για κάποιο σταθερό } k \} $$

Διαισθητικά: τα προβλήματα στο P είναι αυτά που μπορούμε να _λύσουμε_ αποτελεσματικά.

_Παραδείγματα_:
- _Shortest Path_ (Dijkstra, Bellman-Ford)
- _Minimum Spanning Tree_ (Kruskal, Prim)
- _Bipartite Matching_ (Hopcroft-Karp)
- _2-Coloring_ (BFS, διπολικός γράφος ⟺ δεν υπάρχει odd cycle)
- _Linear Programming_

### Η κλάση NP (Nondeterministic Polynomial time)

Η κλάση **NP** περιέχει όλα τα decision problems όπου, αν δοθεί ένα _certificate_ (witness), μπορούμε να **επαληθεύσουμε** μια YES απάντηση σε πολυωνυμικό χρόνο:

$$ NP = \{ L : \exists \text{ verifier } V \text{ s.t. } x \in L \iff \exists \text{ certificate } y, |y| = poly(|x|), V(x,y) = \text{YES σε poly time} \} $$

Διαισθητικά: τα προβλήματα στο NP είναι αυτά που μπορούμε να **επαληθεύσουμε** αποτελεσματικά (όχι κατ' ανάγκη να λύσουμε).

_Παραδείγματα_:
- _Vertex Cover_: certificate = το cover $C$, επαλήθευση = έλεγχος ότι κάθε ακμή έχει άκρο στο $C$ και ότι $|C| \leq k$
- _Hamiltonian Cycle_: certificate = η ακολουθία κόμβων, επαλήθευση = έλεγχος ότι σχηματίζει κύκλο που περνά από κάθε κόμβο μία φορά
- _3-SAT_: certificate = η ανάθεση τιμών, επαλήθευση = έλεγχος ότι ικανοποιεί όλες τις clauses
- _Subset Sum_: certificate = το υποσύνολο, επαλήθευση = έλεγχος ότι αθροίζει στο target

**Σημαντική σχέση**: $\boxed{P \subseteq NP}$ (αν λύνουμε σε pol time, μπορούμε τετριμμένα να επαληθεύσουμε αγνοώντας το certificate).

### Polynomial-time Reductions

Λέμε ότι το πρόβλημα $A$ _ανάγεται_ σε πολυωνυμικό χρόνο στο $B$, γράφουμε $A \leq_p B$, αν υπάρχει συνάρτηση $f$ υπολογίσιμη σε pol time τέτοια ώστε:

$$ x \in A \iff f(x) \in B $$

Διαισθητικά: _"αν ξέρεις πώς να λύνεις το $B$, ξέρεις πώς να λύνεις και το $A$"_.

_Βασικές ιδιότητες_:
- **Transitivity**: αν $A \leq_p B$ και $B \leq_p C$, τότε $A \leq_p C$
- **Hardness propagation**: αν $A \leq_p B$ και το $A$ είναι "δύσκολο", τότε και το $B$ είναι "δύσκολο"
- **Easiness propagation**: αν $A \leq_p B$ και $B \in P$, τότε $A \in P$

### Η κλάση NP-hard

Πρόβλημα $H$ είναι **NP-hard** αν _κάθε_ πρόβλημα του NP ανάγεται σε αυτό σε pol time:

$$ H \text{ είναι NP-hard} \iff \forall L \in NP: L \leq_p H $$

Διαισθητικά: το $H$ είναι _τουλάχιστον τόσο δύσκολο όσο κάθε πρόβλημα στο NP_.

_Παρατήρηση_: ένα NP-hard πρόβλημα **δεν χρειάζεται** να ανήκει στο NP. Π.χ. το _Halting Problem_ είναι NP-hard αλλά εκτός NP (μη αποφασίσιμο).

### Η κλάση NP-complete

Πρόβλημα είναι **NP-complete** αν είναι ταυτόχρονα:
1. στο NP
2. NP-hard

$$ NP\text{-}complete = NP \cap NP\text{-}hard $$

Διαισθητικά: τα NP-complete είναι _τα πιο δύσκολα προβλήματα του NP_. Αν λύσουμε **ένα** από αυτά σε pol time, λύνουμε **όλα** τα NP problems σε pol time (δηλαδή $P = NP$).

_Θεώρημα Cook-Levin (1971)_: Το **SAT** είναι NP-complete. Αυτό ήταν το _πρώτο_ NP-complete πρόβλημα που αποδείχθηκε — όλα τα άλλα αποδεικνύονται με αναγωγή από αυτό (ή από ένα πρόβλημα που ανάγεται σε αυτό).

### Το πρόβλημα P vs NP

Το μεγαλύτερο ανοιχτό πρόβλημα της επιστήμης υπολογιστών:

$$ P = NP \quad ? $$

Δηλαδή: αν μπορούμε να _επαληθεύσουμε_ μια λύση γρήγορα, μπορούμε και να τη _βρούμε_ γρήγορα;

- Πιστεύουμε $P \neq NP$ (δηλαδή υπάρχουν προβλήματα στο NP που δεν είναι στο P).
- Δεν έχει αποδειχθεί.
- $1.000.000\$ Millennium Prize για όποιον το λύσει.

Σχηματικά (υποθέτοντας $P \neq NP$):

```
+------------------------------+
|         NP-hard              |
|  +------------------------+  |
|  |   NP-complete          |  |
|  +-----------+------------+  |
|              |               |
+--------------+---------------+
               |    NP
               |  +-----+
               +--|  P  |
                  +-----+
```

### Recipe: Πώς αποδεικνύουμε ότι ένα πρόβλημα είναι NP-complete

Για να δείξουμε ότι το πρόβλημα $X$ είναι NP-complete:

1. **Βήμα 1**: Δείξε ότι $X \in NP$ — δώσε certificate και verifier που τρέχει σε pol time.
2. **Βήμα 2**: Διάλεξε ένα γνωστό NP-complete πρόβλημα $Q$.
3. **Βήμα 3**: Δείξε ότι $Q \leq_p X$ — κατασκεύασε αναγωγή $f$ σε pol time.
4. **Βήμα 4**: Απόδειξε ορθότητα: $q \in Q \iff f(q) \in X$ (και στις δύο κατευθύνσεις).

**ΠΡΟΣΟΧΗ**: Η κατεύθυνση της αναγωγής είναι _γνωστό-δύσκολο_ $\leq_p$ _άγνωστο_. Όχι το ανάποδο.

#### Παράδειγμα: $\text{Independent Set} \leq_p \text{Vertex Cover}$

_Κλειδί παρατήρησης_: Σε γράφο $G = (V, E)$:
$$ S \subseteq V \text{ είναι Independent Set} \iff V \setminus S \text{ είναι Vertex Cover} $$

**Αναγωγή**: Από instance $(G, k)$ του Independent Set, κατασκευάζουμε instance $(G, n-k)$ του Vertex Cover (όπου $n = |V|$). Η κατασκευή είναι σε $O(1)$ — απλή αλλαγή του $k$ σε $n-k$.

**Ορθότητα**:
- (⇒) Αν το $G$ έχει IS μεγέθους $\geq k$, τότε το συμπλήρωμα είναι VC μεγέθους $\leq n - k$.
- (⇐) Αν το $G$ έχει VC μεγέθους $\leq n - k$, τότε το συμπλήρωμα είναι IS μεγέθους $\geq k$.

**Συμπέρασμα**: Αφού το Independent Set είναι NP-complete, και $\text{IS} \in NP$ (με certificate το ίδιο το σύνολο), τότε:
$$ \boxed{\text{Vertex Cover είναι NP-complete}} $$

### Πώς ζούμε με NP-hard προβλήματα

Όταν αντιμετωπίζουμε ένα NP-hard πρόβλημα στην πράξη, έχουμε 4 βασικές στρατηγικές:

| Στρατηγική | Περιγραφή | Παράδειγμα |
|-|-|-|
| _Approximation_ | Δεχόμαστε λύση που είναι _κοντά_ στη βέλτιστη με αποδεδειγμένο φράγμα | 2-approx Vertex Cover |
| _Special cases_ | Λύνουμε σε pol time όταν η είσοδος έχει ειδική δομή | Vertex Cover σε δέντρα |
| _Pseudo-polynomial_ | Αλγόριθμοι pol ως προς την _τιμή_ των αριθμών | 0-1 Knapsack DP |
| _Heuristics_ | Δεν εγγυώμαστε ποιότητα, αλλά συχνά δουλεύουν καλά | Branch & Bound |

#### 2-Approximation για Vertex Cover

```
VC-Approx(G):
  C ← ∅
  while E ≠ ∅:
    pick any edge (u, v) ∈ E
    C ← C ∪ {u, v}                          // βάζουμε ΚΑΙ ΤΑ ΔΥΟ άκρα
    remove all edges incident to u or v
  return C
```

**Απόδειξη ότι είναι 2-approximation**:

Έστω $M$ το σύνολο των ακμών που διαλέξαμε στο while. Παρατηρήσεις:
1. Οι ακμές του $M$ είναι **matching** — δεν μοιράζονται κορυφές, γιατί κάθε φορά αφαιρούμε όλες τις γειτονικές ακμές.
2. _Κάθε_ valid Vertex Cover πρέπει να καλύπτει κάθε ακμή του $M$, άρα να περιέχει τουλάχιστον ένα άκρο από κάθε ακμή του $M$. Άρα $|OPT| \geq |M|$.
3. Ο αλγόριθμος βάζει $2$ κορυφές για κάθε ακμή του $M$, άρα $|C| = 2|M|$.

Συνδυάζοντας: $|C| = 2|M| \leq 2 \cdot |OPT|$, άρα $\boxed{|C| \leq 2 \cdot |OPT|}$.

**Πολυπλοκότητα**: $O(|V| + |E|)$.

#### Vertex Cover σε Δέντρα — Πολυωνυμική Λύση

Σε δέντρα, το Vertex Cover λύνεται **ακριβώς** σε pol time με DP. Σημαντικό: αυτό δεν αντιφάσκει με την NP-completeness — η NP-hardness αναφέρεται στη _γενική_ περίπτωση γραφημάτων, όχι σε ειδικές οικογένειες.

```
VC-Tree(v):                                   // post-order DP
  if v is leaf:
    take[v] ← 1
    skip[v] ← 0
  else:
    take[v] ← 1 + Σ min(take[c], skip[c])     // αν πάρω v, παιδιά free
    skip[v] ← Σ take[c]                       // αν δεν πάρω v, ΠΡΕΠΕΙ να πάρω παιδιά
  return min(take[root], skip[root])
```

**Πολυπλοκότητα**: $O(n)$ — μία επίσκεψη ανά κορυφή.

### Ψευδοπολυωνυμικοί Αλγόριθμοι (Pseudo-polynomial)

Ένας αλγόριθμος ονομάζεται **pseudo-polynomial** αν τρέχει σε χρόνο πολυωνυμικό ως προς τις _αριθμητικές τιμές_ της εισόδου — αλλά **όχι** ως προς το _μέγεθος_ της εισόδου σε bits.

_Παράδειγμα: 0-1 Knapsack DP_

Ο γνωστός DP αλγόριθμος για 0-1 Knapsack τρέχει σε $O(n \cdot W)$, όπου $n$ ο αριθμός αντικειμένων και $W$ η χωρητικότητα.

**Γιατί ΔΕΝ είναι αληθινά πολυωνυμικός**: Η είσοδος έχει μέγεθος $O(n \log W)$ bits (το $W$ κωδικοποιείται με $\log W$ bits). Αλλά ο αλγόριθμος τρέχει σε χρόνο $O(n \cdot W) = O(n \cdot 2^{\log W})$ — _εκθετικός_ στο μέγεθος των bits.

$$ \boxed{\text{Pseudo-polynomial: poly στις τιμές, exp στα bits}} $$

Αυτός είναι ο λόγος που το 0-1 Knapsack είναι NP-complete παρόλο που έχει "αλγόριθμο" — ο αλγόριθμος δεν είναι _πραγματικά_ πολυωνυμικός.

### Κάτω Φράγμα για Ταξινόμηση με Συγκρίσεις

Σχετίζεται με κάτω φράγματα στην πολυπλοκότητα. _Θεώρημα_: Κάθε comparison-based sorting αλγόριθμος έχει worst-case $\Omega(n \log n)$.

**Απόδειξη (decision tree)**:
- Κάθε σύγκριση δίνει 1 από 2 αποτελέσματα → δυαδικό δέντρο απόφασης.
- Πρέπει να μπορεί να ξεχωρίσει $n!$ διαφορετικές μεταθέσεις της εισόδου, άρα ≥ $n!$ φύλλα.
- Δέντρο με $L$ φύλλα έχει ύψος $\geq \log_2 L$.
- Ύψος ≥ $\log_2(n!) = \Theta(n \log n)$ (από Stirling: $n! \approx (n/e)^n$, άρα $\log_2(n!) \approx n \log_2 n$).

$$ \boxed{\text{Worst-case comparisons} \geq \log_2(n!) = \Omega(n \log n)} $$

### Συνοπτικός Πίνακας Παραδειγμάτων

| Πρόβλημα | Κλάση | Σχόλιο |
|-|-|-|
| Shortest Path | P | Dijkstra: $O((n+m) \log n)$ |
| Minimum Spanning Tree | P | Kruskal/Prim |
| Bipartite Matching | P | Hopcroft-Karp |
| Maximum Flow | P | |
| 2-Coloring | P | BFS, ισοδύναμο με bipartite check |
| Linear Programming | P | Karmarkar, ellipsoid method |
| Fractional Knapsack | P | Greedy by ratio |
| Vertex Cover σε δέντρα | P | DP, $O(n)$ |
| **SAT, 3-SAT** | NP-complete | Cook-Levin (το πρώτο NP-complete) |
| **Vertex Cover** | NP-complete | από Independent Set |
| **Independent Set** | NP-complete | από 3-SAT |
| **Clique** | NP-complete | από Independent Set (συμπλήρωμα) |
| **3-Coloring** | NP-complete | από 3-SAT |
| **0-1 Knapsack** | NP-complete | έχει pseudo-poly DP |
| **Subset Sum** | NP-complete | έχει pseudo-poly DP |
| **Hamiltonian Cycle/Path** | NP-complete | |
| **TSP (decision)** | NP-complete | |
| TSP (optimization) | NP-hard | δεν είναι decision |
| Halting Problem | NP-hard | εκτός NP (undecidable) |

### Πότε ΔΕΝ είναι NP-complete

Συχνά λάθη στις εξετάσεις:
- Πρόβλημα **βελτιστοποίησης** δεν είναι NP-complete αυστηρά (είναι NP-hard). Η decision version του είναι NP-complete.
- Πρόβλημα που είναι **εκτός NP** δεν μπορεί να είναι NP-complete (μπορεί να είναι μόνο NP-hard).
- Πρόβλημα που λύνεται σε pol time σε **ειδική περίπτωση** (π.χ. δέντρα) δεν παύει να είναι NP-complete στη γενική περίπτωση.

### Που εμφανίζεται στις παλιές εξετάσεις

- _Ορισμοί P/NP/NP-complete/NP-hard_: JUNE17, JUNE20, SEPT20, JUNE22, JUNE24, SEPT24 (σε **κάθε** εξέταση)
- _Vertex Cover approximation_: JUNE20, JUNE22
- _Independent Set → Vertex Cover reduction_: JUNE22
- _Vertex Cover σε δέντρα_: JUNE22
- _Lower bound για sorting_: JUNE17, SEPT20
- _Pseudo-polynomial / Knapsack_: JUNE23, JUNE24
- _Graph coloring NP-completeness_: SEPT24