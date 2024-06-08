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

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoRouter router;
  final BuildContext context;
  final AppLocalizations l10n;

  GlobalKey get formKey => _formKey;

  TextEditingController get emailController => _emailController;

  TextEditingController get passwordController => _passwordController;

  SignInViewModel(this.context, this.router, this.l10n);

  Future<void> forgotPassword() async {
    // TODO : To replace
    await router.push(GlossaryView.routeName);
  }

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      final bool isLoggedIn = await _userRepository.register(
        AuthenticationMethod.classic,
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (isLoggedIn) {
        _emailController.clear();
        _passwordController.clear();
        router.go(GlossaryView.routeName);
      } else {
        // ignore: use_build_context_synchronously
        _toasterService.toast(context, l10n.sign_in_error);
      }
    }
  }

  Future<void> signInApple() async {
    final bool isLoggedIn = await _userRepository.register(
      AuthenticationMethod.apple,
    );
    if (isLoggedIn) {
      router.go(GlossaryView.routeName);
    } else {
      // ignore: use_build_context_synchronously
      _toasterService.toast(context, l10n.sign_in_error);
    }
  }

  Future<void> signInGoogle() async {
    final bool isLoggedIn = await _userRepository.register(
      AuthenticationMethod.google,
    );
    if (isLoggedIn) {
      router.go(GlossaryView.routeName);
    } else {
      // ignore: use_build_context_synchronously
      _toasterService.toast(context, l10n.sign_in_error);
    }
  }
}
