import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/firestore_service.dart';
import 'package:todo_app/screens/add_todo_screen.dart'; // Untuk edit tugas
import 'package:todo_app/screens/home_screen.dart'; // Navigasi Bottom Bar
import 'package:todo_app/screens/calendar_screen.dart'; // Placeholder
import 'package:todo_app/screens/settings_screen.dart'; // Placeholder

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 2; // Index 2 untuk 'All tasks'

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const CalendarScreen()),
      );
    } else if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8EE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'All tasks',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4C4A3A),
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Todo>>(
        stream: _firestoreService.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada tugas sama sekali.'));
          }

          List<Todo> allTodos = snapshot.data!;
          List<Todo> completedTodos = allTodos
              .where((todo) => todo.isDone)
              .toList();
          List<Todo> pendingTodos = allTodos
              .where((todo) => !todo.isDone)
              .toList();
          completedTodos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          pendingTodos.sort((a, b) => a.createdAt.compareTo(b.createdAt));

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (completedTodos.isNotEmpty) ...[
                  Text(
                    'Boom! Done!',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4C4A3A),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: completedTodos.length,
                    itemBuilder: (context, index) {
                      Todo todo = completedTodos[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: AllTaskCard(
                          todo: todo,
                          leftBoxColor: const Color(0xFFE48D2E),
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
                  ),
                  const SizedBox(height: 30),
                ],
                if (pendingTodos.isNotEmpty) ...[
                  Text(
                    'Let\'s Do This!',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4C4A3A),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pendingTodos.length,
                    itemBuilder: (context, index) {
                      Todo todo = pendingTodos[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: AllTaskCard(
                          todo: todo,
                          leftBoxColor: const Color(0xFF386392),
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
                  ),
                ],
                if (completedTodos.isEmpty && pendingTodos.isEmpty)
                  const Center(
                    child: Text('Tidak ada tugas untuk ditampilkan.'),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          );
        },
        backgroundColor: const Color(0xFF386392),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF386392),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(),
      ),
    );
  }
}

class AllTaskCard extends StatelessWidget {
  final Todo todo;
  final Color leftBoxColor;
  final ValueChanged<bool?>? onToggleDone;
  final VoidCallback? onTap;

  const AllTaskCard({
    Key? key,
    required this.todo,
    required this.leftBoxColor,
    this.onToggleDone,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    final String formattedDate = formatter.format(todo.createdAt);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF386392),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 15,
              height: 90,
              decoration: BoxDecoration(
                color: leftBoxColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      formattedDate,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white70,
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () => onToggleDone?.call(!todo.isDone),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: todo.isDone ? Colors.white : Colors.transparent,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: todo.isDone
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Color(0xFF386392),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
