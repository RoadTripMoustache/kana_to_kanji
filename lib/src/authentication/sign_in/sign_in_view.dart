import "package:flutter/foundation.dart" show defaultTargetPlatform;
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/authentication/sign_in/sign_in_view_model.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_email.dart";
import "package:kana_to_kanji/src/authentication/widgets/input_password.dart";
import "package:kana_to_kanji/src/authentication/widgets/third_party_round_icon_button.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/core/widgets/app_spacer.dart";
import "package:stacked/stacked.dart";

class SignInView extends StatefulWidget {
  static const routeName = "/authentication/login";

  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    const Widget textDivider = Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Divider(),
      ),
    );

    return ViewModelBuilder<SignInViewModel>.reactive(
      viewModelBuilder: () => SignInViewModel(GoRouter.of(context)),
      builder:
          (context, viewModel, child) => AppScaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                key: const Key("sign_in_view_return"),
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSpacer.p64(),
                  // TODO Replace by image
                  if (MediaQuery.of(context).size.width > 650)
                    const Placeholder(fallbackHeight: 200),
                  AppSpacer.p8(),
                  Form(
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
                            onEditingComplete:
                                () async =>
                                    viewModel.onEditingCompleted(submit: true),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed:
                                    viewModel.isBusy
                                        ? null
                                        : viewModel.forgotPassword,
                                style: TextButton.styleFrom(
                                  textStyle: textTheme.titleMedium,
                                ),
                                child: Text(l10n.sign_in_view_forgot_password),
                              ),
                            ],
                          ),
                          if (viewModel.busy(viewModel.isSignInButtonEnabled))
                            const CircularProgressIndicator()
                          else
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 8.0,
                                ),
                                child: FilledButton(
                                  onPressed:
                                      viewModel.isSignInButtonEnabled
                                          ? viewModel.signIn
                                          : null,
                                  child: Text(
                                    l10n.sign_in_view_sign_in,
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacer.p8(),
                  Row(
                    children: [
                      textDivider,
                      Text(
                        l10n.sign_in_view_or_separator,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      textDivider,
                    ],
                  ),
                  AppSpacer.p16(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ThirdPartyRoundIconButton.google(
                        key: const Key("google_sign_in"),
                        onPressed:
                            viewModel.isBusy ? null : viewModel.signInGoogle,
                      ),
                      // Display the Apple button only on iOS
                      if (defaultTargetPlatform == TargetPlatform.iOS)
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: ThirdPartyRoundIconButton.apple(
                            key: const Key("apple_sign_in"),
                            onPressed:
                                viewModel.isBusy ? null : viewModel.signInApple,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
