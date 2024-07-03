import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_rent/ui/pages/payments/bloc/payment_bloc.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/form_title_widget.dart';
import 'package:http/http.dart' as http;

class PaymentDocumentsListScreen extends StatefulWidget {
  final int docId;
  final int fileTypeId;

  const PaymentDocumentsListScreen({
    super.key,
    required this.docId,
    required this.fileTypeId,
  });

  @override
  State<PaymentDocumentsListScreen> createState() =>
      _PaymentDocumentsListScreenState();
}

class _PaymentDocumentsListScreenState
    extends State<PaymentDocumentsListScreen> {
  final dio = Dio();

  final ScrollController scrollController = ScrollController();
  late bool isTitleElevated = false;

  String _filePath = '';

  Future<void> _downloadAndOpenFile(int fileId, String fileName) async {
    final url = 'https://rentest.smartcase.co.ug/main/documentsdownload/$fileId'; // Replace with your file URL
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
       print('shows file');
       final directory = await getTemporaryDirectory();
       final filePath = '${directory.path}/$fileName';
       final file = File(filePath);
       await file.writeAsBytes(response.bodyBytes).then((value) => {
       setState(() {
       _filePath = filePath;
       })
       }).then((value) => {
       OpenFilex.open(filePath)
       });


       print('directory = ${directory}');
       print('file Path = ${filePath}');
       print('new file Path = ${_filePath}');
       OpenFilex.open(filePath);

    } else {
      print('no file');
    }




    //
    // final file = File(filePath);
    // await file.writeAsBytes(response.bodyBytes);
    //
    // setState(() {
    //   _filePath = filePath;
    // });
    //
    // OpenFilex.open(filePath);
  }


  Future openFile({required String url, required String? fileName})async{
    final file = await downloadFile(url, fileName!);

    if(file == null) return;
    print('My Path: ${file!.path}');
    OpenFilex.open(file.path);

  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try{
      final response = await Dio().get(
          url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          )
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;

    } catch (e){
      return null;
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormTitle(
          cancelText: 'Back',
          hideSave: true,
          name: 'View Documents',
          addButtonText: '',
          onSave: () {},
          isElevated: true,
          onCancel: () {
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // FocusManager.instance.primaryFocus?.unfocus();
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollController.position.userScrollDirection ==
                    ScrollDirection.reverse) {
                  setState(() {
                    isTitleElevated = true;
                  });
                } else if (scrollController.position.userScrollDirection ==
                    ScrollDirection.forward) {
                  if (scrollController.position.pixels ==
                      scrollController.position.maxScrollExtent) {
                    setState(() {
                      isTitleElevated = false;
                    });
                  }
                }
                return true;
              },
              child: Scaffold(
                body: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(8),
                  children: [
                    LayoutBuilder(builder: (context, constraints) {
                      return Column(
                        children: [
                          BlocBuilder<PaymentBloc, PaymentState>(
                            builder: (context, state) {
                              if (state.status == PaymentStatus.initial) {
                                context.read<PaymentBloc>().add(
                                    LoadAllPaymentDocuments(
                                        widget.docId, widget.fileTypeId));
                              }
                              if (state.status == PaymentStatus.success) {
                                print("ITEMS: ${state.paymentsDocumentsList}");

                                return ListView.builder(
                                  shrinkWrap: true,
                                    itemCount:
                                        state.paymentsDocumentsList!.length,
                                    itemBuilder: (context, index) {
                                      var doc =
                                          state.paymentsDocumentsList![index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 5, top: 5),
                                        child: GestureDetector(
                                          onTap: ()async{
                                          // await  openFile(url: 'https://rentest.smartcase.co.ug/main/documentsdownload/${doc.id.toString()}', fileName: doc.name);
                                            await _downloadAndOpenFile(doc.id!, doc.name!);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppTheme.whiteColor,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppTheme.shadowColor.withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: .1,
                                                  offset: const Offset(0, 1), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: ListTile(
                                              leading: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                    image: DecorationImage(
                                                      // image: CachedNetworkImageProvider(
                                                      //     // 'https://img.freepik.com/free-vector/engraving-hand-drawn-golden-wedding-invitation-template_23-2149021171.jpg?w=740&t=st=1705229939~exp=1705230539~hmac=5aa81c5642161b975756f3467d303b0b9364eeb2cf9d68d56965519fcc3f3176',
                                                      //     // 'https://img.freepik.com/free-vector/illustration-gallery-icon_53876-27002.jpg?w=740&t=st=1711964663~exp=1711965263~hmac=f8816ae84edd27fc7bc6209553a47be60955ecaceff88f04d5932a3b6c805abd',
                                                      //   'https://rentest.smartcase.co.ug/main/documentsdownload/${doc.id.toString()}'
                                                      // ),
                                                      image: NetworkImage(
                                                        // 'https://img.freepik.com/free-vector/engraving-hand-drawn-golden-wedding-invitation-template_23-2149021171.jpg?w=740&t=st=1705229939~exp=1705230539~hmac=5aa81c5642161b975756f3467d303b0b9364eeb2cf9d68d56965519fcc3f3176',
                                                        // 'https://img.freepik.com/free-vector/illustration-gallery-icon_53876-27002.jpg?w=740&t=st=1711964663~exp=1711965263~hmac=f8816ae84edd27fc7bc6209553a47be60955ecaceff88f04d5932a3b6c805abd',
                                                          'https://rentest.smartcase.co.ug/main/documentsdownload/${doc.id.toString()}'
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )),
                                                width: 100,
                                              ),
                                              title: Text(doc.name.toString()),
                                              subtitle: Text('added on ${DateFormat('dd/MM/yyyy').format(doc.createdAt!)}'),
                                            ),
                                          ),
                                        ),
                                      );
                                    });

                                // return GridView.count(
                                //   crossAxisCount: 3,
                                //   shrinkWrap: true,
                                //   mainAxisSpacing: 1,
                                //   crossAxisSpacing: 1,
                                //   children: List.generate(
                                //       state.paymentsDocumentsList!.length,
                                //           (index) {
                                //         var doc =
                                //         state.paymentsDocumentsList![index];
                                //         return Card(
                                //           child: Column(
                                //             children: [
                                //               Container(
                                //                 decoration: BoxDecoration(
                                //                     borderRadius: BorderRadius.circular(15),
                                //                     image: DecorationImage(
                                //                       image: CachedNetworkImageProvider(
                                //                         // 'https://img.freepik.com/free-vector/engraving-hand-drawn-golden-wedding-invitation-template_23-2149021171.jpg?w=740&t=st=1705229939~exp=1705230539~hmac=5aa81c5642161b975756f3467d303b0b9364eeb2cf9d68d56965519fcc3f3176',
                                //                           'https://img.freepik.com/free-vector/illustration-gallery-icon_53876-27002.jpg?w=740&t=st=1711964663~exp=1711965263~hmac=f8816ae84edd27fc7bc6209553a47be60955ecaceff88f04d5932a3b6c805abd'),
                                //                       fit: BoxFit.cover,
                                //                     )),
                                //                 height: 100,
                                //                 width: 100,
                                //               ),
                                //               Expanded(child: Text(doc.name.toString(), maxLines: 1, overflow: TextOverflow.ellipsis,))
                                //             ],
                                //           ),
                                //         );
                                //       }),
                                // );
                              }
                              if (state.status == PaymentStatus.loading) {
                                return Center(
                                  child: LoadingWidget(),
                                );
                              }
                              if (state.status == PaymentStatus.empty) {
                                return Center(
                                  child: Text('No Documents'),
                                );
                              }

                              return Container();
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
