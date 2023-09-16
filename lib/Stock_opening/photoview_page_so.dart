import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoviewSO extends StatelessWidget {
  final ImageProvider imageProvider;

  const PhotoviewSO({
    super.key,
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffd53233),
        elevation: 0,
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Center(
        child: PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: Colors.white,
          ),
          imageProvider: imageProvider,
          minScale: PhotoViewComputedScale.contained,
        ),
      ),
    );
  }
}
