import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketmate_app/controllers/category_controller.dart';
import 'package:marketmate_app/models/category.dart';

class CategoryProvider extends StateNotifier<List<Category>> {
  CategoryProvider() : super([]);
  void setCategories(List<Category> categories) {
    state = categories;
  }
}

// final categoryProvider =
//     StateNotifierProvider<CategoryProvider, List<Category>>((ref) {
//   return CategoryProvider();
// });

final categoryProvider=FutureProvider((ref)async{
  return CategoryController().loadCategories();

});
