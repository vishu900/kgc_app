import 'package:dataproject2/bomscreen/sale_bom_order_model.dart';
import 'package:flutter/material.dart';

class BomItemsScreen extends StatefulWidget {
  final bomdatareceived,
      processCode,
      processName,
      sod_pk,
      catalog_item,
      catalogITem1,
      catalog_name,
      iconlink;

  const BomItemsScreen(
      {Key? key,
      this.bomdatareceived,
      this.processCode,
      this.processName,
      this.sod_pk,
      this.catalog_item,
      this.catalogITem1,
      this.catalog_name,
      this.iconlink})
      : super(key: key);

  @override
  _BomItemsScreenState createState() => _BomItemsScreenState();
}

class _BomItemsScreenState extends State<BomItemsScreen> {
  int? total;
  ProcessModel? processModel;
  List<BomItemModel> _bomList = [];

  void initState() {
    processModel = widget.bomdatareceived;
    super.initState();
    processModel!.bomItemList!.forEach((element) {
      if (processModel!.sodPk == element.sodPk &&
          processModel!.sohFk == element.sohFk &&
          processModel!.processCode == element.processCode
      ) {
        _bomList.add(element);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.iconlink,
                width: 40.0,
                height: 40.0,
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'VIEW BOM',
              style: TextStyle(
                letterSpacing: 2.17,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                fontSize: 20,
              ),
            ),
          ],
        )),
        backgroundColor: Color(0xFFFF0000),
      ),
      body: total == 0
          ? Center(
              child: Text('No BOM Items'),
            )
          : Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //order container
                        Container(
                          height: 32,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Catalog Item Name',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 32,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 8, right: 5),
                            child: Text(widget.catalogITem1,
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  color: Color(0xFF2e2a2a),
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 96,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10),
                            child: Text(
                              'Catalog Name',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 96,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 10, right: 5),
                            child: Text(
                              widget.catalog_name.toString().trim(),
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 32,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Process Code',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 32,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 8,
                            ),
                            child: Text(
                              widget.processCode,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 32,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(
                              'Process Name',
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 32,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Color(0xFF766F6F),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 8,
                            ),
                            child: Text(
                              widget.processName,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                color: Color(0xFF2e2a2a),
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 16,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: _bomList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 360,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF0000),
                                  border: Border.all(
                                    color: Color(0xFFFF0000),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    'ITEM DETAILS - ' +
                                        (index + 1).toString() +
                                        "/" +
                                        '${_bomList.length}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 32,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8, right: 4),
                                      child: Text(
                                        "Item Code",
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Color(0xFF2e2a2a),
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 32,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8, right: 5),
                                      child: Text(
                                        _bomList[index].id!,
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Color(0xFF2e2a2a),
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 96,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 10),
                                      child: Text(
                                        'Item Description',
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Color(0xFF2e2a2a),
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 96,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 10, right: 5),
                                      child: Text(
                                        _bomList[index].itemDescription!,
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Color(0xFF2e2a2a),
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 32,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: Text(
                                        'Qty',
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Color(0xFF2e2a2a),
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 32,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: Text(
                                        _bomList[index].qty!,
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Color(0xFF2e2a2a),
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 32,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: Text(
                                        'Uom',
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Color(0xFF2e2a2a),
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 32,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: Text(
                                        _bomList[index].uom!,
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Color(0xFF2e2a2a),
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 32,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: Text(
                                        'Stock Tag ',
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Color(0xFF2e2a2a),
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 32,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF766F6F),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8),
                                      child: Text(
                                        _bomList[index].stockTag!,
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Color(0xFF2e2a2a),
                                          fontFamily: 'Roboto',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
