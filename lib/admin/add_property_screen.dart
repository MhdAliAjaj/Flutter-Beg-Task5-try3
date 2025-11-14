import 'package:flutter/material.dart';

import '../models/property_model.dart';
import '../services/property_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _SmallScreenNotice extends StatelessWidget {
  const _SmallScreenNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.desktop_windows,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'This admin page is best on larger screens',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please use a tablet or desktop (≥ 600px width).',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final PropertyService _propertyService = PropertyService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  // إضافة العقار
  Future<void> _addProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      // Upload default asset image
      final String imageUrl = await _propertyService.uploadImageFromAssets(
        "assets/images/default_property.jpg",
      );

      final property = PropertyModel(
        id: '',
        title: titleController.text.trim(),
        type: typeController.text.trim(),
        location: locationController.text.trim(),
        price: double.tryParse(priceController.text) ?? 0.0,
        description: descriptionController.text.trim(),
        imageUrl: imageUrl,
      );

      await _propertyService.addProperty(property);

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property added successfully')),
      );

      Navigator.pop(context); // العودة للوحة التحكم
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add Property')),
        body: const _SmallScreenNotice(),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Add Property')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: titleController,
                  hintText: 'Title',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter title' : null,
                ),
                CustomTextField(
                  controller: typeController,
                  hintText: 'Type (e.g. Apartment, Villa)',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter type' : null,
                ),
                CustomTextField(
                  controller: locationController,
                  hintText: 'Location',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter location' : null,
                ),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Price',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter price' : null,
                ),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                // Default image preview from assets
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/default_property.jpg',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: 'Add Property',
                        onPressed: _addProperty,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
