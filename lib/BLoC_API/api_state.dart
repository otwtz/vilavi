import 'package:equatable/equatable.dart';
import 'package:vilavi/Models/task.dart';

class TaskState {
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final bool isLoading;
  final String? errorMessage;

  TaskState({
    required this.tasks,
    required this.filteredTasks,
    required this.isLoading,
    this.errorMessage,
  });

  factory TaskState.initial() {
    return TaskState(
      tasks: [],
      filteredTasks: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  TaskState copyWith({
    List<Task>? tasks,
    List<Task>? filteredTasks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
