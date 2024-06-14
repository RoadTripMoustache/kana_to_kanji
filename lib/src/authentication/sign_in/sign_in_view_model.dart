import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:stacked/stacked.dart";

class SignInViewModel extends BaseViewModel {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoRouter router;

  GlobalKey get formKey => _formKey;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  SignInViewModel(this.router);

  Future<void> forgotPassword() async {
    // TODO : To replace
    await router.push(GlossaryView.routeName);
  }

  void signIn() {
    if (_formKey.currentState!.validate()) {
      // TODO : To replace
      //print("email : ${_emailController.text}");
      //print("password : ${_passwordController.text}");
      _emailController.clear();
      _passwordController.clear();
      router.go(GlossaryView.routeName);
    }
  }

  void signInApple() {
    // TODO : To replace
    router.go(GlossaryView.routeName);
  }

  void signInGoogle() {
    // TODO : To replace
    router.go(GlossaryView.routeName);
  }
}
