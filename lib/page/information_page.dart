// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:demo_firebase/bloc/imagepicker_bloc/image_picker_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class InformationWidget extends StatefulWidget {
  final String img;
  final String id;
  const InformationWidget({Key? key, required this.img, required this.id})
      : super(key: key);

  @override
  State<InformationWidget> createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ImagePickerBloc()),
        ],
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              ImageWidget(id: widget.id, img: widget.img),
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

    return Column(
      children: [
        Center(
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
                    : Image.network(
                        widget.img,
                        fit: BoxFit.cover,
                        cacheHeight: 160,
                        cacheWidth: 160,
                      )),
          )),
        ),
      ],
    );
  }
}
