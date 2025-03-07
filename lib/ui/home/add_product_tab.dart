import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/data/blocs/product_bloc.dart';
import 'package:product_management/data/events/product_event.dart';
import 'package:product_management/data/models/form_data.dart';
import 'package:product_management/data/repository/api_repository.dart';
import 'package:product_management/data/states/product_state.dart';
import 'package:product_management/data/validators/validators.dart';

class AddProductTab extends StatefulWidget {
  const AddProductTab({super.key});

  @override
  State<AddProductTab> createState() => _AddProductTabState();
}

class _AddProductTabState extends State<AddProductTab>{
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
      final price = int.tryParse(_controllers["price"]!.text) ?? 0;
      final imageUrl = _controllers["imageUrl"]?.text ?? '';

      context.read<ProductBloc>().add(AddProduct(name: name, price: price, imageUrl: imageUrl));
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thêm sản phẩm thành công')),
          );
        }
      },
      child: FutureBuilder<FormData>(
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
                      ...formData.formFields.map((field) {
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
