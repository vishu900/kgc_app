import 'package:dataproject2/Stock_opening/photoview_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowImage extends StatefulWidget {
  ShowImage({Key? key});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  final List<Map<String, dynamic>> _photoList = [];

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
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          // String temp = "";
          // if (_photoList[index]['content'].length == 0) {
          //   temp = "";
          // } else {
          //   temp = _photoList[index]['content'][0].toString();
          // }

          final imageUrl =
              "https://cdn.pixabay.com/photo/2023/04/24/17/48/bird-7948712_960_720.jpg";
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
