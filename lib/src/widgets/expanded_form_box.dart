import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/services.dart';


class CustomAutoSizeText extends StatefulWidget {
  final int? maxLength;
  final int maxLines;
  final String? label;
  final ValueChanged<String> onChanged;
  final String? lablelText;
  final bool enabled;
  final bool iseditable;
  final bool isMandatory;
  final String? initialValue;
  final String? prefixText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(dynamic val) validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapital;
  final bool obscureText;
  final void Function()? onTap;

  const CustomAutoSizeText({
    Key? key,
    this.maxLines = 1,
    this.maxLength,
    this.label,
    required this.onChanged,
    this.enabled = true,
    this.iseditable = false,
    this.isMandatory = false,
    this.suffix,
    this.keyboardType = TextInputType.multiline,
    this.controller,
    required this.validator,
    this.lablelText,
    this.prefixText,
    this.initialValue,
    this.inputFormatters,
    this.textCapital = TextCapitalization.sentences,
    this.obscureText = false,
    this.onTap,
  }) : super(key: key);

  @override
  _CustomAutoSizeTextState createState() => _CustomAutoSizeTextState();
}

class _CustomAutoSizeTextState extends State<CustomAutoSizeText> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizeTextField(
      onTap: widget.onTap,
      obscureText: widget.obscureText,
      minLines: 1,
      maxLines: widget.maxLines,
      controller: _controller,
      style: TextStyles.b2!.copyWith(fontWeight: FontWeight.w400),
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.lablelText,
        prefixText: widget.prefixText,
        suffixIcon: widget.suffix,
        hintText: widget.label,
        hintStyle: TextStyles.b2!.copyWith(color: Theme.of(context).hintColor),
        filled: true,
        fillColor: Theme.of(context).indicatorColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
    );
  }
}
