import 'package:product_management/data/models/product.dart';

abstract class ProductState{}

class ProductInitial extends ProductState{}

class ProductLoading extends ProductState{}

class ProductLoaded extends ProductState{
  final List<Product> products;
  final ProductAction action;
  ProductLoaded({required this.products, required this.action});
}

class ProductError extends ProductState{
  final String message;
  ProductError({required this.message});
}

enum ProductAction { fetch, added, deleted}