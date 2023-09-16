import 'package:dataproject2/productionmodel/Companies.dart';
import 'package:dataproject2/productionservice/api.dart';
import 'package:dataproject2/productionview/ProductionFormScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompaniesScreen extends StatefulWidget {
  const CompaniesScreen({Key? key, required userID}) : super(key: key);

  @override
  State<CompaniesScreen> createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD63333),
        automaticallyImplyLeading: true,
        actions: [],
        centerTitle: false,
        title: Text(
          "Companies",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 4,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FutureBuilder<List<Companies>>(
                      future: UserRepository().getCompanies(),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 180,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 16),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snap.data!.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, i) {
                                    Companies company = snap.data![i];
                                    return GestureDetector(
                                        onTap: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          prefs.setString("company",
                                              company.code.toString());
                                          prefs.setString("acc", "518");
                                           prefs.setString("companyname", snap.data![i].name.toString());
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductionFormScreen(partname: snap.data![i].name.toString(),)));
                                          /* final nav = Navigator.of(context);
                                          nav.pushNamed('productionform'); */
                                        },
                                        child: Card(
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(16, 16,
                                                                  0, 16),
                                                      child: Text(
                                                        company.name!,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ))
                                                ],
                                              )),
                                        ));
                                  },
                                ),
                              ));
                        } else {
                          return const Center(
                              heightFactor: 10,
                              child: CupertinoActivityIndicator(
                                animating: true,
                                color: Colors.grey,
                                radius: 20,
                              ));
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
