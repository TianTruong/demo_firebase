import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  final String id;
  const PostWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  TextEditingController titleController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> posts = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .collection('posts')
        .snapshots();

    return Container(
      height: 500,
      child: StreamBuilder<QuerySnapshot>(
        stream: posts,
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
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                      // color: Colors.grey.shade200,
                      child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Title: ${data.docs[index]['title']}',
                              style: const TextStyle(fontSize: 20)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('${data.docs[index]['status']}',
                                style: const TextStyle(fontSize: 16)),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade500, width: 1))),
                          child: const Center(heightFactor: 1.5),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _updatePost(context, data, index),
                              _deletePost(context, data, index),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                );
              });
        },
      ),
    );
  }

  Container _updatePost(BuildContext context, data, index) {
    return Container(
      height: 40,
      width: 150,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.greenAccent,
              // color: Colors.white,
            )
          ]),
      child: FlatButton(
        child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.edit), Text(' Sửa')]),
        ),
        onPressed: () {
          titleController.text = data.docs[index]['title'];
          statusController.text = data.docs[index]['status'];

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
                                controller: titleController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.edit),
                                    hintText: 'Title',
                                    labelText: 'Title'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: statusController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.book_outlined),
                                    hintText: 'Status',
                                    labelText: 'Status'),
                              ),
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (titleController.text == '' ||
                                      titleController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please enter some text')));
                                  } else {
                                    data.docs[index].reference
                                        .update({
                                          'image': '',
                                          'title': titleController.text,
                                          'status': statusController.text,
                                        })
                                        .whenComplete(
                                            () => Navigator.pop(context))
                                        .then((value) => print('Post Updated'))
                                        .catchError((error) => print(
                                            'Failed to add post: $error'));
                                  }
                                },
                                child: const Text('Update Post to Database'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
        },
      ),
    );
  }

  Container _deletePost(BuildContext context, data, index) {
    return Container(
      height: 40,
      width: 150,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.redAccent,
              // color: Colors.white,
            )
          ]),
      child: FlatButton(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(Icons.delete), Text(' Xóa')]),
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
                                .then((value) => print('User Post'))
                                .catchError((error) =>
                                    print('Failed to add post: $error'));
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
    );
  }
}
