import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../controller/bloc/todo_bloc.dart';
import '../../functions/functions.dart';
import '../../model/task.dart';
import '../../utils/colors.dart';
import '../widgets/custom_widgets.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key,required this.task});
  final Task task;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late final TextEditingController _titleController = TextEditingController(text: widget.task.title);
  late final TextEditingController _descController = TextEditingController(text: widget.task.description);
  late final TextEditingController _dateController = TextEditingController(text: widget.task.dueDate);
  late final TextEditingController _timeController = TextEditingController(text: widget.task.dueTime);
  late String? _selectedPriority = widget.task.priority;

  bool remindMe = true;

  String warningMsg = '';

  Widget space = const CSBox(
    height: 15,
  );

  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Edit Task',
                  style: TextStyle(fontSize: 17.sp),
                )
              ],
            ),
            const Spacer(),
            // space,
            CRow(
              widget1: CTextFormField(
                controller: _titleController,
                labelTxt: 'Title',
              ),
            ),
            // space,
            const Spacer(),
            CRow(
              widget1: CTextFormField(
                controller: _descController,
                labelTxt: 'Description',
              ),
            ),
            // space,
            const Spacer(),
            const CRow(
              widget1: CText(
                txt: 'Priority',
                weight: FontWeight.bold,
              ),
            ),
            CSBox(
              width: screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Text('Priority Level'),
                  ChoiceChip(
                    label: const Text('High'),
                    selected: _selectedPriority == 'High',
                    selectedColor: Colors.redAccent,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedPriority = selected ? 'High' : null;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Medium'),
                    selected: _selectedPriority == 'Medium',
                    selectedColor: Colors.orangeAccent,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedPriority = selected ? 'Medium' : null;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Low'),
                    selected: _selectedPriority == 'Low',
                    selectedColor: Colors.greenAccent,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedPriority = selected ? 'Low' : null;
                      });
                    },
                  ),
                ],
              ),
            ),
            // space,
            const Spacer(),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    _dateController.text = await selectDate(context);
                    setState(() {});
                  },
                  child: SizedBox(
                    height: 35.h,
                    width: 35.w,
                    child: const CTextFormField(
                      enabled: false,
                      prefixIcon: Icon(
                        Icons.calendar_month_outlined,
                        color: blueClr,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  flex: 3,
                  child: CTextFormField(
                    controller: _dateController,
                    enabled: false,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  flex: 2,
                  child: CTextFormField(
                    controller: _timeController,
                    enabled: false,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                InkWell(
                  onTap: () async {
                    _timeController.text = await selectTime(context);

                    setState(() {});
                  },
                  child: SizedBox(
                    height: 35.h,
                    width: 35.w,
                    child: const CTextFormField(
                      enabled: false,
                      prefixIcon: Icon(
                        Icons.access_time,
                        color: blueClr,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          
            const Spacer(),
            CText(
              txt: warningMsg,
              clr: redClr,
            ),
            SizedBox(
                width: screenWidth,
                height: screenHeight / 20,
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.cyan)),
                    onPressed: () {
                      if (_titleController.text.isEmpty ||
                          _titleController.text == '') {
                        warningMsg = 'Add Title';
                      } else if (_selectedPriority == null) {
                        warningMsg = 'Select Priority';
                      } else if (_dateController.text.isEmpty ||
                          _dateController.text == '') {
                        warningMsg = 'Select Due Date';
                      } else {
                        BlocProvider.of<TodoBloc>(context).add(
                          UpdateTodoEvent(
                              id: widget.task.id,
                              title: _titleController.text.trim(),
                              description: _descController.text.trim(),
                              priority: _selectedPriority!,
                              dueDate: _dateController.text,
                              dueTime: _timeController.text,
                              isCompleted: false),
                        );
                        Navigator.pop(context);
                      }

                      setState(() {});

                     
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ))),
          ],
        ));
  }
}
