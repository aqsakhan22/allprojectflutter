
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';



class PDFCheck extends StatefulWidget {
  const PDFCheck({Key? key,  required this.fileUrl, required this.imageUrl, required this.docpath})
      : super(key: key);

  final String fileUrl;
  final String imageUrl;
  final String docpath;


  @override
  State<PDFCheck> createState() => _PDFCheckState();
}

class _PDFCheckState extends State<PDFCheck> {
  final _pdfViewerController = PdfViewerController();


  @override
  Widget build(BuildContext context) {
    // print("Pdf Document file is image ${widget.fileUrl}${widget.researchData?.documentFile} ${widget.imageUrl}${widget.researchData?.imageFile}");
    return
  Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
    ),
  body:       Column(
    children: [
      Text("File name will be here"),
  Expanded(child:     Padding(
      padding: const EdgeInsets.all(5.0),
      child:
      widget.imageUrl.isEmpty ?
      SfPdfViewer.network(
        // '${model.myResearch.filePath}${widget.researchData?.documentFile ?? widget.searchData?.docNewName}',
        '${widget.fileUrl}${widget.docpath}',
        controller: _pdfViewerController,
        enableHyperlinkNavigation: true,
        canShowHyperlinkDialog: true,
      )
          :
      CachedNetworkImage(
        imageUrl: '${widget.imageUrl}${widget.imageUrl}',
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: Colors.blue,),
        ),

      )
  ),)
    ],
  ),
  );
  }
}
