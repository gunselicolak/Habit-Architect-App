import 'package:flutter/material.dart';
import '../main.dart'; // Habit modelini kullanmak için
import 'add_habit_screen.dart'; // Alışkanlıkları düzenlemek için

class SettingsScreen extends StatelessWidget {
  final List<Habit> habits;
  final Function(Habit) onDeleteHabit;
  final Function(Habit, Habit) onUpdateHabit;
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.habits,
    required this.onDeleteHabit,
    required this.onUpdateHabit,
    required this.themeMode,
    required this.onThemeChanged,
  });
  
  // Alışkanlık silme onayı için bir diyalog penceresi gösterir
  Future<void> _confirmDelete(BuildContext context, Habit habit) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Kullanıcı dışarıya dokunarak kapatamaz
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alışkanlığı Sil'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${habit.habitName} alışkanlığını silmek istediğine emin misin?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Vazgeç', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sil', style: TextStyle(color: Colors.red)),
              onPressed: () {
                onDeleteHabit(habit);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Uygulama Görünümü'),
            _buildThemeSwitcher(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Alışkanlık Yönetimi'),
            _buildHabitManagementList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF555555),
        ),
      ),
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    final isDarkMode = themeMode == ThemeMode.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: isDarkMode ? Colors.white : Colors.amber,
        ),
        title: const Text('Karanlık Mod'),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (bool value) {
            onThemeChanged(value ? ThemeMode.dark : ThemeMode.light);
          },
        ),
      ),
    );
  }

  Widget _buildHabitManagementList(BuildContext context) {
    return habits.isEmpty
        ? Center(
            child: Text(
              'Henüz eklenmiş bir alışkanlığınız yok.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return _buildHabitEditTile(context, habit);
            },
          );
  }

  Widget _buildHabitEditTile(BuildContext context, Habit habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(habit.icon, color: habit.color),
        title: Text(habit.habitName),
        subtitle: Text('${habit.goalValue} ${habit.goalUnit} ${habit.timeframe}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                final updatedHabit = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddHabitScreen(habitToEdit: habit),
                  ),
                );
                if (updatedHabit != null) {
                  onUpdateHabit(habit, updatedHabit);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, habit),
            ),
          ],
        ),
      ),
    );
  }
}
