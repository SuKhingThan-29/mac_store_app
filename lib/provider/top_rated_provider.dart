import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/product_controller.dart';
import '../models/product.dart';

class TopRatedProvider extends StateNotifier<List<Product>> {
  TopRatedProvider() : super([]);

  void setProduct(List<Product> products) {
    state = products;
  }
}

final topRatedProductProvider =
    StateNotifierProvider<TopRatedProvider, List<Product>>((ref) {
  return TopRatedProvider();
});

final topRatedProvider = FutureProvider((ref) async {
  return ProductController().loadTopRatedProduct();
});