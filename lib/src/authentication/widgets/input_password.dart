import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class InputPassword extends StatefulWidget {
  final TextEditingController controller;

  final VoidCallback? onChange;

  final VoidCallback? onEditingComplete;

  final bool isRequired;

  final bool autoFocus;

  final bool enabled;

  final TextInputAction textInputAction;

  const InputPassword({
    required this.controller,
    this.isRequired = true,
    this.autoFocus = false,
    this.enabled = true,
    this.onChange,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.done,
    super.key,
  });

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  final GlobalKey<FormFieldState> _formFieldKey =
      GlobalKey<FormFieldState>(debugLabel: "password_input_widget");
  // Timer applied before the validation is triggered
  Timer? timer;

  // Indicate if the password is hidden or not.
  bool isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    isPasswordObscured = true;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _onChange(String? _) {
    timer?.cancel();
    // Trigger a new timer that will validate on inactivity
    timer = Timer(const Duration(milliseconds: 300), () {
      _formFieldKey.currentState!.validate();
      widget.onChange?.call();
    });
  }

  String? _validate(String? value, AppLocalizations l10n) {
    if (widget.isRequired && (value == null || value.isEmpty)) {
      return l10n.input_password_msg_missing_password;
    }
    return null;
  }

  void _toggleVisibility() {
    setState(() {
      isPasswordObscured = !isPasswordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
      child: TextFormField(
        key: _formFieldKey,
        controller: widget.controller,
        autofocus: widget.autoFocus,
        enabled: widget.enabled,
        autofillHints: const [AutofillHints.password],
        textInputAction: widget.textInputAction,
        onChanged: _onChange,
        onEditingComplete: widget.onEditingComplete,
        validator: (String? value) => _validate(value, l10n),
        obscureText: isPasswordObscured,
        decoration: InputDecoration(
          hintText: l10n.input_password_placeholder,
          suffixIcon: IconButton(
            icon: Icon(isPasswordObscured
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded),
            onPressed: _toggleVisibility,
          ),
          alignLabelWithHint: false,
        ),
      ),
    );
  }
}
