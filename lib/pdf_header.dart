// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:research/ui/views/reports/model/model.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../shared/shared.dart';
// import '../../morning/morning.dart';
// import '../../navigation/navigation.dart';
//
// class PDFHeader extends StatelessWidget {
//   const PDFHeader({Key? key, this.researchData, this.searchData, required this.filePathUrl, required this.imagePathUrl})
//       : super(key: key);
//
//   final ResearchData? researchData;
//   final SearchData? searchData;
//   final String filePathUrl;
//   final String imagePathUrl;
//   @override
//   Widget build(BuildContext context) {
//
//    // print("filePathUrl ${filePathUrl} imagePathUrl ${imagePathUrl} document file is  ${researchData!.documentFile} image ${researchData!.imageFile}");
//     return Stack(
//       children: [
//         ClipPath(
//           clipper: MyClipper(0.6, 0.3),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topRight,
//                 end: Alignment.bottomLeft,
//                 colors: [
//                   kDarkGrey,
//                   const Color(0xFFCFD1D2).withOpacity(0.3),
//                   kLightRed,
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SafeArea(
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: MySvgIcon(
//                       iconPath: 'assets/images/back_arrow.svg',
//                       mHeight: 4.h,
//                     ),
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         "${researchData?.title ?? searchData?.title ?? ""}",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           color: kDarkGrey,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 10.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Consumer<BaseDataVM>(
//                     builder: (_, model, __) {
//                       // print(
//                       //     "documentFile is ${model.myResearch.filePath}${researchData?.documentFile}");
// //${model.myResearch.filePath}${researchData?.documentFile ?? searchData?.docNewName}
//                       return HeaderItems(
//                         fileUrl: '${researchData!.imageFile!.isEmpty ?  researchData!.documentFile  :  researchData!.imageFile}',
//                         filePathUrl: filePathUrl,
//                         imagePathUrl: imagePathUrl,
//
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//
//
//       ],
//     );
//   }
// }
//
// class HeaderItems extends StatelessWidget {
//   const HeaderItems({Key? key, required this.fileUrl, required this.filePathUrl, required this.imagePathUrl}) : super(key: key);
//
//   final String fileUrl;
//   final String filePathUrl;
//   final String imagePathUrl;
//
//
//   void _shareFile(BuildContext context) async {
//       print("share file is ${fileUrl.contains('pdf') ? filePathUrl : imagePathUrl }$fileUrl");
//     final box = context.findRenderObject() as RenderBox?;
//     var isShared = false;
//     if (Platform.isAndroid || Platform.isIOS) {
//       // print("we checking on IOS");
//       try {
//         var response = await http.get(Uri.parse('${fileUrl.contains('pdf') ? filePathUrl : imagePathUrl }$fileUrl'));
//         final directory = (await getTemporaryDirectory()).path;
//         final path = (fileUrl.contains('pdf'))
//             ? '$directory/file.pdf'
//             : '$directory/file.png';
//
//         File file = File(path);
//         file.writeAsBytesSync(response.bodyBytes);
//         List<XFile> files = [];
//         files.add(XFile(path));
//
//           // if(path.contains('png')){
//           //
//           //   // final tempDir = await getTemporaryDirectory();
//           //   // final file = await File('${tempDir.path}/image.jpg').create();
//           //   // file.writeAsBytesSync(response.bodyBytes);
//           //   Share.shareFiles(['${file.path}'], text: 'Great picture');
//           //   // Share.shareFiles(['assets/img_1.png'], text: 'Great picture');
//           //
//           // }
//
//
//         await Share.shareXFiles(
//           files,
//           subject: "BMA Capital Morning News",
//           sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
//         );
//
//
//
//
//         isShared = true;
//         print("File has been shared");
//       } catch (e) {
//        print("Sharing file ${e}");
//        MyMethods().toastMessage(e.toString());
//       }
//     }
//
//     if (!isShared) {
//       Share.share(fileUrl);
//     }
//   }
//
//   void _downloadFile(BuildContext context) async {
//     // print("download file is ${fileUrl} ${fileUrl.contains('pdf') ? filePathUrl : imagePathUrl }$fileUrl");
//     // Request storage permission
//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       try {
//         // print("fileUrl is http://15.206.35.78/uploads/research/${fileUrl} ");
//         //http://15.206.35.78/uploads/research/${fileUrl}
//         // var response = await http.get(Uri.parse(fileUrl));
//         var response = await http
//             .get(Uri.parse('${fileUrl.contains('pdf') ? filePathUrl : imagePathUrl}${fileUrl}'));
//         print("response body part is ${response.statusCode}");
//
//         var filePath = '';
//
//         String fileName = fileUrl.substring(fileUrl.lastIndexOf('/') + 1);
//         if (Platform.isIOS) {
//           final appDocumentsDir = await getApplicationDocumentsDirectory();
//           filePath = '${appDocumentsDir.path}/$fileName';
//         } else {
//           // String dir = '/storage/emulated/0/Documents';
//           String dir = '/storage/emulated/0/Download';
//           // done by AK to rename this random file name to file
//           filePath =
//               (fileUrl.contains('pdf')) ? '$dir/file.pdf' : '$dir/file.png';
//           // filePath = '$dir/$fileName'; // tauheed code
//         }
//
//         // final appDocumentsDir = await getExternalStorageDirectory();
//
//         File file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);
//
//         AppSnackBar.showSnackBar(context, 'File saved');
//         print('File saved in $filePath');
//       } catch (e) {
//         AppSnackBar.showSnackBar(context, '$e');
//       }
//     } else {
//       AppSnackBar.showSnackBar(context, 'Permission denied');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MenuBar(
//       style: const MenuStyle(
//         backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
//         elevation: MaterialStatePropertyAll(0.0),
//       ),
//       children: [
//         SubmenuButton(
//           menuChildren: [
//             MenuItemButton(
//               onPressed: () => _shareFile(context),
//               child: const MenuAcceleratorLabel('Share'),
//             ),
//             MenuItemButton(
//               onPressed: () => _downloadFile(context),
//               child: const MenuAcceleratorLabel('Download'),
//             ),
//           ],
//           child: SvgPicture.asset('assets/images/three_dots.svg'),
//         ),
//       ],
//     );
//   }
// }
