import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todolist/functions/functions.dart';
import 'package:todolist/model/task.dart';
import 'package:todolist/utils/colors.dart';

import '../../controller/bloc/todo_bloc.dart';
import 'dialog.dart';

class CRow extends StatelessWidget {
  const CRow({
    super.key,
    this.widget1,
    this.widget2,
    this.flex1 = 1,
  });

  final Widget? widget1, widget2;
  final int flex1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: flex1, child: widget1 ?? const SizedBox()),
      ],
    );
  }
}

class CText extends StatelessWidget {
  const CText(
      {super.key,
      required this.txt,
      this.size,
      this.weight,
      this.clr,
      this.fontFamily});

  final String txt;
  final double? size;
  final FontWeight? weight;
  final Color? clr;

  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          color: clr,
          fontFamily: fontFamily),
    );
  }
}

class CTextFormField extends StatelessWidget {
  const CTextFormField(
      {super.key,
      this.labelTxt,
      this.hintTxt,
      this.hintFontSize,
      this.msg,
      this.prefixIcon,
      this.enabled,
      this.keyboardType,
      this.controller,
      this.onChanged,
      this.focusNode});

  final String? labelTxt, hintTxt, msg;
  final double? hintFontSize;
  final Widget? prefixIcon;
  final bool? enabled;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      maxLines: null,
      keyboardType: keyboardType,
      focusNode: focusNode,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return msg;
        } else {
          return null;
        }
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        labelText: labelTxt,
        hintText: hintTxt,
        hintStyle: TextStyle(fontSize: hintFontSize),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        prefixIcon: prefixIcon,
        suffixIconColor: Colors.blue,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class CSBox extends StatelessWidget {
  const CSBox({super.key, this.height, this.width, this.child});

  final double? height, width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height?.h,
      width: width?.w,
      child: child,
    );
  }
}

class TaskListTile extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String dueDate;
  final String dueTime;

  final bool isCompleted;

  const TaskListTile({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.dueTime,
    this.isCompleted = false,
  });

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  late bool isCompleted = widget.isCompleted;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: SizedBox(
          width: 30,
          child: Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                fillColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return greenClr; // Background color when checked
                    }
                    return whiteClr; // Background color when unchecked
                  },
                ),
              ),
            ),
            child: Checkbox(
                // checkColor: greenClr,

                value: isCompleted,
                onChanged: (value) {
                  setState(() {
                    isCompleted = value!;
                  });
                }),
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            decoration: widget.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              widget.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: greyClr[600],
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.dueDate),
                Text(widget.dueTime),
                Container(
                  width: 15, // Width of the round indicator
                  height: 15, // Height of the round indicator
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Makes the container round
                    color: widget.priority == 'High'
                        ? redClr
                        : widget.priority == 'Medium'
                            ? Colors.yellow
                            : greenClr, // Background color of the indicator
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: SizedBox(
          width: 20,
          child: PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 1) {
                Task task = Task(
                    id: widget.id,
                    title: widget.title,
                    description: widget.description,
                    priority: widget.priority,
                    dueDate: widget.dueDate,
                    dueTime: widget.dueTime,
                    isCompleted: isCompleted);
                showBtmSheet(context, 'Edit', task: task);
              } else if (value == 2) {
                void dlt() {
                  BlocProvider.of<TodoBloc>(context)
                      .add(DeleteTodoEvent(todoId: widget.id));
                }

                showPopDialog(
                    context,
                    'Confirm Deletation',
                    'Are you sure you want to delete this Task?',
                    'No',
                    'Yes',
                    dlt);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: blueClr),
                    SizedBox(width: 8.w),
                    const Text("Edit"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: redClr),
                    SizedBox(width: 8.w),
                    const Text("Delete"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
