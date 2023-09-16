import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class StockDetails extends StatefulWidget {
  var code;
  var catItem;
   StockDetails({super.key,required this.code, required this.catItem});

  @override
  State<StockDetails> createState() => _StockDetailsState();
}

class _StockDetailsState extends State<StockDetails> {





  List<Map<String, dynamic>> _stockDetails = [];


   @override
  void initState() {
    super.initState();
    getStockDetails();
  }

  Future<void> getStockDetails() async {
    final url = Uri.parse(
        "http://103.204.185.17:24978/webapi/api/Common/StockOpeningDetail?&CompCode=" +
         widget.code +
         "&CatItem=" + widget.catItem.toString()

        );
    final response = await http.get(url);
    final jsonResponseList = json.decode(response.body);
    setState(
      () {
        _stockDetails = List.castFrom(jsonResponseList);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                
              },
              child: Icon(Icons.arrow_back_ios)),
        title: const Text(
                "STOCK DETAILS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
        
      ),
      body: Column(
        children: [
           Expanded(
                
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount:_stockDetails.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(
                        left: 18, right: 18, bottom: 25, top: 10),
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
                                    "Company ",
                                    style: TextStyle(
                                      
                                      fontSize: 16,
                                    ),
                                  ),
                                   const SizedBox(height: 5.0),
                             Text(
                                    _stockDetails[index]["COMP_NAME"].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                 
                                  
                                  const SizedBox(height: 5.0),
                                  
                                  const Text(
                                    "Godown ",
                                    style: TextStyle(
                                      
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                   Text(
                                     _stockDetails[index]["GODOWN_NAME"].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),

 const SizedBox(height: 5.0),
                                  
                                  const Text(
                                    "Catalog Item Name",
                                    style: TextStyle(
                                      
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                   Text(
                                     _stockDetails[index]["CATALOG_NAME"].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                 

                                   const SizedBox(height: 5.0),
                                  
                                  const Text(
                                    "Catalog Item ",
                                    style: TextStyle(
                                      
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                   Text(
                                     _stockDetails[index]["CATALOG_ITEM"].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),

                                
                      
                                  
                                  const SizedBox(height: 5.0),
                            
                            Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Text("Lot No"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Roll No"),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("Stock Qty"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children:  [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                     _stockDetails[index]["LOT_NO"].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                     _stockDetails[index]["ROLL_NO"].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                     _stockDetails[index]["STOCK_QTY"].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            
                            SizedBox(
                              
                              height: 20.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:  [
                                   Text(
                                    '${index + 1}/${_stockDetails.length}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
      
      
      
      
      
      
         
        ],
      ),
    );
  }
}