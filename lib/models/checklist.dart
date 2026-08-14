import 'package:flutter/material.dart';

// ۱) یک سؤال/آیتم از چک‌لیست
class ChecklistItem {
  final String id;      // شناسه یکتا مثل 'fire_01'
  final String text;    // متن سؤال
  String answer;        // 'بله' یا 'خیر' یا 'عدم کاربرد'
  String comment;       // توضیح / اقدام اصلاحی (برای پاسخ خیر)

  ChecklistItem({
    required this.id,
    required this.text,
    this.answer = '',
    this.comment = '',
  });
}

// ۲) یک چک‌لیست کامل (کپسول، تابلو برق، ...)
class ChecklistModel {
  final String id;          // مثل 'fire' یا 'panel'
  final String title;       // عنوان نمایشی چک‌لیست
  final String assetLabel;  // برچسب فیلد شناسه تجهیز (مثلاً «کد/شماره کپسول»)
  final IconData? icon;     // آیکون منو
  final Color color;        // رنگ منو
  final List<ChecklistItem> items;

  ChecklistModel({
    required this.id,
    required this.title,
    required this.assetLabel,
    required this.items,
    this.icon,
    this.color = Colors.blue,
  });
}

// ۳) گزینه‌های مجاز برای هر سؤال
const List<String> answerOptions = ['بله', 'خیر', 'عدم کاربرد'];

// ۴) یک رکورد کامل بازرسی (که در دیتابیس ذخیره می‌شود)
class InspectionRecord {
  int? id;                      // شماره خودکار در دیتابیس
  final String checklistId;
  final String checklistTitle;
  final String assetCode;       // کد/شماره تجهیز
  final String assetName;       // نام تجهیز
  final String location;        // محل/واحد
  final String inspector;       // نام بازرس
  final String inspectionType;  // نوع بازرسی
  final String date;            // تاریخ بازرسی
  final List<Map<String, String>> answers; // [{question, answer, comment}]

  InspectionRecord({
    this.id,
    required this.checklistId,
    required this.checklistTitle,
    required this.assetCode,
    required this.assetName,
    required this.location,
    required this.inspector,
    required this.inspectionType,
    required this.date,
    required this.answers,
  });
}
