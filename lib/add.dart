import 'package:flutter/material.dart';
import 'item.dart';

class AddItemScreen extends StatelessWidget {
  final _websiteController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(labelText: 'Situs Web'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan situs web';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email';
                  } else if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newItem = Item(
                      id: DateTime.now().millisecondsSinceEpoch,
                      website: _websiteController.text,
                      email: _emailController.text,
                      iconPath: 'assets/icons/default_icon.png', 
                    );
                    Navigator.pop(context, newItem);
                  }
                },
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 