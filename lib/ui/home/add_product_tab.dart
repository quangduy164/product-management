import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:product_management/data/blocs/product_bloc.dart';
import 'package:product_management/data/events/product_event.dart';
import 'package:product_management/data/models/form_data.dart' as model;
import 'package:product_management/data/repository/api_repository.dart';
import 'package:product_management/data/states/product_state.dart';
import 'package:product_management/data/validators/validators.dart';

class AddProductTab extends StatefulWidget {
  const AddProductTab({super.key});

  @override
  State<AddProductTab> createState() => _AddProductTabState();
}

class _AddProductTabState extends State<AddProductTab> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  late Future<model.FormData> _formDataFuture;

  File? _selectedImage;
  String? _imageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _formDataFuture = ApiRepository().fetchFormData();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      await _uploadImageToCloudinary(_selectedImage!);
    }
  }

  Future<void> _uploadImageToCloudinary(File imageFile) async {
    setState(() {
      _isUploading = true;
    });

    try {
      String cloudinaryUrl = "https://api.cloudinary.com/v1_1/dqizoym6j/image/upload";
      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(imageFile.path),
        "upload_preset": "product-management"
      });

      dio.Response response = await dio.Dio().post(cloudinaryUrl, data: formData);

      if (response.statusCode == 200) {
        setState(() {
          _imageUrl = response.data["secure_url"];
        });
      } else {
        throw Exception("Lỗi khi tải ảnh lên Cloudinary");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi tải ảnh: $e")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _submit(model.FormData formData) {
    if (_formKey.currentState!.validate()) {
      final name = _controllers["productName"]!.text;
      final price = int.tryParse(_controllers["price"]!.text) ?? 0;

      if (_imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng chọn ảnh")),
        );
        return;
      }

      context.read<ProductBloc>().add(AddProduct(
        name: name,
        price: price,
        imageUrl: _imageUrl!,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Center(
            child: Text("Thêm sản phẩm",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),))
        ),
        body: _getBody()
    );
  }

  Widget _getBody(){
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi thêm sản phẩm: ${state.message}')),
          );
        } else if (state is ProductLoaded && state.action == ProductAction.added)  {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thêm sản phẩm thành công')),
          );
        }
      },
      child: FutureBuilder<model.FormData>(
        future: _formDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final formData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Hiển thị ảnh đã chọn
                      _selectedImage != null
                          ? Image.file(_selectedImage!, height: 150, width: 150, fit: BoxFit.cover)
                          : Container(),

                      const SizedBox(height: 10),

                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image, color: Colors.black,),
                        label: const Text('Tải ảnh lên', style: TextStyle(color: Colors.black),),
                      ),

                      if (_isUploading)
                        const CircularProgressIndicator(),

                      const SizedBox(height: 20),
                      ...formData.formFields.where((field) => field.name != "imageUrl").map((field) {
                        _controllers[field.name] = TextEditingController();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextFormField(
                            controller: _controllers[field.name],
                            decoration: InputDecoration(
                              labelText: field.label,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 0.5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan, width: 1.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: field.type == "number" ? TextInputType.number : TextInputType.text,
                            validator: (value) => Validators.validateField(
                              value: value,
                              label: field.label,
                              required: field.required,
                              isNumber: field.type == "number",
                              minValue: field.minValue,
                              maxValue: field.maxValue,
                              maxLength: field.maxLength,
                            ),
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _submit(formData),
                        child: Text(formData.buttonText,
                            style: const TextStyle(fontSize: 16, color: Colors.white)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text("Không có dữ liệu"));
          }
        },
      ),
    );
  }
}
