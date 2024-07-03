import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_rent/data_layer/models/property/property_response_model.dart';
import 'package:smart_rent/ui/pages/account/bloc/account_bloc.dart';
import 'package:smart_rent/ui/pages/floors/bloc/floor_bloc.dart';
import 'package:smart_rent/ui/pages/floors/bloc/form/floor_form_bloc.dart';
import 'package:smart_rent/ui/pages/properties/bloc/property_bloc.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/app_drop_downs.dart';
import 'package:smart_rent/ui/widgets/app_max_textfield.dart';
import 'package:smart_rent/ui/widgets/auth_textfield.dart';
import 'package:smart_rent/ui/widgets/form_title_widget.dart';
import 'package:smart_rent/utilities/app_init.dart';

class ChangePasswordForm extends StatelessWidget {
  final String addButtonText;
  final bool isUpdate;

  ChangePasswordForm(
      {super.key, required this.addButtonText, required this.isUpdate});

  final TextEditingController floorController = TextEditingController();
  final TextEditingController floorDescriptionController = TextEditingController();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController = TextEditingController();

  late SingleValueDropDownController _propertyModelCont;

  bool isTitleElevated = false;
  String? floorName;
  int selectedPropertyId = 0;

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _propertyModelCont = SingleValueDropDownController();
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20)
                .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [

                BlocListener<AccountBloc, AccountState>(
                  listener: (context, state) {
                    if (state.status == AccountStatus.success) {
                      Fluttertoast.showToast(
                          msg: 'Password Changed Successfully',
                          backgroundColor: Colors.green,
                          gravity: ToastGravity.TOP);
                      oldPasswordController.clear();
                      passwordController.clear();
                      passwordConfirmationController.clear();
                      Navigator.pop(context);
                    }
                    if (state.status == AccountStatus.accessDenied) {
                      Fluttertoast.showToast(
                          msg: state.message.toString(), gravity: ToastGravity.TOP);
                    }
                    if (state.status == AccountStatus.error) {
                      Fluttertoast.showToast(
                          msg: state.message.toString(), gravity: ToastGravity.TOP);
                    }
                  },
                  child: FormTitle(
                    name: "Change Password",
                    addButtonText: "Update",
                    onSave: () {
                      if (oldPasswordController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'old password required',
                            gravity: ToastGravity.TOP);
                      } else if (passwordController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'new password required',
                            gravity: ToastGravity.TOP);
                      } else if (passwordController.text.length <6) {
                        Fluttertoast.showToast(
                            msg: 'min password length is 6',
                            gravity: ToastGravity.TOP);
                      } else if (passwordConfirmationController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'confirm password required',
                            gravity: ToastGravity.TOP);
                      }  else if (passwordConfirmationController.text.length <6) {
                        Fluttertoast.showToast(
                            msg: 'min password length is 6',
                            gravity: ToastGravity.TOP);
                      } else if (passwordController.text != passwordConfirmationController.text ) {
                        Fluttertoast.showToast(
                            msg: 'mismatching passwords',
                            gravity: ToastGravity.TOP);
                      }else {
                        context.read<AccountBloc>().add(ChangePasswordEvent(
                          currentUserToken.toString(),
                          currentSmartUserModel!.id!,
                          oldPasswordController.text.toString(),
                          passwordController.text.toString(),
                          passwordConfirmationController.text.toString(),
                          true
                        ));
                      }
                    },
                    isElevated: true,
                    onCancel: () {
                      oldPasswordController.clear();
                      passwordController.clear();
                      passwordConfirmationController.clear();
                      Navigator.pop(context);
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
                                    controller: oldPasswordController,
                                    hintText: 'Old Password.',
                                    obscureText: false,
                                    onChanged: (value) {

                                    },
                                  ),
                                  SizedBox(height: 10,),

                                  AppTextField(
                                    controller: passwordController,
                                    hintText: 'New Password.',
                                    obscureText: false,
                                    onChanged: (value) {

                                    },
                                  ),
                                  SizedBox(height: 10,),

                                  AppTextField(
                                    controller: passwordConfirmationController,
                                    hintText: 'Confirm New Password.',
                                    obscureText: false,
                                    onChanged: (value) {

                                    },
                                  ),
                                  const SizedBox(height: 10),

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
//                                     height: 10
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
//                                     height: 10
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
//                                     height: 10
//                                   ),
//                                   AppMaxTextField(
//                                     controller: descriptionController,
//                                     hintText: 'Description',
//                                     obscureText: false,
//                                     fillColor: AppTheme.itemBgColor,
//                                   ),
//                                   SizedBox(
//                                     height: 10
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
