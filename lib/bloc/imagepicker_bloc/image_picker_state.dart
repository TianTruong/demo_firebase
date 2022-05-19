part of 'image_picker_bloc.dart';

@immutable
class ImagePickerState {
  final XFile? avatar;

  const ImagePickerState({this.avatar});

  ImagePickerState selectAvatar({XFile? avatar}) =>
      ImagePickerState(avatar: avatar ?? this.avatar);

}
