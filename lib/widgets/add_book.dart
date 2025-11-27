import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddBookSheet extends StatefulWidget {
  final void Function(
    String title,
    String author,
    String? coverUrl,
    Uint8List? coverBytes,
    String description,
  ) onSubmit;

  const AddBookSheet({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddBookSheet> createState() => _AddBookSheetState();
}

class _AddBookSheetState extends State<AddBookSheet> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _coverUrlCtrl = TextEditingController();

  Uint8List? _pickedImageBytes;
  String? _pickedImageName;

  bool _submitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _descriptionCtrl.dispose();
    _coverUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _pickedImageBytes = file.bytes;
        _pickedImageName = file.name;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    widget.onSubmit(
      _titleCtrl.text.trim(),
      _authorCtrl.text.trim(),
      _coverUrlCtrl.text.trim().isEmpty ? null : _coverUrlCtrl.text.trim(),
      _pickedImageBytes,
      _descriptionCtrl.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Book added successfully'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add Book', style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Please enter a title'
                          : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _authorCtrl,
                  decoration: const InputDecoration(labelText: 'Author'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Please enter an author'
                          : null,
                ),
                const SizedBox(height: 18),

                Text('Cover Image', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),

                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Upload image'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (_pickedImageName != null)
                      Expanded(
                        child: Text(
                          _pickedImageName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _coverUrlCtrl,
                  decoration: const InputDecoration(
                    labelText: '…or paste image URL (optional)',
                  ),
                ),
                const SizedBox(height: 18),

                TextFormField(
                  controller: _descriptionCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),

                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: Text(_submitting ? 'Adding…' : 'Add'),
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
