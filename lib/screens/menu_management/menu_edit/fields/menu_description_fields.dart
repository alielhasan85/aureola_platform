// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:aureola_platform/providers/providers.dart';
// import 'package:aureola_platform/service/theme/theme.dart';
// import 'package:aureola_platform/service/localization/localization.dart';
// import 'package:aureola_platform/widgest/multilang_dialog.dart';

// class MenuDescriptionFields extends ConsumerStatefulWidget {
//   final Map<String, String> descriptionMap;
//   final ValueChanged<Map<String, String>> onDescriptionChanged;
//   final String? Function(String?)? validator;

//   final double dialogWidth;
//   final Offset popoverOffset;
//   final BoxDecoration popoverDecoration;

//   const MenuDescriptionFields({
//     super.key,
//     required this.descriptionMap,
//     required this.onDescriptionChanged,
//     this.validator,
//     required this.dialogWidth,
//     this.popoverOffset = const Offset(0, 8.0),
//     this.popoverDecoration = const BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.all(Radius.circular(8)),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black26,
//           blurRadius: 4,
//           offset: Offset(0, 2),
//         ),
//       ],
//     ),
//   });

//   @override
//   ConsumerState<MenuDescriptionFields> createState() =>
//       _MenuDescriptionFieldsState();
// }

// class _MenuDescriptionFieldsState extends ConsumerState<MenuDescriptionFields> {
//   final LayerLink _layerLink = LayerLink();
//   OverlayEntry? _multilangOverlay;

//   final GlobalKey _fieldKey = GlobalKey();

//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     final currentLang = ref.read(languageProvider);
//     // Initialize the single text field with whatever is in the "current" language
//     _controller =
//         TextEditingController(text: widget.descriptionMap[currentLang] ?? '');
//   }

//   @override
//   void dispose() {
//     _removeOverlay();
//     _controller.dispose();
//     super.dispose();
//   }

//   void _removeOverlay() {
//     _multilangOverlay?.remove();
//     _multilangOverlay = null;
//   }

//   void _showMultilangDialog() {
//     // Remove any existing overlay
//     _removeOverlay();
//     final overlay = Overlay.of(context);
//     // if (overlay == null) return;

//     final RenderBox? renderBox =
//         _fieldKey.currentContext?.findRenderObject() as RenderBox?;
//     if (renderBox == null) return;

//     final Size fieldSize = renderBox.size;
//     final Offset fieldPosition = renderBox.localToGlobal(Offset.zero);

//     _multilangOverlay = OverlayEntry(
//       builder: (context) {
//         return Stack(
//           children: [
//             // Transparent barrier to dismiss popover on outside taps
//             Positioned.fill(
//               child: GestureDetector(
//                 onTap: _removeOverlay,
//                 behavior: HitTestBehavior.translucent,
//                 child: Container(color: Colors.transparent),
//               ),
//             ),
//             // The pop-up
//             Positioned(
//               left: fieldPosition.dx,
//               top:
//                   fieldPosition.dy + fieldSize.height + widget.popoverOffset.dy,
//               child: Material(
//                 elevation: 4,
//                 color: Colors.transparent,
//                 child: Container(
//                   width: fieldSize.width,
//                   decoration: widget.popoverDecoration,
//                   padding: const EdgeInsets.all(16),
//                   child: GestureDetector(
//                     onTap: () {}, // so taps inside don’t dismiss
//                     child: _buildMultilangFields(),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     overlay.insert(_multilangOverlay!);
//   }

//   Widget _buildMultilangFields() {
//     final venue = ref.read(draftVenueProvider);
//     final currentLang = ref.read(languageProvider);

//     // If no venue, fallback to a single language list
//     final availableLangs = venue?.languageOptions ?? [currentLang];

//     return MultilangFieldDialogContent(
//       initialValues: widget.descriptionMap,
//       availableLanguages: availableLangs,
//       onSave: (updatedMap) {
//         widget.onDescriptionChanged(updatedMap);
//         _removeOverlay();
//       },
//       onCancel: _removeOverlay,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentLang = ref.watch(languageProvider);
//     final venue = ref.watch(draftVenueProvider);
//     final availableLangs = venue?.languageOptions ?? [currentLang];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           AppLocalizations.of(context)!.translate("edit.menuDescription"),
//           style: AppThemeLocal.paragraph,
//         ),
//         const SizedBox(height: 6),
//         CompositedTransformTarget(
//           link: _layerLink,
//           child: Container(
//             key: _fieldKey,
//             child: TextFormField(
//               controller: _controller,
//               maxLines: null, // Allow the field to expand as needed
//               style: AppThemeLocal.paragraph,
//               cursorColor: AppThemeLocal.accent,
//               validator: widget.validator,
//               onChanged: (val) {
//                 final updatedMap = {...widget.descriptionMap};
//                 updatedMap[currentLang] = val;
//                 widget.onDescriptionChanged(updatedMap);
//               },
//               decoration: AppThemeLocal.textFieldinputDecoration(
//                 hint: AppLocalizations.of(context)!
//                     .translate("edit.MenuDescriptionHint"),
//                 suffixIcon: availableLangs.length > 1
//                     ? Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const SizedBox(
//                             height: 30,
//                             child: VerticalDivider(
//                               color: AppThemeLocal.accent,
//                               thickness: 0.5,
//                               width: 4,
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(
//                               Icons.translate,
//                               color: AppThemeLocal.accent,
//                             ),
//                             tooltip: AppLocalizations.of(context)!
//                     .translate("edit.editInOtherLanguages")
//                             ,
//                             onPressed: _showMultilangDialog,
//                           ),
//                         ],
//                       )
//                     : null,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
