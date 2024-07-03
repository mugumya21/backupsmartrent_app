
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_picker/full_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_rent/data_layer/models/payment/payment_list_model.dart';
import 'package:smart_rent/data_layer/models/payment/payment_schedules_model.dart';

import 'package:smart_rent/data_layer/models/tenant_unit/tenant_unit_model.dart';
import 'package:smart_rent/data_layer/services/receipt/payment_receipt_pdf.dart';
import 'package:smart_rent/ui/pages/payments/bloc/payment_bloc.dart';
import 'package:smart_rent/ui/pages/payments/layouts/payment_documents_list_layout_screen.dart';
import 'package:smart_rent/ui/pages/tenant_unit/bloc/tenant_unit_bloc.dart';
import 'package:smart_rent/ui/pages/tenant_unit/layouts/test.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/app_search_textfield.dart';
import 'package:smart_rent/ui/widgets/appbar_content.dart';
import 'package:smart_rent/utilities/app_init.dart';
import 'package:smart_rent/utilities/extra.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';


class PaymentDetailsScreen extends StatefulWidget {
  final PaymentListModel paymentListModel;
  const PaymentDetailsScreen({super.key, required this.paymentListModel});

  @override
  State<PaymentDetailsScreen> createState() => _TenantUnitDetailsPageLayoutState();
}

class _TenantUnitDetailsPageLayoutState extends State<PaymentDetailsScreen> {

  List<FullPickerOutput>? filePickerOutputs;

  late PaymentDetailsDataSource paymentDetailsDataSource;

  final TextEditingController searchController = TextEditingController();

  late List<SchedulesPerPayment> filteredData;

  final PaymentReceiptPrintPdf paymentReceiptPrintPdf = PaymentReceiptPrintPdf();


  int number = 0;

  File? paymentImage;
  String paymentImageError = '';

  Future<String> getFilePath(String path) async {
    // Get the application documents directory
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    // Generate a unique filename
    String filePath = '${appDocumentsDirectory.path}/shot';
    return filePath;
  }
  
  pickPaymentImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final tempImage = File(image.path);
      setState(() {
        paymentImage = tempImage;
      });
    } on PlatformException {
      print('Failed to Pick Payment Image');
    }
  }


  void filterData(String query) {

    // setState(() {
    //   filteredData.where((schedule) =>
    //   DateFormat('d MMM, yy')
    //       .format(schedule.fromDate!)
    //       .toString()
    //       .toLowerCase()
    //       .contains(query.toLowerCase()) ||
    //       DateFormat('d MMM, yy')
    //           .format(schedule.fromDate!)
    //           .toLowerCase()
    //           .contains(query.toLowerCase()))
    //       .toList();
    // });

    print('My Filtered List $filteredData');
    setState(() {
      filteredData = widget.paymentListModel.schedulesPerPayment!
          .where((schedule) =>
      DateFormat('d MMM, yy')
          .format(schedule.schedule!.fromDate!)
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()) ||
          DateFormat('d MMM, yy')
              .format(schedule.schedule!.toDate!)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentDetailsDataSource = PaymentDetailsDataSource(paymentData: widget.paymentListModel.schedulesPerPayment!);
    filteredData = widget.paymentListModel.schedulesPerPayment!;
    // paymentDetailsDataSource = TenantUnitPaymentScheduleDataSource(paymentData: filteredData);

  }


  @override
  Widget build(BuildContext context) {

    int sumListRecursive(List<SchedulesPerPayment> numbers) {
      if (numbers.isEmpty) {
        return 0;
      }
      return numbers.first.schedule!.paid! + sumListRecursive(numbers.sublist(1));
    }

    return BlocProvider<TenantUnitBloc>(
      create: (context) => TenantUnitBloc(),
      child: Scaffold(
        backgroundColor: AppTheme.whiteColor,
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          title: const TitleBarImageHolder(),
          foregroundColor: AppTheme.whiteColor,
          centerTitle: true,
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Padding(
                padding:  EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Details', style: AppTheme.appTitle7,),
                    Row(
                      children: [
                        Text('Tenant:', style: AppTheme.appTitle7,),
                        SizedBox(width: 5,),
                        // Text(widget.paymentListModel.tenantProfile!.first.firstName!.name.toString(), style: AppTheme.blueAppTitle3,),
                        // Text(widget.paymentListModel.tenantType!.id == 1
                        //     ? '${widget.paymentListModel.tenantProfile!.first.firstName!.name.capitalizeFirst.toString().replaceAll('_', ' ')} ${widget.paymentListModel.tenantProfile!.first.lastName!.capitalizeFirst.toString().replaceAll('_', ' ')}'
                        //     : '${widget.paymentListModel.tenantProfile!.first.companyName!.name.capitalizeFirst.toString().replaceAll('_', ' ')}', style: AppTheme.blueAppTitle3,),
                        Text(widget.paymentListModel.tenantType!.id == 1
                            ? '${widget.paymentListModel.tenantProfile!.first.firstName == null ? '' : widget.paymentListModel.tenantProfile!.first.firstName!.capitalizeFirst.toString().replaceAll('_', ' ')} ${widget.paymentListModel.tenantProfile!.first.lastName!.capitalizeFirst.toString().replaceAll('_', ' ')}'
                            : '${widget.paymentListModel.tenantProfile!.first.companyName!.capitalizeFirst.toString().replaceAll('_', ' ')}', style: AppTheme.blueAppTitle3,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text('Unit:', style: AppTheme.appTitle7,),
                              SizedBox(width: 5,),
                              SizedBox(
                                // width: 180,
                                  child: Text(widget.paymentListModel.unitName.toString(), style: AppTheme.blueAppTitle3,
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ))
                            ],
                          ),
                        ),
                        // Container(
                        //   child: Row(
                        //     children: [
                        //       Text('Currency:', style: AppTheme.appTitle7,),
                        //       SizedBox(width: 5,),
                        //       Text('UGX', style: AppTheme.blueAppTitle3,)
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text('Amount Paid:', style: AppTheme.appTitle7,),
                          SizedBox(width: 5,),
                          Text('${widget.paymentListModel.currencyModel!.code} ${amountFormatter.format(sumListRecursive(widget.paymentListModel.schedulesPerPayment!).toString())}', style: AppTheme.blueAppTitle3,)
                        ],
                      ),
                    ),

                    Divider(),

                    // Center(
                    //     child:  GestureDetector(
                    //       onTap: () {
                    //         pickPaymentImage();
                    //       },
                    //       child: Center(
                    //         child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(
                    //               15),
                    //           child: SizedBox(
                    //               height: 200,
                    //               width: 300,
                    //               child: paymentImage != null ?
                    //               Image.file(
                    //                 File(paymentImage!.path.toString()),
                    //                 fit: BoxFit.cover,) :
                    //               Container(
                    //                 decoration: BoxDecoration(
                    //                   color: AppTheme.fillColor,
                    //                   borderRadius: BorderRadius
                    //                       .circular(15),
                    //                   border: Border.all(
                    //                       color: Colors.grey,
                    //                       width: 0.1),
                    //                 ),
                    //                 height: 200,
                    //                 width: 300,
                    //                 child: Column(
                    //                   children: [
                    //                     GestureDetector(
                    //                       onTap: () {
                    //                         pickPaymentImage();
                    //                       },
                    //                       child: Container(
                    //                         padding: const EdgeInsets
                    //                             .only(
                    //                             top: 15, bottom: 8),
                    //                         child: Icon(Icons.upload),
                    //                       ),
                    //                     ),
                    //                     Text(
                    //                       "Upload Store Pic",
                    //                       style: AppTheme.subText,
                    //                     ),
                    //                   ],
                    //                 ),
                    //               )
                    //           ),
                    //         ),
                    //       ),
                    //
                    //     )
                    // ),
                    // paymentImageError == '' ? Container() : Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: 3, vertical: 0.5),
                    //   child: Text(paymentImageError, style: TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.red.shade800,
                    //
                    //   ),),
                    // ),
                    //
                    //
                    // Divider(),


                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Container(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [


                             Container(
                               child: Row(
                                 children: [
                                   Text('Receipt No:', style: AppTheme.appTitle7,),
                                   SizedBox(width: 1,),
                                   Text('', style: AppTheme.blueAppTitle3,)
                                 ],
                               ),
                             ),
                             Container(
                               child: Row(
                                 children: [
                                   Text('Payment Date:', style: AppTheme.appTitle7,),
                                   SizedBox(width: 1),
                                   Text(DateFormat('d MMM, yy').format(widget.paymentListModel.date!), style: AppTheme.blueAppTitle3,)
                                 ],
                               ),
                             ),

                             // Row(
                             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             //   children: [
                             //     Container(
                             //       child: Row(
                             //         children: [
                             //           Text('Period:', style: AppTheme.appTitle7,),
                             //           SizedBox(width: 5,),
                             //           Text(widget.paymentListModel.period!.name!.name.toString(), style: AppTheme.blueAppTitle3,)
                             //         ],
                             //       ),
                             //     ),
                             //     // Container(
                             //     //   child: Row(
                             //     //     children: [
                             //     //       Text('Number:', style: AppTheme.appTitle7,),
                             //     //       SizedBox(width: 5,),
                             //     //       Text(widget.paymentListModel.paymentScheduleModel!.length.toString(), style: AppTheme.blueAppTitle3,)
                             //     //     ],
                             //     //   ),
                             //     // ),
                             //   ],
                             // ),
                             Container(
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text('Payment Mode:', style: AppTheme.appTitle7,),
                                   SizedBox(width: 1,),
                                   Text(widget.paymentListModel.paymentModeModel!.name.toString().capitalizeFirst.toString(), style: AppTheme.blueAppTitle3,)
                                 ],
                               ),
                             ),
                             Container(
                               child: Row(
                                 children: [
                                   Text('Account:', style: AppTheme.appTitle7,),
                                   SizedBox(width: 1,),
                                   Text(widget.paymentListModel.paymentAccountModel!.name.toString(), style: AppTheme.blueAppTitle3,)
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),
                       Column(
                         children: [
                           GestureDetector(
                             onTap: ()async{

                               final data = await paymentReceiptPrintPdf.createReceiptPdf(widget.paymentListModel, sumListRecursive(widget.paymentListModel.schedulesPerPayment!));
                               await paymentReceiptPrintPdf.savePdfFile(
                                   'Smart_Rent_Receipt_$number', data);
                               number++;

                             },
                             child: Card(
                               child: Padding(
                                 padding: const EdgeInsets.all(5),
                                 child: Row(
                                   children: [
                                     Icon(Icons.print),
                                     Text('Print')
                                   ],
                                 ),
                               ),
                             ),
                           ),
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

                                   context.read<PaymentBloc>().add(UploadPaymentFileEvent(value.file.first!, widget.paymentListModel.docid!, widget.paymentListModel.filetype!));


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

                           GestureDetector(
                             onTap: (){

                               showModalBottomSheet(
                                 // backgroundColor: AppTheme.whiteColor,
                                   useSafeArea: true,
                                   isScrollControlled: true,
                                   context: context,
                                   builder: (context) {
                                     return BlocProvider<PaymentBloc>(create: (context) => PaymentBloc(),
                                       child: PaymentDocumentsListScreen(
                                       docId: widget.paymentListModel.docid!,
                                       fileTypeId: widget.paymentListModel.filetype!,
                                     ),
);
                                   });

                             },
                             child: Card(
                               child: Padding(
                                 padding: const EdgeInsets.all(5),
                                 child: Row(
                                   children: [
                                     Icon(Icons.view_list),
                                     Text('View')
                                   ],
                                 ),
                               ),
                             ),
                           ),

                         ],
                       )

                     ],
                   )



                  ],
                ),
              ),


              // Container(
              //   padding: const EdgeInsets.only(
              //     top: 15,
              //     left: 10,
              //     right: 10,
              //     bottom: 15,
              //   ),
              //   // decoration: const BoxDecoration(color: Colors.transparent),
              //   child: AppSearchTextField(
              //     controller: searchController,
              //     hintText: 'Search schedule',
              //     obscureText: false,
              //     onChanged: filterData,
              //     function: (){
              //
              //     },
              //     fillColor: AppTheme.grey_100,
              //   ),
              // ),

              // BlocBuilder<TenantUnitBloc, TenantUnitState>(
              //   builder: (context, state) {
              //     if(state.status == TenantUnitStatus.initial){
              //       context.read<TenantUnitBloc>().add(LoadTenantUnitPaymentSchedules(widget.paymentListModel.id!));
              //     } if(state.status == TenantUnitStatus.loadingDetails){
              //       return Center(child: CircularProgressIndicator(),);
              //     } if(state.status == TenantUnitStatus.successDetails){
              //       filteredData = state.paymentSchedules!;
              //       return Expanded(child: _buildDataTable(filteredData));
              //       // return ListView.builder(
              //       //     shrinkWrap: true,
              //       //     itemCount: filteredData.length,
              //       //     itemBuilder: (context, index){
              //       //       var schedule =  filteredData[index];
              //       //       return Text('Index$index ${schedule.fromDate.toString()}');
              //       //     });
              //
              //     } if(state.status == TenantUnitStatus.errorDetails){
              //       return Center(child: Text('Something went wrong'),);
              //
              //     } if(state.status == TenantUnitStatus.emptyDetails){
              //       return Center(child: Text('No Payment Schedules', style: AppTheme.blueAppTitle3,),);
              //     }
              //
              //     return Container();
              //
              //   },
              // ),

              widget.paymentListModel.schedulesPerPayment!.isEmpty
                  ? Center(child: Text('No Payment Schedules', style: AppTheme.blueAppTitle3,),)

                  : Expanded(child: _buildDataTable(filteredData)),

              // : Expanded(child: MyDataTable(tenantUnitModel: widget.tenantUnitModel)),

              // widget.tenantUnitModel.paymentScheduleModel!.isEmpty
              //     ? Center(child: Text('No Payment Schedules', style: AppTheme.blueAppTitle3,),)
              //
              //     : Expanded(
              //       child: SingleChildScrollView(
              //         child: DataTable(
              //                         showBottomBorder: true,
              //                         headingTextStyle: AppTheme.appTitle7,
              //                         columnSpacing: 20,
              //                         columns: [
              //         DataColumn(label: Text('Period')),
              //         DataColumn(label: Text('Amount')),
              //         DataColumn(label: Text('Paid')),
              //         DataColumn(label: Text('Balance')),
              //
              //                         ],
              //         rows:  widget.tenantUnitModel.paymentScheduleModel!.map((schedule) {
              //           return DataRow(
              //               cells: [
              //             DataCell(Text('${DateFormat('d MMM, yy').format(schedule.fromDate!)}\n${DateFormat('d MMM, yy').format(schedule.toDate!)}')),
              //             DataCell(Text(amountFormatter.format(schedule.discountAmount.toString()))),
              //             DataCell(Text(amountFormatter.format(schedule.paid.toString()))),
              //             DataCell(Text(amountFormatter.format(schedule.balance.toString()))),
              //           ]);
              //         }).toList(),
              //                       ),
              //       ),
              //     ),


            ],
          ),
        ),

      ),
    );
  }


}


Widget _buildDataTable(List<SchedulesPerPayment> payments) {
  return SfDataGridTheme(
    data: SfDataGridThemeData(
      headerColor: AppTheme.gray.withOpacity(.2),
      headerHoverColor: AppTheme.gray.withOpacity(.3),
    ),
    child: SfDataGrid(
      // allowSorting: true,
      // allowFiltering: true,
      allowSwiping: false,
      allowTriStateSorting: true,
      // source: tenantUnitPaymentScheduleDataSource,
      source: PaymentDetailsDataSource(paymentData: payments),
      columnWidthMode: ColumnWidthMode.fill,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      columns: _getColumns(),
    ),
  );
}



class PaymentDetailsDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  PaymentDetailsDataSource({required List<SchedulesPerPayment> paymentData}) {
    _paymentData = paymentData
        .map<DataGridRow>((schedule) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'period', value: '${DateFormat('d MMM, yy').format(schedule.schedule!.fromDate!)}\n${DateFormat('d MMM, yy').format(schedule.schedule!.fromDate!)}'),
      DataGridCell<String>(columnName: 'amount', value: amountFormatter.format(schedule.schedule!.discountAmount.toString())),
      DataGridCell<String>(columnName: 'paid', value: amountFormatter.format(schedule.schedule!.paid.toString())),
      DataGridCell<String>(columnName: 'balance', value: amountFormatter.format(schedule.schedule!.balance.toString()))
    ]))
        .toList();
  }

  List<DataGridRow> _paymentData = [];

  @override
  List<DataGridRow> get rows => _paymentData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}


List<GridColumn> _getColumns() {
  return <GridColumn>[
    GridColumn(
        columnName: 'period',
        label: Container(
            padding: const EdgeInsets.all(1.0),
            alignment: Alignment.center,
            child:  Text(
              'Period',
              style: AppTheme.darkBlueTitle,
            ))),
    GridColumn(
        columnName: 'amount',
        label: Container(
            padding: const EdgeInsets.all(1.0),
            alignment: Alignment.center,
            child:  Text('Amount',
              style: AppTheme.darkBlueTitle,
            ))),
    GridColumn(
        columnName: 'paid',
        label: Container(
            padding: const EdgeInsets.all(1.0),
            alignment: Alignment.center,
            child:  Text(
              'Paid',
              overflow: TextOverflow.ellipsis,
              style: AppTheme.darkBlueTitle,
            ))),
    GridColumn(
        columnName: 'balance',
        label: Container(
            padding: const EdgeInsets.all(1.0),
            alignment: Alignment.center,
            child:  Text(
              'Balance',
              overflow: TextOverflow.ellipsis,
              style: AppTheme.darkBlueTitle,
            ))),
  ];
}