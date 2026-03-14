import 'package:flutter/material.dart';
import 'package:marketmate_app/views/presentation/detail/screens/widgets/inner_category_content_widget.dart';
import 'package:marketmate_app/views/presentation/detail/screens/widgets/inner_header_widget.dart';

import '../../../../models/category.dart';
import '../../nav_screen/account_screen.dart';
import '../../nav_screen/cart_screen.dart';
import '../../nav_screen/category_screen.dart';
import '../../nav_screen/favorite_screen.dart';
import '../../nav_screen/store_screen.dart';

class InnerCategoryScreen extends StatefulWidget {
  final Category category;
  const InnerCategoryScreen({super.key, required this.category});

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      InnerCategoryContentWidget(
        category: widget.category,
      ),
       FavoriteScreen(),
      const CategoryScreen(),
      const StoreScreen(),
      const CartScreen(),
      AccountScreen()
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _pageIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/home.png",
                width: 25,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/love.png", width: 25),
              label: "Favorite"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/mart.png", width: 25),
              label: "Stores"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/cart.png", width: 25),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/user.png", width: 25),
              label: "Account"),
        ],
      ),
      body: pages[_pageIndex],
    );
  }
}
