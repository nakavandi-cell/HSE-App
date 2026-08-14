import 'package:flutter/material.dart';
import '../data/checklist_data.dart';
import '../models/checklist.dart';
import '../services/database_helper.dart';

class InspectionForm extends StatefulWidget {
  final String checklistId;

  const InspectionForm({super.key, required this.checklistId});

  @override
  State<InspectionForm> createState() => _InspectionFormState();
}

class _InspectionFormState extends State<InspectionForm> {
  final _formKey = GlobalKey<FormState>();
  final _assetController = TextEditingController();
  final _inspectorController = TextEditingController();
  final _locationController = TextEditingController();

  late ChecklistModel checklist;
  final Map<String, String> answers = {};
  final Map<String, TextEditingController> noteControllers = {};

  @override
  void initState() {
    super.initState();
    checklist = ChecklistData.getById(widget.checklistId)!;

    for (var item in checklist.items) {
      answers[item.id] = 'yes';
      noteControllers[item.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _assetController.dispose();
    _inspectorController.dispose();
    _locationController.dispose();
    for (var c in noteControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _saveInspection() async {
    if (!_formKey.currentState!.validate()) return;

    final db = DatabaseHelper.instance;

    final inspectionId = await db.insertInspection({
      'checklistId': checklist.id,
      'checklistTitle': checklist.title,
      'assetLabel': checklist.assetLabel,
      'assetValue': _assetController.text,
      'inspectorName': _inspectorController.text,
      'location': _locationController.text,
      'inspectionDate': DateTime.now().toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
    });

    for (var item in checklist.items) {
      await db.insertAnswer({
        'inspectionId': inspectionId,
        'itemId': item.id,
        'question': item.text,
        'answer': answers[item.id],
        'correctiveAction': answers[item.id] == 'no'
            ? noteControllers[item.id]!.text
            : null,
        'note': answers[item.id] == 'no'
            ? noteControllers[item.id]!.text
            : null,
      });
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('بازرسی با موفقیت ذخیره شد')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(checklist.title),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _assetController,
                decoration: InputDecoration(
                  labelText: checklist.assetLabel,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'این فیلد الزامی است';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _inspectorController,
                decoration: const InputDecoration(
                  labelText: 'نام بازرس',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'نام بازرس الزامی است';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'محل بازرسی',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'محل بازرسی الزامی است';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              ...checklist.items.map((item) {
                final noteController = noteControllers[item.id]!;
                final selectedAnswer = answers[item.id] ?? 'yes';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.text,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'yes',
                              groupValue: selectedAnswer,
                              onChanged: (value) {
                                setState(() {
                                  answers[item.id] = value!;
                                });
                              },
                            ),
                            const Text('بله'),
                            Radio<String>(
                              value: 'no',
                              groupValue: selectedAnswer,
                              onChanged: (value) {
                                setState(() {
                                  answers[item.id] = value!;
                                });
                              },
                            ),
                            const Text('خیر'),
                            Radio<String>(
                              value: 'na',
                              groupValue: selectedAnswer,
                              onChanged: (value) {
                                setState(() {
                                  answers[item.id] = value!;
                                });
                              },
                            ),
                            const Text('عدم کاربرد'),
                          ],
                        ),
                        if (selectedAnswer == 'no') ...[
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: noteController,
                            decoration: const InputDecoration(
                              labelText: 'توضیح / اقدام اصلاحی',
                            ),
                            maxLines: 2,
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveInspection,
                  child: const Text('ذخیره بازرسی'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
