import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/constants/authentication_method.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/core/services/toaster_service.dart";
import "package:kana_to_kanji/src/glossary/glossary_view.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:stacked/stacked.dart";

class SignInViewModel extends BaseViewModel {
  final UserRepository _userRepository = locator<UserRepository>();
  final ToasterService _toasterService = locator<ToasterService>();

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusScopeNode focusScopeNode = FocusScopeNode();

  final GoRouter router;
  final AppLocalizations l10n;

  bool get isSignInButtonEnabled =>
      emailController.value.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      (formKey.currentState != null && formKey.currentState!.validate());

  SignInViewModel(this.router, this.l10n);

  /// Used to update the sign in button state
  void onFormChange() {
    notifyListeners();
  }

  /// Move to the next input or unfocus if [submit] is true. Also if [submit] is
  /// true, the [signIn] method will be called
  Future<void> onEditingCompleted(
      {required BuildContext context, bool submit = false}) async {
    if (submit) {
      focusScopeNode.unfocus();
      await signIn(context);
    } else {
      focusScopeNode.nextFocus();
    }
  }

  /// Redirect the user to the forgot password flow
  Future<void> forgotPassword() async {
    // TODO : To replace
    await router.push("/authentication/reset_password");
  }

  Future<void> signIn(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // Change the sign in button into a loading.
      setBusyForObject(isSignInButtonEnabled, true);

      // Disable the form and buttons
      setBusy(true);

      final bool isLoggedIn = await _userRepository.authenticate(
        AuthenticationMethod.classic,
        email: emailController.text,
        password: passwordController.text,
      );
      if (isLoggedIn) {
        emailController.clear();
        passwordController.clear();
        await router.pushReplacement(GlossaryView.routeName);
      } else {
        // ignore: use_build_context_synchronously
        _toasterService.toast(context, l10n.sign_in_error);
        setBusyForObject(isSignInButtonEnabled, false);
        setBusy(false);
      }
    }
  }

  Future<void> signInApple(BuildContext context) async {
    setBusy(true);
    final bool isLoggedIn = await _userRepository.authenticate(
      AuthenticationMethod.apple,
    );
    if (isLoggedIn) {
      await router.pushReplacement(GlossaryView.routeName);
    } else {
      // ignore: use_build_context_synchronously
      _toasterService.toast(context, l10n.sign_in_error);
      setBusyForObject(isSignInButtonEnabled, false);
      setBusy(false);
    }
  }

  Future<void> signInGoogle(BuildContext context) async {
    setBusy(true);
    final bool isLoggedIn = await _userRepository.authenticate(
      AuthenticationMethod.google,
    );
    if (isLoggedIn) {
      await router.pushReplacement(GlossaryView.routeName);
    } else {
      // ignore: use_build_context_synchronously
      _toasterService.toast(context, l10n.sign_in_error);
      setBusyForObject(isSignInButtonEnabled, false);
      setBusy(false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    focusScopeNode.dispose();
    super.dispose();
  }
}
