import 'dart:io';
import 'package:firebaseflutterproject/bflow/base_data_vm.dart';
import 'package:firebaseflutterproject/bflow/custom_icons/my_svg_icon.dart';
import 'package:firebaseflutterproject/bflow/search.dart';
import 'package:firebaseflutterproject/bflow/shared/custom_classes/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

import '../../bflow/custom_design/my_clipper.dart';
import '../../morning/morning.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';


class PDFHeader extends StatelessWidget {
  const PDFHeader({Key? key, this.researchData, this.searchData})
      : super(key: key);

  final ResearchData? researchData;
  final SearchData? searchData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: MyClipper(0.6, 0.3),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.grey,
                  const Color(0xFFCFD1D2).withOpacity(0.3),
                  Color(0xFFC3161C),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: MySvgIcon(
                      iconPath: 'assets/images/back_arrow.svg',
                      mHeight: 4.h,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        researchData?.title ?? searchData?.title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                  Consumer<BaseDataVM>(
                    builder: (_, model, __) {
                      return HeaderItems(
                        fileUrl:
                            '${model.myResearch.filePath}${researchData?.documentFile ?? searchData?.docNewName}',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderItems extends StatelessWidget {
  const HeaderItems({Key? key, required this.fileUrl}) : super(key: key);

  final String fileUrl;

  void _shareFile() async {
    var isShared = false;
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        var response = await http.get(Uri.parse(fileUrl));
        final directory = (await getTemporaryDirectory()).path;
        final path = (fileUrl.contains('pdf'))
            ? '$directory/file.pdf'
            : '$directory/file.png';

        File file = File(path);
        file.writeAsBytesSync(response.bodyBytes);

        List<XFile> files = [];
        files.add(XFile(path));
        await Share.shareXFiles(files);
        isShared = true;
      } catch (e) {
        print(e);
      }
    }

    if (!isShared) {
      Share.share(fileUrl);
    }
  }

  void _downloadFile(BuildContext context) async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        var response = await http.get(Uri.parse(fileUrl));
        var filePath = '';
        String fileName = fileUrl.substring(fileUrl.lastIndexOf('/') + 1);

        if (Platform.isIOS) {
          final appDocumentsDir = await getApplicationDocumentsDirectory();
          filePath = '${appDocumentsDir.path}/$fileName';
        } else {
          String dir = '/storage/emulated/0/Documents';
          filePath = '$dir/$fileName';
        }

        // final appDocumentsDir = await getExternalStorageDirectory();

        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        AppSnackBar.showSnackBar(context, 'File saved');
        print('File saved in $filePath');
      } catch (e) {
        AppSnackBar.showSnackBar(context, '$e');
      }
    } else {
      AppSnackBar.showSnackBar(context, 'Permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      style: const MenuStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
        elevation: MaterialStatePropertyAll(0.0),
      ),
      children: [
        SubmenuButton(
          menuChildren: [
            MenuItemButton(
              onPressed: () => _shareFile(),
              child: const MenuAcceleratorLabel('Share'),
            ),
            MenuItemButton(
              onPressed: () => _downloadFile(context),
              child: const MenuAcceleratorLabel('Download'),
            ),
          ],
          child: SvgPicture.asset('assets/images/three_dots.svg'),
        ),
      ],
    );
  }
}
