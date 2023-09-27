import 'package:firebaseflutterproject/bflow/search.dart';
import 'package:firebaseflutterproject/morning/model/research.dart';
import 'package:firebaseflutterproject/pdf/view/pdf_body.dart';
import 'package:firebaseflutterproject/pdf/view/pdf_header.dart';
import 'package:flutter/material.dart';


class PDFScreen extends StatelessWidget {
  const PDFScreen({Key? key, this.researchData, this.searchData})
      : super(key: key);

  final ResearchData? researchData;

  final SearchData? searchData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child:
                PDFHeader(researchData: researchData, searchData: searchData),
          ),
          Expanded(
            flex: 4,
            child: PDFBody(researchData: researchData, searchData: searchData),
          ),
        ],
      ),
    );
  }
}
