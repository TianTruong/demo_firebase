import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:demo_firebase/bloc/imagepicker_bloc/image_picker_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
    CollectionReference user = FirebaseFirestore.instance.collection('users');

    final imagePickerBloc = BlocProvider.of<ImagePickerBloc>(context);

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
                // Navigator.push(context,
                //                 MaterialPageRoute(builder: (context) {
                //               return ABC(id: widget.id,);
                //             }));

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
                            child: MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                    create: (context) => ImagePickerBloc()),
                              ],
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
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Container(
                                                height: 150,
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.camera_alt),
                                                      title:
                                                          const Text('Camera'),
                                                      onTap: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        imagePickerBloc.add(
                                                            SelectImageEvent(
                                                                ImageSource
                                                                    .camera
                                                                //     ,
                                                                // widget.id
                                                                ));
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.image),
                                                      title:
                                                          const Text('Gallery'),
                                                      onTap: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        imagePickerBloc.add(
                                                            SelectImageEvent(
                                                          ImageSource.gallery,
                                                          // widget.id
                                                        ));
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: BlocBuilder<ImagePickerBloc,
                                            ImagePickerState>(
                                        builder: (context, state) =>
                                            state.image == null
                                                ? Center(
                                                    child: Image.asset(
                                                      'images/intro.jpg',
                                                      fit: BoxFit.cover,
                                                      cacheHeight: 160,
                                                      cacheWidth: 160,
                                                    ),
                                                  )
                                                // Image.file(
                                                //     File(state.image!.path),
                                                //     fit: BoxFit.cover,
                                                //     cacheHeight: 160,
                                                //     cacheWidth: 160,
                                                //   )
                                                : Center(
                                                    child: Container(
                                                        height: 160,
                                                        width: 160,
                                                        child: const Icon(
                                                            Icons.add,
                                                            size: 30)))),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (titleController.text == '' ||
                                            titleController.text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Please enter some text')));
                                        } else {
                                          user
                                              .doc(widget.id)
                                              .collection('posts')
                                              .add({
                                                'image': '',
                                                'title': titleController.text,
                                                'status': statusController.text,
                                              })
                                              .whenComplete(
                                                  () => Navigator.pop(context))
                                              .then((value) {
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
                        )));
              }),
        ),
      ),
    );
    // });
  }
}