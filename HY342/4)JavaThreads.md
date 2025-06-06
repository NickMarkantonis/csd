# HY342 - Παράλληλος Προγραμματισμός
## Java Threads

## Τί είναι Thread
Ένα thread είναι μία μονάδα εκτέλεσης μέσα σε μία διεργασία, κάθε πρόγραμμα έχει τουλάχιστον ένα thread, το `main()`
Υλοποίηση:
- Κάθε thread έχει το δικό του *Program Counter (PC)* και *stack*
- Όλα τα threads μοιράζονται το ίδιο heap και static μνήμη

## Υλοποίηση των Thread
- Όσο εκτελείται ένα thread, ο *PC* και ο *stack pointer* του αποθυκέυονται στη μνήμη
- Όταν εκτελείται, αποθηκεύνται σε *hardware registers* ενός πυρήνα

## Πλεονεκτήματα και Μειωνεκτήματα των Threads
Πλεονεκτήματα:
- Πράλληλη εκτέλεση σε multi-core επεξεργαστές
- Συνδυασμός I/O και υπολογισμών
- Φυσική επιλογή για μοντέλα όπως event processing και simulations
Μειωνεκτήματα:
- Αυξημένη πολυπλοκότητα (προβλήματα όπως safety, liveness, composability)
- Oversubscription: πολλά threads σε λίγους πόρους προκαλούν συμφόρηση

## Thread Programming Model
- Πολλές γλώσσες τα υποστηρίζουν
- Στην Java είναι μέρος του language specification
- Η Java διαθέτει τυπικά ορισμένο Memory Model

## Java Threads
- Η Java ξεκινάει με ένα thread: το `main()`
- Για να δημιουργήσουμε νέα threads
  - **Άμεσα**: με χρήση της κλάσης `Thread`
  - **Έμμεσα**: από libraries (RMI, Swing, AWT)

## Java Threads ως Objects
- Τα threads είναι *αντικείμενα* της κλάσης `Thread` ή υποκλάση της
- Για να ξεκινήσει ένα νέο thread:
  - Δημιουργούμε αντικείμενο `Thread`
  - Κλήση της `start()`: ξεκινά το thread και εκτελεί την `run()` ασύγχρονα
  - Το thread τερματίζει όταν τελειώσει η `run()`

### Παράδειγμα: Alarms
- Ο κώδικας εισάγει χρόνο `t` και μήνυμα `m`.
- Ο κώδικας χρησιμοποιεί `Thread.sleep(t*1000)` για να περιμένει και μετά τυπώνει το μήνυμα

Γραμμικά (μέσα στο thread `main()`):
```java
// ...

while(true) {
  System.out.print("Alarm> ");
  // read user input
  String line = b.readLine();
  parseInput(line);

  // wait
  try {
    Thread.sleep(timeout * 1000);
  } catch (InterruptedException e) {}
  System.out.println("(" + timeout + ")" + msg);
}

// ...
```

Παραλληλοποίηση (δημιουργούμε ένα καινούργιο thread):

```java
// thread class
public class AlarmThread extends Thread {
  private String msg = null;
  private int timeout = 0;
  
  // Constructor
  putblic AlarmThread(String msg, int time) {
    this.msg = msg;
    this.timeout = time;
  }
  
  // run function
  public void run() {
    try {
      Thread.sleep(timeout * 1000);
    } catch(InterruptedException e) {}
    System.out.println("(" + timeout + ")" + msg);
  }
}

// ...

while (true) {
  System.out.print("Alarm> ");
  // read user input
  String line = b.readLine();
  parseInput(line); 

  if (m != null) {
    // start alarm thread
    Thread t = newAlarmThread(msg,timeout);
    t.start();
  }
} 

// ...
```

## Εναλακτική: Runnable Interface
- Η κληρονομικότητα από `Thread` περιορίζει το class hierarchy
- Αντί για `extends Thread`, μπορούμε να υλοποιήσουμε το interface `Runnable`
- Η κλάση υλοποιεί τη μέθοδο `void run()`
- Δημιουργεί thread
```java
Thread t = new Thread(new AlarmRunnable(msg,timeout));
t.start();
```

### Παράδειγμα
```java
public class AlarmRunnable impements Runnable {
  private String msg = null;
  private int timeout = 0;

  public AlarmRunnable(String msg, int time) {
    this.msg = msg;
    this.timeout = time;
  }

  public void run() {
    try {
      Thread.sleep(timeout * 1000);
    } catch (InterruptedException e) {}
    System.out.println("(" + timeout + ")" + msg);
  }
}

// ...

while (true) {
  System.out.print("Alarm> ");
  // read user input
  String line = b.readLine();
  parseInput(line);

  if (m != null) {
    // start alarm thread
    Thread t = new Thread(new AlarmRunnable(msg,timeout));
    t.start();
  }
}

// ...
```

## Πέρασμα παραμέτρων
- Η `run()` δεν δέχεται παραμέτρους
- Τα δεδομένα μεταβιβάζονται μέσω `private` fields του αντικειμένου
- Είτε στην υποκλάση `Thread` είτε στο `Runnable`

## Concurency
- **Concurent** πρόγραμμα: Πολλά thread ενεργά τατόχρονα ταυτόχρονα
- Εκτελείται σε:
  - Ένα CPU με context-switching
  - Πολλά CPU cores με παράλληλη εκτέλεση
- Ο Thread Sceduler αποφασίζει πότε γίνεται εναλλαγή
- Το JVM επιλέγει πολική scheduling

## Concurrency και Κοινή Μνήμη
- Το concurrency γίνεται πολύπλοκο όταν threads μοιράζονται δεδομένα
- Η επικοινωνία γίνεται μέσω shared heap αντικειμένων
- Interleavings των reads/writes είναι μη-ντετερμινιστικά
  - Το hardware, compiler και scheduler αλλάζουν τη σειρά
- Προσοχή σε race conditions και memmory consistency errors

### Παράδειγμα Data Race:
``` java
public class Example extends Thread {
  private static int counter = 0;
  public void run() {
    int y = counter;
    counter = y + 1;
  }
  public static void main(String[] args) {
    thread t1 = new Example();
    thread t2 = new Example();
    t1.start();
    t2.start();
  }
}
```
Τα threads μπορεί να γράψουν/διαβάσουν τον `counter` με λάθος σειρά - πιθανή απώλεια updates

## Συγχρονισμός (Synchronization)
- Χρησιμοποιείται για τον έλεγχο της σειράς εκτέλεσης μεταξύ threads
- Στόχος: Αποκλείονται λάθος interleavings, ώστε το πρόγραμμα να παραμένει σωστό
- Οι μηχανισμοί συγχρονισμού περιορίζουν το χώρο των δυνατών εκτελέσεων
- Η Java προσφέρει πολλούς τέτοιυς μηχανισμούς (π.χ locks, synchronized)

## Java Locks
- Interface `Lock`: έχει μεθόδους `lock()` και `unlock()`
```java
interface Lock {
  void lock();
  void unlock();
  ...
}
class ReentrantLock implements Lock { ... }
```
- Κύρια υλοποίηση: `ReentrantLock`
- Χαρακτηριστικά:
  - Μόνο ένα thread μπορεί να κρατά το lock κάθε φορά
  - Reentrant: το ίδιο thread μπορεί να πάρει το ίδιο lock πολλές φορές
  - Πρέπει να γίνει unlock τόσες φορές όσες έγινε lock

### Παράδειγμα με Lock
```java
static Lock lock = new ReentantLock();
static int counter = 0;

public void run() {
  lock.lock();
  int y = counter;
  counter = y + 1;
  lock.unlock();
}
```
Αποφυγή data races μέσω αποκλιεσιτκής πρόσβασης με lock

## Προσοχή σε διαφορετικά Locks
- Αν δυο threads χρησιμοποιούν διαφορετικά locks για τα ίδια shared δεδομένα -> race conditions
```java
static lock l = new ReentantLock();
static lock m = new ReentantLock();
```
- Τα locks δεν συνανεργάζονται μεταξύ τους, κάθε thread προστατέυει μόνο μεμονωμένα accesses

### Παράδειγμα με Busy Waiting
```java
static int counter = 0;
static int x = 0;

Thread 1:
while (x != 0);
x = 1;
counter++;
x = 0;

Thread 2:
while (x != 0);
x = 1;
counter++;
x = 0;
```

- Δεν υπάρχει αληθινός συγχρονισμός
- Και τα δύο threads μπορεί να "νομίζουν" ότι έχουν το lock -> Data Race
- Επίσης κάνει σπατάλη CPU -> λέγεται busy waiting

## Deadlock
- Προκύπτει όταν κανένα thread δεν μπορεί να προχωρήσει επιεδή περιμένει κάποιο lock που κατά άλλο thread
- Παράδειγμα:
```java
lock l = new ReentantLock();
lock m = new ReentantLock();

Thread 1:
l.lock();
m.lock();
// ...
m.unlock();
l.unlock();

Thread 2:
l.lock();
m.lock();
// ...
m.unlock();
l.unlock();
```

Αν το Thread1 πάρει το l και Thread 2 πάρει το m τότε και τα δύο περιμένουν το άλλο -> deadlock

## Ο γράφρος των Waits (Wait graph)
- Αναπαριστά τις σχέσεις μεταξύ threads και locks
- Κόμβοι: threads & locks
- Ακμή: `Thread -> Lock`: περιμένει το lock
- Ακμή: `Lock -> Thread`: thread κατέχει το lock
- Deadlock υπάρχει όταν υπάρχει κύκλος στον γράφο
- Πολύ δύσκολο στο debug - μπορεί να προκύψει σε άσχετο σημείο εκτέλεσης

### Παράδειγμα Deadlock λόγο Exception
```java
lock l = new ReentantLock();

void f() throws Exception {
  l.lock();
  FileInputStream f = new FileInputStream("file.txt");
  // ...
  f.close();
  l.unlock();
}
```
- Αν προκύψει exception πρίν το `unlock()` το lock δεν αποδεσμέυεται
- Αυτό οδηγέι σε πιθανό deadlock αργότερα

### Λύση: `finally` Block
```java
l.lock();
try {
  // ...
} finally { 
  l.unlock()
}
```
- Το `finally` εγγυάται ότι το `unlock()` θα εκτελεστεί πάντα, ακόμα και με `exception` ή `return`

## `synchronized` Blocks
- Java construct για αυτόματο lock/unlock
- Σύνταξη:
```java
synchronized(obj) {
  // ...
}
```
- Κλειδώνει το lock του αντικειμένου `obj`
- Το lock αποδεσμέυεται αυτόματα βγαίνοντας από το μπλοκ (ακόμα και με exception)

## Παράδειγμα `synchronized`
```java
static Object o = new Object();

void f() {
  synchronized (o) {
    FileInputStream f = new FileInputStream("file.txt");
    // ...
    f.close();
  }
}
```
- Το `o` λειτουργεί ως lock
- Το lock αποκτάται και αποδεσμέυεται αυτόματα

Προσοχή: Το αντικείμενο και το lock που του αντιστοιχεί είναι διαφορετικά πράγματα:
Το ότι το lock ενός αντικειμένου είναι κλειδωμένο δε σταματά άλλα threads απο το να καλέσουν μεθόδους, να έχουν πρόσβαση στα πεδία κτλ.

## Object Locks $\neq$ Objext Access
- Το lock ενός αντικειμένου δεν εμποδίζει άλλες προσβάσεις στα πεδία του
- Το lock αφορά μόνο το synxchronized block, όχι ολόκληρο το object

### Παράδειγμα: χρήση της `this` για Lock
```java
class C {
  int counter;
  void inc() {
    synchronized(this) {
      counter++;
    }
  }
}
```
- Τα threads συνγχρονίζονται πάνω στο ίδιο αντικείμενο (`this`)
- Όχι data race, επειδή όλα αποκτούν το ίδιο lock π´ριν προσπελάσουν το counter

### Παράδειγμα με πολλαπλά αντικείμενα 
```java
C c1 = new C();
C c2 = new C();

Thread 1: c1.inc();
Thread 2: c2.inc();
```
- Δεν υπάρχει Data Race επειδή τα αντικείμενα είναι ξεχωριστά
- Κάθε thread κλειδώνει το δικό του object -> διαφορετικά locks, διαφορετικά δεδομένα

## Synchronized Methods
- Εναλακτική του `synchronized (this)`
  - Χρησιμοποιεί τη λέξη-κλειδί `synchronized` στη δήλωση της μεθόδου
- Ισοδύναμο:
```java
synchronized void inc() { ... }
```
αντί για:
```java
void int() {
  synchronized (this) { ... }
}
```

### Παράδειγμα `synchronized` Method
```java
class C {
  int counter;
  void inc() {
    synchronized (this) {
      counter ++;
    }
  }
  synchronized void dec() {
    counter --;
  }
}
```

- Και οι δύο μεθόδοι συγχρονίζονται πάνω στο ίδιο `this` object -> ασφαλής πρόσβαση στα shared δεδομένα

## Synchronized `static` Methods
- Οι `static synchronized` μεθόδοι κλειδώνουν το lock του class object, όχι ενός instance.
- Δεν υπάρχει `this`, άρα:
```java
static synchronized void dec() { ... }
```
- Παράδειγμα:
```java
class C {
  int counter;
  synchronized void inc() { counter++; }
  static synchronized void dec() { ... }
}
```

## Task Scheduling
- Όταν πολλά threads μοιράζονται έναν πυρήνα CPU:
  - Ποιο εκτελείται και πότε αλλάζει βάσει scheduling policy
- `Thread.yield()`:
  - Το thread παραιτείται προσωρινά από το CPU
  - Μπορεί να αγνοηθεί από το JVM
- Preemptive schedulers:
  - Μπορούν να σταματήσουν thread ανα πάσα στιγμή
  - Δνε υποστηρίζονται απο όλα τα JVMS's
- `yield()` χρήσιμο σε loops για αποφυγή starvation:

## Thread Lifecycle
Καταστάσεις ενός thread:
- **New**: δημιοργήθηκε αλλά δεν ξεκίνησε
- **Runnable**: έτοιμο για εκτέλεση η εκτελείται ήδη
- **Blocked**: περιμένει για lock ή I/O
- **Sleeping**: σε πάυση βάσει `sleep()`
- **Terminated**: τελείωσε

## Ποιο Thread Εκτελείται;
- O JVM Scheduler διαλέγει ανάμεσα σε runnable threads
- Παράγοντες:
  - Threads που ξεμπλοκάραν απο I/O, sleep ή lock
  - Προτεραιότητα (`setPriority(int)`): υψηλότερη = προτιμάται
- Συνήθως δεν υπάρχει λόγος να τροποποιηθεί η προτεραιτότητα

## Σημαντικές μεθόδοι του Thread
- `void join() throws InterruptedException`
  - Περιμένει να τελειώσει το Thread
- `static void yield()`
  - Το τρέχων thread απελευθερώνει το CPU core
- `static void sleep(long milliseconds) throws InterrputedException`
  - Tο τρέχων thread κάνει sleep για τον καθορισμένο χρόνο
- `static Thread currentThread()`
  - Επιστρέφει το Thread object του thread που εκτελείται

### Παράδειγμα: Alarm
```java
// ...

while (true) {
  System.out.print("Alarm> ");
  // read user input
  String line = b.readLine();
  parseInput(line);

  if (msg != null) {
    // start alarm
    Thread t = new AlarmThread(msg,timeout);
    t.start();
    // waiting for thread to finish
    t.join();
  }
}

// ...
```

## Daemon Threads
- `setDaemon(true)` ορίζει ότι ένα thread είναι daemon
- Πρέπει να κληθεί πρίν το `start()`
- Ένα πρόγραμμα τερματίζει όταν δεν υπάρχουν πια non-daemon threads
- Daemon threads: π.χ. background εργασίες, timers

## Βασικές Αρχές για Threads
- Πολλά threads μπορεί:
  - Να εκτελούνται ταυτόχρονα (σε πολλούς πυρήνες)
  - Ή να εναλλάσσονται σε έναν επεξεργαστή
- Μοιράζονται δεδομένα: κυρίως `fields`, όχι `local variables`
- Βέλτιστες πρακτικές
  - Κρατήσε lock όταν προσπελαύνεις shared δεδομένα
  - Μήν αφήνεις το lock μέχρι τα δεδομένα να είναι σε valid κατάσταση
- Προσοχή σε deadlocks
  - Αποφυγή: κάθε thread να κρατά ένα μόνο lock κάθε στιγμή

## Producer - Consumer Design Pattern
- Παράδειγμα επικοινωνίας δύο threads μέσω shared buffer
  - **Producer**: προσθέτει δεδομένα στον buffer
  - **Consumer**: αφαιρεί δεδομένα
- Υλοποίηση με condition variables

## Conditions (Java 5+)
```java
Lock lock = new ReentantLock();
Condition cond = lock.newCondition();
```

- `cond.awaits()`
  - Καλείται όταν το lock είναι acquired
  - Απελευθερώνει το lock και μπλοκάρει το thread
- `cond.signalAll()`
  - Ξυπνά όλα τα threads που περιμένουν στο condition
  - Πρέπει να καλεστεί ενώ το lock είναι acquired

## Παράδειγμα Producer - Consumer
```java
Lock lock = new ReentrantLock();
Condition ready = lock.newCondition();
boolean valueReady = false;
Object value;

void produce(Object o) {
  lock.lock();
  while (valueReady)
    ready.await();
  value = o;
  valueReady = true;
  ready.signalAll();
  lock.unlock();
}

Object consume() {
  lock.lock();
  while (!valueReady)
    ready.await();
  Object o = value;
  valueReady = false;
  ready.signalAll();
  lock.unlock();
  return o;
}
```
- Ορθή χρήση `await()` και `signalAll()` για συγχρονισμό μεταξύ threads

## Προτιμήστε αυτό το Pattern
- Είναι ορθή και ασφαλής λύση για synchronization
- Πρόβλημα με εναλλακτικές υλοποιήσεις είναι:
  - Δύσκολα στον εντοπισμό (subtle bugs)
  - Συχνά λανθασμένες (π.χ. double-cheked locking)

## Παραδείγματα λάθος κώδικα:
1. Deadlock
  ```java
  lock.lock()
  while (valueReady); // <- busy-wait μέσα σε lock
  value = o;
  valueReady = true;
  lock.unlock();
  ```
  Το Thread μπλοκάρει ενώ κρατάει το lock, κανείς άλλος δεν μπορεί να προχωρήσει

2. Data Race
  ```java
  while (valueReady); // <- Χωρίς lock
  lock.lock();
  value = o;
  valueReady = true;
  lock.unlock();
  ```
  race condition: το `valueReady` διαβάζεται χωρίς σχυγχρονισμό -> αναξιόπιστο

3. Correctness Error
  ```java
  if (valueReady) ready.await();
  ```
  - Λάθος Λογική:
    - Το `await()` πρέπει να είναι σε `while`, όχι `if`
    - Δεν δουλέυει σωστά υπάρχουν πολλαπλοί producer/consumers

## Condition Interface (Java 5+)
```java
interface Condition {
  void await();
  boolean await(long time, timeUnit unit);
  void signal();
  void signalAll();
}
```
- `await()` -> μπλοκάρει το thread μέχρι να λάβει σήμα (signal)
- `await(t,unit)` -> περιμένει για περιορισμένο χρόνο 
- `signal()` -> ξυπνάει **ένα** thread
- `signalAll()` -> ξυπνάει όλα τα threads

## Χρήση `await()` - `signalAll()`
- Το `await()` πρέπει να είναι πάντα μέσα σε loop, όχι `if`
- Γιατί 
  - Υπάρχουν spurious wakeups (λανθασμένες αφυπνίσεις)
  - Μπορεί να έχουν ξυπνήσει πολλά threads και μόνο ένα να πάρει το lock
- Αποφέυγουμε να κρατάμε άλλα locks κατά τη διάρκεια του `await()`

## Blocking Queues - Παράδειγμα Abstraction
Το Producer-Consumer pattern μπορεί να υλοποιηθεί πιο καθαρά με BlockingQueue
```java
interface Queue<E> extends Collection<E> {
  boolean offer(E x);
  E remove;
}
```
- Προσφέρει build-in συγχρονισμό
- Υλοποιήσεις
  - `LinkedBlockingQueue` (μπορεί να είναι άπειρη)
  - `ArrayBlockingQueue` (με σταθερό μέγεθος)

## Wait & NotifyAll (Java < 1.5)
- Παλιά προσέγγιση συγχρονισμού:
  - Χρησιμοποιεί `synchronized` blocks
  - Και τις μεθόδους `wait()`, `notify()`, `notifyAll()`

`wait()`: 
- Μπλοκάρει το thread και το προσθέτει στο wait set του αντικειμένου
- Απελευθερώνει το lock
`notifyAll()`
- Ξυπνά όλα τα threads που περιμένουν στο wait set του αντικειμένου

## Παράδειγμα Producer-Consumer με `wait/notifyAll`
```java
public class ProducerConsumer {
  private boolean valueReady = false;
  private Object value;

  synchronized void produce(Object o) {
    while (valueReady) wait();
    value = o;
    valueReady = true;
    notifyAll();
  }

  synchronized Object consume() {
    while (!valueReady) wait();
    Object o = value;
    valueReady = false;
    notifyAll();
    return o;
  }
} 
```
- Λειουργεί όπως με `Lock/Condition`, αλλά με:
  - `synchronized` αντί `lock.lock()`
  - `wait()` αντί `await()`
  - `notifyAll()` αντί `signalAll()`

## InteruptedException
- Εξαίρεση που πετιέται όταν ένα μπλοκαρισμένο thread διακοπεί 
- Πιθανές περιπτώσεις:
  - `wait()`
  - `await()`
  - `sleep()`
  - `join()`
  - `lockInterruptibly()`
- Αν το interrupt flag έχει ενεργοποιηθεί, η επόμενη από αυτές τις μεθόδους θα ρίξει `InterruptedException`

## Μεδόδοι και Interfaces με InterruptedException
- `Object.wait()`
- `Condition.await()`
- `Lock.lockInterruptibly()`
- `Thread.sleep()`
- `Thread.join()`

## Isolation (Απομόνωση)
- Ιδέα: Αν ένα αντικείμενο δεν είναι κοινόχρηστο (shared) δεν χρειάζεται synchronization
- Ισχύει για:
  - Τοπικές μεταβλητές (`local variables`)
  - Ορίσματα μεθόδων (`parameters`)
- Java παρέχει:
  - `ThreadLocal` -> Για ξεχωριστό αντίγραφο μιας μεταβλητής ανα thread

## Thread Local Data
- Κατάλληλο όταν κάθε thread πρέπει να έχει δική του έκδοση κάποιου πόρου (π.χ. direction, settings)
- Αντί να περνάμε δεδομένα με ορίσματα ή πεδία:
  - Χρησιμοποιούμε `ThreadLocal`
  - Δεν χρειάζεται Synchronization
  - Μειώνει πολυπλοκότητα

### Παράδειγμα: `ThreadLocal`
```java
public class WebServer {
  static final ThreadLocal documentRoot = new ThreadLocal();

  public WebServer(int port, File root) {
    documentRoot.set(root);
  }

  private void proccessRequest(Socket sock) {
    File root = (File) documentedRoot.get();
    // ...
  }
}
```

### Πότε να χρησιμοποιώ `ThreadLocal`
- Όταν η μεταβλητή αφορά δραστηριότητα (activity), όχι αντικείμενο
- Παραδείγματα:
  - Timeout per thread
  - Transaction ID
  - Deffault settings
- Χρήσιμο για:
  - Αποφυγή synchronization
  - Εσωτερικά λειτουργίες του JVM

## Stateless Objects
```java
class StatelessAdder {
  int addOne(int i) { return i + 1; }
  int addTwo(int i) { return i + 2; }
}
```
- Δεν έχουν καθόλου κατάσταση (state)
- Άρα:
  - Δεν υπάρχουν προβήματα συγχρονισμού
  - Δεν χρειάζονται locks
  - Πολλαπλά threads μπορούν να τα καλούν ασφαλώς ταυτόχρονα

## Immutable Objects
```java
class ImmutableAdder {
  private final int offset;
  ImmutableAdder(int offset) { this.offset = offset; }
  int add(int i ) { return i + offset; }
}
```
- Το state του αντικειμένου ορίζεται μια φορά στο constructor
- Δεν αλλάζει ποτέ -> αμετάβλητο
- Άρα
  - Thread-safe χωρίς synchronization
  - Κατάλληλο για shared user
- Συχνά παραδείγματα: `String`, `Integer`, `Boolean` κλπ

## Containment (Περιορισμός Πρόσβασης)
- Σκοπός: περιορίζω την πρόσβασιμότητα στα mutable δεδομένα
- Δημιουργεί "νησίδες" αντικειμένων με ασφαλή πρόσβαση
- Οι εξωτερικές κλάσεις:
  - Δεν αποκαλύπτουν τα mutable δεδομένα
  - Μπορούν να κάνουν αντίγραφα των δεδομένων πριν τα επιστρέψουν
- Οι εσωτερικές κλάσσεις:
  - Εκτελούν τον κώδικα τους χωρίς συγχρονισμό, γιατί δεν υπάρχει επικίνδυνη πρόσβαση

### Παράδειγμα Containment (1)
```java
class Statistic {
  public long request;
  public double avgTime;
}
```
- Τα πεδία είναι `public` και mutable -> όχι thread-safe
- Δεν πρέπει να κοινοποιούνται εκτός
Μπορεί να είνα εσωτερικό πεδίο μιας άλλης κλάσης (όπως WebServer) και να προστατεύεται εκεί

### Παράδειγμα Containment (2)
```java
class WebServer {
  private final Statistics stats = new Statistics(0,0.0);

  public synchronized Statistic getStatistics() {
    return new Statistics(stats.request,stats.avgTime); // returning a copy
  }

  private void proccessRequest(Socket sock) {
    synchronized(this) {
      double total = stats.avgTime * stats.request + elapsed;
      stats.avgTime = total / (++stats.requests);
    }
  }
}
```
- Δεν επιστρέφει το `stats` απευθείας -> προστασία μέσω αντιγραφής
- Η ενημέρωση γίνεται εντός synchronized -> ασφαλής τροποποίηση

## Hierarchical Containment Locking
- Χρήσιμο όταν:
  - Ένα αντικείμενο περιέχει άλλα, τα οποία δεν είναι πλήρως κρυφά από τους πελάτες
- Όλα τα επιμέρους αντικείμενα χρησιμοποιούν το ίδιο lock του "ιδιοκτήτη"
- Αποφέυγει deadlocks που θα προέκυπταν από διαφορετικά locks ανά τμήμα
- Εφαρμόζεται μέσω:
  - **Internal locking**: Το αντικείμενο ξέρει το lock του κατόχου του
  - **External locking**: Ο client κρατά το σωστό lock

### Internal Containment Locking (1)
```java
class Part {
  protected Container owner_;
  public Container owner() { return owner_; }

  public void m() {
    synchronized(owner()) {
      bareAction(); // unsafe
    }
  }
}
```
- Κάθε `Part` γνωρίζει τον `Container` του και χρησιμοποιεί το δικό του lock
- Τα parts δεν κάνουν deadlock μεταξύ τους, αν ακολουθείται η ίδια πολιτική

### Internal Containment Locking (2)
```java
class Container {
  class Part {
    public void m() {
      synchronized (Container.this) {
        bareAction();
      }
    }
  }
}
```
- Υλοποίηση με inner classes, που αποκτούν πρόσβαση στο Container.this lock
- Δεν απαιτεί `synchronized` μεθόδο σε κάθε μέρος
- Μπορεί να χρησιμοποιηθεί με :
  - Shared locks
  - Transactional locks

## External Containment Locking
```java
class Client {
  void f(Part p) {
    synchronized(p.owner()) {
      p.bareAction();
    }
  }
}
```
- O client είναι υπέυθυνος να πάρει το σωστό lock πριν καλέσει τη μέθοδο
- Χρησιμοποιείται σε framework όπως το AWT (getTreeLock())

Πλεονεκτήματα:
- Λιγότερος συγχρονισμός (πιο αποδοτικό)
Μειωνεκτήματα:
- Έυθραυστο: Όλοι οι clients πρέπει να τηρούν το convention
- Σπάει την encapsulation

## Subclassing Unsfafe Code (1)
```java
class HandlerHelper {
  native void mountFileSystem();
}
```
- Κώδικας σε native γλώσσα (π.χ C): δεν γνωρίζουμε αν είναι thread-safe
- Πρέπει να τον προστατέψουμε με synchronization

## Subclassing Unsafe Code (2)
```java
class SafeHandlerHelper extends HandlerHelper {
  synchronized void mountFileSystem() {
    super.mountFileSystem();
  }
}
```
- Δημιουργούμε νέα κλάση με synchronized wrapper γύρω απο την unsafe μέθοδο
- Το synchronization είναι τοπικό και διαφανές
- Εναλλακτικά:
  - Μπορούμε να φτιάξουμε wrapper object αντί για subclass
  - Ή να χρησιμοποιήσουμε template method pattern

## State Dependent Actions
Προβλήματα που εξαρτώνται από κατάσταση του αντικειμένου
- Ανάγνωση από άδειο buffer
- Απόσυρση χρημάτων απο άδειο λογαριασμό
- Εκτύπωση χωρίς διαθέσιμο εκτυπωτή

Τεχνικές διαχείρισης:
- Balking
- Guarder Suspension
- Retrying
- Timeout
- Planning

## Interfaces and Policies
```java
public interface Buffer {
  int capacity();
  int size();
  void put(Object x);
  Object take();
}
```
- Το interface περιγράφει τις λογικές προϋποθέσεις για τις μεθόδους
- Όμως δεν επιβάλλει policy
- Κάθε υλοποίηση μπορεί να έχει διαφορετική πολιτική
  - Πετάει exception
  - Περιμένει
  - Αγνοεί το αίτημα

## Balking
- Απορρίπτει τη λειτουργία αν η κατάσταση δεν είναι σωστή
- Ελέγχει την κατάσταση στην αρχή της μεθόδου
- Αν δεν ικανοποιείται: `throw new Failure(...)`
- Δεν αλλάζει την κατάσταση κατά τον έλεγχο!
- Απλό και ασφαλές για synchronized αντικείμενα

Κατάλληλο για:
- Sequential & concurrent προγράμματα
- Collectino classes (π.χ `Vector.add()` όταν γεμίσει)

Σε concurrent περιβάλον, μόνο ο host (δηλαδή η κλάση) πρέπει να κάνει check-act, όχι ο client

### Παραδείγμα: Balking Bounded Buffer
```java
public class BalkingBoundedBuffer implements Buffer {
  private List data;
  private final int capacity;

  public BalkingBoundedBuffer(int capacity) {
    data = new ArrayList(capacity);
    this.capacity = capacity;
  }

  public synchronized Object take() throws Failure {
    if (data.size() == 0) throw new Failure("Buffer Empty");
    Object temp = data.get(0);
    data.remove(0);
    return temp;
  }

  public synchronized void put(Object o) throws Failure {
    if (data.size() == capacity) throw new Failure("Buffer Full");
    data.add(o);
  }

  public synchronized int size() { return data.size(); }
  public int capacity() { return capacity; }
}
```
- Αν το buffer είναι γεμάτο ή άδειο, η μέθοδος απλά αποτυγχάνει
- Δεν γίνεται αναμονή ή block
- Απλό, αποδοτικό, χωρίς προβλήματα liveness
- Δεν κάνει retry, δεν περιμένει - ο client πρέπει να χειριστεί το failure

## Guarding
- Γενίκευση του locking για state-dependent actions
- Αντί να κλειδώσει απλά, το thread περιμένει μέχρι να γίνει true μια συνθήκη

Λειτουργία:
1. Ελέγχει την κατάσταση
2. Αν δεν είναι κατάλληλη μπλοκάρει (wait)
3. Κάποιο άλλο thread κάνει αλλαγή κατάστασης
4. Συνεχίζει όταν η συνθήκη γίνει true

Μπορεί να δημιοργήσει liveness προβλήματα (π.χ αν το άλλο thread δεν κάνει ποτέ update)

## Guarding με busy wait (κακή πρακτική)
```java
while (!condition);
```
- Το thread σπαταλά CPU ενώ περιμένει -> busy spinning
- Χρήσιμο μόνο αν η συνθήκη δεν θα ξαναγίνει false (latching)
- Σε java 1.4 και μετά μπορούμε να ελέγξουμε CPUs με:
```java
Runtime.getRuntime().availableProcessors();
```

## Guarding με Suspension (σωστή προσέγγιση)
```java
synchronized (obj) {
  while (!condition) {
    try {
      obj.wait();
    } catch (InterruptedException e) { ... }
  }
}
```
- Το `wait()` απελευθερώνει το lock και βάζει το thread στο wait set του `obj`
- Όταν ξυπνήσει, ξαναπαίρνει το lock και ελέγχει ξανά τη συνθήκη

## Αλλαγή Συνθήκης - Notifying
```java
synchronized (obj) {
  condition = true;
  obj.notifyAll();
}
```
- Το `notifyAll()` ξυπνά όλα τα threads που περιμένουν στο `obj`
- Χρυσός κανόνας: πάντα ελέγχουμε τη συνθήκη μέσα σε loop γιατί:
  - Άλλα threads μπορεί να την άλλαξαν ξανά
  - Το wakeup μπορεί να είναι spurious

## Wait Sets and Notifications (1)
- Κάθε java object έχει ένα wait set:
  - Περιέχει threads που έχουν καλέσει `wait()` πάνω στο object
- Προϋποθέσεις
  - Το thread πρέπει να κρατά το intrinsic lock (`synchronized(obj)`)
- Όταν καλείται `wait()`
  - Ατομικά: απελευθερώνει το lock και το thread μπαίνει σε ένα wait set
  - Αν κρατά επαναλητπικά locks, τα απελευθερώνει όλα για το object

## Wait Sets and Notifications (2)
Πώς ξυπνούν τα threads
- `notifyAll()`
  - Ξυπνά όλα τα threads στο wait set
- `notify()`
  - Ξυπνά ένα τυχαίο thread
- Άλλοι τρόποι αφύπνισης
  - Έληξε το timeout του `wait(ms)`
  - `interrupt()` κλήθηκε -> πετιέται `InterruptException`
  - Spurious wakeup (π.χ από underlying OS)

Το lock πρέπει να επανακτηθεί πριν συνεχίσει το thread μετά το `wait()`

## Wait Sets and Notification (3)
Αποφύγετε `notify()` - μόνο για optimization και μόνο όταν:
1. Ένα και μόνο thread ενδιαφέρεαι για την αλλαγή κατάστασης
2. Όλα τα threads περιμένουν για την ίδια συνθήκη
3. Το πρόγραμμα (και τα subclasses του!) το εγγυώνται 100%

Προιμήστε `notifyAll()`, είναι πιο ασφαλές

## Χρήση Wait/Notify = Monitor-style Conditions
- Παρόμοια με condition variables σε:
  - POSIX threads
  - Monitors
- Αλλά μόνο για wait queue ανά object -> περιοριστικό για πολύπλοκα patterns

Από Java 5+: προτιμήστε `Lock` + `Condition`, για περισσότερη ευελιξία

## Παράδειγμα: Guarded Bounded Buffer
```java
public class GuarderBoundedBuffer implements Buffer {
  private List data;
  private final int capacity;

  public GuardedBoundedBuffer(int capacity) {
    data = new ArrayList(capacity);
    this capacity = capacity;
  }

  public synchronized Object take() throws Failure {
    while (data.size() == 0) {
      try { wait(); }
      catch (InterruptedException e) {throw new Failure(); }
    }

    Object temp = data.get(0);
    data.remove(0);
    notifyAll();
    return temp;
  }

  public synchronize void put(Object obj) throws Failure {
    while (data.size() == capacity) {
      try { wait(); }
      catch (InterruptedException e) { throws ne Failure(); }
    }

    data.add(obj);
    notifyAll();
  }

  public synchronized int size() { return data.size(); }
  public int capacity() { return capacity; }
}
```
Χρήση `wait()` και `notifyAll()` με σωστά `while` loops
Thread-safe, αποφέυγει race conditions
Δεν είναι επεκτάσιμο εύκολα σε πολλά conditions -> προτιμότερη η χρήση `Condition` από java 5+

## Timeout (ανάμεσα σε Balking & Guarding)
- Μερική αναμονή: Δεν περιμένουμε για πάντα
- Υλοποιείται με `wait(timeout)` ή `awaits(timeout,TimeUnit)`
- Χρήσεις:
  - Εντοπισμός σφαλμάτων (π.χ deadlocks, I/O delays)
  - Ανθεκτικότητα σε αποτυχίες
- Όχι ακριβής χρονισμός
  - Καθυστέρηση ανάμεσα στο `wait` και το resume
  - Δεν ξέρουμε πότε ακριβώς συνεχίζει

## Optimistic Techniques
- Αντί για `wait()` ή `lock()` -> δοκιμάζουμε και ξαναπροσπαθούμε (retry)
- Πιο αποδοτικό όταν:
  - Υπάρχουν πολλού πυρήνες
  - Οι συγκρούσεις είναι σπάνιες

Προσοχή σε livestock
- Άν όλα τα threads αποτυγχάνουν και ξαναδοκιμάζουν συνεχώς
- Λύση: Περιορισμός επαναλήψεων ή χρήση `Thread.yield()`

## Παράδειγμα: Optimistic Bounded Counter
```java
public class OptimisticBoundedCounter {
  private final long MIN, MAX;
  private Long count;

  public OptimisticBoundedCounter(long min, long max) {
    MIN = min; MAX = max;
    count = new Long(MIN);
  }

  public synchronized Long count() { return count; }

  private synchronized boolean commit(Long oldc, Long newc) {
    if (count == oldc) {
      count = newc;
      return true;
    }
    return false;
  }

  public void inc() throws InterruptedException {
    for (;;) {
      if (Thread.interrupted()) throw new InterruptedException();
      Long c = count();
      long v = c.longValue();
      if (v < MAX && commit(c, new Long(v+1)))
        break;
      Thread.yield(); // επιτρέπει σε άλλα threads να προχωρήσουν
    }
  }
}
```
- Δεν μπλοκάρει threads - απλώς επαναπροσπαθεί
- Αποδοτικό όταν οι συγκρούσεις έιναι σπάνιες
- Όχι για χρήση όταν η πρόσβαση είναι συχνά συγκρουόμενη

