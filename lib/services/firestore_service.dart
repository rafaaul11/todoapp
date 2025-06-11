import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/todo.dart';

class FirestoreService {
  final CollectionReference _todoCollection = FirebaseFirestore.instance
      .collection('todos');

  // Stream semua todo
  Stream<List<Todo>> getTodos() {
    return _todoCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Todo.fromFirestore(doc)).toList();
        });
  }

  // Update todo
  Future<void> updateTodo(String id, Map<String, dynamic> data) async {
    await _todoCollection.doc(id).update(data);
  }

  // Tambah todo (opsional)
  Future<void> addTodo(Todo todo) async {
    await _todoCollection.add(todo.toFirestore());
  }

  // Hapus todo (opsional)
  Future<void> deleteTodo(String id) async {
    await _todoCollection.doc(id).delete();
  }
}
