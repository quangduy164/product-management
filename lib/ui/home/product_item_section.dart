import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_management/data/models/product.dart';

class ProductItemSection extends StatelessWidget {
  final Product product;

  const ProductItemSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/defaultproduct.png',
          image: product.imageUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/defaultproduct.png',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${product.price} VND', style: const TextStyle(color: Colors.green)),
      onTap: () {
        // TODO: Xử lý khi nhấn vào sản phẩm (ví dụ: điều hướng đến chi tiết sản phẩm)
      },
    );
  }
}
