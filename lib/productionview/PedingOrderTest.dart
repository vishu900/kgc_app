import 'dart:convert';
import 'dart:math';

import 'package:dataproject2/productionmodel/PendingOrder.dart';
import 'package:dataproject2/productionmodel/PkCode.dart';
import 'package:dataproject2/productionservice/api.dart';
import 'package:dataproject2/productionview/Images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

String RandomString(int strlen) {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result;
}

// ignore: must_be_immutable
class PendingOrderTest extends StatefulWidget {
  List<PendingOrder>? allSelected = [];
  PendingOrderTest(this.allSelected);

  @override
  _PendingOrderTestState createState() => _PendingOrderTestState();
}

class _PendingOrderTestState extends State<PendingOrderTest> {
  Future<List<PendingOrder>>? productsFuture;
  ProductRepository? productRepo;

  @override
  initState() {
    super.initState();
    productRepo = new ProductRepository();
    productsFuture = productRepo!.fetchAll(widget.allSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(
              "Pending Orders",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFFD63333),
            automaticallyImplyLeading: true,
            elevation: 0,
            centerTitle: false,
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 28,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: MySearchDelegate(
                            productRepo: this.productRepo!,
                            isSelected: (bool value) {
                              setState(() {});
                            },
                            allSelected: widget.allSelected));
                  }),
            ]),
        body: MyFutureBuilder<List<PendingOrder>>(
            future: productsFuture,
            successWidget: (List<PendingOrder> products) {
              return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    PendingOrder p = products[index];
                    return MyItem(
                        pendingOrder: p,
                        isSelected: (bool value) {
                          setState(() {
                            if (value) {
                              widget.allSelected!.add(p);
                            } else {
                              widget.allSelected!.remove(p);
                            }
                          });
                          print("caindex $index : $value");
                        },
                        key: Key(p.itemCode.toString()));
                  });
            }));
  }
}

class MySearchDelegate extends SearchDelegate {
  ProductRepository? productRepo;
  final ValueChanged<bool>? isSelected;
  List<PendingOrder>? allSelected = [];

  MySearchDelegate({this.productRepo, this.isSelected, this.allSelected});

  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            this.query = "";
          }),
    ];
  }

  Widget buildResults(BuildContext context) {
    if (query == '') return Container();
    return MyFutureBuilder<List<PendingOrder>>(
        future: this.productRepo!.searchProducts(this.query),
        successWidget: (List<PendingOrder> products) {
          return ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                PendingOrder p = products[index];
                return MyItem(
                    pendingOrder: p,
                    isSelected: (bool value) {
                      if (value) {
                        allSelected!.add(p);
                      } else {
                        allSelected!.remove(p);
                      }
                      this.isSelected!(true);
                      print("caindex $index : $value");
                    },
                    key: Key(p.prodOrderDtlPk.toString()));
              });
        });
  }

  buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          this.isSelected!(true);
          this.close(context, null);
        });
  }

  buildSuggestions(BuildContext context) {
    if (query == '') return Container();
    return MyFutureBuilder<List<PendingOrder>>(
        future: this.productRepo!.searchProducts(this.query),
        successWidget: (List<PendingOrder> products) {
          return ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                PendingOrder p = products[index];
                return MyItem(
                    pendingOrder: p,
                    isSelected: (bool value) {
                      if (value) {
                        allSelected!.add(p);
                      } else {
                        allSelected!.remove(p);
                      }
                      this.isSelected!(true);
                      print("caindex $index : $value");
                    },
                    key: Key(p.itemCode.toString()));
              });
        });
  }
}

buildMatch(String query, String found, BuildContext context) {
  var tabs = found.toLowerCase().split(query.toLowerCase());
  List<TextSpan> list = [];
  for (var i = 0; i < tabs.length; i++) {
    if (i % 2 == 1) {
      list.add(TextSpan(
          text: query,
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w600, fontSize: 15)));
    }
    list.add(TextSpan(text: tabs[i]));
  }
  return RichText(
    text: TextSpan(style: TextStyle(color: Colors.black), children: list),
  );
}

//Common widget

// ignore: must_be_immutable
class MyFutureBuilder<T> extends StatelessWidget {
  Future<T>? future;
  Widget Function(dynamic error)? errorWidget;
  Widget Function(T data)? successWidget;

  MyFutureBuilder({
    this.future,
    this.errorWidget,
    this.successWidget,
  });

  @override
  build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshotData) {
          switch (snapshotData.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                  heightFactor: 10,
                  child: CupertinoActivityIndicator(
                    animating: true,
                    color: Colors.grey,
                    radius: 20,
                  ));

            case ConnectionState.none:
              return Center(child: Text('Check Your Internet Connection'));
            //   break;
            case ConnectionState.done:
              if (snapshotData.hasError) {
                return this.errorWidget != null
                    ? this.errorWidget!(snapshotData.error)
                    : Center(child: Text('${snapshotData.error}'));
              } else {
                return this.successWidget!(snapshotData.data);
              }
            // break;
            default:
              return Container();
          }
        });
  }
}

// Repository file

class ProductRepository {
  List<PendingOrder> ebooksList = [];

  Future<List<PendingOrder>> fetchAll(List<PendingOrder>? allSelected) {
    return getPendingOrders(allSelected);
  }

  Future<List<PendingOrder>> getPendingOrders(
      List<PendingOrder>? allSelected) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final String baseUrl =
        'http://103.204.185.17:24977/webapi/api/PendingOrder/GetPendingOrders?comp_code=${pref.getString("company")}&acc_code=${pref.getString("acc")}';

    try {
      var response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        ebooksList = List.from(data)
            .map<PendingOrder>((e) => PendingOrder.fromJson(e))
            .toList();

        for (var po in ebooksList) {
          if (allSelected!.contains(po)) {
            po.is_selected = true;
          }
        }
      }
      return ebooksList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PendingOrder>> searchProducts(String query) {
    return Future.delayed(Duration(seconds: 1), () {
      return ebooksList.where((p) {
        return (p.catalogItem
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            p.orderNo.toString().toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }
}

// ignore: must_be_immutable
class MyItem extends StatefulWidget {
  final ValueChanged<bool>? isSelected;
  final Key? key;
  PendingOrder? pendingOrder;
  MyItem({this.pendingOrder, this.isSelected, this.key});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<MyItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Stack(children: <Widget>[
      SafeArea(
        child: GestureDetector(
          onTap: () => {_getPendingPK()},
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 7,
                    color: Color(0x2F1D2429),
                    offset: Offset(0, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(
                              widget.pendingOrder!.catalogItemName!,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            "Order No.",
                            style: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Catalog Item",
                            style: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Process",
                            style: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              widget.pendingOrder!.orderNo!.toString(),
                              style: TextStyle(
                                fontFamily: 'Roboto Mono',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.pendingOrder!.catalogItem!.toString(),
                              style: TextStyle(
                                fontFamily: 'Roboto Mono',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.pendingOrder!.processName!,
                              style: TextStyle(
                                fontFamily: 'Roboto Mono',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                "Qty",
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF57636C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Tot Prod",
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF57636C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Bal qty",
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF57636C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              widget.pendingOrder!.qty!.toString(),
                              style: TextStyle(
                                fontFamily: 'Roboto Mono',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.pendingOrder!.totProd!.toString(),
                              style: TextStyle(
                                fontFamily: 'Roboto Mono',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.pendingOrder!.balQty!.toString(),
                              style: TextStyle(
                                fontFamily: 'Roboto Mono',
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextButton(
                              onPressed: () {
                                _showImages(widget.pendingOrder!.catalogItem!);
                              },
                              child: Text(
                                "Show Images",
                                style: TextStyle(
                                  fontFamily: 'Roboto Mono',
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      widget.pendingOrder!.is_selected
          ? Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                ),
              ),
            )
          : Container()
    ]));
  }

  _getPendingPK() async {
    print("hiiii data");
    if (widget.pendingOrder!.pk_code == 0) {
      List<PkCode> response = await UserRepository().getPkCodes(false);
      widget.pendingOrder!.pk_code = response[0].code;
    }
    setState(() {
      widget.pendingOrder!.is_selected = !widget.pendingOrder!.is_selected;
      widget.isSelected!(widget.pendingOrder!.is_selected);
    });
  }

  void _showImages(int i) async {
    print("value of ordernum" + i.toString());
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Images(i)),
    );
  }
}
