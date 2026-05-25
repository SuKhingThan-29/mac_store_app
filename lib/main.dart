import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:marketmate_app/controllers/auth_controller.dart';
import 'package:marketmate_app/provider/user_provider.dart';
import 'package:marketmate_app/views/presentation/authentication_screen/login_screen.dart';
import 'package:marketmate_app/views/presentation/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51QtrksCcEl8IraMmOHoej6du7QIpUCfSBIVNFAiilrcyUFn7xk7Rjn6BOqAOt2DdmEFrXy99lUbRxlTQGWJkxGAc00NkLLiEbw';
  await Stripe.instance.applySettings();
  //Run the flutter app wrapped in a ProviderScope for managing state
  runApp(const ProviderScope(child: MyApp()));
}

//Root widget of the application, a consumer widget to consume state change
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<void> _checkTokenAndSetUser(WidgetRef ref, context) async {
    await AuthController().getUserData(context, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Material(
          child: FutureBuilder(
              future: _checkTokenAndSetUser(ref, context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final user = ref.watch(userProvider);
                return user!.token.isNotEmpty? MainScreen() : LoginScreen();
              }),
        ));
  }
}
