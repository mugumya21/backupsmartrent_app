import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_picker/full_picker.dart';
import 'package:get/get.dart';
import 'package:internet_file/internet_file.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/pages/property_details/screens/property_documents_view_screen.dart';
import 'package:smart_rent/ui/pages/property_details/screens/property_view_docs_screen.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/custom_image.dart';
import 'package:http/http.dart' as http;

class DetailsSuccessScreen extends StatefulWidget {
  final Property property;

  const DetailsSuccessScreen({super.key, required this.property});

  @override
  State<DetailsSuccessScreen> createState() => _DetailsSuccessScreenState();
}

class _DetailsSuccessScreenState extends State<DetailsSuccessScreen> {

  List<FullPickerOutput>? filePickerOutputs;

  final dio = Dio();

  String _filePath = '';

  Future<void> _downloadAndOpenFile(int fileId, String fileName) async {
    final url = widget.property.imageUrl.toString(); // Replace with your file URL
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
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<PropertyBloc, PropertyState>(
  listener: (context, state) {
    if(state.status ==  PropertyStatus.successUpload){
      Fluttertoast.showToast(msg: 'Property Document Uploaded Successfully',
          gravity: ToastGravity.TOP,
          backgroundColor: AppTheme.green
      );
      context.read<PropertyBloc>().add(LoadAllPropertyDocuments(widget.property.id!, widget.property.filetype! ));
    }if(state.status == PropertyStatus.errorUpload){
      Fluttertoast.showToast(msg: 'Property Document Uploaded Successfully',
          gravity: ToastGravity.TOP,
          backgroundColor: AppTheme.green
      );
      context.read<PropertyBloc>().add(LoadAllPropertyDocuments(widget.property.id!, widget.property.filetype! ));

    }

  },
  child: Stack(
      children: [
         CustomImage(
          // "assets/images/property_image.jpg",
          widget.property.imageUrl!.isEmpty ? "assets/images/propertyicon.png" : widget.property.imageUrl.toString(),
          isNetwork: widget.property.imageUrl!.isEmpty ? false : true,
          radius: 0,
          height: 300,
          width: double.infinity,
        ),
        Container(
          margin: EdgeInsets.only(top: screenHeight * .328),
          child: _buildInfo(),
        ),
      ],
    ),
);
  }

  Widget _buildInfo() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _buildPropertyDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.property.getName(),
                softWrap: true,
                overflow: TextOverflow.clip,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppTheme.darker,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_half_sharp,
                    color: Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.property.getNumber(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (widget.property.propertyCategoryModel != null)
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.tag,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.property.getPropertyCategoryName(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.property.getLocation(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.rulerCombined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${widget.property.getSquareMeters()} SQM${widget.property.id}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.sparkles,
                    color: Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.property.propertyType!.getName(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (true)
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.calendar,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat("dd/MM/yyyy").format(widget.property.createdAt!),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Documents:', style: AppTheme.appTitle6,),
                  GestureDetector(
                    onTap: ()async{


                      FullPicker(
                        multiFile: true,
                        // prefixName: 'Add Payment Files',
                        context: context,
                        file: true,
                        image: true,
                        imageCamera: kDebugMode,
                        imageCropper: true,
                        onError: (int value) {
                          print(
                              " ----  onError ----=$value");
                        },
                        onSelected: (value) async {
                          print(" ----  onSelected $value");
                          setState(() {
                            filePickerOutputs = [value];
                          });

                          // final pickedDocFileBytes = await value.file.first!.readAsBytes();
                          // var myDocFile = http.MultipartFile.fromBytes(
                          //     'file', pickedDocFileBytes,
                          //     filename: value.file.first!
                          //         .path
                          //         .split('/')
                          //         .last);
                          // print(" new multiple images $filePickerOutputs");
                          context.read<PropertyBloc>().add(UploadPropertyFileEvent(value.file.first!, widget.property.id!, widget.property.filetype!));

                        },
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Icon(Icons.file_present),
                            Text('Upload')
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              BlocBuilder<PropertyBloc, PropertyState>(
                builder: (context, state) {
                  if (state.status == PropertyStatus.initial) {
                    context.read<PropertyBloc>().add(
                        LoadAllPropertyDocuments(
                            widget.property.id!, widget.property.filetype!));
                  }
                  if (state.status == PropertyStatus.success) {
                    print("ITEMS: ${state.propertyDocumentsList}");

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.propertyDocumentsList == null ? 0 : state.propertyDocumentsList!.length,
                        itemBuilder: (context, index) {
                          var doc =
                          state.propertyDocumentsList![index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                            child: GestureDetector(
                              onTap: ()async{


                                if(doc.extension == 'pdf'){
                                  
                                  Get.to(() => PropertyViewDocsScreen(propertyDocumentsListModel: doc,));
                                  
                                  // Get.to(() => PropertyDocumentsViewScreen(propertyDocumentsListModel: doc));
                                } else if(doc.extension == 'jpeg' || doc.extension == 'jpg' || doc.extension == 'png' ) {
                                  Get.to(() =>
                                      PhotoView(
                                        imageProvider: CachedNetworkImageProvider(doc.appUrl.toString()),
                                      ));
                                } else {

                                }

                                // print('tapped');

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
                                  leading: doc.extension == 'pdf' ?
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                        ),
                                    child: Image.asset('assets/images/pdf.png'),
                                    width: 100,
                                  )
                                      : Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image:  CachedNetworkImageProvider(doc.appUrl.toString()),
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
                  if (state.status == PropertyStatus.loading) {
                    return Center(
                      child: LoadingWidget(),
                    );
                  }
                  if (state.status == PropertyStatus.loadingUpload) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Adding Property Document....'),
                        LoadingWidget(),
                      ],
                    );
                  }
                  if (state.status == PropertyStatus.empty) {
                    return Center(
                      child: Text('No Documents'),
                    );
                  }

                  return Container();
                },
              ),

            ],
          ),
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
