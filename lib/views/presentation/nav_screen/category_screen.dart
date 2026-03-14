import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketmate_app/controllers/subcategory_controller.dart';
import 'package:marketmate_app/provider/category_provider.dart';
import 'package:marketmate_app/provider/subcategory_provider.dart';
import 'package:marketmate_app/views/presentation/detail/screens/subcategory_product_screen.dart';
import 'package:marketmate_app/views/presentation/detail/screens/widgets/subcategory_tile_widget.dart';
import 'package:marketmate_app/views/presentation/nav_screen/widgets/sub_category_screen.dart';

import '../../../controllers/category_controller.dart';
import '../../../models/category.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(categoryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      //appBar:  HomeHeader(),
      body: Row(
        children: [
          /// LEFT SIDE (Category List)
          Expanded(
            flex: 2,
            child: categoryAsync.when(
              data: (categories) {
                /// set default category once
                if (selectedCategory == null && categories.isNotEmpty) {
                  Future.microtask(() {
                    ref.read(selectedCategoryProvider.notifier).state =
                        categories.first;
                  });
                }

                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (_, index) {
                    final category = categories[index];

                    final isSelected =
                        selectedCategory?.id == category.id;

                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: Colors.blue.shade50,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category;
                      },
                      title: Text(
                        category.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.blue
                              : Colors.black,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text("Error")),
            ),
          ),

          /// RIGHT SIDE (Subcategory)
          Expanded(
            flex: 5,
            child: selectedCategory == null
                ? const Center(child: Text("Select Category"))
                : SubcategorySection(category: selectedCategory),
          )
        ],
      ),
    );
  }
}
