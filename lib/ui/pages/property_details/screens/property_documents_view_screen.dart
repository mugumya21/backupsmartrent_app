import 'package:flutter/material.dart';
import 'package:smart_rent/data_layer/models/property/property_documents_list_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class PropertyDocumentsViewScreen extends StatelessWidget {
  final PropertyDocumentsListModel propertyDocumentsListModel;
  const PropertyDocumentsViewScreen({super.key, required this.propertyDocumentsListModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfPdfViewer.network(propertyDocumentsListModel.appUrl.toString()));
  }
  }

