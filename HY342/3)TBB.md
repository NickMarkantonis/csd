## HY342 - Παράλληλος Προγραμματισμός
### Thread Building Blocks

### Εισαγωγή
Η **Thread Building Blocks (TBB)** είναι μία βιβλιοθήκη γραμμένη σε C++ που απλοποιεί τον παράλληλο προγραμματισμό μέσω την χρήση **tasks**. Αντί να διεαχειρίζεται απευθείας threads, η TBB επιτρέπει στον προγραμματιστή να επικεντρώνεται στη λογική του παραλληλισμού, ενώ η βιβλιοθήκη αναλαμβάνει τη δυναμική κατανομή των tasks στους διαθέσιμους πυρήνες. Αυτό οδηγεί σε καλύτερη χρήση των caches και αποφέυγει προβλήματα όπως το oversubscription.

#### Πλεονεκτήματα TBB
- Λογικός πραλληλισμός αντί για threads 
- Παραλληλισμός για ταχύτητα
- Συμβατότητα με άλλες μορφές threading
- Έμφαση σε data parallelism
- Generics (templates)
- Έτοιμα patters παραλληλισμού
#### Μειωνεκτήματα TBB
- Όχι για παραλληλισμό i/o
- Όχι για real-time εφαρμογές 
- Βιβλιοθήκη, άρα και θέματα compilation

### Βασικές Ιδέες
Ένας απο τους κύριους στόχους της TBB είναι το *κλημακωισμότητα (scalability)* δηλαδή, η οποία επιτυγχάνεται μέσω της αυτοματοποίησης των parallel patterns και της τεχνικής work-stealing για την ισοροποία φόρτου, είναι open - source και υποστηρίζεται απο πολλές πλατφόρμες.

### Δομές Παραλληλισμού
Η βιβλιοθήκη προσφέρει μια σειρά απο δομές παραλληλισμού, οι οποίες μπορούν να χωριστούν σε διαφορετικές κατηγορίες. Μεταξύ αυτών είναι οι παράλληλοι αλγόριθμοι, όπως οι `parallel_for`, `parallel_foer_each`, `parallel_reduce` και `parallel_do` οι οποίοι επιτρέπουν την εκτέλεση βρόχων με ανεξάρτητα iterations. Επιπλέον, η TBB υποστηρίζει flow graphs τα οποία περιλαμβάνουν κόμβους για τη ροή δεδομένων (data flow), όπως functional nodes, buffering nodes και split/join nodes. 
Άλλες σημαντικές δομές είναι τα ranges και partitioners, τα οποία χρησιμοποιούνται για την περιγραφή της κατανομής δεδομένων, καθώς και τα task groups, που παρέχουν έναν γενικό τρόπο για την έκφραση παραλληλισμού. Ο task scheduler της TBB αναλαμβάνει την αντιστοίχιση των tasks στα threads και διαχειρίζεται το thread pool, ενώ η βιβλιοθήκη προσφέρει και πτωτόκολλα συγχρονισμού, όπως atomic operations, mutexes και rw_mutexes. 
Η TBB περιλαμβάνει επίσης thread local storage (TLS), το οποίο επιτρέπει την αποθύκευση δεδομένων που είναι ιδιαίτερα για κάθε thread, χρησιμοποιώντας κλάσεις όπως η combinable και enumerable_thread_specific. Επιπλέον παρέχει παράλληλα containers για ασφαλή και αποδοτική χρήση σε παράλληλα περιβάλοντα, όπως το `concurrent_hash_map`, `concurrent_queue`, `concurent_bounded_queue`, `concurrent_priority_queue`, `concurent_vector`, `concurent_unordered_map` και `concurent_unordered_set`.
Τέλος, η βιβλιοθήκη προσφέρει memory allocators όπως οι tbb_allocator, chache_alligned_allocato και scalable_allocator, οι οποίοι βελτιστοποιούν τη δυναμική διαχείριση μνήμης σε παράλληλα προγράμματα μειώνοντας τα bottlenecks και το false sharing.

### Task-based Παραλληλισμός
Το TBB βασίζεται σε tasks αντί για threads για να εκφράσει τον παραλληλισμό. Τα tasks είναι ελαφριές μονάδες εργασίας που δημιουργούνται και διαχειρίζονται δυναμικά από τον TBB Scheduler. O Scheduler αντιστοιχεί tasks σε threads μέσα σε ένα thread pool.
Η εκτέλεση είναι unfair για λόγους απόδοσης: προτιμούνται tasks που έχουν καλή τοπικότητα στις cache, βελτιώνοντας την απόδοση του συστήματος.
Για την αποδοτική κατανομή των tasks, η TBB χρησιμοποιεί work-stealing, μία τεχνική όπου idle threads "κλέβουν" tasks απο φορτωμένα threads.

### Αλγόριθμοι TBB
H ΤΒΒ προσφέρει υψηλού επιπέδου αλγορίθμους παραλληλισμού, υλοποιημένους με γενικευμένο κώδικα. Οι πιο σημαντικοί είναι:
- `parallel_for`: Χρησιμοποιείται για βρόχους με ανεξάρτητα iterations
- `parallel_reduce`: Όπως το `parallel_for` αλλά συνδυάζει ενδιάμεσα αποτελέσματα
- `parallel_scan`: Παράγει cumulative results (όπως prefix sums)
- `parallel_pipeline`: Επιτρέπει παράλληλα και σειριακά στάδια σε pipeline μορφή
- `parallel_do`: Εκτελεί βρόζους με δυναμικά επεκτεινόμενο σύνολο iterations. Κατάλληλο όταν η εκτέλεση ενός στοιχείου μπορεί να προσθέσει και άλλα.
- `parallel_sort`: Παράλληλη ταξινόμηση
- `parallel_invoke`: Εκτελεί πολλαπλές συναρτήσεις παράλληλα, χρήσιμο για ανεξάρτητες εργασίες

#### H `parallel_for`
Ο βασικός τρόπος παράλληλης εκτέλεσης βρόχων στην TBB, χρησιμοποιεί το αντικείμενο `blocked_range` για να χωρίσει τα δεδομένα σε μικρότερα "κομάτια" που εκτελούνται παράλληλα.
Υπάρχουν δυο overload της `parallel_for`:
```cpp
template <typename Range, typename Body>
void parallel_for(const Range& range, const Body& f);

template <typename Index, typename Function>
void parallel_for(Index first, Index last, Index step, const Function& f);
```
##### Range
Το `Range` είναι ένα αντικείμενο που περιγράφει το έυρος των ιμών που θα υποστούν παράλληλη επεξργασία. 
Η TBB παρέχει έτοιμα ranges, όπως:
- `blocked_range`
- `blocked_range2d`
- `blocked_range3d`

Για custom ranges απαιτούνται μέθοδοι όπως:
```cpp
bool MyRange::is_empty() const;
bool MyRange::is_divisible() const;
MyRange::MyRange(MyRange& r, split);
```
##### Granularity
Το granularity είναι το μέγεθος των επιμέρους τμημάτων του range. Αντιστοιχεί στην έννοια του `chunk` στο OpenMP
- Δεν το ορίζει το task scheduler αλλα οι `parallel_for`, `parallel_reduce`.
- Βοηθάει στην μείωσει του overhead 
- Δεν χρησιμοποιείται για balancing threads, αλλα για απόδοση σε κάθε thread

Καλή επιλογή granularity:
- Με βάση το performance ενός single thread
- Ελαφρώς μεγαλύτερο από το βέλτιστο για αποφυγή overheads

##### Παράδειγμα `parallel_for`
- Αρχικός κώδικας:
```cpp
void change_array(float* array, int M) {
    for (int i = 0; i < M; i++) {
        array[i] *= 2;
    }
}
```
- Μετατροπή σε `parallel_for`
```cpp
#include <tbb/blocked_range.h>
#include <tbb/parallel_for.h>
using namespace tbb;

void parallel_change_array(float* array, size_t M) {
    parallel_for(blocked_range<size_t>(0, M, 1000),
        [=](const blocked_range<size_t>& r) {
            for(size_t i = r.begin(); i != r.end(); i++)
                array[i] *= 2;
        }
    );
}
```

### Task Sxheduler
#### Αυτόματη διαχείρηση
Η TBB δημιουργεί και καταστρέφει task scheduler threads αυτόματα, με βασή τις ανάγκες. Ωστόσο, ο προγραμματιστής μπορεί να περέμβει για αποδοτικότερη διαχείριση.
Παράδειγμα με χειροκίνητο `task_scheduler_init`:
```cpp
#include <tbb/task_scheduler_init.h>
using namespace tbb;

int main() {
    task_scheduler_init init; // δημιουργία threads
    float A[N];
    initialize_array(A);
    parallel_change_array(A, N); // χρήση parallel_for
    return 0; // καταστροφή scheduler αυτόματα
}
```
Μπορεί να καθοριστεί αριθμός απο threads μέσω παραμέτρου στον constructor `task_scheduler_init`

### Προγραμματισμός με Generics ή Lambda
#### Generics (Function Objects)
Οι συναρτήσεις μπορούν να εκφραστούν ώς classes με overload στο `operator()`
```cpp
class ChangeArrayBody {
    float* array;
public:
    ChangeArrayBody(float* a) : array(a) {}
    void operator()(const blocked_range<size_t>& r) const {
        for (size_t i = r.begin(); i != r.end(); i++)
            array[i] *= 2;
    }
};
```
Κλήση:
```cpp
parallel_for(blocked_range<size_t>(0, M, 1000), ChangeArrayBody(array));
```
#### Lambda
Αντι για γενικευμένες κλάσεις, μπορεί να χρησιμοποιηθεί Lambda Function:
```cpp
void parallel_change_array(float* array, size_t M) {
    parallel_for(blocked_range<size_t>(0, M, 1000),
        [=](const blocked_range<size_t>& r) {
            for(size_t i = r.begin(); i != r.end(); i++)
                array[i] *= 2;
        }
    );
}
```

#### Generics vs Lambdas
- Και οι δύο μεθόδοι παρέχουν παρόμοια απόδοση overhead.
- Η χρήση λήψης μεταβλητών με captures ([=]) καθιστά τις lambdas απλούστερες στην πράξη.
- Ορισμένες περιπτώσεις απαιτούν γενικευμένες εκφράσεις όπου οι lambdas δεν επαρκούν
- Η χρήση lambdas απαιτεί υποστήριξη C++11 και την παράμετρο `-std=c++0x` στον compiler

### Parallel Reduce
Η `parallel_reduce` είναι παρόμοια με την `parallel_for`, αλλά κατάλληλη για περιτπώσεις όπου χρειάζεται συνδυασμός αποτελεσμάτων.
Η γενική χρήση έχει δύο μορφές:
```cpp
template<typename Range, typename Body>
void parallel_reduce(const Range& range, Body& body);

template<typename Range, typename Value, typename RealBody, typename Reduction>
Value parallel_reduce(const Range& range,
                      const Value& identity,
                      const RealBody& real_body,
                      const Reduction& reduction);
```
- Η `RealBody` εκτελείται για κάθε υποπεριοχή (`subrange`)
- Η `Reduction` ενώνει τα επιμέρους αποτελέσματα

#### Παράδειγμα parallel_reduce
Ευρεση του index με το μιρκότερο στοιχείο
- σειριακά:
```cpp
size_t serialMinIndex(const float a[], size_t n) {
    float value_of_min = std::numeric_limits<float>::max();
    size_t index_of_min = 0;
    for(size_t i = 0; i < n; ++i) {
        if(a[i] < value_of_min) {
            value_of_min = a[i];
            index_of_min = i;
        }
    }
    return index_of_min;
}
```

- παράλληλα:
```cpp
size_t parallelMinIndex(const float a[], size_t n) {
    return parallel_reduce(blocked_range<size_t>(0, n, 10000), size_t(0),
        [=](blocked_range<size_t>& r, size_t index_of_min) -> size_t {
            float value_of_min = a[index_of_min];
            for(size_t i = r.begin(); i != r.end(); ++i) {
                if (a[i] < value_of_min) {
                    value_of_min = a[i];
                    index_of_min = i;
                }
            }
            return index_of_min;
        },
        [=](size_t i1, size_t i2) {
            return (a[i1] < a[i2]) ? i1 : i2;
        }
    );
}
```

### Parallel Sort
Ο αλγόριθμος `parallel_sort` προσφέρει παράλληλη ταξινόμηση:
Στηρίζεται σε quicksort με work-stealing για balancing
```cpp
template<typename RandomAccessIterator>
void parallel_sort(RandomAccessIterator begin, RandomAccessIterator end);

template<typename RandomAccessIterator, typename Compare>
void parallel_sort(RandomAccessIterator begin,
                   RandomAccessIterator end,
                   const Compare& comp);
```

### Parallel Invoke
Η `parallel_invoke` επιτρέπει τον ταυτόχρονη εκτέλεση πολλών συναρτήσεων, κατάλληλη για ανεξάρτητες εργασίες. Οι συναρτήσεις εκτελούνται ως ξεχωριστά tasks και η parallel_invoke περιμένει να ολοκληρωθούν όλες πριν συνεχίσει.
Σημειώσεις για parllel_invoke:
- Οι συναρτήσεις δεν δέχονται ούτε επιτστρέφουν τιμές απευθείας
- Η επικοινωνία γίνεται μέσω shared μεταβλητών (όπως `x`, `y` παραπάνω)
- Είναι ιδανικό για ελαφριά, ανεξάρτητα tasks

### Task Groups
Τα task groups επιτρέπουν τη δυναμική δημιουργία πολλών tasks που μπορόυν να εκτελούνται παράλληλα
- Όλα τα tasks ενός `task_group` θεωρούνται συσχετισμένα
- Τα tasks ξεκινούν με `run()` και ολοκληρώνονται με `wait()`
#### Παράδειγμα με Fibonacci
```cpp
#include <tbb/task_group.h>
using namespace tbb;

int Fib(int n) {
    if (n < 2) return n;
    int x, y;
    task_group g;
    g.run([&] { x = Fib(n - 1); }); // spawn task
    g.run([&] { y = Fib(n - 2); }); // spawn another
    g.wait(); // συγχρονισμός
    return x + y;
}
```

#### Tasks χωρίς lambda
Η TBB επιτρέπει και χρήση χειροκίνητης δημιουργίας tasks μέσω της χρήσης `task`
Παράδειγμα:
```cpp
class FibTask : public task {
public:
    const long n;
    long* const sum;
    FibTask(long n_, long* sum_) : n(n_), sum(sum_) {}

    task* execute() override {
        if (n < 1000) {
            *sum = serial_fib(n);
        } else {
            long x, y;
            FibTask& a = *new(allocate_child()) FibTask(n - 1, &x);
            FibTask& b = *new(allocate_child()) FibTask(n - 2, &y);
            set_ref_count(3);
            spawn(b);
            spawn_and_wait_for_all(a);
            *sum = x + y;
        }
        return nullptr;
    }
};

long parallel_fib(long n) {
    long sum;
    FibTask& a = *new(Task::allocate_root()) FibTask(n, &sum);
    Task::spawn_root_and_wait(a);
    return sum;
}
```

### Παράλληλα Containers στην TBB
Γιατί TBB Containers;
Τα containers της STL δεν είναι thread-safe. Η παράλληλη χρήση τους οδηγεί σε:
- Data corruption
- Ανάγκη για locks -> bottlenecks
Η TBB προσφέρει παράλληλες υλοποιήσεις containers με
- Fine-grained συγχρονισμό
- Χαμηλότερη απόδοση σε σειριακή χρήση
- Καλή κλιμακωσιμότητα σε παράλληλο κώδικα
- Χρήση χωρίς TBB scheduler (λειτουργούν και με OpenMP,pthreads)
- Συμβατά με pthreads, OpenMP

H C++ STL περιέχει containers με APIs που απαιτούν σειριακή εκτέλεση, πχ:
```cpp
extern std::queue q;
if (q.empty()) {
    // race: first thread that pop()s will make queue empty
    item = q.front()
    q.pop()
}
```
Λύση: `concurent_queue`
Νέο API: `pop_if_present()`

### Concurrent Queue
Χαρακτηριστικά:
- FIFO ουρά, παράλληλα προσθήκη και αφαίρεση στοιχείων
- Μεθόδοι:
    - `push(const &T)`: προσθέτει αντικείμενο
    - `pop(T&)`: blocking
    - `pop_if_present(T&)`: non-blocking
    - `size()`: επιστρέφει signed ακέραιο (αρνητικό σημαίνει ότι threads περιμένουν pop)
Παράδειγμα:
```cpp
#include <tbb/concurrent_queue.h>
using namespace tbb;

int main() {
    concurrent_queue<int> queue;
    for (int i = 0; i < 10; i++)
        queue.push(i);

    int j;
    while (!queue.empty()) {
        queue.pop(j);
        std::cout << "From queue: " << j << std::endl;
    }
    return 0;
}
```


