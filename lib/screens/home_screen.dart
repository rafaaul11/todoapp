import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Untuk mendapatkan nama pengguna
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/firestore_service.dart';
import 'package:todo_app/screens/add_todo_screen.dart'; // Untuk menambah tugas
import 'package:todo_app/screens/all_tasks_screen.dart'; // Akan dibuat nanti untuk "See all"
import 'package:todo_app/screens/category_tasks_screen.dart'; // Tambahkan import untuk CategoryTasksScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String? _userName; // Untuk menyimpan nama pengguna
  int _tasksDueToday = 0; // Untuk jumlah tugas hari ini

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _listenToTasksDueToday();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Ambil nama pengguna dari Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        // Jika displayName ada, gunakan itu, jika tidak, gunakan bagian email sebelum '@'
        _userName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
      });
    }
  }

  void _listenToTasksDueToday() {
    // Mendengarkan perubahan tugas yang jatuh tempo hari ini
    _firestoreService.getTodos().listen((todos) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      int count = 0;
      for (var todo in todos) {
        // Asumsi createdAt sebagai due date untuk demo ini.
        // Di aplikasi nyata, kamu mungkin punya field 'dueDate'.
        final todoDate = DateTime(
          todo.createdAt.year,
          todo.createdAt.month,
          todo.createdAt.day,
        );
        if (todoDate.isAtSameMomentAs(today) && !todo.isDone) {
          count++;
        }
      }
      setState(() {
        _tasksDueToday = count;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8EE), // Background krem muda
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for Tasks, Events',
                  hintStyle: GoogleFonts.poppins(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF386392),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              const SizedBox(height: 30),
              // Sapaan Pengguna
              Text(
                'Hi ${_userName ?? 'User'}, you have $_tasksDueToday tasks due today!!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4C4A3A),
                ),
              ),
              const SizedBox(height: 30),
              // Categories
              Text(
                'Categories',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4C4A3A),
                ),
              ),
              const SizedBox(height: 15),
              // Grid Kategori
              GridView.builder(
                shrinkWrap: true, // Agar GridView menyesuaikan tinggi kontennya
                physics:
                    const NeverScrollableScrollPhysics(), // Nonaktifkan scroll GridView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 kolom
                  crossAxisSpacing: 15, // Spasi horizontal antar item
                  mainAxisSpacing: 15, // Spasi vertikal antar item
                  childAspectRatio: 0.9, // Rasio aspek (lebar/tinggi) item
                ),
                itemCount: 4, // Jumlah kategori yang ditunjukkan di desain
                itemBuilder: (context, index) {
                  // Data Dummy Kategori
                  List<Map<String, dynamic>> categories = [
                    {
                      'name': 'Study',
                      'icon': Icons.edit_note,
                      'color': const Color(0xFF386392),
                    }, // Biru tua
                    {
                      'name': 'Personal',
                      'icon': Icons.person,
                      'color': const Color(0xFFE48D2E),
                    }, // Oranye
                    {
                      'name': 'Shopping',
                      'icon': Icons.shopping_cart,
                      'color': const Color(0xFF386392),
                    }, // Biru tua
                    {
                      'name': 'Health',
                      'icon': Icons.favorite,
                      'color': Colors.red[300],
                    }, // Merah muda
                  ];
                  var category = categories[index];

                  return CategoryCard(
                    name: category['name'],
                    icon: category['icon'],
                    color: category['color'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryTasksScreen(
                            categoryName: category['name'],
                            categoryIcon: category['icon'],
                            categoryColor: category['color'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 30),

              // Today's task
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s task',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4C4A3A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman semua tugas
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllTasksScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'See all',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE48D2E), // Warna oranye
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Daftar Tugas Hari Ini
              // Menggunakan StreamBuilder untuk mendengarkan perubahan dari Firestore
              StreamBuilder<List<Todo>>(
                stream: _firestoreService.getTodos(), // Dapatkan semua todo
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada tugas hari ini.'),
                    );
                  }

                  // Filter tugas yang jatuh tempo hari ini
                  List<Todo> todayTodos = snapshot.data!.where((todo) {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final todoDate = DateTime(
                      todo.createdAt.year,
                      todo.createdAt.month,
                      todo.createdAt.day,
                    );
                    return todoDate.isAtSameMomentAs(today) && !todo.isDone;
                  }).toList();

                  // Urutkan berdasarkan waktu (misalnya, createdAt)
                  todayTodos.sort((a, b) => a.createdAt.compareTo(b.createdAt));

                  if (todayTodos.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada tugas aktif untuk hari ini!'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap:
                        true, // Penting agar ListView bisa di dalam SingleChildScrollView
                    physics:
                        const NeverScrollableScrollPhysics(), // Nonaktifkan scroll ListView
                    itemCount: todayTodos.length,
                    itemBuilder: (context, index) {
                      Todo todo = todayTodos[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10.0,
                        ), // Spasi antar tugas
                        child: TaskCard(
                          todo: todo,
                          onToggleDone: (bool? newValue) {
                            if (newValue != null) {
                              _firestoreService.updateTodo(todo.id!, {
                                'isDone': newValue,
                              });
                            }
                          },
                          onTap: () {
                            // Contoh: Navigasi ke halaman detail/edit tugas
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          );
        },
        backgroundColor: const Color(0xFF386392), // Warna tombol
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Sudut membulat
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}

// Widget Kustom untuk Kartu Kategori
class CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap; // <-- Tambahkan ini

  const CategoryCard({
    Key? key,
    required this.name,
    required this.icon,
    this.color,
    this.onTap, // <-- Tambahkan ini
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap, // <-- Gunakan onTap di sini
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4C4A3A),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Kustom untuk Kartu Tugas Hari Ini
class TaskCard extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?>? onToggleDone;
  final VoidCallback? onTap;

  const TaskCard({Key? key, required this.todo, this.onToggleDone, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mendapatkan waktu dari createdAt (untuk demo ini)
    String time =
        '${todo.createdAt.hour.toString().padLeft(2, '0')}:${todo.createdAt.minute.toString().padLeft(2, '0')} am'; // Asumsi AM/PM
    if (todo.createdAt.hour >= 12) {
      time =
          '${(todo.createdAt.hour - 12).toString().padLeft(2, '0')}:${todo.createdAt.minute.toString().padLeft(2, '0')} pm';
      if (todo.createdAt.hour == 12) {
        time = '12:${todo.createdAt.minute.toString().padLeft(2, '0')} pm';
      }
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF386392), // Warna biru tua seperti desain
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Checklist/Lingkaran
              GestureDetector(
                onTap: () => onToggleDone?.call(!todo.isDone),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: todo.isDone
                        ? Colors.white
                        : Colors.transparent, // Warna putih jika done
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ), // Border putih
                  ),
                  child: todo.isDone
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Color(0xFF386392),
                        ) // Ikon centang
                      : null,
                ),
              ),
              const SizedBox(width: 15),
              // Judul Tugas
              Expanded(
                child: Text(
                  todo.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 15),
              // Waktu Tugas
              Text(
                time,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white70, // Warna putih sedikit transparan
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
