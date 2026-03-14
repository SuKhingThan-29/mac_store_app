import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketmate_app/views/data/state/nav_state.dart';
import 'package:marketmate_app/views/data/state_notifier/nav_notifier.dart';

import '../../../provider/cart_provider.dart';
import '../state/cart_state.dart';

final navProvider=NotifierProvider<NavNotifier,NavState>(NavNotifier.new);

