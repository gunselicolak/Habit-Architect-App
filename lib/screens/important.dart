// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import './screens/add_habit_screen.dart';
// import './screens/report_screen.dart';
// import './screens/path_screen.dart';
// import './screens/setting_screen.dart';
// import './widgets/progress_card.dart';
// import './screens/login_screen.dart';
// import './screens/profil_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeDateFormatting('tr_TR', null);
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   ThemeMode _themeMode = ThemeMode.light;

//   void _setThemeMode(ThemeMode mode) {
//     setState(() {
//       _themeMode = mode;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Habit Architect',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: const Color(0xFFF0F2F5),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           titleTextStyle: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         cardColor: Colors.white,
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: const Color(0xFF121212),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Color(0xFF1E1E1E),
//           elevation: 0,
//           titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         cardColor: const Color(0xFF1E1E1E),
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Colors.white),
//           bodyMedium: TextStyle(color: Colors.white70),
//           titleMedium: TextStyle(color: Colors.white),
//         ),
//         bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//           backgroundColor: Color(0xFF1E1E1E),
//           unselectedItemColor: Colors.grey,
//           selectedItemColor: Color(0xFF00BFFF),
//         ),
//         iconTheme: const IconThemeData(
//           color: Colors.white70,
//         ),
//         listTileTheme: const ListTileThemeData(
//           textColor: Colors.white,
//         ),
//       ),
//       themeMode: _themeMode, // Tema durumu artık buradan yönetiliyor
//       home: MainWrapper(
//         themeMode: _themeMode,
//         onThemeChanged: _setThemeMode,
//       ),
//     );
//   }
// }

// // Alışkanlık verilerini tutmak için model sınıfı
// class Habit {
//   final String habitName;
//   final String timeframe;
//   final IconData icon;
//   final Color color;
//   int goalValue;
//   String goalUnit;
//   int currentProgress;
//   int streak;
//   DateTime? lastCompletedDate;

//   Habit({
//     required this.habitName,
//     required this.goalValue,
//     required this.goalUnit,
//     required this.timeframe,
//     required this.icon,
//     required this.color,
//     this.currentProgress = 0,
//     this.streak = 0,
//     this.lastCompletedDate,
//   });
// }

// class MainWrapper extends StatefulWidget {
//   final ThemeMode themeMode;
//   final Function(ThemeMode) onThemeChanged;

//   const MainWrapper({
//     super.key,
//     required this.themeMode,
//     required this.onThemeChanged,
//   });

//   @override
//   State<MainWrapper> createState() => _MainWrapperState();
// }

// class _MainWrapperState extends State<MainWrapper> {
//   int _selectedIndex = 0;
//   bool _isLoggedIn = false;
//   String _currentUsername = "";

//   List<Habit> _habits = [
//     Habit(
//       habitName: 'Su İçme',
//       goalValue: 8,
//       goalUnit: 'Bardak',
//       timeframe: 'Günlük',
//       icon: Icons.water_drop_outlined,
//       color: Colors.blue,
//       currentProgress: 4,
//       streak: 25,
//     ),
//     Habit(
//       habitName: 'Egzersiz',
//       goalValue: 30,
//       goalUnit: 'Dakika',
//       timeframe: 'Günlük',
//       icon: Icons.directions_run_outlined,
//       color: Colors.orange,
//       currentProgress: 30,
//       streak: 12,
//       lastCompletedDate: DateTime.now(),
//     ),
//     Habit(
//       habitName: 'Kitap Oku',
//       goalValue: 30,
//       goalUnit: 'Sayfa',
//       timeframe: 'Günlük',
//       icon: Icons.book_outlined,
//       color: Colors.purple,
//       currentProgress: 15,
//       streak: 7,
//     ),
//   ];

//   void _handleLogin(String username) {
//     setState(() {
//       _isLoggedIn = true;
//       _currentUsername = username;
//       _selectedIndex = 4;
//     });
//   }

//   void _handleLogout() {
//     setState(() {
//       _isLoggedIn = false;
//       _currentUsername = "";
//       _selectedIndex = 0;
//     });
//   }

//   void _onItemTapped(int index) {
//     if (index == 4 && !_isLoggedIn) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen(onLogin: _handleLogin)),
//       );
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   void _addHabit(Habit newHabit) {
//     setState(() {
//       _habits.add(newHabit);
//     });
//   }
  
//   void _deleteHabit(Habit habitToDelete) {
//     setState(() {
//       _habits.remove(habitToDelete);
//     });
//   }

//   void _updateHabit(Habit oldHabit, Habit newHabit) {
//     setState(() {
//       final index = _habits.indexOf(oldHabit);
//       if (index != -1) {
//         _habits[index] = newHabit;
//       }
//     });
//   }

//   void _incrementHabitProgress(Habit habit) {
//     setState(() {
//       if (habit.currentProgress < habit.goalValue) {
//         habit.currentProgress++;
//       }

//       if (habit.currentProgress >= habit.goalValue) {
//         if (habit.lastCompletedDate == null || !isSameDay(habit.lastCompletedDate!, DateTime.now())) {
//           habit.streak++;
//           habit.lastCompletedDate = DateTime.now();
//         }
//       }
//     });
//   }
  
//   bool isSameDay(DateTime a, DateTime b) {
//     return a.year == b.year && a.month == b.month && a.day == b.day;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> pages = [
//       HomeScreen(
//         habits: _habits,
//         onAddHabit: _addHabit,
//         onIncrementProgress: _incrementHabitProgress,
//       ),
//       ReportsScreen(habits: _habits),
//       JourneyScreen(habits: _habits),
//       SettingsScreen(
//         habits: _habits,
//         onDeleteHabit: _deleteHabit,
//         onUpdateHabit: _updateHabit,
//         themeMode: widget.themeMode, // Üst widget'tan alınan tema modunu kullan
//         onThemeChanged: widget.onThemeChanged, // Üst widget'tan alınan callback'i kullan
//       ),
//       _isLoggedIn
//           ? ProfileScreen(username: _currentUsername, onLogout: _handleLogout)
//           : const SizedBox(),
//     ];

//     return Scaffold(
//       body: pages[_selectedIndex],
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       showUnselectedLabels: true,
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Ana Ekran',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.bar_chart),
//           label: 'Raporlar',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.route),
//           label: 'Yolculuk',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.settings),
//           label: 'Ayarlar',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Profil',
//         ),
//       ],
//       currentIndex: _selectedIndex,
//       onTap: _onItemTapped,
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   final List<Habit> habits;
//   final Function(Habit) onAddHabit;
//   final Function(Habit) onIncrementProgress;

//   const HomeScreen({
//     super.key,
//     required this.habits,
//     required this.onAddHabit,
//     required this.onIncrementProgress,
//   });

//   String _getTodayDate() {
//     final now = DateTime.now();
//     final formatter = DateFormat('d MMMM yyyy', 'tr_TR');
//     return formatter.format(now);
//   }

//   void _navigateToAddNewHabitScreen(BuildContext context) async {
//     final newHabit = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const AddHabitScreen()),
//     );

//     if (newHabit != null) {
//       onAddHabit(newHabit);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final completedHabits = habits.where((h) => h.currentProgress >= h.goalValue).length;
//     final totalHabits = habits.length;
//     final double progressPercentage = totalHabits > 0 ? (completedHabits / totalHabits) : 0.0;
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_getTodayDate()),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             ProgressCard(progress: progressPercentage),
//             const SizedBox(height: 24.0),
//             _buildHabitsSection(context),
//             const SizedBox(height: 16.0),
//             _buildAddHabitButton(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHabitsSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Bugünkü Alışkanlıklar',
//           style: TextStyle(
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).textTheme.bodyLarge?.color,
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         ...habits.map((habit) => _buildHabitItem(context: context, habit: habit)).toList(),
//       ],
//     );
//   }
  
//   Widget _buildHabitItem({required BuildContext context, required Habit habit}) {
//     bool isCompleted = habit.currentProgress >= habit.goalValue;
//     final theme = Theme.of(context);
//     final cardColor = theme.cardColor;
//     final textColor = theme.textTheme.bodyLarge?.color;
//     final subtitleColor = theme.textTheme.bodyMedium?.color;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12.0),
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(12.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         children: <Widget>[
//           Icon(
//             habit.icon,
//             size: 32.0,
//             color: isCompleted ? Colors.green : habit.color,
//           ),
//           const SizedBox(width: 16.0),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   habit.habitName,
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.w500,
//                     color: textColor,
//                   ),
//                 ),
//                 Text(
//                   '${habit.currentProgress}/${habit.goalValue} ${habit.goalUnit}',
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     color: subtitleColor,
//                   ),
//                 ),
//                 Text(
//                   'Streak: ${habit.streak} Gün',
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     color: subtitleColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: Icon(
//               isCompleted ? Icons.check_circle : Icons.add_circle,
//               size: 32.0,
//               color: isCompleted ? Colors.green : habit.color,
//             ),
//             onPressed: () {
//               onIncrementProgress(habit);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAddHabitButton(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: const Color(0xFFE9F5FF),
//         borderRadius: BorderRadius.circular(12.0),
//         border: Border.all(
//           color: const Color(0xFF007BFF),
//           style: BorderStyle.solid,
//           width: 2.0,
//         ),
//       ),
//       child: TextButton.icon(
//         onPressed: () => _navigateToAddNewHabitScreen(context),
//         icon: const Icon(Icons.add, color: Color(0xFF007BFF)),
//         label: const Text(
//           'Yeni Alışkanlık Ekle',
//           style: TextStyle(
//             color: Color(0xFF007BFF),
//             fontSize: 16.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         style: TextButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 16.0),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//         ),
//       ),
//     );
//   }
// }
