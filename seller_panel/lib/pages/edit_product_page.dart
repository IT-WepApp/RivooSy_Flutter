import 'package:shared_widgets/utils/error_handling.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_widgets/app_text_field.dart';

class EditProductPage extends StatefulWidget {
  final String productId;
  const EditProductPage({super.key, required this.productId});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late String productId;
  String _productName = '';
  String _description = '';
  double _price = 0.0;
  String _avatar = '';
  bool _isLoading = false;

  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _avatarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productId = widget.productId;
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          'https://68027bdb0a99cb7408e9bb97.mockapi.io/api/v1/products/$productId'));

      if (!mounted) return;
      if (response.statusCode == 200) {
        final productData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _productName = productData['name'] ?? '';
            _description = productData['description'] ?? '';
            _price = double.tryParse(productData['price'].toString()) ?? 0.0;
            _avatar = productData['avatar'] ?? '';
            _productNameController.text = _productName;
            _descriptionController.text = _description;
            _priceController.text = _price.toString();
            _avatarController.text = _avatar;
          });
        }
      } else {
        if (mounted) {
          showErrorSnackBar(context, 'Failed to load product. Please try again later.');
        }
      }
    } catch (e, stackTrace) {
      if (!mounted) return;
      logError('An error occurred while loading product data',
          error: e, stackTrace: stackTrace);
      showErrorSnackBar(
        context,
        e is http.ClientException
            ? 'Failed to connect to the server. Please check your internet connection and try again.'
            : 'An unexpected error occurred. Please try again later.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.put(
        Uri.parse(
            'https://68027bdb0a99cb7408e9bb97.mockapi.io/api/v1/products/$productId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _productNameController.text,
          'description': _descriptionController.text,
          'price': double.parse(_priceController.text),
          'avatar': _avatarController.text,
        }),
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        if (mounted) Navigator.pop(context);
        if (mounted) {
          showErrorSnackBar(context, 'Product updated successfully', color: Colors.green);
        }
      } else {
        if (mounted) {
          showErrorSnackBar(context, 'Failed to update product. Please try again later.');
        }
      }
    } catch (e, stackTrace) {
      if (!mounted) return;
      logError('An error occurred while updating the product',
          error: e, stackTrace: stackTrace);
      showErrorSnackBar(
        context,
        e is http.ClientException
            ? 'Failed to connect to the server. Please check your internet connection and try again.'
            : 'An unexpected error occurred. Please try again later.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
        title: const Text('Edit Product'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      AppTextField(
                        controller: _productNameController,
                        label: 'Product Name',
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter the product name.'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        maxLines: 3,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter the description.'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _priceController,
                        label: 'Price',
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter the price.'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _avatarController,
                        label: 'Avatar URL',
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter the avatar url.'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
