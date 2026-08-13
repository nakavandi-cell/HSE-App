code = r'''import 'package:flutter/material.dart';

void main() => runApp(const HSEApp());

/* ============================================================
   سیستم مدیریت HSE  -  نسخه حرفه‌ای
   فاز ۱: منوی کامل + چک‌لیست‌های تخصصی + گزارش‌گیری پایه
   اطلاعات از مستند ملی HSE-6-028 استخراج و دسته‌بندی شده است.
   ============================================================ */

/* ---------- مدل داده ---------- */
class ChecklistItem {
  final int number;
  final String question;
  final List<String> options; // گزینه‌های انتخابی (بله/خیر/تا حدودی)
  ChecklistItem(this.number, this.question, this.options);
}

class ChecklistCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final bool threeOptions; // چندگزینه‌ای (بله/تا حدودی/خیر)
  final List<ChecklistItem> items;
  ChecklistCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    this.threeOptions = false,
    required this.items,
  });
}

/* ---------- ذخیره‌سازی جلسه (نسخه Pro با دیتابیس بعداً) ---------- */
class SavedReport {
  final String category;
  final String unit;
  final String date;
  final String inspector;
  final int total;
  final int passed;
  final int partial;
  final int failed;
  final String summary;
  SavedReport({
    required this.category,
    required this.unit,
    required this.date,
    required this.inspector,
    required this.total,
    required this.passed,
    required this.partial,
    required this.failed,
    required this.summary,
  });
}

class ReportsStore {
  static final List<SavedReport> items = [];
}

/* ---------- تعریف تمام چک‌لیست‌ها ---------- */
List<ChecklistCategory> buildCategories() {
  const yesNo = ['بله', 'خیر'];
  const yesPartialNo = ['بله', 'تا حدودی', 'خیر'];

  return [
    /* ===== ۱) کپسول اطفای حریق (استاندارد بازرسی) ===== */
    ChecklistCategory(
      id: 'fire',
      title: 'چک‌لیست کپسول اطفای حریق',
      icon: Icons.fire_extinguisher,
      color: Colors.red,
      items: [
        ChecklistItem(1, 'آیا کپسول آتش‌نشانی در محل تعیین‌شده نصب/قرار داده شده است؟', yesNo),
        ChecklistItem(2, 'آیا دسترسی به کپسول بدون مانع و باز است؟', yesNo),
        ChecklistItem(3, 'آیا کپسول در ارتفاع استاندارد (حداکثر ۱۲۰ سانتی‌متر از کف) نصب شده است؟', yesNo),
        ChecklistItem(4, 'آیا عقربه فشارسنج کپسول در محدوده سبز (نرمال) قرار دارد؟', yesNo),
        ChecklistItem(5, 'آیا پلمب (سرب) و ضامن ایمنی کپسول سالم و دست‌نخورده است؟', yesNo),
        ChecklistItem(6, 'آیا کارت/برچسب بازرسی دوره‌ای کپسول معتبر و به‌روز است؟', yesNo),
        ChecklistItem(7, 'آیا تاریخ شارژ مجدد کپسول منقضی نشده است؟', yesNo),
        ChecklistItem(8, 'آیا بدنه کپسول فاقد زنگ‌زدگی، فرورفتگی و آسیب فیزیکی است؟', yesNo),
        ChecklistItem(9, 'آیا شیلنگ و نازل کپسول سالم و فاقد ترک‌خوردگی یا گرفتگی است؟', yesNo),
        ChecklistItem(10, 'آیا نوع کپسول متناسب با کلاس خطر محل استقرار (A/B/C/D) است؟', yesNo),
        ChecklistItem(11, 'آیا برچسب راهنمای استفاده روی کپسول سالم و خوانا است؟', yesNo),
        ChecklistItem(12, 'آیا وزن کپسول در محدوده مجاز (کمتر از ۱۰٪ کاهش نسبت به اسمی) است؟', yesNo),
        ChecklistItem(13, 'آیا محل استقرار کپسول دارای علامت/تابلوی استاندارد آتش‌نشانی است؟', yesNo),
        ChecklistItem(14, 'آیا کپسول دارای گواهی معتبر آزمایش هیدرواستاتیک دوره‌ای است؟', yesNo),
        ChecklistItem(15, 'آیا کپسول‌ها ماهانه و به‌صورت دوره‌ای توسط مسئول بازرسی چک می‌شوند؟', yesNo),
      ],
    ),

    /* ===== ۲) ایمنی تابلو برق عمومی ===== */
    ChecklistCategory(
      id: 'panel',
      title: 'چک‌لیست ایمنی تابلو برق عمومی',
      icon: Icons.electrical_services,
      color: Colors.deepOrange,
      items: [
        ChecklistItem(24, 'تابلوهای برق سالم می‌باشند؟', yesNo),
        ChecklistItem(25, 'محل قرارگرفتن تابلوهای برق مناسب است؟', yesNo),
        ChecklistItem(26, 'تابلوهای برق در محفظه قفل‌دار مخصوص قرار دارند؟', yesNo),
        ChecklistItem(27, 'تابلو برق در اختیار فرد مسئول و مورد بازرسی مستمر می‌باشد؟', yesNo),
        ChecklistItem(28, 'اطراف تابلو برق فضای کافی (۱.۵ متر مربع) وجود دارد؟', yesNo),
        ChecklistItem(29, 'توصیه‌های ایمنی لازم در مجاورت تابلو نصب گردیده است؟', yesNo),
        ChecklistItem(30, 'درب تابلو مجهز به قفل مخصوص می‌باشد؟', yesNo),
        ChecklistItem(31, 'تابلوهای (PLC) دارای کلید حفاظتی (جهت جلوگیری از وقوع حوادث) می‌باشند؟', yesNo),
        ChecklistItem(32, 'فرش لاستیکی یا سکوی عایق در کنار تابلو موجود است؟', yesNo),
        ChecklistItem(33, 'اطفاءکننده حریق متناسب در کنار تابلو موجود است؟ (ترجیحاً کپسول انیدرید کربنیک)', yesNo),
        ChecklistItem(34, 'کابل‌کشی استاندارد و مسیر سیم‌ها در تابلو قابل ردیابی است؟', yesNo),
        ChecklistItem(35, 'تابلو دارای سیستم اتصال به زمین (ارت) می‌باشد؟', yesNo),
        ChecklistItem(36, 'تابلو مجهز به سایر سیستم‌های حفاظتی مناسب (آژیر، فیوز، بیمتال و غیره) است؟', yesNo),
        ChecklistItem(37, 'فاصله محل ورود سیم از پایین تابلو تا ترمینال مجاز (۳۵ سانتی‌متر) است؟', yesNo),
        ChecklistItem(38, 'گلند جهت ورود سیم به داخل تابلو نصب گردیده است؟', yesNo),
        ChecklistItem(39, 'پلاگ یا جسم مناسب (سوراخ‌بند) برای پوشش سوراخ‌های باز و اضافی تابلو موجود است؟', yesNo),
        ChecklistItem(40, 'موقعیت کلیدها و نشانگرها در تابلو به لحاظ ایجاد فاصله لازم هنگام کار مناسب است؟', yesNo),
        ChecklistItem(41, 'برچسب‌های علامت‌گذاری کابل‌های مدار تابلو مناسب است؟', yesNo),
        ChecklistItem(42, 'فیوزها و کلیدهای خودکار متناسب با ولتاژ و جریان عبوری شبکه نصب شده‌اند؟', yesNo),
        ChecklistItem(43, 'روشنایی عمومی و موضعی تابلو مناسب می‌باشد؟', yesNo),
        ChecklistItem(44, 'محافظ‌هایی جهت تجهیزات الکتریکی حساس روی تابلو در نظر گرفته شده است؟', yesNo),
      ],
    ),

    /* ===== ۳) ایمنی تابلو پست برق (۲۰ کیلو ولت) ===== */
    ChecklistCategory(
      id: 'substation',
      title: 'چک‌لیست ایمنی پست برق ۲۰ کیلو ولت',
      icon: Icons.flash_on,
      color: Colors.amber.shade800,
      items: [
        ChecklistItem(45, 'در دو طرف تابلو برق فشار قوی، حداقل ۶۰ سانتی‌متر تا دیوار فاصله وجود دارد؟', yesNo),
        ChecklistItem(46, 'فاصله جلوی تابلو تا دیوار ۱۳۰ سانتی‌متر می‌باشد؟', yesNo),
        ChecklistItem(47, 'ارتفاع از کف پست برق تا روشنایی سقف حداقل ۱۹۰ سانتی‌متر است؟', yesNo),
        ChecklistItem(48, 'حداقل فضای دسترسی از روبه‌رو تابلو ۷۵ سانتی‌متر است؟', yesNo),
        ChecklistItem(49, 'فاصله بالای تابلو (از ارتفاع ۱۹۰ سانتی‌متر تا سقف) حداقل ۹۰ سانتی‌متر است؟', yesNo),
        ChecklistItem(50, 'بر روی تابلو علامت/نوشته «توجه ولتاژ بالا» نصب یا نوشته شده است؟', yesNo),
        ChecklistItem(51, 'جنب تابلو، خاموش‌کننده حریق انیدرید کربنیک نصب شده است؟', yesNo),
        ChecklistItem(52, 'فرش عایق متناسب با ولتاژ جلوی تابلو وجود دارد؟', yesNo),
        ChecklistItem(53, 'دستکش و کلاه ایمنی (کلاس B)، چکمه عایق، هندل مخصوص شارژ و فازمتر متناسب با ولتاژ در دسترس است؟', yesNo),
        ChecklistItem(54, 'مخزن اضطراری روغن ترانس برق (تعبیه‌شده در کف تابلو) سالم و بدون نشتی است؟', yesNo),
        ChecklistItem(55, 'غیر از درب ورودی، منفذ دیگری (در یا پنجره) پیش‌بینی شده است؟', yesNo),
        ChecklistItem(56, 'در اطراف ترانسفورماتورهای برق حداقل ۸۰ سانتی‌متر فاصله وجود دارد؟', yesNo),
        ChecklistItem(57, 'فاصله کف ترانسفورماتورهای برق تا کانال آب‌رو حداقل ۲۰ سانتی‌متر است؟', yesNo),
        ChecklistItem(58, 'در پست برق، سیستم اعلام حریق متناسب نصب شده است؟', yesNo),
        ChecklistItem(59, 'در پست برق، سیستم اطفاء (از نوع اسپرینکلر انیدرید کربنیک) نصب شده است؟', yesNo),
      ],
    ),

    /* ===== ۴) ایمنی برق و وسایل پرتابل ===== */
    ChecklistCategory(
      id: 'portable',
      title: 'چک‌لیست ایمنی برق و وسایل پرتابل',
      icon: Icons.security,
      color: Colors.indigo,
      threeOptions: true,
      items: [
        ChecklistItem(1, 'آیا کلیه وسایل الکتریکی و ادوات برقی مثل کلیدها، پریزها و غیره سالم هستند؟', yesPartialNo),
        ChecklistItem(2, 'آیا سیم‌کشی مطابق اصول فنی می‌باشد؟', yesPartialNo),
        ChecklistItem(3, 'آیا سیم‌کشی غیرمجاز وجود دارد؟', yesPartialNo),
        ChecklistItem(4, 'آیا سیم‌ها از داخل لوله‌های عایق یا سینی برق عبور داده شده‌اند؟', yesPartialNo),
        ChecklistItem(5, 'آیا سر راه جریان برق دستگاه‌ها، فیوز سالم و متناسب قرار دارد؟', yesPartialNo),
        ChecklistItem(6, 'آیا هنگام تعمیرات از ابزار و وسایل ایمنی عایق استفاده می‌شود؟', yesPartialNo),
        ChecklistItem(7, 'آیا تعمیرات برق توسط افراد مسئول و متخصص انجام می‌شود؟', yesPartialNo),
        ChecklistItem(8, 'آیا هنگام تعمیر دستگاه‌های برقی، فیوز تابلو برق مربوطه برداشته شده و تابلو «دست نزنید» نصب می‌شود؟', yesPartialNo),
        ChecklistItem(9, 'آیا کابل‌های دستگاه‌های الکتریکی از کابل‌های دستگاه‌های خبرکننده (کاشف‌ها detektor) جدا می‌باشد؟', yesPartialNo),
        ChecklistItem(10, 'آیا نکات ایمنی در خصوص سیم‌های سیار رعایت می‌شود؟', yesPartialNo),
        ChecklistItem(11, 'آیا از وسایل حفاظت فردی مناسب در هنگام کار با وسایل برقی استفاده می‌شود؟', yesPartialNo),
        ChecklistItem(12, 'آیا کارگران برق‌کار آموزش‌های لازم در مورد ایمنی برق و کمک‌های اولیه را دیده‌اند؟', yesPartialNo),
        ChecklistItem(13, 'آیا سیستم اتصال به زمین (چاه ارت) و دستگاه ارت وجود دارد؟', yesPartialNo),
        ChecklistItem(14, 'آیا تمام دستگاه‌ها و تابلوهای برق به سیستم ارت متصل هستند و سیم اتصال به زمین دوره‌ای چک می‌شود؟', yesPartialNo),
        ChecklistItem(15, 'آیا مقاومت چاه ارت به‌صورت دوره‌ای مورد ارزیابی قرار می‌گیرد؟', yesPartialNo),
        ChecklistItem(16, 'آیا نکات ایمنی در هنگام کار در مکان‌های مرطوب رعایت می‌گردد؟', yesPartialNo),
        ChecklistItem(17, 'آیا قبل از استفاده از وسایل و ابزارآلات برقی کنترل ایمنی آن‌ها (زدگی، پارگی و غیره) صورت می‌گیرد؟', yesPartialNo),
        ChecklistItem(18, 'آیا قبل از استفاده از وسایل برقی ولتاژ آن کنترل می‌شود؟ (آیا دستگاه‌ها نشانگر ولتاژ دارند)', yesPartialNo),
        ChecklistItem(19, 'آیا سیستم برق‌گیر نصب شده و کارگاه را به‌صورت مناسب تحت پوشش قرار می‌دهد؟', yesPartialNo),
        ChecklistItem(20, 'آیا نگهداری تجهیزات الکتریکی نصب‌شده به‌صورت دوره‌ای صورت می‌گیرد؟', yesPartialNo),
        ChecklistItem(21, 'آیا کلیدهای الکتریکی دستگاه‌ها برچسب‌های مناسب شناسایی دارند؟', yesPartialNo),
        ChecklistItem(22, 'آیا دستورالعمل‌های مناسب ایمنی برق وجود دارد و رعایت می‌گردد؟', yesPartialNo),
        ChecklistItem(23, 'آیا آموزش‌های لازم در خصوص ایمنی برق و کمک‌های اولیه هنگام برق‌گرفتگی داده شده است؟', yesPartialNo),
        ChecklistItem(60, 'آیا پریزهای تک‌فاز و سه‌فاز دارای سیم ارت می‌باشند؟', yesNo),
        ChecklistItem(61, 'آیا قسمت‌های الکتریکی بین دستگاه‌ها عایق می‌باشد؟', yesNo),
        ChecklistItem(62, 'آیا کلید دستگاه‌ها عایق هستند؟', yesNo),
        ChecklistItem(63, 'آیا سیم رابط و سیم سیار سالم است؟', yesNo),
        ChecklistItem(64, 'آیا سیم اتصال به زمین به‌درستی طراحی شده است؟', yesNo),
        ChecklistItem(65, 'آیا از تعمیر دستگاه توسط افراد غیرمسئول جلوگیری می‌شود؟', yesNo),
        ChecklistItem(66, 'آیا پریزها به تعداد کافی نصب شده‌اند تا از سیم‌کشی‌های سیار خودداری شود؟', yesNo),
        ChecklistItem(67, 'آیا قبل از وصل دستگاه به برق، دستگاه به سیم اتصال به زمین متصل می‌شود؟', yesNo),
        ChecklistItem(68, 'آیا پریزها دارای کلید مخصوص قطع جریان برق می‌باشند؟ (آیا داخل تابلو فیوز دارد؟)', yesNo),
      ],
    ),
  ];
}

/* ---------- صفحه اصلی (منو) ---------- */
class HSEApp extends StatelessWidget {
  const HSEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'سیستم HSE',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1B4F72),
      ),
      home: const MainMenuPage(),
    );
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = buildCategories();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سیستم مدیریت HSE'),
          centerTitle: true,
          backgroundColor: const Color(0xFF1B4F72),
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE8F0F8), Color(0xFFD6E4F0)],
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: ListView(
            children: [
              _headerCard(context),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Text(
                  'فرم‌های بازرسی و چک‌لیست',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B4F72)),
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.35,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: categories.map((c) => _menuCard(context, c)).toList(),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.bar_chart),
                      label: const Text('گزارش‌گیری / نتایج'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsPage())),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'نسخه حرفه‌ای HSE  |  بازرسی فنی دوره‌ای',
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCard(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1B4F72)),
              child: const Icon(Icons.health_and_safety, color: Colors.white, size: 34),
            ),
            const SizedBox(height: 8),
            const Text('سیستم جامع مدیریت HSE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('بازرسی ایمنی برق و تجهیزات آتش‌نشانی', style: TextStyle(fontSize: 13, color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(BuildContext context, ChecklistCategory c) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChecklistPage(category: c))),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [c.color.withOpacity(0.12), c.color.withOpacity(0.05)],
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(c.icon, size: 42, color: c.color),
              const SizedBox(height: 8),
              Text(
                c.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text('${c.items.length} سؤال بازرسی', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------- صفحه چک‌لیست ---------- */
class ChecklistPage extends StatefulWidget {
  final ChecklistCategory category;
  const ChecklistPage({super.key, required this.category});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final _unitCtrl = TextEditingController();
  final _inspectorCtrl = TextEditingController();
  final Map<int, String> _responses = {};
  String _date = '';
  double _score = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';
  }

  String? _savedMessage;

  void _save() {
    final items = widget.category.items;
    int passed = 0, partial = 0, failed = 0;

    for (final item in items) {
      final val = _responses[item.number];
      if (val == null) continue;
      if (val == 'بله') passed++;
      else if (val == 'خیر') failed++;
      else partial++;
    }

    final answered = passed + partial + failed;
    final score = items.isEmpty ? 0 : (passed + partial * 0.5) / items.length * 100;

    ReportsStore.items.add(SavedReport(
      category: widget.category.title,
      unit: _unitCtrl.text.trim().isEmpty ? 'نامشخص' : _unitCtrl.text.trim(),
      date: _date,
      inspector: _inspectorCtrl.text.trim().isEmpty ? 'نامشخص' : _inspectorCtrl.text.trim(),
      total: items.length,
      passed: passed,
      partial: partial,
      failed: failed,
      summary: 'پاسخ داده‌شده: $answered از ${items.length}  |  امتیاز: ${score.toStringAsFixed(1)}٪',
    ));

    setState(() {
      _savedMessage = 'گزارش با موفقیت ثبت شد ✅';
      _score = score;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ثبت شد: ${items.length} سؤال  |  امتیاز ${score.toStringAsFixed(1)}٪')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.category.items;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category.title, style: const TextStyle(fontSize: 16)),
          backgroundColor: widget.category.color,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            /* --- بخش مشخصات --- */
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _unitCtrl,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            labelText: 'نام واحد',
                            prefixIcon: Icon(Icons.factory),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _inspectorCtrl,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            labelText: 'نام بازرس',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() => _date = '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}');
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'تاریخ بازدید',
                              prefixIcon: Icon(Icons.calendar_month),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            child: Text(_date, textAlign: TextAlign.right),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.rule, color: widget.category.color),
                              const SizedBox(width: 6),
                              Text('${items.length} سؤال', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            /* --- لیست سؤالات --- */
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final item = items[i];
                  return Card(
                    elevation: 1.5,
                    color: _responses[item.number] == 'خیر'
                        ? Colors.red.shade50
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.number}. ${item.question}',
                            style: const TextStyle(fontSize: 13.5, height: 1.5),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 4,
                            children: item.options.map((opt) {
                              final selected = _responses[item.number] == opt;
                              return ChoiceChip(
                                label: Text(opt, style: const TextStyle(fontSize: 12)),
                                selected: selected,
                                showCheckmark: false,
                                onSelected: (_) => setState(() {
                                  _responses[item.number] = selected ? null : opt;
                                }),
                                selectedColor: opt == 'بله'
                                    ? Colors.green
                                    : opt == 'خیر'
                                        ? Colors.red
                                        : Colors.amber,
                                labelStyle: TextStyle(
                                  color: selected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /* --- دکمه ثبت --- */
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
              ]),
              child: Row(
                children: [
                  Expanded(
                    child: _savedMessage == null
                        ? ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('ثبت نهایی چک‌لیست'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _save,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green.shade300),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(_savedMessage!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                                const SizedBox(height: 4),
                                Text('امتیاز نهایی: ${_score.toStringAsFixed(1)}٪'},
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------- صفحه گزارش‌گیری ---------- */
class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('گزارش‌گیری'),
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
        body: ReportsStore.items.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 70, color: Colors.blueGrey),
                    SizedBox(height: 12),
                    Text('هنوز گزارشی ثبت نشده است', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 6),
                    Text('ابتدا یک چک‌لیست را تکمیل و ثبت کنید', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: ReportsStore.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final r = ReportsStore.items[i];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.assignment_turned_in, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(child: Text(r.category, style: const TextStyle(fontWeight: FontWeight.bold))),
                              Text(r.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                          const Divider(height: 14),
                          Row(
                            children: [
                              Expanded(child: _infoCell('واحد', r.unit)),
                              Expanded(child: _infoCell('بازرس', r.inspector)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _stat('بله', r.passed, Colors.green),
                              _stat('تا حدودی', r.partial, Colors.amber),
                              _stat('خیر', r.failed, Colors.red),
                              _stat('کل', r.total, Colors.blueGrey),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(r.summary, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _infoCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _stat(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text('$value', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ],
      ),
    );
  }
}
'''

with open('/mnt/data/hse_app_main.dart', 'w', encoding='utf-8') as f:
    f.write(code)

print("ساختار باز رایانه: checking for common syntax issues")
# quick check for obvious unbalanced braces
opens = code.count('{'); closes = code.count('}')
print("braces open:", opens, "close:", closes)
opens_p = code.count('('); closes_p = code.count(')')
print("parens open:", opens_p, "close:", closes_p)
opens_b = code.count('['); closes_b = code.count(']')
print("brackets open:", opens_b, "close:", closes_b)
print("lines:", code.count('\n'))
