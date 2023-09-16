import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewImage extends StatefulWidget {
  final String image;

  ViewImage({required this.image});

  @override
  State<StatefulWidget> createState() => _ViewImage();
}

class _ViewImage extends State<ViewImage> {
  @override
  void initState() {
    super.initState();
    debugPrint(' ViewImage ${widget.image}} ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
                'https://images.unsplash.com/photo-1606822350112-b9e3caea2461?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=561&q=80'),
            //   imageProvider: NetworkImage(widget.image),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            // heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
          );
        },
        itemCount: 1,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 40.0,
            height: 40.0,
            child: CircularProgressIndicator(
              // backgroundColor: Color(0xFFFF0000).withOpacity(0.70),
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
      ),
    );
  }
}
