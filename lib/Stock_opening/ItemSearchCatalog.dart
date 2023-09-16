import 'dart:convert';

import 'package:dataproject2/Commons/Commons.dart';
import 'package:dataproject2/Commons/WebService.dart';
import 'package:dataproject2/Stock_opening/ItemSearchResult.dart';
import 'package:dataproject2/Stock_opening/ViewItemDetail.dart';
import 'package:dataproject2/appConfig/AppConfig.dart';
import 'package:dataproject2/datamodel/CategoryModel.dart';
import 'package:dataproject2/datamodel/SearchUserModel.dart';

import 'package:dataproject2/style/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';

import 'model/ItemResultModel.dart';

class ItemSearchCatalog extends StatefulWidget {
  final ComingFrom? comingFrom;

  const ItemSearchCatalog({Key? key, this.comingFrom}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemSearchCatalog();
}

class _ItemSearchCatalog extends State<ItemSearchCatalog> {
  String tempString = '';

  /// All Variables
  double tabHeight = 60;
  double tabFontSize = 16;
  static const double tabFontLeftPadding = 12.0;
  WidgetsFactory _selectedWidget = WidgetsFactory.Category;
  String? imgBaseUrl = '';
  DateTime selectedFromDt = DateTime.now();
  DateTime selectedToDt = DateTime.now();

  /// Lists
  List<ItemResultModel> resultList = [];
  List<CategoryModel> categoryList = [];
  List<CategoryModel> subCategoryList = [];
  List<CategoryModel> typeList = [];
  List<CategoryModel> partyList = [];
  List<CategoryModel> machineList = [];
  List<CategoryModel> brandList = [];
  List<CategoryModel> countList = [];
  List<CategoryModel> materialList = [];
  List<CategoryModel> processList = [];
  List<CategoryModel> shadeList = [];
  List<CategoryModel> itemList = [];
  List<SearchUserModel> userList = [];
  List<CategoryModel> attributeList = [];
  List<CategoryModel> mAttributeList = [];

  List<CategoryModel> catalogList = [];
  List<CategoryModel> partyItemList = [];
  List<CategoryModel> partyPoList = [];
  List<CategoryModel> catMachineList = [];

  List<CategoryModel> mCatList = [];
  List<CategoryModel> mSubCatList = [];
  List<CategoryModel> mTypeList = [];
  List<CategoryModel> mPartyList = [];
  List<CategoryModel> mMachineList = [];
  List<CategoryModel> mBrandList = [];
  List<CategoryModel> mCountList = [];
  List<CategoryModel> mMaterialList = [];
  List<CategoryModel> mProcessList = [];
  List<CategoryModel> mShadeList = [];
  List<CategoryModel> mItemList = [];
  List<SearchUserModel> mUserList = [];
  List<CategoryModel> attList = [];

  List<CategoryModel> mCatalogList = [];
  List<CategoryModel> mPartyItemList = [];
  List<CategoryModel> mPartyPoList = [];
  List<CategoryModel> mCatMachineList = [];

  /// Selected Items
  String? selectedCategory = '';
  String? selectedSubCategory = '';
  String? selectedType = '';
  String? selectedParty = '';
  String? selectedMachine = '';
  String? selectedBrand = '';
  String? selectedCount = '';
  String? selectedMaterial = '';
  String? selectedProcess = '';
  String? selectedShade = '';
  String? selectedItem = '';
  String? selectedUser = '';
  String selectedSimilarItem = '';
  String selectedFromDate = '';
  String selectedToDate = '';

  String selectedCatalog = '';
  String? selectedPartyItem = '';
  String? selectedPartyPo = '';
  String? selectedCatMachine = '';
  String selectedFromRate = '';
  String selectedToRate = '';

  String? codeCategory = '';
  String? codeSubCategory = '';
  String? codeType = '';
  String? codeParty = '';
  String? codeMachine = '';
  String? codeBrand = '';
  String? codeCount = '';
  String? codeMaterial = '';
  String? codeProcess = '';
  String? codeShade = '';
  String? codeItem = '';
  String? codeUser = '';
  String codeSimilarItem = '';
  String codeFromDate = '';
  String codeToDate = '';

  String codeCatalog = '';
  String? codePartyItem = '';
  String? codePartyPO = '';
  String? codeCatMachine = '';

  String? codeAttrValWise = '';

  String? codeMultiAttrWiseHeader = '';
  String? codeMultiAttrWise1 = '';
  String? codeMultiAttrWise2 = '';
  String? codeMultiAttrWise3 = '';
  String? codeMultiAttrWise4 = '';
  String? codeMultiAttrWise5 = '';

  String? codeAttrComp1 = '';
  String? codeAttrComp2 = '';
  String? codeAttrComp3 = '';
  String? codeAttrComp4 = '';
  String? codeAttrComp5 = '';

  /// Controllers
  TextEditingController categoryController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController partyController = TextEditingController();
  TextEditingController machineController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  TextEditingController processController = TextEditingController();
  TextEditingController shadeController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController similarController = TextEditingController();

  TextEditingController catalogController = TextEditingController();
  TextEditingController partyItemController = TextEditingController();
  TextEditingController partyPoController = TextEditingController();
  TextEditingController catMachineController = TextEditingController();
  TextEditingController fromRateController = TextEditingController();
  TextEditingController toRateController = TextEditingController();

  /// Attribute Value Wise Controllers
  TextEditingController attrValueWiseController = TextEditingController();
  TextEditingController avw1Controller = TextEditingController();
  TextEditingController avw2Controller = TextEditingController();
  TextEditingController avw3Controller = TextEditingController();
  TextEditingController avw4Controller = TextEditingController();
  TextEditingController avw5Controller = TextEditingController();
  TextEditingController avw6Controller = TextEditingController();
  TextEditingController avw7Controller = TextEditingController();
  TextEditingController avw8Controller = TextEditingController();
  TextEditingController avw9Controller = TextEditingController();
  TextEditingController avw10Controller = TextEditingController();
  TextEditingController avw11Controller = TextEditingController();
  TextEditingController avw12Controller = TextEditingController();
  TextEditingController avw13Controller = TextEditingController();
  TextEditingController avw14Controller = TextEditingController();
  TextEditingController avw15Controller = TextEditingController();
  TextEditingController avw16Controller = TextEditingController();
  TextEditingController avw17Controller = TextEditingController();
  TextEditingController avw18Controller = TextEditingController();
  TextEditingController avw19Controller = TextEditingController();
  TextEditingController avw20Controller = TextEditingController();
  TextEditingController avw21Controller = TextEditingController();
  TextEditingController avw22Controller = TextEditingController();
  TextEditingController avw23Controller = TextEditingController();
  TextEditingController avw24Controller = TextEditingController();
  TextEditingController avw25Controller = TextEditingController();

  /// Multi Attribute Wise Controllers
  TextEditingController multiAttrWiseController = TextEditingController();

  ///First Group
  TextEditingController mawAttr1Controller = TextEditingController();
  TextEditingController mawAttrCode1Controller = TextEditingController();
  TextEditingController mawAttrValue1Controller = TextEditingController();

  ///First Group
  TextEditingController mawAttr2Controller = TextEditingController();
  TextEditingController mawAttrCode2Controller = TextEditingController();
  TextEditingController mawAttrValue2Controller = TextEditingController();

  ///First Group
  TextEditingController mawAttr3Controller = TextEditingController();
  TextEditingController mawAttrCode3Controller = TextEditingController();
  TextEditingController mawAttrValue3Controller = TextEditingController();

  ///First Group
  TextEditingController mawAttr4Controller = TextEditingController();
  TextEditingController mawAttrCode4Controller = TextEditingController();
  TextEditingController mawAttrValue4Controller = TextEditingController();

  ///First Group
  TextEditingController mawAttr5Controller = TextEditingController();
  TextEditingController mawAttrCode5Controller = TextEditingController();
  TextEditingController mawAttrValue5Controller = TextEditingController();

  /// Attribute Comparison Controllers
  TextEditingController attrCompController = TextEditingController();

  /// First
  TextEditingController attrCompValue1Controller = TextEditingController();
  TextEditingController attrCompType1Controller = TextEditingController();
  TextEditingController attrCompFrom1Controller = TextEditingController();
  TextEditingController attrCompTo1Controller = TextEditingController();

  /// Second
  TextEditingController attrCompValue2Controller = TextEditingController();
  TextEditingController attrCompType2Controller = TextEditingController();
  TextEditingController attrCompFrom2Controller = TextEditingController();
  TextEditingController attrCompTo2Controller = TextEditingController();

  /// Third
  TextEditingController attrCompValue3Controller = TextEditingController();
  TextEditingController attrCompType3Controller = TextEditingController();
  TextEditingController attrCompFrom3Controller = TextEditingController();
  TextEditingController attrCompTo3Controller = TextEditingController();

  /// Fourth
  TextEditingController attrCompValue4Controller = TextEditingController();
  TextEditingController attrCompType4Controller = TextEditingController();
  TextEditingController attrCompFrom4Controller = TextEditingController();
  TextEditingController attrCompTo4Controller = TextEditingController();

  /// Fifth
  TextEditingController attrCompValue5Controller = TextEditingController();
  TextEditingController attrCompType5Controller = TextEditingController();
  TextEditingController attrCompFrom5Controller = TextEditingController();
  TextEditingController attrCompTo5Controller = TextEditingController();

  /// Type
  String? attrCompType1 = '';
  String? attrCompType2 = '';
  String? attrCompType3 = '';
  String? attrCompType4 = '';
  String? attrCompType5 = '';

  /// Misc.
  String selectedCatFiles = '0';
  String selectedCatStatus = '0';

  bool isCatFile = false;
  bool isCatStatus = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getList();
    });
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0000),
        automaticallyImplyLeading: true,
        title: Text(
          'Item Search Catalog',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearAll();
              setState(() {});
            },
            child: Text(
              'Clear Filters',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          /// Category (Right Side)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              color: Colors.white,
              child: _getWidgets(_selectedWidget),
            ),
          ),

          /// Category List (Left Side)
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                children: [
                  /// Category
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Category;
                      if (categoryList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Category
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: tabFontLeftPadding),
                              child: Text(
                                'Category',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: tabFontSize),
                              ),
                            ),
                            Visibility(
                              visible: selectedCategory!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Sub Category
                  GestureDetector(
                    onTap: () {
                      if (selectedCategory!.isNotEmpty) {
                        _selectedWidget = WidgetsFactory.SubCategory;
                        _getSubCategory();
                        setState(() {});
                      } else {
                        Commons.showToast('First Select the category');
                      }
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.SubCategory
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding,
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Sub Category',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedSubCategory!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Type
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Type;
                      if (typeList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Type
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding,
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Type',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedType!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Item
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Item;
                      if (itemList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Item
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Item',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedItem!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Party
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Party;
                      if (partyList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Party
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding,
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Party',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedParty!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Catalog
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Catalog;
                      /*if (catalogList.isEmpty) {
                        _getList();
                      }*/
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Catalog
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Catalog No',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedCatalog.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Machine
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Machine;
                      if (machineList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Machine
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding,
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Machine',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedMachine!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Brand
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Brand;
                      if (brandList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Brand
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding,
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Brand',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedBrand!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Count
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Count;
                      if (countList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Count
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding,
                                    right: tabFontLeftPadding),
                                child: Text(
                                  'Count',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedCount!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Material
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Material;
                      if (materialList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Material
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Material',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedMaterial!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Process
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Process;
                      if (processList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Process
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Process',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedProcess!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Shade
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Shade;
                      if (shadeList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Shade
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Shade',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedShade!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// User
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.User;
                      if (userList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.User
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'User',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedUser!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Party Item
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.PartyItem;
                      if (partyItemList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.PartyItem
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Party Item',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedPartyItem!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Party PO
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.PartyPO;
                      if (partyPoList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.PartyPO
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Party PO',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedPartyPo!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// CAT Machine
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.CatMachine;
                      if (catMachineList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.CatMachine
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'CAT Machine',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedCatMachine!.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Similar Items
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.SimilarItems;
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.SimilarItems
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'Similar Items',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: similarController.text.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// From Rate
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.FromRate;
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.FromRate
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'From Rate',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  fromRateController.text.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// To Rate
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.ToRate;
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.ToRate
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'To Rate',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: toRateController.text.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// From Date
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.FromDate;
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.FromDate
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'From Date',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedFromDate.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// To Date
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.ToDate;
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.ToDate
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding),
                                child: Text(
                                  'To Date',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: selectedToDate.trim().isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: tabFontLeftPadding),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: Container(
                                      height: 6,
                                      width: 6,
                                      color: AppColor.appRed,
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),

                  /// Attribute Between
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.AttributeComparison;
                      if (attributeList.isEmpty) {
                        _getList();
                      }
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget ==
                                WidgetsFactory.AttributeComparison
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding,
                                    right: tabFontLeftPadding),
                                child: Text(
                                  'Attribute Between',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),

                  /// Misc.
                  GestureDetector(
                    onTap: () {
                      _selectedWidget = WidgetsFactory.Miscellaneous;
                      setState(() {});
                    },
                    child: Container(
                        color: _selectedWidget == WidgetsFactory.Miscellaneous
                            ? Colors.white
                            : Colors.transparent,
                        height: tabHeight,
                        child: Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: tabFontLeftPadding,
                                    right: tabFontLeftPadding),
                                child: Text(
                                  'Misc.',
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: tabFontSize),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),

                  SizedBox(
                    height: 58,
                  ),
                ],
              ),
            ),
          ),

          /// Bottom Count and Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Item Result Count
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${resultList.length}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              'items Found',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            )
                          ]),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: ElevatedButton(
                        // color: AppColor.appRed,
                        onPressed: () {
                          if (_validated()) {
                            _getFilteredItems();
                          }
                        },
                        child: Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _init() {
    attList.clear();

    for (int i = 0; i <= 24; i++) {
      attList.add(CategoryModel(id: '$i', categoryName: 'At${i + 1}'));
    }
  }

  Widget _getWidgets(WidgetsFactory type) {
    switch (type) {
      case WidgetsFactory.Category:
        return categoryList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: categoryController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = categoryList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mCatList.clear();
                            setState(() {
                              mCatList.addAll(res);
                            });
                          } else {
                            mCatList.clear();
                            mCatList.addAll(categoryList);
                            setState(() {});
                          }
                          //  debugPrint('SearchString => $char');
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                categoryController.clear();
                                mCatList.clear();
                                mCatList.addAll(categoryList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Category',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total category:${categoryList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 65),
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mCatList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  debugPrint('Category $value');
                                  selectedCategory = value;
                                  codeCategory = mCatList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedCategory,
                            ),
                            Text(mCatList[index].categoryName!),
                          ],
                        );
                      },
                      itemCount: mCatList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.SubCategory:
        return subCategoryList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 3),
                    child: Text(
                      'Total subcategory:${subCategoryList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 65),
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: subCategoryList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedSubCategory = value;
                                  codeSubCategory = subCategoryList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedSubCategory,
                            ),
                            Text(subCategoryList[index].categoryName!),
                          ],
                        );
                      },
                      itemCount: subCategoryList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Type:
        return typeList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: typeController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = typeList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mTypeList.clear();
                            setState(() {
                              mTypeList.addAll(res);
                            });
                          } else {
                            mTypeList.clear();
                            mTypeList.addAll(typeList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                typeController.clear();
                                mTypeList.clear();
                                mTypeList.addAll(typeList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total type:${typeList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mTypeList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedType = value;
                                  codeType = mTypeList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedType,
                            ),
                            Flexible(
                                child: Text(mTypeList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mTypeList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Party:
        return partyList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: partyController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = partyList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mPartyList.clear();
                            setState(() {
                              mPartyList.addAll(res);
                            });
                          } else {
                            mPartyList.clear();
                            mPartyList.addAll(partyList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                partyController.clear();
                                mPartyList.clear();
                                mPartyList.addAll(partyList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Party',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total party:${partyList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mPartyList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedParty = value;
                                  codeParty = mPartyList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedParty,
                            ),
                            Flexible(
                                child: Text(mPartyList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mPartyList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Machine:
        return machineList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: machineController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = machineList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mMachineList.clear();
                            setState(() {
                              mMachineList.addAll(res);
                            });
                          } else {
                            mMachineList.clear();
                            mMachineList.addAll(machineList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                partyController.clear();
                                mMachineList.clear();
                                mMachineList.addAll(machineList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Machine',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total machine:${machineList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mMachineList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedMachine = value;
                                  codeMachine = mMachineList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedMachine,
                            ),
                            Flexible(
                                child: Text(mMachineList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mMachineList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Brand:
        return brandList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: brandController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = brandList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mBrandList.clear();
                            setState(() {
                              mBrandList.addAll(res);
                            });
                          } else {
                            mBrandList.clear();
                            mBrandList.addAll(brandList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                partyController.clear();
                                mBrandList.clear();
                                mBrandList.addAll(brandList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Brand',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total brand:${brandList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mBrandList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedBrand = value;
                                  codeBrand = mBrandList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedBrand,
                            ),
                            Flexible(
                                child: Text(mBrandList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mBrandList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Count:
        return countList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: countController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = countList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mCountList.clear();
                            setState(() {
                              mCountList.addAll(res);
                            });
                          } else {
                            mCountList.clear();
                            mCountList.addAll(countList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                countController.clear();
                                mCountList.clear();
                                mCountList.addAll(countList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Count',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total count:${countList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mCountList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedCount = value;
                                  codeCount = mCountList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedCount,
                            ),
                            Flexible(
                                child: Text(mCountList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mCountList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Material:
        return materialList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: materialController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = materialList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mMaterialList.clear();
                            setState(() {
                              mMaterialList.addAll(res);
                            });
                          } else {
                            mMaterialList.clear();
                            mMaterialList.addAll(materialList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                materialController.clear();
                                mMaterialList.clear();
                                mMaterialList.addAll(materialList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Material',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total material:${materialList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mMaterialList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedMaterial = value;
                                  codeMaterial = mMaterialList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedMaterial,
                            ),
                            Flexible(
                                child:
                                    Text(mMaterialList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mMaterialList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Process:
        return processList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: processController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = processList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mProcessList.clear();
                            setState(() {
                              mProcessList.addAll(res);
                            });
                          } else {
                            mProcessList.clear();
                            mProcessList.addAll(processList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                processController.clear();
                                mProcessList.clear();
                                mProcessList.addAll(processList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Process',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total process:${processList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mProcessList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedProcess = value;
                                  codeProcess = mProcessList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedProcess,
                            ),
                            Flexible(
                                child: Text(mProcessList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mProcessList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Shade:
        return shadeList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: shadeController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = shadeList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mShadeList.clear();
                            setState(() {
                              mShadeList.addAll(res);
                            });
                          } else {
                            mShadeList.clear();
                            mShadeList.addAll(shadeList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                shadeController.clear();
                                mShadeList.clear();
                                mShadeList.addAll(shadeList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Shade',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total shade:${shadeList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mShadeList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedShade = value;
                                  codeShade = mShadeList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedShade,
                            ),
                            Flexible(
                                child: Text(mShadeList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mShadeList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Item:
        return itemList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: itemController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = itemList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mItemList.clear();
                            setState(() {
                              mItemList.addAll(res);
                            });
                          } else {
                            mItemList.clear();
                            mItemList.addAll(itemList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                itemController.clear();
                                mItemList.clear();
                                mItemList.addAll(itemList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Item',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total items:${itemList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mItemList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedItem = value;
                                  codeItem = mItemList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedItem,
                            ),
                            Flexible(
                                child: Text(mItemList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mItemList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.User:
        return userList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: userController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = userList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mUserList.clear();
                            setState(() {
                              mUserList.addAll(res);
                            });
                          } else {
                            mUserList.clear();
                            mUserList.addAll(userList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                userController.clear();
                                mUserList.clear();
                                mUserList.addAll(userList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'User',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total user:${userList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mUserList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedUser = value;
                                  codeUser = mUserList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedUser,
                            ),
                            Flexible(
                                child: Text(mUserList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mUserList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.Catalog:
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                  controller: catalogController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Catalog No',
                  )),
            ],
          ),
        );

      case WidgetsFactory.PartyItem:
        return partyItemList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: partyItemController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = partyItemList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mPartyItemList.clear();
                            setState(() {
                              mPartyItemList.addAll(res);
                            });
                          } else {
                            mPartyItemList.clear();
                            mPartyItemList.addAll(partyItemList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                partyItemController.clear();
                                mPartyItemList.clear();
                                mPartyItemList.addAll(partyItemList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Party Item',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total party item:${partyItemList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mPartyItemList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedPartyItem = value;
                                  codePartyItem = mPartyItemList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedPartyItem,
                            ),
                            Flexible(
                                child:
                                    Text(mPartyItemList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mPartyItemList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.PartyPO:
        return partyPoList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: partyPoController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = partyPoList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mPartyPoList.clear();
                            setState(() {
                              mPartyPoList.addAll(res);
                            });
                          } else {
                            mPartyPoList.clear();
                            mPartyPoList.addAll(partyPoList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                partyPoController.clear();
                                mPartyPoList.clear();
                                mPartyPoList.addAll(partyPoList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Party PO',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total party po:${partyPoList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mPartyPoList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedPartyPo = value;
                                  codePartyPO = mPartyPoList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedPartyPo,
                            ),
                            Flexible(
                                child: Text(mPartyPoList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mPartyPoList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.CatMachine:
        return catMachineList.isEmpty
            ? Center(
                child: Text('No data found.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                        controller: catMachineController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        onChanged: (char) {
                          if (char.trim().isNotEmpty) {
                            var res = catMachineList.where((element) => element
                                .categoryName!
                                .toLowerCase()
                                .contains(char.trim().toLowerCase()));
                            mCatMachineList.clear();
                            setState(() {
                              mCatMachineList.addAll(res);
                            });
                          } else {
                            mCatMachineList.clear();
                            mCatMachineList.addAll(catMachineList);
                            setState(() {});
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                catMachineController.clear();
                                mCatMachineList.clear();
                                mCatMachineList.addAll(catMachineList);
                                setState(() {});
                              },
                              child: Icon(Icons.clear)),
                          isDense: true,
                          labelText: 'Cat Machine',
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 3, 12, 3),
                    child: Text(
                      'Total cat machine:${catMachineList.length}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: mCatMachineList[index].categoryName,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedCatMachine = value;
                                  codeCatMachine = mCatMachineList[index].id;
                                });
                              },
                              activeColor: AppColor.appRed,
                              groupValue: selectedCatMachine,
                            ),
                            Flexible(
                                child:
                                    Text(mCatMachineList[index].categoryName!)),
                          ],
                        );
                      },
                      itemCount: mCatMachineList.length,
                    ),
                  ),
                ],
              );

      case WidgetsFactory.SimilarItems:
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                  keyboardType: TextInputType.text,
                  controller: similarController,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Similar Item',
                  )),
            ],
          ),
        );

      case WidgetsFactory.FromRate:
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                  controller: fromRateController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'From Rate',
                  )),
            ],
          ),
        );

      case WidgetsFactory.ToRate:
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: toRateController,
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'To Rate',
                  )),
            ],
          ),
        );

      case WidgetsFactory.FromDate:
        debugPrint('FromDate-> $selectedFromDt');

        DateTime now = DateTime.now();
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: CalendarDatePicker(
            initialCalendarMode: DatePickerMode.year,
            currentDate: selectedFromDt,
            lastDate: now,
            firstDate: DateTime(2001, 01, 01),
            initialDate: selectedFromDt,
            onDateChanged: (date) {
              selectedFromDt = date;
              selectedFromDate = '${date.year}-${date.month}-${date.day}';
              //  setState(() {});
            },
          ),
        );

      case WidgetsFactory.ToDate:
        DateTime now = DateTime.now();
        debugPrint('ToDate-> $selectedToDt Now -> $now');

        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: CalendarDatePicker(
            initialCalendarMode: DatePickerMode.year,
            currentDate: selectedToDt,
            lastDate: now,
            firstDate: DateTime(2001, 01, 01),
            initialDate: selectedToDt,
            onDateChanged: (date) {
              selectedToDt = date;
              selectedToDate = '${date.year}-${date.month}-${date.day}';
              // setState(() {});
            },
          ),
        );

      case WidgetsFactory.AttributeComparison:
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10.0, 14, 10.0, 10.0),
          child: Column(
            children: [
              /// First Group
              /// Attribute Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: attrCompValue1Controller,
                        readOnly: true,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () async {
                          _attributeBottomSheet(
                              context,
                              attrCompValue1Controller,
                              'codeAttrComp1',
                              attrCompType1Controller,
                              'At1',
                              attrCompFrom1Controller,
                              attrCompTo1Controller);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Attribute',
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: attrCompType1Controller,
                        readOnly: true,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attListSheet(context, attrCompType1Controller);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// From
                  Expanded(
                    child: TextFormField(
                        controller: attrCompFrom1Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onChanged: (val) {
                          attrCompTo1Controller.text = val.trim();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'From',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// To
                  Expanded(
                    child: TextFormField(
                        controller: attrCompTo1Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'To',
                        )),
                  )
                ],
              ),

              SizedBox(
                height: 10,
              ),

              Divider(
                color: Colors.black,
              ),

              SizedBox(
                height: 10,
              ),

              /// Second Group
              /// Attribute Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: attrCompValue2Controller,
                        readOnly: true,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attributeBottomSheet(
                              context,
                              attrCompValue2Controller,
                              'codeAttrComp2',
                              attrCompType2Controller,
                              'At1',
                              attrCompFrom2Controller,
                              attrCompTo2Controller);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Attribute',
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: attrCompType2Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attListSheet(context, attrCompType2Controller);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// From
                  Expanded(
                    child: TextFormField(
                        controller: attrCompFrom2Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onChanged: (val) {
                          attrCompTo2Controller.text = val.trim();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'From',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// To
                  Expanded(
                    child: TextFormField(
                        controller: attrCompTo2Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'To',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),

              Divider(
                color: Colors.black,
              ),

              SizedBox(
                height: 10,
              ),

              /// Third Group
              /// Attribute Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: attrCompValue3Controller,
                        readOnly: true,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attributeBottomSheet(
                              context,
                              attrCompValue3Controller,
                              'codeAttrComp3',
                              attrCompType3Controller,
                              'At1',
                              attrCompFrom3Controller,
                              attrCompTo3Controller);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Attribute',
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: attrCompType3Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attListSheet(context, attrCompType3Controller);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// From
                  Expanded(
                    child: TextFormField(
                        controller: attrCompFrom3Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onChanged: (val) {
                          attrCompTo3Controller.text = val.trim();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'From',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// To
                  Expanded(
                    child: TextFormField(
                        controller: attrCompTo3Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'To',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),

              Divider(
                color: Colors.black,
              ),

              SizedBox(
                height: 10,
              ),

              /// Fourth Group
              /// Attribute Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: attrCompValue4Controller,
                        readOnly: true,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attributeBottomSheet(
                              context,
                              attrCompValue4Controller,
                              'codeAttrComp4',
                              attrCompType4Controller,
                              'At1',
                              attrCompFrom4Controller,
                              attrCompTo4Controller);
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Attribute',
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: attrCompType4Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attListSheet(context, attrCompType4Controller);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// From
                  Expanded(
                    child: TextFormField(
                        controller: attrCompFrom4Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onChanged: (val) {
                          attrCompTo4Controller.text = val.trim();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'From',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// To
                  Expanded(
                    child: TextFormField(
                        controller: attrCompTo4Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'To',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),

              Divider(
                color: Colors.black,
              ),

              SizedBox(
                height: 10,
              ),

              /// Fifth Group
              /// Attribute Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: attrCompValue5Controller,
                      readOnly: true,
                      cursorColor: Colors.black,
                      textInputAction: TextInputAction.next,
                      onTap: () {
                        _attributeBottomSheet(
                            context,
                            attrCompValue5Controller,
                            'codeAttrComp5',
                            attrCompType5Controller,
                            'At1',
                            attrCompFrom5Controller,
                            attrCompTo5Controller);
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                        border: OutlineInputBorder(),
                        isDense: true,
                        labelText: 'Attribute',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: attrCompType5Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          _attListSheet(context, attrCompType5Controller);
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'Type',
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  /// From
                  Expanded(
                    child: TextFormField(
                        controller: attrCompFrom5Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onChanged: (val) {
                          attrCompTo5Controller.text = val.trim();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'From',
                        )),
                  ),

                  SizedBox(width: 10),

                  /// To
                  Expanded(
                    child: TextFormField(
                        controller: attrCompTo5Controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        onTap: () {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          labelText: 'To',
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 78,
              ),
            ],
          ),
        );

      case WidgetsFactory.Miscellaneous:
        return Column(
          children: [
            /// Catalog Item With Files
            Row(
              children: [
                Checkbox(
                    value: isCatFile,
                    onChanged: (v) {
                      setState(() {
                        isCatFile = !isCatFile;
                      });
                    }),
                Flexible(child: Text('Catalog Item With Files', softWrap: true))
              ],
            ),

            /// Catalog Item With Status No
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                    value: isCatStatus,
                    onChanged: (v) {
                      setState(() {
                        isCatStatus = !isCatStatus;
                      });
                    }),
                Flexible(
                    child: Text('Catalog Item With Status No', softWrap: true))
              ],
            ),
          ],
        );

      default:
        return Center(child: Text('Wrong Widget Parameter'));
    }
  }

  String _getTableName() {
    switch (_selectedWidget) {
      case WidgetsFactory.Category:
        return 'ITEM_CATAGORY';

      case WidgetsFactory.Type:
        return 'ITEM_TYPE';

      case WidgetsFactory.Party:
        return 'ACC_MASTER';

      case WidgetsFactory.Machine:
        return 'MACHINE_MASTER';

      case WidgetsFactory.Brand:
        return 'BRAND_MASTER';

      case WidgetsFactory.Count:
        return 'COUNT_MASTER';

      case WidgetsFactory.Material:
        return 'MATERIAL_MASTER';

      case WidgetsFactory.Process:
        return 'PROCESS_MASTER';

      case WidgetsFactory.Shade:
        return 'SHADE_MASTER';

      case WidgetsFactory.Item:
        return 'ITEM_MASTER';

      case WidgetsFactory.PartyItem:
        return 'PARTY_ITEM';

      case WidgetsFactory.PartyPO:
        return 'PARTY_PO';

      case WidgetsFactory.CatMachine:
        return 'CATALOG_MACHINE';

      case WidgetsFactory.User:
        return 'USERS';

      case WidgetsFactory.AttributeComparison:
        return 'ITEM_PARA_ALL';

      case WidgetsFactory.AttributeValueWise:
      case WidgetsFactory.MultiAttributeWise:
        return 'ATTR_MASTER';

      default:
        return 'Un_Defined';
    }
  }

  _getList() {
    String? userId = AppConfig.prefs.getString('user_id');

    Commons().showProgressbar(context);

    var jsonEncoder = jsonEncode(
        <String, dynamic>{'user_id': userId, 'table_name': _getTableName()});

    debugPrint('getList $jsonEncoder');

    WebService()
        .post(context, AppConfig.searchItemParameters, jsonEncoder)
        .then((value) => {Navigator.pop(context), _parse(value!)});
  }

  _parse(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List?;

        switch (_selectedWidget) {
          case WidgetsFactory.Category:
            categoryList.clear();
            categoryList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mCatList.addAll(categoryList);
            debugPrint('partyList ${categoryList.length}');
            break;

          case WidgetsFactory.Type:
            typeList.clear();
            typeList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mTypeList.addAll(typeList);
            debugPrint('partyList ${typeList.length}');
            break;

          case WidgetsFactory.Party:
            partyList.clear();
            partyList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mPartyList.addAll(partyList);
            debugPrint('partyList ${partyList.length}');
            break;

          case WidgetsFactory.Machine:
            machineList.clear();
            machineList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mMachineList.addAll(machineList);
            debugPrint('partyList ${machineList.length}');
            break;

          case WidgetsFactory.Brand:
            brandList.clear();
            brandList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mBrandList.addAll(brandList);
            debugPrint('partyList ${brandList.length}');
            break;

          case WidgetsFactory.Count:
            countList.clear();
            countList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mCountList.addAll(countList);
            debugPrint('partyList ${countList.length}');
            break;

          case WidgetsFactory.Material:
            materialList.clear();
            materialList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mMaterialList.addAll(materialList);
            debugPrint('partyList ${materialList.length}');
            break;

          case WidgetsFactory.Process:
            processList.clear();
            processList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mProcessList.addAll(processList);
            debugPrint('partyList ${processList.length}');
            break;

          case WidgetsFactory.Shade:
            shadeList.clear();
            shadeList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mShadeList.addAll(shadeList);
            debugPrint('partyList ${shadeList.length}');
            break;

          case WidgetsFactory.Item:
            itemList.clear();
            itemList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mItemList.addAll(itemList);
            debugPrint('partyList ${itemList.length}');
            break;

          case WidgetsFactory.Catalog:
            catalogList.clear();
            catalogList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mCatalogList.addAll(catalogList);
            debugPrint('partyList ${catalogList.length}');
            break;

          case WidgetsFactory.PartyItem:
            partyItemList.clear();
            partyItemList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mPartyItemList.addAll(partyItemList);
            debugPrint('partyList ${partyItemList.length}');
            break;

          case WidgetsFactory.PartyPO:
            partyPoList.clear();
            partyPoList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mPartyPoList.addAll(partyPoList);
            debugPrint('partyList ${partyPoList.length}');
            break;

          case WidgetsFactory.CatMachine:
            catMachineList.clear();
            catMachineList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mCatMachineList.addAll(catMachineList);
            debugPrint('partyList ${catMachineList.length}');
            break;

          case WidgetsFactory.User:
            userList.clear();
            userList.addAll(
                contentList!.map((e) => SearchUserModel.fromJSON(e)).toList());
            mUserList.addAll(userList);
            debugPrint('partyList ${userList.length}');
            break;

          case WidgetsFactory.AttributeComparison:
          case WidgetsFactory.AttributeValueWise:
          case WidgetsFactory.MultiAttributeWise:
            attributeList.clear();
            mAttributeList.clear();
            attributeList.addAll(
                contentList!.map((e) => CategoryModel.fromJSON(e)).toList());
            mAttributeList.addAll(
                contentList.map((e) => CategoryModel.fromJSON(e)).toList());

            debugPrint('partyList ${attributeList.length}');

            break;
          case WidgetsFactory.SubCategory:
            break;
          case WidgetsFactory.SimilarItems:
            break;
          case WidgetsFactory.FromRate:
            break;
          case WidgetsFactory.ToRate:
            break;
          case WidgetsFactory.FromDate:
            break;
          case WidgetsFactory.ToDate:
            break;
          case WidgetsFactory.Miscellaneous:
            break;
        }

        setState(() {});
      }
    }
  }

  _getSubCategory() {
    String? userId = AppConfig.prefs.getString('user_id');

    Commons().showProgressbar(context);

    var jsonEncoder = jsonEncode(
        <String, dynamic>{'user_id': userId, 'item_cat_code': codeCategory});

    debugPrint('getList $jsonEncoder');

    WebService()
        .post(context, AppConfig.getSubCategory, jsonEncoder)
        .then((value) => {Navigator.pop(context), _parseSubCategory(value!)});
  }

  _parseSubCategory(Response value) {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        var contentList = data['content'] as List;

        subCategoryList.clear();
        subCategoryList
            .addAll(contentList.map((e) => CategoryModel.fromJSON(e)).toList());
        mSubCatList.addAll(subCategoryList);
        debugPrint('SubCategory ${subCategoryList.length}');
        setState(() {});
      }
    }
  }

  _attributeBottomSheet(
      BuildContext context,
      TextEditingController valueController,
      attId,
      TextEditingController attrCompTypeController,
      String atValue,
      TextEditingController attrCompFromController,
      TextEditingController attrCompToController) {
    debugPrint('ControllerIs-> $attrCompTypeController');
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20.0, 18, 0),
                  child: TypeAheadFormField<CategoryModel>(
                    validator: (value) =>
                        value!.isEmpty ? 'Please select attribute' : null,
                    itemBuilder: (BuildContext context, itemData) {
                      return ListTile(
                        title: Text(
                          itemData.categoryName!,
                          style: TextStyle(
                              color: itemData.isSelected
                                  ? Colors.grey
                                  : Colors.black),
                        ),
                      );
                    },
                    onSuggestionSelected: (sg) {
                      if (sg.isSelected) return;
                      _checkRemoveRedundant(attId);
                      Navigator.of(context).pop();
                      debugPrint('SelectedAttCode ${sg.type}');
                      switch (attId) {
                        case 'codeAttrComp1':
                          attrCompType1 = sg.type;
                          break;

                        case 'codeAttrComp2':
                          attrCompType2 = sg.type;
                          break;

                        case 'codeAttrComp3':
                          attrCompType3 = sg.type;
                          break;

                        case 'codeAttrComp4':
                          attrCompType4 = sg.type;
                          break;

                        case 'codeAttrComp5':
                          attrCompType5 = sg.type;
                          break;
                      }

                      setState(() async {
                        sg.selectedId = attId;
                        sg.isSelected = true;
                        valueController.text = sg.categoryName!;
                        _addToCodes(attId, sg.id);
                        attrCompTypeController.text = atValue;
                        attrCompFromController.text = '0';
                        attrCompToController.text = '0';
                      });
                    },
                    suggestionsCallback: (String pattern) {
                      return _getFilteredAttributes(pattern);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        textAlign: TextAlign.start,
                        autofocus: true,
                        onChanged: (string) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.search),
                            hintText: 'Search Attribute',
                            isDense: true)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _checkRemoveRedundant(String attId) async {
    attributeList.forEach((element) {
      if (attId == element.selectedId) {
        element.selectedId = '';
        element.isSelected = false;
      }
    });
  }

  /*void _attributeSheet(context, TextEditingController valueController, attId) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => ListTile(
                title: Row(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index + 1}.'),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(mAttributeList[index].categoryName),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  valueController.text = mAttributeList[index].categoryName;
                  //  attId = attributeList[index].id;
                  _addToCodes(attId, mAttributeList[index].id);
                  debugPrint('SelectedAttCode $attId');
                  Navigator.of(context).pop();
                },
              ),
              itemCount: mAttributeList.length,
            ),
          );
        });
  }*/

  _getFilteredAttributes(String str) {
    return attributeList
        .where(
            (i) => i.categoryName!.toLowerCase().startsWith(str.toLowerCase()))
        .toList();
  }

  _addToCodes(field, data) {
    switch (field) {
      case 'codeAttrValWise':
        codeAttrValWise = data;
        break;
      case 'codeMultiAttrWiseHeader':
        codeMultiAttrWiseHeader = data;
        break;
      case 'codeMultiAttrWise1':
        codeMultiAttrWise1 = data;
        mawAttrCode1Controller.text = data;
        break;
      case 'codeMultiAttrWise2':
        codeMultiAttrWise2 = data;
        mawAttrCode2Controller.text = data;
        break;
      case 'codeMultiAttrWise3':
        codeMultiAttrWise3 = data;
        mawAttrCode3Controller.text = data;
        break;
      case 'codeMultiAttrWise4':
        codeMultiAttrWise4 = data;
        mawAttrCode4Controller.text = data;
        break;
      case 'codeMultiAttrWise5':
        codeMultiAttrWise5 = data;
        mawAttrCode5Controller.text = data;
        break;
      case 'codeAttrComp1':
        codeAttrComp1 = data;
        break;
      case 'codeAttrComp2':
        codeAttrComp2 = data;
        break;
      case 'codeAttrComp3':
        codeAttrComp3 = data;
        break;
      case 'codeAttrComp4':
        codeAttrComp4 = data;
        break;
      case 'codeAttrComp5':
        codeAttrComp5 = data;
        break;
      default:
        print('defaultexcuted');
    }
  }

  void _attListSheet(context, TextEditingController teCont) {
    showModalBottomSheet(
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => ListTile(
                title: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(attList[index].categoryName!),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  teCont.text = attList[index].categoryName!;
                  Navigator.of(context).pop();
                },
              ),
              itemCount: attList.length,
            ),
          );
        });
  }

  /// Validation for dependent values
  bool _validated() {
    /// Misc.
    // if(  !isCatFile || !isCatStatus)return false;

    /// Attribute Value Wise
    if (attrValueWiseController.text.isNotEmpty) {
      if (avw1Controller.text.trim().isEmpty &&
          avw2Controller.text.trim().isEmpty &&
          avw3Controller.text.trim().isEmpty &&
          avw4Controller.text.trim().isEmpty &&
          avw5Controller.text.trim().isEmpty &&
          avw6Controller.text.trim().isEmpty &&
          avw7Controller.text.trim().isEmpty &&
          avw8Controller.text.trim().isEmpty &&
          avw9Controller.text.trim().isEmpty &&
          avw10Controller.text.trim().isEmpty &&
          avw11Controller.text.trim().isEmpty &&
          avw12Controller.text.trim().isEmpty &&
          avw13Controller.text.trim().isEmpty &&
          avw14Controller.text.trim().isEmpty &&
          avw15Controller.text.trim().isEmpty &&
          avw16Controller.text.trim().isEmpty &&
          avw17Controller.text.trim().isEmpty &&
          avw18Controller.text.trim().isEmpty &&
          avw19Controller.text.trim().isEmpty &&
          avw20Controller.text.trim().isEmpty &&
          avw21Controller.text.trim().isEmpty &&
          avw22Controller.text.trim().isEmpty &&
          avw23Controller.text.trim().isEmpty &&
          avw24Controller.text.trim().isEmpty &&
          avw25Controller.text.trim().isEmpty) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter atleast one value.',
            'Attribute Value Wise');
        return false;
      }
    }

    /// Multi Attribute Wise
    if (multiAttrWiseController.text.trim().isNotEmpty) {
      if (mawAttr1Controller.text.trim().isNotEmpty) {
        if ((mawAttrCode1Controller.text.trim().isEmpty ||
            mawAttrValue1Controller.text.trim().isEmpty)) {
          Commons().showAlert(
              context,
              'You have selected Attribute header,please enter at least one value.',
              'Multi Attribute Wise');

          return false;
        }
      }
      if (mawAttr2Controller.text.trim().isNotEmpty) {
        if ((mawAttrCode2Controller.text.trim().isEmpty ||
            mawAttrValue2Controller.text.trim().isEmpty)) {
          Commons().showAlert(
              context,
              'You have selected Attribute header,please enter at least one value.',
              'Multi Attribute Wise');

          return false;
        }
      }
      if (mawAttr3Controller.text.trim().isNotEmpty) {
        if ((mawAttrCode3Controller.text.trim().isEmpty ||
            mawAttrValue3Controller.text.trim().isEmpty)) {
          Commons().showAlert(
              context,
              'You have selected Attribute header,please enter at least one value.',
              'Multi Attribute Wise');

          return false;
        }
      }
      if (mawAttr4Controller.text.trim().isNotEmpty) {
        if ((mawAttrCode4Controller.text.trim().isEmpty ||
            mawAttrValue4Controller.text.trim().isEmpty)) {
          Commons().showAlert(
              context,
              'You have selected Attribute header,please enter at least one value.',
              'Multi Attribute Wise');

          return false;
        }
      }
      if (mawAttr5Controller.text.trim().isNotEmpty) {
        if ((mawAttrCode5Controller.text.trim().isEmpty ||
            mawAttrValue5Controller.text.trim().isEmpty)) {
          Commons().showAlert(
              context,
              'You have selected Attribute header,please enter at least one value.',
              'Multi Attribute Wise');

          return false;
        }
      }

      if (mawAttr1Controller.text.trim().isEmpty &&
          mawAttr2Controller.text.trim().isEmpty &&
          mawAttr3Controller.text.trim().isEmpty &&
          mawAttr4Controller.text.trim().isEmpty &&
          mawAttr5Controller.text.trim().isEmpty) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Multi Attribute Wise');

        return false;
      }
    }

    /// Attribute Comparison

    if (attrCompValue1Controller.text.trim().isNotEmpty ||
        attrCompType1Controller.text.trim().isNotEmpty) {
      if ((attrCompFrom1Controller.text.trim().isEmpty ||
          attrCompTo1Controller.text.trim().isEmpty)) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Attribute Comparison');

        return false;
      }
    }

    if (attrCompValue2Controller.text.trim().isNotEmpty ||
        attrCompType2Controller.text.trim().isNotEmpty) {
      if ((attrCompFrom2Controller.text.trim().isEmpty ||
          attrCompTo2Controller.text.trim().isEmpty)) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Attribute Comparison');

        return false;
      }
    }

    if (attrCompValue3Controller.text.trim().isNotEmpty ||
        attrCompType3Controller.text.trim().isNotEmpty) {
      if ((attrCompFrom3Controller.text.trim().isEmpty ||
          attrCompTo3Controller.text.trim().isEmpty)) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Attribute Comparison');

        return false;
      }
    }

    if (attrCompValue4Controller.text.trim().isNotEmpty ||
        attrCompType4Controller.text.trim().isNotEmpty) {
      if ((attrCompFrom4Controller.text.trim().isEmpty ||
          attrCompTo4Controller.text.trim().isEmpty)) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Attribute Comparison');

        return false;
      }
    }

    if (attrCompValue5Controller.text.trim().isNotEmpty ||
        attrCompType5Controller.text.trim().isNotEmpty) {
      if ((attrCompFrom5Controller.text.trim().isEmpty ||
          attrCompTo5Controller.text.trim().isEmpty)) {
        Commons().showAlert(
            context,
            'You have selected Attribute header,please enter at least one value.',
            'Attribute Comparison');

        return false;
      }
    }

    return true;
  }

  _clearAll() {
    /// Resetting attributeList selection
    Future.sync(() => attributeList.forEach((element) {
          element.isSelected = false;
        }));

    /// Selected Items
    selectedCategory = '';
    selectedSubCategory = '';
    selectedType = '';
    selectedParty = '';
    selectedMachine = '';
    selectedBrand = '';
    selectedCount = '';
    selectedMaterial = '';
    selectedProcess = '';
    selectedShade = '';
    selectedItem = '';
    selectedUser = '';
    selectedSimilarItem = '';
    selectedFromDate = '';
    selectedToDate = '';

    selectedCatalog = '';
    selectedPartyItem = '';
    selectedPartyPo = '';
    selectedCatMachine = '';
    selectedFromRate = '';
    selectedToRate = '';

    codeCategory = '';
    codeSubCategory = '';
    codeParty = '';
    codeCount = '';
    codeShade = '';
    codeMachine = '';
    codeMaterial = '';
    codeItem = '';
    codeType = '';
    codeBrand = '';
    codeProcess = '';
    codeUser = '';
    codeSimilarItem = '';
    codeFromDate = '';
    codeToDate = '';
    codeCatMachine = '';
    codeCatalog = '';
    codePartyItem = '';
    codePartyPO = '';

    /// Controllers
    categoryController.clear();
    typeController.clear();
    partyController.clear();
    machineController.clear();
    brandController.clear();
    countController.clear();
    materialController.clear();
    processController.clear();
    shadeController.clear();
    itemController.clear();
    userController.clear();
    similarController.clear();
    fromRateController.clear();
    toRateController.clear();
    catalogController.clear();
    partyItemController.clear();
    partyPoController.clear();
    catMachineController.clear();

    /// Attribute Value Wise Controllers
    attrValueWiseController.clear();
    avw1Controller.clear();
    avw2Controller.clear();
    avw3Controller.clear();
    avw4Controller.clear();
    avw5Controller.clear();
    avw6Controller.clear();
    avw7Controller.clear();
    avw8Controller.clear();
    avw9Controller.clear();
    avw10Controller.clear();
    avw11Controller.clear();
    avw12Controller.clear();
    avw13Controller.clear();
    avw14Controller.clear();
    avw15Controller.clear();
    avw16Controller.clear();
    avw17Controller.clear();
    avw18Controller.clear();
    avw19Controller.clear();
    avw20Controller.clear();
    avw21Controller.clear();
    avw22Controller.clear();
    avw23Controller.clear();
    avw24Controller.clear();
    avw25Controller.clear();

    codeAttrValWise = '';

    codeMultiAttrWiseHeader = '';
    codeMultiAttrWise1 = '';
    codeMultiAttrWise2 = '';
    codeMultiAttrWise3 = '';
    codeMultiAttrWise4 = '';
    codeMultiAttrWise5 = '';

    codeAttrComp1 = '';
    codeAttrComp2 = '';
    codeAttrComp3 = '';
    codeAttrComp4 = '';
    codeAttrComp5 = '';

    /// Multi Attribute Wise Controllers
    multiAttrWiseController.clear();

    ///First Group
    mawAttr1Controller.clear();
    mawAttrCode1Controller.clear();
    mawAttrValue1Controller.clear();

    ///First Group
    mawAttr2Controller.clear();
    mawAttrCode2Controller.clear();
    mawAttrValue2Controller.clear();

    ///First Group
    mawAttr3Controller.clear();
    mawAttrCode3Controller.clear();
    mawAttrValue3Controller.clear();

    ///First Group
    mawAttr4Controller.clear();
    mawAttrCode4Controller.clear();
    mawAttrValue4Controller.clear();

    ///First Group
    mawAttr5Controller.clear();
    mawAttrCode5Controller.clear();
    mawAttrValue5Controller.clear();

    /// Attribute Comparison Controllers
    attrCompController.clear();

    /// First
    attrCompValue1Controller.clear();
    attrCompType1Controller.clear();
    attrCompFrom1Controller.clear();
    attrCompTo1Controller.clear();

    /// Second
    attrCompValue2Controller.clear();
    attrCompType2Controller.clear();
    attrCompFrom2Controller.clear();
    attrCompTo2Controller.clear();

    /// Third
    attrCompValue3Controller.clear();
    attrCompType3Controller.clear();
    attrCompFrom3Controller.clear();
    attrCompTo3Controller.clear();

    /// Fourth
    attrCompValue4Controller.clear();
    attrCompType4Controller.clear();
    attrCompFrom4Controller.clear();
    attrCompTo4Controller.clear();

    /// Fourth
    attrCompValue5Controller.clear();
    attrCompType5Controller.clear();
    attrCompFrom5Controller.clear();
    attrCompTo5Controller.clear();

    attrCompType1 = '';
    attrCompType2 = '';
    attrCompType3 = '';
    attrCompType4 = '';
    attrCompType5 = '';

    mCatList.clear();
    mCatList.addAll(categoryList);

    mSubCatList.clear();
    mSubCatList.addAll(subCategoryList);

    mTypeList.clear();
    mTypeList.addAll(typeList);

    mPartyList.clear();
    mPartyList.addAll(partyList);

    mMachineList.clear();
    mMachineList.addAll(machineList);

    mBrandList.clear();
    mBrandList.addAll(brandList);

    mCountList.clear();
    mCountList.addAll(countList);

    mMaterialList.clear();
    mMaterialList.addAll(materialList);

    mProcessList.clear();
    mProcessList.addAll(processList);

    mShadeList.clear();
    mShadeList.addAll(shadeList);

    mItemList.clear();
    mItemList.addAll(itemList);

    mUserList.clear();
    mUserList.addAll(userList);

    mCatalogList.clear();
    mCatalogList.addAll(catalogList);

    mPartyItemList.clear();
    mPartyItemList.addAll(partyItemList);

    mPartyPoList.clear();
    mPartyPoList.addAll(partyPoList);

    mCatMachineList.clear();
    mCatMachineList.addAll(catMachineList);

    resultList.clear();

    selectedFromDt = DateTime.now();
    selectedToDt = DateTime.now();

    isCatFile = false;
    isCatStatus = false;

    FocusScope.of(context).unfocus();
  }

  _getFilteredItems() {
    FocusScope.of(context).unfocus();

    /// All Empty Validation
    if (codeCategory!.isEmpty &&
        codeSubCategory!.isEmpty &&
        codeParty!.isEmpty &&
        codeCount!.isEmpty &&
        codeShade!.isEmpty &&
        codeMachine!.isEmpty &&
        codeMaterial!.isEmpty &&
        codeItem!.isEmpty &&
        codeType!.isEmpty &&
        codeBrand!.isEmpty &&
        codeProcess!.isEmpty &&
        codeUser!.isEmpty &&
        codeCatMachine!.isEmpty &&
        codeCatalog.isEmpty &&
        codePartyItem!.isEmpty &&
        codePartyPO!.isEmpty &&
        fromRateController.text.trim().isEmpty &&
        toRateController.text.trim().isEmpty &&
        selectedFromDate.isEmpty &&
        selectedToDate.isEmpty &&
        catalogController.text.trim().isEmpty &&
        attrValueWiseController.text.trim().isEmpty &&
        multiAttrWiseController.text.trim().isEmpty &&
        attrCompValue1Controller.text.trim().isEmpty &&
        attrCompValue2Controller.text.trim().isEmpty &&
        attrCompValue3Controller.text.trim().isEmpty &&
        attrCompValue4Controller.text.trim().isEmpty &&
        attrCompValue5Controller.text.trim().isEmpty &&
        !isCatFile &&
        !isCatStatus) {
      Commons()
          .showAlert(context, 'Please select at least one value.', 'Error');
      return null;
    }

    Commons().showProgressbar(context);

    String? userId = AppConfig.prefs.getString('user_id');

    Map<String, dynamic> data = {
      'user_id': userId,
      'category': codeCategory,
      'sub_cat': codeSubCategory,
      'party': codeParty,
      'count': codeCount,
      'shade': codeShade,
      'machine': codeMachine,
      'material': codeMaterial,
      'item_id': codeItem,
      'type': codeType,
      'brand': codeBrand,
      'process': codeProcess,
      'search_user_id': codeUser,
      'catalog_code': catalogController.text,
      'from_date': selectedFromDate,
      'from_rate': fromRateController.text.trim(),
      'to_rate': toRateController.text.trim(),
      'to_date': selectedToDate,
      'cat_machine': codeCatMachine,
      'party_po': codePartyPO,
      'party_item': codePartyItem,
      'catalog_with_file': isCatFile ? '1' : '0',
      'catalog_with_no_status': isCatStatus ? '1' : '0',
    };

    if (attrCompValue1Controller.text.trim().isNotEmpty ||
        attrCompValue2Controller.text.trim().isNotEmpty ||
        attrCompValue3Controller.text.trim().isNotEmpty ||
        attrCompValue4Controller.text.trim().isNotEmpty ||
        attrCompValue5Controller.text.trim().isNotEmpty) {
      var dt = {
        'attr_btw_status': 1,
        'attr_btw_code': _getAttrCompCode(),
        'attr_btw_type': _getAttrCompType(),
        'attr_btw_from': _getAttrCompFrom(),
        'attr_btw_to': _getAttrCompTo(),
        'attr_btw_item_type': _getAttrCompItemType()
      };

      data.addAll(dt);
    }

    debugPrint('ParamsAre => $data');

    var json = jsonEncode(data);
    WebService().post(context, AppConfig.searchItems, json).then((value) => {
          Navigator.pop(context),
          _parseResult(value!),
        });
  }

  _parseResult(Response value) async {
    if (value.statusCode == 200) {
      var data = jsonDecode(value.body);

      if (data['error'] == 'false') {
        List<ItemResultModel> itemList = [];
        List<ItemResultModel> catalogList = [];
        List<ItemResultModel> paraCatalogList = [];
        List<ItemResultModel> attrCatalogList = [];

        resultList.clear();

        imgBaseUrl = data['image_tiff_path'];

        var contentList = data['content'] as List;
        var catalogContentList = data['catalog_content'] as List;
        tempString =
            'Y: ${contentList.length} R: ${catalogContentList.length} ';

        catalogList.addAll(catalogContentList
            .map((e) => ItemResultModel.fromJSONParse2(e))
            .toList());

        itemList.addAll(
            contentList.map((e) => ItemResultModel.fromJSON(e)).toList());
        var blockedCatalog = data['block_catalog'] as List;
        var paraCatalogId = data['para_catalog_ids'] as List;
        resultList.addAll(catalogList);

        /// Checking for Blocked Items
        for (int i = 0; i < blockedCatalog.length; i++) {
          for (int j = 0; j < resultList.length; j++) {
            if (resultList[j].id == blockedCatalog[i]) {
              resultList[j].isEnabled = false;
            }
          }
        }

        /// Checking for Para Items
        for (int i = 0; i < paraCatalogId.length; i++) {
          for (int j = 0; j < resultList.length; j++) {
            if (resultList[j].id == paraCatalogId[i] &&
                resultList[j].itemType == '2') {
              resultList[j].itemType = '3';
              paraCatalogList.add(resultList[j]);
            }
          }
        }

        /// Checking for Attr Items
        for (int j = 0; j < resultList.length; j++) {
          if (resultList[j].itemType == '2') {
            attrCatalogList.add(resultList[j]);
          }
        }

        if (catalogList.isEmpty) {
          resultList.addAll(itemList);
        }

        debugPrint('ResultList ${resultList.length}');

        if (resultList.isEmpty) {
          Commons().showAlert(context, 'No item found', 'Item Search');
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemSearchResult(
                        resultList: resultList,
                        imgBaseUrl: imgBaseUrl,
                        comingFrom: widget.comingFrom,
                        tempCount: tempString,
                        paraList: paraCatalogList,
                        attrList: attrCatalogList,
                        catalogList: catalogList,
                        itemList: itemList,
                      )));
        }
      }
    }
  }

  String? _getAttrCompType() {
    var data;

    if (attrCompType1Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType1Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType1Controller.text.trim().toLowerCase()}";
      }
    } else {
      if (codeAttrComp1!.isNotEmpty) {
        if (data == null) {
          data = ',';
        } else {
          data = '$data,';
        }
      }
    }

    if (attrCompType2Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType2Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType2Controller.text.trim().toLowerCase()}";
      }
    } else {
      if (codeAttrComp2!.isNotEmpty) {
        if (data == null) {
          data = ',';
        } else {
          data = '$data,';
        }
      }
    }

    if (attrCompType3Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType3Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType3Controller.text.trim().toLowerCase()}";
      }
    } else {
      if (codeAttrComp3!.isNotEmpty) {
        if (data == null) {
          data = ',';
        } else {
          data = '$data,';
        }
      }
    }

    if (attrCompType4Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType4Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType4Controller.text.trim().toLowerCase()}";
      }
    } else {
      if (codeAttrComp4!.isNotEmpty) {
        if (data == null) {
          data = ',';
        } else {
          data = '$data,';
        }
      }
    }

    if (attrCompType5Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType5Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType5Controller.text.trim().toLowerCase()}";
      }
    } else {
      if (codeAttrComp5!.isNotEmpty) {
        if (data == null) {
          data = ',';
        } else {
          data = '$data,';
        }
      }
    }

    return data;
  }

  String? _getAttrCompFrom() {
    var data;

    if (attrCompFrom1Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompFrom1Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompFrom1Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompFrom2Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompFrom2Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompFrom2Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompFrom3Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompFrom3Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompFrom3Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompFrom4Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompFrom4Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompFrom4Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompFrom5Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompFrom5Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompFrom5Controller.text.trim().toLowerCase()}";
      }
    }

    return data;
  }

  String? _getAttrCompTo() {
    var data;

    if (attrCompTo1Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompTo1Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompTo1Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompTo2Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompTo2Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompTo2Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompTo3Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompTo3Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompTo3Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompTo4Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompTo4Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompTo4Controller.text.trim().toLowerCase()}";
      }
    }

    if (attrCompTo5Controller.text.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompTo5Controller.text.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompTo5Controller.text.trim().toLowerCase()}";
      }
    }

    return data;
  }

  String? _getAttrCompItemType() {
    var data;

    if (attrCompType1!.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType1!.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType1!.trim().toLowerCase()}";
      }
    }

    if (attrCompType2!.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType2!.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType2!.trim().toLowerCase()}";
      }
    }

    if (attrCompType3!.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType3!.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType3!.trim().toLowerCase()}";
      }
    }

    if (attrCompType4!.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType4!.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType4!.trim().toLowerCase()}";
      }
    }

    if (attrCompType5!.trim().isNotEmpty) {
      if (data == null) {
        data = '${attrCompType5!.trim().toLowerCase()}';
      } else {
        data = "$data,${attrCompType5!.trim().toLowerCase()}";
      }
    }

    return data;
  }

  String? _getAttrCompCode() {
    var data;

    if (codeAttrComp1!.isNotEmpty) {
      if (data == null) {
        data = '$codeAttrComp1';
      } else {
        data = "$data,$codeAttrComp1";
      }
    }

    if (codeAttrComp2!.isNotEmpty) {
      if (data == null) {
        data = '$codeAttrComp2';
      } else {
        data = "$data,$codeAttrComp2";
      }
    }

    if (codeAttrComp3!.isNotEmpty) {
      if (data == null) {
        data = '$codeAttrComp3';
      } else {
        data = "$data,$codeAttrComp3";
      }
    }

    if (codeAttrComp4!.isNotEmpty) {
      if (data == null) {
        data = '$codeAttrComp4';
      } else {
        data = "$data,$codeAttrComp4";
      }
    }

    if (codeAttrComp5!.isNotEmpty) {
      if (data == null) {
        data = '$codeAttrComp5';
      } else {
        data = "$data,$codeAttrComp5";
      }
    }

    return data;
  }
}

enum WidgetsFactory {
  Category,
  SubCategory,
  Type,
  Party,
  Machine,
  Brand,
  Count,
  Material,
  Process,
  Shade,
  Item,
  User,
  Catalog,
  PartyItem,
  PartyPO,
  CatMachine,
  SimilarItems,
  FromRate,
  ToRate,
  FromDate,
  ToDate,
  AttributeValueWise,
  MultiAttributeWise,
  AttributeComparison,
  Miscellaneous,
}
