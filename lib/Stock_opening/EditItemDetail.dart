//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditItemDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditItemDetail();
}

class _EditItemDetail extends State<EditItemDetail> {
  int? _currentPosition;
  List<String> itemList = [];
  PageController pageController = PageController(initialPage: 0);

  var diff = SizedBox(
    height: 12,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF0000),
          automaticallyImplyLeading: true,
          title: Text(
            _currentPosition == null
                ? 'Edit Item Detail'
                : 'Edit Item Detail  $_currentPosition/${itemList.length}',
            style: TextStyle(fontSize: 18),
          ),
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
              Text('Machine  Catalog'),
            ],
          ),
        ),
        body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
          Center(
            child: Text('Tab 1'),
          ),
          Center(
            child: Text('Tab 2'),
          ),
          Center(
            child: Text('Tab 3'),
          ),
          Center(
            child: Text('Tab 4'),
          ),
          Center(
            child: Text('Tab 5'),
          ),
          Center(
            child: Text('Tab 6'),
          ),
        ]),
      ),
    );
  }
}

/*
Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Form(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      /// Item
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Item',
                                                border: OutlineInputBorder())),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),

                                      /// Catalog
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Catalog',
                                                border: OutlineInputBorder())),
                                      )
                                    ],
                                  ),

                                  diff,
                                  TextFormField(
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Party Item Name',
                                          border: OutlineInputBorder())),

                                  diff,
                                  Row(
                                    children: [
                                      /// Count
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Count',
                                                border: OutlineInputBorder())),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),

                                      /// Material
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Material',
                                                border: OutlineInputBorder())),
                                      )
                                    ],
                                  ),

                                  /// Quantity && Uom
                                  diff,
                                  Row(
                                    children: [
                                      /// Quantity
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Quantity',
                                                border: OutlineInputBorder())),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),

                                      /// Uom
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Uom',
                                                border: OutlineInputBorder())),
                                      )
                                    ],
                                  ),

                                  /// Rate $ Uom
                                  diff,
                                  Row(
                                    children: [
                                      /// Rate
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Rate',
                                                border: OutlineInputBorder())),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),

                                      /// Uom
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Uom',
                                                border: OutlineInputBorder())),
                                      )
                                    ],
                                  ),

                                  /// Clb Quantity $ Uom
                                  diff,
                                  Row(
                                    children: [
                                      /// Clb Quantity
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Clb Quantity',
                                                border: OutlineInputBorder())),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),

                                      /// Uom
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Uom',
                                                border: OutlineInputBorder())),
                                      )
                                    ],
                                  ),

                                  /// Clb Rate $ Uom
                                  diff,
                                  Row(
                                    children: [
                                      /// Clb Rate
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Clb Rate',
                                                border: OutlineInputBorder())),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),

                                      /// Uom
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Uom',
                                                border: OutlineInputBorder())),
                                      )
                                    ],
                                  ),
                                  diff,

                                  /// Status
                                  TextFormField(
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Status',
                                          border: OutlineInputBorder())),

                                  diff,

                                  /// Catalog Item Code
                                  TextFormField(
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Catalog Item Code',
                                          border: OutlineInputBorder())),

                                  /// Unnamed & Unnamed
                                  diff,
                                  Row(
                                    children: [
                                      /// Unnamed
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Unnamed',
                                                border: OutlineInputBorder())),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),

                                      /// Unnamed
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Unnamed',
                                                border: OutlineInputBorder())),
                                      )
                                    ],
                                  ),

                                  /// Include Tax & Tax
                                  diff,
                                  Row(
                                    children: [
                                      /// Include
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Include',
                                                border: OutlineInputBorder())),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),

                                      /// Tax
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Tax',
                                                border: OutlineInputBorder())),
                                      )
                                    ],
                                  ),

                                  diff,

                                  /// Basic Rate
                                  TextFormField(
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Basic Rate',
                                          border: OutlineInputBorder())),

                                  diff,

                                  /// Brand
                                  TextFormField(
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Brand',
                                          border: OutlineInputBorder())),

                                  diff,

                                  /// Shade
                                  TextFormField(
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Shade',
                                          border: OutlineInputBorder())),

                                  diff,

                                  /// Remarks
                                  TextFormField(
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Remarks',
                                          border: OutlineInputBorder())),

                                  SizedBox(
                                    height: 24,
                                  ),

                                  /// Item Parameter
                                  TextFormField(
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Item Parameter',
                                          border: OutlineInputBorder())),

                                  /// Value & Uom
                                  diff,
                                  Row(
                                    children: [
                                      /// Value
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Value',
                                                border: OutlineInputBorder())),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),

                                      /// Uom
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Uom',
                                                border: OutlineInputBorder())),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 12),
                                    child: Container(
                                      height: 0.8,
                                      width: double.infinity,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  /// Item Parameter
                                  TextFormField(
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Item Parameter',
                                          border: OutlineInputBorder())),

                                  /// Value & Uom
                                  diff,
                                  Row(
                                    children: [
                                      /// Value
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Value',
                                                border: OutlineInputBorder())),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),

                                      /// Uom
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Uom',
                                                border: OutlineInputBorder())),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 12),
                                    child: Container(
                                      height: 0.8,
                                      width: double.infinity,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  /// Item Parameter
                                  TextFormField(
                                      cursorColor: Colors.black,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: 'Item Parameter',
                                          border: OutlineInputBorder())),

                                  /// Value & Uom
                                  diff,
                                  Row(
                                    children: [
                                      /// Value
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Value',
                                                border: OutlineInputBorder())),
                                      ),

                                      SizedBox(
                                        width: 12,
                                      ),

                                      /// Uom
                                      Flexible(
                                        child: TextFormField(
                                            cursorColor: Colors.black,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Uom',
                                                border: OutlineInputBorder())),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                      );
                    },
                    itemCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (position) {
                      setState(() {
                        _currentPosition = position + 1;
                        debugPrint('onChanged $_currentPosition');
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () async {
                          await _pageController.previousPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          );
                        }),
                    IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () async {
                          await _pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          );
                        }),
                  ],
                ),
              ],
            ),
          ],
        )

 */
