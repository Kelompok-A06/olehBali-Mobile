import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductForm extends StatefulWidget {
  final Function? onProductAdded;

  const AddProductForm({super.key, this.onProductAdded});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  File? _imageFile;
  Uint8List? _webImage;

  final List<String> categories = [
    'Makanan/Minuman',
    'Kerajinan Tangan',
    'Pakaian',
    'Lain-lain'
  ];

  Widget _buildImagePreview() {
    if (_imageFile == null && _webImage == null) {
      return const SizedBox.shrink();
    }

    if (kIsWeb) {
      return Image.memory(
        _webImage!,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        _imageFile!,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _webImage = f;
          _imageFile = File('');
        });
      }
    } else {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product', style: GoogleFonts.lato()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.lato(),
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  labelStyle: GoogleFonts.lato(),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan nama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                style: GoogleFonts.lato(),
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: GoogleFonts.lato(),
                  border: const OutlineInputBorder(),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category, style: GoogleFonts.lato()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon pilih kategori';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                style: GoogleFonts.lato(),
                decoration: InputDecoration(
                  labelText: 'Harga',
                  labelStyle: GoogleFonts.lato(),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan harga';
                  }
                  try {
                    int.parse(value.replaceAll(RegExp(r'[^0-9]'), ''));
                    return null;
                  } catch (e) {
                    return 'Masukkan angka yang valid';
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                style: GoogleFonts.lato(),
                decoration: InputDecoration(
                  labelText: 'Alamat Toko',
                  labelStyle: GoogleFonts.lato(),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan alamat toko';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                style: GoogleFonts.lato(),
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  labelStyle: GoogleFonts.lato(),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan deskripsi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: Text('Upload Foto', style: GoogleFonts.lato()),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 8),
              if (_imageFile != null || _webImage != null) ...[
                const SizedBox(height: 8),
                _buildImagePreview(),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _selectedCategory != null) {
                    try {
                      final priceString = _priceController.text
                          .replaceAll(RegExp(r'[^0-9]'), '');
                      final price = int.parse(priceString);

                      String? imageBase64;
                      if (kIsWeb && _webImage != null) {
                        imageBase64 = base64Encode(_webImage!);
                      } else if (_imageFile != null) {
                        imageBase64 =
                            base64Encode(await _imageFile!.readAsBytes());
                      }

                      final response = await request.postJson(
                        "https://muhammad-hibrizi-olehbali.pbp.cs.ui.ac.id/api/add_product/",
                        jsonEncode({
                          'nama': _nameController.text,
                          'kategori': _selectedCategory,
                          'harga': price,
                          'toko': request.jsonData['username'],
                          'alamat': _addressController.text,
                          'deskripsi': _descriptionController.text,
                          'gambar': '',
                          'gambar_file': imageBase64,
                        }),
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Sukses menambahkan produk!")),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(response['message'] ??
                                  'Gagal menambahkan produk..'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      print('Error: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Tambah', style: GoogleFonts.lato()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
