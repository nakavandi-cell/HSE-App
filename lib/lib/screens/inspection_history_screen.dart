import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class InspectionHistoryScreen extends StatefulWidget {
  const InspectionHistoryScreen({super.key});

  @override
  State<InspectionHistoryScreen> createState() => _InspectionHistoryScreenState();
}

class _InspectionHistoryScreenState extends State<InspectionHistoryScreen> {
  late Future<List<Map<String, dynamic>>> inspectionsFuture;

  @override
  void initState() {
    super.initState();
    inspectionsFuture = DatabaseHelper.instance.getInspections();
  }

  Future<void> _refreshData() async {
    setState(() {
      inspectionsFuture = DatabaseHelper.instance.getInspections();
    });
  }

  Future<void> _deleteInspection(int id) async {
    await DatabaseHelper.instance.deleteInspection(id);
    await _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سوابق بازرسی'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: inspectionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('هنوز هیچ بازرسی‌ای ثبت نشده است'),
            );
          }

          final inspections = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: inspections.length,
              itemBuilder: (context, index) {
                final item = inspections[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      item['checklistTitle'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${item['assetLabel'] ?? ''}: ${item['assetValue'] ?? ''}\n'
                      'بازرس: ${item['inspectorName'] ?? ''}',
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteInspection(item['id']),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
