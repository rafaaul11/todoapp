import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String? id; // ID dokumen Firestore
  String title;
  String description;
  bool isDone;
  DateTime createdAt;
  String category; // Tambahkan ini

  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    required this.createdAt,
    this.category = 'Uncategorized', // Tambahkan ini dengan nilai default
  });

  // Factory constructor untuk membuat objek Todo dari DocumentSnapshot (Firestore)
  factory Todo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Todo(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isDone: data['isDone'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      category: data['category'] ?? 'Uncategorized', // Tambahkan ini
    );
  }

  // Method untuk mengubah objek Todo menjadi Map (untuk disimpan ke Firestore)
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'createdAt': Timestamp.fromDate(createdAt),
      'category': category, // Tambahkan ini
    };
  }
}
