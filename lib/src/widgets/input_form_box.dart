import 'package:Skillify/src/res/colors/colors.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextForm extends StatefulWidget {
  final int maxLines;
  final int? maxLength;
  final String? label;
  final ValueChanged<String> onChanged;
  final String? lablelText;
  final bool enabled;
  final bool iseditable;
  final bool isMandatory;
  final String? initialValue;
  final String? prefixText;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(dynamic val) validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapital;
  final bool obscureText;
  final bool enableInteractiveSelection;
  final void Function()? onTap;
  const CustomTextForm({
    Key? key,
    this.maxLines = 1,
    this.maxLength,
    this.label,
    required this.onChanged,
    this.enabled = true,
    this.iseditable = false,
    this.isMandatory = false,
    this.suffix,
    this.prefix,
    this.keyboardType = TextInputType.text,
    this.controller,
    required this.validator,
    this.lablelText,
    this.prefixText,
    this.initialValue,
    this.inputFormatters,
    this.textCapital = TextCapitalization.sentences,
    this.obscureText = false,
    this.enableInteractiveSelection = true,
    this.onTap,
  }) : super(key: key);
  @override
  _CustomTextFormWidgetState createState() => _CustomTextFormWidgetState();
}

class _CustomTextFormWidgetState extends State<CustomTextForm> {
//  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    // controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    //  controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
        onTap: widget.onTap,
        autofocus: true,
        obscureText: widget.obscureText,
        initialValue: widget.initialValue,
        textCapitalization: widget.textCapital,
        scrollPadding: EdgeInsets.zero,
        readOnly: widget.iseditable,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        style: TextStyles.b2!.copyWith(fontWeight: FontWeight.w400),
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,

        validator: widget.validator,
        controller: widget.controller,
        onChanged: (content) => widget.onChanged(content),
        decoration: InputDecoration(
            labelText: widget.lablelText,
            prefixText:
                widget.prefixText == null ? null : '${widget.prefixText}:  ',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blackColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixIcon: widget.suffix,
            prefixIcon: widget.prefix,
            hintText: widget.label,
            // filled: true,
            hintStyle:
                TextStyles.l1!.copyWith(color: Theme.of(context).hintColor),
            // fillColor: Color.fromARGB(255, 231, 232, 233),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blackColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blackColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: Space.all()),
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        //  toolbarOptions: ToolbarOptions(),
      );
}
