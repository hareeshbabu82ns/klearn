import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:klearn/model/app_state.dart';
import 'package:klearn/screens/dashboard_page.dart';
import 'package:klearn/screens/arithmetics_page.dart';

void main() => runApp(
      ProviderScope(child: MyApp()),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kids Learning',
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.blue[700],
              displayColor: Colors.grey[600],
            ),
        primaryColor: Colors.green[500],
        textSelectionHandleColor: Colors.purple[500],
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => DashboardPage()),
        GetPage(name: '/arithmetics', page: () => ArithmeticsPage()),
      ],
    );
  }
}
