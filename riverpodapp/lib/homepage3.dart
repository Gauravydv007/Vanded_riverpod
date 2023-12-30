// stream provider

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class Person{
  late final String name;
  late final int age;
  late final String uuid;
}



class HomePage2 extends ConsumerWidget {
  const HomePage2({Key ? key}):super(key: key);

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Home Page'),
      ),



    );


  }
}