import 'package:flutter/material.dart';
import 'package:demo_firebase/bloc/imagepicker_bloc/image_picker_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_firebase/page/information_page/image_page.dart';
import 'package:demo_firebase/page/information_page/addpost_page.dart';
import 'package:demo_firebase/page/information_page/post_page.dart';

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




