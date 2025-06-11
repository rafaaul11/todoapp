import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/firestore_service.dart';
import 'package:todo_app/screens/add_todo_screen.dart';
import 'package:todo_app/screens/home_screen.dart'; // Navigasi Bottom Bar
import 'package:todo_app/screens/calendar_screen.dart'; // Placeholder
import 'package:todo_app/screens/all_tasks_screen.dart'; // Placeholder
import 'package:todo_app/screens/settings_screen.dart'; // Placeholder

class CategoryTasksScreen extends StatefulWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;

  const CategoryTasksScreen({
    Key? key,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
  }) : super(key: key);

  @override
  State<CategoryTasksScreen> createState() => _CategoryTasksScreenState();
}

class _CategoryTasksScreenState extends State<CategoryTasksScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 0; // Atur default untuk Bottom Nav, bisa disesuaikan

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Hindari navigasi ulang ke layar yang sama
    setState(() {
      _selectedIndex = index;
    });
    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = const HomeScreen();
        break;
      case 1:
        nextScreen = const CalendarScreen();
        break;
      case 2:
        nextScreen = const AllTasksScreen();
        break;
      case 3:
        nextScreen = const SettingsScreen();
        break;
      default:
        return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8EE), // Background krem muda
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8EE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
        title: Text(
          'All tasks', // Sesuai desain, judulnya masih 'All tasks'
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4C4A3A),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Ikon dan Teks Kategori (Personal)
            Column(
              children: [
                Icon(
                  widget.categoryIcon, // Ikon dari parameter
                  size: 60,
                  color: widget.categoryColor, // Warna dari parameter
                ),
                const SizedBox(height: 8),
                Text(
                  widget.categoryName, // Nama kategori dari parameter
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4C4A3A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Daftar Tugas Berdasarkan Kategori
            Expanded(
              child: StreamBuilder<List<Todo>>(
                stream: _firestoreService.getTodos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada tugas untuk kategori "${widget.categoryName}".',
                      ),
                    );
                  }

                  List<Todo> allTodos = snapshot.data!;
                  // Pastikan field 'category' ada di model Todo dan Firestore
                  List<Todo> filteredTodos = allTodos.where((todo) {
                    return todo.category == widget.categoryName;
                  }).toList();

                  if (filteredTodos.isEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada tugas untuk kategori "${widget.categoryName}".',
                      ),
                    );
                  }

                  filteredTodos.sort(
                    (a, b) => b.createdAt.compareTo(a.createdAt),
                  );

                  return ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      Todo todo = filteredTodos[index];
                      Color leftBoxColor = todo.isDone
                          ? Colors.grey
                          : widget.categoryColor;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: AllTaskCard(
                          todo: todo,
                          leftBoxColor: leftBoxColor,
                          onToggleDone: (bool? newValue) {
                            if (newValue != null) {
                              _firestoreService.updateTodo(todo.id!, {
                                'isDone': newValue,
                              });
                            }
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTodoScreen(todo: todo),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description), // Ikon untuk All Tasks
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF386392), // Warna item terpilih
        unselectedItemColor: Colors.grey, // Warna item tidak terpilih
        backgroundColor: Colors.white, // Background putih sesuai desain
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Penting agar item tidak bergeser
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(),
      ),
    );
  }
}
