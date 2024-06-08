import "package:flutter/foundation.dart" show defaultTargetPlatform;
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/authentication/create/create_account_view_model.dart";
import "package:kana_to_kanji/src/authentication/widgets/button_logo.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_email.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_password.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:stacked/stacked.dart";

class CreateAccountView extends StatelessWidget {
  static const routeName = "/authentication/link";

  const CreateAccountView({
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

    return ViewModelBuilder<CreateAccountViewModel>.reactive(
      viewModelBuilder: () => CreateAccountViewModel(GoRouter.of(context)),
      builder: (context, viewModel, child) => AppScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            key: const Key("create_account_view_return"),
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
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
                InputPassword(
                  controller: viewModel.passwordConfirmationController,
                  passwordToConfirmController: viewModel.passwordController,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FilledButton(
                      key: const Key(
                          "create_account_view_create_account_button"),
                      onPressed: viewModel.createAccount,
                      child: Text(
                        l10n.create_account_view_create_account,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0, bottom: 28.0),
                  child: Row(
                    children: [
                      textDivider,
                      Text(
                        l10n.create_account_view_or_separator,
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
                        onPressedFunction: viewModel.createAccountGoogle,
                      ),
                    ),
                    // Display the Apple button only on iOS
                    if (defaultTargetPlatform == TargetPlatform.iOS)
                      Expanded(
                        child: ButtonLogo.apple(
                          onPressedFunction: viewModel.createAccountApple,
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
