import 'package:firebaseflutterproject/bflow/base_data_vm.dart';
import 'package:firebaseflutterproject/bflow/reports_calendar.dart';
import 'package:firebaseflutterproject/bflow/reports_sector.dart';
import 'package:firebaseflutterproject/reports/view/reports_company.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';


class ReportsFilter extends StatelessWidget {
  const ReportsFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseDataVM>(
      builder: (context, model, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ReportsCalendar(),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) => const ReportsSector(),
              ),
              child: FilterButton(
                  title: (model.sector.isEmpty) ? 'Sector' : model.sector),
            ),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) => const ReportsCompany(),
              ),
              child: FilterButton(
                  title: (model.company.isEmpty) ? 'Company' : model.company),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  model.updateDate('');
                  model.updateSector('');
                  model.updateCompany('');
                  model.updateSectorIndex('');
                  model.updateCompanyIndex('');
                },
                child: Icon(
                  Icons.highlight_remove_sharp,
                  color: Colors.red,
                  size: 2.5.h,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3.5.h,
      width: 25.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF0013), Color(0xFF8F1218)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Center(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.sp,
                ),
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 3.h,
          ),
        ],
      ),
    );
  }
}
