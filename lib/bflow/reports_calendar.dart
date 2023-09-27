import 'package:firebaseflutterproject/bflow/base_data_vm.dart';
import 'package:firebaseflutterproject/bflow/reports_filter.dart';
import 'package:firebaseflutterproject/reports/model/reports.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';


class ReportsCalendar extends StatefulWidget {
  const ReportsCalendar({Key? key}) : super(key: key);

  @override
  State<ReportsCalendar> createState() => _ReportsCalendarState();
}

class _ReportsCalendarState extends State<ReportsCalendar> {
  final reports = Reports();

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (mContext) {
        return Container(
          height: 45.h,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                  child: child,
                ),
                Consumer<BaseDataVM>(
                  builder: (context, model, child) {
                    return CupertinoButton(
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Color(0xFFC3161C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if(model.date.isEmpty) {
                          model.updateDate(DateTime.now().toString().substring(0, 10));
                        }

                        Navigator.pop(mContext);

                        // if (reports.createdAt == "") {
                        //   reports.createdAt =
                        //       DateTime.now().toString().substring(0, 10);
                        // }
                        // reports.reportTypeId = AppState().getReportId.toString();
                        // reports.reportCategoryId = AppState().getScreenId.toString();
                        //
                        // final instance = Provider.of<ReportsVM>(
                        //   context,
                        //   listen: false,
                        // );
                        // instance.callApi(reports);
                        //
                        // Navigator.pop(mContext);
                        // reports.createdAt = "";
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final instance = Provider.of<BaseDataVM>(context);
    return CupertinoButton(
      onPressed: () => _showDialog(
        CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          mode: CupertinoDatePickerMode.date,
          use24hFormat: true,
          maximumDate: DateTime.now(),
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              instance.updateDate(newDate.toString().substring(0, 10));
              reports.createdAt = newDate.toString().substring(0, 10);

              // print('created attt: ${reports.createdAt}');
              // print(newDate.toString().substring(0, 10));
            });
          },
        ),
      ),
      child:
          FilterButton(title: (instance.date.isEmpty) ? 'Date' : instance.date),
    );
  }
}
