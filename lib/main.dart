import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todolist/controller/bloc/todo_bloc.dart';
import 'package:todolist/services/database_services.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'services/notification_services.dart';
import 'view/screens/home_screen.dart';

late DatabaseServices _databaseServices;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _databaseServices = DatabaseServices();
  
  tz.initializeTimeZones(); 
  NotificationServices notificationServices = NotificationServices();
  notificationServices.initializeNotifications();

  runApp(
    BlocProvider(
      create: (context) =>
          TodoBloc(_databaseServices)..add(const LoadTodosEvent()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
        
            RepositoryProvider(create: (context) => DatabaseServices()),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}
