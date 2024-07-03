
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


class PaymentReceiptPrintPdf {


  final amountFormatter = AmountFormatter(separator: ',');

  Future<Uint8List> createReceiptPdf(PaymentListModel paymentListModel, int totalAmount) async{
    final pdf = pw.Document();
    // final netImage = await networkImage(product.image.toString());
    // final logoImage = ( await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();
    // final letterHeadImage = ( await rootBundle.load('assets/images/leterhead.jpg')).buffer.asUint8List();
    final letterHeadImage = ( await rootBundle.load('assets/images/5square.jpg')).buffer.asUint8List();
    final netImage = await networkImage(paymentListModel.letterHead.toString());

    // final wLogo = ( await rootBundle.load('assets/wt.png')).buffer.asUint8List();
    // final profilePic = ( await rootBundle.load('assets/account/man.jpg')).buffer.asUint8List();
    // final bannerImage = ( await rootBundle.load('assets/banner.jpg')).buffer.asUint8List();
    // final paidStamp = ( await rootBundle.load('assets/paid.png')).buffer.asUint8List();

    var headers = [
      'PERIOD',
      'AMOUNT DUE',
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

                      // pw.Image(pw.MemoryImage(letterHeadImage),
                      //     width: 500,
                      //     height: 80,
                      //     fit: pw.BoxFit.cover
                      // ),
                      pw.Image(netImage,
                          width: 500,
                          height: 110,
                          fit: pw.BoxFit.cover
                      ),
                      // pw.Divider(
                      //   color: PdfColors.grey
                      // ),
                      pw.Center(
                        child:
                        pw.Text(
                          'RECEIPT',
                          style: pw.TextStyle(
                            fontSize: 25,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.red,
                            decoration: pw.TextDecoration.underline,
                            decorationStyle: pw.TextDecorationStyle.solid,
                          ),
                        ),
                      ),

                      pw.Row(
                        children: [
                          pw.Expanded(child: pw.Container(), flex: 1),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.end,
                                    children: [
                                      pw.Text(
                                        'Date:',
                                        style: pw.TextStyle(
                                          fontSize: 20,
                                          fontWeight: pw.FontWeight.bold,
                                          // color: PdfColors.blue,
                                        ),
                                      ),
                                      pw.Text(DateFormat('d MMM, yy').format(paymentListModel.date!),
                                        style: pw.TextStyle(
                                          fontSize: 20,
                                          // color: PdfColors.blue,
                                        ),
                                      ),
                                    ]
                                ),

                                pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.end,
                                    children: [
                                      pw.Text(
                                        'Receipt No: ',
                                        style: pw.TextStyle(
                                          fontSize: 20,
                                          fontWeight: pw.FontWeight.bold,
                                          // color: PdfColors.blue,
                                        ),
                                      ),
                                      pw.Text(paymentListModel.paymentId.toString(),
                                        style: pw.TextStyle(
                                          fontSize: 20,
                                          color: PdfColors.red,
                                        ),
                                      ),
                                    ]
                                ),


                              ]
                          ),
                        ]
                      ),

                      pw.Row(
                          children: [
                            pw.Text(
                              'Tenant: ',
                              style: pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                // color: PdfColors.blue,
                              ),
                            ),
                            pw.Text(paymentListModel.tenantType!.id == 1 ? '${paymentListModel.tenantProfile!.first.firstName == null ? '' : paymentListModel.tenantProfile!.first.firstName!.capitalizeFirst.toString().replaceAll('_', ' ')} ${paymentListModel.tenantProfile!.first.lastName!.capitalizeFirst.toString().replaceAll('_', ' ')}'
                                : '${paymentListModel.tenantProfile!.first.companyName!.capitalizeFirst.toString().replaceAll('_', ' ')}',
                              style: pw.TextStyle(
                                fontSize: 20,
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
                              'Unit Name/No: ',
                              style: pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                // color: PdfColors.blue,
                              ),
                            ),
                            pw.Text(paymentListModel.unitName.toString().capitalizeFirst.toString(),
                              style: pw.TextStyle(
                                fontSize: 20,
                                // color: PdfColors.blue,
                              ),
                            ),
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

                      // pw.Divider(color: PdfColors.grey300),

                      pw.Text('Rent Payment Details', style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 20,
                      ),
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
                                width: index == 0 ? 200 : 100,
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
                        itemCount: paymentListModel.schedulesPerPayment!.length + 1,
                        itemBuilder: (context, index){

                          if (index < paymentListModel.schedulesPerPayment!.length) {
                            var mySchedule = paymentListModel.schedulesPerPayment![index].schedule;
                            return pw.Container(
                                child: pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Container(
                                        child: pw.Center(
                                          child: pw.Text('${DateFormat('d MMM, yy').format(mySchedule!.fromDate!)}-${DateFormat('d MMM, yy').format(mySchedule.toDate!)}',
                                              style: pw.TextStyle(
                                                fontSize: 17.5,
                                              )),
                                        ),
                                        width: 200,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(),
                                        ),
                                      ),

                                      pw.Container(
                                        child:  pw.Center(
                                          child: pw.Text(amountFormatter.format(mySchedule.discountAmount.toString()),
                                              style: pw.TextStyle(
                                                fontSize: 17.5,
                                              ), textAlign: pw.TextAlign.start),
                                        ),
                                        width: 100,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(),
                                        ),
                                      ),

                                      pw.Container(
                                        child:  pw.Center(
                                          child: pw.Text(amountFormatter.format(mySchedule.paid.toString()),
                                              style: pw.TextStyle(
                                                fontSize: 17.5,
                                              ), textAlign: pw.TextAlign.start),
                                        ),
                                        width: 100,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(),
                                        ),
                                      ),

                                      pw.Container(
                                        child:  pw.Center(
                                          child: pw.Text(amountFormatter.format(mySchedule.balance.toString()),
                                              style: pw.TextStyle(
                                                fontSize: 17.5,
                                              ), textAlign: pw.TextAlign.start),
                                        ),
                                        width: 100,
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
                            for (var schedule in paymentListModel.schedulesPerPayment!) {
                              totalDiscount += int.parse(schedule.schedule!.discountAmount.toString());
                              totalPaid += int.parse(schedule.schedule!.paid.toString());
                              totalBalance += int.parse(schedule.schedule!.balance.toString());
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
                                          fontSize: 17.5,
                                          fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.white
                                        ),
                                      ),
                                    ),
                                    width: 200,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                  ),
                                  pw.Container(
                                    child: pw.Center(
                                      child: pw.Text(
                                        amountFormatter.format(totalDiscount.toString()),
                                        style: pw.TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.white
                                        ),
                                        textAlign: pw.TextAlign.start,
                                      ),
                                    ),
                                    width: 100,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                  ),
                                  pw.Container(
                                    child: pw.Center(
                                      child: pw.Text(
                                        amountFormatter.format(totalPaid.toString()),
                                        style: pw.TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.white
                                        ),
                                        textAlign: pw.TextAlign.start,
                                      ),
                                    ),
                                    width: 100,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                  ),
                                  pw.Container(
                                    child: pw.Center(
                                      child: pw.Text(
                                        amountFormatter.format(totalBalance.toString()),
                                        style: pw.TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.white
                                        ),
                                        textAlign: pw.TextAlign.start,
                                      ),
                                    ),
                                    width: 100,
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


                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Amount Received In Words: ',
                                style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                            ),
                            pw.Container(
                              child:  paymentListModel.currencyModel!.code == 'UGX' ? pw.Text('${paymentListModel.currencyModel!.name} ${NumberToWordsEnglish.convert(totalAmount).replaceAll('-', ' ').capitalizeFirst.toString()}',
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                    decoration: pw.TextDecoration.underline,
                                    decorationStyle: pw.TextDecorationStyle.solid,
                                  ), textAlign: pw.TextAlign.start, maxLines: 3)
                                  : pw.Text('${NumberToWordsEnglish.convert(totalAmount).replaceAll('-', ' ').capitalizeFirst.toString()} ${paymentListModel.currencyModel!.name}',
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                    decoration: pw.TextDecoration.underline,
                                    decorationStyle: pw.TextDecorationStyle.solid,
                                  ), textAlign: pw.TextAlign.start, maxLines: 3),
                            ),
                          ]
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Row(
                          children: [
                            pw.Text('Payment Mode: ',
                                style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold,
                                )
                            ),
                            pw.Container(
                              child:  pw.Text(paymentListModel.paymentModeModel!.name.toString(),
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                  ), textAlign: pw.TextAlign.start),

                            ),
                          ]
                      ),

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
                      //         child:  pw.Text(paymentListModel.paymentAccountModel!.name.toString(),
                      //             style: pw.TextStyle(
                      //               fontSize: 20,
                      //             ), textAlign: pw.TextAlign.start),
                      //
                      //       ),
                      //     ]
                      // ),

                      pw.SizedBox(
                        height: 10,
                      ),

                      pw.Column(
                          children: [
                            pw.Text('Description: ',
                                style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                maxLines: 3
                            ),
                            pw.Container(
                              child:  pw.Text('',
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                  ), textAlign: pw.TextAlign.start),

                            ),
                          ]
                      ),

                      // pw.Container(
                      //     alignment: pw.Alignment.centerRight,
                      //     child: pw.Row(
                      //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      //         children: [
                      //
                      //           // pw.Image(
                      //           //   pw.MemoryImage(paidStamp),
                      //           //   height: 15.h,
                      //           //   width: 30.w
                      //           // ),
                      //
                      //           pw.Column(
                      //             crossAxisAlignment: pw.CrossAxisAlignment.start,
                      //             children: [
                      //
                      //             ]
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

                      pw.SizedBox(
                        height: 10,
                      ),

                      pw.Container(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [

                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    mainAxisAlignment: pw.MainAxisAlignment.end,
                                    children: [
                                      pw.Row(
                                          mainAxisAlignment: pw.MainAxisAlignment.start,
                                          children: [
                                            pw.Text('Received By: ',
                                                style: pw.TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: pw.FontWeight.bold,
                                                )
                                            ),
                                            pw.Container(
                                              child:  pw.Text('',
                                                  style: pw.TextStyle(
                                                    fontSize: 20,
                                                  ), textAlign: pw.TextAlign.start),
                                            ),
                                          ]
                                      ),
                                      pw.Row(
                                          children: [
                                            pw.Text('Paid By: ',
                                                style: pw.TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: pw.FontWeight.bold,
                                                )
                                            ),
                                            pw.Container(
                                              child:  pw.Text(paymentListModel.tenantType!.id == 1
                                                  ? '${paymentListModel.tenantProfile!.first.firstName == null ? '' : paymentListModel.tenantProfile!.first.firstName!.capitalizeFirst.toString().replaceAll('_', ' ')} ${paymentListModel.tenantProfile!.first.lastName!.capitalizeFirst.toString().replaceAll('_', ' ')}'
                                                  : '${paymentListModel.tenantProfile!.first.companyName!.capitalizeFirst.toString().replaceAll('_', ' ')}',
                                                  style: pw.TextStyle(
                                                    fontSize: 20,
                                                  ), textAlign: pw.TextAlign.start),

                                            ),
                                          ]
                                      ),

                                    ]
                                ),


                                pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    mainAxisAlignment: pw.MainAxisAlignment.start,
                                    children: [
                                      pw.Text('Signature ',
                                          style: pw.TextStyle(
                                            fontSize: 20,
                                            fontWeight: pw.FontWeight.bold,
                                          )
                                      ),
                                      pw.SizedBox(height: 10),
                                      pw.Text('..........................................',
                                          style: pw.TextStyle(
                                            // fontSize: 20,
                                            fontWeight: pw.FontWeight.bold,
                                          )
                                      ),
                                      pw.SizedBox(height: 10),
                                      pw.Text('..........................................',
                                          style: pw.TextStyle(
                                            // fontSize: 20,
                                            fontWeight: pw.FontWeight.bold,
                                          )
                                      ),

                                    ]
                                ),

                                // pw.Expanded(
                                //   flex: 4,
                                //   child:   pw.Container(
                                //       child: pw.Column(
                                //           crossAxisAlignment: pw.CrossAxisAlignment.start,
                                //           children: [
                                //             pw.Column(
                                //                 children: [
                                //                   // pw.Text('Shipping Fee', style: pw.TextStyle(
                                //                   //     fontWeight: pw.FontWeight.bold,
                                //                   //     fontSize: 17.5.sp
                                //                   // ),),
                                //                   // pw.Text('UGX 150,000', style: pw.TextStyle(
                                //                   //     fontWeight: pw.FontWeight.bold,
                                //                   //     fontSize: 18.sp,
                                //                   //     color: PdfColors.green
                                //                   // ),),
                                //                 ]
                                //             ),
                                //           ]
                                //       )
                                //   ),
                                // ),

                                // pw.Container(
                                //   width: 60,
                                //   child: pw.Column(
                                //       crossAxisAlignment: pw.CrossAxisAlignment.start,
                                //       children: [
                                //         pw.Container(
                                //             width: double.infinity,
                                //             child: pw.Row(
                                //                 children: [
                                //                   pw.Expanded(child: pw.Text('Net Value', style: pw.TextStyle(
                                //                       fontWeight: pw.FontWeight.bold,
                                //                       fontSize: 18
                                //                   ),),),
                                //                   // pw.Text(amountFormatter.format(paymentListModel.total.toString()), style: pw.TextStyle(
                                //                   //     fontWeight: pw.FontWeight.bold,
                                //                   //     fontSize: 18.sp
                                //                   // ),),
                                //                 ]
                                //             )
                                //         ),
                                //
                                //         pw.Container(
                                //             width: double.infinity,
                                //             child: pw.Row(
                                //                 children: [
                                //                   // pw.Expanded(child: pw.Text(selectedDelivery.toString(), style: pw.TextStyle(
                                //                   //     fontWeight: pw.FontWeight.bold,
                                //                   //     fontSize: 18.sp
                                //                   // ),),),
                                //                   // pw.Text(selectedDelivery.toString() == 'Delivery' ? '${amountFormatter.format(deliveryFee.toString())}' : '10,000', style: pw.TextStyle(
                                //                   //     fontWeight: pw.FontWeight.bold,
                                //                   //     fontSize: 18.sp
                                //                   // ),),
                                //                 ]
                                //             )
                                //         ),
                                //
                                //         // pw.Container(
                                //         //     width: double.infinity,
                                //         //     child: pw.Row(
                                //         //         children: [
                                //         //           pw.Expanded(child: pw.Text('VAT', style: pw.TextStyle(
                                //         //               fontWeight: pw.FontWeight.bold,
                                //         //               fontSize: 18.sp
                                //         //           ),),),
                                //         //           pw.Text(200.toString(), style: pw.TextStyle(
                                //         //               fontWeight: pw.FontWeight.bold,
                                //         //               fontSize: 18.sp
                                //         //           ),),
                                //         //         ]
                                //         //     )
                                //         // ),
                                //         pw.Divider(),
                                //         pw.Container(
                                //             width: double.infinity,
                                //             child: pw.Row(
                                //                 children: [
                                //                   pw.Expanded(child: pw.Text('TOTAL', style: pw.TextStyle(
                                //                       fontWeight: pw.FontWeight.bold,
                                //                       fontSize: 18
                                //                   ),),),
                                //                   // pw.Text(amountFormatter.format(grandTotal.toString()), style: pw.TextStyle(
                                //                   //     fontWeight: pw.FontWeight.bold,
                                //                   //     fontSize: 22.5.sp
                                //                   // ),),
                                //                 ]
                                //             )
                                //         ),
                                //         pw.SizedBox(height: 1),
                                //         pw.Container(color: PdfColors.green100, height: 0.5),
                                //         pw.SizedBox(height: 0.5),
                                //         pw.Container(color: PdfColors.green100, height: 0.5),
                                //
                                //       ]
                                //   ),)
                              ]
                          )
                      ),



                      // pw.Row(
                      //     children: [
                      //       pw.Text('Payment Method:', style: pw.TextStyle(
                      //         fontSize: 15.sp,
                      //       )),
                      //       pw.SizedBox(
                      //         width: 2.w,
                      //       ),
                      //       pw.Text(paymentMethod ?? 'Mobile Money', style: pw.TextStyle(
                      //           color: PdfColors.green,
                      //           fontWeight: pw.FontWeight.bold,
                      //           fontSize: 17.5.sp
                      //
                      //       ))
                      //     ]
                      // ),
                      //
                      // pw.Row(
                      //     children: [
                      //       pw.Text('Delivery Option:', style: pw.TextStyle(
                      //         fontSize: 15.sp,
                      //       )),
                      //       pw.SizedBox(
                      //         width: 2.w,
                      //       ),
                      //       pw.Text(selectedDelivery ?? 'PICKUP', style: pw.TextStyle(
                      //           color: PdfColors.green,
                      //           fontWeight: pw.FontWeight.bold,
                      //           fontSize: 17.5.sp
                      //
                      //       ))
                      //     ]
                      // ),

                      // pw.Text('Promo', style: const pw.TextStyle(
                      //     color: PdfColors.green
                      // )),

                      // pw.ClipRRect(
                      //     child: pw.Image(pw.MemoryImage(bannerImage),
                      //         width: paymentListModel.cartList.length <= 4 ? 90.w : 65.w,
                      //         height: paymentListModel.cartList.length <= 4 ? 25.h : 18.h,
                      //         // width: 120.w,
                      //         // height: 33.h,
                      //         fit: pw.BoxFit.cover
                      //     ),
                      //     horizontalRadius: 15.sp,
                      //     verticalRadius: 15.sp
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