//

import 'package:aureola_platform/screens/main_page/layouts/main_mobile.dart';
import 'package:aureola_platform/screens/main_page/layouts/main_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';

import 'layouts/main_desctop.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setOrientation();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout
          return const MobileLayout();
        } else if (constraints.maxWidth < 1200) {
          // Tablet layout
          return const TabletLayout();
        } else {
          // Desktop layout
          return const DesktopLayout();
        }
      },
    );
  }

  void _setOrientation() {
    // Use portrait for mobile, landscape for tablet and desktop
    if (MediaQuery.of(context).size.width < 600) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void dispose() {
    // Reset the orientation when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
}
