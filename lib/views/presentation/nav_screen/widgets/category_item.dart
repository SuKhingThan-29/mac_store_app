import 'package:flutter/material.dart';

import '../../../../models/category.dart';
import '../../detail/screens/inner_category_screen.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InnerCategoryScreen(category: category),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black.withOpacity(0.08),
                )
              ],
            ),
            child: Image.network(
              category.image,
              height: 40,
              width: 40,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}