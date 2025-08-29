// lib/models/habit.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Alışkanlık tiplerini belirlemek için Enum
enum HabitType {
  countBased, // Sayaç bazlı (örn: su içme)
  yesNo, // Evet/Hayır bazlı (örn: egzersiz)
  duration, // Süre bazlı (örn: kitap okuma)
}

// Alışkanlık verileri için model sınıfı
class Habit {
  String? id;
  String name;
  HabitType type;
  int goal; // Hedef değeri (örn: 8 bardak)
  int currentProgress; // Mevcut ilerleme (örn: 4 bardak)
  int streak; // Seri (üst üste tamamlanan gün sayısı)
  DateTime? lastCompleted; // En son tamamlandığı tarih
  IconData icon; // Alışkanlık ikonu
  Color color; // Alışkanlık rengi
  DateTime createdAt; // Oluşturulma tarihi

  Habit({
    this.id,
    required this.name,
    required this.type,
    required this.goal,
    required this.currentProgress,
    required this.streak,
    this.lastCompleted,
    required this.icon,
    required this.color,
    required this.createdAt,
  });

  // Habit nesnesini Firestore için Map'e dönüştürür
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.toString().split('.').last, // Enum'u string olarak sakla
      'goal': goal,
      'currentProgress': currentProgress,
      'streak': streak,
      'lastCompleted': lastCompleted?.toIso8601String(),
      'iconCodePoint': icon.codePoint, // İkonu codePoint olarak sakla
      'colorValue': color.value, // Rengi int olarak sakla
      'createdAt': createdAt.toIso8601String(), // Hata düzeltildi
    };
  }

  // Firestore DocumentSnapshot'tan Habit nesnesi oluşturur
  factory Habit.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Habit(
      id: doc.id,
      name: data['name'] ?? '',
      type: HabitType.values.firstWhere(
        (e) => e.toString().split('.').last == (data['type'] ?? 'yesNo'),
        orElse: () => HabitType.yesNo,
      ),
      goal: data['goal'] ?? 0,
      currentProgress: data['currentProgress'] ?? 0,
      streak: data['streak'] ?? 0,
      lastCompleted: data['lastCompleted'] != null
          ? DateTime.parse(data['lastCompleted'])
          : null,
      icon: IconData(data['iconCodePoint'] ?? Icons.check.codePoint,
          fontFamily: 'MaterialIcons'),
      color: Color(data['colorValue'] ?? Colors.blue.value),
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
    );
  }
}
