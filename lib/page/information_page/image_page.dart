import 'dart:io';

import 'package:flutter/material.dart';
import 'package:demo_firebase/bloc/imagepicker_bloc/image_picker_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
              builder: (context, state) => state.image != null
                  ? Image.file(
                      File(state.image!.path),
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
