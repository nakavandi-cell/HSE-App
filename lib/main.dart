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
      title: 'HSE App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainMenuPage(),
    );
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سیستم مدیریت HSE'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              menuButton(context, 'چک‌لیست کپسول حریق', Icons.fire_extinguisher, Colors.red, const FireChecklistPage()),
              menuButton(context, 'تابلو برق عمومی', Icons.electrical_services, Colors.orange, const PanelChecklistPage()),
              menuButton(context, 'تابلو پست برق', Icons.flash_on, Colors.amber, const SubstationChecklistPage()),
              menuButton(context, 'گزارش‌گیری', Icons.bar_chart, Colors.green, const ReportsPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuButton(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FireChecklistPage extends StatelessWidget {
  const FireChecklistPage({super.key});

  final List<String> questions = const [
    'آیا کپسول در محل مناسب نصب شده است؟',
    'آیا دسترسی به کپسول بدون مانع است؟',
    'آیا پلمب کپسول سالم است؟',
    'آیا فشارسنج در محدوده مجاز قرار دارد؟',
    'آیا بدنه کپسول سالم و بدون زنگ‌زدگی است؟',
    'آیا شیلنگ و نازل سالم هستند؟',
    'آیا تاریخ شارژ کپسول معتبر است؟',
    'آیا کارت بازدید دوره‌ای نصب شده است؟',
    'آیا نوع کپسول با خطرات محل متناسب است؟',
    'آیا پایه یا بست نگهدارنده کپسول سالم است؟',
  ];

  @override
  Widget build(BuildContext context) {
    return ChecklistScaffold(title: 'چک‌لیست کپسول حریق', questions: questions);
  }
}

class PanelChecklistPage extends StatelessWidget {
  const PanelChecklistPage({super.key});

  final List<String> questions = const [
    'تابلوهای برق سالم میباشد؟',
    'محل قرار گرفتن تابلوهای برق مناسب است؟',
    'تابلوهای برق در محفظه قفل‌دار مخصوص قرار دارد؟',
    'تابلو برق در اختیار فرد مسئول و مورد بازرسی مستمر میباشد؟',
    'اطراف تابلو برق فضای کافی دارد؟',
    'توصیه‌های ایمنی لازم در مجاورت تابلو نصب گردیده است؟',
    'درب تابلو مجهز به قفل مخصوص میباشد؟',
    'تابلوهای PLC دارای کلید حفاظتی میباشند؟',
    'فرش لاستیکی یا سکوی عایق در کنار تابلو موجود است؟',
    'کپسول اطفاء حریق متناسب در کنار تابلو موجود است؟',
    'کابل‌کشی استاندارد و مسیر سیم‌ها در تابلو قابل ردیابی میباشد؟',
    'تابلو دارای سیستم اتصال به زمین میباشد؟',
    'تابلو مجهز به سیستم‌های حفاظتی مناسب میباشد؟',
    'گلند جهت ورود سیم به داخل تابلو نصب شده است؟',
    'برچسب‌های علامت‌گذاری کابل‌های مدار تابلو مناسب میباشد؟',
    'روشنایی عمومی و موضعی تابلو مناسب میباشد؟',
  ];

  @override
  Widget build(BuildContext context) {
    return ChecklistScaffold(title: 'چک‌لیست تابلو برق عمومی', questions: questions);
  }
}

class SubstationChecklistPage extends StatelessWidget {
  const SubstationChecklistPage({super.key});

  final List<String> questions = const [
    'در دو طرف تابلو برق فشار قوی حداقل 60 سانتی‌متر تا دیوار فاصله وجود دارد؟',
    'فاصله جلوی تابلو تا دیوار 130 سانتی‌متر میباشد؟',
    'ارتفاع از کف پست برق تا روشنایی سقف حداقل 190 سانتی‌متر میباشد؟',
    'حداقل فضای دسترسی از روبروی تابلو 75 سانتی‌متر است؟',
    'فاصله بالای تابلو برق تا سقف حداقل 90 سانتی‌متر است؟',
    'علامت هشدار ولتاژ بالا روی تابلو نصب شده است؟',
    'خاموش‌کننده حریق CO2 در کنار تابلو نصب شده است؟',
    'فرش عایق متناسب با ولتاژ جلوی تابلو وجود دارد؟',
    'دستکش، کلاه ایمنی، چکمه عایق و فازمتر مخصوص در دسترس میباشد؟',
    'مخزن اضطراری روغن ترانس سالم و بدون نشتی میباشد؟',
    'غیر از درب ورودی منفذ دیگری پیش‌بینی شده است؟',
    'در اطراف ترانسفورماتور حداقل 80 سانتی‌متر فاصله وجود دارد؟',
    'فاصله کف ترانسفورماتور تا کانال آبرو حداقل 20 سانتی‌متر میباشد؟',
    'سیستم اعلام حریق متناسب در پست برق نصب شده است؟',
    'سیستم اطفاء حریق در پست برق نصب شده است؟',
  ];

  @override
  Widget build(BuildContext context) {
    return ChecklistScaffold(title: 'چک‌لیست تابلو پست برق', questions: questions);
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('گزارش‌گیری'),
        ),
        body: const Center(
          child: Text(
            'بخش گزارش‌گیری در نسخه بعدی تکمیل می‌شود',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class ChecklistScaffold extends StatefulWidget {
  final String title;
  final List<String> questions;

  const ChecklistScaffold({
    super.key,
    required this.title,
    required this.questions,
  });

  @override
  State<ChecklistScaffold> createState() => _ChecklistScaffoldState();
}

class _ChecklistScaffoldState extends State<ChecklistScaffold> {
  final Map<int, String> answers = {};

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.questions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${widget.questions[index]}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('بله'),
                                  value: 'بله',
                                  groupValue: answers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      answers[index] = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('خیر'),
                                  value: 'خیر',
                                  groupValue: answers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      answers[index] = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('اطلاعات چک‌لیست ثبت شد'),
                      ),
                    );
                  },
                  child: const Text('ثبت نهایی'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
