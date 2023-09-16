import 'package:flutter/material.dart';

import '../salary/employee_advance_comp_selection.dart';
import '../salary/employee_salary_comp_selection.dart';

class EmployeeManage{
  Widget employeeManage(permList, index, context, cardRadius, imgHeight, imgWidth, sizeb){
    switch (permList[index]) {
      case 'SALARY_ADVANCE_PAID':
        {
          return GestureDetector(
            onTap: () {
              /*if (!isImprest) {
                Commons.showToast('You profile does not have imprest code.');
                return;
              }*/
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EmpAdvanceCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/cashback.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),
                  ],
                ),
                sizeb,
                Text('Advance Entry',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }


      case 'SALARY_PAY_CHECK':
        {
          return GestureDetector(
            onTap: () {
              /*if (!isImprest) {
                Commons.showToast('You profile does not have imprest code.');
                return;
              }*/
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EmpSalaryCompSelection()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        radius: cardRadius,
                        child: Image.asset(
                          'images/salary.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        backgroundColor: Color(0xFFE5E5E5),
                      ),
                    ),

                  ],
                ),
                sizeb,
                Text('Employee\nSalary Paid',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          );
        }


      default:
    return Text('INVALID PERM');
    }
}
}