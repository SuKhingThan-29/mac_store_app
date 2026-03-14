import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/cart_state.dart';

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    return const CartState();
  }

  void addItem() {
    state = state.copyWith(count: state.count + 1);
  }

  void removeItem() {
    if (state.count == 0) return;
    state = state.copyWith(count: state.count - 1);
  }

  void clear() {
    state = const CartState();
  }
}

