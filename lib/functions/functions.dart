import 'package:flutter/material.dart';
import 'package:todolist/view/screens/add_task.dart';
import 'package:todolist/view/screens/edit_task.dart';

import '../model/task.dart';

/////////////////////// Bottom Sheet //////////////////////////////
showBtmSheet(context, String flag, {Task? task}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        if (flag == 'Add') {
          return const AddTask();
        } else {
          return EditTask(
            task: task!,
          );
        }
      });
}


/////////////////////// Convert Date to String //////////////////////////////

String dateTimeToString(DateTime dateTime) {
  return '${dateTime.year.toString().padLeft(4, '0')}-'
      '${dateTime.month.toString().padLeft(2, '0')}-'
      '${dateTime.day.toString().padLeft(2, '0')} '
      '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')}:'
      '${dateTime.second.toString().padLeft(2, '0')}';
}

String convertDateToString(DateTime date) {
  return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
}

String formatTimeOfDay(TimeOfDay time, BuildContext context) {
  return time.format(context);
}


/////////////////////// Select Date //////////////////////////////

Future<String> selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null) {
    return convertDateToString(picked);
  }
  return '';
}

/////////////////////// Select Time //////////////////////////////


Future<String> selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (picked != null) {
    return formatTimeOfDay(picked, context);
  }
  return formatTimeOfDay(TimeOfDay.now(), context);
}
