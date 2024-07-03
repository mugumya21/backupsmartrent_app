import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_picker/full_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smart_rent/data_layer/models/smart_model.dart';
import 'package:smart_rent/ui/global/global.dart';
import 'package:smart_rent/ui/pages/properties/bloc/form/property_form_bloc.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';
import 'package:smart_rent/ui/pages/properties/widgets/loading_widget.dart';
import 'package:smart_rent/ui/pages/property_categories/bloc/property_category_bloc.dart';
import 'package:smart_rent/ui/pages/property_details/screens/property_view_docs_screen.dart';
import 'package:smart_rent/ui/pages/property_types/bloc/property_type_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/amount_text_field.dart';
import 'package:smart_rent/ui/widgets/app_drop_downs.dart';
import 'package:smart_rent/ui/widgets/app_max_textfield.dart';
import 'package:smart_rent/ui/widgets/auth_textfield.dart';
import 'package:smart_rent/ui/widgets/form_title_widget.dart';
import 'package:smart_rent/utilities/app_init.dart';

import '../../../../data_layer/models/property/property_response_model.dart';

class UpdatePropertyForm extends StatefulWidget {
  final String addButtonText;
  final bool isUpdate;
  final Property property;

  const UpdatePropertyForm(
      {super.key, required this.addButtonText, required this.isUpdate, required this.property});

  @override
  State<UpdatePropertyForm> createState() => _UpdatePropertyFormState();
}

class _UpdatePropertyFormState extends State<UpdatePropertyForm> {
  File? propertyPic;
  String? propertyImagePath;
  String? propertyImageExtension;
  String? propertyFileName;
  Uint8List? propertyBytes;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController sqmController = TextEditingController();

  int selectedPropertyTypeId = 0;
  int selectedPropertyCategoryId = 0;
  bool isTitleElevated = false;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.property.name.toString();
    addressController.text = widget.property.location.toString();
    descriptionController.text =  widget.property.description == null ? '' : widget.property.description.toString();
    locationController.text = widget.property.location.toString();
    sqmController.text = widget.property.squareMeters.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    sqmController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20)
            .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            BlocListener<PropertyFormBloc, PropertyFormState>(
              listener: (context, state) {
                if (state.status == PropertyFormStatus.success) {
                  Fluttertoast.showToast(
                      msg: 'Property Updated Successfully',
                      backgroundColor: Colors.green,
                      gravity: ToastGravity.TOP);
                  titleController.clear();
                  locationController.clear();
                  descriptionController.clear();
                  sqmController.clear();
                  selectedPropertyTypeId = 0;
                  selectedPropertyCategoryId = 0;
                  propertyPic = File('');
                  globalPropertiesContext
                      .read<PropertyBloc>()
                      .add(RefreshPropertiesEvent());
                  // Navigator.pop(context);
                  Get.back();
                }
                if (state.status == PropertyFormStatus.accessDenied) {
                  Fluttertoast.showToast(
                      msg: state.message.toString(),
                      gravity: ToastGravity.TOP);
                }
                if (state.status == PropertyFormStatus.error) {
                  Fluttertoast.showToast(
                      msg: state.message.toString(),
                      gravity: ToastGravity.TOP);
                }
              },
              child: FormTitle(
                name: '${widget.isUpdate ? "Edit" : "Edit"}  Property',
                addButtonText: widget.isUpdate ? "Update" : "Update",
                onSave: () {
                  if (titleController.text.isEmpty ||
                          locationController.text.isEmpty ||
                          sqmController.text.isEmpty
                      // propertyPic == null
                      ) {
                    Fluttertoast.showToast(
                        msg: 'fill in all fields', gravity: ToastGravity.TOP);
                  }  else {
                    context.read<PropertyFormBloc>().add(UpdatePropertyEvent(
                          currentUserToken.toString(),
                          titleController.text.trim().toString(),
                          locationController.text.trim().toString(),
                          sqmController.text.trim().toString(),
                          descriptionController.text.trim().toString(),
                          widget.property.propertyTypeId!,
                          widget.property.propertyCategoryId!,
                      widget.property.id!
                        ));
                  }
                },
                isElevated: true,
                onCancel: () {
                  titleController.clear();
                  locationController.clear();
                  descriptionController.clear();
                  sqmController.clear();
                  selectedPropertyTypeId = 0;
                  selectedPropertyCategoryId = 0;
                  propertyPic = File('');
                  Get.back();
                },
              ),
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
                    } else if (scrollController
                            .position.userScrollDirection ==
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
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(8),
                    children: [
                      LayoutBuilder(builder: (context, constraints) {
                        return Form(
                          child: Column(
                            children: [
                              AppTextField(
                                controller: titleController,
                                hintText: 'Property title',
                                obscureText: false,
                              ),

                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     BlocBuilder<PropertyTypeBloc,
                              //         PropertyTypeState>(
                              //       builder: (context, state) {
                              //         if (state.status ==
                              //             PropertyTypeStatus.initial) {
                              //           context.read<PropertyTypeBloc>().add(
                              //               LoadAllPropertyTypesEvent());
                              //         }
                              //         return Expanded(
                              //           child: CustomApiGenericDropdown<
                              //               SmartModel>(
                              //             hintText: 'Type',
                              //             menuItems:
                              //                 state.propertyTypes == null
                              //                     ? []
                              //                     : state.propertyTypes!,
                              //             onChanged: (value) {
                              //               setState(() {
                              //                 selectedPropertyTypeId =
                              //                     value!.getId();
                              //               });
                              //               print(value!.getId());
                              //             },
                              //           ),
                              //         );
                              //       },
                              //     ),
                              //     SizedBox(width: 10,),
                              //     BlocBuilder<PropertyCategoryBloc,
                              //         PropertyCategoryState>(
                              //       builder: (context, state) {
                              //         if (state.status ==
                              //             PropertyCategoryStatus.initial) {
                              //           context
                              //               .read<PropertyCategoryBloc>()
                              //               .add(
                              //                   LoadAllPropertyCategoriesEvent());
                              //         }
                              //         return Expanded(
                              //           child: CustomApiGenericDropdown<
                              //               SmartModel>(
                              //             hintText: 'Category',
                              //             menuItems:
                              //                 state.propertyCategories == null
                              //                     ? []
                              //                     : state.propertyCategories!,
                              //             onChanged: (value) {
                              //               print(value!.getId());
                              //               setState(() {
                              //                 selectedPropertyCategoryId =
                              //                     value.getId();
                              //               });
                              //             },
                              //           ),
                              //         );
                              //       },
                              //     ),
                              //   ],
                              // ),
                              //
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [

                                  Expanded(
                                    child: AppTextField(
                                      controller: locationController,
                                      hintText: 'Location',
                                      obscureText: false,
                                    ),
                                  ),

                                  SizedBox(width: 10,),
                                  
                                  Expanded(
                                    child:AmountTextField(
                                    controller: sqmController,
                                    hintText: 'sqm',
                                    obscureText: false,
                                  ),)
                                  
                                  // SizedBox(
                                  //   width: 190,
                                  //   child: AuthTextField(
                                  //     controller: locationController,
                                  //     hintText: 'Location',
                                  //     obscureText: false,
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   width: 190,
                                  //   child: AuthTextField(
                                  //     controller: sqmController,
                                  //     hintText: 'sqm',
                                  //     obscureText: false,
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AppMaxTextField(
                                controller: descriptionController,
                                hintText: 'Description',
                                obscureText: false,
                                fillColor: AppTheme.itemBgColor,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     FullPicker(
                              //       prefixName: 'add property',
                              //       context: context,
                              //       image: true,
                              //       imageCamera: kDebugMode,
                              //       imageCropper: true,
                              //       onError: (int value) {
                              //         print(" ----  onError ----=$value");
                              //       },
                              //       onSelected: (value) async {
                              //         print(" ----  onSelected ----");
                              //
                              //         setState(() {
                              //           propertyPic = value.file.first;
                              //           propertyImagePath =
                              //               value.file.first!.path;
                              //           propertyImageExtension = value
                              //               .file.first!.path
                              //               .split('.')
                              //               .last;
                              //           propertyFileName = value
                              //               .file.first!.path
                              //               .split('/')
                              //               .last;
                              //         });
                              //         propertyBytes =
                              //             await propertyPic!.readAsBytes();
                              //         print('MY PIC == $propertyPic');
                              //         print('MY path == $propertyImagePath');
                              //         print('MY bytes == $propertyBytes');
                              //         print(
                              //             'MY extension == $propertyImageExtension');
                              //         print(
                              //             'MY FILE NAME == $propertyFileName');
                              //       },
                              //     );
                              //   },
                              //   child: Container(
                              //     width: 175,
                              //     height: 200,
                              //     decoration: BoxDecoration(
                              //         color: AppTheme.itemBgColor,
                              //         borderRadius: BorderRadius.circular(15),
                              //         image: DecorationImage(
                              //             image: FileImage(
                              //                 propertyPic ?? File('')),
                              //             fit: BoxFit.cover)),
                              //     child: propertyPic == null ||
                              //             propertyPic!.path.isEmpty
                              //         ? Center(
                              //             child: Text('Upload Property Pic'),
                              //           )
                              //         : null,
                              //   ),
                              // ),

                              Align(
                                alignment: Alignment.centerLeft,
                                  child: Text('Select Feature Pic', style: AppTheme.appTitle6,)),
                              BlocListener<PropertyBloc, PropertyState>(
                                listener: (context, state) {
                                  if(state.status == PropertyStatus.successUploadPic){
                                    Fluttertoast.showToast(
                                        msg: 'Property Image Updated Successfully',
                                        backgroundColor: Colors.green,
                                        gravity: ToastGravity.TOP);
                                    context.read<PropertyBloc>().add(
                                        LoadAllPropertyDocuments(
                                            widget.property.id!, widget.property.filetype!));
                                    globalPropertiesContext
                                        .read<PropertyBloc>()
                                        .add(RefreshPropertiesEvent());
                                    // Navigator.pop(context);
                                    // Get.back();
                                  }
                                },
                                child: BlocBuilder<PropertyBloc, PropertyState>(
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
                                          return doc.extension == 'jpeg' || doc.extension == 'jpg' || doc.extension == 'png' ?  Padding(
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
                                                  subtitle: Align(
                                                    alignment: Alignment.centerRight,
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          context.read<PropertyBloc>().add(UploadPropertyMainImageEvent(
                                                            doc.id!,
                                                            doc.externalKey!,
                                                            doc.documentTypeId!
                                                          ));
                                                        },
                                                          child: Text('use', style: AppTheme.blueAppTitle3,))),
                                                ),
                                              ),
                                            ),
                                          ) : Container();
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
                                  if (state.status == PropertyStatus.loadingUploadPic) {
                                    return const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Updating Property Main Image....'),
                                        LoadingWidget(),
                                      ],
                                    );
                                  }
                                  if (state.status == PropertyStatus.loading) {
                                    return  LoadingWidget();
                                  }
                                  if (state.status == PropertyStatus.empty) {
                                    return Center(
                                      child: Text('No Pictures'),
                                    );
                                  }

                                  return Container();
                                },
                              ),
),


                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

//
// addPropertyForm(BuildContext context, String addButtonText,
//     VoidCallback submitFormData, bool isTitleElevated, bool isUpdate){
//
//   showModalBottomSheet(
//       useSafeArea: true,
//       isScrollControlled: true,
//       context: context, builder: (context){
//
//     return  StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           File? propertyPic;
//           String? propertyImagePath;
//           String? propertyImageExtension;
//           String? propertyFileName;
//           Uint8List? propertyBytes;
//
//           final TextEditingController titleController = TextEditingController();
//           final TextEditingController addressController = TextEditingController();
//           final TextEditingController descriptionController = TextEditingController();
//           final TextEditingController locationController = TextEditingController();
//           final TextEditingController sqmController = TextEditingController();
//
//           List<String> searchableList = ['Orange', 'Watermelon', 'Banana'];
//
//           int selectedPropertyTypeId = 0;
//           int selectedPropertyCategoryId = 0;
//
//           final ScrollController scrollController = ScrollController();
//
//
//
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 20)
//                 .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
//             child: Column(
//               children: [
//                 FormTitle(
//                   name: '${isUpdate ? "Edit" : "New"}  Property',
//                   addButtonText: isUpdate ? "Update" : "Add",
//                   onSave: submitFormData,
//                   isElevated: true,
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       // FocusManager.instance.primaryFocus?.unfocus();
//                     },
//                     child: NotificationListener<ScrollNotification>(
//                       onNotification: (scrollNotification) {
//                         if (scrollController.position.userScrollDirection ==
//                             ScrollDirection.reverse) {
//                           setState(() {
//                             isTitleElevated = true;
//                           });
//                         } else if (scrollController.position.userScrollDirection ==
//                             ScrollDirection.forward) {
//                           if (scrollController.position.pixels ==
//                               scrollController.position.maxScrollExtent) {
//                             setState(() {
//                               isTitleElevated = false;
//                             });
//                           }
//                         }
//                         return true;
//                       },
//                       child: ListView(
//                         controller: scrollController,
//                         padding: const EdgeInsets.all(8),
//                         children: [
//                           LayoutBuilder(builder: (context, constraints) {
//                             return Form(
//                               child: Column(
//                                 children: [
//
//                                   AuthTextField(
//                                     controller: titleController,
//                                     hintText: 'Property title',
//                                     obscureText: false,
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       SizedBox(
//                                         width: 175,
//                                         child: BlocBuilder<PropertyTypeBloc,
//                                             PropertyTypeState>(
//                                           builder: (context, state) {
//                                             if(state.status == PropertyTypeStatus.initial){
//                                               context.read<PropertyTypeBloc>().add(LoadAllPropertyTypesEvent());
//                                             }
//                                             return CustomApiGenericDropdown<
//                                                 SmartModel>(
//                                               hintText: 'Type',
//                                               menuItems: state.propertyTypes == null
//                                                   ? []
//                                                   : state.propertyTypes!,
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   selectedPropertyTypeId =
//                                                       value!.getId();
//                                                 });
//                                                 print(value!.getId());
//                                               },
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 175,
//                                         child: BlocBuilder<PropertyCategoryBloc,
//                                             PropertyCategoryState>(
//                                           builder: (context, state) {
//                                             if(state.status == PropertyCategoryStatus.initial){
//                                               context.read<PropertyCategoryBloc>().add(LoadAllPropertyCategoriesEvent());
//                                             }
//                                             return CustomApiGenericDropdown<
//                                                 SmartModel>(
//                                               hintText: 'Category',
//                                               menuItems:
//                                               state.propertyCategories == null
//                                                   ? []
//                                                   : state.propertyCategories!,
//                                               onChanged: (value) {
//                                                 print(value!.getId());
//                                                 setState(() {
//                                                   selectedPropertyCategoryId =
//                                                       value.getId();
//                                                 });
//                                               },
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       SizedBox(
//                                         width: 175,
//                                         child: AuthTextField(
//                                           controller: locationController,
//                                           hintText: 'Location',
//                                           obscureText: false,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 175,
//                                         child: AuthTextField(
//                                           controller: sqmController,
//                                           hintText: 'sqm',
//                                           obscureText: false,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   AppMaxTextField(
//                                     controller: descriptionController,
//                                     hintText: 'Description',
//                                     obscureText: false,
//                                     fillColor: AppTheme.itemBgColor,
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       FullPicker(
//                                         prefixName: 'add property',
//                                         context: context,
//                                         image: true,
//                                         imageCamera: kDebugMode,
//                                         imageCropper: true,
//                                         onError: (int value) {
//                                           print(" ----  onError ----=$value");
//                                         },
//                                         onSelected: (value) async {
//                                           print(" ----  onSelected ----");
//
//                                           setState(() {
//                                             propertyPic = value.file.first;
//                                             propertyImagePath =
//                                                 value.file.first!.path;
//                                             propertyImageExtension = value
//                                                 .file.first!.path
//                                                 .split('.')
//                                                 .last;
//                                             propertyFileName = value
//                                                 .file.first!.path
//                                                 .split('/')
//                                                 .last;
//                                           });
//                                           propertyBytes =
//                                           await propertyPic!.readAsBytes();
//                                           print('MY PIC == $propertyPic');
//                                           print('MY path == $propertyImagePath');
//                                           print('MY bytes == $propertyBytes');
//                                           print(
//                                               'MY extension == $propertyImageExtension');
//                                           print(
//                                               'MY FILE NAME == $propertyFileName');
//                                         },
//                                       );
//                                     },
//                                     child: Container(
//                                       width: 175,
//                                       height: 200,
//                                       decoration: BoxDecoration(
//                                           color: AppTheme.itemBgColor,
//                                           borderRadius:
//                                           BorderRadius.circular(15),
//                                           image: DecorationImage(
//                                               image: FileImage(
//                                                   propertyPic ?? File('')),
//                                               fit: BoxFit.cover)),
//                                       child: propertyPic == null ||
//                                           propertyPic!.path.isEmpty
//                                           ? Center(
//                                         child: Text('Upload Property Pic'),
//                                       )
//                                           : null,
//                                     ),
//                                   ),
//
//                                 ],
//                               ),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//     );
//   });
// }
