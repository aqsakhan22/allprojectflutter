import 'package:firebaseflutterproject/bflow/base_data_vm.dart';
import 'package:firebaseflutterproject/bflow/custom_icons/my_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';


class ReportsCompany extends StatelessWidget {
  const ReportsCompany({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        height: 70.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE6E7E8),
          borderRadius: BorderRadius.circular(25),
          boxShadow:  [
            BoxShadow(
              color: Colors.red,
              blurRadius: 15,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: const CompanyList(),
      ),
    );
  }
}

class CompanyList extends StatelessWidget {
  const CompanyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 1.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Company",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF720812),
                  fontSize: 12.sp,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Color(0xFF720812),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<BaseDataVM>(
            builder: (context, model, child) {
              return ListView.builder(
                itemCount: model.baseData.baseMetaData?.companies?.length,
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      RadioListTile<String>(
                        title: Text(
                          model.baseData.baseMetaData?.companies?[index].companyName ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        activeColor: Colors.red,
                        value: model.baseData.baseMetaData?.companies?[index].companyName ?? "",
                        groupValue: model.baseData.baseMetaData?.companies?[model.companyIndex == '' ? 0 : int.parse(model.companyIndex)].companyName,
                        dense: true,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        onChanged: (String? value) {
                          model.updateCompany(value ?? "");
                          model.updateCompanyIndex(index.toString());
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.h),
                        child: const Divider(
                            color: Color(0xFF720812), thickness: 0.7),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CompanyButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class CompanyButton extends StatelessWidget {
  const CompanyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Container(
        height: 4.h,
        width: 30.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF0013), Color(0xFF8F1218)],
          ),
        ),
        child: Consumer<BaseDataVM>(
          builder: (context, model, child) {
            return ElevatedButton(
              onPressed: () {
                if (model.company.isEmpty) {
                  model.updateCompany(
                      model.baseData.baseMetaData?.companies?[0].companyName);
                }
                Navigator.pop(context);
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "GO ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  MySvgIcon(iconPath: 'assets/images/go.svg', mHeight: 4.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
