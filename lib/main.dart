// ignore_for_file: always_specify_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Four Leaves',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Four Leaves'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 0.8,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductivityButton(
              label: 'Assignments',
              color: const Color.fromARGB(255, 170, 233, 245),
              iconPath: 'assets/Assignment.png',
              onPressed: () {
                // Navigate to the assignments page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => AssignmentsPage()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductivityButton(
              label: 'Homework',
              color: const Color.fromARGB(255, 174, 209, 175),
              iconPath: 'assets/homework.png',
              onPressed: () {
                // Navigate to the homework page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => HomeworkPage()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductivityButton(
              label: 'Projects',
              color: const Color.fromARGB(255, 234, 169, 245),
              iconPath: 'assets/projects.png',
              onPressed: () {
                // Navigate to the projects page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => ProjectsPage()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductivityButton(
              label: 'Meetings',
              color: const Color.fromARGB(255, 246, 242, 161),
              iconPath: 'assets/Meetings.png',
              onPressed: () {
                // Navigate to the meetings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => MeetingsPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductivityButton extends StatelessWidget {
  final String label;
  final Color color;
  final String iconPath;
  final VoidCallback onPressed;

  const ProductivityButton({
    required this.label,
    required this.color,
    required this.iconPath,
    required this.onPressed,
  });

  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontFamily: 'Courier New',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          Image.asset(
            iconPath,
            width: 80,
            height: 80,
          ),
        ],
      ),
    ),
  );
}
}

class TaskItem {
  String task;
  bool isChecked;

  TaskItem({
    required this.task,
    this.isChecked = false,
  });

  void toggle() {
    isChecked = !isChecked;
  }
}


// Helper method to load tasks from SharedPreferences
Future<List<TaskItem>> loadTasksFromSharedPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final taskStrings = prefs.getStringList('tasks');
  if (taskStrings != null) {
    final tasks = taskStrings.map((taskString) {
      final taskData = taskString.split(':');
      return TaskItem(
        task: taskData[0],
        isChecked: taskData[1] == 'true',
      );
    }).toList();
    return tasks;
  }
  return [];
}

// Helper method to save tasks to SharedPreferences
Future<void> saveTasksToSharedPrefs(List<TaskItem> tasks) async {
  final prefs = await SharedPreferences.getInstance();
  final taskStrings = tasks.map((task) => '${task.task}:${task.isChecked}').toList();
  await prefs.setStringList('tasks', taskStrings);
}


class AssignmentsPage extends StatefulWidget {
  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentsPage> {
  List<TaskItem> assignments = [];

  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    assignments = prefs.getStringList('assignments')?.map((assignment) {
      return TaskItem(
        task: assignment,
        isChecked: false,
      );
    }).toList() ?? [];
    setState(() {});
  }

  Future<void> saveAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('assignments', assignments.map((assignment) => assignment.task).toList());
  }


  void addAssignment(String assignment) {
    setState(() {
      assignments.add(TaskItem(task: assignment));
    });
    saveAssignments();
  }

  void toggleAssignment(int index) {
    setState(() {
      assignments[index].isChecked = !assignments[index].isChecked;
    });
    saveAssignments();
  }

  void removeAssignment(String assignment) {
    setState(() {
      assignments.removeWhere((item) => item.task == assignment);
    });
    saveAssignments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
    icon: const Icon(
      CupertinoIcons.arrow_left, // Replace this with your desired icon
      // You can also customize the icon size and color if needed
      size: 24,
      color: Colors.white,
    ),
    onPressed: () {
      Navigator.of(context).pop();// Handle the back button press event
    },
  ),
        title: const Text('Assignments'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: const Color.fromARGB(255, 170, 233, 245),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                         ),
                        title: const Text('Add Assignment'),
                        content: TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            hintText: 'Enter a task',
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              if (_taskController.text.isNotEmpty) {
                                addAssignment(_taskController.text);
                              }
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                            child: const Icon(CupertinoIcons.add),
                            
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Add Assignment'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: assignments.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(assignments[index].task),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      removeAssignment(assignments[index].task);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      color: Colors.red,
                      child: const Icon(
                        CupertinoIcons.minus_circle,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: assignments[index].isChecked,
                        onChanged: (bool? value) {
                          toggleAssignment(index);
                        },
                      ),
                      title: Text(
                        assignments[index].task,
                        style: TextStyle(
                          decoration: assignments[index].isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class HomeworkPage extends StatefulWidget {
  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
   List<TaskItem> homeworks = [];

  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadHomeworks();
  }

  Future<void> loadHomeworks() async {
    final prefs = await SharedPreferences.getInstance();
    homeworks = prefs.getStringList('homeworks')?.map((homework) {
      return TaskItem(
        task: homework,
        isChecked: false,
      );
    }).toList() ?? [];
    setState(() {});
  }

  Future<void> saveHomeworks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('homeworks', homeworks.map((homework) => homework.task).toList());
  }

  void addHomeworks(String homework) {
    setState(() {
      homeworks.add(TaskItem(task: homework));
    });
    saveHomeworks();
  }


  void toggleHomeworks(int index) {
    setState(() {
      homeworks[index].isChecked = !homeworks[index].isChecked;
    });
    saveHomeworks();
  }

  void removeHomeworks(String homework) {
    setState(() {
      homeworks.removeWhere((item) => item.task == homework);
    });
    saveHomeworks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
    icon: const Icon(
      CupertinoIcons.arrow_left, // Replace this with your desired icon
      // You can also customize the icon size and color if needed
      size: 24,
      color: Colors.white,
    ),
    onPressed: () {
      Navigator.of(context).pop();// Handle the back button press event
    },
  ),
        title: const Text('Homework'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: const Color.fromARGB(255, 174, 209, 175),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                         ),
                        title: const Text('Add Homework'),
                        content: TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            hintText: 'Enter a task',
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              if (_taskController.text.isNotEmpty) {
                                addHomeworks(_taskController.text);
                              }
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                            child: const Icon(CupertinoIcons.add),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Add Homework'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: homeworks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(homeworks[index].task),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      removeHomeworks(homeworks[index].task);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      color: Colors.red,
                      child: const Icon(
                        CupertinoIcons.minus_circle,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: homeworks[index].isChecked,
                        onChanged: (bool? value) {
                          toggleHomeworks(index);
                        },
                      ),
                      title: Text(
                        homeworks[index].task,
                        style: TextStyle(
                          decoration: homeworks[index].isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
   List<TaskItem> projects = [];

  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    projects = prefs.getStringList('projects')?.map((project) {
      return TaskItem(
        task: project,
        isChecked: false,
      );
    }).toList() ?? [];
    setState(() {});
  }

  Future<void> saveProjects() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('projects', projects.map((project) => project.task).toList());
  }

  void addProjects(String project) {
    setState(() {
      projects.add(TaskItem(task: project));
    });
    saveProjects();
  }

  void toggleProjects(int index) {
    setState(() {
      projects[index].isChecked = !projects[index].isChecked;
    });
    saveProjects();
  }

  void removeProjects(String project) {
    setState(() {
      projects.removeWhere((item) => item.task == project);
    });
    saveProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
    icon: const Icon(
      CupertinoIcons.arrow_left, // Replace this with your desired icon
      // You can also customize the icon size and color if needed
      size: 24,
      color: Colors.white,
    ),
    onPressed: () {
      Navigator.of(context).pop();// Handle the back button press event
    },
  ),
        title: const Text('Projects'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        color: const Color.fromARGB(255, 234, 169, 245),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                         ),
                        title: const Text('Add Project'),
                        content: TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            hintText: 'Enter a task',
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              if (_taskController.text.isNotEmpty) {
                                addProjects(_taskController.text);
                              }
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                            child: const Icon(CupertinoIcons.add),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Add Project'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(projects[index].task),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      removeProjects(projects[index].task);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      color: Colors.red,
                      child: const Icon(
                        CupertinoIcons.minus_circle,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: projects[index].isChecked,
                        onChanged: (bool? value) {
                          toggleProjects(index);
                        },
                      ),
                      title: Text(
                        projects[index].task,
                        style: TextStyle(
                          decoration: projects[index].isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MeetingsPage extends StatefulWidget {
  @override
  _MeetingsPageState createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
   List<TaskItem> meetings = [];

  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMeetings();
  }


  Future<void> loadMeetings() async {
    final prefs = await SharedPreferences.getInstance();
    meetings = prefs.getStringList('meetings')?.map((meeting) {
      return TaskItem(
        task: meeting,
        isChecked: false,
      );
    }).toList() ?? [];
    setState(() {});
  }

  Future<void> saveMeetings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('meetings', meetings.map((meeting) => meeting.task).toList());
  }

  void addMeetings(String meeting) {
    setState(() {
      meetings.add(TaskItem(task: meeting));
    });
    saveMeetings();
  }

  void toggleMeeting(int index) {
    setState(() {
      meetings[index].isChecked = !meetings[index].isChecked;
    });
    saveMeetings();
  }

  void removeMeetings(String meeting) {
    setState(() {
      meetings.removeWhere((item) => item.task == meeting);
    });
    saveMeetings();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
    icon: const Icon(
      CupertinoIcons.arrow_left, // Replace this with your desired icon
      // You can also customize the icon size and color if needed
      size: 24,
      color: Colors.white,
    ),
    onPressed: () {
      Navigator.of(context).pop();// Handle the back button press event
    },
  ),
        title: const Text('Meetings'),
        backgroundColor: const Color.fromARGB(255, 199, 183, 44),
      ),
      body: Container(
        color: const Color.fromARGB(255, 246, 242, 161),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                         ),
                        title: const Text('Add Meeting'),
                        content: TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            hintText: 'Enter a task',
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              if (_taskController.text.isNotEmpty) {
                                addMeetings(_taskController.text);
                              }
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                            child: const Icon(CupertinoIcons.add),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Add Meeting'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: meetings.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(meetings[index].task),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      removeMeetings(meetings[index].task);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      color: Colors.red,
                      child: const Icon(
                        CupertinoIcons.minus_circle,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: meetings[index].isChecked,
                        onChanged: (bool? value) {
                          toggleMeeting(index);
                        },
                      ),
                      title: Text(
                        meetings[index].task,
                        style: TextStyle(
                          decoration: meetings[index].isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
