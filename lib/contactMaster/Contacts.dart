import 'dart:convert';

import 'package:dataproject2/contactMaster/AddContact.dart';
import 'package:dataproject2/datamodel/ContactModel.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Contacts extends StatefulWidget {
  final String? accCode;
  final String? companyName;

  const Contacts({Key? key, required this.accCode, this.companyName})
      : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> with NetworkResponse {
  List<ContactModel> _contactList = [];

  double? screenWidth;
  int _current = 0;
  String? imgBaseUrl;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        AddContact(type: 'Add', accCode: widget.accCode)));

                _getContacts();
              }),
          Visibility(
            visible: _contactList.isNotEmpty,
            child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddContact(
                          type: 'Edit',
                          accCode: widget.accCode,
                          model: _contactList[_current],
                          imageBaseUrl: imgBaseUrl)));
                  _getContacts();
                }),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _contactList.isEmpty
            ? Center(child: Text('No Data Found'))
            : Column(
                children: [
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Details For:',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.companyName!,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  /// Carousel Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _contactList.map((item) {
                      int mIndex = _contactList.indexOf(item);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == mIndex
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 12),
                  Expanded(
                    child: PageView.builder(
                        itemCount: _contactList.length,
                        onPageChanged: (v) {
                          setState(() {
                            _current = v;
                          });
                        },
                        itemBuilder: (context, index) => SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Item Images
                                    SizedBox(
                                      height: screenWidth! / 1.5,
                                      child: Container(
                                        width: screenWidth,
                                        height: screenWidth! / 1.5,
                                        child: _contactList[index]
                                                .imageList!
                                                .isNotEmpty
                                            ? PhotoViewGallery.builder(
                                                backgroundDecoration:
                                                    BoxDecoration(
                                                        color: Colors.white),
                                                scrollPhysics:
                                                    const BouncingScrollPhysics(),
                                                builder: (BuildContext context,
                                                    int imgIndex) {
                                                  _contactList[index].imagePos =
                                                      imgIndex;
                                                  return PhotoViewGalleryPageOptions(
                                                    imageProvider: NetworkImage(
                                                        '$imgBaseUrl${_contactList[index].imageList![imgIndex]}.png'),
                                                    initialScale:
                                                        PhotoViewComputedScale
                                                                .contained *
                                                            0.8,
                                                  );
                                                },
                                                onPageChanged: (value) {
                                                  setState(() {
                                                    _contactList[index]
                                                        .imagePos = value;
                                                  });
                                                },
                                                itemCount: _contactList[index]
                                                    .imageList!
                                                    .length,
                                                loadingBuilder:
                                                    (context, event) => Center(
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: event == null
                                                          ? 0
                                                          : event.cumulativeBytesLoaded /
                                                              event
                                                                  .expectedTotalBytes!,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                color: Colors.white,
                                                child: Center(
                                                  child: Image.asset(
                                                      'images/noImage.png'),
                                                ),
                                              ),
                                        //child: Image.network('$imgBaseUrl${itemMasterList[index].imageList[imgIndex]}.png'),
                                      ),
                                    ),

                                    /// Carousel Indicator
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                          _contactList[index].imageList!.length,
                                          (index) {
                                        return Container(
                                          width: 8.0,
                                          height: 8.0,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 2.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _contactList[_current]
                                                        .imagePos ==
                                                    index
                                                ? Color.fromRGBO(0, 0, 0, 0.9)
                                                : Color.fromRGBO(0, 0, 0, 0.4),
                                          ),
                                        );
                                      }),
                                    ),

                                    /// Title
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].title),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Title',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Name
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].name),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Name',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Address
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].address),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Address',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Address 2
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].address2),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Address 2',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// City
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].city),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'City',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// State
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].state),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'State',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Country
                                    TextFormField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: _contactList[index].country),
                                      decoration: InputDecoration(
                                          labelText: 'Country',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Pin Code
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].pinCode),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Pin Code',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Mobile
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].mobile),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Mobile',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Mobile 2
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].mobile2),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Mobile 2',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Phone
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].phone),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Phone',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Fax
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].fax),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Fax',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Email
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].email),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Email',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Email 2
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].email2),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Email 2',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Email 3
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].email3),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Email 3',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    /// Website
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: _contactList[index].website),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          labelText: 'Website',
                                          labelStyle: TextStyle(fontSize: 18),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          border: OutlineInputBorder(),
                                          isDense: true),
                                    ),
                                    SizedBox(height: 12),

                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      direction: Axis.horizontal,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                                value: _contactList[index]
                                                    .isActive,
                                                onChanged: (v) {
                                                  /*  setState(() {
                                              _contactList[index].isActive =
                                                  !_contactList[index]
                                                      .isActive;
                                            });*/
                                                }),
                                            Text(
                                              'Active',
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                                value: _contactList[index]
                                                    .sendMailAuto,
                                                onChanged: (v) {
                                                  /*setState(() {
                                              _contactList[index]
                                                      .sendMailAuto =
                                                  !_contactList[index]
                                                      .sendMailAuto;
                                            });*/
                                                }),
                                            Text(
                                              'Send Mail Automatically',
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                                value: _contactList[index]
                                                    .sendLedger,
                                                onChanged: (v) {
                                                  /* setState(() {
                                              _contactList[index].sendLedger =
                                                  !_contactList[index]
                                                      .sendLedger;
                                            });*/
                                                }),
                                            Text(
                                              'Send Ledger To Party',
                                              style: TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )),
                  ),
                ],
              ),
      ),
    );
  }

  _getContacts() {
    Map jsonBody = {'user_id': getUserId(), 'acc_code': widget.accCode};

    WebService.fromApi(AppConfig.contactList, this, jsonBody)
        .callPostService(context);
  }

  @override
  void onResponse({Key? key, String? requestCode, String? response}) {
    try {
      switch (requestCode) {
        case AppConfig.contactList:
          {
            var data = jsonDecode(response!);

            var contentList = data['content'] as List;

            _contactList.clear();
            _contactList.addAll(
                contentList.map((e) => ContactModel.fromJSON(e)).toList());

            imgBaseUrl = data['image_png_path'];

            setState(() {});
          }
      }
    } catch (err) {
      logIt('onResponse-> $err');
    }
  }
}
