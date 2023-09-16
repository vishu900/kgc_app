import 'package:dataproject2/utils/Utils.dart';

mixin Permissions {
  static const IndentApprove = 'IndentApprove';
  static const SaleOrderApprove = 'SaleOrderApprove';
  static const PurchaseOrderApprove = 'PurchaseOrderApprove';

  static const ATTENDANCE = 'ATTENDANCE';
  static const EMP_MODIFY = 'EMP_MODIFY';
  static const VISITOR_GATE_ENTRY = 'VISITOR_GATE_ENTRY';
  static const VISITOR_OUT = 'VISITOR_OUT';
  static const GATE_PASS = 'GATE_PASS';

  /// Emp Gate Pass
  static const GATE_ENTRY_CHALLAN = 'GATE_ENTRY_CHALLAN';
  static const GATE_ENTRY_BILL = 'GATE_ENTRY_BILL';
  static const INDENT_APPROVAL = 'INDENT_APPROVAL';
  static const PURCHASE_ORDERS = 'PURCHASE_ORDERS';
  static const PUR_BILL_APPROVAL = 'PUR_BILL_APPROVAL';
  static const PUR_PACKING_CHALLAN = 'PUR_PACKING_CHALLAN';
  static const PUR_PACKING_BILL = 'PUR_PACKING_BILL';
  static const SALE_ENQ = 'SALE_ENQ';
  static const SALE_QTN = 'SALE_QTN';
  static const SALE_ORDERS = 'SALE_ORDERS';
  static const SO_BOM_APPROVAL = 'SO_BOM_APPROVAL';
  static const EMP_GATEPASS = 'EMP_GATEPASS';
  static const EMP_IMAGES = 'EMP_IMAGES';
  static const SALARY_PAY_CHECK = 'SALARY_PAY_CHECK';
  static const SALARY_ADVANCE_PAID = 'SALARY_ADVANCE_PAID';
  static const FANDF = 'FANDF';
  static const CASH_PAYMENT = 'CASH_PAYMENT';
  static const CASH_RECEIPT = 'CASH_RECEIPT';
  static const CASH_PAYMENT_APPROVAL = 'CASH_PAYMENT_APPROVAL';
  static const CASH_RECEIPT_APPROVAL = 'CASH_RECEIPT_APPROVAL';
  static const MATERIAL_RECD_4_PROD_ORD = 'MATERIAL_RECD_4_PROD_ORD';
  static const MATERIAL_ISSUE_4_PROD_ORD = 'MATERIAL_ISSUE_4_PROD_ORD';
}

enum PermFlag { MOD, DEL }

enum PermType { INSERT, MODIFIED, ALL, SEARCH }

void savePermission(
    String compCode, String? permission, Map<String, dynamic> data) {
  AppConfig.prefs.getBool('${permission}_DEL');

  switch (compCode) {
    case COMP_KMT:
      {
        AppConfig.prefs
            .setString('KMT_$permission', getString(data, 'mode_flag'));
        AppConfig.prefs.setBool(
            'KMT_${permission}_DEL', getString(data, 'del_flag') == 'Y');
      }
      break;

    case COMP_BK:
      {
        AppConfig.prefs
            .setString('BK_$permission', getString(data, 'mode_flag'));
        AppConfig.prefs.setBool(
            'BK_${permission}_DEL', getString(data, 'del_flag') == 'Y');
      }
      break;

    case COMP_BK99:
      {
        AppConfig.prefs
            .setString('BK99_$permission', getString(data, 'mode_flag'));
        AppConfig.prefs.setBool(
            'BK99_${permission}_DEL', getString(data, 'del_flag') == 'Y');
      }
      break;

    case COMP_BK98:
      {
        AppConfig.prefs
            .setString('BK98_$permission', getString(data, 'mode_flag'));
        AppConfig.prefs.setBool(
            'BK98_${permission}_DEL', getString(data, 'del_flag') == 'Y');
      }
      break;

    case COMP_ITT:
      {
        AppConfig.prefs
            .setString('ITT_$permission', getString(data, 'mode_flag'));
        AppConfig.prefs.setBool(
            'ITT_${permission}_DEL', getString(data, 'del_flag') == 'Y');
      }
      break;

    case COMP_KMT_OVERSEAS:
      {
        AppConfig.prefs.setString(
            'KMT_OVERSEAS_$permission', getString(data, 'mode_flag'));
        AppConfig.prefs.setBool('KMT_OVERSEAS_${permission}_DEL',
            getString(data, 'del_flag') == 'Y');
      }
      break;
  }
}

/// I = Insert/search
/// M = modified/search
/// A = All (insert/modified/search)
/// S = Only search

bool? ifHasPermission(
    {String? compCode,
    String? permission,
    flag = PermFlag.MOD,
    permType = PermType.SEARCH}) {
  logIt(
      'ifHasPerm-> CompCode $compCode Permission $permission Flag $flag PermType $permType');

  switch (compCode) {
    case COMP_KMT:
      {
        //   logIt('ifHasPermission-> ${_getPermission('KMT_$permission', flag, permType)}');
        return _getPermission('KMT_$permission', flag, permType);
      }
    // break;

    case COMP_BK:
      {
        return _getPermission('BK_$permission', flag, permType);
      }
    // break;
    case COMP_BK99:
      {
        return _getPermission('BK99_$permission', flag, permType);
      }
    // break;

    case COMP_BK98:
      {
        return _getPermission('BK98_$permission', flag, permType);
      }
    // break;

    case COMP_ITT:
      {
        return _getPermission('ITT_$permission', flag, permType);
      }
    // break;

    case COMP_KMT_OVERSEAS:
      {
        return _getPermission('KMT_OVERSEAS_$permission', flag, permType);
      }
    //  break;

    default:
      return false;
  }
}

bool? _getPermission(String permission, PermFlag flag, PermType permType) {
  // logIt('getPermission-> $permission $flag $permType');

  if (flag == PermFlag.DEL) {
    return AppConfig.prefs.getBool('${permission}_DEL');
  } else {
    var res = AppConfig.prefs.getString('$permission');

    switch (permType) {
      case PermType.INSERT:
        return res == 'I' || res == 'A';
      case PermType.MODIFIED:
        return res == 'M' || res == 'A';
      case PermType.ALL:
        return res == 'A';
      case PermType.SEARCH:
        return res == 'S' || res == 'A';
      default:
        return false;
    }
  }
}
