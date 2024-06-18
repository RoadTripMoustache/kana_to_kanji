import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:stacked/stacked.dart";

class SignInViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  final GoRouter router;

  bool get isSignInButtonEnabled =>
      !(emailController.value.text.isEmpty ||
          passwordController.text.isEmpty) ||
      (formKey.currentState != null && formKey.currentState!.validate());

  SignInViewModel(this.router);

  void onEditingCompleted() {
    if (emailFocusNode.hasFocus) {
      passwordFocusNode.requestFocus();
    } else {
      passwordFocusNode.nextFocus();
      signIn();
    }
  }

  Future<void> forgotPassword() async {
    // TODO : To replace
    await router.push(GlossaryView.routeName);
  }

  void signIn() {
    if (formKey.currentState!.validate()) {
      setBusyForObject(isSignInButtonEnabled, true);
      setBusy(true);
      // TODO: Handle login
      // router.go(GlossaryView.routeName);
    }
  }

  void signInApple() {
    // TODO : To replace
    setBusy(true);
    router.go(GlossaryView.routeName);
  }

  void signInGoogle() {
    // TODO : To replace
    setBusy(true);
    router.go(GlossaryView.routeName);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
}
