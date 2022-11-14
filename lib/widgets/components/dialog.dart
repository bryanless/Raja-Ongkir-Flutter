part of '../widgets.dart';

class BasicDialog {
  static AlertDialog alert({
    String? title,
    String? content,
    String? dismissLabel,
    void Function()? onDismiss,
    String? confirmLabel,
    void Function()? onConfirm,
  }) {
    return AlertDialog(
      title: title != null ? Text(title) : null,
      content: content != null ? Text(content) : null,
      actions: [
        if (dismissLabel != null)
          TextButton(
            onPressed: onDismiss,
            child: Text(dismissLabel),
          ),
        if (confirmLabel != null)
          TextButton(
            onPressed: onConfirm,
            child: Text(confirmLabel),
          ),
      ],
    );
  }
}
