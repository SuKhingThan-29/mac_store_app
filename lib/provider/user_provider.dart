import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

class UserProvider extends StateNotifier<User?> {
  UserProvider()
      : super(User(
            id: '',
            fullName: '',
            email: '',
            state: '',
            city: '',
            locality: '',
            password: '',
            token: ''));

  User? get user => state;
  void setUser(Map<String,dynamic> json) {
    state = User.fromMap(json);
  }

  void signout() {
    state = null;
  }

  void recreateUserState(
      {required String state, required String city, required String locality}) {
    if (this.state != null) {
      this.state = User(
          id: this.state!.id,
          fullName: this.state!.fullName,
          email: this.state!.email,
          state: state,
          city: city,
          locality: locality,
          password: this.state!.password,
          token: this.state!.token);
    }
  }
}

final userProvider =
    StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());
