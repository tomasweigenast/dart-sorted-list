# SortedCollection
> An efficient way to sort lists at the time you add items.


## How it works?
Under the hood it uses the `Binary Insertion Sort` algorithm, which has a **O(log n)** time complexity at the time of finding the position to insert the item to but, after finding the index, we need the insert the item to the list, which is **O(N^2)** in the worst case.
> NOTE: Due to its nature, this implementation is not suitable for large collections. In those cases, the best you can do is maintain a normal List and apply sort only when you need it.

## Usage  
 Only you have to do is create a new `SortedList<T>` and, optionally, if `T` is not a primitive or some object that does not implement `Comparable` interface, you must pass the `comparer` argument.

```dart

List<int> mySortedList = SortedList<int>();
mySortedList.add(15);
mySortedList.add(2);
mySortedList.add(8);
mySortedList.add(5);
mySortedList.addAll([6, 4, 16, 65, 32, 20])

print(mySortedList);

// Outputs: SortedList(2, 4, 5, 6, 8, 15, 16, 20, 32, 65)

```

As you can see, `SortedList<T>` extends `List<T>`, so you can use any other method from that class. Keep in mind that methods such as `insert`, `insertAll`, `setRange`, `fillRange` and others will throw an error because it not make sense to insert an item at a specific index if it must be sorted. 

#### Custom `comparer` function
If you have a class that does not implements the `Comparable` interface, you must pass the `comparer` argument or it will throw an exception.

  ```dart

var list = SortedList<User>((left, right) => left.firstName.compareTo(right.firstName));
list.add(User(firstName: "Gerardo"));
list.add(User(firstName: "Alfredo"));

print(list);

// Outputs: SortedList(Alfredo, Gerardo)

```

## Contribute
If you want to contribute, fell free to create an issue on the GitHub repository or make pull requests 😁