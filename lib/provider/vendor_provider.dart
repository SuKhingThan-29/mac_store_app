import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketmate_app/models/banner_model.dart';

import '../models/vendor_model.dart';

class VendorProvider extends StateNotifier<List<Vendor>> {
  VendorProvider() : super([]);

  void setVendor(List<Vendor> vendors) {
    state = vendors;
  }
}

final vendorProvider =
StateNotifierProvider<VendorProvider, List<Vendor>>((ref) {
  return VendorProvider();
});
