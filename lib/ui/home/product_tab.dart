import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/data/blocs/product_bloc.dart';
import 'package:product_management/data/events/product_event.dart';
import 'package:product_management/data/states/product_state.dart';
import 'package:product_management/ui/home/product_item_section.dart';

class ProductTab extends StatefulWidget {
  const ProductTab({super.key});

  @override
  State<ProductTab> createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<ProductBloc>().add(FetchProduct());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _searchBar(),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductLoaded) {
                    // Lọc sản phẩm theo từ khóa tìm kiếm
                    final filteredProducts = state.products
                        .where((product) =>
                        product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList();

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ProductBloc>().add(FetchProduct());
                      },
                      child: filteredProducts.isEmpty
                          ? const Center(child: Text("Không tìm thấy sản phẩm"))
                          : ListView.separated(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          return ProductItemSection(product: filteredProducts[index]);
                        },
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 24,
                          endIndent: 24,
                        ),
                      ),
                    );
                  } else if (state is ProductError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text("Không có dữ liệu"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
          hintText: 'Tìm kiếm sản phẩm...',
        ),
        onChanged: (query) {
          setState(() {
            _searchQuery = query; // Cập nhật giá trị tìm kiếm
          });
        },
      ),
    );
  }
}
