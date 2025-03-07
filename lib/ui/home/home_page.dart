import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_management/ui/home/add_product_tab.dart';
import 'package:product_management/ui/home/product_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{
  final List<Widget> _tabs = [
    const ProductTab(),
    const AddProductTab()
  ];
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;//Kiểm tra chiều cao bàn phím
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Quản lý sản phẩm'),
      ),
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            activeColor: Colors.black,
              backgroundColor: Colors.white,
              items: const[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
                BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Thêm sản phẩm')
              ],
            height: bottomInset > 0 ? 0 : kBottomNavigationBarHeight,//Nếu bàn phím xuất hiện thì ẩn tabbottom
          ),
          tabBuilder: (BuildContext context, int index){
            return _tabs[index];
          },
        ),
    );
  }
}