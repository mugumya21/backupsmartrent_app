
import 'dart:io';
import 'dart:typed_data';
import 'package:amount_formatter/amount_formatter.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_rent/data_layer/models/payment/payment_list_model.dart';
import 'package:smart_rent/data_layer/models/reports/collections/collections_report_model.dart';
import 'package:smart_rent/utilities/app_init.dart';


class CollectionsReceiptPrintPdf {


  final amountFormatter = AmountFormatter(separator: ',');

  Future<Uint8List> createReceiptPdf(List<CollectionsReportModel> collections, int totalUnpaidAmount,
      String selectedPropertyName, int totalAmountDue, int totalPaid, String dateToday,
      String otherDate, String selectedCurrencyCode, dynamic totalUnits, dynamic occupiedUnits, dynamic vacantUnits,
      String pTotalUnits, String pOccupiedUnits, String pVacantUnits
      ) async{
    final pdf = pw.Document();
    // final netImage = await networkImage(product.image.toString());
    // final logoImage = ( await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();
    // final letterHeadImage = ( await rootBundle.load('assets/images/leterhead.jpg')).buffer.asUint8List();
    final letterHeadImage = ( await rootBundle.load('assets/images/5square.jpg')).buffer.asUint8List();
    final netImage = await networkImage(currentUserLetterHead.toString());

    // final wLogo = ( await rootBundle.load('assets/wt.png')).buffer.asUint8List();
    // final profilePic = ( await rootBundle.load('assets/account/man.jpg')).buffer.asUint8List();
    // final bannerImage = ( await rootBundle.load('assets/banner.jpg')).buffer.asUint8List();
    // final paidStamp = ( await rootBundle.load('assets/paid.png')).buffer.asUint8List();



    // int vacantUnits  = collections.where((collection) => collection.basePaid ==0 && collection.baseBalance == 0 && collection.baseDiscountAmount ==0
    //     && collection.tenantUnitId == null).toList().length;
    //
    // int occupiedUnits  = collections.where((collection) => collection.tenantUnitId != null).toList().length;

    var headers = [
      'UNIT',
      'TENANT',
      'PERIOD',
      'AMOUNT',
      'PAID',
      'BALANCE',
    ];

    pdf.addPage(
        pw.MultiPage(
            // footer: (pw.Context context){
            //   return pw.Column(
            //       mainAxisAlignment: pw.MainAxisAlignment.center,
            //       crossAxisAlignment: pw.CrossAxisAlignment.center,
            //       children: [
            //         pw.Divider(),
            //         pw.Row(
            //             mainAxisAlignment: pw.MainAxisAlignment.center,
            //             crossAxisAlignment: pw.CrossAxisAlignment.center,
            //             children: [
            //               pw.Text('smartrent.co.ug',
            //                   style: pw.TextStyle(
            //                     fontSize: 17.5,
            //                     fontWeight: pw.FontWeight.bold,
            //                     color: PdfColors.blue,
            //                   )
            //               ),
            //               // pw.Text(' |  Download App',
            //               //     style: pw.TextStyle(
            //               //       fontSize: 17.5,
            //               //       fontWeight: pw.FontWeight.bold,
            //               //       color: PdfColors.black,
            //               //     )
            //               // ),
            //
            //             ]
            //         ),
            //
            //         pw.Text('© copyright 2024',
            //             style: pw.TextStyle(
            //               fontSize: 15,
            //               fontWeight: pw.FontWeight.bold,
            //               color: PdfColors.grey,
            //             )
            //         ),
            //
            //         // pw.Row(
            //         //     mainAxisAlignment: pw.MainAxisAlignment.center,
            //         //     crossAxisAlignment: pw.CrossAxisAlignment.center,
            //         //     children: [
            //         //       pw.Image(pw.MemoryImage(wLogo),
            //         //           width: 8.w,
            //         //           height: 2.5.h,
            //         //           fit: pw.BoxFit.cover
            //         //       ),
            //         //     ]
            //         // ),
            //       ]
            //   );
            // },
            build: (pw.Context context){
              return  [
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [

                      pw.Image(netImage,
                          width: 500,
                          height: 110,
                          fit: pw.BoxFit.cover
                      ),

                      // pw.Image(pw.MemoryImage(letterHeadImage),
                      //     width: 500,
                      //     height: 100,
                      //     fit: pw.BoxFit.cover
                      // ),
                      // pw.Divider(
                      //   color: PdfColors.grey
                      // ),

                      // pw.Center(
                      //   child:
                      //   pw.Text(
                      //     'Powered By SmartRent Manager',
                      //     style: pw.TextStyle(
                      //       fontSize: 15,
                      //       fontWeight: pw.FontWeight.bold,
                      //       color: PdfColors.grey,
                      //       fontStyle: pw.FontStyle.italic,
                      //       decorationStyle: pw.TextDecorationStyle.solid,
                      //     ),
                      //   ),
                      // ),

                      pw.Center(
                        child:
                        pw.Text(
                          'COLLECTIONS REPORT - ${dateToday.isEmpty ? DateFormat('d MMM, yy').format(DateTime.now()) : otherDate}',
                          style: pw.TextStyle(
                            fontSize: 25,
                            fontWeight: pw.FontWeight.bold,
                            decoration: pw.TextDecoration.underline,
                            decorationStyle: pw.TextDecorationStyle.solid,
                          ),
                        ),
                      ),

                      pw.SizedBox(
                        height: 10,
                      ),

                      pw.Row(
                          children: [
                            pw.Text(
                              'Property: ',
                              style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                                // color: PdfColors.blue,
                              ),
                            ),
                            pw.Text(selectedPropertyName,
                              style: pw.TextStyle(
                                fontSize: 15,
                                // color: PdfColors.blue,
                              ),
                            ),
                          ]
                      ),


                      pw.SizedBox(
                        height: 10,
                      ),


                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [

                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                              pw.Text(
                                'Occupancy',
                                style: pw.TextStyle(
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.bold,
                                  decoration: pw.TextDecoration.underline,
                                  decorationStyle: pw.TextDecorationStyle.solid,
                                ),
                              ),
                              pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'Total Units: ',
                                      style: pw.TextStyle(
                                        fontSize: 13,
                                        fontWeight: pw.FontWeight.bold,
                                        // color: PdfColors.blue,
                                      ),
                                    ),
                                    // pw.Text(totalUnits.toString(),
                                    pw.Text(pTotalUnits.toString(),
                                      style: pw.TextStyle(
                                        fontSize: 13,
                                        // color: PdfColors.blue,
                                      ),
                                    ),
                                  ]
                              ),
                                pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.start,
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        'Occupied: ',
                                        style: pw.TextStyle(
                                          fontSize: 13,
                                          fontWeight: pw.FontWeight.bold,
                                          // color: PdfColors.blue,
                                        ),
                                      ),
                                      // pw.Text(occupiedUnits.toString(),
                                      pw.Text(pOccupiedUnits.toString(),
                                        style: pw.TextStyle(
                                          fontSize: 13,
                                          // color: PdfColors.blue,
                                        ),
                                      ),
                                    ]
                                ),

                                pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.start,
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        'Vacant: ',
                                        style: pw.TextStyle(
                                          fontSize: 13,
                                          fontWeight: pw.FontWeight.bold,
                                          // color: PdfColors.blue,
                                        ),
                                      ),
                                      pw.Text(pVacantUnits.toString(),
                                        style: pw.TextStyle(
                                          fontSize: 13,
                                          // color: PdfColors.blue,
                                        ),
                                      ),
                                    ]
                                ),

                            ]
                          ),

                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Summary',
                                style: pw.TextStyle(
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.bold,
                                  decoration: pw.TextDecoration.underline,
                                  decorationStyle: pw.TextDecorationStyle.solid,
                                ),
                              ),
                              pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'Total Amount Due: ',
                                      style: pw.TextStyle(
                                        fontSize: 13,
                                        fontWeight: pw.FontWeight.bold,
                                        // color: PdfColors.blue,
                                      ),
                                    ),
                                    pw.Text('${amountFormatter.format(totalAmountDue.toString())} $selectedCurrencyCode',
                                      style: pw.TextStyle(
                                        fontSize: 13,
                                        // color: PdfColors.blue,
                                      ),
                                    ),
                                  ]
                              ),
                              pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'Total Paid Amount: ',
                                      style: pw.TextStyle(
                                        fontSize: 13,
                                        fontWeight: pw.FontWeight.bold,
                                        // color: PdfColors.blue,
                                      ),
                                    ),
                                    pw.Text('${amountFormatter.format(totalPaid.toString())} $selectedCurrencyCode',
                                      style: pw.TextStyle(
                                        fontSize: 13,
                                        // color: PdfColors.blue,
                                      ),
                                    ),
                                  ]
                              ),

                              pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'Total Un-Paid: ',
                                      style: pw.TextStyle(
                                        fontSize: 13,
                                        fontWeight: pw.FontWeight.bold,
                                        // color: PdfColors.blue,
                                      ),
                                    ),
                                    pw.Text('${amountFormatter.format(totalUnpaidAmount.toString())} $selectedCurrencyCode',
                                      style: pw.TextStyle(
                                        fontSize: 13,
                                        // color: PdfColors.blue,
                                      ),
                                    ),
                                  ]
                              ),

                            ]
                          )

                        ]
                      ),


                      // pw.Row(
                      //     mainAxisAlignment: pw.MainAxisAlignment.start,
                      //     crossAxisAlignment: pw.CrossAxisAlignment.start,
                      //     children: [
                      //       pw.Column(
                      //           crossAxisAlignment: pw.CrossAxisAlignment.start,
                      //           children: [
                      //             // pw.Image(pw.MemoryImage(logoImage),
                      //             //     width: 55.w,
                      //             //     height: 8.h,
                      //             //     fit: pw.BoxFit.cover
                      //             // ),
                      //
                      //
                      //           ]
                      //       ),
                      //
                      //
                      //     ]
                      // ),

                      pw.SizedBox(
                        height: 10,
                      ),


                      // pw.TableHelper.fromTextArray(
                      //     headers: headers,
                      //     data: [
                      //       [
                      //         paymentListModel.schedulesPerPayment!.map((schedule) => schedule.schedule!.fromDate),
                      //         paymentListModel.schedulesPerPayment!.map((schedule) => schedule.schedule!.discountAmount),
                      //         paymentListModel.schedulesPerPayment!.map((schedule) => schedule.schedule!.paid),
                      //         paymentListModel.schedulesPerPayment!.map((schedule) => schedule.schedule!.balance),
                      //
                      //       ]
                      //     ],
                      //     headerDecoration: pw.BoxDecoration(
                      //       color: PdfColors.black,
                      //     ),
                      //     headerAlignment: pw.Alignment.centerLeft,
                      //     // headerPadding: pw.EdgeInsets.zero,
                      //     border: null,
                      //     headerStyle: pw.TextStyle(
                      //       fontWeight: pw.FontWeight.bold,
                      //       fontSize: 18,
                      //       color: PdfColors.white
                      //     )
                      // ),


                      pw.SizedBox(height: 2),


                       pw.ListView.builder(
                          direction: pw.Axis.horizontal,
                          itemCount: headers.length,
                          itemBuilder: (context, index){
                            return pw.Container(
                                width: index == 0 ? 50 : index == 1 ? 90 : index == 2 ?  140 : 80,
                                child: pw.Center(
                                  child: pw.Text(headers[index], style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                  ), textAlign: pw.TextAlign.center),
                                ),
                              height: 30,
                              decoration: pw.BoxDecoration(
                                color: PdfColors.black,
                              ),
                            );
                          },
                        ),

                      pw.ListView.builder(
                        itemCount: collections.length + 1,
                        itemBuilder: (context, index){

                          if (index < collections.length) {
                            var myCollection = collections[index];
                            return pw.Container(
                                child: pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        child:  pw.Center(
                                          child: pw.Text(myCollection.tenantunit!.unit!.name.toString(),
                                              style: pw.TextStyle(
                                                fontSize: 10,
                                              ), textAlign: pw.TextAlign.start,
                                            maxLines: 1,
                                          ),
                                        ),
                                        width: 50,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(),
                                        ),
                                      ),

                                      pw.Container(
                                        child:  pw.Center(
                                          child: pw.Text(myCollection.tenantunit!.tenant == null ? 'Vacant' : myCollection.tenantunit!.tenant!.clientTypeId == 1
                                              ? '${myCollection.tenantunit!.tenant!.clientProfiles!.first.firstName!.capitalizeFirst} ${myCollection.tenantunit!.tenant!.clientProfiles!.first.lastName!.capitalizeFirst}'.replaceAll('_', ' ')
                                              : myCollection.tenantunit!.tenant!.clientProfiles!.first.companyName!.replaceAll('_', ' '),
                                              style: pw.TextStyle(
                                                fontSize: 10,
                                              ),
                                              textAlign: pw.TextAlign.center,
                                            maxLines: 1,
                                            overflow: pw.TextOverflow.clip,
                                          ),
                                        ),
                                        width: 90,
                                        decoration: pw.BoxDecoration(
                                          // border: pw.Border.all(),
                                          border: pw.Border(
                                            bottom: pw.BorderSide( //                    <--- top side
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),

                                      myCollection.fromDate == null ?
                                      pw.Container(
                                        child: pw.Center(
                                          child: pw.Text('${DateFormat('d MMM, yy').format(DateTime.now())}-${DateFormat('d MMM, yy').format(DateTime.now())}',
                                              style: pw.TextStyle(
                                                  fontSize: 10,
                                                color: PdfColors.white
                                              )),
                                        ),
                                        width: 140,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(),
                                        ),
                                      )
                                          :
                                      pw.Container(
                                        child: pw.Center(
                                          child: pw.Text('${DateFormat('d MMM, yy').format(myCollection.fromDate!)}-${DateFormat('d MMM, yy').format(myCollection.toDate!)}',
                                              style: pw.TextStyle(
                                                fontSize: 10,
                                              )),
                                        ),
                                        width: 140,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(),
                                        ),
                                      ),

                                      pw.Container(
                                        child:  pw.Center(
                                          child: pw.Text(currentUserBaseCurrencyCode == selectedCurrencyCode ? amountFormatter.format(myCollection.baseDiscountAmount == null ? 0.toString() : myCollection.baseDiscountAmount.toString())
                                              : amountFormatter.format(myCollection.foreignDiscountAmount == null ? 0.toString() : myCollection.foreignDiscountAmount.toString()),
                                              style: pw.TextStyle(
                                                fontSize: 10,
                                              ), textAlign: pw.TextAlign.start),
                                        ),
                                        width: 80,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(),
                                        ),
                                      ),

                                      pw.Container(
                                        child:  pw.Center(
                                          child: pw.Text(currentUserBaseCurrencyCode == selectedCurrencyCode ? amountFormatter.format(myCollection.basePaid == null ? 0.toString() : myCollection.basePaid.toString())
                                              : amountFormatter.format(myCollection.foreignPaid == null ? 0.toString() : myCollection.foreignPaid.toString()),
                                              style: pw.TextStyle(
                                                fontSize: 10,
                                              ), textAlign: pw.TextAlign.start),
                                        ),
                                        width: 80,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(),
                                        ),
                                      ),

                                      pw.Container(
                                        child:  pw.Center(
                                          child: pw.Text(currentUserBaseCurrencyCode == selectedCurrencyCode ? amountFormatter.format(myCollection.baseBalance ==null ? 0.toString() : myCollection.baseBalance.toString())
                                              : amountFormatter.format(myCollection.foreignBalance ==null ? 0.toString() : myCollection.foreignBalance.toString()),
                                              style: pw.TextStyle(
                                                fontSize: 10,
                                              ), textAlign: pw.TextAlign.start),
                                        ),
                                        width: 80,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(),
                                        ),
                                      )

                                    ]
                                )
                            );

                          } else {

                            int totalDiscount = 0;
                            int totalPaid = 0;
                            int totalBalance = 0;
                            for (var schedule in collections) {
                              totalDiscount += currentUserBaseCurrencyCode == selectedCurrencyCode ? (int.parse(schedule.baseDiscountAmount == null ? 0.toString() : schedule.baseDiscountAmount.toString()))
                                  : int.parse(schedule.foreignDiscountAmount == null ? 0.toString() : schedule.foreignDiscountAmount.toString());
                              totalPaid += currentUserBaseCurrencyCode == selectedCurrencyCode ? (int.parse(schedule.basePaid == null ? 0.toString() : schedule.basePaid.toString()))
                                  : int.parse(schedule.foreignPaid == null ? 0.toString() : schedule.foreignPaid.toString());
                              totalBalance += currentUserBaseCurrencyCode == selectedCurrencyCode ? (int.parse(schedule.baseBalance == null ? 0.toString() : schedule.baseBalance.toString()))
                                  : int.parse(schedule.foreignBalance == null ? 0.toString() : schedule.foreignBalance.toString());
                            }

                            return pw.Container(
                              child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                crossAxisAlignment: pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Container(
                                    child: pw.Center(
                                      child: pw.Text(
                                        'Totals',
                                        style: pw.TextStyle(
                                            fontSize: 10,
                                          fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.white
                                        ),
                                      ),
                                    ),
                                    width: 280,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                  ),
                                  pw.Container(
                                    child: pw.Center(
                                      child: pw.Text(
                                        amountFormatter.format(totalDiscount.toString()),
                                        style: pw.TextStyle(
                                            fontSize: 10,
                                          fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.white
                                        ),
                                        textAlign: pw.TextAlign.start,
                                      ),
                                    ),
                                    width: 80,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                  ),
                                  pw.Container(
                                    child: pw.Center(
                                      child: pw.Text(
                                        amountFormatter.format(totalPaid.toString()),
                                        style: pw.TextStyle(
                                            fontSize: 10,
                                          fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.white
                                        ),
                                        textAlign: pw.TextAlign.start,
                                      ),
                                    ),
                                    width: 80,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                  ),
                                  pw.Container(
                                    child: pw.Center(
                                      child: pw.Text(
                                        amountFormatter.format(totalBalance.toString()),
                                        style: pw.TextStyle(
                                            fontSize: 10,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.white
                                        ),
                                        textAlign: pw.TextAlign.start,
                                      ),
                                    ),
                                    width: 80,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                        color: PdfColors.grey
                                    ),
                                  ),
                                ],
                              ),
                              decoration: pw.BoxDecoration(
                                color: PdfColors.grey
                              ),
                            );

                          }
                        },
                      ),

                      // pw.Divider(color: PdfColors.grey300),
                      pw.SizedBox(
                        height: 10,
                      ),


                      // pw.Column(
                      //     mainAxisAlignment: pw.MainAxisAlignment.start,
                      //     crossAxisAlignment: pw.CrossAxisAlignment.start,
                      //     children: [
                      //       pw.Text('Amount Received In Words: ',
                      //           style: pw.TextStyle(
                      //             fontSize: 20,
                      //             fontWeight: pw.FontWeight.bold,
                      //           ),
                      //       ),
                      //       pw.Container(
                      //         child:  pw.Text('Uganda Shillings ${NumberToWordsEnglish.convert(totalUnpaidAmount).replaceAll('-', ' ').capitalizeFirst.toString()}',
                      //             style: pw.TextStyle(
                      //               fontSize: 20,
                      //               decoration: pw.TextDecoration.underline,
                      //               decorationStyle: pw.TextDecorationStyle.solid,
                      //             ), textAlign: pw.TextAlign.start, maxLines: 3),
                      //       ),
                      //     ]
                      // ),
                      // pw.SizedBox(
                      //   height: 10,
                      // ),
                      // pw.Row(
                      //     children: [
                      //       pw.Text('Payment Mode: ',
                      //           style: pw.TextStyle(
                      //             fontSize: 20,
                      //             fontWeight: pw.FontWeight.bold,
                      //           )
                      //       ),
                      //       pw.Container(
                      //         child:  pw.Text('',
                      //             style: pw.TextStyle(
                      //               fontSize: 20,
                      //             ), textAlign: pw.TextAlign.start),
                      //
                      //       ),
                      //     ]
                      // ),
                      //
                      // pw.SizedBox(
                      //   height: 10,
                      // ),
                      // pw.Row(
                      //     children: [
                      //       pw.Text('Credited Account: ',
                      //           style: pw.TextStyle(
                      //             fontSize: 20,
                      //             fontWeight: pw.FontWeight.bold,
                      //           )
                      //       ),
                      //       pw.Container(
                      //         child:  pw.Text('',
                      //             style: pw.TextStyle(
                      //               fontSize: 20,
                      //             ), textAlign: pw.TextAlign.start),
                      //
                      //       ),
                      //     ]
                      // ),
                      //
                      // pw.SizedBox(
                      //   height: 10,
                      // ),
                      //
                      // pw.Column(
                      //     children: [
                      //       pw.Text('Description: ',
                      //           style: pw.TextStyle(
                      //             fontSize: 20,
                      //             fontWeight: pw.FontWeight.bold,
                      //           ),
                      //           maxLines: 3
                      //       ),
                      //       pw.Container(
                      //         child:  pw.Text('',
                      //             style: pw.TextStyle(
                      //               fontSize: 20,
                      //             ), textAlign: pw.TextAlign.start),
                      //
                      //       ),
                      //     ]
                      // ),
                      //
                      //
                      // pw.SizedBox(
                      //   height: 10,
                      // ),
                      //
                      // pw.Container(
                      //     alignment: pw.Alignment.centerRight,
                      //     child: pw.Row(
                      //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      //         crossAxisAlignment: pw.CrossAxisAlignment.end,
                      //         children: [
                      //
                      //           pw.Column(
                      //               crossAxisAlignment: pw.CrossAxisAlignment.start,
                      //               mainAxisAlignment: pw.MainAxisAlignment.end,
                      //               children: [
                      //                 pw.Row(
                      //                     mainAxisAlignment: pw.MainAxisAlignment.start,
                      //                     children: [
                      //                       pw.Text('Received By: ',
                      //                           style: pw.TextStyle(
                      //                             fontSize: 20,
                      //                             fontWeight: pw.FontWeight.bold,
                      //                           )
                      //                       ),
                      //                       pw.Container(
                      //                         child:  pw.Text('',
                      //                             style: pw.TextStyle(
                      //                               fontSize: 20,
                      //                             ), textAlign: pw.TextAlign.start),
                      //                       ),
                      //                     ]
                      //                 ),
                      //                 pw.Row(
                      //                     children: [
                      //                       pw.Text('Paid By: ',
                      //                           style: pw.TextStyle(
                      //                             fontSize: 20,
                      //                             fontWeight: pw.FontWeight.bold,
                      //                           )
                      //                       ),
                      //                       pw.Container(
                      //                         child:  pw.Text('',
                      //                             style: pw.TextStyle(
                      //                               fontSize: 20,
                      //                             ), textAlign: pw.TextAlign.start),
                      //
                      //                       ),
                      //                     ]
                      //                 ),
                      //
                      //               ]
                      //           ),
                      //
                      //
                      //           pw.Column(
                      //               crossAxisAlignment: pw.CrossAxisAlignment.start,
                      //               mainAxisAlignment: pw.MainAxisAlignment.start,
                      //               children: [
                      //                 pw.Text('Signature ',
                      //                     style: pw.TextStyle(
                      //                       fontSize: 20,
                      //                       fontWeight: pw.FontWeight.bold,
                      //                     )
                      //                 ),
                      //                 pw.SizedBox(height: 10),
                      //                 pw.Text('..........................................',
                      //                     style: pw.TextStyle(
                      //                       // fontSize: 20,
                      //                       fontWeight: pw.FontWeight.bold,
                      //                     )
                      //                 ),
                      //                 pw.SizedBox(height: 10),
                      //                 pw.Text('..........................................',
                      //                     style: pw.TextStyle(
                      //                       // fontSize: 20,
                      //                       fontWeight: pw.FontWeight.bold,
                      //                     )
                      //                 ),
                      //
                      //               ]
                      //           ),
                      //
                      //           // pw.Expanded(
                      //           //   flex: 4,
                      //           //   child:   pw.Container(
                      //           //       child: pw.Column(
                      //           //           crossAxisAlignment: pw.CrossAxisAlignment.start,
                      //           //           children: [
                      //           //             pw.Column(
                      //           //                 children: [
                      //           //                   // pw.Text('Shipping Fee', style: pw.TextStyle(
                      //           //                   //     fontWeight: pw.FontWeight.bold,
                      //           //                   //     fontSize: 17.5.sp
                      //           //                   // ),),
                      //           //                   // pw.Text('UGX 150,000', style: pw.TextStyle(
                      //           //                   //     fontWeight: pw.FontWeight.bold,
                      //           //                   //     fontSize: 18.sp,
                      //           //                   //     color: PdfColors.green
                      //           //                   // ),),
                      //           //                 ]
                      //           //             ),
                      //           //           ]
                      //           //       )
                      //           //   ),
                      //           // ),
                      //
                      //           // pw.Container(
                      //           //   width: 60,
                      //           //   child: pw.Column(
                      //           //       crossAxisAlignment: pw.CrossAxisAlignment.start,
                      //           //       children: [
                      //           //         pw.Container(
                      //           //             width: double.infinity,
                      //           //             child: pw.Row(
                      //           //                 children: [
                      //           //                   pw.Expanded(child: pw.Text('Net Value', style: pw.TextStyle(
                      //           //                       fontWeight: pw.FontWeight.bold,
                      //           //                       fontSize: 18
                      //           //                   ),),),
                      //           //                   // pw.Text(amountFormatter.format(paymentListModel.total.toString()), style: pw.TextStyle(
                      //           //                   //     fontWeight: pw.FontWeight.bold,
                      //           //                   //     fontSize: 18.sp
                      //           //                   // ),),
                      //           //                 ]
                      //           //             )
                      //           //         ),
                      //           //
                      //           //         pw.Container(
                      //           //             width: double.infinity,
                      //           //             child: pw.Row(
                      //           //                 children: [
                      //           //                   // pw.Expanded(child: pw.Text(selectedDelivery.toString(), style: pw.TextStyle(
                      //           //                   //     fontWeight: pw.FontWeight.bold,
                      //           //                   //     fontSize: 18.sp
                      //           //                   // ),),),
                      //           //                   // pw.Text(selectedDelivery.toString() == 'Delivery' ? '${amountFormatter.format(deliveryFee.toString())}' : '10,000', style: pw.TextStyle(
                      //           //                   //     fontWeight: pw.FontWeight.bold,
                      //           //                   //     fontSize: 18.sp
                      //           //                   // ),),
                      //           //                 ]
                      //           //             )
                      //           //         ),
                      //           //
                      //           //         // pw.Container(
                      //           //         //     width: double.infinity,
                      //           //         //     child: pw.Row(
                      //           //         //         children: [
                      //           //         //           pw.Expanded(child: pw.Text('VAT', style: pw.TextStyle(
                      //           //         //               fontWeight: pw.FontWeight.bold,
                      //           //         //               fontSize: 18.sp
                      //           //         //           ),),),
                      //           //         //           pw.Text(200.toString(), style: pw.TextStyle(
                      //           //         //               fontWeight: pw.FontWeight.bold,
                      //           //         //               fontSize: 18.sp
                      //           //         //           ),),
                      //           //         //         ]
                      //           //         //     )
                      //           //         // ),
                      //           //         pw.Divider(),
                      //           //         pw.Container(
                      //           //             width: double.infinity,
                      //           //             child: pw.Row(
                      //           //                 children: [
                      //           //                   pw.Expanded(child: pw.Text('TOTAL', style: pw.TextStyle(
                      //           //                       fontWeight: pw.FontWeight.bold,
                      //           //                       fontSize: 18
                      //           //                   ),),),
                      //           //                   // pw.Text(amountFormatter.format(grandTotal.toString()), style: pw.TextStyle(
                      //           //                   //     fontWeight: pw.FontWeight.bold,
                      //           //                   //     fontSize: 22.5.sp
                      //           //                   // ),),
                      //           //                 ]
                      //           //             )
                      //           //         ),
                      //           //         pw.SizedBox(height: 1),
                      //           //         pw.Container(color: PdfColors.green100, height: 0.5),
                      //           //         pw.SizedBox(height: 0.5),
                      //           //         pw.Container(color: PdfColors.green100, height: 0.5),
                      //           //
                      //           //       ]
                      //           //   ),)
                      //         ]
                      //     )
                      // ),




                    ]
                )
              ];
            }
        )
    );

    return pdf.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = '${output.path}/$fileName.pdf';
    final file = File(filePath);
    await file.writeAsBytes(byteList);

    await OpenFilex.open(filePath);

  }

}