import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/regexp.dart";

class InputEmail extends StatelessWidget {
  final GlobalKey<FormFieldState> _formFieldKey =
      GlobalKey<FormFieldState>(debugLabel: "email_input_widget");

  final TextEditingController controller;
  final bool autofocus;
  final bool isRequired;
  final VoidCallback? onEditingComplete;
  final TextInputAction textInputAction;

  InputEmail(
      {required this.controller,
      this.isRequired = true,
      this.autofocus = false,
      this.textInputAction = TextInputAction.continueAction,
      this.onEditingComplete,
      super.key});

  void _onEditingComplete() {
    if (_formFieldKey.currentState!.validate()) {
      onEditingComplete?.call();
    }
  }

  String? _validate(String? value, AppLocalizations l10n) {
    if (isRequired && (value == null || value.isEmpty)) {
      return l10n.input_email_missing_email;
    } else if (value != null && !emailRegexp.hasMatch(value)) {
      return l10n.input_email_incorrect_email_format;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
      child: TextFormField(
          key: _formFieldKey,
          controller: controller,
          autofillHints: const [AutofillHints.email],
          keyboardType: TextInputType.emailAddress,
          autofocus: autofocus,
          textInputAction: textInputAction,
          onEditingComplete: _onEditingComplete,
          decoration: InputDecoration(hintText: l10n.input_email_placeholder),
          validator: (String? value) => _validate(value, l10n)),
    );
  }
}
