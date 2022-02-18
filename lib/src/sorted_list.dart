import 'dart:collection';
import 'dart:math';

final _notSupportedException = StateError("Cannot insert an element at a specific index in a sorted list.");

typedef CompareFunc<T> = int Function(T left, T right);

class SortedList<T> extends ListBase<T> {
  final List<T> _base;
  final CompareFunc<T> _comparer;

  int _length = 0;

  SortedList([CompareFunc<T>? comparer]) : _comparer = comparer ?? _defaultCompare, _base = [];
  SortedList.from(Iterable<T> iterable, [CompareFunc<T>? comparer]) : _comparer = comparer ?? _defaultCompare, _base = [] {
    addAll(iterable.toList());
  }
  
  @override
  set length(int length) {
    throw Exception("Cannot modify the length of a sorted list.");
  }

  @override
  int get length => _length;

  @override
  T operator [](int index) => _base[index];

  @override
  void operator []=(int index, T value) {
    throw _notSupportedException;
  }

  @override
  bool get isEmpty => _base.isEmpty;

  @override
  bool get isNotEmpty => _base.isNotEmpty;

  @override
  T get first => _base.first;

  @override
  T get last => _base.last;

  @override
  set last(T value) {
    throw _notSupportedException;
  }

  @override
  set first(T value) {
    throw _notSupportedException;
  }

  @override
  T get single => _base.single;

  @override
  bool contains(Object? element) => _base.contains(element);

  @override
  bool every(bool Function(T element) test) => _base.every(test);
  
  @override
  bool any(bool Function(T element) test) => _base.any(test);

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) => _base.firstWhere(test, orElse: orElse);

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) => _base.lastWhere(test, orElse: orElse);

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) => _base.singleWhere(test, orElse: orElse);

  @override
  String join([String separator = ""]) => _base.join(separator);

  @override
  Iterable<T> where(bool Function(T element) test) => _base.where(test);

  @override
  Iterable<E> whereType<E>() => _base.whereType<E>();

  @override
  Iterable<E> map<E>(E Function(T element) f) => _base.map<E>(f);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T element) f) => _base.expand(f);

  @override
  T reduce(T Function(T previousValue, T element) combine) => _base.reduce(combine);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) => _base.fold<E>(initialValue, combine);

  @override
  Iterable<T> skip(int count) => _base.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T element) test) => _base.skipWhile(test);

  @override
  Iterable<T> take(int count) => _base.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T element) test) => _base.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _base.toList();

  @override
  Set<T> toSet() => _base.toSet();

  @override
  bool remove(Object? element) => _base.remove(element);

  @override
  void removeWhere(bool Function(T element) test) => _base.removeWhere(test);

  @override
  void retainWhere(bool Function(T element) test) => _base.retainWhere(test);
  
  @override
  void clear() => _base.clear();

  @override
  List<R> cast<R>() {
    throw Exception("Cannot cast a SortedList");
  }

  @override
  T removeLast() => _base.removeLast();

  @override
  T removeAt(int index) => _base.removeAt(index);

  @override
  void removeRange(int start, int end) => _base.removeRange(start, end);
  
  @override
  Map<int, T> asMap() => _base.asMap();

  @override
  void add(T element) {
    _addSorted(element);
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    throw Exception("Why would you sort an already sorted list?");
  }

  @override
  void addAll(Iterable<T> iterable) {
    for(var item in iterable) {
      _addSorted(item);
    }
  }

  @override
  void insert(int index, T element) {
    throw _notSupportedException;
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    throw _notSupportedException;
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    throw _notSupportedException;
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    throw _notSupportedException;
  }

  @override
  void shuffle([Random? random]) => _base.shuffle(random);

  @override
  List<T> operator +(List<T> other) => SortedList.from(other, _comparer);

  @override
  List<T> sublist(int start, [int? end]) {
    int listLength = _length;
    end ??= listLength;

    RangeError.checkValidRange(start, end, length);
    return SortedList.from(getRange(start, end), _comparer);
  }

  @override
  Iterable<T> getRange(int start, int end) => _base.getRange(start, end);

  @override
  void fillRange(int start, int end, [T? fill]) {
    throw _notSupportedException;
  }

  @override
  void replaceRange(int start, int end, Iterable<T> newContents) {
    throw _notSupportedException;
  }

  @override
  int indexOf(Object? element, [int start = 0]) => _base.indexOf(element as T, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) => _base.indexWhere(test, start);
  
  @override
  int lastIndexOf(Object? element, [int? start]) => _base.lastIndexOf(element as T, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) => _base.lastIndexWhere(test, start);

  @override
  Iterable<T> get reversed => _base.reversed;
  
  @override
  String toString() => "SortedList(${_base.join(', ')})";

  void _addSorted(T element) {
    if(isEmpty) {
      _base.add(element);
      _length++;
    } else {
      int low = 0;
      int high = _length;
      int mid = 0;

      while(low < high) {
        mid = low + high >>> 1;
        if(_comparer(_base[mid], element) < 0) {
          low = mid + 1;
        } else {
          high = mid;
        }
      }

      // now "low" contains the index to insert to 
      _base.insert(low, element);
      _length++;
    }
  }

  /*void _addSorted(T element) {
    print("Inserting element $element");

    if(isEmpty) {
      print("is empty. adding normally.");
      _base.add(element);
      _length++;
      return;
    }

    if(_comparer(_base[_length-1], element) <= 0) {
      print("element compared to ${_base[_length-1]} returned -1, adding normally.");
      _base.add(element);
      _length++;
      return;
    }

    if(_comparer(_base[0], element) >= 0) {
      print("element compared to ${_base[0]} returned 1, inserting at 0.");
      _base.insert(0, element);
      _length++;
      return;
    }

    int index = binarySearch<T>(_base, element, compare: _comparer);
    print("binary searched element returned index $index.");

    if(index < 0) {
      index = ~index;
      print("applied bitwise to index giving $index.");
    }

    print("inserting at $index.");
    _base.insert(index, element);
    _length++;
  }*/

  static int _defaultCompare(dynamic a, dynamic b) {
    return Comparable.compare(a as Comparable, b as Comparable);
  }
}
