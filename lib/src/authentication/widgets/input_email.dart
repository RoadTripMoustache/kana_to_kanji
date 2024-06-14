import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/regexp.dart";

class InputEmail extends StatelessWidget {
  final TextEditingController controller;
  final bool isRequired;

  const InputEmail(
      {required this.controller, this.isRequired = true, super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        key: const Key("email_input_widget"),
        controller: controller,
        decoration: InputDecoration(hintText: l10n.input_email_placeholder),
        validator: (String? value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return l10n.input_email_missing_email;
          } else if (value != null && !emailRegexp.hasMatch(value)) {
            return l10n.input_email_incorrect_email_format;
          }
          return null;
        },
      ),
    );
  }
}
