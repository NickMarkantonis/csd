## HY342 - Παράλληλος Προγραμματισμός
### 18-02-2025 | Διάλεξη 3

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

#### Reader-Writter API
##### Αρχικοποίησης και καταστροφή:
```c
pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;
int pthread_rwlock_init(pthread_rwlock_t *rwlock, const pthread_rwlockattr_t *attr);
int pthread_rwlock_destroy(pthread_rwlock_t *rwlock);
```
- `rwlock`: Ο reader-writer μηχανισμός
- `attr`: επιτρέπει να ορίσουμε προσαρμοσμένες ιδιότητες, αν είναι `NULL`, χρησιμοποιούνται οι προεπιλεγμένες τιμές.
- `PTHREAD_RWLOCK_INITIALIZER`: Στατική αρχικοποίηση χωρίς `pthread_rwlock_inti()`

##### Κλείδωμα για Ανάγνωση (Read Lock)
```c
int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
```
- `rwlock`: Το lock που θα κλειδωθεί για ανάγνωση
- Επιτρέπει **πολλά threads** να διαβάζουν ταυτόχρονα **αλλά όχι συγγραφέις**.

##### Κλέιδωμα για Εγγραφή (Writer Lock)
```c
int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
```
- `rwlock`: Το lock που θα κλειδωθεί για εγγραφή
- **Μόνο ένα thread** μπορεί να το πάρει καθε φορά, και **όλοι οι ανγνώστες και συγκραφείς μπλοκάρονται** μέχρι να ξεκλειδωθεί

##### Μη-Blocking Λειτουργίες
```c
int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
```
- Όπως τα `rdlock` και `wrlock`, αλλά **αντί να μπλοκάρουν αν το lock είναι πιασμένο, επιστρέφουν αμέσως**
- Αν η κλήση πετύχει επιστρέφει 0. Αν όχι επιστρέφει `EBUSY`.

##### Ξεκλείδωμα
```c
int pthread_rwlock_unlock(pthread_rwlock_t *rwlock);
```
- Ξεκλειδώνει το lock, επιτρέποντας σε άλλα threads να το χρησιμοποιούν.
- Αν το είχε ένας αναγνώστης, επιτρέπει σε όλους του συγγραφείς να μπούν
- Αν το είχε ένας συγγραφές  επιτρέπει σε αναγνώστης **ή** άλλους να συγγραφείς να το πάρουν

#### Παράδειγμα: Reader-Writer Access
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

    // Join threads (αναμονή για να ολοκληρωθούν)
    for (int i = 0; i < NUM_READERS; i++) {
        pthread_join(readers[i], NULL);
    }
    pthread_join(writer, NULL);

    pthread_rwlock_destroy(&data_rw_lock);  // Καταστροφή του lock
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

#### Πότε να χρησιμοποιήσω RW locks αντί για Mutexes;

| **Mutex** | **Reader-Writer Lock** |
| --- | --- |
| Ένα thread κάθε φορά | Πολλοί αναγνώστες, ένας συγγραφέας |
| Όλα τα threads περιμένουν αν ένα άλλο έχει το lock | Οι αναγνώστες δεν εμποδίζονται μεταξύ τους |
| Απλούστερο και πιο αποδοτικό για μικρές κρίσιμες περιοχές | Χρήσιμο αν υπάρχουν πολλές αναγνώσεις και λίγες εγγραφές |
| Δεν διαχωρίζει αναγνώστες-συγγραφείς | Χρησιμοποιεί δύο επίπεδα πρόσβασης |

RW locks είναι ιδανικά αν τα περισσότερα threads διαβάζουν και σπάνια γίνονται εγγραφές.

#### Bariers: Συγχρονισμός μεταξύ πολλών threads
##### Τί είναι τα Barriers;
- Τα barriers (φράγες συγχρονισμού) είναι ένας μηχανισμός όπου όλα τα threads περιμένουν να φτάσουν σε ένα συγκεκριμμένο σημείο π´ριν συνεχίσουν.
- Σκεφτείτε το σαν μία γραμμή εκκίνησης όπου διαφορετικά threads πρέπει να συγχρονιστούν πρίν εκτελέσουν την επόμενη φάση υπολογισμού

##### Χαρακτηριστικά των Barriers
- Δεν χρειάζονται όλα τα threads να περιμένουν - μόνο ένας προκαθορισμένος αριθμός
- Συμπεριφέρεται σαν έναν καταμετρητή (counter) που περιμένει να φτάσουν όλα τα απαραίτητα threads πριν τους επιτρέψει να προχωρήσουν.

#### Barrier API (POSIX Pthreads)
##### Αρχικοποίηση και καταστροφή

```c
int pthread_barrier_init(
    pthread_barrier_t *barrier, 
    const pthread_barrierattr_t *attr, 
    unsigned count
);
```
- `barrier`: Δείκτης στο barrier object που θα αρχικοποιηθεί.
- `attr`: Δομή με ιδιότητες του barrier (συνήθως `NULL` για deffault τιμές)
- `count`: Ο αριθμός των threads που πρέπει να φτάσουν στο barrier πριν συνεχίσουν

```c
int pthread_barrier_destroy(pthread_barrier_t *barrier);
```
- Χρησιμοποιείται για να καταστρέψει το barrier και να απελευθερώσει πόρους.

##### Χρήση του Barrier
```c
int pthread_barrier_wait(pthread_barrier_t *barrier);
```
- Όταν ένα thread καλεί `pthread_barrier_wait`, **μπλοκάρεται** μέχρι να φτάσουν όλα τα απαραίτητα threads
- Όταν το τελευταίο thread φτάσει στο barrier, όλα τα threads απελευθερώνονται ταυτόχρονα.

#### Παράδειγμα: Χρήση Barrier
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

#### Πιθανά προβλήματα με Threads
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

