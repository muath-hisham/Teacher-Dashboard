import 'package:flutter/material.dart';
import 'menu_item.dart';

class MenuItems {
  static const List<MenuItem> items = [
    itemDelete,
  ];

  static const List<MenuItem> itemsLesson = [
    itemCopy,
    itemSend,
    itemEdit,
    itemDelete,
  ];

  static const List<MenuItem> itemsStudent = [
    itemChat,
    itemEdit,
    itemDelete,
  ];

  static const MenuItem itemDelete = MenuItem(
    text: 'حذف',
    icon: Icons.delete,
  );

  static const MenuItem itemCopy = MenuItem(
    text: 'نسخ الرابط',
    icon: Icons.copy,
  );

  static const MenuItem itemEdit = MenuItem(
    text: 'تعديل',
    icon: Icons.edit,
  );

  static const MenuItem itemChat = MenuItem(
    text: 'مراسلة',
    icon: Icons.chat,
  );

  static const MenuItem itemSend = MenuItem(
    text: 'ارسال الرابط',
    icon: Icons.send,
  );
}
