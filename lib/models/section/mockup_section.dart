// lib/mock/mock_sections.dart

import 'package:aureola_platform/models/items/mockup_items.dart';

import 'package:aureola_platform/models/section/section_model.dart';

final List<MenuSection> sampleSections = [
  MenuSection(
    sectionId: 'section1',
    sectionName: {
      'en': 'Beverages',
      'ar': 'مشروبات',
    },
    items: [
      sampleItems[0], // Espresso
      sampleItems[1], // Latte
    ],
  ),
  MenuSection(
    sectionId: 'section2',
    sectionName: {
      'en': 'Bakery Items',
      'ar': 'منتجات المخبوزات',
    },
    items: [
      sampleItems[2], // Bagel
      sampleItems[3], // Avocado Toast
      sampleItems[4], // Blueberry Pancakes
    ],
  ),
];
