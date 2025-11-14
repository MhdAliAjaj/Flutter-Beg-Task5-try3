import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../services/property_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class EditPropertyScreen extends StatefulWidget {
  final PropertyModel property;

  const EditPropertyScreen({super.key, required this.property});

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
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

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final PropertyService _propertyService = PropertyService();

  late TextEditingController titleController;
  late TextEditingController typeController;
  late TextEditingController locationController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController imageUrlController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    titleController = TextEditingController(text: p.title);
    typeController = TextEditingController(text: p.type);
    locationController = TextEditingController(text: p.location);
    priceController = TextEditingController(text: p.price.toString());
    descriptionController = TextEditingController(text: p.description);
    imageUrlController = TextEditingController(text: p.imageUrl);
  }

  Future<void> _updateProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final updated = PropertyModel(
        id: widget.property.id,
        title: titleController.text,
        type: typeController.text,
        location: locationController.text,
        price: double.tryParse(priceController.text) ?? 0,
        description: descriptionController.text,
        imageUrl: imageUrlController.text,
      );

      await _propertyService.updateProperty(updated);

      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Property updated')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Property')),
        body: const _SmallScreenNotice(),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Property')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(controller: titleController, hintText: 'Title'),
                CustomTextField(controller: typeController, hintText: 'Type'),
                CustomTextField(
                  controller: locationController,
                  hintText: 'Location',
                ),
                CustomTextField(controller: priceController, hintText: 'Price'),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                ),
                CustomTextField(
                  controller: imageUrlController,
                  hintText: 'Image URL',
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: 'Update Property',
                        onPressed: _updateProperty,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
