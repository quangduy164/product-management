import 'package:product_management/data/models/product.dart';

abstract class ProductEvent{}

class FetchProduct extends ProductEvent{}

class AddProduct extends ProductEvent{
  final String name;
  final int price;
  final String imageUrl;

  AddProduct({required this.name, required this.price, required this.imageUrl});
}

class DeleteProduct extends ProductEvent {
  final Product product;

  DeleteProduct({required this.product});
}
