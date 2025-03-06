class Product{
  final String name;
  final int price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});

  factory Product.fromJs(Map<String, dynamic> json){
    return Product(
      name: json["name"],
      price: json["price"],
      imageUrl: json["imageSrc"]
    );
  }
}