import 'package:dataproject2/attendance/model/SmsModel.dart';
import 'package:flutter/material.dart';

class ViewSms extends StatefulWidget {
  final List<SmsModel> smsList;

  ViewSms(this.smsList);

  @override
  _ViewSmsState createState() => _ViewSmsState();
}

class _ViewSmsState extends State<ViewSms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Sms'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: widget.smsList.length,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) => Container(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Table(
                      children: [
                        /// Message id
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('Message id',
                                style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(widget.smsList[index].id!,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ]),

                        /// Sent to
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child:
                                Text('Sent To', style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(widget.smsList[index].sentTo!,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ]),

                        /// Message
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child:
                                Text('Message', style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(widget.smsList[index].message!,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ]),

                        /// Employee Code
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('Employee Code',
                                style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(widget.smsList[index].empCode!,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ]),

                        /// Employee Name
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('Employee Name',
                                style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(widget.smsList[index].name!,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ]),

                        /// In Time
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('Sent Date',
                                style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(widget.smsList[index].date!,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ]),

                        /// Sent Status
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('Sent Status',
                                style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(widget.smsList[index].sentStatus!,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
