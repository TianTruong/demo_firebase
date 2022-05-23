import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(const ImagePickerState()) {
    on<SelectAvatarEvent>(_onSelectAvatarEvent);
  }

  Future<void> _onSelectAvatarEvent(
      SelectAvatarEvent event, Emitter<ImagePickerState> emit) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // ignore: non_constant_identifier_names
    // final ImageID = DateTime.now().microsecondsSinceEpoch.toString();
    final ImagePicker _picker = ImagePicker();

    Reference ref = FirebaseStorage.instance.ref().child(event.id);
    // .child('/images')
    // .child('Image_$ImageID');

    final XFile? avatar = await _picker.pickImage(source: event.source);

    var img = File(avatar!.path);

    await ref.putFile(img);

    var downloadURL = await ref.getDownloadURL();

    // ignore: avoid_print
    print(downloadURL);

    firebaseFirestore
        .collection('users')
        .doc(event.id)
        .update({'image': downloadURL});

    emit(state.selectAvatar(avatar: avatar));
  }
}
