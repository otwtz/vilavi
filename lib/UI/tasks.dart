import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilavi/BLoC_API/api_bloc.dart';
import 'package:vilavi/BLoC_API/api_event.dart';
import 'package:vilavi/BLoC_API/api_state.dart';
import 'package:vilavi/Models/task.dart';

class TaskScreen extends StatefulWidget {

  TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          Switch(
            value: showCompleted,
            onChanged: (value) {
              setState(() {
                showCompleted = value; // Обновляем состояние фильтра
              });
              context.read<TaskBloc>().add(FilterTasksEvent(showCompleted)); // Отправляем событие фильтрации
            },
          ),

        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }
          return ListView.builder(
            itemCount: state.filteredTasks.length,
            itemBuilder: (context, index) {
              final task = state.filteredTasks[index];
              return ListTile(
                title: Text(task.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(task.completed ? Icons.check_box : Icons.check_box_outline_blank),
                      onPressed: () {
                        context.read<TaskBloc>().add(ToggleTaskEvent(task));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<TaskBloc>().add(DeleteTaskEvent(task));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  final titleController = TextEditingController();
                  return AlertDialog(
                    title: const Text('Add Task'),
                    content: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Task title'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          final newTask = Task(id: DateTime.now().millisecondsSinceEpoch, title: titleController.text, completed: false);
                          context.read<TaskBloc>().add(AddTaskEvent(newTask));
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
      );
  }
}



