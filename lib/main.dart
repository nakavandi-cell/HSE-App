import 'package:flutter/material.dart';
import 'package:hse_app/data/checklist_data.dart';
import 'package:hse_app/screens/inspection_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'چک‌لیست‌های HSE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('چک‌لیست‌های HSE'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ChecklistData.checklists.length,
        itemBuilder: (context, index) {
          final checklist = ChecklistData.checklists[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                checklist.icon,
                color: checklist.color,
                size: 32,
              ),
              title: Text(
                checklist.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(checklist.assetLabel),
              trailing: const Icon(Icons.chevron_left),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InspectionForm(
                      checklistId: checklist.id,
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
