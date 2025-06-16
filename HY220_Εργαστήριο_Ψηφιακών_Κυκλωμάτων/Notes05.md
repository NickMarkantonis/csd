# HY220 - Εργαστήριο Ψηφιακών Κυκλωμάτων
# Διάλεξη 5 - SystemVerilog: Επιπλέον Χαρακτηριστικά

## Οργάνωση Κώδικα σε SystemVerilog
Η αυξανόμενη πολυπλοκότητα των σχεδίων πειβάλλει καλύτερη οργάνωση για:
- Αναγνωσιμότητα
- Συντήρηση
- Επαναχρησιμοποιήση

SystemVerilog παρέχει ισχυρούς μηχανισμούς για αυτό:
- `typedef`: Δημιουργία νέων τύπων (aliases)
- `enum`: Ονομαστικές απαριθμήσεις
- `struct`: Ομαδοποίηση σημάτων
- `array`: Πίνακες (packed & unpacked)
- `packages`: Διαμοιρασμός δηλώσεων τύπων, functions κ.λπ

### Typedefs (Προσαρμοσμένοι τύποι)
Ορίζουν εναλλακτικά ονόματα για καλύτερη αναγνωσιμότητα, συντήρηση και επαναχρησιμοποίηση
```verilog
typedef logic [7:0] byte_t;
typedef integer count_t;
typedef struct {
    logic valid;
    logic [31:0] data;
} data_payload_t;
```

Οφέλη:
- Ευκολότερες δηλώσεις
- Ευελιξία σε μελλοντικές αλλαγές
- Επαναχρησιμοποίηση με χρήση `packages`

### Enums (Απαριθμήσεις)
Ορίζουν τύπους για συγκεκριμμένες ονομαστικές τιμές, πολύ χρήσιμο για:
- FSM καταστάσεις
- OpCodes
- Options
```verilog
typedef enum logic [1:0] {
    IDLE = 2'b00,
    READ = 2'b01,
    WRITE = 2'b10,
    ERROR = 2'b11
} state_e;
```
Μπορούν να επιστρέψουν ως String με `.name()`:
```verilog
$display("Current state: %s", current_state.name());
```

### Structs (Δομές)
Ομαδοποιούν σχετικά σήματα/δεδομένα υπό ενιαίο όνομα:
```verilog
typedef struct {
  logic [7:0] red, green, blue;
} pixel_t;

pixel_t my_pixel;
```
#### Packed vs Unpacked Structs
- **Unpacked**(deffault): Τα πεδία είναι συνεχόμενα στη μνήμη
- **Packed**: Χωρίς padding, με συνεχές layout -> απαραίτητα για συνθέσιμο κώδικα
```verilog
typedef struct packed {
    logic valid;
    logic [7:0] data;
} packed_data_t;
```

### Structs ως Πόρτες Module
Χρήση `struct` για ομαδοποίηση σχετικών σημάτων σε διεπαφές module
```verilog
typedef struct packed {
    logic [7:0] address;
    logic [7:0] data;
    logic       read_enable;
    logic       write_enable;
} bus_interface_t;

module memory_controller(
    input  logic clk,
    input  logic rst_n,
    input  bus_interface_t req_if,
    output bus_interface_t tgt_if
);
assign tgt_if = req_if;
endmodule
```
Οργάνωση και καθαριότητα στα module instances

### Arrays (Πίνακες)
#### Unpacked Arrays
Διατηρούνται ως ανεξάρτητα στοιχεία:
```verilog
logic [7:0] byte_array[11:0];   // array of 12 bytes
integer count[10];              // array of 10 integers
```
#### Packed Arrays
Συνεχόμενη ακολουθία bits - χρήσιμο για signal/memories
```verilog
logic [3:0][4:0] nibble_array; // 5 στοιχεία των 4 bits
```
#### Packed vs Unpacked Array
| Χαρακτηριστικό | Packed Array | Unpacked Array |
|---|---|---|
| Χώρος | Συνεχόμενος | Ξεχωριστός ανα στοιχείο |
| Χρήση | Σήματα/Μνήμες | Λογική συλλόγων (data structores) |
| Δήλωση | `data_type [packed_dims] array_name` | `data_type array_name [dims]` |

### Packages
Επιτρέπουν συγκέντροση για διαμοιρασμό τύπων, function κ.τλ
```verilog
package common_types_pkg;
    typedef enum logic [1:0] {IDLE, READ, WRITE, ERROR} state_e;
    typedef struct packed {
        logic [7:0] address, data;
    } bus_transaction_t;

    function void print_transaction(bus_transaction_t trans);
        $display("Address: %h, Data: %h", trans.address, trans.data);
    endfunction
endpackage
```

### Χρήσιμες SystemVerilog Συναρτήσεις
#### `$bits(expression)`
Υπολογίζει πόσα bits χρειάζονται ένα expression:
```verilog
$bits(my_struct)
```
#### `$clog2(integer)`
Υπολογίζει το ελάχιστο πλήθος bits για αναπαράσταση
```verilog
localparam ADDR_BITS = $clog2(MEMORY_WORDS)
```
Πολύ χρήσιμες σε παραμετρικά designs


