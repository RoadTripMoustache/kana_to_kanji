import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class InputPassword extends StatefulWidget {
  final TextEditingController controller;

  const InputPassword({
    required this.controller,
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
        key: const Key("password_input_widget"),
        controller: widget.controller,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return l10n.input_password_msg_missing_password;
          }
          return null;
        },
        obscureText: passwordVisible,
        decoration: InputDecoration(
          hintText: l10n.input_password_placeholder,
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
