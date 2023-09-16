import 'dart:convert';
import 'dart:io';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/itemMaster/MapToMachine.dart';
import 'package:dataproject2/itemMaster/model/ItemResultModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart' as web;
import 'package:dataproject2/newmodel/ItemMasterModel.dart';
import 'package:dataproject2/quotation/ViewPdf.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
//import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'ViewItemOtherDetail.dart';

// ignore: must_be_immutable
class ViewItemDetail extends StatefulWidget {
  List<ItemResultModel> selectedItem;
  final ComingFrom? comingFrom;

  ViewItemDetail({required this.selectedItem, this.comingFrom});

  @override
  State<StatefulWidget> createState() => _ViewItemDetail();
}

class _ViewItemDetail extends State<ViewItemDetail> with NetworkResponse {
  List<ItemMasterModel> itemMasterList = [];
  int position = 0;
  String? imgBaseUrl = '';
  int _current = 0;
  double? screenWidth;

  @override
  void initState() {
    super.initState();
    debugPrint('ViewItemDetail ${widget.selectedItem.length}');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getItemDetails();
    });

    debugPrint('ComingFrom ${widget.comingFrom}');
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF0000),
          automaticallyImplyLeading: true,
          title: Text(
            itemMasterList.isEmpty
                ? 'Item Detail'
                : 'Item Detail  ${position + 1}/${itemMasterList.length}',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            Visibility(
              visible: widget.comingFrom == ComingFrom.Quotation,
              child: IconButton(
                  icon: Icon(
                    Icons.send_sharp,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    List<dynamic> data = [];
                    data.add(imgBaseUrl);
                    data.add(itemMasterList);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(data);
                  }),
            )
          ],
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.white),
            labelStyle: TextStyle(fontSize: 18, color: Colors.white),
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.all(8),
            physics: BouncingScrollPhysics(),
            tabs: [
              Text('Catalog'),
              Text('Material'),
              Text('Count'),
              Text('Brand'),
              Text('Shade'),
              Text('Catalog Machine'),
            ],
          ),
        ),
        body: PageView.builder(
          onPageChanged: (pos) {
            setState(() {
              position = pos;
            });
          },
          itemBuilder: (context, index) {
            return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  getWidgets(WidgetType.Catalog, index),
                  getWidgets(WidgetType.Material, index),
                  getWidgets(WidgetType.Count, index),
                  getWidgets(WidgetType.Brand, index),
                  getWidgets(WidgetType.Shade, index),
                  getWidgets(WidgetType.MachineCatalog, index),
                ]);
          },
          itemCount: itemMasterList.length,
        ),
      ),
    );
  }

  Widget getWidgets(WidgetType type, int index) {
    switch (type) {
      case WidgetType.Catalog:
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Item Images
              SizedBox(
                height: screenWidth! / 1.5,
                child: Container(
                  width: screenWidth,
                  height: screenWidth! / 1.5,
                  child: itemMasterList[index].imageList!.isNotEmpty
                      ? PhotoViewGallery.builder(
                          backgroundDecoration:
                              BoxDecoration(color: Colors.white),
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: (BuildContext context, int imgIndex) {
                            _current = imgIndex;
                            return PhotoViewGalleryPageOptions(
                              onTapUp: (context, _, val) {
                                logIt('onTapUp $val');
                                if (itemMasterList[index]
                                        .mediaTypeList![imgIndex] !=
                                    'Image') {
                                  Map json = {
                                    'user_id': getUserId(),
                                    'code_pk': itemMasterList[index]
                                        .imageList![imgIndex]
                                  };

                                  web.WebService.fromApi(
                                          AppConfig.viewCatalogPdf, this, json)
                                      .callPostService(context);
                                }
                              },
                              imageProvider: itemMasterList[index]
                                          .mediaTypeList![imgIndex] ==
                                      'Image'
                                  ? NetworkImage(
                                      '$imgBaseUrl${itemMasterList[index].imageList![imgIndex]}.png')
                                  : _getFileIcon(itemMasterList[index]
                                      .mediaTypeList![imgIndex]
                                      .toLowerCase()),
                              initialScale:
                                  PhotoViewComputedScale.contained * 0.8,
                            );
                          },
                          onPageChanged: (value) {
                            setState(() {
                              _current = value;
                            });
                          },
                          itemCount: itemMasterList[index].imageList!.length,
                          loadingBuilder: (context, event) => Center(
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              child: CircularProgressIndicator(
                                value: event == null
                                    ? 0
                                    : event.cumulativeBytesLoaded /
                                        event.expectedTotalBytes!,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.white,
                          child: Center(
                            child: Image.asset('images/noImage.png'),
                          ),
                        ),
                  //child: Image.network('$imgBaseUrl${itemMasterList[index].imageList[imgIndex]}.png'),
                ),
              ),

              /// Carousel Indicator
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: itemMasterList[index].imageList!.map((item) {
                    int mIndex = itemMasterList[index].imageList!.indexOf(item);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == mIndex
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ),

              /// Block
              Visibility(
                visible: itemMasterList[index].type == '2',
                child: Visibility(
                  visible: !itemMasterList[index].isEnabled,
                  child: OutlinedButton(
                      onPressed: () {
                        _blockUnBlock(itemMasterList[index].catalogCode, '1');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Block Item',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.block_sharp,
                            color: AppColor.appRed,
                            size: 20,
                          )
                        ],
                      )),
                ),
              ),

              /// UnBlock
              Visibility(
                visible: itemMasterList[index].type == '2',
                child: Visibility(
                  visible: itemMasterList[index].isEnabled,
                  child: OutlinedButton(
                      onPressed: () {
                        _blockUnBlock(itemMasterList[index].catalogCode, '0');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'UnBlock Item',
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.done,
                            color: Colors.green,
                            size: 20,
                          )
                        ],
                      )),
                ),
              ),

              /// Item Data
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    /// Item Name
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Text(
                          'Item Name:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          itemMasterList[index].itemName,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Catalog Code
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          'Catalog Code:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].catalogCode!.trim().isNotEmpty
                              ? itemMasterList[index].catalogCode!
                              : 'N/A',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Item Code
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          'Item Code:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].itemCode!.trim().isNotEmpty
                              ? itemMasterList[index].itemCode!
                              : 'N/A',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Category
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          'Category:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          itemMasterList[index].category!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Sub Category
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                          'Sub Category:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].subCategory!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Type
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Type:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].Type!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Min Stock
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Min Stock:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].MinStock!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Max Stock
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Max Stock:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].MaxStock!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Uom
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Uom:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].Uom!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Brand
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Brand:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].Brand!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Process
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Process:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].Process!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Material
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Material:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].Material!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Machine
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Machine:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].Machine!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Shade
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Shade:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].Shade!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Count
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Count:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          itemMasterList[index].Count!,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Para 1
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Para 1:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          '${itemMasterList[index].itemParameter1} ${itemMasterList[index].itemValue1} ${itemMasterList[index].itemUom1}',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Para 2
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Para 2:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          '${itemMasterList[index].itemParameter2} ${itemMasterList[index].itemValue2} ${itemMasterList[index].itemUom2}',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Para 3
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Para 3:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          '${itemMasterList[index].itemParameter3} ${itemMasterList[index].itemValue3} ${itemMasterList[index].itemUom3}',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Created Date
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Created Date:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          '${itemMasterList[index].createdDate}',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),

                    /// Created Date
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          'Created By:',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Text(
                          '${itemMasterList[index].createdBy}',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ]),
                  ],
                ),
              ),

              /// Item Attributes
              Visibility(
                visible: itemMasterList[index].attributeList!.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _buildCells(
                            itemMasterList[index].attributeList!.length, index),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildRows(
                                itemMasterList[index].attributeList!.length,
                                index),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: itemMasterList[index].type == '2',
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                  builder: (context) => MapToMachine(
                                        catalogCode:
                                            itemMasterList[index].catalogCode,
                                        itemName:
                                            itemMasterList[index].itemName,
                                      )));
                          _getItemDetails();
                        },
                        // color: AppColor.appRed,
                        child: Text(
                          'Map To Machine',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                  builder: (context) => ViewItemOtherDetail(
                                        catalogCode:
                                            itemMasterList[index].catalogCode,
                                      )));
                        },
                        // color: AppColor.appRed,
                        child: Text(
                          'View Other Detail',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );

      //  break;
      case WidgetType.Material:
        return ListView(
          padding: EdgeInsets.all(12),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Item Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Text(
                    itemMasterList[index].name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            itemMasterList[index].materialList!.isNotEmpty
                ? Column(
                    children: List.generate(
                        itemMasterList[index].materialList!.length,
                        (mIndex) => Container(
                              width: double.infinity,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    itemMasterList[index]
                                        .materialList![mIndex]
                                        .name!,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            )),
                  )
                : Column(
                    children: [
                      SizedBox(height: 50),
                      Center(
                          child: Text(
                        'No data found.',
                        style: TextStyle(fontSize: 18),
                      )),
                    ],
                  )
          ],
        );
      // break;

      case WidgetType.Count:
        return ListView(
          padding: EdgeInsets.all(12),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Item Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Text(
                    itemMasterList[index].name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            itemMasterList[index].countList!.isNotEmpty
                ? Column(
                    children: List.generate(
                        itemMasterList[index].countList!.length,
                        (mIndex) => Container(
                              width: double.infinity,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    itemMasterList[index]
                                        .countList![mIndex]
                                        .name!,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            )),
                  )
                : Column(
                    children: [
                      SizedBox(height: 50),
                      Center(
                          child: Text(
                        'No data found.',
                        style: TextStyle(fontSize: 18),
                      )),
                    ],
                  )
          ],
        );
      // break;

      case WidgetType.Brand:
        return ListView(
          padding: EdgeInsets.all(12),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Item Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Text(
                    itemMasterList[index].name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            itemMasterList[index].brandList!.isNotEmpty
                ? Column(
                    children: List.generate(
                        itemMasterList[index].brandList!.length,
                        (mIndex) => Container(
                              width: double.infinity,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    itemMasterList[index]
                                        .brandList![mIndex]
                                        .name!,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            )),
                  )
                : Column(
                    children: [
                      SizedBox(height: 50),
                      Center(
                          child: Text(
                        'No data found.',
                        style: TextStyle(fontSize: 18),
                      )),
                    ],
                  )
          ],
        );
      // break;

      case WidgetType.Shade:
        return ListView(
          padding: EdgeInsets.all(12),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Item Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Text(
                    itemMasterList[index].name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            itemMasterList[index].shadeList!.isNotEmpty
                ? Column(
                    children: List.generate(
                        itemMasterList[index].shadeList!.length,
                        (mIndex) => Container(
                              width: double.infinity,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    itemMasterList[index]
                                        .shadeList![mIndex]
                                        .name!,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            )),
                  )
                : Column(
                    children: [
                      SizedBox(height: 50),
                      Center(
                          child: Text(
                        'No data found.',
                        style: TextStyle(fontSize: 18),
                      )),
                    ],
                  ),
          ],
        );
      // break;

      case WidgetType.MachineCatalog:
        return ListView(
          padding: EdgeInsets.all(12),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Item Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Text(
                    itemMasterList[index].name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            itemMasterList[index].catalogMachineList!.isNotEmpty
                ? Column(
                    children: List.generate(
                        itemMasterList[index].catalogMachineList!.length,
                        (mIndex) => Container(
                              width: double.infinity,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    itemMasterList[index]
                                        .catalogMachineList![mIndex]
                                        .name!,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            )),
                  )
                : Column(
                    children: [
                      SizedBox(height: 50),
                      Center(
                          child: Text(
                        'No data found.',
                        style: TextStyle(fontSize: 18),
                      )),
                    ],
                  ),
          ],
        );
      // break;

      default:
        return Text('');
      // break;
    }
  }

  _getFileIcon(String fileType) {
    switch (fileType) {
      case 'pdf':
        return AssetImage('images/pdf.png');
      case 'jpg':
        return AssetImage('images/jpg.png');
      case 'txt':
        return AssetImage('images/txt.png');
      case 'xlsx':
        return AssetImage('images/xls.png');
      case 'docx':
        return AssetImage('images/doc.png');
    }
  }

  /// Vertically
  List<Widget> _buildCells(int count, int mainIndex) {
    return List.generate(
      count,
      (index) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Container(
            width: 136,
            height: 48,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    itemMasterList[mainIndex].attributeList![index].name!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: itemMasterList[mainIndex]
                                .attributeList![index]
                                .isHeader
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  /// Horizontally
  List<Widget> _buildRows(int count, int mainIndex) {
    return List.generate(
        count, (index) => _buildHorizontalCells(count, index, mainIndex));
  }

  Container _buildHorizontalCells(int count, int index, int mainIndex) {
    return Container(
      alignment: Alignment.topCenter,
      child: Row(children: [
        ///At1
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 2),
          child: Container(
            height: 48,
            width: 90,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at1!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At2
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 90,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at2!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At3
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 90,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at3!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At4
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 90,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at4!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At5
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 90,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at5!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At6
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at6!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At7
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at7!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At8
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at8!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At9
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at9!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At10
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at10!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At11
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at11!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At12
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at12!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At13
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at13!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At14
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at14!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At15
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at15!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At16
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at16!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At17
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at17!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At18
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at18!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At19
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at19!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At20
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at20!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At21
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at21!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At22
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at22!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At23
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at23!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At24
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at24!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),

        ///At25
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2),
          child: Container(
            height: 48,
            width: 60,
            color: itemMasterList[mainIndex].attributeList![index].isHeader
                ? AppColor.appRed
                : Colors.red[100],
            child: Center(
              child: Text(
                itemMasterList[mainIndex].attributeList![index].at25!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color:
                        itemMasterList[mainIndex].attributeList![index].isHeader
                            ? Colors.white
                            : Colors.black),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  _getItemDetails() {
    String? userId = AppConfig.prefs.getString('user_id');

    var data;
    var type;

    widget.selectedItem.forEach((e) {
      if (data == null) {
        data = '${e.id}';
      } else {
        data = "$data,${e.id}";
      }
    });

    widget.selectedItem.forEach((e) {
      if (type == null) {
        type = '${e.itemType}';
      } else {
        type = "$type,${e.itemType}";
      }
    });

    Commons().showProgressbar(this.context);

    var json = jsonEncode(<String, dynamic>{
      'user_id': userId,
      'item_ids': data.toString(),
      'item_type': type.toString(),

      /// e.g: Item-> 1 Catalog-> 2
      'full_detail': '1' //,2,2
    });

    WebService()
        .post(this.context, AppConfig.getItemDetails, json)
        .then((value) => {Navigator.pop(this.context), _parse(value!)});

    debugPrint('params $json');
  }

  _parse(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        imgBaseUrl = data['image_tiff_path'];

        var contentList = data['content'] as List;
        var contentListCatalog = data['catalog_content'] as List;
        //var blockedCatalog = data['block_catalog'] as List?;
        itemMasterList.clear();

        itemMasterList.addAll(contentListCatalog
            .map((e) => ItemMasterModel.fromJSONCatalog(e))
            .toList());
        itemMasterList.addAll(
            contentList.map((e) => ItemMasterModel.fromJSON(e)).toList());

        setState(() {});
      }
    }
  }

  _blockUnBlock(String? code, String status) {
    Map jsonBody = {
      'user_id': getUserId(),
      'catalog_item_code': code,
      'block_status': status
    };

    web.WebService.fromApi(AppConfig.blockUnBlockCatalog, this, jsonBody)
        .callPostService(this.context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      if (requestCode == AppConfig.blockUnBlockCatalog) {
        var data = jsonDecode(response!);

        if (data['error'] == 'false') {
          showAlert(this.context, data['message'], 'Success', onOk: () {
            setState(() {
              itemMasterList[position].isEnabled =
                  !itemMasterList[position].isEnabled;
            });
          });
        } else {
          showAlert(this.context, data['message'], 'Failed');
        }
      } else if (requestCode == AppConfig.viewCatalogPdf) {
        var data = jsonDecode(response!);

        logIt('viewCatalogPdf-> $data');

        if (data['error'] == 'false') {
          String type = getString(data, 'file_extension');

          if (type == 'PDF') {
            Navigator.of(this.context).push(MaterialPageRoute(
                builder: (context) => ViewPdf(
                      pdfUrl: getString(data, 'pdf_path'),
                    )));
          } else {
            _downloadPdf(getString(data, 'pdf_path'), type);
          }
        }
      }
    } catch (err) {
      logIt('onResponse-> $err');
    }
  }

  _downloadPdf(String url, String ext) async {
    List<int> bytes = [];

    String docCode = basename(url);

    var documentDirectory = await getTemporaryDirectory();
    var firstPath = documentDirectory.path + "/doc";
    var filePathAndName = documentDirectory.path + '/doc/$docCode';
    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);

    Commons().showProgressbar(this.context);
    logIt('File does not exist -> $file2');

    final request = Request('GET', Uri.parse(url));
    final StreamedResponse res = await Client().send(request);

    res.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
      },
      onDone: () async {
        await file2.writeAsBytes(bytes);
        popIt(this.context);

        /*      var res = await OpenFile.open(file2.absolute.path);

        if (res.type != ResultType.done) {
          showAlert(this.context, res.message, 'Error');
        } */
      },
      onError: (e) {
        popIt(this.context);
        showAlert(this.context, 'Error occurred while downloading', 'Error!');
        print(e);
      },
      cancelOnError: true,
    );
  }
}

enum ComingFrom {
  Quotation,
}

enum WidgetType {
  Catalog,
  Material,
  Count,
  Brand,
  Shade,
  MachineCatalog,
}
