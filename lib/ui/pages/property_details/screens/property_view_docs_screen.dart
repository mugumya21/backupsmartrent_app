import 'dart:io';

import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:smart_rent/configs/app_configs.dart';
import 'package:smart_rent/data_layer/models/property/property_documents_list_model.dart';
import 'package:smart_rent/res/values/strings.dart';
import 'package:smart_rent/utilities/app_init.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

class PropertyViewDocsScreen extends StatefulWidget {
  final PropertyDocumentsListModel propertyDocumentsListModel;
  const PropertyViewDocsScreen({Key? key, required this.propertyDocumentsListModel}) : super(key: key);

  @override
  State<PropertyViewDocsScreen> createState() => _PropertyViewDocsScreenState();
}

enum DocShown { sample, tutorial, hello, password }

class _PropertyViewDocsScreenState extends State<PropertyViewDocsScreen> {
  static const int _initialPage = 1;
  DocShown _showing = DocShown.sample;
  late PdfControllerPinch _pdfControllerPinch;

  var headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $currentUserToken'
  };

  @override
  void initState() {
    print('My APP URL =${appUrl}');
    _pdfControllerPinch = PdfControllerPinch(
      // document: PdfDocument.openAsset('assets/hello.pdf'),
      document: PdfDocument.openData(
        InternetFile.get(
          '$appUrl/api/main/documentspreview/${widget.propertyDocumentsListModel.id}',
          headers: headers
        ),
      ),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfControllerPinch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title:  Text(widget.propertyDocumentsListModel.name.toString()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              _pdfControllerPinch.previousPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          PdfPageNumber(
            controller: _pdfControllerPinch,
            builder: (_, loadingState, page, pagesCount) => Container(
              alignment: Alignment.center,
              child: Text(
                '$page/${pagesCount ?? 0}',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              _pdfControllerPinch.nextPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),

        ],
      ),
      body: PdfViewPinch(
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
          const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
          const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, error) => Center(child: Text(error.toString())),
        ),
        controller: _pdfControllerPinch,
      ),
    );
  }
}