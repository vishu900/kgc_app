import 'dart:convert';

import 'package:dataproject2/productionmodel/ImagesResponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Images extends StatefulWidget {
  int _id = 0;
  Images(this._id);
  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  late List data;
  List imagesUrl = [];
  int state = 0;

  @override
  void initState() {
    super.initState();

    fetchDataFromApi();
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 5), child: Text("Processing...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> fetchDataFromApi() async {
    ImagesResponse imagesResponse = ImagesResponse();

    var response = await http.get(Uri.parse(
        "http://103.204.185.17:24976/bkintl/public/api/save_item_image/${widget._id}"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      imagesResponse = ImagesResponse.fromJson(data);
    }
    state = 1;
    setState(() {
      imagesResponse.content?.forEach((element) {
        imagesUrl.add("${imagesResponse.imageTiffPath}${element.toString()}");
      });
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('List Of Images'),
          centerTitle: true,
        ),
        body: Stack(children: <Widget>[
          GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemCount: imagesUrl.length,
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                imagesUrl[index],
                fit: BoxFit.cover,
              );
            },
          ),
          state == 0
              ? imagesUrl.length == 0
                  ? Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container()
              : imagesUrl.length == 0
                  ? Align(
                      alignment: Alignment.center,
                      child: Text("No Data Available"),
                    )
                  : Container()
        ]));
  }
}
