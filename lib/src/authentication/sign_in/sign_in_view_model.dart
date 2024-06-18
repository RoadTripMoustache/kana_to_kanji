import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:stacked/stacked.dart";

class SignInViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusScopeNode focusScopeNode = FocusScopeNode();

  final GoRouter router;

  bool get isSignInButtonEnabled =>
      emailController.value.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      (formKey.currentState != null && formKey.currentState!.validate());

  SignInViewModel(this.router);

  /// Used to update the sign in button state
  void onFormChange() {
    notifyListeners();
  }

  /// Move to the next input or unfocus if [submit] is true. Also if [submit] is
  /// true, the [signIn] method will be called
  void onEditingCompleted({bool submit = false}) {
    if (submit) {
      focusScopeNode.unfocus();
      signIn();
    } else {
      focusScopeNode.nextFocus();
    }
  }

  /// Redirect the user to the forgot password flow
  Future<void> forgotPassword() async {
    // TODO : To replace
    await router.push(GlossaryView.routeName);
  }

  void signIn() {
    if (formKey.currentState!.validate()) {
      // Change the sign in button into a loading.
      setBusyForObject(isSignInButtonEnabled, true);

      // Disable the form and buttons
      setBusy(true);

      // TODO: Handle login
      router.go(GlossaryView.routeName);
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
    focusScopeNode.dispose();
    super.dispose();
  }
}
