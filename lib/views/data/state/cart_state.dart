import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_state.freezed.dart';
@freezed
class CartState with _$CartState{
  const factory CartState({
    @Default(0) int count,

})=_CartState;

}