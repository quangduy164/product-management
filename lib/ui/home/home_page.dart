import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_management/data/repository/api_repository.dart';
import 'package:product_management/ui/home/add_product_tab.dart';
import 'package:product_management/ui/home/product_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  String _appBarTitle = "Quản lý sản phẩm";

  final List<Widget> _tabs = [
    const ProductTab(),
    const AddProductTab(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchFormData();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // Kiểm tra chiều cao bàn phím
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_appBarTitle), // Hiển thị tiêu đề từ API
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          activeColor: Colors.black,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Thêm sản phẩm'),
          ],
          height: bottomInset > 0 ? 0 : kBottomNavigationBarHeight, // Ẩn tab nếu bàn phím xuất hiện
        ),
        tabBuilder: (BuildContext context, int index) {
          return _tabs[index];
        },
      ),
    );
  }

  Future<void> _fetchFormData() async {
    try {
      final formData = await ApiRepository().fetchFormData();
      setState(() {
        _appBarTitle = formData.label; //Lấy title từ API
      });
    } catch (e) {
      debugPrint("Lỗi khi lấy dữ liệu: $e");
    }
  }
}
