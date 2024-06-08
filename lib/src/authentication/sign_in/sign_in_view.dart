import "package:flutter/foundation.dart" show defaultTargetPlatform;
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/authentication/landing_view.dart";
import "package:kana_to_kanji/src/authentication/sign_in/sign_in_view_model.dart";
import "package:kana_to_kanji/src/authentication/widgets/button_logo.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_email.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_password.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:stacked/stacked.dart";

class SignInView extends StatelessWidget {
  static const routeName = "/authentication/login";

  const SignInView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final Widget textDivider = Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Divider(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
    );

    return ViewModelBuilder<SignInViewModel>.reactive(
      viewModelBuilder: () =>
          SignInViewModel(context, GoRouter.of(context), l10n),
      builder: (context, viewModel, child) => AppScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            key: const Key("sign_in_view_return"),
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.replace(LandingView.routeName),
          ),
        ),
        body: Form(
          key: viewModel.formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputEmail(controller: viewModel.emailController),
                InputPassword(controller: viewModel.passwordController),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, top: 8.0, bottom: 8.0),
                    child: TextButton(
                      key: const Key("sign_in_view_forgot_password"),
                      onPressed: viewModel.forgotPassword,
                      child: Text(
                        l10n.sign_in_view_forgot_password,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FilledButton(
                      key: const Key("sign_in_view_sign_in_button"),
                      onPressed: viewModel.signIn,
                      child: Text(
                        l10n.sign_in_view_sign_in,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28.0),
                  child: Row(
                    children: [
                      textDivider,
                      Text(
                        l10n.sign_in_view_or_separator,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      textDivider
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ButtonLogo.google(
                        onPressedFunction: viewModel.signInGoogle,
                      ),
                    ),
                    // Display the Apple button only on iOS
                    if (defaultTargetPlatform == TargetPlatform.iOS)
                      Expanded(
                        child: ButtonLogo.apple(
                          onPressedFunction: viewModel.signInApple,
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
