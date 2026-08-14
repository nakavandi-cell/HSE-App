import 'package:flutter/material.dart';

void main() {
  runApp(const HSEApp());
}

class HSEApp extends StatelessWidget {
  const HSEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HSE Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Tahoma', // یا هر فونت فارسی که دارید
      ),
      home: const MainMenuPage(),
    );
  }
}

// --- مدل داده‌ای برای توسعه‌پذیری ---
class ChecklistItem {
  final int id;
  final String question;
  String answer; // بله، خیر، عدم کاربرد
  String comment; // توضیحات/اقدام اصلاحی

  ChecklistItem({required this.id, required this.question, this.answer = '', this.comment = ''});
}

class ChecklistModel {
  final String title;
  final String assetLabel; // مثلاً "کد کپسول" یا "نام تابلو"
  final List<ChecklistItem> items;

  ChecklistModel({required this.title, required this.assetLabel, required this.items});
}

// --- مرکز داده (Data Center) ---
// اینجا می‌توانید چک‌لیست‌های جدید را بدون تغییر در کد صفحه اضافه کنید
class HSEData {
  static List<ChecklistModel> getChecklists() {
    return [
      ChecklistModel(
        title: 'چک‌لیست کپسول حریق',
        assetLabel: 'کد/شماره کپسول',
        items: [
          ChecklistItem(id: 1, question: 'آیا کپسول در محل مناسب نصب شده است؟'),
          ChecklistItem(id: 2, question: 'آیا فشارسنج در محدوده مجاز قرار دارد؟'),
          // ... بقیه سؤالات
        ],
      ),
      ChecklistModel(
        title: 'تابلو برق عمومی',
        assetLabel: 'نام/کد تابلو برق',
        items: [
          ChecklistItem(id: 1, question: 'آیا تابلو دارای سیستم اتصال به زمین می‌باشد؟'),
          ChecklistItem(id: 2, question: 'آیا فرش عایق در کنار تابلو موجود است؟'),
        ],
      ),
      ChecklistModel(
        title: 'وسایل برقی قابل حمل',
        assetLabel: 'کد شناسایی دستگاه',
        items: [
          ChecklistItem(id: 1, question: 'آیا کابل و دوشاخه دستگاه سالم است؟'),
        ],
      ),
    ];
  }
}

// --- صفحه اصلی ---
class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final checklists = HSEData.getChecklists();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('پنل مدیریت HSE (نسخه اکسل)')),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
          ),
          itemCount: checklists.length + 1, // +1 برای دکمه گزارشات
          itemBuilder: (context, index) {
            if (index < checklists.length) {
              return menuCard(context, checklists[index]);
            } else {
              return reportCard(context);
            }
          },
        ),
      ),
    );
  }

  Widget menuCard(BuildContext context, ChecklistModel checklist) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChecklistFormPage(model: checklist))),
      child: Card(
        color: Colors.blue.shade50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment_turned_in, size: 40, color: Colors.blue),
            const SizedBox(height: 10),
            Text(checklist.title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget reportCard(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 40, color: Colors.green),
          SizedBox(height: 10),
          Text('خروجی اکسل و گزارشات', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// --- صفحه فرم چک‌لیست (هوشمند و عمومی) ---
class ChecklistFormPage extends StatefulWidget {
  final ChecklistModel model;
  const ChecklistFormPage({super.key, required this.model});

  @override
  State<ChecklistFormPage> createState() => _ChecklistFormPageState();
}

class _ChecklistFormPageState extends State<ChecklistFormPage> {
  final TextEditingController _assetController = TextEditingController();
  final TextEditingController _inspectorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.model.title)),
        body: Column(
          children: [
            // بخش شناسایی تجهیز
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  TextField(
                    controller: _assetController,
                    decoration: InputDecoration(labelText: widget.model.assetLabel, border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _inspectorController,
                    decoration: const InputDecoration(labelText: 'نام بازرس', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            // لیست سؤالات
            Expanded(
              child: ListView.builder(
                itemCount: widget.model.items.length,
                itemBuilder: (context, index) {
                  final item = widget.model.items[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${index + 1}. ${item.question}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              answerOption(item, 'بله'),
                              answerOption(item, 'خیر'),
                              answerOption(item, 'عدم کاربرد'),
                            ],
                          ),
                          if (item.answer == 'خیر')
                            TextField(
                              onChanged: (val) => item.comment = val,
                              decoration: const InputDecoration(hintText: 'توضیح عدم انطباق / اقدام اصلاحی'),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // دکمه ثبت
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('ثبت نهایی و ذخیره در دیتابیس'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget answerOption(ChecklistItem item, String label) {
    return Expanded(
      child: RadioListTile<String>(
        title: Text(label, style: const TextStyle(fontSize: 12)),
        value: label,
        groupValue: item.answer,
        contentPadding: EdgeInsets.zero,
        onChanged: (val) => setState(() => item.answer = val!),
      ),
    );
  }

  void _saveData() {
    // اینجا در گام بعدی کد ذخیره در SQL را می‌نویسیم
    if (_assetController.text.isEmpty || _inspectorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لطفاً اطلاعات تجهیز و بازرس را وارد کنید')));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اطلاعات آماده ذخیره در دیتابیس و تبدیل به اکسل است')));
  }
}
