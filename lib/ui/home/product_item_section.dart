import 'package:flutter/material.dart';
import 'package:product_management/data/models/product.dart';

class ProductItemSection extends StatelessWidget {
  final Product product;

  const ProductItemSection({super.key, required this.product});

  bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasAbsolutePath;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: isValidUrl(product.imageUrl)
                ? Image.network(
              product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint("Lỗi tải ảnh: $error");
                return Image.asset(
                  'assets/images/defaultproduct.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              },
            )
                : Image.asset(
              'assets/images/defaultproduct.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 30), // Khoảng cách giữa ảnh và chữ
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Căn chữ sang trái
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.price} VNĐ',
                      style: const TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {  },

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
