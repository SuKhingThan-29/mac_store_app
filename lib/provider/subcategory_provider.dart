import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketmate_app/models/subcategory.dart';

import '../controllers/subcategory_controller.dart';
import '../models/category.dart';

class SubcategoryProvider extends StateNotifier<List<Subcategory>> {
  SubcategoryProvider() : super([]);

  //set the list of subcategories
  void setSubCategories(List<Subcategory> subcategories) {
    state = subcategories;
  }
}

// final subcategoryProvider =
//     StateNotifierProvider<SubcategoryProvider, List<Subcategory>>((ref) {
//   return SubcategoryProvider();
// });

final subcategoryProvider =
FutureProvider.family((ref, String categoryName) async {
  return SubcategoryController()
      .getSubCategoryByCategoryName(categoryName);
});

final selectedCategoryProvider = StateProvider<Category?>((ref) => null);
