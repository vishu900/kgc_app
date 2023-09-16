import 'dart:io';
import 'dart:typed_data';

class HandModel {
  final String fingerName;
  List<int>? fingerValue;
  Uint8List? fingerImage;
  bool isSelected;
  bool isDone;
  int quality;
  File? file;

  HandModel(
      {required this.fingerName,
      this.fingerValue,
      this.fingerImage,
      required this.isSelected,
      this.isDone = false,
      required this.quality,
      this.file});

  static List<HandModel> loadLeftHandList() {
    List<HandModel> mList = [];
    for (int i = 1; i <= 5; i++) {
      mList.add(HandModel(
          fingerName: 'Left Finger $i', isSelected: false, quality: 0));
    }
    return mList;
  }

  static List<HandModel> loadRightHandList() {
    List<HandModel> mList = [];
    for (int i = 1; i <= 5; i++) {
      mList.add(HandModel(
          fingerName: 'Right Finger $i', isSelected: false, quality: 0));
    }
    return mList;
  }
}
