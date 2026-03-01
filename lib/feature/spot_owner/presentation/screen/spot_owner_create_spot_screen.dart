import 'package:app_pigeon/app_pigeon.dart';
import 'package:dio/dio.dart' hide FormData, MultipartFile;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';
import 'package:xocobaby13/core/common/widget/button/loading_buttons.dart';

class SpotOwnerCreateSpotScreen extends StatefulWidget {
  const SpotOwnerCreateSpotScreen({super.key});

  @override
  State<SpotOwnerCreateSpotScreen> createState() =>
      _SpotOwnerCreateSpotScreenState();
}

class _SpotOwnerCreateSpotScreenState extends State<SpotOwnerCreateSpotScreen> {
  final TextEditingController _pondNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _latController = TextEditingController(
    text: '23.8103',
  );
  final TextEditingController _lngController = TextEditingController(
    text: '90.4125',
  );
  final TextEditingController _priceController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  String _maxGuests = '';
  String _availableSlots = '';
  String _waterType = 'Pond';
  final Set<String> _facilities = <String>{'Seating Area', 'Fishing Platform'};
  final Set<String> _restrictions = <String>{
    'waste dumping',
    'Commercial filming',
  };
  List<XFile> _selectedImages = <XFile>[];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _pondNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '21 Jan';
    return DateFormat('dd MMM').format(date);
  }

  String _formatDisplayTime(TimeOfDay? time) {
    if (time == null) return '';
    final DateTime date = DateTime(2026, 1, 1, time.hour, time.minute);
    return DateFormat('h:mma').format(date);
  }

  String _formatTimeRange() {
    if (_fromTime == null || _toTime == null) return '4:00PM-6:00PM';
    return '${_formatDisplayTime(_fromTime)}-${_formatDisplayTime(_toTime)}';
  }

  String _formatApiDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatApiTime(TimeOfDay time) {
    final DateTime date = DateTime(2026, 1, 1, time.hour, time.minute);
    return DateFormat('hh:mm a').format(date);
  }

  DateTime _effectiveDate() {
    return _selectedDate ?? DateTime.now();
  }

  TimeOfDay _effectiveFromTime() {
    return _fromTime ?? const TimeOfDay(hour: 16, minute: 0);
  }

  TimeOfDay _effectiveToTime() {
    return _toTime ?? const TimeOfDay(hour: 18, minute: 0);
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime initial = _selectedDate ?? DateTime(2026, 1, 21);
    final DateTime firstDate = DateTime(now.year - 1, 1, 1);
    final DateTime lastDate = DateTime(now.year + 5, 12, 31);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTimeRange() async {
    final TimeOfDay initialFrom =
        _fromTime ?? const TimeOfDay(hour: 16, minute: 0);
    final TimeOfDay? from = await showTimePicker(
      context: context,
      initialTime: initialFrom,
    );
    if (from == null) return;
    final TimeOfDay initialTo = _toTime ?? const TimeOfDay(hour: 18, minute: 0);
    final TimeOfDay? to = await showTimePicker(
      context: context,
      initialTime: initialTo,
    );
    if (to == null) return;
    setState(() {
      _fromTime = from;
      _toTime = to;
    });
  }

  Future<void> _pickImages() async {
    final List<XFile> picked = await ImagePicker().pickMultiImage();
    if (picked.isEmpty) return;
    setState(() => _selectedImages = picked);
  }

  Future<void> _submitSpot() async {
    if (_isSubmitting) return;
    final String title = _pondNameController.text.trim();
    final String description = _descriptionController.text.trim();
    final String priceInput = _priceController.text.trim();
    final String address = _locationController.text.trim();
    final String city = _cityController.text.trim();
    final String country = _countryController.text.trim();
    final String latInput = _latController.text.trim();
    final String lngInput = _lngController.text.trim();

    String cleanNumber(String value) =>
        value.replaceAll(RegExp(r'[^0-9.\-]'), '');
    double? parseNumber(String value) => double.tryParse(cleanNumber(value));

    if (title.isEmpty) {
      _showMessage('Title is required');
      return;
    }
    if (description.isEmpty) {
      _showMessage('Description is required');
      return;
    }
    if (priceInput.isEmpty) {
      _showMessage('Price is required');
      return;
    }
    final double? priceValue = parseNumber(priceInput);
    if (priceValue == null) {
      _showMessage('Price must be a number');
      return;
    }
    if (latInput.isEmpty || lngInput.isEmpty) {
      _showMessage('Latitude and longitude are required');
      return;
    }
    final double? latValue = parseNumber(latInput);
    final double? lngValue = parseNumber(lngInput);
    if (latValue == null || lngValue == null) {
      _showMessage('Latitude/Longitude must be valid numbers');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final DateTime date = _effectiveDate();
      final TimeOfDay from = _effectiveFromTime();
      final TimeOfDay to = _effectiveToTime();

      final FormData formData = FormData();
      formData.fields.addAll(<MapEntry<String, String>>[
        MapEntry<String, String>('title', title),
        MapEntry<String, String>('description', description),
        MapEntry<String, String>('price', priceValue.toString()),
        MapEntry<String, String>('address', address),
        MapEntry<String, String>('city', city),
        MapEntry<String, String>('country', country),
        MapEntry<String, String>('lat', latValue.toString()),
        MapEntry<String, String>('lng', lngValue.toString()),
        MapEntry<String, String>('availability[0][date]', _formatApiDate(date)),
        MapEntry<String, String>(
          'availability[0][slots][0][start]',
          _formatApiTime(from),
        ),
        MapEntry<String, String>(
          'availability[0][slots][0][end]',
          _formatApiTime(to),
        ),
      ]);

      int index = 0;
      for (final String facility in _facilities) {
        formData.fields.add(
          MapEntry<String, String>('facilities[$index]', facility),
        );
        index += 1;
      }

      index = 0;
      for (final String restriction in _restrictions) {
        formData.fields.add(
          MapEntry<String, String>('restrictions[$index]', restriction),
        );
        index += 1;
      }

      for (final XFile file in _selectedImages) {
        formData.files.add(
          MapEntry<String, MultipartFile>(
            'images',
            await MultipartFile.fromFile(file.path, filename: file.name),
          ),
        );
      }

      final response = await Get.find<AuthorizedPigeon>().post(
        ApiEndpoints.createSpot,
        data: formData,
      );
      final Map<String, dynamic> responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data as Map)
          : <String, dynamic>{};
      final String message =
          responseBody['message']?.toString() ?? 'Spot created';
      if (!mounted) return;
      _showMessage(message);
      Navigator.of(context).pop();
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final String message =
          responseData is Map && responseData['message'] != null
          ? responseData['message'].toString()
          : responseData is String && responseData.isNotEmpty
          ? responseData
          : 'Failed to create spot';
      if (!mounted) return;
      _showMessage(message);
    } catch (e) {
      if (!mounted) return;
      _showMessage('Failed to create spot');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        color: const Color(0xFFF2F9FF),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: AppElevatedButton(
            onPressed: _isSubmitting ? null : _submitSpot,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1787CF),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Publish Now',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFD7E7F7), Color(0xFFE2E8F1)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        CupertinoIcons.back,
                        size: 20,
                        color: Color(0xFF1D2A36),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const _FieldLabel('Pond Name'),
                const SizedBox(height: 8),
                _InputField(
                  controller: _pondNameController,
                  hintText: 'Title of the spot',
                ),
                const SizedBox(height: 14),
                const _FieldLabel('Description'),
                const SizedBox(height: 8),
                _InputField(
                  controller: _descriptionController,
                  hintText:
                      'Describe the water, species of fish, and\naccess points ...',
                  maxLines: 4,
                  height: 96,
                ),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const _FieldLabel('Date'),
                          const SizedBox(height: 8),
                          _SelectField(
                            value: _formatDate(_selectedDate),
                            icon: CupertinoIcons.calendar,
                            isPlaceholder: false,
                            onTap: _pickDate,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const _FieldLabel('Time'),
                          const SizedBox(height: 8),
                          _SelectField(
                            value: _formatTimeRange(),
                            icon: CupertinoIcons.clock,
                            isPlaceholder: false,
                            onTap: _pickTimeRange,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const _FieldLabel('Max Guests'),
                const SizedBox(height: 8),
                _DropdownField(
                  value: _maxGuests.isEmpty ? null : _maxGuests,
                  hintText: 'Select',
                  items: const <String>['1 Person', '2 Person', '3 Person'],
                  onChanged: (String? value) {
                    setState(() => _maxGuests = value ?? '');
                  },
                ),
                const SizedBox(height: 14),
                const _FieldLabel('Available Slots'),
                const SizedBox(height: 8),
                _DropdownField(
                  value: _availableSlots.isEmpty ? null : _availableSlots,
                  hintText: 'Select',
                  items: const <String>['40', '60', '80', '100'],
                  onChanged: (String? value) {
                    setState(() => _availableSlots = value ?? '');
                  },
                ),
                const SizedBox(height: 14),
                const _FieldLabel('Location'),
                const SizedBox(height: 8),
                _InputField(
                  controller: _locationController,
                  hintText: 'Search by location',
                  suffixIcon: CupertinoIcons.location,
                ),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const _FieldLabel('City'),
                          const SizedBox(height: 8),
                          _InputField(
                            controller: _cityController,
                            hintText: 'City',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const _FieldLabel('Country'),
                          const SizedBox(height: 8),
                          _InputField(
                            controller: _countryController,
                            hintText: 'Country',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const _FieldLabel('Latitude'),
                          const SizedBox(height: 8),
                          _InputField(
                            controller: _latController,
                            hintText: 'Lat',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const _FieldLabel('Longitude'),
                          const SizedBox(height: 8),
                          _InputField(
                            controller: _lngController,
                            hintText: 'Lng',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const _FieldLabel('Price per day'),
                const SizedBox(height: 8),
                _InputField(
                  controller: _priceController,
                  hintText: 'Enter your budget (e.g. \$50 Min.)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                const _FieldLabel('Type of Water'),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _WaterTypeOption(
                        assetPath: 'assets/images/lake.png',
                        label: 'Lake',
                        selected: _waterType == 'Lake',
                        onTap: () => setState(() => _waterType = 'Lake'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _WaterTypeOption(
                        assetPath: 'assets/images/river.png',
                        label: 'River',
                        selected: _waterType == 'River',
                        onTap: () => setState(() => _waterType = 'River'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _WaterTypeOption(
                        assetPath: 'assets/images/pond.png',
                        label: 'Pond',
                        selected: _waterType == 'Pond',
                        onTap: () => setState(() => _waterType = 'Pond'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionLabel(
                  label: 'Facilities',
                  onAddTap: () => _showMessage('Add facility'),
                ),
                const SizedBox(height: 10),
                _SelectableGrid(
                  items: const <String>[
                    'Seating Area',
                    'Shade',
                    'Night Lighting',
                    'Washroom',
                    'Life Jacket',
                    'Fishing Platform',
                    'First Aid Box',
                    'Security Guard',
                  ],
                  selectedItems: _facilities,
                  onToggle: (String value) {
                    setState(() {
                      if (_facilities.contains(value)) {
                        _facilities.remove(value);
                      } else {
                        _facilities.add(value);
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                _SectionLabel(
                  label: 'Restriction',
                  onAddTap: () => _showMessage('Add restriction'),
                ),
                const SizedBox(height: 10),
                _SelectableGrid(
                  items: const <String>[
                    'waste dumping',
                    'Loud music',
                    'No chemical',
                    'Fireworks',
                    'Outside food',
                    'Commercial filming',
                  ],
                  selectedItems: _restrictions,
                  onToggle: (String value) {
                    setState(() {
                      if (_restrictions.contains(value)) {
                        _restrictions.remove(value);
                      } else {
                        _restrictions.add(value);
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                const _FieldLabel('Add New Files'),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB5D7F7)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          CupertinoIcons.cloud_upload,
                          color: Color(0xFF1E7CC8),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _selectedImages.isEmpty
                              ? 'Upload'
                              : 'Upload (${_selectedImages.length} selected)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D2A36),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1D2A36),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final double height;
  final TextInputType? keyboardType;
  final IconData? suffixIcon;

  const _InputField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.height = 46,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB5D7F7)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFB8C1CC),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          suffixIcon: suffixIcon == null
              ? null
              : Icon(suffixIcon, color: const Color(0xFF1D2A36), size: 18),
        ),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1D2A36),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPlaceholder;

  const _SelectField({
    required this.value,
    required this.icon,
    required this.onTap,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFB5D7F7)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: isPlaceholder
                      ? const Color(0xFFB8C1CC)
                      : const Color(0xFF1D2A36),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(icon, size: 18, color: const Color(0xFF1D2A36)),
          ],
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB5D7F7)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hintText,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFB8C1CC),
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: const Icon(
            CupertinoIcons.chevron_down,
            size: 18,
            color: Color(0xFF1D2A36),
          ),
          isExpanded: true,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF1D2A36),
            fontWeight: FontWeight.w500,
          ),
          items: items
              .map(
                (String item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _WaterTypeOption extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _WaterTypeOption({
    required this.assetPath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = selected
        ? const Color(0xFF1787CF)
        : const Color(0xFFB5D7F7);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 88,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              assetPath,
              width: 38,
              height: 38,
              color: selected
                  ? const Color(0xFF1787CF)
                  : const Color(0xFF1E7CC8),
              errorBuilder: (_, __, ___) => Icon(
                CupertinoIcons.drop,
                color: selected
                    ? const Color(0xFF1787CF)
                    : const Color(0xFF1E7CC8),
                size: 26,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2A36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final VoidCallback onAddTap;

  const _SectionLabel({required this.label, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D2A36),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onAddTap,
          child: const Text(
            '+Add',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E7CC8),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectableGrid extends StatelessWidget {
  final List<String> items;
  final Set<String> selectedItems;
  final ValueChanged<String> onToggle;

  const _SelectableGrid({
    required this.items,
    required this.selectedItems,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items
          .map(
            (String item) => _SelectableChip(
              label: item,
              selected: selectedItems.contains(item),
              onTap: () => onToggle(item),
            ),
          )
          .toList(),
    );
  }
}

class _SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? const Color(0xFF1787CF) : const Color(0xFFB5D7F7),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF1787CF) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF1787CF)
                      : const Color(0xFF1D2A36),
                  width: 1.4,
                ),
              ),
              child: selected
                  ? const Icon(
                      CupertinoIcons.check_mark,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D2A36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
