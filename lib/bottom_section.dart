import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomSection extends StatelessWidget {
  final DateTime? selectedDate; // 선택된 날짜를 전달받음

  const BottomSection({super.key, this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                selectedDate != null
                    ? "선택된 날짜: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}"
                    : "날짜를 선택해주세요",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
