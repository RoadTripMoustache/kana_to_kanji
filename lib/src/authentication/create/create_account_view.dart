import "package:flutter/foundation.dart" show defaultTargetPlatform;
import "package:flutter/material.dart";
import "package:flutter_rtm/flutter_rtm.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/authentication/create/create_account_view_model.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_email.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_password.dart";
import "package:kana_to_kanji/src/authentication/widgets/third_party_round_icon_button.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/core/widgets/app_spacer.dart";
import "package:stacked/stacked.dart";

class CreateAccountView extends StatelessWidget {
  static const routeName = "/authentication/link";

  const CreateAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    const Widget textDivider = Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Divider(),
      ),
    );

    return ViewModelBuilder<CreateAccountViewModel>.reactive(
      viewModelBuilder: () => CreateAccountViewModel(GoRouter.of(context)),
      builder:
          (context, viewModel, child) => AppScaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: RTMIconButton(
                key: const Key("create_account_view_return"),
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: viewModel.formKey,
                child: FocusScope(
                  node: viewModel.focusScopeNode,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InputEmail(
                        controller: viewModel.emailController,
                        autofocus: true,
                        enabled: !viewModel.isBusy,
                        onChange: viewModel.onFormChange,
                        onEditingComplete: viewModel.onEditingCompleted,
                      ),
                      InputPassword(
                        controller: viewModel.passwordController,
                        onChange: viewModel.onFormChange,
                        enabled: !viewModel.isBusy,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: viewModel.onEditingCompleted,
                      ),
                      InputPassword(
                        controller: viewModel.passwordConfirmationController,
                        validate: (value) {
                          if (viewModel.passwordController.text !=
                              viewModel.passwordConfirmationController.text) {
                            return l10n.input_password_configuration_mismatch;
                          }
                          return null;
                        },
                        onChange: viewModel.onFormChange,
                        enabled: !viewModel.isBusy,
                        textInputAction: TextInputAction.next,
                        onEditingComplete:
                            () async =>
                                viewModel.onEditingCompleted(submit: true),
                        textHint: l10n.input_password_confirmation_placeholder,
                      ),
                      if (viewModel.busy(
                        viewModel.isCreateAccountButtonEnabled,
                      ))
                        const RTMSpinner()
                      else
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                            child: FilledButton(
                              key: const Key(
                                "create_account_view_create_account_button",
                              ),
                              onPressed:
                                  viewModel.isCreateAccountButtonEnabled
                                      ? viewModel.createAccount
                                      : null,
                              child: Text(
                                l10n.create_account_view_create_account,
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),
                      AppSpacer.p8(),
                      Row(
                        children: [
                          textDivider,
                          Text(
                            l10n.create_account_view_or_separator,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                          textDivider,
                        ],
                      ),
                      AppSpacer.p16(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ThirdPartyRoundRTMIconButton.google(
                            onPressed:
                                viewModel.isBusy
                                    ? null
                                    : viewModel.createAccountGoogle,
                          ),
                          // Display the Apple button only on iOS
                          if (defaultTargetPlatform == TargetPlatform.iOS)
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: ThirdPartyRoundRTMIconButton.apple(
                                onPressed:
                                    viewModel.isBusy
                                        ? null
                                        : viewModel.createAccountApple,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
