import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PurBillImageViewer extends StatefulWidget {

  final String? imageMainBaseUrl;
  final List<String>? imageMainList;
  final int position;

  const PurBillImageViewer({Key? key, this.imageMainBaseUrl, this.imageMainList,this.position=0})
      : super(key: key);

  @override
  _PurBillImageViewerState createState() => _PurBillImageViewerState();

}

class _PurBillImageViewerState extends State<PurBillImageViewer> {

  PageController pageController = PageController();
  var position = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      position=widget.position;
      pageController.animateToPage(position,
          duration: Duration(milliseconds: 600),
          curve: Curves.fastLinearToSlowEaseIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
              child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(
                    '${widget.imageMainBaseUrl}${widget.imageMainList![index]}'),
                initialScale: PhotoViewComputedScale.contained * 0.9,
              );
            },
            itemCount: widget.imageMainList!.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 40.0,
                height: 40.0,
                child: CircularProgressIndicator(
                  value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            ),
            pageController: pageController,
            onPageChanged: (pos) {
              setState(() {
                this.position = position;
              });
            },
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List.generate(
                widget.imageMainList!.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      pageController.animateToPage(index,
                          duration: Duration(milliseconds: 600),
                          curve: Curves.fastLinearToSlowEaseIn);
                      setState(() {
                        position=index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: position == index
                                  ? Color(0xFFFF0000).withOpacity(0.70)
                                  : Colors.transparent)),
                      height: 128,
                      width: 128,
                      child: Image.network(
                          '${widget.imageMainBaseUrl}${widget.imageMainList![index]}'),
                    ),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),

    );

  }

}
