# HY220 - Εργαστήριο Ψηφιακών Κυκλωμάτων
# Διάλεξη 4 - Στυλ Κώδικα και Synthesizable Verilog

## Κατηγορίες στυλ Verilog
Υπάρχουν τρια βασικά στυλ γραφής σε Verilog:
- **Behavioral**: Περιγράφει τη συμπεριφορά ενός συστήματος ανεξάρτητα από την υπολοίηση
- **RTL(Register Tranfer Level)**: Περιγράφει τη ροή δεδομένων μεταξύ καταχωρητών και την ακριβή λειτουργία με χρονισμό
- **Structural**: Περιγράφει κυκλώματα μέσω σύνδεσης έτοιμων modules, όπως θα τα υλοποιούσε κανείς με πύλες
Η επιλογή στυλ έχει άμεση σχέση με το αν ο κώδικας είναι synthesizable

### Behavioral Verilog
Εστιάζει στη λειτουργία του κώδικα και χρησιμοποιείται συχνά σε:
- TestBenches
- Αρχικό verification/προσομοίωση
Δίνει μεγάλη ελευθερία: χρήση `initial`, `tasks`, `functions`, floating-point μεταβλητές (`real`), arrays, `fork...join`, delays

### RTL (Register Transfer Level)
Είναι το standart για synthesizable Verilog. Ορίζουμε τι κάνει κάθε block σε σχέση με το ρολόι. Το hardware μεταφράζεται εύκολα από τον κώδικα RTL.
Χρησιμοποιείται:
- Για καταχωρητές
- Για συνδυαστική λογική
- Με `always_ff`, `always_comb`

### Structural Verilog
Περιλαμβάνει αποκλειστικά instatiations modules και gates. Είναι αυστηρό αλλά πολύ χρήσιμο στο top-level. Δεν χρησιμοποιείται για χαμηλού επιπέδου λογική αλλά για σύνθεση συνολικών blocks.

### Συμβουλές Κώδικα:
- **Ονοματολογία**: ξεκάθαρα και συνεπή ονόματα
- **Indentation**: βελτιώνει αναγνωσιμότητα
- **Αναγνωσιμότητα**: μην τα βάζεις όλα σε μία γραμμή
- **Σχόλια**: να μπαίνουν απο την αρχή

## Synthesizable Verilog
Περιλαμβάνει περιορισμένο υποσύνολο της Verilog:
| Εντολές | Status |
|---|---|
| `input`/`output` | Επιτρεπτά | 
| `assign` | Ναι, delays αγνούνται 
| `initial` | Όχι (μόνο για simulation) |
| `function`/`tasks` | Περιορισμένη χρήση |
| `for`/`while` | Επιτρεπτά, αλλά όχι σε harware loops | 
| `*`/`/`/`%` | Προσοχή - συχνά όχι synthesizable | 

## Kλασικά RTL Modules (παραμετρικά)
#### D Flip-Flop
```verilog
module Reg #(
    parameter int N = 16,
    parameter int C2Q = 1 
)(
    input logic clk,
    input logic [N-1:0] i_d,
    output logic [N-1:0] o_q
);
always_ff @(posedge clk)
    o_q <= #C2Q i_d;
endmodule
```
#### Flip-Flop με ασύνγχρονο reset
```verilog
module RegARst #(
    parameter int N = 16,
    parameter int C2Q = 1 
)(
    input logic clk,
    input logic reset_n,
    input logic [N-1:0] i_d,
    output logic [N-1:0] o_q
);
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n)   o_q <= #C2Q 0;
    else            o_q <= #C2Q i_d;
end
endmodule
```
#### Flip-Flop με συνγχρονισμένο reset
```verilog
module RegSRst #(
    parameter int N = 16,
    parameter int C2Q = 1 
)(
    input logic clk,
    input logic reset_n,
    input logic [N-1:0] i_d,
    output logic [N-1:0] o_q
);
always_ff @(posedge clk) begin
    if (~reset_n)   o_q <= #C2Q 0;
    else            o_q <= #C2Q i_d;
end
endmodule
```
#### Register with Load Enable
```verilog
module RegLd #(
    parameter int N = 16,
    parameter int C2Q = 1
)(
    input logic clk,
    input logic i_ld,
    input logic [N-1:0] i_d,
    output logic [N-1:0] o_q
);
always_ff @(posedge clk)
    if (i_ld)
        o_q <= #C2Q i_d;
endmodule
```
#### Set Clear Flip-Flop with Strong Clear
```verilog
module scff_sc #(
    parameter int C2Q = 1 
)(
    input logic clk
    input logic i_set,
    input logic i_clear,
    output logic o_out
);
always_ff @(posedge clk) begin
    if (i_clear)    o_out <= #C2Q 0;
    else if (i_set) o_out <= #C2Q 1;
end
endmodule
```
#### Set Clear Flip-Flop with Strong Set
```verilog
module scff_ss #(
    parameter int C2Q = 1 
)(
    input logic clk
    input logic i_set,
    input logic i_clear,
    output logic o_out
);
always_ff @(posedge clk) begin
    if (i_set)          o_out <= #C2Q 1;
    else if (i_clear)   o_out <= #C2Q 0;
end
endmodule
```
#### T Flip-Flop
```verilog
module Tff #(
    parameter int C2Q = 1 
)(
    input logic clk,
    input logic rst,
    input logic i_toggle,
    output logic o_out
);
always_ff @(posedge clk) begin
    if (rst)            o_out <= #C2Q 0;
    else if (i_toggle)  o_out <= #C2Q ~o_out;
end
endmodule
```
#### Multiplexor 2 to 1
```verilog
module mux2 #(
    parameter int N = 16
)(
    output logic [N-1:0] o_out,
    input logic [N-1:0] i_in0,
    input logic [N-1:0] i_in1,
    input logic i_sel
);
assign o_out = i_sel ? i_in1 : i_in0;
endmodule
```
#### Multiplexor 4 to 1
```verilog
module mux4 #(
    parameter int N = 32
)(
    input logic  [N-1:0] i_in0,
    input logic  [N-1:0] i_in1,
    input logic  [N-1:0] i_in2,
    input logic  [N-1:0] i_in3,
    input logic    [1:0] i_sel,
    output logic [N-1:0] o_out
);
always_comb begin
    case (i_sel)
        2'b00 : o_out = i_in0;
        2'b01 : o_out = i_in1;
        2'b10 : o_out = i_in2;
        2'b11 : o_out = i_in3;
    endcase
end
endmodule
```
#### Possitive Edge Detector
```verilog
module PosEdgDet #(
    parameter int C2Q = 1
)(
    input logic clk,
    input logic i_in,
    output logic o_out
);
logic tmp;
always_ff @(posedge clk)
    tmp <= #C2Q i_in;
assign o_out = ~tmp & i_in;
endmodule
```
#### Negative Edge Detector
```verilog
module NegEdgDet #(
    parameter int C2Q = 1
)(
    input logic clk,
    input logic i_in,
    output logic o_out
);
logic tmp;
always_ff @(posedge clk)
    tmp <= #C2Q i_in;
assign o_out = tmp & ~i_in;
endmodule
```
#### Edge Detector
```verilog
module EdgDet #(
    parameter int C2Q = 1
)(
    input logic clk,
    input logic i_in,
    output logic o_out
);
logic tmp;
always_ff @(posedge clk)
    tmp <= #C2Q i_in;
assign o_out = tmp ^ i_in;
endmodule
```
#### Tri-State Driver
```verilog
module Tris #(
    parameter int N = 32
)(
    input logic [N-1:0] i_tris_in,
    input logic i_tris_oen_n,
    inout logic [N-1:0] o_tris_out
);
assign o_tris_out = ~i_tris_oen_n ? i_tris_in : ‘bz;
endmodule
```
#### Up Counter
```verilog
module Cnt #(
    parameter int N = 32,
    parameter int MAXCNT = 100,
    parameter int C2Q = 1
)(
    input logic clk,
    input logic i_en,
    input logic i_clear,
    output logic o_zero,
    output logic [N-1:0] o_out
);
always_ff @(posedge clk) begin
    if(i_clear) begin
        o_out <= #C2Q 0;
        o_zero <= #C2Q 1;
    end
    else if (i_en) begin
        if (o_out==MAXCNT) begin
            o_out <= #C2Q 0;
            o_zero <= #C2Q 1;
        end
        else begin
            o_out <= #C2Q o_out + 1’b1;
            o_zero <= #C2Q 0;
        end
    end
end
endmodule
```
#### Parallel to Serial Shift Register
```verilog
module P2Sreg #(
    parameter int N = 32,
    parameter int C2Q = 1
)(
    input logic clk,
    input logic reset_n,
    input logic i_ld,
    input logic i_shift,
    input logic [N-1:0] i_in,
    output logic o_out
);
logic [N-1:0] tmp_val;
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) tmp_val <= #C2Q 0;
    else begin
        if (i_ld) tmp_val <= #C2Q i_in;
        else if(i_shift) tmp_val <= #C2Q tmp_val >> 1;
    end
end
assign o_out = tmp_val[0];
endmodule
```
#### Serial to Parallel Shift Register
```verilog
module S2Preg #(
    parameter int N = 32,
    parameter int C2Q = 1
)(
    input logic clk,
    input logic i_clear,
    input logic i_shift,
    input logic i_in,
    output logic [N-1:0] o_out
);
always_ff @(posedge clk) begin
    if (i_clear)        o_out <= #C2Q 0;
    else if (i_shift)   o_out <= #C2Q {o_out[N-2:0],i_in};
end
endmodule
```
### Barrel Shift Register
```verilog
module BarShiftReg (
    parameter int N = 32,
    parameter int C2Q = 1
)(
    input logic clk,
    input logic reset_n,
    input logic i_ld,
    input logic i_shift,
    input logic [N-1:0] i_in,
    output logic [N-1:0] o_out
);
always_ff @(posedge clk) begin
    if (~reset_n) o_out <= #C2Q 0;
    else begin
        if(i_ld) 
            o_out <= #C2Q i_in;
        else if (i_shift)
            o_out <= #C2Q {o_out[N-2:0],o_out[N-1]};
    end
end
endmodule
```
#### 3 to 8 Binary Decoder
```verilog
module dec #(
    parameter int NLOG = 3
)(
    input logic [NLOG-1:0] i_in,
    output logic [((1<<NLOG))-1:0] o_out
);
int i;
always_comb begin
    for(i=0; i<(1<<NLOG); i++) begin
        if(i_in == i)   o_out[i] = 1;
        else            o_out[i] = 0;
    end
end
endmodule
```
#### 8 to 3 Binary Encoder
```verilog
module enc #(
    parameter int NLOG = 3
)(
    input logic [((1<<NLOG)-1):0] i_in,
    output logic [NLOG-1:0] o_out
);
int i;
always_comb begin
    o_out = ‘x;
    for (i=0; i<(1<<NLOG); i++) begin
        if (i_in[i]) o_out = i;
    end
end
endmodule
```
#### Priority Enfocer Module
```verilog
module PriorEnf #(
    parameter int N = 8
)(
    input logic [N-1:0] i_in,
    output logic [N-1:0] o_out,
    output logic o_found
);
int i;
always_comb begin
    o_found = 0;
    for (i=0; i<N; i++) begin
        if (i_in[i] & ~o_found) begin
            o_found = 1;
            o_out[i] = 1;
        end
        else 
            o_out[i] = 0;
    end
end
endmodule
```
#### Latch
```verilog
module Latch #(
    parameter int N = 16,
    parameter int D2Q = 1
)(
    input logic i_ld,
    input logic [N-1:0] i_in,
    output logic [N-1:0] o_out
);
always_latch begin
    if (i_ld) o_out = #D2Q i_in;
end
endmodule
```
#### Combinational Logic and Latches:
**Λάθος**:
```verilog
module mux3 #(
    parameter int N = 32 
)( 
    input logic [ 1:0] sel,
    input logic [N-1:0] in2,
    input logic [N-1:0] in1,
    input logic [N-1:0] in0,
    output logic [N-1:0] out
);
always_comb begin
    case ( sel )
        2'b00 : out = in0;
        2'b01 : out = in1;
        2'b10 : out = in2;
                    // no deffault case
    endcase
end
endmodule
```
**Σωστό**:
```verilog
module mux3 #(
    parameter int N = 32 
)( 
    input logic [ 1:0] sel,
    input logic [N-1:0] in2,
    input logic [N-1:0] in1,
    input logic [N-1:0] in0,
    output logic [N-1:0] out
);
always_comb begin
    case ( sel )
        2'b00 : out = in0;
        2'b01 : out = in1;
        2'b10 : out = in2;
        default : out = ‘x;
    endcase
end
endmodule
```
Όταν φτιάχνουμε συνδυαστική λογική με `always_comb` blocks και `logic` τότε πρέπει να αναθέτουμε τιμές στις εξόδους της λογικής για όλες τις πιθανές περιπτώσεις εισόδων (κλήσεις του `always_comb`)

