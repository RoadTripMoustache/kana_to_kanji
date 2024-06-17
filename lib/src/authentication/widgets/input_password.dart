import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class InputPassword extends StatefulWidget {
  final TextEditingController controller;

  final VoidCallback? onEditingComplete;

  final bool isRequired;

  final bool autoFocus;

  final TextInputAction textInputAction;

  const InputPassword({
    required this.controller,
    this.isRequired = true,
    this.autoFocus = false,
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

  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  void _onEditingComplete() {
    if (_formFieldKey.currentState!.validate()) {
      widget.onEditingComplete?.call();
    }
  }

  String? _validate(String? value, AppLocalizations l10n) {
    if (widget.isRequired && (value == null || value.isEmpty)) {
      return l10n.input_password_msg_missing_password;
    }
    return null;
  }

  void _toggleVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
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
        autofillHints: const [AutofillHints.password],
        textInputAction: widget.textInputAction,
        onEditingComplete: _onEditingComplete,
        validator: (String? value) => _validate(value, l10n),
        obscureText: passwordVisible,
        decoration: InputDecoration(
          hintText: l10n.input_password_placeholder,
          suffixIcon: IconButton(
            icon: Icon(passwordVisible
                ? Icons.visibility_rounded
                : Icons.visibility_off),
            onPressed: _toggleVisibility,
          ),
          alignLabelWithHint: false,
        ),
      ),
    );
  }
}
