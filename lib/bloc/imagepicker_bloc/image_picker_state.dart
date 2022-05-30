part of 'image_picker_bloc.dart';

@immutable
class ImagePickerState {
  final XFile? avatar;
  final XFile? image;

  const ImagePickerState({this.avatar, this.image});

  ImagePickerState selectAvatar({XFile? avatar}) =>
      ImagePickerState(avatar: avatar ?? this.avatar);

  ImagePickerState selectImage({XFile? image}) =>
      ImagePickerState(image: image ?? this.image);
}
