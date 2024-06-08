import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:stacked/stacked.dart";

class CreateAccountViewModel extends FutureViewModel {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final GoRouter router;

  GlobalKey get formKey => _formKey;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get passwordConfirmationController =>
      _passwordConfirmationController;

  CreateAccountViewModel(this.router);

  @override
  Future futureToRun() async {}

  void createAccount() {
    if (_formKey.currentState!.validate()) {
      // TODO : To replace
      _emailController.clear();
      _passwordController.clear();
      router.go(GlossaryView.routeName);
    }
  }

  void createAccountApple() {
    // TODO : To replace
    router.go(GlossaryView.routeName);
  }

  void createAccountGoogle() {
    // TODO : To replace
    router.go(GlossaryView.routeName);
  }
}
