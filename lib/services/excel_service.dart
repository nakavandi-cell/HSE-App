import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'database_helper.dart';

class ExcelService {
  // ایجاد فایل اکسل از داده‌های دیتابیس
  static Future<String> exportInspectionsToExcel() async {
    final inspections = await DatabaseHelper.instance.getInspections();

    var excel = Excel.createExcel();
    var sheet = excel['سوابق بازرسی'];

    // عنوان ستون‌ها
    sheet.appendRow([
      'شناسه',
      'عنوان چک‌لیست',
      'تجهیز/بخش',
      'نام بازرس',
      'تاریخ',
    ]);

    // پر کردن داده‌ها
    for (final item in inspections) {
      sheet.appendRow([
        item['id'],
        item['checklistTitle'],
        '${item['assetLabel']}: ${item['assetValue']}',
        item['inspectorName'],
        item['date'],
      ]);
    }

    // ذخیره فایل در حافظه دستگاه
    final bytes = excel.save();
    if (bytes == null) {
      throw Exception('خطا در ایجاد فایل اکسل');
    }

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'HSE_Inspections_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final filePath = '${dir.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }

  // اشتراک‌گذاری فایل
  static Future<void> shareExcelFile() async {
    final filePath = await exportInspectionsToExcel();
    await Share.shareXFiles([XFile(filePath)], text: 'خروجی سوابق بازرسی HSE');
  }
}
