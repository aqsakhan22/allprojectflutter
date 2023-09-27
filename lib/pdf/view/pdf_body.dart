import 'package:firebaseflutterproject/bflow/base_data_vm.dart';
import 'package:firebaseflutterproject/bflow/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../morning/morning.dart';


class PDFBody extends StatefulWidget {
  const PDFBody({Key? key, this.researchData, this.searchData})
      : super(key: key);

  final ResearchData? researchData;
  final SearchData? searchData;

  @override
  State<PDFBody> createState() => _PDFBodyState();
}

class _PDFBodyState extends State<PDFBody> {
  final _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseDataVM>(
      builder: (context, model, child) {
        print(model.myResearch.filePath);
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: SfPdfViewer.network(
            // '${model.myResearch.filePath}${widget.researchData?.documentFile ?? widget.searchData?.docNewName}',
            'http://15.206.35.78/uploads/research/${widget.researchData?.documentFile ?? widget.searchData?.docNewName}',
            controller: _pdfViewerController,
            enableHyperlinkNavigation: true,
            canShowHyperlinkDialog: true,
          ),
        );
      },
    );
  }
}
