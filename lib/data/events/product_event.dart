abstract class ProductEvent{}

class FetchProduct extends ProductEvent{}

class AddProduct extends ProductEvent{
  final String name;
  final int price;
  final String imageUrl;

  AddProduct({required this.name, required this.price, required this.imageUrl});
}