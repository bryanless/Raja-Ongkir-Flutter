part of 'widgets.dart';

class TextFields {
  static TextFormField outlined({
    String? initialValue,
    String? labelText,
    String? hintText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    bool autofocus = false,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    AutovalidateMode? autovalidateMode,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      keyboardType: keyboardType,
      autofocus: autofocus,
      onSaved: onSaved,
      validator: validator,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
    );
  }

  static DropdownButtonFormField dropdown({
    required List<String> optionValues,
    List<dynamic>? options,
    String? value,
    String? hint,
    String? disabledHint,
    void Function(dynamic)? onChanged,
    String? labelText,
    IconData? prefixIcon,
    Function(dynamic)? onSaved,
    String? Function(dynamic)? validator,
    AutovalidateMode? autovalidateMode,
  }) {
    Map<String, dynamic> items =
        Map.fromIterables(optionValues, options ?? optionValues);

    return DropdownButtonFormField(
      items: items.entries
          .map((item) => DropdownMenuItem(
                value: item.value,
                child: Text(item.key),
              ))
          .toList(),
      value: value,
      hint: hint != null ? Text(hint) : null,
      disabledHint: disabledHint != null ? Text(disabledHint) : null,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      onSaved: onSaved,
      validator: validator,
      autovalidateMode: autovalidateMode,
    );
  }
}
