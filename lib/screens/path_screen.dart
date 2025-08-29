import 'package:flutter/material.dart';
import '../main.dart'; // Habit modelini kullanmak için import edildi

// Yolculuk adımlarını temsil eden bir model
class JourneyMilestone {
  final String title;
  final String description;
  final bool isCompleted;
  final IconData icon;

  JourneyMilestone({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.icon,
  });
}

class JourneyScreen extends StatelessWidget {
  final List<Habit> habits;

  const JourneyScreen({super.key, required this.habits});

  // Örnek yolculuk verilerini oluşturma
  List<JourneyMilestone> _getJourneyMilestones() {
    // Bu mantığı, uygulamanızın gerçek verilerine göre düzenleyebilirsiniz.
    // Örnek olarak, tamamlanan toplam alışkanlık sayısına göre adımları belirliyoruz.
    final completedHabitsCount = habits.where((h) => h.currentProgress >= h.goalValue).length;
    
    return [
      JourneyMilestone(
        title: 'Başlangıç',
        description: 'İlk alışkanlığını tamamla',
        isCompleted: completedHabitsCount >= 1,
        icon: Icons.flag,
      ),
      JourneyMilestone(
        title: 'Süreklilik',
        description: '3 farklı alışkanlık tamamla',
        isCompleted: completedHabitsCount >= 3,
        icon: Icons.check_circle_outline,
      ),
      JourneyMilestone(
        title: 'Uzman',
        description: 'En az 5 alışkanlığı 7 gün boyunca tamamla',
        isCompleted: habits.where((h) => h.streak >= 7).length >= 5,
        icon: Icons.star_border,
      ),
      JourneyMilestone(
        title: 'Alışkanlık Mimarı',
        description: 'Tüm alışkanlıklarını 30 gün boyunca sürdür',
        isCompleted: habits.where((h) => h.streak >= 30).length == habits.length && habits.isNotEmpty,
        icon: Icons.architecture,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final milestones = _getJourneyMilestones();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yolculuk'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        itemCount: milestones.length,
        itemBuilder: (context, index) {
          final milestone = milestones[index];
          final bool isLast = index == milestones.length - 1;
          
          return _buildJourneyStep(milestone, isLast);
        },
      ),
    );
  }

  // Yolculuk adımını oluşturan widget
  Widget _buildJourneyStep(JourneyMilestone milestone, bool isLast) {
    final Color pathColor = milestone.isCompleted ? const Color(0xFF007BFF) : Colors.grey[300]!;
    final Color iconColor = milestone.isCompleted ? Colors.white : Colors.grey[600]!;
    final Color iconBackgroundColor = milestone.isCompleted ? const Color(0xFF007BFF) : Colors.grey[200]!;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sol taraftaki yol ve ikon kısmı
          SizedBox(
            width: 48,
            child: Column(
              children: [
                // Adım ikonu
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(milestone.icon, color: iconColor),
                ),
                // Adımları birleştiren çizgi
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 4,
                      color: pathColor,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Sağ taraftaki içerik kartı
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    milestone.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
