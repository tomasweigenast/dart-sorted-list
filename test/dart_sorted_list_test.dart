

import 'package:dart_sorted_list/dart_sorted_list.dart';
import 'package:test/test.dart';

void main() {
  test("Test add", () {
    List<int> list = SortedList.from([7, 15, 2, 5]);
    expect(list.toList(), equals([2, 5, 7, 15]));

    List<String> another = SortedList.from(["Tomás", "Diana", "Serena", "Alan"]);
    expect(another.toList(), ["Alan", "Diana", "Serena", "Tomás"]);

    List<MyClass> users = SortedList((a, b) => a.firstName.compareTo(b.firstName));
    users.add(MyClass(firstName: "Jorge", age: 16));
    users.add(MyClass(firstName: "Alberto", age: 64));
    users.add(MyClass(firstName: "Megan", age: 24));
    users.add(MyClass(firstName: "Analia", age: 24));
    expect(users.map((e) => e.firstName).toList(), equals(["Alberto", "Analia", "Jorge", "Megan"]));
  });
}

class MyClass {
  final String firstName;
  final int age;

  MyClass({required this.firstName, required this.age});

  @override
  String toString() => firstName;
}