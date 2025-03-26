import "dart:async";

import "package:flutter/material.dart";
import "package:kana_to_kanji/l10n/app_localizations.dart";
import "package:kana_to_kanji/src/core/constants/regexp.dart";

class InputEmail extends StatefulWidget {
  final TextEditingController controller;
  final bool autofocus;
  final bool isRequired;
  final bool enabled;
  final VoidCallback? onChange;
  final VoidCallback? onEditingComplete;
  final TextInputAction textInputAction;

  const InputEmail({
    required this.controller,
    this.isRequired = true,
    this.autofocus = false,
    this.enabled = true,
    this.textInputAction = TextInputAction.none,
    this.onChange,
    this.onEditingComplete,
    super.key,
  });

  @override
  State<InputEmail> createState() => _InputEmailState();
}

class _InputEmailState extends State<InputEmail> {
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>(
    debugLabel: "email_input_widget",
  );
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _onChange(String? _) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 300), () {
      _formFieldKey.currentState!.validate();
      widget.onChange?.call();
    });
  }

  String? _validate(String? value, AppLocalizations l10n) {
    if (widget.isRequired && (value == null || value.isEmpty)) {
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
        controller: widget.controller,
        autofillHints: const [AutofillHints.email],
        keyboardType: TextInputType.emailAddress,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        textInputAction: widget.textInputAction,
        onEditingComplete: widget.onEditingComplete,
        onChanged: _onChange,
        decoration: InputDecoration(hintText: l10n.input_email_placeholder),
        validator: (String? value) => _validate(value, l10n),
      ),
    );
  }
}
