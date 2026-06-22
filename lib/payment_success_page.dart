// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'home_page.dart';

// class PaymentSuccessPage extends StatefulWidget {
//   final String hostelName;
//   final String roomNumber;
//   final int amount;
//   final int selectedBeds;
//   final int rentPerBed;
//   final String studentName;
//   final String email;
//   final String phone;
//   final DateTime moveInDate;
//   final String transactionId;

//   const PaymentSuccessPage({
//     super.key,
//     required this.hostelName,
//     required this.roomNumber,
//     required this.amount,
//     required this.selectedBeds,
//     required this.rentPerBed,
//     required this.studentName,
//     required this.email,
//     required this.phone,
//     required this.moveInDate,
//     required this.transactionId,
//   });

//   @override
//   State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
// }

// class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
//   bool isLoading = false;

//   Future<void> _downloadReceipt() async {
//     try {
//       setState(() => isLoading = true);

//       final pdf = pw.Document();
//       final formattedDate = DateFormat('dd MMM yyyy').format(widget.moveInDate);
//       final now = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           build: (pw.Context context) {
//             return pw.Padding(
//               padding: const pw.EdgeInsets.all(30),
//               child: pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Center(
//                     child: pw.Text(
//                       'NAN Hostel - Booking Receipt',
//                       style: pw.TextStyle(
//                         fontSize: 26,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   pw.SizedBox(height: 10),
//                   pw.Center(
//                     child: pw.Text(
//                       'Payment Successful',
//                       style: pw.TextStyle(fontSize: 16, color: PdfColors.green),
//                     ),
//                   ),
//                   pw.Divider(height: 30),
//                   pw.Text(
//                     'Booking Details',
//                     style: pw.TextStyle(
//                       fontSize: 18,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                   pw.SizedBox(height: 10),
//                   pw.Text('Transaction ID: ${widget.transactionId}'),
//                   pw.Text('Payment Date: $now'),
//                   pw.Text('Payment Method: bKash'),
//                   pw.Text('Status: Paid'),
//                   pw.SizedBox(height: 20),
//                   pw.Text(
//                     'Student Information',
//                     style: pw.TextStyle(
//                       fontSize: 18,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                   pw.SizedBox(height: 10),
//                   pw.Text('Name: ${widget.studentName}'),
//                   pw.Text('Email: ${widget.email}'),
//                   pw.Text('Phone: ${widget.phone}'),
//                   pw.SizedBox(height: 20),
//                   pw.Text(
//                     'Hostel Information',
//                     style: pw.TextStyle(
//                       fontSize: 18,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                   pw.SizedBox(height: 10),
//                   pw.Text('Hostel Name: ${widget.hostelName}'),
//                   pw.Text('Room: ${widget.roomNumber}'),
//                   pw.Text('Move-in Date: $formattedDate'),
//                   pw.SizedBox(height: 15),
//                   pw.Divider(),
//                   pw.Text(
//                     'Beds Booked: ${widget.selectedBeds}',
//                     style: pw.TextStyle(fontSize: 14),
//                   ),
//                   pw.Text(
//                     'Rent per Bed: Tk ${widget.rentPerBed}',
//                     style: pw.TextStyle(fontSize: 14),
//                   ),
//                   pw.SizedBox(height: 5),
//                   pw.Text(
//                     'Total Amount Paid: Tk ${widget.amount}',
//                     style: pw.TextStyle(
//                       fontSize: 16,
//                       fontWeight: pw.FontWeight.bold,
//                       color: PdfColors.blue,
//                     ),
//                   ),
//                   pw.Spacer(),
//                   pw.Center(
//                     child: pw.Text(
//                       'Thank you for booking with NAN Hostel!',
//                       style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       );

//       final pdfBytes = await pdf.save();
//       String path;
//       String saveLocation;

//       if (kIsWeb) {
//         await Printing.sharePdf(
//           bytes: pdfBytes,
//           filename: 'NestFinder_Receipt_${widget.transactionId}.pdf',
//         );
//         setState(() => isLoading = false);
//         return;
//       } else if (Platform.isAndroid || Platform.isIOS) {
//         final directory = await getExternalStorageDirectory();
//         if (directory == null) throw Exception('Storage not found');

//         // Android 11+ e Download folder direct access
//         final downloadDir = Directory('${directory.path}/Download');
//         if (!await downloadDir.exists()) {
//           await downloadDir.create(recursive: true);
//         }

//         path =
//             '${downloadDir.path}/NestFinder_Receipt_${widget.transactionId}.pdf';
//         saveLocation =
//             'Download/NestFinder_Receipt_${widget.transactionId}.pdf';
//       } else {
//         final directory = await getDownloadsDirectory();
//         if (directory == null) {
//           final docsDir = await getApplicationDocumentsDirectory();
//           path =
//               '${docsDir.path}/NestFinder_Receipt_${widget.transactionId}.pdf';
//           saveLocation =
//               'Documents/NestFinder_Receipt_${widget.transactionId}.pdf';
//         } else {
//           path =
//               '${directory.path}/NestFinder_Receipt_${widget.transactionId}.pdf';
//           saveLocation =
//               'Downloads/NestFinder_Receipt_${widget.transactionId}.pdf';
//         }
//       }

//       final file = File(path);
//       await file.writeAsBytes(pdfBytes);

//       setState(() => isLoading = false);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 const Icon(Icons.check_circle, color: Colors.white, size: 24),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         "Download Successful",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                       Text(
//                         "Saved to: $saveLocation",
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             backgroundColor: const Color(0xFFE2136E),
//             duration: const Duration(seconds: 4),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Download Failed: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     const Color primaryBlue = Color(0xFF003366);
//     final formattedDate = DateFormat('dd MMM yyyy').format(widget.moveInDate);
//     final now = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

//     return Scaffold(
//       backgroundColor: const Color(0xFFEAF4FF),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Container(
//             padding: const EdgeInsets.all(25),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25),
//               border: Border.all(
//                 color: Colors.green.withOpacity(0.3),
//                 width: 2,
//               ),
//               boxShadow: const [
//                 BoxShadow(color: Colors.black12, blurRadius: 10),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CircleAvatar(
//                   radius: 45,
//                   backgroundColor: Colors.green,
//                   child: Icon(Icons.check, color: Colors.white, size: 50),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   "Payment Successful",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   "Receipt / Booking Proof",
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 25),
//                 Divider(color: Colors.grey.shade300),
//                 const SizedBox(height: 15),

//                 _buildRow(Icons.person, "Name", widget.studentName),
//                 _buildRow(Icons.email, "Email", widget.email),
//                 _buildRow(Icons.phone, "Phone", widget.phone),
//                 _buildRow(Icons.home, "Hostel", widget.hostelName),
//                 _buildRow(Icons.bed, "Room", widget.roomNumber),
//                 _buildRow(
//                   Icons.groups,
//                   "Beds Booked",
//                   "${widget.selectedBeds} bed${widget.selectedBeds > 1 ? 's' : ''}",
//                 ),
//                 _buildRow(
//                   Icons.attach_money,
//                   "Rent per Bed",
//                   "Tk ${widget.rentPerBed}",
//                 ),
//                 _buildRow(Icons.date_range, "Move-in Date", formattedDate),
//                 const SizedBox(height: 10),
//                 Divider(color: Colors.grey.shade200),
//                 const SizedBox(height: 10),
//                 _buildRow(
//                   Icons.payments,
//                   "Total Amount",
//                   "Tk ${widget.amount}",
//                   valueColor: primaryBlue,
//                   bold: true,
//                 ),
//                 _buildRow(
//                   Icons.receipt_long,
//                   "Transaction ID",
//                   widget.transactionId,
//                 ),
//                 _buildRow(Icons.payment, "Method", "bKash"),
//                 _buildRow(Icons.access_time, "Date", now),

//                 const SizedBox(height: 25),

//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton.icon(
//                     icon: isLoading
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Color(0xFF003366),
//                             ),
//                           )
//                         : Icon(Icons.download, color: primaryBlue),
//                     label: Text(
//                       isLoading ? "Downloading..." : "Download Receipt PDF",
//                       style: TextStyle(
//                         color: primaryBlue,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       side: BorderSide(color: primaryBlue, width: 2),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     onPressed: isLoading ? null : _downloadReceipt,
//                   ),
//                 ),

//                 const SizedBox(height: 12),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryBlue,
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(builder: (_) => const HomePage()),
//                         (route) => false,
//                       );
//                     },
//                     child: const Text(
//                       "Back To Home",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRow(
//     IconData icon,
//     String title,
//     String value, {
//     bool bold = false,
//     Color? valueColor,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Colors.grey[700]),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(title, style: TextStyle(color: Colors.grey[700])),
//           ),
//           Flexible(
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               style: TextStyle(
//                 fontWeight: bold ? FontWeight.bold : FontWeight.w600,
//                 color: valueColor ?? Colors.black,
//                 fontSize: bold ? 16 : 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'home_page.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String hostelName;
  final String roomNumber;
  final int amount;
  final int selectedBeds;
  final int rentPerBed;
  final String studentName;
  final String email;
  final String phone;
  final DateTime moveInDate;
  final String transactionId;

  const PaymentSuccessPage({
    super.key,
    required this.hostelName,
    required this.roomNumber,
    required this.amount,
    required this.selectedBeds,
    required this.rentPerBed,
    required this.studentName,
    required this.email,
    required this.phone,
    required this.moveInDate,
    required this.transactionId,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  bool isLoading = false;

  Future<void> _downloadReceipt() async {
    try {
      setState(() => isLoading = true);

      final pdf = pw.Document();
      final formattedDate = DateFormat('dd MMM yyyy').format(widget.moveInDate);
      final now = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(30),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      'NAN Hostel - Booking Receipt',
                      style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Center(
                    child: pw.Text(
                      'Payment Successful',
                      style: pw.TextStyle(fontSize: 16, color: PdfColors.green),
                    ),
                  ),
                  pw.Divider(height: 30),
                  pw.Text(
                    'Booking Details',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text('Transaction ID: ${widget.transactionId}'),
                  pw.Text('Payment Date: $now'),
                  pw.Text('Payment Method: bKash'),
                  pw.Text('Status: Paid'),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Student Information',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text('Name: ${widget.studentName}'),
                  pw.Text('Email: ${widget.email}'),
                  pw.Text('Phone: ${widget.phone}'),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Hostel Information',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text('Hostel Name: ${widget.hostelName}'),
                  pw.Text('Room: ${widget.roomNumber}'),
                  pw.Text('Move-in Date: $formattedDate'),
                  pw.SizedBox(height: 15),
                  pw.Divider(),
                  pw.Text(
                    'Beds Booked: ${widget.selectedBeds}',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.Text(
                    'Rent per Bed: Tk ${widget.rentPerBed}',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Total Amount Paid: Tk ${widget.amount}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue,
                    ),
                  ),
                  pw.Spacer(),
                  pw.Center(
                    child: pw.Text(
                      'Thank you for booking with NAN Hostel!',
                      style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();
      String path;
      String saveLocation;

      if (kIsWeb) {
        await Printing.sharePdf(
          bytes: pdfBytes,
          filename: 'NestFinder_Receipt_${widget.transactionId}.pdf',
        );
        setState(() => isLoading = false);
        return;
      } else if (Platform.isAndroid) {
        // Android এর জন্য permission + Download folder
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }

        if (status.isGranted) {
          final downloadsDirectory =
              await DownloadsPathProvider.downloadsDirectory;
          if (downloadsDirectory == null)
            throw Exception('Downloads folder not found');

          path =
              '${downloadsDirectory.path}/NestFinder_Receipt_${widget.transactionId}.pdf';
          saveLocation =
              'Downloads/NestFinder_Receipt_${widget.transactionId}.pdf';
        } else {
          throw Exception('Storage permission denied');
        }
      } else if (Platform.isIOS) {
        // iOS এর জন্য Documents folder
        final directory = await getApplicationDocumentsDirectory();
        path =
            '${directory.path}/NestFinder_Receipt_${widget.transactionId}.pdf';
        saveLocation = 'Files app > NestFinder';
      } else {
        // Windows/Mac/Linux
        final directory = await getDownloadsDirectory();
        if (directory == null) {
          final docsDir = await getApplicationDocumentsDirectory();
          path =
              '${docsDir.path}/NestFinder_Receipt_${widget.transactionId}.pdf';
          saveLocation =
              'Documents/NestFinder_Receipt_${widget.transactionId}.pdf';
        } else {
          path =
              '${directory.path}/NestFinder_Receipt_${widget.transactionId}.pdf';
          saveLocation =
              'Downloads/NestFinder_Receipt_${widget.transactionId}.pdf';
        }
      }

      final file = File(path);
      await file.writeAsBytes(pdfBytes);

      setState(() => isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Download Successful",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Saved to: $saveLocation",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFE2136E),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: "OPEN",
              textColor: Colors.white,
              onPressed: () => OpenFile.open(path),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Download Failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF003366);
    final formattedDate = DateFormat('dd MMM yyyy').format(widget.moveInDate);
    final now = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white, size: 50),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Payment Successful",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Receipt / Booking Proof",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 25),
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 15),

                _buildRow(Icons.person, "Name", widget.studentName),
                _buildRow(Icons.email, "Email", widget.email),
                _buildRow(Icons.phone, "Phone", widget.phone),
                _buildRow(Icons.home, "Hostel", widget.hostelName),
                _buildRow(Icons.bed, "Room", widget.roomNumber),
                _buildRow(
                  Icons.groups,
                  "Beds Booked",
                  "${widget.selectedBeds} bed${widget.selectedBeds > 1 ? 's' : ''}",
                ),
                _buildRow(
                  Icons.attach_money,
                  "Rent per Bed",
                  "Tk ${widget.rentPerBed}",
                ),
                _buildRow(Icons.date_range, "Move-in Date", formattedDate),
                const SizedBox(height: 10),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 10),
                _buildRow(
                  Icons.payments,
                  "Total Amount",
                  "Tk ${widget.amount}",
                  valueColor: primaryBlue,
                  bold: true,
                ),
                _buildRow(
                  Icons.receipt_long,
                  "Transaction ID",
                  widget.transactionId,
                ),
                _buildRow(Icons.payment, "Method", "bKash"),
                _buildRow(Icons.access_time, "Date", now),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF003366),
                            ),
                          )
                        : Icon(Icons.download, color: primaryBlue),
                    label: Text(
                      isLoading ? "Downloading..." : "Download Receipt PDF",
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: primaryBlue, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: isLoading ? null : _downloadReceipt,
                  ),
                ),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Back To Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    IconData icon,
    String title,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title, style: TextStyle(color: Colors.grey[700])),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                color: valueColor ?? Colors.black,
                fontSize: bold ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
