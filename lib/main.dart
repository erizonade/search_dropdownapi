import 'dart:async';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<List<UserModel>> getData(String filter) async {
    log(filter);
    //simulate network request for a user
    await Future.delayed(const Duration(seconds: 2));

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: DropdownSearch<UserModel>(
        popupProps: PopupProps.bottomSheet(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            enabled: true,
          ),
          showSelectedItems: true,
        ),
        compareFn: (a, b) => a == b,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: "Menu mode",
            hintText: "country in menu mode",
          ),
        ),
        asyncItems: (String filter) => getData(filter),
        itemAsString: (UserModel u) => u.userAsString(),
        onChanged: (UserModel? data) => print(data),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserModel {
  final String? id;
  final DateTime? createdAt;
  final String? name;
  final String? avatar;

  UserModel({this.id, this.createdAt, this.name, this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return this.createdAt.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => name!;
}
