import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({
    required this.name,
    required this.age,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Person updated([String? name, int? age]) => Person(
        name: name ?? this.name,
        age: age ?? this.age,
        uuid: uuid,
      );
  String get displayName => '$name ($age years old)';

  @override
  int get hashCode => uuid.hashCode; // we use hash for comparison

  @override
  String toString() => 'Person(name: $name, age: $age; uuid =$uuid )';
}

class DataModel extends ChangeNotifier {
  final List<Person> _people =
      []; // for any number of people it contains while list

  int get count => _people.length;
  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);

  void addPerson(Person person) {
    _people.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    _people.remove(person);
    notifyListeners();
  }

  void update(Person updatedPerson) {
    final index = _people.indexOf(updatedPerson);
    final oldPerson = _people[index];
    if (oldPerson.name != updatedPerson.name ||
        oldPerson.age != updatedPerson.age) {
      _people[index] = oldPerson.updated(
        updatedPerson.name,
        updatedPerson.age,
      );
      notifyListeners();
    }
  }
}

final peopleProvider = ChangeNotifierProvider((_) => DataModel());

class HomePage4 extends ConsumerWidget {
  const HomePage4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StreamProvider'),
      ),
      body: Consumer(
        builder: (context , ref, child){
          final DataModel = ref.watch(peopleProvider);
          return ListView.builder(
            itemCount: DataModel.count,
            itemBuilder: (context ,index){
              final person = DataModel.people[index];
              return ListTile(
                title: GestureDetector(
                  onTap: () async{
                    final updatedPerson = await createOrUpdatePersonDialog(
                      context,
                      person,
                    );
                    if(updatedPerson != null){
                      DataModel.update(updatedPerson);

                    }

                  },
                  child: Text(person.displayName)),

              );
            }
            );

        }
    
        ),
        floatingActionButton:FloatingActionButton(
          onPressed: () async {
            final person = await createOrUpdatePersonDialog(context, );
            if(person != null){
              final DataModel = ref.read(peopleProvider);
              DataModel.addPerson(person);
            }

          },
          child: Icon(Icons.add),
          ),
    );
  }
}

final nameController = TextEditingController();
final ageController = TextEditingController();

Future<Person?> createOrUpdatePersonDialog(
  BuildContext context, [
  Person? existingPerson,
]) {
  String? name = existingPerson?.name;
  int? age = existingPerson?.age;

  nameController.text = name ?? ''; // name or empty
  ageController.text = age?.toString() ?? '';

  return showDialog<Person?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create a person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Enter name here', hintText: 'Enter name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                    labelText: 'Enter age here', hintText: 'Enter age'),
                onChanged: (value) => age = int.tryParse(value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if(name != null && age != null){
                  if(existingPerson != null){
                    final newPerson = existingPerson.updated(   // if we have existing person
                      name,
                      age,
                    );
                    Navigator.of(context).pop(
                      newPerson,
                    );

                  }
                  else{
                    // person not exist, so create new person

                    // final newPerson = Person(
                    //   name: name!, 
                    //   age: age!,
                    //   ); or
                      Navigator.of(context).pop(
                        Person(
                          name: name!, 
                          age: age!,
                          )
                      );
                  }
                }
                else{
                  Navigator.of(context).pop();
                }

              },
              child: Text('Create'),
            ),
          ],
        );
      });
}
