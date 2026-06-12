import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nan_nestfinder/bkash_payment_page.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> room;
  final String roomId;
  final Map<String, dynamic> hostel;
  final String ownerId;
  final String hostelName;

  const BookingPage({
    super.key,
    required this.room,
    required this.roomId,
    required this.hostel,
    required this.ownerId,
    required this.hostelName,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final Color primaryBlue = const Color(0xFF003366);
  final Color lightBlue = const Color(0xFFE3F2FD);
  DateTime? selectedDate;
  int selectedBeds = 1;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final RegExp phoneRegex = RegExp(r'^01[3-9]\d{8}$');
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  String s(dynamic val, [String def = '']) => val?.toString() ?? def;
  int i(dynamic val, [int def = 0]) {
    if (val is int) return val;
    if (val is double) return val.toInt();
    if (val is String) return int.tryParse(val) ?? def;
    return def;
  }

  Future<void> _proceedToPayment() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select move-in date"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final int rentPerBed = i(
      widget.room['monthly_rent'] ??
          widget.room['rent'] ??
          widget.room['price'],
      0,
    );
    final int totalAmount = rentPerBed * selectedBeds;
    // ignore: unused_local_variable
    final user = FirebaseAuth.instance.currentUser;

    try {
      // Owner er businessName fetch
      final ownerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.ownerId)
          .get();
      final businessName = ownerDoc.data()?['businessName'] ?? 'Business';

      // Shudhu bookingId generate koro, doc create koro na
      final bookingId = FirebaseFirestore.instance
          .collection('bookings')
          .doc()
          .id;

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BkashPaymentPage(
              room: widget.room,
              roomId: widget.roomId,
              hostel: widget.hostel,
              ownerId: widget.ownerId,
              hostelName: widget.hostelName,
              studentName: nameController.text.trim(),
              studentPhone: phoneController.text.trim(),
              studentEmail: emailController.text.trim(),
              selectedBeds: selectedBeds,
              moveInDate: selectedDate!,
              amount: totalAmount,
              rentPerBed: rentPerBed,
              bookingId: bookingId,
              businessName: businessName,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String roomNumber = s(widget.room['room_number'], 'Room');
    final int rent = i(
      widget.room['monthly_rent'] ??
          widget.room['rent'] ??
          widget.room['price'],
      0,
    );
    final int totalBeds = i(
      widget.room['beds'] ?? widget.room['total_beds'],
      1,
    );
    final int bookedBeds = i(widget.room['booked_beds'], 0);
    final int availableBeds = totalBeds - bookedBeds;
    final int totalAmount = rent * selectedBeds;

    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Book Room",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.hostelName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.meeting_room, color: primaryBlue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Room $roomNumber",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.attach_money, color: primaryBlue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Tk $rent / month per bed",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.bed, color: primaryBlue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "$availableBeds of $totalBeds beds available",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (availableBeds > 1) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Number of Beds",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        initialValue: selectedBeds,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: lightBlue,
                        ),
                        items: List.generate(availableBeds, (index) => index + 1)
                            .map(
                              (bed) => DropdownMenuItem(
                                value: bed,
                                child: Text(
                                  "$bed bed${bed > 1 ? 's' : ''} - Tk ${rent * bed}",
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => selectedBeds = val!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    selectedDate == null
                        ? "Select Move-in Date *"
                        : "Move-in: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: Icon(Icons.calendar_today, color: primaryBlue),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) setState(() => selectedDate = date);
                  },
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "Your Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name *",
                        prefixIcon: Icon(Icons.person, color: primaryBlue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: lightBlue,
                      ),
                      validator: (val) => val == null || val.trim().isEmpty
                          ? "Name required"
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      decoration: InputDecoration(
                        labelText: "Phone Number *",
                        hintText: "01XXXXXXXXX",
                        prefixIcon: Icon(Icons.phone, color: primaryBlue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: lightBlue,
                        counterText: "",
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty)
                          return "Phone required";
                        if (!phoneRegex.hasMatch(val.trim()))
                          return "Enter valid BD number: 01XXXXXXXXX";
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email *",
                        prefixIcon: Icon(Icons.email, color: primaryBlue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: lightBlue,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty)
                          return "Email required";
                        if (!emailRegex.hasMatch(val.trim()))
                          return "Enter valid email";
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryBlue),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    Text(
                      "Tk $totalAmount",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: selectedDate == null ? null : _proceedToPayment,
                  child: const Text(
                    "Proceed to Payment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
