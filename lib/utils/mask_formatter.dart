import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskFormatter {
  MaskTextInputFormatter hourFormat({String? value}) {
    return MaskTextInputFormatter(
      initialText: value.toString(),
      mask: '##:##',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }
}
