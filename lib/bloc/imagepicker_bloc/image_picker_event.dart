part of 'image_picker_bloc.dart';

@immutable
abstract class ImagePickerEvent {}

class SelectAvatarEvent extends ImagePickerEvent {
  final ImageSource source;
  final String id;

  SelectAvatarEvent(this.source, this.id);
}