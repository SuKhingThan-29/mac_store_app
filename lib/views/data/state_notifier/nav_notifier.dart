import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketmate_app/views/data/state/nav_state.dart';

class NavNotifier extends Notifier<NavState>{
  @override
  NavState build(){
    return const NavState();
  }

  void changeTab(int index){
    if(state.index==index) return;

    state=state.copyWith(index: index,isAnimating: true);

    Future.delayed(const Duration(microseconds: 300), (){
      state=state.copyWith(isAnimating: false);

    });
  }
}