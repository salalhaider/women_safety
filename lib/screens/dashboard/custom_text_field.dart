import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final bool isPasswordField;
  final Widget? trailing;
  final String? Function(String?) onValitdate;
  final Function(String?) onSaved;
  final Function(String?)? onChanged;
  final int? maxLines;
  final TextInputType? keyboardType;
  const CustomTextField(
      {Key? key,
      this.label,
      this.hint,
      this.isPasswordField = false,
      this.initialValue,
      this.maxLines = 1,
      required this.onValitdate,
      required this.onSaved,
      this.onChanged,
      this.keyboardType = TextInputType.text,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isObscure = isPasswordField;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 5,
        ),
        StatefulBuilder(builder: (context, setFieldState) {
          return TextFormField(
            maxLines: maxLines,
            obscureText: isObscure,
            initialValue: initialValue ?? '',
            keyboardType: keyboardType,
            decoration: InputDecoration(
                hintText: hint,
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    gapPadding: 50),
                suffixIcon: trailing ??
                    IconButton(
                        icon: isPasswordField
                            ? Icon(isObscure
                                ? Icons.visibility
                                : Icons.visibility_off)
                            : const SizedBox(
                                width: 0,
                              ),
                        onPressed: () {
                          setFieldState(() {
                            isObscure = !isObscure;
                          });
                        })),
            onChanged: onChanged,
            onSaved: onSaved,
            validator: onValitdate,
          );
        }),
      ],
    );
  }
}
