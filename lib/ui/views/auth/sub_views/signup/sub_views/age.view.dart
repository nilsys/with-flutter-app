import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class Age extends StatelessWidget {
  final Function onChange;

  Age({
    @required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Transform.translate(
      offset: Offset(0, -18),
      child: DatePickerWidget(
        firstDate: DateTime(now.year - 120),
        lastDate: DateTime(now.year - 13),
        initialDate: DateTime(now.year - 20),
        dateFormat: "dd-MMMM-yyyy",
        onChange: onChange,
        pickerTheme: DateTimePickerTheme(
          backgroundColor: Colors.transparent,
          itemTextStyle: Theme.of(context).textTheme.bodyText1,
          dividerColor: Colors.white.withAlpha(40),
          showTitle: false,
          titleHeight: 0,
        ),
      ),
    );
  }
}
