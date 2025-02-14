## HY342 - Παράλληλος Προγραμματισμός
### 14-02-2025 | Διάλεξη 2

#### Κοινή Μνήμη και Συγχρονισμός
##### Κοινή Μνήμη στα threads
- Όλα τα threads που ανήκουν σε μία διεργασία μοιράζονται την ίδια μνήμη, δηλαδή έχουν πρόσβαση στις ίδιες μεταβλητές, τον ίδιο χώρο σωρού (heap) και τις ίδιες ανοικτές διεργασίες αρχείων.
- Παρόλο που μπορούν να έχουν τα δικά τους τοπικά δεδομένα (π.χ δικό τους stack), η διαχείρηση της μνήμης μπορεί να οδηγήσει σε επικίνδυνα φαινόμενα, όπως **data races** και **memmory cocrruption** (βλέπε παρακάτω).

##### Προβλήμματα απο Κοινού Μνήμη
1. Ταυτόχρονη πρόσβαση σε κοινά δεδομένα (Data Races)
- Όταν δύο ή περισσότερα threads προσπαθούν να γράψουν στην ίδια μεταβλητή ταυτόχρονα, μπορεί να προκύψουν απρόβλεπτες τιμές.
- Αν δεν υπάρχει σωστός συγχρονισμός, η σειρά εκτέλεσης μπορεί να είναι μή ντετερμινιστική, οδηγόντας σε διαφορετικά αποτελέσματα σε κάθε εκτέλεση.

2. Memmory Corruption 
- Ένα thread μπορεί να αλλάξει μία τιμή στην μνήμη την οποία χρησιμοποιεί και κάποιο άλλο thread, χωρίς αυτό να έχει προωλεφθεί.
- Αν δεν υπάρχει συγχρονισμός, η πρόσβαση σε τέτοια δεδομένα μπορεί να οδηγήσει σε σφάλματα ή απρόσδεκτες συμπεριφορές.

3. Ανάγκη για συγχρονισμό
- Για να αποφύγουμε αυτά τα προβλήματα, χρησιμοπιούμε **μηχανισμόυς συγχρονισμού**, όπως **mutexes**, **condition variables**, **reader-writter locks** και **barriers**.

#### Συχρονισμός με Mutexes (Mutual Exclusion Locks)
##### Τί είναι ένα Mutex
- Ένα **mutex (mutual exclusion)** είναι ένας μηχανισμός που επιτρέπει σε **μόνο ένα** thread να έχει πρόσβαση σε μία κρίσιμη περιοχή κώδικα κάθε φορά.
- Όταν ένα thread θέλει να εκτελέσει μία κρίσιμη λειτουργία:
    1. Κλειδώνει το mutex
    2. Εκτελέι την λειτουργία που θέλει
    3. Ξεκλειδώνει το mutex, επιτρέποντας στα άλλα threads να έχουν ξανά πρόσβαση στην κρίσιμη περιοχή

##### Βασικές Συναρτήσεις Mutex
###### Δημιουργία και Καταστροφή:
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

###### Χρήση Mutex
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

##### Παράδειγμα: Producer-Consumer με Mutex
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

#### Συγχρονισμός με Condition Variables
##### Τί είναι Condition Variables
- Οι Condition Variables χρησιμοποιούνται μαζί με mutexes για να επιτρέψουν σε ένα thread να περιμένει να ικανοποιηθεί μία συνθήκη.
- Χρησιμοποιείται σε περιπτώσεις όπου ένα thread πρέπει να περιμένει ένα γεγονός που προκαλείται απο κάποιο άλλο thread
- Ένα thread μπορεί να περιμένει μέχρι μία συνθήκη να γίνει αληθής:
    1. Κλειδώνει το mutex
    2. Ελέγχει αν μία μεταβλητή ικανοποιέι τη συνθήκη
    3. Αν η συνθήκη δεν ικανονοποιείται, περιμένει αφήνοντας το lock
    4. Μόλις η συνθήκη ικανοποιηθεί από κάποιο άλλο thread, αυτό ξυπνά όσα threads περιμένουν στη συνθήκη
    5. Ένα απο αυτά θα κλειδώσει και τα συνεχίσει έχοντας το mutex
- Το API της condition:
```c
int pthread_cond_init(
    pthread_cond_t ∗cond,
    const pthread_condattr_t ∗attr);
int pthread_cond_destroy(pthread_cond_t ∗cond);
int pthread_cond_wait(
    pthread_cond_t ∗cond,
    pthread_mutex_t ∗mutex);
int pthread_cond_timedwait(
    pthread_cond_t ∗cond,
    pthread_mutex_t ∗mutex, 
    const struct timespec ∗wtime);
int pthread_cond_signal(pthread_cond_t ∗cond);
int pthread_cond_broadcast(pthread_cond_t ∗cond);
```

##### Παράδειγμα: Producer-Consumer με Condition Variables
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

#### Συγχρονισμός με reader-writer locks
Τα **reader-writer locks** είναι μηχανισμοί σύγχρονισμού που επιτρέπουν την διάκριση μεταξύ αναγνώσων (**readers**) και συγγραφέων (**writers**) σε μία κοινόχρηστη μεταβλητή
##### Προβλήματα που λύνουν τα RW Locks
- Αν χρησιμοποιήσουμε **mutexes**, τότε μόνο ένα thread μπορεί να έχει πρόσβαση στα δεδομένα κάθε φορά, είτε διαβάζει είτε γράφει. Αυτό είναι αναπολεσματικό αν πολλά threads απλά διαβάζουν και δεν κάνουν αλλαγές.
- Με RW lock πολλαπλά thread μπορούν ταυτόχρονα να διβάζουν χωρίς να εμποδίζουν το ένα το άλλο. Μόνο όταν ένα thread θέλει να γράψει, αποκλείονται όλα τα άλλα (αναγνώστς και συγγραφείς).