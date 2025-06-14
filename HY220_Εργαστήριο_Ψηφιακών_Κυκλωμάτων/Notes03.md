# HY220 - Εργαστήριο Ψηφιακών Κυκλωμάτων
# Διάλεξη 3 - verilog: Μια πιο κοντινή ματιά

## Δομή της γλώσσας
Η Verilog μοιάζει με τη γλώσσα C σε διαφοεριτκές πτυχές, όπως η χρήση preprocessor directives (`include`,`define`), keywords και τελεστών. Οι τελεστές χωρίζονται σε:
- Συγκριτικούς: `=`, `==`, `!=`, `<`, `>`, `<=`, `>=`
- Λογικούς: `&&` (AND), `||` (OR), `~` (NOT), `^` (XOR)
- Τριαδικός τελεστής: `?`: (όπως στη C).

Χρονικές οδηγίες:
- `timescale 1ns/1ns` ορίζει τη μονάδα χρόνου προσομοίωσης.
- `define dh 2` δημιουργεί μια σταθερά με τιμή 2, που μπορεί να χρησιμοποιηθεί για καθυστερήσεις (π.χ. `q <= #dh d`).
- Οι `ifdef`/`ifndef` επιτρέπουν υπό συνθήκη μεταγλώττιση.

## Events και Event Queue
Η verilog είναι μία event-driven γλώσσα, όπου η προσομοίωση βασίζεται σε μια ουρά γεγονόντων (event queue). Κάθε γεγονός έχει μια χρονική σήμανση και εκτελείται μόνο όταν αλλάξει κάποια τιμή.
- Event Queue:
    - Περιέχει γεγονόντα με χρονικές σημάνσεις (π.χ `t = 10ns`)
    - Δεν υπάρχει εγγύηση για σειρά εκτέλεσης γεγονόντων τον ίδιο χρόνο (εξαρτάται απο τον simulator)
- Δύο τύποι events:
    1. **Evaluation**: Υπολογισμός τιμών
    2. **Update**: Ανάθεση τιμών

Παράδειγμα:
```verilog
always_ff @(posedge clk) a <= b + 1;  
always_ff @(posedge clk) b <= c + 1;  
```
Εδώ, τα a και b ενημερώνονται ταυτόχρονα μετά το posedge του clk, χάρη στα non-blocking assignments (`<=`).

*Evaluation*: διαβάζει τις τιμές b και c, υπολογίζει, αποθηκεύει εσωτερικά και προγραμματίζει ένα update event 
*Update*: διαβάζει τις τιμές b και c, υπολογίζει, αποθηκεύει εσωτερικά και προγραμματίζει ένα update event 

## Blocking vs Non-blocking Assignments
### Blocking `=`
- Evaluation και Update γίνονται ίδιο χρόνο
- Εκτελείται άμεσα και με σειρά
- Χρήση για συνδυαστική λογική (μέσα σε `always_comb`)
```verilog
always_ff @(posedge clk) a = b;  
always_ff @(posedge clk) b = a;  
```
Ανταλλάσσει `a` και `b` αμέσως, δημιουργόντας απρόβλεπτη συμπεριφορά

### Non-Blocking `<=`
- Evaluation τώρα, update όταν τελειώσουν όλα τα evaluations του τρέχοντος χρόνου
- Χρήση για σειριακή λογική (μέσα σε `always_ff`)
- Ασφαλής ανταλλαγή τιμών:
```verilog
always_ff @(posedge clk) a <= b;  
always_ff @(posedge clk) b <= a;  
```
Ανταλλάσσει a και b χωρίς races, καθώς τα updates γίνονται παράλληλα.

## Χρονικές Καθυστερήσεις
- Inter-Assignment Delays
```verilog
#5 a = b + c;   // Εκτέλεση μετά απο 5 μονάδες χρόνου
```
- Intra-Assignment Delays
```verilog
a = #5 b + c;   // Evaluation τώρα, update σε 5 μονάδες (blocking)
a <= #5 b + c;  // Evaluation τώρα, update σε 5 μονάδες (non-blocking)
```

## 




