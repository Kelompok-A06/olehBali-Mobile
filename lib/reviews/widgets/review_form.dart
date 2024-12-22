import 'package:flutter/material.dart';

class ReviewForm extends StatefulWidget {
  final Function(int rating, String comment) onSubmit;
  final int? initialRating; // Optional: Existing rating
  final String? initialComment; // Optional: Existing comment

  const ReviewForm({
    super.key,
    required this.onSubmit,
    this.initialRating, // Pass the initial rating
    this.initialComment, // Pass the initial comment
  });

  @override
  State<StatefulWidget> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  int _selectedRating = 0;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the form fields with existing review values
    if (widget.initialRating != null) {
      _selectedRating = widget.initialRating!;
    }
    if (widget.initialComment != null) {
      _commentController.text = widget.initialComment!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Submit a Review'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              value: _selectedRating,
              items: List.generate(
                6,
                    (index) => DropdownMenuItem(
                  value: index,
                  child: Text(index.toString()),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedRating = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Rating'),
              validator: (value) {
                if (value == null) {
                  return 'Please select a rating';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: 'Comments'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your comments';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(_selectedRating, _commentController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
