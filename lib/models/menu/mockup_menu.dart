// lib/mock/mock_menus.dart

import 'package:aureola_platform/models/menu/menu_availability.dart';
import 'package:aureola_platform/models/menu/menu_model.dart';
import 'package:aureola_platform/models/section/mockup_section.dart';

final MenuModel menu1 = MenuModel(
  menuId: 'menu1',
  venueId: 'venue1',
  menuName: {
    'en': 'Breakfast Menu',
    'ar': 'قائمة الإفطار',
  },
  description: {
    'en': 'Start your day with our delightful breakfast options.',
    'ar': 'ابدأ يومك مع خيارات الإفطار اللذيذة لدينا.',
  },
  notes: {
    'en': 'Allergen info available upon request.',
    'ar': 'معلومات مسببات الحساسية متوفرة عند الطلب.',
  },
  imageUrl: 'https://picsum.photos/400/200', // Placeholder image

  //sections: sampleSections, // Use the mock sections
  isOnline: true,
  visibleOnTablet: true,
  visibleOnQr: true,
  visibleOnPickup: false,
  visibleOnDelivery: false,
  availability: MenuAvailability(
    type: AvailabilityType.always,
  ),
  settings: {
    'themeColor': '#FFD700',
    'icon': 'breakfast_icon',
  },
);

final MenuModel menu2 = MenuModel(
  menuId: 'menu2',
  venueId: 'venue1',
  menuName: {
    'en': 'Main course',
    'ar': 'قائمة',
  },
  description: {
    'en': 'Start your day with our delightful breakfast options.',
    'ar': 'ابدأ يومك مع خيارات الإفطار اللذيذة لدينا.',
  },
  notes: {
    'en': 'Allergen info available upon request.',
    'ar': 'معلومات مسببات الحساسية متوفرة عند الطلب.',
  },
  imageUrl: 'https://picsum.photos/400/200', // Placeholder image

 // sections: sampleSections, // Use the mock sections
  isOnline: true,
  visibleOnTablet: true,
  visibleOnQr: true,
  visibleOnPickup: true,
  visibleOnDelivery: true,
  availability: MenuAvailability(
    type: AvailabilityType.always,
  ),
  settings: {
    'themeColor': '#FFD700',
    'icon': 'breakfast_icon',
  },
);
