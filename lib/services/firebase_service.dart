import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/habit.dart';

// Singleton service class to manage all Firebase operations.
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _userId;

  // Safely retrieve 'appId' from the environment.
  final String _appId = (const String.fromEnvironment('__app_id', defaultValue: 'null') != 'null')
      ? const String.fromEnvironment('__app_id')
      : 'default-app-id';

  String? get userId => _userId;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // Authenticates the user with a custom token or anonymously.
  Future<void> signIn() async {
    try {
      if (_auth.currentUser != null) {
        _userId = _auth.currentUser?.uid;
        return;
      }
      
      // Safely retrieve 'initialAuthToken' from the environment.
      final initialAuthToken =
          (const String.fromEnvironment('__initial_auth_token', defaultValue: 'null') != 'null')
              ? const String.fromEnvironment('__initial_auth_token')
              : null;

      if (initialAuthToken != null && initialAuthToken.isNotEmpty) {
        await _auth.signInWithCustomToken(initialAuthToken);
      } else {
        await _auth.signInAnonymously();
      }
      _userId = _auth.currentUser?.uid;
    } catch (e) {
      // A general catch-all block to handle various types of errors.
      print("Authentication error (type: ${e.runtimeType}): $e");
      _userId = null;
    }
  }

  // Registers a new user with email and password.
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _userId = userCredential.user?.uid;
      return userCredential;
    } catch (e) {
      print("Registration error: $e");
      rethrow;
    }
  }

  // Signs in an existing user with email and password.
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _userId = userCredential.user?.uid;
      return userCredential;
    } catch (e) {
      print("Sign-in error: $e");
      rethrow;
    }
  }

  // Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
    _userId = null;
  }

  // Provides a stream to listen to habits in real-time.
  Stream<List<Habit>> streamHabits() {
    if (_userId == null) {
      return Stream.value([]);
    }
    return _db
        .collection('artifacts/$_appId/users/$_userId/habits')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Habit.fromFirestore(doc)).toList());
  }

  // Adds a new habit.
  Future<void> addHabit(Habit habit) async {
    if (_userId == null) return;
    await _db
        .collection('artifacts/$_appId/users/$_userId/habits')
        .add(habit.toMap());
  }

  // Updates an existing habit.
  Future<void> updateHabit(Habit habit) async {
    if (_userId == null || habit.id == null) return;
    await _db
        .collection('artifacts/$_appId/users/$_userId/habits')
        .doc(habit.id)
        .update(habit.toMap());
  }

  // Deletes a habit.
  Future<void> deleteHabit(String id) async {
    if (_userId == null) return;
    await _db
        .collection('artifacts/$_appId/users/$_userId/habits')
        .doc(id)
        .delete();
  }
}
