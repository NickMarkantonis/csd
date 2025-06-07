## HY342 - Παράλληλος Προγραμματισμός
### Parallel programming in Pthreads 

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

### Κοινή Μνήμη και Συγχρονισμός
#### Κοινή Μνήμη στα threads
- Όλα τα threads που ανήκουν σε μία διεργασία μοιράζονται την ίδια μνήμη, δηλαδή έχουν πρόσβαση στις ίδιες μεταβλητές, τον ίδιο χώρο σωρού (heap) και τις ίδιες ανοικτές διεργασίες αρχείων.
- Παρόλο που μπορούν να έχουν τα δικά τους τοπικά δεδομένα (π.χ δικό τους stack), η διαχείρηση της μνήμης μπορεί να οδηγήσει σε επικίνδυνα φαινόμενα, όπως **data races** και **memmory cocrruption** (βλέπε παρακάτω).

#### Προβλήμματα απο Κοινού Μνήμη
1. Ταυτόχρονη πρόσβαση σε κοινά δεδομένα (Data Races)
    - Όταν δύο ή περισσότερα threads προσπαθούν να γράψουν στην ίδια μεταβλητή ταυτόχρονα, μπορεί να προκύψουν απρόβλεπτες τιμές.
    - Αν δεν υπάρχει σωστός συγχρονισμός, η σειρά εκτέλεσης μπορεί να είναι μή ντετερμινιστική, οδηγόντας σε διαφορετικά αποτελέσματα σε κάθε εκτέλεση.

2. Memmory Corruption 
    - Ένα thread μπορεί να αλλάξει μία τιμή στην μνήμη την οποία χρησιμοποιεί και κάποιο άλλο thread, χωρίς αυτό να έχει προωλεφθεί.
    - Αν δεν υπάρχει συγχρονισμός, η πρόσβαση σε τέτοια δεδομένα μπορεί να οδηγήσει σε σφάλματα ή απρόσδεκτες συμπεριφορές.

3. Ανάγκη για συγχρονισμό
    - Για να αποφύγουμε αυτά τα προβλήματα, χρησιμοπιούμε **μηχανισμόυς συγχρονισμού**, όπως **mutexes**, **condition variables**, **reader-writter locks** και **barriers**.

### Συχρονισμός με Mutexes (Mutual Exclusion Locks)
#### Τί είναι ένα Mutex
- Ένα **mutex (mutual exclusion)** είνΌταν δύο ή περισσότερα threads προσπαθούν να γράψουν στην ίδια μεταβλητή ταυτόχρονα, μπορεί να προκύψουν απρόβλεπτες τιμές.
αι ένας μηχανισμός που επιτρέπει σε **μόνο ένα** thread να έχει πρόσβαση σε μία κρίσιμη περιοχή κώδικα κάθε φορά.
- Όταν ένα thread θέλει να εκτελέσει μία κρίσιμη λειτουργία:
    1. Κλειδώνει το mutex
    2. Εκτελέι την λειτουργία που θέλει
    3. Ξεκλειδώνει το mutex, επιτρέποντας στα άλλα threads να έχουν ξανά πρόσβαση στην κρίσιμη περιοχή

### Βασικές Συναρτήσεις Mutex
#### Δημιουργία και Καταστροφή:
- Στατική Αρχικοποίηση:
    ```c
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    ```
   
- Αρχικοποίηση με δοσμένες ιδιότητες:
    - `*mutex`: δείκτης στο mutex που θέλουμε να αρχικοποιήσουμε
    - `*attr`: δείκτης σε struct που μπορούμε να θέσουμε τις ιδιότητες του mutex
    - Επιστρέφει 0 σε επιτυχία, αλλιώς κωδικό σφάλματος
    ```c
    int pthread_mutex_init(
        pthread_mutex_t *mutex,
        const pthread_mutexattr_t *attr
    );
    ```
    - Ιδιότητες που μπορούμε να ορίσουμε:
    ```c
    int pthread_attr_init(pthread_attr_t ∗);
    int pthread_attr_destroy(pthread_attr_t ∗);
    int pthread_attr_getdetachstate(const pthread_attr_t ∗, int ∗);
    int pthread_attr_setdetachstate(pthread_attr_t ∗, int);
    int pthread_attr_getstack(const pthread_attr_t ∗, void ∗∗, size_t ∗);
    int pthread_attr_setstack(pthread_attr_t ∗, void ∗, size_t);
    int pthread_attr_getstacksize(const pthread_attr_t ∗, size_t ∗);
    int pthread_attr_setstacksize(pthread_attr_t ∗, size_t);
    int pthread_attr_getstackaddr(const pthread_attr_t ∗, void ∗∗);
    int pthread_attr_setstackaddr(pthread_attr_t ∗, void ∗);
    int pthread_attr_getguardsize(const pthread_attr_t ∗, size_t ∗);
    int pthread_attr_setguardsize(pthread_attr_t ∗, size_t);
    int pthread_attr_getinheritsched(const pthread_attr_t ∗, int ∗);
    int pthread_attr_setinheritsched(pthread_attr_t ∗, int);
    int pthread_attr_getschedparam(const pthread_attr_t ∗, struct sched_param ∗);
    int pthread_attr_setschedparam(pthread_attr_t ∗, const struct sched_param ∗);
    int pthread_attr_getschedpolicy(const pthread_attr_t ∗, int ∗);
    int pthread_attr_setschedpolicy(pthread_attr_t ∗, int);
    ```
- Καταστροφή:
    - `*mutex`: δείκτης στο mutex που θέλουμε να καταστρέψουμε
    - Όταν δεν χρειάζομαστε ποια το mutex για επελευθέρωση πόρων 
    ```c
    int pthread_mutex_destroy(pthread_mutex_t *mutex);
    ```

### Χρήση Mutex
- Κλείδωμα mutex
    - `*mutex`: το mutex που θέλουμε να κλειδώσουμε
    - Αν είναι ήδη κλειδωμένο το thread περιμένει μέχρι να ξεκλειδωθεί
    ```c
    int pthread_mutex_lock(pthread_mutex_t *mutex);
    ```
- Προσπάθεια κλειδώματος mutex
    - Όπως παραπάνω αλλα σε περίπτωση που το mutex είναι ήδη κλειδωμένο επιστρέφει εκεί που ήταν χωρίς να περιμένει
    ```c
    int pthread_mutex_trylock(pthread_mutex_t *mutex);
    ```
- Ξεκλέιδωμα mutex
    - `*mutex`: το mutex που θέλουμε να ξεκλειδώσουμε
    - Ξεκλειδώνε το mutex επιτρέποντας σε όλα τα threads να το αποκτήσουν
    ```c
    int pthread_mutex_unlock(pthread_mutex_t *mutex);
    ```

### Παράδειγμα: Producer-Consumer με Mutex
Σε αυτό το παράδειγμα, ένας παραγωγός δημιουργεί tasks και τα τοποθετεί σε μία ουρά, ενώ ένας καταναλωτής τα ανακτά και τα επεξεργάζεται.
```c
pthread_mutex_t task_lock;
int task_available;

int main() {
    task_available = 0;
    pthread_mutex_init(&task_lock, NULL);
    // Δημιουργία producer και consumer threads
}

void *producer(void *arg) {
    int inserted;
    struct task my_task;
    
    while (!done()) {
        inserted = 0;
        create_task(&my_task);
        while (inserted == 0) {
            pthread_mutex_lock(&task_lock);
            if (task_available == 0) {
                insert_into_queue(my_task);
                task_available = 1;
                inserted = 1;
            }
            pthread_mutex_unlock(&task_lock);
        }
    }
}

void *consumer(void *arg) {
    int extracted;
    struct task my_task;
    
    while (!done()) {
        extracted = 0;
        while (extracted == 0) {
            pthread_mutex_lock(&task_lock);
            if (task_available == 1) {
                extract_from_queue(&my_task);
                task_available = 0;
                extracted = 1;
            }
            pthread_mutex_unlock(&task_lock);
        }
        process_task(my_task);
    }
}
```
Τι κάνει ο κώδικας αυτός:
- Ο **παραγωγός (producer)** δημιουργεί tasks και τα προσθέτει σε μία ουρά, χρησιμοποιόντας `pthread_mutex_lock` για να διασφαλίσεις ότι δεν υπάρχει ταυτόχρονη πρόσβαση.
- Ο **καταλωτής (consumer)** περιμένει μεχρι να υπάρχει διαθέσιμο task, αποκτά το mutex, αφαιρή το task και το επεξεργάζεται

### Συγχρονισμός με Condition Variables
#### Τι είναι Condition Variables

- Οι Condition Variables χρησιμοποιούνται μαζί με mutexes για να επιτρέψουν σε ένα thread να περιμένει να ικανοποιηθεί μία συνθήκη.
- Χρησιμοποιούνται σε περιπτώσεις όπου ένα thread πρέπει να περιμένει ένα γεγονός που προκαλείται από κάποιο άλλο thread.
- Ένα thread μπορεί να περιμένει μέχρι μία συνθήκη να γίνει αληθής:
    1. Κλειδώνει το mutex.
    2. Ελέγχει αν μία μεταβλητή ικανοποιεί τη συνθήκη.
    3. Αν η συνθήκη δεν ικανοποιείται, περιμένει αφήνοντας το lock.
    4. Μόλις η συνθήκη ικανοποιηθεί από κάποιο άλλο thread, αυτό ξυπνά όσα threads περιμένουν στη συνθήκη.
    5. Ένα από αυτά θα κλειδώσει ξανά και θα συνεχίσει έχοντας το mutex.

- Το API της Condition Variable:
```c
int pthread_cond_init(
    pthread_cond_t *cond,
    const pthread_condattr_t *attr);
int pthread_cond_destroy(pthread_cond_t *cond);
int pthread_cond_wait(
    pthread_cond_t *cond,
    pthread_mutex_t *mutex);
int pthread_cond_timedwait(
    pthread_cond_t *cond,
    pthread_mutex_t *mutex, 
    const struct timespec *wtime);
int pthread_cond_signal(pthread_cond_t *cond);
int pthread_cond_broadcast(pthread_cond_t *cond);
```

#### Παράδειγμα: Producer-Consumer με Condition Variables
```c
pthread_cond_t cond_q_empty, cond_q_full;
pthread_mutex_t task_lock;
int task_available;

int main() {
    task_available = 0;
    pthread_cond_init(&cond_q_empty, NULL);
    pthread_cond_init(&cond_q_full, NULL);
    pthread_mutex_init(&task_lock, NULL);
}

void *producer(void *arg) {
    while (!done()) {
        create_task();
        pthread_mutex_lock(&task_lock);
        while (task_available == 1)  // Αν η ουρά είναι γεμάτη, περιμένει
            pthread_cond_wait(&cond_q_empty, &task_lock);

        insert_into_queue();
        task_available = 1;
        pthread_cond_signal(&cond_q_full);
        pthread_mutex_unlock(&task_lock);
    }
}

void *consumer(void *arg) {
    while (!done()) {
        pthread_mutex_lock(&task_lock);
        while (task_available == 0)  // Αν δεν υπάρχουν δεδομένα, περιμένει
            pthread_cond_wait(&cond_q_full, &task_lock);

        my_task = extract_from_queue();
        task_available = 0;
        pthread_cond_signal(&cond_q_empty);
        pthread_mutex_unlock(&task_lock);
        process_task(my_task);
    }
}
```

### Συγχρονισμός με reader-writer locks
Τα **reader-writer locks** είναι μηχανισμοί σύγχρονισμού που επιτρέπουν την διάκριση μεταξύ αναγνώσων (**readers**) και συγγραφέων (**writers**) σε μία κοινόχρηστη μεταβλητή
#### Προβλήματα που λύνουν τα RW Locks
- Αν χρησιμοποιήσουμε **mutexes**, τότε μόνο ένα thread μπορεί να έχει πρόσβαση στα δεδομένα κάθε φορά, είτε διαβάζει είτε γράφει. Αυτό είναι αναπολεσματικό αν πολλά threads απλά διαβάζουν και δεν κάνουν αλλαγές.
- Με RW lock πολλαπλά thread μπορούν ταυτόχρονα να διβάζουν χωρίς να εμποδίζουν το ένα το άλλο. Μόνο όταν ένα thread θέλει να γράψει, αποκλείονται όλα τα άλλα (αναγνώστς και συγγραφείς).

### Reader-Writter API
#### Αρχικοποίησης και καταστροφή:
```c
pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;
int pthread_rwlock_init(pthread_rwlock_t *rwlock, const pthread_rwlockattr_t *attr);
int pthread_rwlock_destroy(pthread_rwlock_t *rwlock);
```
- `rwlock`: Ο reader-writer μηχανισμός
- `attr`: επιτρέπει να ορίσουμε προσαρμοσμένες ιδιότητες, αν είναι `NULL`, χρησιμοποιούνται οι προεπιλεγμένες τιμές.
- `PTHREAD_RWLOCK_INITIALIZER`: Στατική αρχικοποίηση χωρίς `pthread_rwlock_inti()`

#### Κλείδωμα για Ανάγνωση (Read Lock)
```c
int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
```
- `rwlock`: Το lock που θα κλειδωθεί για ανάγνωση
- Επιτρέπει **πολλά threads** να διαβάζουν ταυτόχρονα **αλλά όχι συγγραφέις**.

#### Κλέιδωμα για Εγγραφή (Writer Lock)
```c
int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
```
- `rwlock`: Το lock που θα κλειδωθεί για εγγραφή
- **Μόνο ένα thread** μπορεί να το πάρει καθε φορά, και **όλοι οι ανγνώστες και συγκραφείς μπλοκάρονται** μέχρι να ξεκλειδωθεί

#### Μη-Blocking Λειτουργίες
```c
int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
```
- Όπως τα `rdlock` και `wrlock`, αλλά **αντί να μπλοκάρουν αν το lock είναι πιασμένο, επιστρέφουν αμέσως**
- Αν η κλήση πετύχει επιστρέφει 0. Αν όχι επιστρέφει `EBUSY`.

#### Ξεκλείδωμα
```c
int pthread_rwlock_unlock(pthread_rwlock_t *rwlock);
```
- Ξεκλειδώνει το lock, επιτρέποντας σε άλλα threads να το χρησιμοποιούν.
- Αν το είχε ένας αναγνώστης, επιτρέπει σε όλους του συγγραφείς να μπούν
- Αν το είχε ένας συγγραφές  επιτρέπει σε αναγνώστης **ή** άλλους να συγγραφείς να το πάρουν

### Παράδειγμα: Reader-Writer Access
Αυτό το παράδειγμα δείχνει **πολλαπλά threads** που είτε διαβάζουν (`reader_func`) είτε γράφουν (`rare_writer_func`) χρησιμοποιόντας reader-writer locks.

```c
pthread_rwlock_t data_rw_lock;   // Reader-Writer Lock
int data[1000];                  // Μοιραζόμενος πίνακας δεδομένων
pthread_t readers[NUM_READERS];   // Πίνακας με reader threads
pthread_t writer;                 // Thread που κάνει εγγραφή

int main() {
    pthread_rwlock_init(&data_rw_lock, NULL);
    
    // Δημιουργία των reader threads
    for (int i = 0; i < NUM_READERS; i++) {
        pthread_create(&readers[i], NULL, reader_func, NULL);
    }

    // Δημιουργία του writer thread
    pthread_create(&writer, NULL, rare_writer_func, NULL);

    // ...

    return 0;
}

void *reader_func(void *arg) {
    while (!done()) {
        pthread_rwlock_rdlock(&data_rw_lock);  // Κλείδωμα για ανάγνωση
        compute(data);  // Διαβάζει και κάνει επεξεργασία των δεδομένων
        pthread_rwlock_unlock(&data_rw_lock);  // Ξεκλείδωμα
    }
}

void *rare_writer_func(void *arg) {
    while (!done()) {
        pthread_rwlock_wrlock(&data_rw_lock);  // Κλείδωμα για εγγραφή
        update(data);  // Ενημέρωση δεδομένων
        pthread_rwlock_unlock(&data_rw_lock);  // Ξεκλείδωμα
    }
}
```

### Πότε να χρησιμοποιήσω RW locks αντί για Mutexes;

| **Mutex** | **Reader-Writer Lock** |
| --- | --- |
| Ένα thread κάθε φορά | Πολλοί αναγνώστες, ένας συγγραφέας |
| Όλα τα threads περιμένουν αν ένα άλλο έχει το lock | Οι αναγνώστες δεν εμποδίζονται μεταξύ τους |
| Απλούστερο και πιο αποδοτικό για μικρές κρίσιμες περιοχές | Χρήσιμο αν υπάρχουν πολλές αναγνώσεις και λίγες εγγραφές |
| Δεν διαχωρίζει αναγνώστες-συγγραφείς | Χρησιμοποιεί δύο επίπεδα πρόσβασης |

RW locks είναι ιδανικά αν τα περισσότερα threads διαβάζουν και σπάνια γίνονται εγγραφές.

**Summary**:

- Πολλοί **readers** μπορούν να διαβάζουν ταυτόχρονα.
- **Writer** χρειάζεται αποκλειστική πρόσβαση (μόνο του), άρα περιμένει αν υπάρχουν active readers ή άλλος writer.
- Όταν ένας writer γράφει, κανείς άλλος (reader ή writer) δεν μπαίνει.

### Bariers: Συγχρονισμός μεταξύ πολλών threads
#### Τί είναι τα Barriers;
- Τα barriers (φράγες συγχρονισμού) είναι ένας μηχανισμός όπου όλα τα threads περιμένουν να φτάσουν σε ένα συγκεκριμμένο σημείο π´ριν συνεχίσουν.
- Σκεφτείτε το σαν μία γραμμή εκκίνησης όπου διαφορετικά threads πρέπει να συγχρονιστούν πρίν εκτελέσουν την επόμενη φάση υπολογισμού

#### Χαρακτηριστικά των Barriers
- Δεν χρειάζονται όλα τα threads να περιμένουν - μόνο ένας προκαθορισμένος αριθμός
- Συμπεριφέρεται σαν έναν καταμετρητή (counter) που περιμένει να φτάσουν όλα τα απαραίτητα threads πριν τους επιτρέψει να προχωρήσουν.

### Barrier API (POSIX Pthreads)
#### Αρχικοποίηση και καταστροφή

```c
int pthread_barrier_init(
    pthread_barrier_t *barrier, 
    const pthread_barrierattr_t *attr, 
    unsigned count
);
```
- `barrier`: Δείκτης στο barrier object που θα αρχικοποιηθεί.
- `attr`: Δομή με ιδιότητες του barrier
- `count`: Ο αριθμός των threads που πρέπει να φτάσουν στο barrier πριν συνεχίσουν

```c
int pthread_barrier_destroy(pthread_barrier_t *barrier);
```
- Χρησιμοποιείται για να καταστρέψει το barrier και να απελευθερώσει πόρους.

#### Χρήση του Barrier
```c
int pthread_barrier_wait(pthread_barrier_t *barrier);
```
- Όταν ένα thread καλεί `pthread_barrier_wait`, **μπλοκάρεται** μέχρι να φτάσουν όλα τα απαραίτητα threads
- Όταν το τελευταίο thread φτάσει στο barrier, όλα τα threads απελευθερώνονται ταυτόχρονα.

### Παράδειγμα: Χρήση Barrier
```c
#include <stdio.h>
#include <pthread.h>

#define NUM_THREADS 4

pthread_barrier_t barrier;

void *worker_func(void *arg) {
    int id = *(int *)arg;
    printf("Thread %d: Έφτασα στο barrier.\n", id);
    
    pthread_barrier_wait(&barrier); // Όλα τα threads περιμένουν εδώ

    printf("Thread %d: Συνεχίζω μετά το barrier.\n", id);
    return NULL;
}

int main() {
    pthread_t threads[NUM_THREADS];
    int thread_ids[NUM_THREADS];

    pthread_barrier_init(&barrier, NULL, NUM_THREADS); // Barrier για 4 threads

    for (int i = 0; i < NUM_THREADS; i++) {
        thread_ids[i] = i;
        pthread_create(&threads[i], NULL, worker_func, &thread_ids[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    pthread_barrier_destroy(&barrier);
    return 0;
}
```
**Εξήγηση κώδικα**
- Δημιουργούμε 4 threads που καλούν `pthread_barrier_wait`.
- Κανένα δεν συνεχίζει μέχρι να φτάσουν όλα στο barrier
- Ότνα φτάσει το 4ο thread, όλα συνεχίζουν ταυτόχρονα

### Πιθανά προβλήματα με Threads
**1. fork() και exec() με threads**
- Όταν ένα multi-threaded πρόγραμμα εκτελεί `fork()`, μόνο το thread που κάλεσε το fork επιβιώνει στο νέο process
- Αυτό μπορεί να προκαλέσει ασυνέπειες στη μνήμη αν το πρόγραμμα δεν είναι σχεδιασμένο σωστά
- Η λύση είναι η χρήση της `pthread_atfork()` που επιτρέπει σωστό συγχρονισμό πρίν και μετά απο `fork()`.

**2. Thread Safety**
- Ορισμένες συναρτήσεις της C, δεν είναι thread-safe, π.χ. `strtok()`, `gethostbyname()`, `ctime()`.
- Αντί για αυτές υπάρχουν reentrant εκδόσεις (π.χ `strtok_r(), gethostbyname_r()`).

**3. Λάθη λόγω errno**
- Η `errno` είναι μία μεταβλητή που δείχνει τον τελευταίο κωδικό σφάλματος
- Σε multi-threaded πρόγραμμα, κάθε thread έχει δική του errno

### Deadlocks (Αδιέξοδα στα threads)
Τι είναι το deadlock;
- Ένα deadlock συμβαίνει όταν δύο ή περισσότερα threads περιμένουν το ένα το άλλο να ξεκλειδώσει κάποιον πόρο.
- Κανένα thread δεν μπορεί να συνεχίσει, με αποτέλεσμα το πρόγραμμα να "κολλήσει" επ' άπειρον

#### Παράδειγμα Deadlock
```c
pthread_mutex_lock(&lockA);
pthread_mutex_lock(&lockB);
work();
pthread_mutex_unlock(&lockA);
pthread_mutex_unlock(&lockB);

// Σε άλλο thread:
pthread_mutex_lock(&lockB);
pthread_mutex_lock(&lockA);
work();
pthread_mutex_unlock(&lockB);
pthread_mutex_unlock(&lockA);
```
- Άν το πρώτο thread κλειδώσει το `lockA` και το δεύτερο `lockB`, το καθένα περιμένει το άλλο και κανένα δεν προχωρά

#### Πώς αποφέυγεται το Deadlock
1. Να τηρείται μία σταθερή σειρά κλειδώματος (π.χπ πάντα πρώτα `lockA` και μετά `lockB`)
2. Χρήση `trylock()` αντί για `lock()` για να αποφέυγεται η αναμονή.

### Livelock (Ζωντανό Αδιέξοδο)
- Στο livelock, τα threads δεν είναι μπλοκαρισμένα αλλά συνεχώς αλλάζουν κατάσταση χωρίς να κάνουν πρόοδο.
- Συχνά συμβαίνει όταν δύο threads προσπαθούν να είναι "ευγενικά" και να παραχωρήσουν τον πόρο το ένα στο άλλο.

#### Παράδειγμα Livelock
```c
while (retrying) {
    if (pthread_mutex_trylock(&lockA)) {
        if (pthread_mutex_trylock(&lockB)) {
            work();
            pthread_mutex_unlock(&lockB);
            retrying = 0;
        }
        pthread_mutex_unlock(&lockA);
    }
}
```
- Αν δύο threads κάνουν το ίδιο, μπορεί να κλειδώνουν αμέσως και να ξαναδοκιμάζουν χωρίς να κάνουν πρόοδο

### Priority Inversion (Αναστροφή Προτεραιότητας)
- Ένα thread υψηλής προτεραιότητας περιμένει για έναν πόρο που κατέχει ένα thread χαμηλής προτεραιότητας.
- Άν ένα thread μεσαίας προτεραιότητας εμποδίζει το χαμηλό να εκτελεστεί, το υψηλό μένει κολλημένο.

```c
pthread_mutex_lock(&resource);  // Χαμηλού προτεραιότητας thread
// ... κάνει κάποια επεξεργασία ...
pthread_mutex_unlock(&resource);
```
- Άν ένα **μεσαίο thread** εκτελείται συνεχώς, το χαμηλό δεν ξεκλειδώνει τον πόρο, και το υψηλό περιμένει επ' άπειρο

**Λύση:**
- Χρήση **Priority Inheritance**, όπου ένα χαμηλού προτεραιότητας thread κρατάει lock, αυξάνει προσωρινά η προτεραιότητα ώστε να ξεκλειδώσει γρήγορότερα.


### Πρότυπα Παραλληλισμού 
#### 1. doall ή forall
##### Doall
Ο *Doall* είναι ένας τύπος παραλληλισμού που εφαρμόζεται όταν όλες οι επαναλήψεις ενός βρόχου μπορούν να εκτελεστούν ανεξάρτητα η μία απο την άλλη, χωρίς να υπάρχουν εξαρτήσεις μεταξύ τους. Αυτό σημαίνει ότι όλες οι επαναλήψεις μπορούν να εκτελεστούν ταυτόχρονα, δεδομένου ότι υπάρχουν αρκετοί επεξεργαστές.

**Χαρακτηριστικά:**
1. Δεν υπάρχουν εξαρτήσεις δεδομένων μεταξύ των επαναλήψεων
2. Όλες οι επαναλήψεις εκτελούνται ταυτόχρονα, αν υπάρχει επαρκής υπολογιστική ισχύς
3. Ιδανικό για απόλυτα ενξάρτητους υπολογισμούς.
4. Συχνά εφαρμόζεται σε [SIMD](https://en.wikipedia.org/wiki/Single_instruction,_multiple_data) και [MIMD](https://en.wikipedia.org/wiki/Multiple_instruction,_multiple_data) αρχιτεκτονικές.

##### Forall
Ο *Forall* είναι ο πίο γενικός τρόπος παράλληλης εκτέλεσης βροχών και χρησιμοποιείται κυρίως σε γλώσσες προγραμματισμού υψηλού επιπέδου και αριθμητικούς υπολογισμούς. Σε αντίθεση με το Doall, επιτρέπει συγχρονισμό μεταξύ των επαναλήψεων, αλλα εξακολουθεί να διατηρεί μία παραλληλιστική προσέγγιση.

**Χαρακτηριστικά:**
1. Μπορεί να επιτρέπει κάποιο συγχρονισμό μεταξύ των επαναλήψεων.
2. Χρησιμοποιείται συχνά σε υπολογιστικά συστήματα με διάνυσμα και σε υψηλού επιπέδου γλώσσες προγραμματισμού
3. Εστιάζει στην περιγραφή του υπολογισμού χωρίς να καθορίζει άμεσα την ακολουθιακή ή παράλληλη εκτέλεση.

##### Πότε χρησιμοποιούμε κάθε έναν;
- **Doall**: Όταν κάθε επανάληψη μπορεί να εκτελεστεί χωρίς καμία εξάρτηση από άλλες.
- **Forall**: Όταν υπάρχει κάποια εξάρτηση, άλλα μπορούμε να επιτρέψουμε έναν ελεγχόμενο συγχρονισμό.

##### forall με Pthreads:
- Αρχικός Κώδικας:
```c
for(i = 0; i < 1000000; i++) {
    C[i] = A[i] + B[i];
}
```
- Μετά την μετατροπή:
```c
struct thread_arg {
    int from;
    int to;
    pthread_t thread;
};

void ∗do_work(void ∗voidarg) {
    struct thread_arg ∗arg = (struct thread_arg ∗)voidarg;
    for(i = arg->from; i < arg->to; i++) {
        C[i] = A[i] + B[i];
    }
}

void parallelfor() {
    struct thread_arg[NUM_THREADS];
    int from = 0, to = 1000000;
    int step = to / NUM_THREADS;
    int i ;
    for(i = 0; i < NUM_THREADS; i++) {
        thread_arg[i].from = from;
        thread_arg[i].to = (i < NUM_THREADS-1) ? (from + step) : to;
        from = to;
        pthread_create(&thread_arg[i].thread, NULL, &do_work, &thread_arg[i]);
    }
    for(i = 0; i < NUM_THREADS; i++) {
        pthread_join(thread_arg[i].thread, NULL);
    }
}
```

Ζητήματα:
- Κάθε thread θέλει καινούργιο step
- Κόστος δημιουργίας και join
- Κώδικας βιβλιοθήκης - παράλληλη χρήση παράλληλου κώδικα
- Διαχείριση πόρων

#### 2. Pipeline
Το Pipeline είναι μια τεχνική που χρησιμοποιείται για να διαχωρίσουμε τη δουλειά σε στάδια, με το καθένα από αυτά να εκτελεί μια συγκεκριμένη εργασία. Αντί να εκτελούνται όλες οι εργασίες σειριακά, κάθε στάδιο του pipeline εκτελείται παράλληλα με τα άλλα στάδια, και τα δεδομένα ρέουν μέσα από το pipeline.
Η ιδέα είναι ότι όλα τα βήματα της δουλειάς εκτελούνται ταυτόχρονα, αλλά κάθε βήμα έχει διαφορετικά δεδομένα.
Σκεφτείτε το σαν μια γραμμή παραγωγής: κάθε εργάτης (στάδιο) κάνει τη δουλειά του και περνά το προϊόν (δεδομένα) στον επόμενο εργάτη. Αν όλοι οι εργάτες δουλεύουν ταυτόχρονα, το σύνολο της παραγωγής γίνεται πολύ πιο γρήγορα!

##### Παράδειγμα pipeline
```c
#include<stdio.h>
#include<pthread.h>

queue_t ph1_ph2_buffer;
queue_t ph2_ph3_buffer;

void ∗phase1(void ∗a) {
    while(!done()) {
        read_from_file(data);
        process1(data);
        enqueue(ph1_ph2_buffer, data);
    }
}

void ∗phase2(void ∗a) {
    while(!done()) {
        data = dequeue(ph1_ph2_buffer);
        process2(data);
        enqueue(ph2_ph3_buffer, data);
    }
}

void ∗phase3(void ∗a) {
    while(!done()) {
        data = dequeue(ph2_ph3_buffer);
        save_to_file(data);
    }
}
```

#### 3. Task (recursive)
Το recursive task (αναδρομικό task) είναι μια μέθοδος για να σπάσουμε ένα πρόβλημα σε μικρότερα υποπροβλήματα και να τα επιλύσουμε παράλληλα. Αυτή η μέθοδος είναι συχνά χρήσιμη όταν το πρόβλημα μπορεί να διαχωριστεί σε πολλά υποπροβλήματα που είναι αυτόνομα και παράλληλα εκτελέσιμα.
Πιο ααλυτικά:
- **Task**: Στη βάση του, ένα task είναι ένα ανεξάρτητο "κομμάτι δουλειάς" που μπορεί να εκτελείται παράλληλα με άλλα tasks. Για παράδειγμα, το task μπορεί να είναι μια λειτουργία ή υπολογισμός.
- **Recursive Task**: Σε έναν αναδρομικό παράλληλο αλγόριθμο, το πρόβλημα σπάει σε μικρότερα υποπροβλήματα. Κάθε υποπρόβλημα είναι ένα αναδρομικό task, το οποίο μπορεί να εκτελείται είτε σειριακά είτε παράλληλα με άλλες αναδρομικές κλήσεις.

#### Divide and Conquer
Το Divide and Conquer (Διαίρεση και Κατάκτηση) είναι μια στρατηγική που χρησιμοποιείται για την επίλυση σύνθετων προβλημάτων. Η βασική ιδέα πίσω από αυτή τη στρατηγική είναι ότι μπορούμε να διαιρέσουμε το πρόβλημα σε μικρότερα υποπροβλήματα, να τα επιλύσουμε και μετά να συγκεντρώσουμε τα αποτελέσματα για να λύσουμε το αρχικό πρόβλημα.
Αυτή η τεχνική έχει το πλεονέκτημα ότι τα υποπροβλήματα μπορεί να επιλυθούν παράλληλα, βελτιώνοντας έτσι την απόδοση του αλγορίθμου.

#### 4. MapReduce
Το MapReduce είναι ένα μοντέλο προγραμματισμού και μια αρχιτεκτονική που χρησιμοποιείται για να επεξεργάζεται μεγάλες ποσότητες δεδομένων με παράλληλο τρόπο σε διανεμημένα συστήματα. Το μοντέλο διαχωρίζει τη διαδικασία επεξεργασίας σε δύο βασικά βήματα: το Map και το Reduce.
Ο βασικός στόχος του MapReduce είναι να επιτρέπει την επεξεργασία τεράστιων όγκων δεδομένων σε πολλές μηχανές (όπως σε ένα cluster), έτσι ώστε η επεξεργασία να είναι πιο γρήγορη και αποτελεσματική.


### Thread Pool
Το thread pool είναι μια τεχνική διαχείρισης νήματος όπου δημιουργούμε έναν πεπερασμένο αριθμό απο threads εκ των προτέρων και τα επαναχρησιμοποιούμε για την εκτέλεση πολλαπλών εργασιών. Αυτό μειώνει το κόστος δημιουργίας και καταστροφής threads, καθιστώντας την εκτέλεση πιο αποδοτική. Χωρίς αυτό θα έπρεπε να δημιουργήσουμε ένα νέο thread για κάθε εργασία που θα οδηγούσε σε **υψηλότερο κόστος δημιουργίας/καταστροφής απο threads**, **πιθανή υπερφόρτωση συστήματος** και **ασυντόνιστη εκτέλεση**.

#### Παράμετροι που το επηρεάζουν:
1. Καλύτερος καταμετρισμός εργασίας
    - Οι εργασίες κατανέμονται όσο το δυνατόν πιο ισόποσα
    - Ενα καλό *Load Balancing* εξασφαλίζει ότι όλα τα threads έχουν παρόμοιο φόρτο εργασίας
2. Περισσότερα κομμάτια
    - Ο κατακερματισμός της εργασίας σε περισσότερα μικρά tasks βοηθά στην καλύτερη εξισορρόπηση
3. Overhead (χρόνος `dequeue()`)
    - Η διαχείριση των εργασιών έχει ένα κόστος (overhead)
    - Άν έχουμε πολλά μικρά tasks μπορεί ο χρόνος διαχείρισης να γίνει μεγαλύτερος απο τον κανονικό χρόνο εκτέλεσης της εργασίας
4. Fine-grain vs Coarse-grain: Ισορροπία
    - Το μέγεθος των tasks που δίνουμε στα threads
    - Διαφέρει απο επεξεργαστή σε επεξεργαστή
    - Fine-Grain:
        - πολλά μικρά tasks
        - Καλύτερη κατανομή φορτίου
        - Υψηλό overhead
    - Coarse-Grain:
        - Λίγα μεγάλα tasks
        - Χαμηλότερο overhead
        κίνδυνος ανισοκατανομής αν τα tasks δεν είναι ίδιας διάρκειας

#### παράδειγμα thread pool:
```c
pthread_t threads[NUM_THREADS];
queue_t available_work;

void∗ worker_thread(void∗ arg) {
    /∗ ... ∗/
    while(!done()) {
        task_t work = dequeue(available_work);
        run(task);
    }
}

int main() {
    /∗ ... ∗/
    for(i = 0; i < NUM_THREADS; i++) {
        pthread_create(&threads[i], NULL, &worker_thread, arg);
    }
    for(i = 0; i < WORK_PIECES; i++) {
        /∗ create work ∗/
        enqueue(available_work, task);
    }
    for(i = 0; i < NUM_THREADS; i++) {
        pthread_join(&threads[i], NULL);
    }
}
```

### False Sharing
Το False Sharing είναι ένα φαινόμενο στο οποίο πολλά threads τροποποιούν διαφορετικές μεταβλητές που όμως βρίσκονται στην ίδια cache line, οδηγόντας σε περιττές ενημερώσεις μνήμης και μείωση της απόδοσης αφού κάθε φορά που ένα thread θέλει να τροποποιήσει την μεταβλητή του όλα τα άλλα πρέπει να περιμένουν ακόμα και αν έχουν διαφορετική μεταβλητή.
Μπορούμε να το αποφύγουμε κυρίος με δύο τρόπους:
1. memalign
    Μπορούμε να χρησιμοποιήσουμε την συνάρτηση `posix_memalign()` που μας επιτρέπει να δεσμέυσουμε μνήμη που ευθυγραμμίζεται σε πολλαπλάσια ενός αριθμού, π.χ. 64 bytes (ώστε να ταιρίαζε με cache lines). Έχει την δομή:
    ```c
    int posix_memalign(
        void** memptr,
        size_t alignment,
        size_t size
    );
    ```
    - `*memptr`: αποτέλεσμα 
    - `size`: πόσα bytes να δεσμέυσει
    - `allignment`: διέυθυνση πολλαπλάσιο του allignment (δύναμη του 2)
2. padding
Είναι μία απλή τεχνική που προσθέτει έξτρα χώρο ανάμεσα στις μεταβλητές για να τις αναγκάσει να είναι σε διαφορετικές cache lines.
