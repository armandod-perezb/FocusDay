import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_list.dart';
import '../widgets/task_form_bottom_sheet.dart';
import '../../domain/entities/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  int _selectedIndex = 0;
  late PageController _pageController;

  // Calendario variables
  int calendarSelectedDay = 0;
  int calendarSelectedMonth = 0;
  int calendarSelectedYear = 0;
  List<Task> allTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _pageController = PageController(initialPage: 0);

    final now = DateTime.now();
    calendarSelectedDay = now.day;
    calendarSelectedMonth = now.month;
    calendarSelectedYear = now.year;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadTasks() {
    context.read<TaskBloc>().add(LoadTasksByDate(selectedDate));
  }

  void _showTaskForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TaskFormBottomSheet(
        selectedDate: selectedDate,
      ),
    );
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
    _loadTasks();
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Mapear índice de navbar a índice de PageView
    // NavBar: 0=Home, 1=Tareas, 2=Add new, 3=Calendario, 4=Perfil
    // PageView: 0=Home, 1=Tareas, 2=Calendario, 3=Perfil

    switch (index) {
      case 0:
        // Home
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 1:
        // Tareas
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 2:
        // Add new
        _showTaskForm();
        setState(() {
          _selectedIndex = 0;
        });
        break;
      case 3:
        // Calendario
        _pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 4:
        // Perfil
        _pageController.animateToPage(
          3,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FocusDay',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade400, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
              Colors.purple.shade100,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (pageIndex) {
            setState(() {
              // Mapear índice de página a índice de navbar
              // PageView: 0=Home, 1=Tareas, 2=Calendario, 3=Perfil
              // NavBar: 0=Home, 1=Tareas, 2=Add new, 3=Calendario, 4=Perfil
              switch (pageIndex) {
                case 0:
                  _selectedIndex = 0; // Home
                  break;
                case 1:
                  _selectedIndex = 1; // Tareas
                  break;
                case 2:
                  _selectedIndex = 3; // Calendario
                  break;
                case 3:
                  _selectedIndex = 4; // Perfil
                  break;
              }
            });
          },
          children: [
            _buildHomeTab(),
            _buildTasksTab(),
            _buildCalendarTab(),
            _buildProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavBarItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: _selectedIndex == 0
                    ? BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: const Icon(Icons.home, size: 26),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: _selectedIndex == 1
                    ? BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: const Icon(Icons.checklist, size: 26),
              ),
              label: 'Tareas',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: 26, color: Colors.purple.shade600),
              ),
              label: 'Add new',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: _selectedIndex == 3
                    ? BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: const Icon(Icons.calendar_today, size: 26),
              ),
              label: 'Calendario',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: _selectedIndex == 4
                    ? BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: const Icon(Icons.person, size: 26),
              ),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        _buildDateSelector(),
        Expanded(
          child: BlocConsumer<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is TaskOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is TaskLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TaskLoaded) {
                return TaskList(tasks: state.tasks);
              } else if (state is TaskError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('No hay tareas'));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTasksTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checklist, size: 80, color: Colors.purple.shade400),
          const SizedBox(height: 20),
          Text(
            'Todas tus Tareas',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Aquí verás todas tus tareas pendientes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    List<int> calendarDays = _getCalendarDays(calendarSelectedMonth, calendarSelectedYear);
    String monthName = _getMonthName(calendarSelectedMonth);

    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskLoaded) {
          setState(() {
            allTasks = state.tasks;
          });
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildCalendarYearSelector(),
              const SizedBox(height: 20),
              _buildCalendarMonthSelector(monthName),
              const SizedBox(height: 20),
              _buildCalendarGrid(calendarDays),
              const SizedBox(height: 20),
              _buildCalendarDateDisplay(),
              const SizedBox(height: 20),
              _buildCalendarTasksList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 80, color: Colors.blue.shade400),
          const SizedBox(height: 20),
          Text(
            'Mi Perfil',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Manage tu perfil aquí',
            style: TextStyle(
              fontSize: 16,
              color: Colors.purple.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.9),
            Colors.blue.shade50.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.15),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.purple.shade600),
              onPressed: () => _changeDate(-1),
            ),
          ),
          Text(
            _formatDate(selectedDate),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.blue.shade600),
              onPressed: () => _changeDate(1),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Hoy';
    } else if (dateToCheck == today.add(const Duration(days: 1))) {
      return 'Mañana';
    } else if (dateToCheck == today.subtract(const Duration(days: 1))) {
      return 'Ayer';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  // Métodos del calendario
  int _getDaysInMonth(int month, int year) {
    if (month == 2) {
      return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) ? 29 : 28;
    }
    return [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month - 1];
  }

  int _getFirstDayOfMonth(int month, int year) {
    return DateTime(year, month, 1).weekday;
  }

  List<int> _getCalendarDays(int month, int year) {
    List<int> days = [];
    int daysInMonth = _getDaysInMonth(month, year);
    int firstDay = _getFirstDayOfMonth(month, year);

    for (int i = 0; i < firstDay - 1; i++) {
      days.add(0);
    }

    for (int i = 1; i <= daysInMonth; i++) {
      days.add(i);
    }

    return days;
  }

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }

  String _getDayOfWeekName(DateTime date) {
    const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return days[date.weekday - 1];
  }

  Widget _buildCalendarYearSelector() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade100, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.purple.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () {
                setState(() {
                  calendarSelectedYear--;
                });
              },
            ),
          ),
          Text(
            calendarSelectedYear.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () {
                setState(() {
                  calendarSelectedYear++;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarMonthSelector(String monthName) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.cyan.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () {
                setState(() {
                  if (calendarSelectedMonth == 1) {
                    calendarSelectedMonth = 12;
                    calendarSelectedYear--;
                  } else {
                    calendarSelectedMonth--;
                  }
                });
              },
            ),
          ),
          Column(
            children: [
              Text(
                monthName.toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              Text(
                '${calendarSelectedMonth.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.cyan.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () {
                setState(() {
                  if (calendarSelectedMonth == 12) {
                    calendarSelectedMonth = 1;
                    calendarSelectedYear++;
                  } else {
                    calendarSelectedMonth++;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(List<int> calendarDays) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.95), Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.shade200,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade600,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: calendarDays.length,
            itemBuilder: (context, index) {
              int day = calendarDays[index];
              bool isSelected = day == calendarSelectedDay &&
                  calendarSelectedMonth == DateTime.now().month &&
                  calendarSelectedYear == DateTime.now().year;
              bool isToday = day == DateTime.now().day &&
                  calendarSelectedMonth == DateTime.now().month &&
                  calendarSelectedYear == DateTime.now().year;

              return GestureDetector(
                onTap: day != 0
                    ? () {
                        setState(() {
                          calendarSelectedDay = day;
                        });
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    gradient: day != 0
                        ? isToday
                            ? LinearGradient(
                                colors: [
                                  Colors.purple.shade400,
                                  Colors.blue.shade400,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : isSelected
                                ? LinearGradient(
                                    colors: [
                                      Colors.purple.shade300,
                                      Colors.blue.shade300,
                                    ],
                                  )
                                : null
                        : null,
                    color: day == 0
                        ? Colors.transparent
                        : !isToday && !isSelected
                            ? Colors.white.withValues(alpha: 0.7)
                            : null,
                    borderRadius: BorderRadius.circular(15),
                    border: day != 0 && !isToday && !isSelected
                        ? Border.all(
                            color: Colors.purple.shade200,
                            width: 1,
                          )
                        : null,
                    boxShadow: day != 0 && (isToday || isSelected)
                        ? [
                            BoxShadow(
                              color: Colors.purple.withValues(alpha: 0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: day != 0
                      ? Center(
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isToday || isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isToday || isSelected
                                  ? Colors.white
                                  : Colors.purple.shade700,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDateDisplay() {
    String monthName = _getMonthName(calendarSelectedMonth);
    String dayOfWeek = _getDayOfWeekName(
      DateTime(calendarSelectedYear, calendarSelectedMonth, calendarSelectedDay),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade200, Colors.blue.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Fecha Seleccionada',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$dayOfWeek, $calendarSelectedDay de $monthName de $calendarSelectedYear',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTasksList() {
    // Obtener tareas del día seleccionado en el calendario
    final selectedDateTime = DateTime(calendarSelectedYear, calendarSelectedMonth, calendarSelectedDay);
    final tasksForDay = allTasks.where((task) {
      final taskDate = DateTime(task.date.year, task.date.month, task.date.day);
      return taskDate == selectedDateTime;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.95), Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.shade200,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tareas del día',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
          ),
          const SizedBox(height: 15),
          if (tasksForDay.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: Colors.green.shade300,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No hay tareas para este día',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasksForDay.length,
              itemBuilder: (context, index) {
                final task = tasksForDay[index];
                final priorityColor = task.priority == TaskPriority.high
                    ? Colors.red
                    : task.priority == TaskPriority.medium
                        ? Colors.orange
                        : Colors.green;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.blue.shade50,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: priorityColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: priorityColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 60,
                          decoration: BoxDecoration(
                            color: priorityColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade700,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (task.description != null)
                                Text(
                                  task.description!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 4),
                              Text(
                                task.priority.toString().split('.').last.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: priorityColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (task.isCompleted)
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 28,
                          )
                        else
                          Icon(
                            Icons.radio_button_unchecked,
                            color: priorityColor.withValues(alpha: 0.5),
                            size: 28,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
