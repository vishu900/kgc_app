import 'package:dataproject2/material_issue/screens/photo_view_pages.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowImage extends StatefulWidget {
  var itemCode;

  ShowImage({Key? key, required this.itemCode});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  final List<Map<String, dynamic>> _photoList = [];

  Future<void> getPhotoList() async {
    final url = Uri.parse(
        "http://103.204.185.17:24976/bkintl/public/api/save_item_image/" +
            widget.itemCode.toString());
    final response = await http.get(url);
    final jsonResponse = json.decode(response.body);
    if (jsonResponse['error'] == 'false') {
      setState(() {
        _photoList.add(jsonResponse);
      });
    } else {
      print('Error fetching image data');
    }
  }

  @override
  void initState() {
    super.initState();
    getPhotoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffd53233),
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _photoList.length,
        itemBuilder: (BuildContext context, int index) {
          String temp = "";
          if (_photoList[index]['content'].length == 0) {
            temp = "";
          } else {
            temp = _photoList[index]['content'][0].toString();
          }

          final imageUrl = _photoList[index]['image_tiff_path'] + temp;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PhotoViewPage(
                    imageProvider: NetworkImage(imageUrl),
                  ),
                ),
              );
            },
            child: Image.network(
              imageUrl ==
                      "http://103.204.185.17:24976/bkintl/public/CatalogItemImages/"
                  ? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
                  : imageUrl,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
