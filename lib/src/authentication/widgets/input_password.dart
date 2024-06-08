import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class InputPassword extends StatefulWidget {
  /// Controller of the input password
  final TextEditingController controller;

  /// Controller of the main password input,
  /// meaning that this input is used to confirm the first one.
  final TextEditingController? passwordToConfirmController;

  const InputPassword({
    required this.controller,
    this.passwordToConfirmController,
    super.key,
  });

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        key: widget.passwordToConfirmController != null
            ? const Key("password_confirmation_input_widget")
            : const Key("password_input_widget"),
        controller: widget.controller,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return widget.passwordToConfirmController == null
                ? l10n.input_password_msg_missing_password
                : l10n.input_password_msg_missing_password_confirmation;
          } else if (widget.passwordToConfirmController != null &&
              widget.passwordToConfirmController?.text !=
                  widget.controller.text) {
            return l10n.input_password_configuration_mismatch;
          }
          return null;
        },
        obscureText: passwordVisible,
        decoration: InputDecoration(
          hintText: widget.passwordToConfirmController != null
              ? l10n.input_password_confirmation_placeholder
              : l10n.input_password_placeholder,
          suffixIcon: IconButton(
            icon: Icon(passwordVisible
                ? Icons.visibility_rounded
                : Icons.visibility_off),
            onPressed: () {
              setState(
                () {
                  passwordVisible = !passwordVisible;
                },
              );
            },
          ),
          alignLabelWithHint: false,
        ),
      ),
    );
  }
}
