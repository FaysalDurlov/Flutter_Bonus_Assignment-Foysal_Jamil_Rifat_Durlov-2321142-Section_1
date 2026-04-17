import 'package:flutter/material.dart';
import 'package:flutter_ui_class/data/dummy_data.dart';
import 'package:flutter_ui_class/providers/task_management_provider.dart';
import 'package:flutter_ui_class/screens/add_task_page.dart';
import 'package:flutter_ui_class/widgets/task_card_widget.dart';
import 'package:provider/provider.dart';

class UiPage extends StatefulWidget {
  const UiPage({super.key});

  @override
  State<UiPage> createState() => _UiPageState();
}

class _UiPageState extends State<UiPage> {


  
  DummyData dummyDataInstance = DummyData();
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<TaskManagementProvider>(
        context,
        listen: false,
      ).loadTasksFromFirebase();
    });
  }


  @override
  Widget build(BuildContext context) {
    print("Building UI Page...");
    

    return Scaffold(
      appBar: AppBar(
        title: Text("UI PAGE"),
        backgroundColor: Colors.purpleAccent,
      ),

      body: Consumer<TaskManagementProvider>(
        builder: (context, taskProvider, _) {
          return RefreshIndicator(
              onRefresh: () async {
                await Provider.of<TaskManagementProvider>(
                  context,
                  listen: false,
                ).loadTasksFromFirebase();
              },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: taskProvider.firebaseTasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.firebaseTasks[index];

                return TaskCardWidget(
                  task: task,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddTaskPage(task: task),
                      ),
                    );
                  },
                  onDelete: () async {
                    await taskProvider.deleteTask(task.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Task deleted"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                );
              },
            ),
          );
        }
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AddTaskPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}
