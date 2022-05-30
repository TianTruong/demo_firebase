import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  builderCard(j, data_) {
    print('object');
    return Container(
      height: 20,
      color: Colors.blue,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            title: Text('Title: ${data_.docs[j]['title']}',
                style: const TextStyle(fontSize: 20)),
            // subtitle: Padding(
            //   padding: const EdgeInsets.only(top: 5, bottom: 5),
            //   child: Text('${data_.docs[index_]['status']}',
            //       style: const TextStyle(fontSize: 16)),
            // ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // height: 350,
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
                return Container(
                  height: 100,
                  color: Colors.red,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(data.docs[index].reference.id)
                        .collection('posts')
                        .snapshots(),
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

                      if (snapshot.connectionState == ConnectionState.active) {
                        final data_ = snapshot.requireData;

                        for (int i = 1; i < data_.size; i++) {
                          for (int j = 0; j <= i; j++) {
                            print(j);
                            builderCard(j, data_);
                            build(context)=> Card(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  title: Text(
                                      'Title: ${data_.docs[j]['title']}',
                                      style: const TextStyle(fontSize: 20)),
                                  // subtitle: Padding(
                                  //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                                  //   child: Text('${data_.docs[index_]['status']}',
                                  //       style: const TextStyle(fontSize: 16)),
                                  // ),
                                ),
                              ),
                            );
                            // print('aaaaaaaaaaaa $j');
                            // print('bbbbbbbbbb');
                          }
                        }
                        ;
                      }
                      return Container();
                    },
                  ),
                );
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text('Title: ${data.docs[index].reference.id}',
                          style: const TextStyle(fontSize: 20)),
                      // subtitle: Padding(
                      //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                      //   child: Text('${data_.docs[index_]['status']}',
                      //       style: const TextStyle(fontSize: 16)),
                      // ),
                    ),
                  ),
                );
              });
        },
      ),

      // StreamBuilder<QuerySnapshot>(
      //   stream: posts,
      //   builder: (
      //     BuildContext context,
      //     AsyncSnapshot<QuerySnapshot> snapshot,
      //   ) {
      //     if (snapshot.hasError) {
      //       return const Text('Something went wrong.');
      //     }
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Text('Loading');
      //     }

      //     final data_ = snapshot.requireData;

      //     return ListView.builder(
      //         itemCount: data_.size,
      //         itemBuilder: (context, index_) {
      //           return Card(
      //             child: Padding(
      //               padding: const EdgeInsets.all(5.0),
      //               child: ListTile(
      //                 title: Text('Title: ${data_.docs[index_]['title']}',
      //                     style: const TextStyle(fontSize: 20)),
      //                 // subtitle: Padding(
      //                 //   padding: const EdgeInsets.only(top: 5, bottom: 5),
      //                 //   child: Text('${data_.docs[index_]['status']}',
      //                 //       style: const TextStyle(fontSize: 16)),
      //                 // ),
      //               ),
      //             ),
      //           );
      //         });
      //   },
      // ),
    );
  }
}
