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

## Sensitivity List (Not for SystemVerilog)
Η **Sensitivity List** είναι μία λίστα σημάτων που καθορίζει πότε θα ενεργοποιηθεί ένα `always` block. Όταν κάποιο από τα σήματα στη λίστα αλλάξει τιμή (σλυμφωνα με τις συνθήκες που ορίζονται), το block εκτελέιται.
Στην SystemVerilog τα `always_comb` και `always_ff` δεν χρειάζονται sensitivity list:
- `always_comb`: Αυτόματα ενεργοποιήται όταν αλλάξει οποιοδήποτε σήμα στο RHS
- `always_ff`: Χρησιμοποιείται μόνο για flip-flops (π.χ `always_ff @(posedge clk)`)

## Τιμές Σημάτων (Four-valued Logic)
- `0`, `1`: Κανονικές τιμές
- `Z` (high-Impendance)
    - Χρήση σε τρικατάστατους οδηγητές
    - παράδειγμα:
    ```SystemVerilog
    wire data = (enable) ? data_out : 8'bZ;
    ```
- `X` (Unknown)
    - Αρχικοποίηση `reg`, `logic`  χωρίς τιμή
    - Έξοδος πύλης με είσοδο `Z`
    - Σύγκρουση πολλαπλών πηγών (π.χ δύο πύλες οδηγούν το ίδιο καλώδιο σε 0 και 1 ταυτόχρονα)

## Συνένωση Bits (Concatenation)
Η συνένωση (concatenation) χρησιμοποιείται για να ενωθούν bitfields σε νέα διανύσματα. Είναι απαραίτητη σε HDL γλώσσες για την περιγραφή συνδυαστικών κυκλωμάτων.
```verilog
wire [2:0] a;
wire [4:0] b;
wire [7:0] c = {a,b};
```

## For-While
Οι βρόχοι `for` και `while` υποστηρίζονται μόνο μέσα σε `initial` ή `always` blocks. Δεν υπάρχει υποστήριξη για `break`, `continue` ούτε `i++` (εκτός απο SystemVerilog)
Προορίζονται κυρίος για testbench
```verilog
integer i;
initial begin
    for (i = 0; i < 10; i = i + 1)
        $display("i = %d", i);
end
```
```verilog
integer j;
initial begin
    j = 0;
    while (j < 10) begin
        $display("j = %b", j);
        j = j + 1;
    end
end
```

## Παρεμετρικά Modules
Τα modules μπορούν να έχουν παραμέτρους για να παραμετροποιούνται (π.χ μέγεθος λέξης ή καθυστερήσεις). Αυτό κάνει τον κώδικα πιο επαναχρησιμοποιήσιμο.
```verilog
module RegLd #(
    parameter N = 8,
    parameter dh = 2
)(
    input clk, load,
    input [N-1:0] D,
    output logic [N-1:0] Q
);
always_ff @(posedge clk)
    if (load)
        Q <= #dh D;
endmodule
```
Κλήση:
```verilog
rom #(
    .N(4),
    .dh(8)
)
maze1 (
    .clk(clk),
    .load(load),
    // ...
);
```

## Τρικατάστατοι Οδηγητές (Tri-State Buffer)
Χρησιμοποιούν την τιμή `Ζ` για αποσύνδεση από τον διαύλο. Απαιτούν `inout` τύπο σήματος:
```verilog
module tristate(en, clk, data);
input en, clk;
inout [7:0] data;

wire [7:0] data = (en) ? data_out : 8’bz;

always_ff @(posedge clk) begin
    if (!en)
        case (data)
        // ...
end
// ...
endmodule
```

## Μνήμες (Memories)
Οι μνήμες ορίζονται ως arrays και μπορούν να συντεθούν. Η αρχικοποίηση γίνεται με `$readmemh(filename,array)` ή `$readmemb(filename,array)`
```verilog
logic [15:0] memory [1023:0];
initial begin
    $readmemh("memory.dat", memory);
end
```

## Συναρτήσεις (Functions)
Οι συναρτήσεις επιστρέφουν μία τιμή και εκτελούνται σε μηδενικό χρόνο. Χρησιμοποιούνται για συνδυαστική λογική. Δεν επιτρέπουν delays ή `event` constructs.
Χαρακτηριστικά:
- Επιστρέφουν μία τιμή (deffault: 1-bit)
- Μπορούν να έχουν πολλαπλούς εισόδους
- Δεν είναι αναδρομικές
- Μπορούν να καλούν **άλλα** functions αλλα όχι tasks
- Καλούνται ενός expressions
- Είναι synthesizable
```verilog
function calc_parity;
input [31:0] val;
begin
    calc_parity = ^val;
end
endfunction
```
```verilog
function [15:0] average;
input [15:0] a, b, c, d;
begin
    average = (a + b + c + d) >> 2;
end
endfunction
```

## Tasks
Μοιάζουν με functions αλλά:
- Δεν επιστρέφουν τιμή (χρησιμοποιούν `output`/`inout`)
- Μπορούν να περιέχουν delays και χρονικές λειτουργίες
- Δεν υποστηρίζουν αναδρομή
- Μπορούν να καλούν άλλες tasks ή functions
```verilog
task ReverseByte;
    input [7:0] a;
    output [7:0] ra;
    integer j;
    begin
        for (j = 7; j >= 0; j = j - 1)
            ra[j] = a[7 - j];
    end
endtask
```

### Σύγκριση Functions και Tasks
- Ορίζονται μέσα σε modules και είναι τοπικές
- Δεν μπορούν να έχουν always και initial blocks αλλά μπορούν να καλούνται απο αυτά

|  | **Functions** | **Tasks** |
|--|------------|-------|
| Χρόνος | Εκτελούνται σε 0 χρόνο | Μπορεί να περιέχουν χρονικές καθυστερήσεις |
| Επιστροφή | Μία τιμή επιστρέφεται | Χωρίς επιστροφή, χρήση `output`/`inout` |
| Χρήσεις | Μπορούν να καλούν άλλα functions όχι tasks | Μπορούν να καλούν άλλα functions και tasks | 

## System Tasks και Functions
Χρήσιμα εργαλεία για debugging και simulations, ξεκινούν με `$`:
- `$display`: Εκτυπώνει format strings
- `$monitor`: Εκτυπώνει κάθε φορά που αλλάζει κάτι
- `$time`: Επιστρέφει τον χρόνο προσομοίωσης
- `$stop`: Πάυση simulation
- `$finish`: Τερματισμός simulation
- `$fopen`, `$fclose`, `fwrite` κ.α: για αρχεία

