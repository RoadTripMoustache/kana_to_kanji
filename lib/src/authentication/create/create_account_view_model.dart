import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class CreateAccountViewModel extends FutureViewModel {
  final UserRepository _userRepository = locator<UserRepository>();
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

  Future<void> createAccount() async {
    if (_formKey.currentState!.validate()) {
      await _userRepository.linkAccount(AuthenticationMethod.classic,
          email: _emailController.value.text,
          password: _passwordController.value.text);
      _emailController.clear();
      _passwordController.clear();
      router.go(GlossaryView.routeName);
    }
  }

  Future<void> createAccountApple() async {
    await _userRepository.linkAccount(AuthenticationMethod.apple);
    router.go(GlossaryView.routeName);
  }

  Future<void> createAccountGoogle() async {
    await _userRepository.linkAccount(AuthenticationMethod.google);
    router.go(GlossaryView.routeName);
  }
}
