import 'package:flutter/material.dart';

class GroupDetailScreen extends StatelessWidget {
  final Map<String, dynamic> group; // 그룹 데이터

  const GroupDetailScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    // 'members' 필드를 명시적으로 List<String>으로 변환
    final members = (group['members'] as List<dynamic>).cast<String>();

    return Scaffold(
      appBar: AppBar(
        title: Text(group['name']),
        backgroundColor: const Color(0xFF1D3557),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 그룹 이름
            Text(
              "그룹 이름: ${group['name']}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 그룹 설명
            Text(
              "그룹 설명:",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              group['description'] ?? "설명이 없습니다.",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // 멤버 목록
            Text(
              "멤버 목록:",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: members.isNotEmpty
                  ? ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(members[index]),
                        );
                      },
                    )
                  : const Text("멤버가 없습니다."),
            ),
          ],
        ),
      ),
    );
  }
}