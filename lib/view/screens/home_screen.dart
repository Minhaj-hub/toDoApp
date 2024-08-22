import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todolist/utils/colors.dart';

import '../../controller/bloc/todo_bloc.dart';
import '../../functions/functions.dart';
import '../widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  String selectedValue = "All";
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _taskNameController = TextEditingController();

  final List<String> dropdownItems = [
    "All",
    "High",
    "Medium",
    "Low",
  ];

  get child => null;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          padding: EdgeInsets.all(15.w),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                // color: const Color.fromARGB(255, 219, 229, 246),
                child: Column(
                  children: [
                    Row(
                      children: [
                      
                        SizedBox(
                          height: 35.h,
                          width: 120.w,
                          child: DropdownButtonFormField<String>(
                            value: selectedValue,
                            elevation: 16,
                            style: const TextStyle(color: Colors.blue),
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 7.w),
                                border: const OutlineInputBorder()),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValue = newValue!;
                              });
                              BlocProvider.of<TodoBloc>(context).add(
                                  LoadTodosEvent(
                                      keyword: selectedValue,
                                      flag: 'Priority'));
                            },
                            items: dropdownItems
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),

                        SizedBox(
                          width: 20.w,
                        ),
                        SizedBox(
                          height: 35.h,
                          width: 120.w,
                          child: CTextFormField(
                            controller: _dateController,
                            enabled: false,
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        InkWell(
                          onTap: () async {
                            _dateController.text = await selectDate(context);

                            setState(() {});
                            BlocProvider.of<TodoBloc>(context).add(
                                LoadTodosEvent(
                                    keyword: _dateController.text,
                                    flag: 'DueDate'));
                          },
                          child: SizedBox(
                            height: 30.h,
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
                      ],
                    ),
                    SizedBox(
                      height: 15.w,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 35.h,
                          width: 260.w,
                          child: CTextFormField(
                            controller: _taskNameController,
                            hintTxt: 'Search by Task Name',
                            hintFontSize: 12.sp,
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        InkWell(
                          onTap: () async {
                            BlocProvider.of<TodoBloc>(context).add(
                                LoadTodosEvent(
                                    keyword: _taskNameController.text,
                                    flag: 'TaskName'));
                          },
                          child: SizedBox(
                            height: 30.h,
                            width: 35.w,
                            child: const CTextFormField(
                              enabled: false,
                              prefixIcon: Icon(
                                Icons.search,
                                color: blueClr,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    CText(
                      txt: 'Tasks',
                      size: 20.sp,
                      weight: FontWeight.bold,
                    )
                  ],
                ),
              ),
              // const Spacer(),
              SizedBox(
                height: screenHeight * 0.70,
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state is TodoLoadedState) {
                              final reversedTodos = state.todos.reversed.toList();

                      if (reversedTodos.isNotEmpty) {
                        return ListView.builder(
                            itemCount: reversedTodos.length,
                            itemBuilder: (context, index) {
                              final todo = reversedTodos[index];
                              return TaskListTile(
                                id: todo.id,
                                title: todo.title,
                                description: todo.description ?? '',
                                priority: todo.priority,
                                dueDate: todo.dueDate,
                                dueTime: todo.dueTime,
                                isCompleted: todo.isCompleted,
                              );
                            });
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                                height: 150, 'assets/images/no_task.png'),
                            SizedBox(
                              height: 20.h,
                            ),
                            CText(
                              txt: 'You don\'t have any Tasks',
                              size: 15.sp,
                            )
                          ],
                        );
                      }
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBtmSheet(context, 'Add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
