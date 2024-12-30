// lib/screens/menu_management/menu_edit/edit_menu_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aureola_platform/models/menu/menu_model.dart';
import 'package:aureola_platform/models/menu/menu_availability.dart';
import 'package:aureola_platform/screens/menu_management/menu_edit/fields/menu_name_fields.dart';
import 'package:aureola_platform/screens/menu_management/menu_edit/fields/menu_description_fields.dart';
import 'package:aureola_platform/screens/menu_management/menu_edit/fields/menu_notes_fields.dart';
import 'package:aureola_platform/screens/menu_management/menu_edit/fields/menu_image_fields.dart';
import 'package:aureola_platform/screens/menu_management/menu_edit/fields/menu_availability_fields.dart';

class EditMenuDialog extends ConsumerStatefulWidget {
  final MenuModel menu;
  final Function(MenuModel) onSave;

  const EditMenuDialog({
    Key? key,
    required this.menu,
    required this.onSave,
  }) : super(key: key);

  @override
  ConsumerState<EditMenuDialog> createState() => _EditMenuDialogState();
}

class _EditMenuDialogState extends ConsumerState<EditMenuDialog> {
  final _formKey = GlobalKey<FormState>();

  // We'll store a local copy of menuName as a Map
  late Map<String, String> _menuName;

  // Others remain the same
  late TextEditingController _descriptionEnController;
  late TextEditingController _descriptionArController;
  late TextEditingController _notesEnController;
  late TextEditingController _notesArController;

  // Image fields
  late TextEditingController _imageUrlController;
  late TextEditingController _additionalImage1Controller;
  late TextEditingController _additionalImage2Controller;

  // Availability
  AvailabilityType _availabilityType = AvailabilityType.always;
  List<String> _daysOfWeek = [];
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _startDate;
  DateTime? _endDate;

  // Visibility
  bool _visibleOnTablet = false;
  bool _visibleOnQr = false;
  bool _visibleOnPickup = false;
  bool _visibleOnDelivery = false;

  @override
  void initState() {
    super.initState();

    // Initialize from widget.menu
    // 1) menuName is now a Map we can store
    _menuName = Map<String, String>.from(widget.menu.menuName);

    // 2) Description, notes remain separate controllers
    _descriptionEnController =
        TextEditingController(text: widget.menu.description['en'] ?? '');
    _descriptionArController =
        TextEditingController(text: widget.menu.description['ar'] ?? '');
    _notesEnController =
        TextEditingController(text: widget.menu.notes['en'] ?? '');
    _notesArController =
        TextEditingController(text: widget.menu.notes['ar'] ?? '');

    _imageUrlController =
        TextEditingController(text: widget.menu.imageUrl ?? '');
    _additionalImage1Controller = TextEditingController();
    _additionalImage2Controller = TextEditingController();

    // Availability
    if (widget.menu.availability != null) {
      final av = widget.menu.availability!;
      _availabilityType = av.type;
      _daysOfWeek = av.daysOfWeek;
      _startTime = av.startTime != null ? _parseTime(av.startTime!) : null;
      _endTime = av.endTime != null ? _parseTime(av.endTime!) : null;
      _startDate = av.startDate;
      _endDate = av.endDate;
    }

    // Visibility
    _visibleOnTablet = widget.menu.visibleOnTablet;
    _visibleOnQr = widget.menu.visibleOnQr;
    _visibleOnPickup = widget.menu.visibleOnPickup;
    _visibleOnDelivery = widget.menu.visibleOnDelivery;
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  void dispose() {
    // Dispose all controllers
    _descriptionEnController.dispose();
    _descriptionArController.dispose();
    _notesEnController.dispose();
    _notesArController.dispose();
    _imageUrlController.dispose();
    _additionalImage1Controller.dispose();
    _additionalImage2Controller.dispose();
    super.dispose();
  }

  void _onAvailabilityChanged(
    AvailabilityType type,
    List<String> days,
    TimeOfDay? startT,
    TimeOfDay? endT,
    DateTime? startD,
    DateTime? endD,
  ) {
    setState(() {
      _availabilityType = type;
      _daysOfWeek = days;
      _startTime = startT;
      _endTime = endT;
      _startDate = startD;
      _endDate = endD;
    });
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    // Build new MenuAvailability
    final newAvailability = MenuAvailability(
      type: _availabilityType,
      daysOfWeek:
          _availabilityType == AvailabilityType.periodic ? _daysOfWeek : [],
      startTime: _startTime != null
          ? '${_startTime!.hour}:${_startTime!.minute.toString().padLeft(2, '0')}'
          : null,
      endTime: _endTime != null
          ? '${_endTime!.hour}:${_endTime!.minute.toString().padLeft(2, '0')}'
          : null,
      startDate:
          _availabilityType == AvailabilityType.specific ? _startDate : null,
      endDate: _availabilityType == AvailabilityType.specific ? _endDate : null,
    );

    // Construct the updated MenuModel
    final updatedMenu = widget.menu.copyWith(
      menuName: _menuName, // Our updated map
      description: {
        'en': _descriptionEnController.text,
        'ar': _descriptionArController.text,
      },
      notes: {
        'en': _notesEnController.text,
        'ar': _notesArController.text,
      },
      imageUrl:
          _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
      visibleOnTablet: _visibleOnTablet,
      visibleOnQr: _visibleOnQr,
      visibleOnPickup: _visibleOnPickup,
      visibleOnDelivery: _visibleOnDelivery,
      availability: newAvailability,
      updatedAt: DateTime.now(),
    );

    widget.onSave(updatedMenu);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Menu'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1) Menu Name
              MenuNameFields(
                menuName: _menuName,
                onMenuNameChanged: (updatedMap) {
                  setState(() {
                    _menuName = updatedMap;
                  });
                },
                // Simple validator for *current* language
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter menu name in the current language';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2) Description Fields (still using your old approach)
              MenuDescriptionFields(
                descriptionEnController: _descriptionEnController,
                descriptionArController: _descriptionArController,
                validatorEn: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter description in English';
                  }
                  return null;
                },
                validatorAr: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter description in Arabic';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3) Notes
              MenuNotesFields(
                notesEnController: _notesEnController,
                notesArController: _notesArController,
              ),
              const SizedBox(height: 16),

              // 4) Images
              MenuImageFields(
                imageUrlController: _imageUrlController,
                additionalImage1Controller: _additionalImage1Controller,
                additionalImage2Controller: _additionalImage2Controller,
              ),
              const SizedBox(height: 16),

              // 5) Availability
              MenuAvailabilityFields(
                initialType: _availabilityType,
                initialDaysOfWeek: _daysOfWeek,
                initialStartTime: _startTime,
                initialEndTime: _endTime,
                initialStartDate: _startDate,
                initialEndDate: _endDate,
                onChanged: _onAvailabilityChanged,
              ),
              const SizedBox(height: 16),

              // 6) Toggling Switches
              SwitchListTile(
                title: const Text('Visible on Tablet'),
                value: _visibleOnTablet,
                onChanged: (val) => setState(() {
                  _visibleOnTablet = val;
                }),
              ),
              SwitchListTile(
                title: const Text('Visible on QR'),
                value: _visibleOnQr,
                onChanged: (val) => setState(() {
                  _visibleOnQr = val;
                }),
              ),
              SwitchListTile(
                title: const Text('Visible on Pickup'),
                value: _visibleOnPickup,
                onChanged: (val) => setState(() {
                  _visibleOnPickup = val;
                }),
              ),
              SwitchListTile(
                title: const Text('Visible on Delivery'),
                value: _visibleOnDelivery,
                onChanged: (val) => setState(() {
                  _visibleOnDelivery = val;
                }),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _onSave,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
