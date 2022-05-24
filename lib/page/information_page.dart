// ignore_for_file: avoid_print, invalid_return_type_for_catch_error

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:demo_firebase/bloc/imagepicker_bloc/image_picker_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class InformationWidget extends StatefulWidget {
  final int index;
  final String img;
  final String id;
  const InformationWidget(
      {Key? key, required this.index, required this.img, required this.id})
      : super(key: key);

  @override
  State<InformationWidget> createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ImagePickerBloc()),
        ],
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              ImageWidget(id: widget.id, img: widget.img),
              AddPostWidget(index: widget.index, id: widget.id),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Bài viết của bạn',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              PostWidget(id: widget.id)
            ],
          ),
        ),
      ),
    );
  }
}

class ImageWidget extends StatefulWidget {
  final String img;
  final String id;
  const ImageWidget({Key? key, required this.img, required this.id})
      : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    final imagePickerBloc = BlocProvider.of<ImagePickerBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: ClipOval(
            child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                      height: 150,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Camera'),
                            onTap: () async {
                              Navigator.of(context).pop();
                              imagePickerBloc.add(SelectAvatarEvent(
                                  ImageSource.camera, widget.id));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text('Gallery'),
                            onTap: () async {
                              Navigator.of(context).pop();
                              imagePickerBloc.add(SelectAvatarEvent(
                                  ImageSource.gallery, widget.id));
                            },
                          )
                        ],
                      ),
                    ));
          },
          child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
              builder: (context, state) => state.avatar != null
                  ? Image.file(
                      File(state.avatar!.path),
                      fit: BoxFit.cover,
                      cacheHeight: 160,
                      cacheWidth: 160,
                    )
                  : widget.img != ''
                      ? Image.network(
                          widget.img,
                          fit: BoxFit.cover,
                          cacheHeight: 160,
                          cacheWidth: 160,
                        )
                      : Image.asset(
                          'images/intro.jpg',
                          fit: BoxFit.cover,
                          cacheHeight: 160,
                          cacheWidth: 160,
                        )),
        )),
      ),
    );
  }
}

class AddPostWidget extends StatefulWidget {
  final int index;
  final String id;
  const AddPostWidget({Key? key, required this.index, required this.id})
      : super(key: key);

  @override
  State<AddPostWidget> createState() => _AddPostWidgetState();
}

class _AddPostWidgetState extends State<AddPostWidget> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference post = FirebaseFirestore.instance.collection('posts');

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
              )
            ]),
        child: Center(
          child: ListTile(
              title: const Text('Đăng bài viết'),
              onTap: () {
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Please enter some text')));
                                        } else {
                                          post
                                              .add({
                                                'ID_User': widget.id,
                                                'image': '',
                                                'title': titleController.text,
                                                'status': statusController.text,
                                              })
                                              .whenComplete(
                                                  () => Navigator.pop(context))
                                              .then((value) {
                                                firestore
                                                    .collection("users")
                                                    .doc(widget.id)
                                                    .update({
                                                  'post': firestore.doc(
                                                      '/posts/${value.id}'),
                                                });
                                                print('Post ${value.id} Added');
                                              })
                                              .catchError((error) => print(
                                                  'Failed to add user: $error'));

                                          titleController.clear();
                                          statusController.clear();
                                        }
                                      },
                                      child: const Text('Add Post to Database'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
              }),
        ),
      ),
    );
    // });
  }
}

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
    final Stream<QuerySnapshot> posts =
        FirebaseFirestore.instance.collection('posts').snapshots();

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
                if (data.docs[index]['ID_User'] == widget.id) {
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
                }
                return Container();
              });
        },
      ),
    );
  }

  Container _updatePost(BuildContext context, data, index) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.greenAccent,
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
      width: 150,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.redAccent,
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
