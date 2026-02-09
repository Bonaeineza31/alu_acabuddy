// import 'package:flutter/material.dart';
// import '../screens/dashboard/dashboard_screen.dart';
// import '../screens/assignments/assignment_screen.dart';
// import '../screens/schedule/schedule_screen.dart';
// import '../utils/app_colors.dart';

// /// Main navigation widget with bottom navigation bar
// class MainNavigation extends StatefulWidget {
//   const MainNavigation({super.key});

//   @override
//   State<MainNavigation> createState() => _MainNavigationState();
// }

// class _MainNavigationState extends State<MainNavigation> {
//   int _currentIndex = 0;

//   // List of screens
//   final List<Widget> _screens = [
//     const DashboardScreen(),
//     const AssignmentsScreen(),
//     const ScheduleScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         selectedItemColor: AppColors.primary,
//         unselectedItemColor: AppColors.textSecondary,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.assignment),
//             label: 'Tasks',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'Schedule',
//           ),
//         ],
//       ),
//     );
//   }
// }