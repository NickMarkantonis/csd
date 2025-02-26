## HY342 - Παράλληλος Προγραμματισμός
### 11-02-2025 | Διάλεξη 1

## Pthreads
1. Διεργασίες και Νήματα (Processes and Threads):
    - Τα **Νήματα** είναι ανεξάρτητες σειρές εντολών που μπορούν να εκτελεστούν ταυτόχρονα 
απο το λειτουργηκό σύστημα
    - Κάθε νήμα υπάρχει εντός μία διεργασίας (process) και μοιράζεται τα δεδομένα της 
διεργασίας, αλλα έχει το δικό του stack pointer, registers, και άλλα απαραίτητα 
στοιχεία για την εκτέλεση.
    - Η **διεργασία (process)** περιέχει όλα τα δεδομένα που χρειάζεται το λειτουργικό σύστημα για 
να εκτελέσει ένα πρόγραμμα:
        1. *Process ID*, *process group ID*, *user ID* και  *group ID*
            - Process ID: Ένα μοναδικό Αναγνωριστικό για κάθε διεργασία
            - Process group ID: Χρησιμοποιείται για την διαχείριση ομαδών διεργασιών
            - User ID και group ID: Καθορίζουν τα δικαιώματα πρόσβασης της διεργασίας
        2. Enviroment
            - Περιβάλλον εκτέλεσης της διεργασίας, όπως μεταβλητές περιβάλλοντος (enviroment variables) που μπορούν να χρησιμποποιηθούν από το πρόγραμμα
        3. Working Directory
            - Ο τρέχων κατάλογος στον οποίο εκτελέιται η διεργασία. Αυτός ο κατάλογος χτησιμοποιείται για σχετικές διαδρομές αρχείων
        4. Program Instructions
            - Οι εντολές του προγράμματος που εκτελεί η διεργασία. Αυτές είναι οι εντολές που βρίσκονται στος **text_segment** της μνήμης
        5. Registers
            - Οι καταχωρητές (registers) της CPU που χρησιμοποιούνται για την εκτέλεση του προγράμματος. Αυτοί αποθυκέυουν προσωρινά δεδομένα και διευθύνσεις μνήμης.
        6. Stack
            - Το **stack** χρησιμποιείται για την αποθύκευση τοπικών μεταβλητών και πληροφοριών κλήσης συναρτήσεων
        7. Heap
            - Το **heap** είναι μία περιοχή μνήμης που χρησιμοποιήται για την δυναμική διαχείριση μνήμης (π.χ. με`malloc` και `free`). Εδώ αποθυκέυονται τα δεδομένα που έχουν δυναμικά δεσμευτεί κατά την εκτέλεση τουπρογράμματος.
        8. File descriptors
            - Αριθμοί που χρησιμοποιούνται για την πρόσβαση σε αρχεία, sockets, pipes κ.λπ. Κάθε αρχείο που ανοίγει η διεργασία έχει έναν file descriptor.
        9. Signal Actions
            - Πληροφορίες σχετικά με την τρόπο που η διεργασία χειρίζεται σήματα (signals) από το λειτουργικό σύστημα ή άλλες διεργασίες
        10. Shared Libraries
            - Βιβλιοθήκες που χρησιμοποιούνται απο το πρόγραμμα και μοιράζονται μεταξύ πολλών διεργασιών για εξοικονόμηση μνήμης
        11. Αντικείμενα που λειτυργούν μεταξύ διεργασιών
            - Μηχανισμοί για επικοινωνία μεταξύ διεργασιών

2. POSIX Threads (Pthreads):
    - Το **POSIX (Operating System Interface)** είναι ένα πρότυπο που ορίζει το interface 
μεταξύ του λειτουργικού συστήματος και των εφαρμογών.
    - Τα **Pthreads** είναι το πρότυπο για την διαχείριση νημάτων σε συστήματα Unix-like
    - Τα Pthreads παρέχουν API για την δημιουργία, την διαχείριση και τον συγχρονισμό 
νημάτων

3. Οι κύριες συναρτήσεις που θα δούμε:
    - Η συνάρτηση `pthread_create` χρησιμοποιείται για την δημιουργία ενός νέου νήματος. Το νήμα ξεκινά
εκτελώντας μια συνάρτηση που ορίζεται απο τον προγραμματιστή, Έχει την δομή:
    ```c
    int pthread_create(
        pthread_t *tid,
        const pthread_attr_t *attr,
        void* (*start_routine)(void*),
        void* arg
    );
    ```
    Δημιουργεί ένα thread που μόλις άρχισε να εκτελείται, θα καλέσει τη συνάρτηση `start_routine(arg)` και
γράφει στο `tid` το ID του νέου thread, πχ:
    ```c
    pthread_t tid;
    pthread_create(&tid,NULL,start_routine,arg);
    ```
    Εδώ το `start_routine` είναι η συνάρτηση που θα εκτελεστεί και θα πάρει παραμέτρους τις `arg`
    - Η συνάρτηση `pthread_exit` χρησιμοποιείται για τον τερματισμό ενός νήματος. Το όρισμα της συνάρτησης 
αποθυκεύεται και μπορεί να ανακτηθεί από άλλο νήμα που περιμένει το τερματισμό του. Έχει την δομή:
    ```c
    int pthread_exit(void *value_ptr);
    ```
    Θα μπορούσαμε να πούμε πως είναι ανάλογη του "return value".
    - Η συνάρτηση `pthread_join` χρησιμοποιείται για να περιμένει ένα νήμα μέχρι να τερματιστεί ένα άλλο 
νήμα. Επιστρέφει το αποτέλεσμα του νήματος που τερμάτισε στο `value_ptr`. Έχει την δομή:
    ```c
    int pthread_join(
        pthread_t tid,
        void **value_ptr
    );
    ```
    - Η συνάρτηση `pthread_cancel` χρησιμοποιείται για να τερματίσει ένα νήμα απο έξω, δηλαδή απο ένα άλλο
νήμα. Αυτή η λειτουργία είναι χρήσιμη όταν θέλουμε να σταματήσουμε την εκτέλεση ενός νήματος που δεν μπορεί
ή δέν θελει να τερματίσει απο μόνο του. Έχει την δομή:
    ```c
    int pthread_cancel(pthread_t tid);
    ```

4. Παραδείγματα Κώδικα:
    - Ακολουθεί ένα παράδειγμα κώδικα
    ```c
    #include <stdio.h>
    #include <pthread.h>
    
    void ∗do_something(void ∗p) {
        printf(”Hello from %s thread\n”, (char∗)p);
        return NULL;
    }
    
    int main() {
        pthread_t tid;
        char ∗msg1 = ”parent”, ∗msg2 = ”child”;
        pthread_create(&tid, NULL, do_something, msg2);
        do_something(msg1);
    return 0;
    }
    ```
    Στο παράδειγμα αυτό δημιουργείται ένα νήμα που εκτελέι την συνάρτηση `do_something`. Το κύριο νήμα 
(parent) και το νέο νήμα (child) εκτελούν την ίδια συνάρτηση, αλλα μπορεί να υπάρξει **reace condition** 
επειδή και τα δύο νήματα προσπαθούν να γράψουν στην ίδια έξοδο (το terminal) ταυτόχρονα.
    - Άλλο ένα παράδειγμα
    ```c
    #include <stdio.h>
    #include <pthread.h>
    
    void ∗do_something(void ∗p) {
        printf(”Hello from %s thread\n”, (char∗)p);
        return NULL;
    }

    int main() {
        pthread_t tid;
        char ∗msg1 = ”parent”, ∗msg2 = ”child”;
        pthread_create(&tid, NULL, do_something, msg2);
        do_something(msg1);
        pthread_join(tid, NULL);
        return 0;
    }
    ```
    Σε αυτό το παράδειγμα προσθέτουμε την `pthread_join` για να συγχρονιστεί ο τερματισμός του νήματος. Αυτό
εξασφαλίζει ότι το κύριο νήμα θα περιμένει το τέλος του child νήματος πρίν τερματιστεί.

### Βασικές έννοιες
- **Thread-safe**: Ένας όρος που περιγράφει αν ένα πρόγραμμα ή μία βιβλιοθήκη μπορεί να εκτελεστεί ασφαλώς σε
περιβάλλον πολλαπλών νημάτων.
- **Race condition**: Όταν δύο ή περισσότερα νήματα προσπαθούν να προσπελάσουν ταυτόχρονα την ίδια μνήμη,
τουλάχιστον ένα απο τα οποία γράφει, χωρίς συγχρονισμό.

### Συμπεράσματα
- Τα νήματα είναι ισχυρά εργαλεία για την υλοποίηση παραλληλισμού, αλλα απαιτούν προσεκτικό συγχρονισμό για
να αποφευχθούν προβλήματα όπως τα race conditions.
- Η χρήση των `pthread_create`, `pthread_join` και `pthread_exit` είναι βασική για την διαχείριση νημάτων
σε προγράμματα C.

