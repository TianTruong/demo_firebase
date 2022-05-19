// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUserWidget extends StatefulWidget {
  const AddUserWidget({Key? key}) : super(key: key);

  @override
  State<AddUserWidget> createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            keyboardType: TextInputType.text,
            controller: nameController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                hintText: 'Name',
                labelText: 'Name'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            keyboardType: TextInputType.number,
            controller: ageController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.date_range),
                hintText: 'Age',
                labelText: 'Age'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            keyboardType: TextInputType.phone,
            controller: phoneController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
                hintText: 'Phone',
                labelText: 'Phone'),
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (nameController.text == '' ||
                  ageController.text == '' ||
                  phoneController.text == '' ||
                  nameController.text.isEmpty ||
                  ageController.text.isEmpty ||
                  phoneController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter some text')));
              } else {
                user
                    .add({
                      'image': '',
                      'name': nameController.text,
                      'age': ageController.text,
                      'phone': phoneController.text,
                    })
                    .whenComplete(() => Navigator.pop(context))
                    .then((value) => print('User Added ${value.id}'))
                    .catchError((error) => print('Failed to add user: $error'));

                nameController.clear();
                ageController.clear();
              }
            },
            child: const Text('Add User to Database'),
          ),
        )
      ],
    ));
  }
}
