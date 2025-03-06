import 'dart:convert';

import 'package:product_management/data/models/form_data.dart';
import 'package:product_management/data/models/product.dart';
import 'package:http/http.dart' as http;

class ApiRepository{
  final String baseUrl = 'https://hiring-test.stag.tekoapis.net/api/products/management';

  Future<List<Product>> fetchProducts() async{
    try{
      final response = await http.get(Uri.parse(baseUrl));
      if(response.statusCode == 200){
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        List<Product> products = (jsonData["data"][3]["customAttributes"]["productlist"]
        ["items"] as List).map((item) => Product.fromJs(item)).toList();
        return products;
      } else{
        throw Exception('Lỗi khi lấy dữ liệu từ API');
        }
    } catch(e){
      throw Exception('Lỗi khi kết nối API: $e');
    }
  }

  Future<FormData> fetchFormData() async{
    try{
      final response = await http.get(Uri.parse(baseUrl));
      if(response.statusCode == 200){
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return FormData.fromJs(jsonData);
      } else{
        throw Exception('Lỗi khi lấy dữ liệu từ API');
      }
    } catch(e){
      throw Exception('Lỗi khi kết nối API: $e');
    }
  }
}