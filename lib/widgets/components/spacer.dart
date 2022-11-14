part of '../widgets.dart';

class SizedSpacer {
  static SizedBox horizontal({double space = 8}) {
    return SizedBox(
      width: space,
    );
  }

  static SizedBox vertical({double space = 8}) {
    return SizedBox(
      height: space,
    );
  }
}
