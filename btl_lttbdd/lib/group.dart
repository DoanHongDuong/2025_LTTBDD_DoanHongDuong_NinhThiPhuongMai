import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin nhóm'),
        centerTitle: true,
        elevation: 3,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dự án: Ứng dụng ToDo-List',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Thành viên nhóm:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.indigo[600],
            ),
          ),
          const Divider(thickness: 1, height: 20),

          const ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              child: Text('A'),
            ),
            title: Text('Ninh Thị Phương Mai'),
            subtitle: Text('Vai trò: '),
          ),
          const ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              child: Text('B'),
            ),
            title: Text('Đoàn Hồng Dương'),
            subtitle: Text('Vai trò: '),
          ),
        ],
      ),
    );
  }
}
