import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ProcessOrederPP extends StatefulWidget {
  var SALE_ORDER_DTL_PK;
  var PROD_ORDER_HDR_PK;
  ProcessOrederPP(
      {super.key,
      required this.SALE_ORDER_DTL_PK,
      required this.PROD_ORDER_HDR_PK});

  @override
  State<ProcessOrederPP> createState() => _ProcessOrederPPState();
}

class _ProcessOrederPPState extends State<ProcessOrederPP> {
  final List<Map<String, dynamic>> _photoList = [];

  List<Map<String, dynamic>> _processOrderList = [];
  @override
  void initState() {
    super.initState();
    // getPhotoList();
    getProcessOrderList(widget.PROD_ORDER_HDR_PK.toString(),
        widget.SALE_ORDER_DTL_PK.toString());
  }

  Future<void> getProcessOrderList(
      String SALE_ORDER_DTL_PK, PROD_ORDER_HDR_PK) async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/ProdPlanProdOrder?PROD_ORDER_HDR_PK=" +
            widget.PROD_ORDER_HDR_PK.toString() +
            "&SALE_ORDER_DTL_PK=" +
            widget.SALE_ORDER_DTL_PK.toString());
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    setState(
      () {
        _processOrderList = List.castFrom(jsonResponseList);
      },
    );
  }

  // Future<void> getPhotoList() async {
  //   final url = Uri.parse(
  //       "http://103.204.185.17:24976/bkintl/public/api/save_item_image/" +
  //           widget.processorderData.catalogCode.toString());
  //   final response = await http.get(url);
  //   final jsonResponse = json.decode(response.body);
  //   if (jsonResponse['error'] == 'false') {
  //     setState(() {
  //       _photoList.add(jsonResponse);
  //     });
  //   } else {
  //     print('Error fetching image data');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: PageView.builder(
              itemCount: _processOrderList.length,
              itemBuilder: (context, index) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0, bottom: 18.0, top: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Item Description ",
                              style: TextStyle(),
                            ),
                            Text(
                              _processOrderList[index]["PARTY_ITEM_NAME"]
                                  .toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Prd Order No."),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Catalog Code"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Order Date"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _processOrderList[index]["PARTY_ORDER_NO"]
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _processOrderList[index]["CATALOG_ITEM"]
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    DateFormat('dd.MM.yy').format(
                                      DateTime.parse(
                                        _processOrderList[index]["ORDER_DATE"]
                                            .toString(),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
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
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (_) => PhotoViewPage(
                      //       imageProvider: NetworkImage(imageUrl),
                      //     ),
                      //   ),
                      // );
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
            ],
          ),
        ],
      ),
    );
  }
}
