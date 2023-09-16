import 'package:dataproject2/bomscreen/bom_items_screen.dart';
import 'package:dataproject2/bomscreen/sale_bom_order_model.dart';
import 'package:flutter/material.dart';

class ProcessItemsScreen extends StatefulWidget {
  final datareceived, iconlink;

  const ProcessItemsScreen({Key? key, this.datareceived, this.iconlink})
      : super(key: key);

  @override
  _ProcessItemsScreenState createState() => _ProcessItemsScreenState();
}

class _ProcessItemsScreenState extends State<ProcessItemsScreen> {
  List? listprocessItems;
  int? total;

  SaleOrderBomItemModel? model;

  void initState() {
    model = widget.datareceived;
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //List list2 =[]; //widget.datareceived;

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
              'VIEW PROCESS ',
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
              child: Text('No Process Items'),
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
                              'Catalog Item',
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
                            padding: const EdgeInsets.only(left: 20, top: 8),
                            child: Text(model!.catalogName!,
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
                              model!.catalogItemName!.trim(),
                              textAlign: TextAlign.start,
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
                    itemCount: model!.processList!.length,
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
                                        model!.processList!.length.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),

                              /// Process Code
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment:CrossAxisAlignment.center,
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
                                        "Process Code",
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
                                          left: 20, right: 5, top: 8),
                                      child: Text(
                                        model!.processList![index].processCode,
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

                              /// Process
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
                                        'Process',
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
                                        model!.processList![index].process,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
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

                              /// Process Type
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
                                        'Process Type',
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
                                      child: model!.processList![index]
                                                  .processType ==
                                              "O"
                                          ? Text(
                                              "ORDER",
                                              style: TextStyle(
                                                backgroundColor: Colors.white,
                                                color: Color(0xFF2e2a2a),
                                                fontFamily: 'Roboto',
                                                fontSize: 12,
                                              ),
                                            )
                                          : Text(
                                              "PROCESS",
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

                              /// Visible Waste
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
                                        'Visible Waste',
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
                                        model!.processList![index].visibleWaste,
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

                              /// InVisible Waste
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
                                        'Invisible Waste ',
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
                                        model!
                                            .processList![index].invisibleWaste,
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

                              /// Auto Tag
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
                                        'Auto Tag',
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
                                        model!.processList![index].autoTag,
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

                              /// Party Name
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
                                        'Party Name',
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
                                        model!.processList![index].partyName ==
                                                'NULL'
                                            ? 'N/A'
                                            : model!
                                                .processList![index].partyName,
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

                              /// Contact Person
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
                                        'Contact Person',
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
                                        model!.processList![index]
                                                    .contactPerson ==
                                                'NULL'
                                            ? 'N/A'
                                            : model!.processList![index]
                                                .contactPerson,
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

                              SizedBox(
                                height: 20,
                              ),

                              GestureDetector(
                                onTap: () {
                                  ProcessModel processModel =
                                      model!.processList![index];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BomItemsScreen(
                                                bomdatareceived: processModel,
                                                processCode:
                                                    processModel.processCode,
                                                iconlink: widget.iconlink,
                                                processName:
                                                    processModel.process,
                                                sod_pk: processModel.id,
                                                catalog_item:
                                                    processModel.catalogItem,
                                                catalogITem1:
                                                    processModel.catalogItem,
                                                catalog_name:
                                                    processModel.catalogName,
                                              )));
                                },
                                child: Container(
                                    width: 360,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF0000),
                                      border: Border.all(
                                        color: Color(0xFFFF0000),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                        child: Text("VIEW BOM",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                                fontSize: 20,
                                                letterSpacing: 2.17)))),
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

  String? getNonNullValue(data, String param) {
    String? val = 'N.A';
    if (data[param] != null) {
      if (data[param] != 'NULL') {
        val = data[param];
      }
    }
    return val;
  }
}
