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

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final PropertyService _propertyService = PropertyService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  bool isLoading = false;

  Future<void> _addProperty() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final property = PropertyModel(
        id: '',
        title: titleController.text.trim(),
        type: typeController.text.trim(),
        location: locationController.text.trim(),
        price: double.tryParse(priceController.text) ?? 0.0,
        description: descriptionController.text.trim(),
        imageUrl: imageUrlController.text.trim(),
      );

      await _propertyService.addProperty(property);

      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property added successfully')),
      );

      Navigator.pop(context); // ارجع للـ Dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
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
                CustomTextField(
                  controller: imageUrlController,
                  hintText: 'Image URL',
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
