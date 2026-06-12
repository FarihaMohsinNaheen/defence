import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'owner_chat_page.dart';

const Color primaryBlue = Color(0xFF003366);

class OwnerBookingCard extends StatefulWidget {
  final Map<String, dynamic> booking;
  const OwnerBookingCard({super.key, required this.booking});

  @override
  State<OwnerBookingCard> createState() => _OwnerBookingCardState();
}

class _OwnerBookingCardState extends State<OwnerBookingCard> {
  bool _isExpanded = false;

  String _formatDate(dynamic ts) {
    if (ts == null) return '-';
    try {
      final dt = ts.toDate();
      return "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return ts.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;

    // Status + cancel check
    final status = (booking['status'] ?? '').toString().toLowerCase();
    final isCancelled = status == 'cancelled';
    final cancelledAt = booking['cancelled_at'] as Timestamp?;

    // Purana + notun booking er jonno safe calculation
    final int beds = (booking['beds'] ?? booking['beds_booked'] ?? 1).toInt();
    final int rentPerBed = (booking['rent'] ?? booking['monthly_rent'] ?? 0)
        .toInt();
    final int totalRent = (booking['total_rent'] ?? (beds * rentPerBed))
        .toInt();

    // bookingId ber kori - doc.id na thakle booking er id field theke
    final bookingId =
        booking['id'] ?? booking['booking_id'] ?? booking['doc_id'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCancelled
              ? Colors.red.withOpacity(0.5)
              : primaryBlue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isCancelled
                          ? Colors.red.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isCancelled ? Icons.cancel : Icons.check_circle,
                      color: isCancelled ? Colors.red : Colors.green,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['hostel_name'] ?? 'Hostel',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Room ${booking['room_number'] ?? ''}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: primaryBlue,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  Divider(height: 1, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  _infoRow('Student Name:', booking['student_name']),
                  _infoRow('Email:', booking['student_email']),
                  _infoRow('Phone:', booking['student_phone']),
                  _infoRow('bKash:', booking['bkash_number']),
                  _infoRow('Beds:', '$beds beds'),
                  _infoRow('Rent:', 'Tk $rentPerBed'),
                  _infoRow('Total Rent:', 'Tk $totalRent'),
                  _infoRow('Paid At:', _formatDate(booking['paid_at'])),
                  _infoRow('Method:', booking['payment_method']),
                  _infoRow('Txn ID:', booking['transaction_id']),

                  // Cancel hoile cancel time dekhabe
                  if (isCancelled && cancelledAt != null)
                    _infoRow(
                      'Cancelled At:',
                      DateFormat(
                        'dd MMM yyyy, hh:mm a',
                      ).format(cancelledAt.toDate()),
                    ),

                  // Chat Button - cancel hoile disable
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16),
                    child: ElevatedButton.icon(
                      onPressed: isCancelled
                          ? null
                          : () {
                              final ownerId = booking['owner_id'];
                              final studentId = booking['student_id'];

                              if (ownerId == null ||
                                  studentId == null ||
                                  bookingId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Error: id missing'),
                                  ),
                                );
                                return;
                              }

                              // FIX: chatId er sathe bookingId add korlam
                              final chatId =
                                  "${ownerId}_${studentId}_$bookingId";

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OwnerChatPage(
                                    chatId: chatId,
                                    bookingId:
                                        bookingId, // <-- bookingId pass korlam
                                    studentName:
                                        booking['student_name'] ?? 'Student',
                                    studentId: studentId,
                                    hostelName: booking['hostel_name'],
                                    roomNumber:
                                        booking['room_number'], // optional
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.chat_bubble_outline, size: 20),
                      label: Text(
                        isCancelled ? 'Booking Cancelled' : 'Chat with Student',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCancelled
                            ? Colors.grey
                            : primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ===== CANCELLED BADGE - NICHE =====
          if (isCancelled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.block, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "BOOKING CANCELLED",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          // ===== BADGE END =====
        ],
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
