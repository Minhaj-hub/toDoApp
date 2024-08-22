import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todolist/services/notification_services.dart';
import 'package:uuid/uuid.dart';

import '../../controller/bloc/todo_bloc.dart';
import '../../functions/functions.dart';
import '../../utils/colors.dart';
import '../widgets/custom_widgets.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String? _selectedPriority;

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
                  'Add Task',
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
                        final title = _titleController.text.trim();
                        final desc = _descController.text.trim();
                        final priority = _selectedPriority!;
                        final dueDate = _dateController.text;
                        final dueTime = _timeController.text;

                        BlocProvider.of<TodoBloc>(context).add(
                          CreateNewTodoEvent(
                              id: uuid.v4(),
                              title: title,
                              description: desc,
                              priority: priority,
                              dueDate: dueDate,
                              dueTime: dueTime,
                              isCompleted: false),
                        );
                        NotificationServices notificationServices =
                            NotificationServices();
                        notificationServices.scheduleReminder(
                            title, desc, priority, dueDate, dueTime);

                        Navigator.pop(context);
                      }

                      setState(() {});
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ))),
          ],
        ));
  }
}
