import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../models/vendor_model.dart';

class VendorProductProvider extends StateNotifier<List<Product>> {
  VendorProductProvider() : super([]);

  void setVendor(List<Product> vendors) {
    state = vendors;
  }
}

final vendorProductProvider =
StateNotifierProvider<VendorProductProvider, List<Product>>((ref) {
  return VendorProductProvider();
});