import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/data/blocs/product_bloc.dart';
import 'package:product_management/data/events/product_event.dart';
import 'package:product_management/data/models/form_data.dart';
import 'package:product_management/data/repository/api_repository.dart';

class AddProductTab extends StatefulWidget {
  const AddProductTab({super.key});

  @override
  State<AddProductTab> createState() => _AddProductTabState();
}

class _AddProductTabState extends State<AddProductTab> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  late Future<FormData> _formDataFuture;

  @override
  void initState() {
    super.initState();
    _formDataFuture = ApiRepository().fetchFormData();
  }

  void _submit(FormData formData) {
    if (_formKey.currentState!.validate()) {
      final name = _controllers["productName"]!.text;
      final price = int.tryParse(_controllers["price"]!.text) ?? 0.0;
      final imageUrl = _controllers["imageUrl"]!.text;

      context.read<ProductBloc>().add(AddProduct(name: name, price: price.toInt(), imageUrl: imageUrl));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm sản phẩm")),
      body: FutureBuilder<FormData>(
        future: _formDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final formData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(formData.label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ...formData.formFields.map((field) {
                      _controllers[field.name] = TextEditingController();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _controllers[field.name],
                          decoration: InputDecoration(labelText: field.label),
                          keyboardType: field.type == "number" ? TextInputType.number : TextInputType.text,
                          validator: (value) {
                            if (field.required && (value == null || value.isEmpty)) {
                              return "Vui lòng nhập ${field.label}";
                            }
                            if (field.minValue != null && int.tryParse(value!)! < field.minValue!) {
                              return "${field.label} phải lớn hơn ${field.minValue}";
                            }
                            if (field.maxValue != null && int.tryParse(value!)! > field.maxValue!) {
                              return "${field.label} phải nhỏ hơn ${field.maxValue}";
                            }
                            if (field.maxLength != null && value!.length > field.maxLength!) {
                              return "${field.label} không được quá ${field.maxLength} ký tự";
                            }
                            return null;
                          },
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _submit(formData),
                      child: Text(formData.buttonText),
                    ),
                  ],
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
