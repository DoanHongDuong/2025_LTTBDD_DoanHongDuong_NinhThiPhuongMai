import 'package:btl_lttbdd/settings.dart';
import 'package:flutter/material.dart';
import './group.dart';
import 'package:intl/intl.dart';
import './calendar.dart';
import './settings.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null);
  runApp(const ToDoApp());
}

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  ThemeMode _themeMode = ThemeMode.light;
  double _fontScale = 1.0;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _changeFont(double scale) {
    setState(() {
      _fontScale = scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo-List',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          background: Colors.white,
          surface: Colors.grey.shade100,
          primary: Colors.indigo,
          onSurface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
        ),
        cardColor: Colors.grey.shade100,
        textTheme: Theme.of(
          context,
        ).textTheme.apply(fontSizeFactor: _fontScale),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          background: Colors.black, // nền chính đen hẳn
          surface: Color(0xFF1E1E1E), // card, appbar xám sáng hơn
          primary: Colors.indigo, // màu chính
          secondary: Colors.grey, // màu phụ
          onSurface: Colors.white, // màu chữ
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E), // appbar sáng hơn nền
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardColor: const Color(0xFF1E1E1E),
        textTheme: Theme.of(
          context,
        ).textTheme.apply(fontSizeFactor: _fontScale),
      ),

      home: ToDoHomePage(
        onThemeChanged: _changeTheme,
        onFontChanged: _changeFont,
      ), // truyền callback
    );
  }
}

class ToDoHomePage extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;
  final Function(double)? onFontChanged;

  const ToDoHomePage({super.key, this.onThemeChanged, this.onFontChanged});

  @override
  State<ToDoHomePage> createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _tasks = [];
  String _language = 'vi';
  ThemeMode _themeMode = ThemeMode.light;
  double _fontScale = 1.0;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });

    if (widget.onThemeChanged != null) {
      widget.onThemeChanged!(mode);
    }
  }

  void _changFont(double scale) {
    setState(() {
      _fontScale = scale;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeLanguage(String lang) {
    setState(() {
      _language = lang;
    });
  }

  void _addTask(String title, DateTime? deadline) {
    setState(() {
      _tasks.add({'title': title, 'done': false, 'deadline': deadline});
    });
  }

  void _toggleDone(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _editTask(int index) {
    final TextEditingController editController = TextEditingController(
      text: _tasks[index]['title'],
    );
    DateTime? selectedDate = _tasks[index]['deadline'];
    String? _errorText;

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                _language == 'vi' ? 'Thêm công việc' : 'Add Task',
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: _language == 'vi'
                          ? 'Nhập nội dung...'
                          : 'Enter task...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? (_language == 'vi'
                                    ? 'Thêm deadline (không bắt buộc)'
                                    : 'Add deadline (optional)')
                              : 'Deadline: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != selectedDate) {
                            setDialogState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    final newText = editController.text.trim();

                    if (newText.isNotEmpty) {
                      setState(() {
                        _tasks[index]['title'] = newText;
                        _tasks[index]['deadline'] = selectedDate;
                      });
                      Navigator.pop(context);
                    } else {
                      setDialogState(() {
                        _errorText = _language == 'vi'
                            ? 'Nội dung không được để trống'
                            : 'Task content cannot be empty';
                      });
                    }
                  },
                  child: Text(
                    _language == 'vi' ? 'Lưu' : 'Save',
                    style: TextStyle(color: Colors.indigo),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _controller.clear();
                    Navigator.pop(context);
                  },
                  child: Text(
                    _language == 'vi' ? 'Hủy' : 'Cancel',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddDialog() {
    DateTime? selectedDate;
    String? _errorText;

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                _language == 'vi' ? 'Thêm công việc' : 'Add Task',
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: isDark ? Colors.red[300] : Colors.red[700],
                      ),
                      hintText: _language == 'vi'
                          ? 'Nhập nội dung...'
                          : 'Enter task...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: _errorText,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? (_language == 'vi'
                                    ? 'Chưa có deadline'
                                    : 'No deadline')
                              : 'Deadline: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != selectedDate) {
                            setDialogState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      _addTask(text, selectedDate);
                      _controller.clear();
                      Navigator.pop(context);
                    } else {
                      setDialogState(() {
                        _errorText = _language == 'vi'
                            ? 'Nội dung không được để trống'
                            : 'Please enter a task';
                      });
                    }
                  },
                  child: Text(
                    _language == 'vi' ? 'Thêm' : 'Add',
                    style: const TextStyle(color: Colors.indigo),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _controller.clear();
                    Navigator.pop(context);
                  },
                  child: Text(
                    _language == 'vi' ? 'Hủy' : 'Cancel',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task, int index) {
    final DateTime? deadline = task['deadline'] as DateTime?;

    final bool isOverdue =
        deadline != null && deadline.isBefore(DateTime.now()) && !task['done'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? (task['done']
                  ? const Color(0xFF2A2A2A) // màu xám nhạt khi done
                  : const Color(0xFF1E1E1E)) // màu xám đậm cho việc chưa xong
            : (task['done']
                  ? Colors.indigo[50]
                  : Colors.white), // khi sáng giữ nguyên
        borderRadius: BorderRadius.circular(14),
        border: isOverdue
            ? Border.all(color: Colors.redAccent, width: 1.5)
            : null,
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: ListTile(
        onTap: () => _editTask(index),
        leading: Checkbox(
          value: task['done'],
          activeColor: Colors.indigo,
          onChanged: (_) => _toggleDone(index),
        ),
        title: Text(
          task['title'],
          style: TextStyle(
            fontSize: 17,
            decoration: task['done']
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: Theme.of(context).brightness == Brightness.dark
                ? (task['done'] ? Colors.grey[400] : Colors.white)
                : (task['done'] ? Colors.grey : Colors.black),
            fontWeight: task['done'] ? FontWeight.w400 : FontWeight.w500,
          ),
        ),
        subtitle: deadline != null
            ? Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: isOverdue
                        ? Colors.redAccent
                        : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600]),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(deadline),
                    style: TextStyle(
                      color: isOverdue
                          ? Colors.redAccent
                          : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey[600]),
                    ),
                  ),
                ],
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _removeTask(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Phan loai Task thanh 2 nhom
    final List<Map<String, dynamic>> tasksToDo = [];
    final List<Map<String, dynamic>> tasksDone = [];

    for (int i = 0; i < _tasks.length; i++) {
      final task = _tasks[i];
      if (task['done']) {
        tasksDone.add({'task': task, 'originalIndex': i});
      } else {
        tasksToDo.add({'task': task, 'originalIndex': i});
      }
    }

    // Sap xep danh sach can lam( Deadline gan nhat o tren)
    tasksToDo.sort((a, b) {
      final deadlineA = a['task']['deadline'] as DateTime?;
      final deadlineB = b['task']['deadline'] as DateTime?;

      if (deadlineA == null && deadlineB == null) return 0;
      if (deadlineA == null) return 1;
      if (deadlineB == null) return -1;
      return deadlineA.compareTo(deadlineB);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 3,
        centerTitle: true,
        title: Text(
          _language == 'vi' ? 'Danh sách việc' : 'ToDo-List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarPage(tasks: _tasks),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    currentLanguage: _language,
                    onLanguageChanged: _changeLanguage,
                    currentThemeMode: _themeMode,
                    onThemeChanged: _changeTheme,
                    currentFontScale: _fontScale,
                    onFontChanged: (scale) {
                      _changFont(scale);
                      if (widget.onFontChanged != null) {
                        widget.onFontChanged!(scale);
                      }
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _language == 'vi'
                        ? 'Chưa có công việc nào.\nNhấn dấu + để thêm!'
                        : 'No tasks yet.\nTap + to add!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (tasksToDo.isNotEmpty) ...[
                  Text(
                    _language == 'vi'
                        ? 'Cần làm (${tasksToDo.length})'
                        : 'To Do (${tasksToDo.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...tasksToDo.map((taskData) {
                    return _buildTaskItem(
                      taskData['task'],
                      taskData['originalIndex'],
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                ],
                if (tasksDone.isNotEmpty) ...[
                  Text(
                    _language == 'vi'
                        ? 'Đã hoàn thành (${tasksDone.length})'
                        : 'Done (${tasksDone.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 8),
                  ...tasksDone.map((taskData) {
                    return _buildTaskItem(
                      taskData['task'],
                      taskData['originalIndex'],
                    );
                  }).toList(),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: Text(_language == 'vi' ? 'Thêm công việc' : 'Add Task'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }
}
