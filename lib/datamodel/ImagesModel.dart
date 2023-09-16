import 'dart:io';

class ImagesModel {
  final String id;
  File? path;
  String? imagePath;
  bool isLocal;
  bool isEdited;

  ImagesModel(
      {this.id = '',
      this.isLocal = true,
      this.isEdited = false,
      this.path,
      this.imagePath});

}
