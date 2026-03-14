import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketmate_app/provider/category_provider.dart';
import 'package:marketmate_app/views/presentation/detail/screens/inner_category_screen.dart';

import '../../../../controllers/category_controller.dart';
import '../../detail/screens/widgets/section_title.dart';
import 'category_item.dart';
import 'reuseable_text_widget.dart';

// class CategoryItemWidget extends ConsumerStatefulWidget {
//   const CategoryItemWidget({super.key});
//
//   @override
//   _CategoryItemWidgetState createState() => _CategoryItemWidgetState();
// }
//
// class _CategoryItemWidgetState extends ConsumerState<CategoryItemWidget> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _fetchCategory();
//   }
//
//   Future<void> _fetchCategory() async {
//     final CategoryController _categoryController = CategoryController();
//     try {
//       final categories = await _categoryController.loadCategories();
//       ref.read(categoryProvider.notifier).setCategories(categories);
//     } catch (e) {}
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final categories = ref.watch(categoryProvider);
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         ReuseableTextWidget(
//           title: 'Categories',
//           subtitle: "View All",
//         ),
//         SizedBox(
//           height: 200,
//           child: GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
//               itemCount: categories.length, // Correctly set itemCount
//
//               itemBuilder: (context, index) {
//                 final category = categories[index];
//                 return InkWell(
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) {
//                       return InnerCategoryScreen(category: category);
//                     }));
//                   },
//                   child: Column(
//                     children: [
//                       Image.network(
//                         category.image,
//                         height: 47,
//                         width: 47,
//                         errorBuilder: (context, error, stackTrace) =>
//                             const Icon(Icons.error),
//                       ),
//                       Text(
//                         category.name,
//                         style: GoogleFonts.quicksand(
//                             fontWeight: FontWeight.bold, fontSize: 16),
//                       )
//                     ],
//                   ),
//                 );
//               }),
//         ),
//       ],
//     );
//   }
// }

class CategoryItemWidget extends ConsumerWidget {
  const CategoryItemWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(categoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Categories', subtitle: 'View All'),

        categoryAsync.when(
          data: (categories) => SizedBox(
            height: 200,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (_, index) {
                final category = categories[index];

                return CategoryItem(category: category);
              },
            ),
          ),
          loading: () =>
          const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text("Error")),
        ),
      ],
    );
  }

}

