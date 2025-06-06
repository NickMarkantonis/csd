# HY342 - Παράλληλος Προγραμματισμός
## Scala

# Introduction to Scala
## What is Scala
Scala είναι statically typed γλώσσα που συνδυάζει αντικειμενοστραφή και συναρτησιακό προγραμματισμό. Αναπτύχθηκε στο EPFL από το Martin Odersky. Επηρεάστηκε από Java,  ML, Haskell, Erlang και άλλες γλώσσες
Κύρια χαρακτηριστικά:
- Πλούσιες γλωσσικές αφαιρέσεις υψηλού επιπέδου
- Ενιαίο αντικειμενοστραφές μοντέλο
- Higher-order functions, pattern matching
- Νέοι τρόποι σύνθεσης και αφαίρεσης εκφράσεων

Scala τρέχει πάνω σε:
- Java Virtual Machine (JVM)
- .NET Virtual Machine

## Goals of Scala
Υποστήριξη για component software
Βασικές υποθέσεις:
- Μία γλώσσα για component software πρέπει να είναι scalable
- Οι ίδιες έννοιες πρέπει να περιγράφουν τόσο μικρά όσο και μεγάλα μέρη του συστήματος
- Όχι πολλά primitives - έμφαση σε abstraction, composition, decomposition
- Ενοποίηση OOP+ functional προγραμματισμού για scalable υποστήριξη components

## Why use Scala?
- Τρέχει στο JVM -> μπορεί να χρησιμοποιήσει οποιοδήποτε Java κώδικα
- Απόδοση σχεδόν ισάξια με Java
- Συντομότερος κώδικας (Odersky ~50% λιγότερος)
- Τοπική type interface
- Λιγότερα Σφάλματα
- Μεγαλύτερη ευελιξία:
  - Όσες public classes θέλεις ανά αρχείο 
  - Operator overloading
- Υποστήριξη και για .NET

## Why learn Scala
- Δημοφιλής τάση στον προγραμματισμό web services
  - LinkedIn, Twitter, Ebay, Foursquare, ....

## Features of Scala
- Συνδυάζει functional και object-oriented προγραμματισμό
- Κάθε value είναι ένα αντικείμενο
- Κάθε function είναι value (συμπεριλαμβανομένων των methods)
- Static typing με τοπικό type interface

Παράδειγμα:
```scala
val p = new Pair(1,"Scala")
```
αντί για:
```java
Pair p = new Pair<Integer,String> (1,"Scala")
```

- Lightweight σύνταξη για:
  - Anonymous functions
  - Higher-order functions
  - Nested functions
  - Currying
- ML-style pattern matching
- Ενσωμάτωση με XML: 
  - Δυνατότητα γραφής XML μέσα στον Scala κώδικα
  - Μετατροπή XML DTD σε Scala class definitions
- Υποστήριξη για regular expression patterns
- Νέοι έλεγχοι ροής χωρίς macros και με διατήρηση static typing
- Οποιαδήποτε function μπορεί να χρησιμοποιηθεί ως infix/postfix operator
- Υποστήριξη για Actor-based προγραμματισμό, κατανεμημένο και παράλληλο
- Ενσωματομένες DSLs, χρήση ως scripting language
- Hugher-kinded types, first-claess functions, closures
- Delimited Types, Generics
- Scala συχνά θεωρείτε gateway drug για ML, Haskell κτλ

## An example class
Παράδειγμα σύγκρισης Java vs Scala:
```java
public class Person {
  public final String name;
  public final int age;
  
  Person(String name, int age) {
    this.name = name;
    this.age = age;
  }
}
```

```scala
class Person(val name: String, val age: Int)
```

## ... and it's use
#### Java
- Χρήση `ArrayList` για να χωρίσουμε άτομα σε minors/adults
- Επαναληπτικός βρόχος για partition

#### Scala:
```scala
val people: Array[Person] = Array (
  new Person("Joe",24),
  new Person("William",23),
  new Person("Jack",22),
  new Person("Averell",21)
)

val (minors,adults) = people partition (_.age < 18)
```
- Λειτουργίες συλλογών -> concise code
- `partition` επιστρέφει πλειάδα με δύο partitions

## Class Hierarchies and Abstract Data types
- Scala ενοποιεί ιεραρχίες κλάσεων και αφηρημένους τύπους δεδομένων (ADTs)
- Υποστηρίζει pattern matching για αντικείμενα
- Προσφέρει σύντομο χειρισμό immutable δομών δεδομένων

Παράδειγμα ιεραρχίας για δυαδικά δέντρα
```scala
abstract class Tree[T]
case object Empty extends Tree[Nothing]
case class Binary[T](elem: T, left: Tree[T], right: Tree[T]) extends Tree[T]
```

In-order traversal:
```scala
def inOrder[T](t: Tree[T]): List[T] = t match {
  case Empty => List()
  case Binary(e,l,r) => inOrder(l) ::: List(e) ::: inOrder(r)
}
```

- Pattern matching + immutable δομές = καθαρός κώδικας
- Extensibility
  - Encapsulation: μόνο τα constructor params είναι public
  - Representation independence

## Functions and Collections
- First-class functions ενισχύουν τις συλλογές
- Ιδιαίτερα χρήσιμες στις immutable collections

Παράδειγμα:
```scala
people.filter(_.age >= 18)
      .groupBy(_.surname)
      .values
      .count(_.length >= 2)
```

## The Scala Object System
- Class-based, single inheritance
- Εύκολος ορισμός singleton objects
- Υποτύποι: norminal (explicit declaration required)
- Υποστηρίζει
  - Traits
  - Compound types
  - Views
- Προσφέρει ευέλικτες αφαιρέσεις

## Classes and Objects
```scala
trait Nat

object Zero extends Nat {
  def isZero: Boolean = true
  def pred: Nat = throw new Error("Zero.pred")
}

class Succ(n: Nat) extends Nat {
  def isZero: Boolean = false
  def pred: nat = n
}
```
- trait = interface με δυνατότητα υλοποίησης μεθόδων + state
- object = singleton
- class Succ = κανονική κλάση

## Traits
- Παρόμοιο με interfaces της Java
- Μπορούν να περιέχουν:
  - υλοποιήσεις μεθόδων
  - state (μεταβλητά μέλη)
- Υποστηρίζεται πολλαπλή κληρονομικότητα

## Example: Traits
Παράδειγμα Trait + Class:
```scala
trait Similarity {
  def isSimilar(x: Any): Boolean
  def isNotSimilar(x: Any): Boolean = !isSimilar(x)
}

class Point(xc: Int, yc: Int) extends Similarity {
  var x: Int = xc
  var y: Int = yc

  def isSimilar(obj: Any) = 
    obj.isInsanceOf[Point] && obj.asIntanceOf[Point].x == x
}
```
- `isNotSimilar` έχει deffault υλοποίηση
- To `Point` κληρονομέι το trait

## Mixin Class Composition
- Mixin: κλάση που προσθέτει μεθόδους σε άλλη κλάση
- Scala -> single inheritance
- Με mixins αποκτούμε ευελιξία

Παράδειγμα που δεν δουλέυει:
```scala
class ColoredPiont3D(...) extends Piont3D(...) with ColoredPoint2D(...)
```
- Δεν επιτρέπεται mixin class με class -> μόνο trait επιτρέπεται

Σωστός κώδικας:
```scala
trait Color {
  var color: String = null
  def setColor(c: String): Unit = color = c
}

class ColoredPoint3D(...) extends Point3D(...) with Color
```
- Το Color είναι trait -> επιτρέπεται mixin
- Επαναχρησιμοποίηση κώδικα -> ευέλικτος σχεδιασμός

- Το mixin composition προσθέτει explicit defined members
- Κανόνας: Η κλάση D (δέκτης του mixin) πρέπει να κληρωνομεί τουλάχιστον ό,τι κληρονομεί και η κλάση C (που κάνουμε mixin)
- Έτσι διασφαλίζεται ότι τα members του trait δουλέυουν σωστά

## Views
- Views = implicit μετατροπές τύπων
- Παρόμοιο με conversion operators σε C++/C#

Παράδειγμα:
```scala
implicit def list2set[T](list: List[T]): Set[T] {
  def extends(x: T): Set[T] = list2set(x :: list)
  def contains(x: T): Boolean = !list.isEmpty && (list.head == x || list.tail.contains(x))
}
```
- Το compiler εισάγει αυτόματα τη μετατροπή όταν χρειάζεται

Πότε εφαρμόζεται view:
- Όταν ο αναμενόμενος τύπος δεν είναι ο τύπος του `e`
- Όταν γίνεται επιλογή member που δεν υπάρχει στον τύπο `e`

Ο compiler ψάχνει για implicit views που υπάρχουν στο scope

## Lazy Views
- Πολλές συλλογές υποστηρίζουν lazy views
- Τα αποτελέσματα δεν υπολογίζονται άμεσα, μόνο όταν χρειάζεται

Παράδειγμα:
```scala
(1 to 10000000).filter(_ % 2 == 0).take(10).toList
// OutOfMemoryError

(1 to 10000000).view.filter(_ % 2 == 0).take(10).toList
// No Error
```
Με view o υπολογισμό γίνεται πιο "τεμπέλικα" -> αποδοτικότερη χρήση μνήμης

## Variance Annotations
Παράδειγμα προβλήματος με Array
```scala
Array[String] // δεν είναι subtype του Array[Any]
```
Γιατί όχι
```scala
val x = new Array
val y = Array[Any] = x
y.set(0,new FooBar()) // θα έβαζε Foobar σε πίνακα String!
```
Δεν είναι ασφαλές

Covariance επιτρέπεται σε immutable δομές
```scala
trait genList[+T] {
  def isEmpty: Boolean
  def head: T
  def tail: GenList[T]
}

object Empty extends GenList[Any] { ... }
class Cons[+T](x: T, xs: GenList[T]) extends GenList[T] { ... }
```
- το `+T` σημαίνει ότι το GenList είναι covariant ως προς Τ

- Μπορούμε επίσης να έχουμε *contravariant* παραμέτρους (`-T`)
- Χρήσημιμο για αντικείμενα που μόνο γράφουμε

Scala ελέγχει ότι οι annotations είναι sound:
- Covariant -> immutable fields, methods results
- Contravairant -> method arguments
- Αν δεν οριστεί variance -> Invariant

## Functions are Objects
- Κάθε function είναι object -> κάθε function είναι value
- Οι values είναι objects -> άρα function = object

Ο τύπος `S => T` ισοδυναμεί με:
```scala
trait Function1[-S,+T] {
  def apply(x: S): T
} 
```
 
Παράδειγμα:
```scala
(x: Int) => x + 1
// ισοδυναμεί με:
new Function1[Int, Int] {
  def apply (x: Int): Int = x + 1
}
```
Υποστηρίζονται και anonymous functions (`_+1`)

## Arrays are Objects
- Τα arrays είναι mutable functions πάνω σε integer ranges

Systactic sugar:
```scala
a(i) = a(i) + 2
// ισοδυναμεί με:
a.update(i,a.apply(i) + 2)
```

Παράδειγμα:
```scala
final class Array[T](_length: Int) {
  extends java.io.Serializable with java.lang.Cloneable {
    def length: Int     = ...
    def apply(i:Int): T = ...
    def update(i:Int,x:T): Unit = ...
    override def clone: Array[T] = ...
  }
}
```

## Partial Functions
- Functions που είναι ορισμένες μόνο για κάποια αντικείμενα

Μπορούμε να ελέγξουμε με:
```scala
isDefinedAt(x)
```

Παράδειγμα:
```scala
trait PartialFunction[-A,+B] extends (A => B) {
  def isDefinedAt(x: A): Boolean
  def orElse[A1 <: A, B1 >: B](that: PartialFunction[A1,B1]): PartialFunction[A1,B1]
}
```
- Το pattern-matching blocks είναι instances of PartialFunction
- Επιτρέπεται πιο σύνθετα control structures

## Atomatic Closure Construction
- Επιτρέπει δημιουργία custom control structures

Mechanism:
- Οι παράμετροι `=>` σημαίνουν ότι δεν αξιολογούνται αμέσως
- Περνάμε function χωρίς ορίσματα αντί για αποτέλεσμα

Χρήσιμο για control abstractions (π.χ custom loops)
Παράδειγμα:
```scala
object TargetTest1 {
  def loopWhile(cond: => Boolean)(body: => Unit): Unit = 
    if (cond) {
      body
      loopWhile(cond)(body)
    }
  
  def main(args: Array[String]) {
    var i = 10
    loopWhile (i > 10) {
      Console.println(i)
      i = i - 1
    }
  }
}
```
- `loopWhile` φτιάχνουμε δικό μας while-loop με recursion
- Η παράμετρος `cond` και `body` είναι closures που αξιολογούνται κάθε φορά

## Types as Class Members
- Μπορούμε να έχουμε τύπους ώς μέλη κλάσης 

Παράδειγμα
```scala
abstract class AbsCell {
  type T
  val init: I
  private var value: T = init

  def get: T = value
  def set(x: T): Unit = {value = x}
}

def createCell(): AbsCell =
  new AbsCell { type T = Int; val init = 1 }
```
- Ο τύπος `T` είναι κρυφός για τον client
- Client δεν μπορεί να υποθέσει ότι `T = Int`

# Parallelism in Scala
## Scala parallel Colelections
Sequential χρήση:
```scala
val list = (1 to 100000).toList
list.map(_ + 42)
```
- Κανονικό sequential `map`, εκτελείται σειριακά

## Scala Parallel Collections
Parallel χρήση
```scala
val list = (1 to 10000).toList
list.par.map(_ + 42)
```
- Προσθέτοντας `.par` -> parallel collection
- Διατίθενται διαφορές parallel δομές:
  - ParArray
  - ParVector
  - mutable.ParHashMap, mutable.ParHashSet
  - immutable.ParhashMap, immutable.ParHashSet
  - ParRange
  - ParTrieMap

## Παραδείγματα: Operators
Parallel map:
```scala
val lastNames = List("Smith","Jones","Frankestein","Bach","Jackson","Rodin").par
latNames.map(_.toUpperCase)
```

Parallel fold:
```scala
val parArray = (1 to 100000).toArray.par
parArray.fold(0)(_ + _)
```

Parallel filter:
```scala
lastNames.filter(_.head >= 'J')
```

## Παραδείγματα: Create
Δημιουργία ParVector:
```scala
import scala.collection.parallel.immutable.ParVector
val pv1 = new ParVector[Int]            // empty parVector
val pv2 = Vector(1,2,3,4,5,6,7,8,9).par // from existing Vector
```

## Parallel Collections
Προσοχή σε δύο πράγματα:
- Side-effecting operations -> μη καθορισμένο αποτέλεσμα (μη-ντετερμινισμός)
  - side effects μπορεί να εκτελέσουν με διαφορετική σειρά ή ταυτόχρονα
- Non-assosiative operations -> μη-νετερμινισμός
  - η σειρά εκτέλεσης επηρεάζει το τελικό αποτέλεσμα

## Παράδειγμα: Race Condition
```scala
var sum = 0
var list = (1 to 1000).toList.par

list.foreach(sum += _)
sum
```
- `sum` δεν είναι thread-safe -> διαφορετικά αποτελέσματα κάθε φορά

## Παράδειγμα: μη-Associatiev operation
```scala
val list = (1 to 1000).toList.par
list.reduce(_ - _) // different result each time
```
- Το `-` δεν είναι associative, άρα σε parallel execution -> διαφορετικό αποτέλεσμα κάθε φορά

## The Actor Model
- Μοντέλο για concurrent computation
- κεντρική ιδέα: Everything is an Actor

Ένα Actor μπορεί να:
- Στείλει μηνύματα σε άλλους actors
- Δημιουργήσει νέους actors
- Αντιδράσει σε εισερχόμενα μηνύματα

Χαρακτηριστικά
- Καμία εγγύηση σειράς εκτέλεσης μεταξύ ενεργειών
- Παράλληλη εκτέλεση και επικοινωνία
- Ιδανικό για parallel και distributed computation

## Actors in Scala
- Αρχικά υπήρχε built-in υλοποίηση στη γλώσσα
- Πλέον χρησιμοποιείται Akka library
  - Distributed Actors
  - Concurrency
  - Scalability
  - Fault-tolerance
  - Single unified programming model
  - Managed runtime (μέσα στην βιβλιοθήκη)
  - Open Source

## Actors in Akka
Στόχος:
- Να προγραμματίζουμε σε υψηλό επίπεδο αφαίρεσης
- Όχι threads, shared state, locks κτλ
- Να σκεφτόμαστε πώς τα μηνύματα ρέουν στο σύστημα

Akka παρέχει:
- Υψηλή χρήση CPU
- Χαμηλό latency
- Scalability
- Ενσωματωμένη υποστήριξη εντοπισμού και ανάκαμψης λαθών

## Parallel and Distributed
- Akka actors είναι distributable by design
- Κλίμακα
  - scale up -> περισσότερα threads
  - scale out -> περισσότερα nodes

Ιδανικό για cloud deployment
- Elastic, dynamic
- Fault-tolerant, self-healing
- Adaptive load-balancing, migration
- Loosely coupled -> επιρεέπει δυναμικές αλλαγές στο runtime

## What is an Actor
Actor = μονάδα οργάνωσης κώδικα στο Akka
Χαρακτηριστικά:
- Βοηθούν στη δημιουργία concurrent, scalable, fault-tolerated εφαρμογών
- Διαχωρισμός policy από business logic

Χρήση:
- Encapsulated, decoupled black boxes
- Διαχειρίζονται τα state και την συμπεριφορά
- Επικοινωνούν μέσω ασύγχρονων, non-blocking μηνυμάτων
- Μπορούν να δημιουργηθούν/τερματιστούν δυναμικά
- Hot deploy -> runtime αλλαγή συμπεριφοράς

## Actor uses
Actors μπορούν να χρησιμοποιηθούν αντί για
- Thread
- Object instance/Component
- Callback listener
- Singleton/Service
- Load balancer/Router/Thread pool
- Java EE Session Bean/Message-Driven Bean
- Out-of-Process service
- Finite State Machine

## Theoretical definition
Ένας Actor ενσωματώνει:
- Processing
- Storage
- Communication

Βασικοί άξονες (axions):
1. Μπορεί να δημιουργήσει νέους actors
2. Μπορεί να στείλει μηνύματα σε actors που γνωρίζει
3. Μπορεί να αλλάξει το πώς θα χειριστεί το επόμενο μήνυμα (dynamic behavior change)

## Core Actor operations
Βασικές λειτουργίες:
- **Define**: ορισμός actor
- **Create**: δημιουργία actor
- **Send**: αποστολή μηνυμάτων
- **Become**: αλλαγή συμπεριφοράς
- **Supervise**: επιτήρηση (supervision) άλλων actors

## Define an Actor
Παράδειγμα:
```scala
import akka.actor._

class Summer extends Actor {
  var sum = 0

  def receive = {
    case ints: Array[Int] =>
      sum += ints.reduceLeft((a,b) => (a+b) % 7)
    case "print" =>
      println("Sum: " + sum)
  }
}
```
- Κάθε actor υλοποιεί τη μέθοδο receive -> pattern matching στα εισερχόμενα μηνύματα
- Το state είναι εσωτερικό στον Actor (π.ψ `sum`)

## Create an Actor
- Δημιουργούμε instance Actor -> lightweight (~2.7M actors/GB RAM)
- Ισχυρή εγκλειστικότητα (encapsulation)
  - state
  - behavior
  - message queue

Παρατήρηση:
- State και behavior δεν είναι ορατά απ' έξω
- Ο μόνος τρόπος παρατήρησης είναι μέσω μηνυμάτων

Παράδειγμα:
```scala
import akka.actor._

class Summer extends Actor {
  var sum = 0

  def receive = {
    case ints: Array[Int] =>
      sum += ints.reduceLeft((a,b) => (a+b) % 7)
    case "print" =>
      println("Sum: " + sum)
  }
}
```
- ActorSystem -> "ρίζα" του axtor hierarchy
- actorOf -> δημιουργία Actor instance

## Actors from Hierarchies
- Το System είναι ο "guardian actor"
- Οι νέοι actors δημιουργούνται μέσω `context.actorOf()`
- Προκύπτει ιεραρχία acrors (μορφή δέντρου)
- Name resolution είναι όπως σε filesystem -> π.χ `\summer\someother`

## Send Messages
- Ασύγχρονη και non-blocking επικοινωνία -> "fire and forget"
- Ένας Actor είναι παθητικός εώς ότου λάβει μήνυμα
- Τα μηνύματα ενεργοποιούν τη λογική του actor

Χαρακτηριστικά:
- Όλα asynchronous και χωρίς locks
- Lightweight -> υποστήριξη εκατομμυρίων μηνυμάτων/δευτερόλεπτο

Παράδειγμα:
```scala
import akka.actor._

class Summer extends Actor {
  var sum = 0
  
  def receive = {
    case ints: Array[Int] =>
      sum += ints.reduceLeft((a,b) => (a+b) % 7)
    case "print" =>
      prinln("Sum: " + sum)
  }
}
```
- `.tell` και `!` -> αποστολή μηνύματος στον Actor
- Η αποστολή είναι μη-blocking

## Replying to Messages
Παράδειγμα
```scala
import akka.actor._

class SomeActor extends Actor {
  def receive = {
    case User(name) =>
      sender ! ("Hi " + name)
  }
}
```
- To sender είναι reference στον αποστολέα του μηνύματος
- Το Actor μπορεί να απαντήσει χρησιμοποιώντας `sender ! ...`

## Remote Deoployment
Παράδειγμα
```hocon
akka {
  actor {
    provider = akka.remote.RemoteActorRefProvider
    deployment {
      /Summer {
        remote = "akka://SummerSystem@machine42:31337"
      }
    }
  }
}
```
- RemoteActorRedProvider -> υποσηρίζει διαμοιρασμένους actors μεταξύ nodes
- Actor `/Summer` θα τρέχει απομαρυσμένα

## Actor Become
- Dynamically redefine τη συμπεριφορά ενός Actor
- Trigger -> Λαμβάνει κάποιο μήνυμα
- Παρόμοιο με το να αλλάζουμε τύπο (interface/protocol/implementation)

Χαρακτηριστικά:
- Μπορεί να αλλάξει πώς θα αντιδρά στα επόμενα μηνύματα
- Behaviors είναι stacked -> μπορούμε να κάνουμε push/pop

## Why?
Χρήσεις του become:
- Ένας Actor με υψηλό load μπορεί να γίνει load balancer
- Υλοποίηση Finite State Machine (FSM)
- Graceful degradation
- Ένας generic worker μπορεί να γίνεται ό,τι χρειάζεται δυναμικά

## Become: load balancing
Παράδειγμα
```scala
val router = system.actorOf(
  Props[SomeActor].withRouter(
    roundRobinRouter(nrOfInstances = 5)
  )
)
```
- RoundRobinRouter -> διανέμει τα μηνύματα σε 5 instances
- Εύκολη υλοποίηση load balancing

## Example: load balancing++
Dynamic scaling
```scala
val resizer = DefaultResizer(lowerBound = 2, upperBound = 15)

val router = system.actorOf(
  Props[SomeActor].withRouter(
    RoundRobinRouter(resizer = Some(resizer))
  )
)
```
- Ο resizer προσαρμόζει δυναμικά τον αριθμό instances
- Adaptive load balancing -> ιδανικό για changing workloads

## Failure Management, Traditionally
Προβλήματα παραδοσιακού χειρισμού λαθων (χωρίς Akka):
- Single thread -> αν σκάσει -> τέλος
- Πρέπει να γίνει explicit error handling σε κάθε thread
- Errors δεν προπαγανδίζονται μεταξύ threads -> δεν ξέρουμε αν κάτι έσπασε
- Οδηγεί σε defensive programming
  - `if(...)`
  - tangled error handling μέσα στο business logic
  - Δύσκολη συντήρηση

## Supervise
- Actors μπορούν να επιτηρούν (supervise) αλλους actors
- Διαχωρισμός:
  - Ο ένας Actor κάνει processing
  - Άλλος Actor κάνει error handling

Λειτουργία:
- Αν ο supervised Actor crashαρει, ειδοποιείται ο supervisor
- Καθαρός διαχωρισμός error handling από business logic
- Υπάρχει deffault supervisor strategy (αρκετή στης περισσότερες περιπτώσεις)

## Παράδειγμα: Supervisor
Παράδειγμα **AllForOneStrategy**
```scala
class Supervisor extends Actor {
  override val supervisorStrategy = OneForOneStrategy(maxNrOfRetries = 10, 
                                                      withinTimeRange = 1) {
    case _ => SupervisorStrategy.Restart
  }

  val worker = context.actorOf(Props[Worker])

  def receive = {
    case n: Int => worker forward n
  }
}
```
- Αν ο worker αποτύχει, ο supervisor θα τον κάνει restart
- Μεμονωμένος χειρισμός per Actor (OneForOne)

## Manage Failure
Παράδειγμα Actor με custom failure handling:
```scala
class Worker extends Actor {
  // ...

  override def preRestart(reason: Throwable, message: Option[Any]) {
    // Καθαρισμός πριν το restart
  }

  override def postRestart(reason: Throwable) {
    // Αρχικοποίηση μετά το restart
  }
}
```
- `preRestart` -> cleanup πριν το restart
- `postRestart` -> setup μετά το restart

## More Scala
- Υπάρχουν πολλοί πόροι για παραπάνω Scala
- Περισσότερο parallel programming
  - Futures
  - Asynchronous calls
  - Threads, thread pools
  - Interoperability με java threads


