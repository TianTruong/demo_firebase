// ignore_for_file: avoid_print, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:demo_firebase/page/add_page.dart';
import 'package:demo_firebase/page/information_page.dart';

class HomePageWidget extends StatelessWidget {
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Firestore Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Data from Clound Firestore',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 30, color: Colors.black),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const AddUserWidget();
                    }),
                  ),
                ),
              ],
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: users,
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong.');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                }

                final data = snapshot.requireData;

                return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Name: ${data.docs[index]['name']}, ${data.docs[index]['age']} year old.',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text('Phone: ${data.docs[index]['phone']}'),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return InformationWidget(
                                      img: data.docs[index]['image'],
                                      id: data.docs[index].reference.id);
                                }));
                              },
                            ),
                          ),
                          Row(
                            children: [
                              _updateUser(context, data, index),
                              _deleteUser(context, data, index)
                            ],
                          )
                        ],
                      );
                    });
              },
            )),
          ],
        ),
      ),
    );
  }

  Padding _updateUser(BuildContext context, data, index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.greenAccent,
              )
            ]),
        child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              nameController.text = data.docs[index]['name'];
              ageController.text = data.docs[index]['age'].toString();
              phoneController.text = data.docs[index]['phone'].toString();
              showDialog(
                  context: context,
                  builder: (context) => Dialog(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Please enter some text')));
                                      } else {
                                        data.docs[index].reference
                                            .update({
                                              'name': nameController.text,
                                              'age': ageController.text,
                                              'phone': phoneController.text
                                            })
                                            .whenComplete(
                                                () => Navigator.pop(context))
                                            .then((value) =>
                                                print('User Updated'))
                                            .catchError((error) => print(
                                                'Failed to add user: $error'));
                                      }
                                    },
                                    child:
                                        const Text('Update User to Database'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
            }),
      ),
    );
  }

  Padding _deleteUser(BuildContext context, data, index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.redAccent,
              )
            ]),
        child: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Accept ?'),
                      content: const Text('Do you delete User?'),
                      actions: [
                        FlatButton(
                            child: const Text('Yes'),
                            onPressed: () async {
                              data.docs[index].reference
                                  .delete()
                                  .whenComplete(() => Navigator.pop(context))
                                  .then((value) => print('User Deleted'))
                                  .catchError((error) =>
                                      print('Failed to add user: $error'));

                              // print(data.docs[index]['image']);
                              // print(data.docs[index].reference.id);

                              final Reference ref = FirebaseStorage.instance
                                  .refFromURL(data.docs[index]['image']);
                              await FirebaseStorage.instance
                                  .ref(ref.fullPath)
                                  .delete()
                                  .whenComplete(() => print(ref.fullPath));
                            }),
                        FlatButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    ));
          },
        ),
      ),
    );
  }
}
