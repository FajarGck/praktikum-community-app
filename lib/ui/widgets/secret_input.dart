import 'package:flutter/material.dart';
import 'package:tugas_akhir/ui/widgets/standar_input.dart';

class SecretInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;

  const SecretInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
  });

  @override
  State<SecretInput> createState() => _SecretInputState();
}

class _SecretInputState extends State<SecretInput> {
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    return StandarInput(
      label: widget.label,
      controller: widget.controller,
      hint: widget.hint,
      obscureText: !_visible,
      validator: widget.validator,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            _visible = !_visible;
          });
        },
        child: Icon(_visible ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }
}
