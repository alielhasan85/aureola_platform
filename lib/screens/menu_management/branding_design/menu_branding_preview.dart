// import 'package:flutter/material.dart';
// import 'package:aureola_platform/service/theme/theme.dart';

// class MenuBrandingPreview extends StatelessWidget {
//   const MenuBrandingPreview({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Text('Preview', style: AppTheme.paragraph),
//           SizedBox(height: 10),
//           Placeholder(fallbackHeight: 700, fallbackWidth: double.infinity),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:aureola_platform/service/theme/theme.dart';

class MenuBrandingPreview extends StatelessWidget {
  const MenuBrandingPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Typical mobile phone dimensions: 360 (width) x 640 (height)
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Preview', style: AppTheme.paragraph),
          const SizedBox(height: 10),
          // Fixed-size container to mimic a phone screen
          SizedBox(
            width: 360,
            height: 640,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Placeholder(),
            ),
          ),
        ],
      ),
    );
  }
}
