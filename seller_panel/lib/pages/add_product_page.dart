import 'package:flutter/material.dart';
import 'package:shared_widgets/utils/error_handling.dart';
import 'package:http/http.dart' as http;
import 'package:shared_widgets/app_text_field.dart';
import 'dart:convert';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _productNameController.text,
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          Navigator.pop(context);
          showErrorSnackBar(context, 'Product added successfully', color: Colors.green);
        } else {
          showErrorSnackBar(
              context, responseData['message'] ?? 'Failed to add product. Please try again later.');
        }
      } else {
        showErrorSnackBar(context, 'Failed to add product. Please try again later.');
      }
    } catch (e, stackTrace) {
      if (!mounted) return;
      logError('An error occurred while adding the product', error: e, stackTrace: stackTrace);
      showErrorSnackBar(
        context,
        e is http.ClientException
            ? 'Failed to connect to the server. Please check your internet connection and try again.'
            : 'An unexpected error occurred. Please try again later.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _productNameController,
                  label: 'Product Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the description.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _priceController,
                  label: 'Price',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Add Product'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
