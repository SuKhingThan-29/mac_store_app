import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/category.dart';
import '../../../../provider/subcategory_provider.dart';
import '../../detail/screens/subcategory_product_screen.dart';
import '../../detail/screens/widgets/subcategory_tile_widget.dart';

class SubcategorySection extends ConsumerWidget {
  final Category? category;

  const SubcategorySection({this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subAsync =
    ref.watch(subcategoryProvider(category!.name));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// title
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              category!.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                category!.banner,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// subcategory grid
          subAsync.when(
            data: (subcategories) {
              if (subcategories.isEmpty) {
                return const Center(child: Text("No Subcategories"));
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: subcategories.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (_, i) {
                  final sub = subcategories[i];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SubcategoryProductScreen(
                                  subcategory: sub),
                        ),
                      );
                    },
                    child: SubcategoryTileWidget(
                      image: sub.image,
                      title: sub.subCategoryName,
                    ),
                  );
                },
              );
            },
            loading: () =>
            const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text("Error")),
          ),
        ],
      ),
    );
  }
}