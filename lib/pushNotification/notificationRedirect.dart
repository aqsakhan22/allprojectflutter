//
//
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:provider/provider.dart';
// import 'package:research/core/flows/app_state.dart';
// import 'package:research/ui/shared/utility/topVariable.dart';
// import 'package:research/ui/views/navigation/model/base_data.dart';
// import 'package:research/ui/views/navigation/model/navigation_ids.dart';
// import 'package:research/ui/views/navigation/view_model/base_data_vm.dart';
// import 'package:flutter/material.dart';
// import 'package:research/ui/views/pdf/pdfCheck.dart';
// import 'package:research/ui/views/research/view/research_body.dart';
// class NotificationRedirect
//
//
// {
//   NotificationRedirect(){}
//   getId(){
//     final instance = Provider.of<BaseDataVM>(TopVariables.appNavigationKey.currentContext!, listen: false);
//     if (instance.baseData.baseMetaData == null) {
//       instance.callApi();
//     }
//     if (instance.baseData.baseMetaData?.categories?.length != null) {
//       for (Category category in instance.baseData.baseMetaData!.categories!) {
//         // print("Categories is ${category.id} ${category.categoryTitle}");
//         for (NavigationId nId in navigationIds) {
//
//           if (nId.title == category.categoryTitle) {
//             // print("NavigationId is ${nId.id} ${nId.title}");
//             nId.id = category.id;
//           }
//         }
//       }
//     }
//     if (instance.baseData.baseMetaData?.reportTypes?.length != null) {
//       for (ReportType reportType in instance.baseData.baseMetaData!.reportTypes!) {
//         print("report type is ${reportType.id} ${reportType.reportTypeTitle} ${reportType.mainCatId} screen id ${AppState().getScreenId}");
//         AppState().setScreenId(navigationIds[1].id!);
//         if (reportType.mainCatId == AppState().getScreenId) {
//           for (ResearchId research in researchIds) {
//             if (research.title == reportType.reportTypeTitle) {
//               research.id = reportType.id;
//             }
//           }
//         }
//       }
//     }
//     PersistentNavBarNavigator.pushNewScreen(
//       TopVariables.appNavigationKey.currentContext!,
//       screen: PDFCheck(fileUrl: "http://15.206.35.78/uploads/research/", imageUrl: "", docpath: '4009742751702365599.pdf',
//
//       ),
//       withNavBar: false,
//       pageTransitionAnimation: PageTransitionAnimation.cupertino,
//     );
//   //  Navigator.push(TopVariables.appNavigationKey.currentContext!, MaterialPageRoute(builder: (context) => ResearchBody() ));
//   //   PersistentNavBarNavigator.pushNewScreen(
//   //     TopVariables.appNavigationKey.currentContext!,
//   //     screen: const ResearchBody(),
//   //     withNavBar: true,
//   //     pageTransitionAnimation:
//   //     PageTransitionAnimation.cupertino,
//   //   );
//
//     // AppState().setScreenId(navigationIds[1].id!);
//
//   }
//
//
// }