// lib/mock/mock_items.dart

import 'package:aureola_platform/models/items/items_model.dart';

final List<MenuItem> sampleItems = [
  MenuItem(
    itemId: 'item1',
    itemName: {
      'en': 'Espresso',
      'ar': 'إسبريسو',
    },
    description: {
      'en': 'Strong and bold espresso shot.',
      'ar': 'جرعة إسبريسو قوية وجريئة.',
    },
    price: 3.00,
    imageUrl:
        'https://picsum.photos/seed/espresso/200/200', // Placeholder image
    isAvailable: true,
    dietaryTags: ['vegan', 'gluten-free'],
    availability: ['dine-in', 'takeaway'],
  ),
  MenuItem(
    itemId: 'item2',
    itemName: {
      'en': 'Latte',
      'ar': 'لاتيه',
    },
    description: {
      'en': 'Creamy latte with steamed milk.',
      'ar': 'لاتيه كريمي مع حليب مبخر.',
    },
    price: 4.50,
    imageUrl: 'https://picsum.photos/seed/latte/200/200',
    isAvailable: true,
    dietaryTags: ['vegetarian'],
    availability: ['dine-in', 'takeaway', 'delivery'],
  ),
  MenuItem(
    itemId: 'item3',
    itemName: {
      'en': 'Bagel',
      'ar': 'بيغل',
    },
    description: {
      'en': 'Freshly baked bagel with cream cheese.',
      'ar': 'بيغل مخبوز طازجاً مع جبن كريمي.',
    },
    price: 2.75,
    imageUrl: 'https://picsum.photos/seed/bagel/200/200',
    isAvailable: true,
    dietaryTags: ['vegetarian'],
    availability: ['dine-in', 'takeaway'],
  ),
  MenuItem(
    itemId: 'item4',
    itemName: {
      'en': 'Avocado Toast',
      'ar': 'توست الأفوكادو',
    },
    description: {
      'en': 'Toasted bread topped with fresh avocado.',
      'ar': 'خبز محمص مغطى بالأفوكادو الطازج.',
    },
    price: 5.25,
    imageUrl: 'https://picsum.photos/seed/avocado_toast/200/200',
    isAvailable: true,
    dietaryTags: ['vegan'],
    availability: ['dine-in', 'takeaway', 'delivery'],
  ),
  MenuItem(
    itemId: 'item5',
    itemName: {
      'en': 'Blueberry Pancakes',
      'ar': 'فطائر التوت الأزرق',
    },
    description: {
      'en': 'Fluffy pancakes loaded with fresh blueberries.',
      'ar': 'فطائر خفيفة محشوة بالتوت الأزرق الطازج.',
    },
    price: 6.00,
    imageUrl: 'https://picsum.photos/seed/pancakes/200/200',
    isAvailable: true,
    dietaryTags: ['vegetarian'],
    availability: ['dine-in'],
  ),
];
