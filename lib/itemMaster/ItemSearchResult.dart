import 'package:dataproject2/itemMaster/ViewItemDetail.dart';
import 'package:dataproject2/style/AppColor.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'model/ItemResultModel.dart';

class ItemSearchResult extends StatefulWidget {
  final List<ItemResultModel>? resultList;
  final List<ItemResultModel>? itemList;
  final List<ItemResultModel>? catalogList;
  final List<ItemResultModel>? paraList;
  final List<ItemResultModel>? attrList;
  final String? imgBaseUrl;
  final String? tempCount;
  final ComingFrom? comingFrom;

  const ItemSearchResult(
      {Key? key,
      this.resultList,
      this.imgBaseUrl,
      this.comingFrom,
      this.tempCount,
      this.itemList,
      this.catalogList,
      this.paraList,
      this.attrList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemSearchResult();
}

class _ItemSearchResult extends State<ItemSearchResult> {
  bool isSelectionOn = false;
  bool showParaCatalog = true;
  bool showAttrCatalog = true;
  bool showItem = false;
  bool showCatalogItem = true;
  List<ItemResultModel> selectionList = [];

  late double height;
  double? width;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.catalogList!.isEmpty) {
        showItem = true;
        setState(() {});
      }
    });

    logIt('ComingFrom->${widget.comingFrom}');
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: true,
        leading: isSelectionOn
            ? IconButton(
                onPressed: () {
                  widget.resultList!.forEach((element) {
                    element.isSelected = false;
                  });
                  selectionList.clear();
                  isSelectionOn = false;
                  setState(() {});
                },
                icon: Icon(
                  Icons.close,
                  size: 28,
                ),
              )
            : null,
        title: !isSelectionOn
            ? Text(
                'Total Result(s): ${widget.resultList!.length}',
                //'${widget.resultList.length} Items Found',
                style: TextStyle(fontSize: 18),
              )
            : Text(
                '${selectionList.length} Items Selected',
                style: TextStyle(fontSize: 18),
              ),
        actions: [
          Visibility(
            visible: selectionList.isNotEmpty,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewItemDetail(
                              selectedItem: selectionList,
                              comingFrom: widget.comingFrom,
                            )));
              },
              icon: Icon(
                Icons.done_rounded,
                size: 28,
              ),
            ),
          ),
          SizedBox(
            width: 4,
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Wrap(
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                children: [
                  /// Show Item
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: showItem,
                        onChanged: (val) {
                          setState(() {
                            showItem = !showItem;
                            _filterChecked();
                            /*   if (showItem && showCatalogItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.catalogList);
                              widget.resultList.addAll(widget.itemList);
                            } else if (showItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.itemList);
                            } else if (showCatalogItem && !showItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.catalogList);
                            } else if (!showCatalogItem && !showItem) {
                              widget.resultList.clear();
                            }*/
                          });
                        },
                      ),
                      Text('Item (${widget.itemList!.length})')
                    ],
                  ),

                  /// Show Item Catalog
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: showCatalogItem,
                        onChanged: (val) {
                          setState(() {
                            showCatalogItem = !showCatalogItem;
                            showParaCatalog = showCatalogItem;
                            showAttrCatalog = showCatalogItem;
                            _filterChecked();
                            /* if (showItem && showCatalogItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.catalogList);
                              widget.resultList.addAll(widget.itemList);
                            } else if (showCatalogItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.catalogList);
                            } else if (!showCatalogItem && showItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.itemList);
                            } else if (!showCatalogItem && !showItem) {
                              widget.resultList.clear();
                            }*/
                          });
                        },
                      ),
                      Text('Catalog (${widget.catalogList!.length})')
                    ],
                  ),

                  /// Show Para
                  Visibility(
                    visible: showCatalogItem,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: showParaCatalog,
                          onChanged: (val) {
                            setState(() {
                              showParaCatalog = !showParaCatalog;
                              _filterChecked();
                            });
                          },
                        ),
                        Text('Para (${widget.paraList!.length})')
                      ],
                    ),
                  ),

                  /// Show Attr
                  Visibility(
                    visible: showCatalogItem,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: showAttrCatalog,
                          onChanged: (val) {
                            setState(() {
                              showAttrCatalog = !showAttrCatalog;
                              _filterChecked();
                            });
                          },
                        ),
                        Text('Attr (${widget.attrList!.length})')
                      ],
                    ),
                  ),
                ],
              ),

              /* Row(
                children: [
                  /// Show Item
                  Row(
                    children: [
                      Checkbox(
                        value: showItem,
                        onChanged: (val) {
                          setState(() {
                            showItem = !showItem;
                            _filterChecked();
                               if (showItem && showCatalogItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.catalogList);
                              widget.resultList.addAll(widget.itemList);
                            } else if (showItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.itemList);
                            } else if (showCatalogItem && !showItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.catalogList);
                            } else if (!showCatalogItem && !showItem) {
                              widget.resultList.clear();
                            }
                          });
                        },
                      ),
                      Text(
                          'Item ${showItem ? '(${widget.itemList.length})' : '(0)'}')
                    ],
                  ),

                  /// Show Item Catalog
                  Row(
                    children: [
                      Checkbox(
                        value: showCatalogItem,
                        onChanged: (val) {
                          setState(() {
                            showCatalogItem = !showCatalogItem;
                            showParaCatalog = showCatalogItem;
                            showAttrCatalog = showCatalogItem;
                            _filterChecked();
                             if (showItem && showCatalogItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.catalogList);
                              widget.resultList.addAll(widget.itemList);
                            } else if (showCatalogItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.catalogList);
                            } else if (!showCatalogItem && showItem) {
                              widget.resultList.clear();
                              widget.resultList.addAll(widget.itemList);
                            } else if (!showCatalogItem && !showItem) {
                              widget.resultList.clear();
                            }
                          });
                        },
                      ),
                      Text(
                          'Catalog ${showCatalogItem ? '(${widget.catalogList.length})' : '(0)'} ')
                    ],
                  )
                ],
              ),
              Visibility(
                visible: showCatalogItem,
                child: Row(
                  children: [
                    /// Show Para
                    Row(
                      children: [
                        Checkbox(
                          value: showParaCatalog,
                          onChanged: (val) {
                            setState(() {
                              showParaCatalog = !showParaCatalog;
                              _filterChecked();
                            });
                          },
                        ),
                        Text(
                            'Para ${showParaCatalog ? '(${widget.paraList.length})' : '(0)'}')
                      ],
                    ),

                    /// Show Attr
                    Row(
                      children: [
                        Checkbox(
                          value: showAttrCatalog,
                          onChanged: (val) {
                            setState(() {
                              showAttrCatalog = !showAttrCatalog;
                              _filterChecked();
                            });
                          },
                        ),
                        Text(
                            'Attr ${showAttrCatalog ? '(${widget.attrList.length})' : '(0)'}')
                      ],
                    ),
                  ],
                ),
              ),*/

              Expanded(
                child: GridView.builder(
                  itemCount: widget.resultList!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65.sp,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 0,
                  ),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Stack(
                    children: [
                      /// Main Content
                      GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: widget.resultList![index].itemType == '3'
                                ? AppColor.appBlue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Image
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: widget.resultList![index].itemImage!
                                            .isEmpty
                                        ? Image.asset(
                                            'images/noImage.png',
                                            fit: BoxFit.fill,
                                          )
                                        : FadeInImage.assetNetwork(
                                            fit: BoxFit.fill,
                                            placeholder:
                                                'images/placeholder3.png',
                                            image:
                                                '${widget.imgBaseUrl}${widget.resultList![index].itemImage}.png'),
                                  ),
                                  height: height * 20,
                                  width: double.maxFinite,
                                ),

                                /// All Text
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 6, 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.resultList![index].itemType ==
                                                '1'
                                            ? 'Item Code: ${widget.resultList![index].id}'
                                            : 'Catalog Code: ${widget.resultList![index].id} ',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Visibility(
                                        visible: widget
                                                .resultList![index].itemType ==
                                            '2',
                                        child: Text(
                                          'Item Code: ${widget.resultList![index].itemCode} ',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Text(
                                        'Item Name: ${widget.resultList![index].itemName} ',
                                        softWrap: true,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          if (isSelectionOn) {
                            widget.resultList![index].isSelected =
                                !widget.resultList![index].isSelected!;
                            selectionList.add(widget.resultList![index]);
                            setState(() {});
                          }
                        },
                        onLongPress: () {
                          isSelectionOn = true;
                          widget.resultList![index].isSelected =
                              !widget.resultList![index].isSelected!;
                          selectionList.add(widget.resultList![index]);
                          setState(() {});
                          debugPrint('SelectionEnabled');
                        },
                      ),

                      /// Disabled Mask
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Visibility(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.comingFrom != null) return;
                              if (isSelectionOn) {
                                widget.resultList![index].isSelected =
                                    !widget.resultList![index].isSelected!;
                                selectionList.add(widget.resultList![index]);
                                setState(() {});
                              }
                            },
                            onLongPress: () {
                              if (widget.comingFrom != null) return;
                              isSelectionOn = true;
                              widget.resultList![index].isSelected =
                                  !widget.resultList![index].isSelected!;
                              selectionList.add(widget.resultList![index]);
                              setState(() {});
                              debugPrint('SelectionEnabled');
                            },
                            //
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: AppColor.appBlue[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          visible: !widget.resultList![index].isEnabled,
                        ),
                      ),

                      /// Selected Shade with Tick
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Visibility(
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.appRed[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Icon(
                                    Icons.done_rounded,
                                    color: Colors.white,
                                    size: 68,
                                  )),
                                ],
                              ),
                            ),
                            onTap: () {
                              widget.resultList![index].isSelected =
                                  !widget.resultList![index].isSelected!;
                              selectionList.remove(widget.resultList![index]);
                              setState(() {});
                            },
                          ),
                          visible: widget.resultList![index].isSelected!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _filterChecked() {
    /// Attr and Para and Item is showing
    if (showItem && showAttrCatalog && showParaCatalog) {
      widget.resultList!.clear();
      widget.resultList!.addAll(widget.itemList!);
      widget.resultList!.addAll(widget.attrList!);
      widget.resultList!.addAll(widget.paraList!);
    } else if (!showAttrCatalog && !showParaCatalog && showItem) {
      /// Item only
      widget.resultList!.clear();
      widget.resultList!.addAll(widget.itemList!);
    } else if (showAttrCatalog && !showParaCatalog && !showItem) {
      /// Attr Only
      widget.resultList!.clear();
      widget.resultList!.addAll(widget.attrList!);
    } else if (showAttrCatalog && !showParaCatalog && showItem) {
      /// Attr and Item
      widget.resultList!.clear();
      widget.resultList!.addAll(widget.itemList!);
      widget.resultList!.addAll(widget.attrList!);
    } else if (!showAttrCatalog && showParaCatalog && !showItem) {
      /// Para Only
      widget.resultList!.clear();
      widget.resultList!.addAll(widget.paraList!);
    } else if (showAttrCatalog && showParaCatalog) {
      /// Attr and Para Enabled
      widget.resultList!.clear();
      widget.resultList!.addAll(widget.attrList!);
      widget.resultList!.addAll(widget.paraList!);
    } else if (!showAttrCatalog && showParaCatalog && showItem) {
      /// Para and Item
      widget.resultList!.clear();
      widget.resultList!.addAll(widget.itemList!);
      widget.resultList!.addAll(widget.paraList!);
    } else if (!showAttrCatalog && !showItem && !showParaCatalog) {
      widget.resultList!.clear();
    }
  }
}
