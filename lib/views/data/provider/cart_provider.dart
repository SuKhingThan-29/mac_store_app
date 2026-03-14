import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/cart_state.dart';
import '../state_notifier/cart_notifier.dart';

final cartProvider =
NotifierProvider<CartNotifier, CartState>(CartNotifier.new);