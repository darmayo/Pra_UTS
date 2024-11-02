import 'package:flutter/material.dart';
import 'item.dart';

class EditItemScreen extends StatelessWidget {
  final Item item;
  final TextEditingController _websiteController;
  final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  EditItemScreen({required this.item})
      : _websiteController = TextEditingController(text: item.website),
        _emailController = TextEditingController(text: item.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(labelText: 'Website'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a website';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedItem = Item(
                      id: item.id,
                      website: _websiteController.text,
                      email: _emailController.text,
                      iconPath: item.iconPath, 
                    );
                    Navigator.pop(context, updatedItem);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 