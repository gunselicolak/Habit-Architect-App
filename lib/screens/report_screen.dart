import 'package:flutter/material.dart';
import '../main.dart'; // Habit modelini kullanmak için import edildi
import '../widgets/progress_card.dart'; // Yeni oluşturduğumuz widget'ı import ediyoruz

class ReportsScreen extends StatelessWidget {
  final List<Habit> habits;

  const ReportsScreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    // Tamamlanan alışkanlık sayısını ve toplam sayısını hesaplayalım
    final completedHabitsCount = habits.where((h) => h.currentProgress >= h.goalValue).length;
    final totalHabitsCount = habits.length;
    
    // overallProgress değişkeninin tipini double olarak belirliyoruz.
    final double overallProgress = totalHabitsCount > 0 ? (completedHabitsCount / totalHabitsCount) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Raporlar'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Genel İlerleme Kartı için yeni widget'ı çağırıyoruz
            ProgressCard(progress: overallProgress),
            const SizedBox(height: 24),
            // Haftalık İlerleme Bölümü
            _buildWeeklyProgressSection(),
            const SizedBox(height: 24),
            // Güncel Seriler Bölümü
            _buildStreaksSection(),
          ],
        ),
      ),
    );
  }

  // Haftalık İlerleme bölümünü oluşturan metot
  Widget _buildWeeklyProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Haftalık İlerleme',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF555555),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          // Bu alana bir grafik widget'ı eklenebilir. Örneğin: `fl_chart`
          child: const Center(
            child: Text(
              'Grafik Alanı (Örn: Haftalık tamamlanma grafiği)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  // Güncel Seriler bölümünü oluşturan metot
  Widget _buildStreaksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Güncel Seriler',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF555555),
          ),
        ),
        const SizedBox(height: 16),
        // Her bir alışkanlık için seri kartı oluşturma
        ...habits.map((habit) => _buildStreakCard(habit)).toList(),
      ],
    );
  }

  // Seri kartını oluşturan metot
  Widget _buildStreakCard(Habit habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            habit.icon,
            size: 32,
            color: habit.color,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              habit.habitName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${habit.streak} Gün',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF007BFF),
            ),
          ),
        ],
      ),
    );
  }
}
