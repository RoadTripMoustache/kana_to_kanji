import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:stacked/stacked.dart";

class CreateAccountViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final FocusScopeNode focusScopeNode = FocusScopeNode();
  final GoRouter router;

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get passwordConfirmationController =>
      _passwordConfirmationController;
  bool get isCreateAccountButtonEnabled =>
      emailController.value.text.isNotEmpty &&
      passwordController.value.text.isNotEmpty &&
      _passwordConfirmationController.value.text.isNotEmpty &&
      (formKey.currentState != null && formKey.currentState!.validate());

  CreateAccountViewModel(this.router);

  /// Used to update the sign in button state
  void onFormChange() {
    notifyListeners();
  }

  /// Move to the next input or unfocus if [submit] is true. Also if [submit] is
  /// true, the [createAccount] method will be called
  Future<void> onEditingCompleted({bool submit = false}) async {
    if (submit) {
      focusScopeNode.unfocus();
      await createAccount();
    } else {
      focusScopeNode.nextFocus();
    }
  }

  Future<void> createAccount() async {
    if (formKey.currentState!.validate()) {
      // Change the create account button into a loading.
      setBusyForObject(isCreateAccountButtonEnabled, true);
      // Disable the form and buttons
      setBusy(true);

      // TODO: Handle create account process

      _emailController.clear();
      _passwordController.clear();
      _passwordConfirmationController.clear();
      // TODO: replace with profile route.
      await router.pushReplacement(GlossaryView.routeName);
    }
  }

  Future<void> createAccountApple() async {
    setBusy(true);
    // TODO: replace with profile route.
    await router.pushReplacement(GlossaryView.routeName);
  }

  Future<void> createAccountGoogle() async {
    setBusy(true);
    // TODO: replace with profile route.
    await router.pushReplacement(GlossaryView.routeName);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    focusScopeNode.dispose();
    super.dispose();
  }
}
