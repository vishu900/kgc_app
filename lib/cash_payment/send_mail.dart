import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/network/NetworkResponse.dart';
import 'package:dataproject2/network/WebService.dart';
import 'package:dataproject2/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SendMAil extends StatefulWidget {
  final String? codePk;

  const SendMAil({
    Key? key,
    this.codePk,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SendMAil();
}

class _SendMAil extends State<SendMAil> with NetworkResponse {
  TextEditingController _tocontroller = TextEditingController();
  TextEditingController _subjectcontroller = TextEditingController();
  TextEditingController _messagecontroller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<MailModel> emailList = [];
  String? email;
  RegExp emailValidator = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getMail();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Send Mail')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              /// To
              Row(children: [
                Flexible(
                    child: TypeAheadFormField<MailModel>(
                  validator: (value) => value!.isEmpty
                      ? 'Enter sender\'s email'
                      : (!emailValidator.hasMatch(value)
                          ? 'Enter valid email'
                          : null),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  itemBuilder: (BuildContext context, _tocontroller) {
                    return ListTile(title: Text(_tocontroller.email!));
                  },
                  suggestionsCallback: (String pattern) {
                    return [];
                  },
                  onSuggestionSelected: (sg) {
                    setState(() {
                      _tocontroller.text = sg.email!;
                      _tocontroller.text = sg.id!;
                    });
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _tocontroller,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                          labelText: 'To',
                          hintText: ' To',
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          isDense: true)),
                )),
              ]),

              /// Subject
              TextFormField(
                controller: _subjectcontroller,
                validator: (value) => value!.isEmpty ? 'Enter subject' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  hintText: 'Subject',
                ),
              ),

              /// Message
              TextFormField(
                controller: _messagecontroller,
                validator: (value) => value!.isEmpty ? 'Enter message' : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 5,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Message',
                ),
              ),
              SizedBox(
                height: 8,
              ),

              /// Button
              FloatingActionButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendmail();
                  }
                },
                child: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getMail() {
    Map jsonBody = {
      'user_id': getUserId(),
      'code_pk': widget.codePk,
    };
    WebService.fromApi(AppConfig.getMail, this, jsonBody)
        .callPostService(context);
  }

  _sendmail() {
    Map jsonBody = {
      'user_id': getUserId(),
      'code_pk': widget.codePk,
      'to': _tocontroller.text,
      'subject': _subjectcontroller.text,
      'message': _messagecontroller.text,
    };
    WebService.fromApi(AppConfig.sendCashMail, this, jsonBody)
        .callPostService(context);
  }

  void onResponse({Key? key, String? requestCode, String? response}) {
    switch (requestCode) {
      case AppConfig.getMail:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            var emailcontent = data['parties_lists'] as List;
            emailList.addAll(
                emailcontent.map((e) => MailModel.fromJSON(e)).toList());
            _subjectcontroller.text = getString(data, 'subject');
            _messagecontroller.text = getString(data, 'message');
          }
        }
        break;
      case AppConfig.sendCashMail:
        {
          var data = jsonDecode(response!);
          if (data['error'] == 'false') {
            showAlert(context, data['message'], 'Success', onOk: () {
              _sendmail();
            });
          } else {
            showAlert(context, data['message'], 'Failed');
          }
        }
        break;
    }
  }
}

class MailModel {
  final String? id;
  final String? accCode;
  final String? email;
  final String? name;
  final bool? isactive;

  MailModel({this.id, this.accCode, this.email, this.name, this.isactive});

  factory MailModel.fromJSON(Map<String, dynamic> data) {
    return MailModel(
      id: getString(data, 'code'),
      accCode: getString(data, 'acc_code'),
      email: getString(data, 'email_id'),
      name: getString(data, 'name'),
      isactive: getString(data, 'active_tag') == 'Y',
    );
  }
}
