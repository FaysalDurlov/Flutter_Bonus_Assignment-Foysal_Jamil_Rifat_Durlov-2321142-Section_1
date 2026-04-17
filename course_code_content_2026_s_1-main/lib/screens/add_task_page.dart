import 'package:flutter/material.dart';
import 'package:flutter_ui_class/models/task_data_model.dart';
import 'package:flutter_ui_class/providers/task_management_provider.dart';
import 'package:flutter_ui_class/utils/validators.dart';
import 'package:flutter_ui_class/widgets/core_input_field.dart';
import 'package:flutter_ui_class/widgets/password_input_filed.dart';
import 'package:provider/provider.dart';

class AddTaskPage extends StatefulWidget {
  final TaskDataModel? task;

  const AddTaskPage({super.key, this.task});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final _titleController = TextEditingController();
  final _assignedToController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late TaskManagementProvider taskProvider;

  @override
  void initState() {
    super.initState();
    taskProvider =
        Provider.of<TaskManagementProvider>(context, listen: false);

    taskProvider.loadTasksFromFirebase();
    if (widget.task != null) {
      fillData(widget.task!);
    }
  }
  
  void fillData(TaskDataModel task) {
    _titleController.text = task.title;
    _assignedToController.text = task.assignedTo;
    _phoneNumberController.text = task.number;
    _passwordController.text = task.password;
    _descriptionController.text = task.discreption;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _assignedToController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CoreInputField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                labelText: "Task Title",
                validator: CustomValidators.validateTaskTitle,
              ),

              const SizedBox(height: 20),
              CoreInputField(
                controller: _assignedToController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                labelText: "Assigned To",
                validator: CustomValidators.validateAssignedTo,
              ),

              const SizedBox(height: 20),
              CoreInputField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                labelText: "Phone Number",
                validator: CustomValidators.validatePhoneNumber,
              ),

              const SizedBox(height: 20),
              PasswordInputFiled(controller: _passwordController),

              const SizedBox(height: 40),
              CoreInputField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                labelText: "Task Description",
                validator: CustomValidators.validateDescription,
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            if (widget.task != null)
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    bool success =
                        await taskProvider.deleteTask(widget.task!.id);

                    if (!mounted) return;

                    if (success) {
                      await taskProvider.loadTasksFromFirebase();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Task Deleted"),
                          backgroundColor: Colors.red,
                        ),
                      );

                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Delete"),
                ),
              ),

            if (widget.task != null)
              const SizedBox(width: 10),

            // ✔ CREATE / UPDATE BUTTON
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {

                    TaskDataModel task = TaskDataModel(
                      id: widget.task?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleController.text,
                      discreption: _descriptionController.text,
                      password: _passwordController.text,
                      assignedTo: _assignedToController.text,
                      createdAt: DateTime.now().toIso8601String(),
                      number: _phoneNumberController.text,
                    );

                    bool success;

                    if (widget.task == null) {
                      success = await taskProvider.addTaskToFirebase(task);
                    } else {
                      success = await taskProvider.updateTask(task);
                    }

                    if (!mounted) return;

                    if (success) {
                      await taskProvider.loadTasksFromFirebase();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.task == null ? "Task Created" : "Task Updated",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.of(context).pop();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(widget.task == null ? "Add Task" : "Update Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
