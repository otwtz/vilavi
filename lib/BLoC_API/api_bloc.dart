import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vilavi/BLoC_API/api_event.dart';
import 'package:vilavi/BLoC_API/api_state.dart';
import 'package:vilavi/Models/task.dart';


class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskState.initial()) {
    on<FetchTasksEvent>(_onFetchTasks);
    on<ToggleTaskEvent>(_onToggleTask);
    on<AddTaskEvent>(_onAddTask);
    on<FilterTasksEvent>(_onFilterTasks);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  // Существующий метод для получения задач
  Future<void> _onFetchTasks(FetchTasksEvent event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
      if (response.statusCode == 200) {
        final tasks = (json.decode(response.body) as List)
            .map((json) => Task.fromJson(json))
            .toList();
        emit(state.copyWith(tasks: tasks, filteredTasks: tasks, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: 'Failed to fetch tasks'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Error: $e'));
    }
  }

  // Метод для переключения статуса задачи
  Future<void> _onToggleTask(ToggleTaskEvent event, Emitter<TaskState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = List<Task>.from(state.tasks);
    final index = tasks.indexWhere((task) => task.id == event.task.id);
    tasks[index] = event.task.copyWith(completed: !event.task.completed);
    await prefs.setString('tasks', json.encode(tasks.map((task) => task.toJson()).toList()));
    emit(state.copyWith(tasks: tasks, filteredTasks: tasks));
  }

  // Метод для добавления задачи
  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = List<Task>.from(state.tasks);
    tasks.insert(0, event.task);
    await prefs.setString('tasks', json.encode(tasks.map((task) => task.toJson()).toList()));
    emit(state.copyWith(tasks: tasks, filteredTasks: tasks));
  }

  // Метод для фильтрации задач
  Future<void> _onFilterTasks(FilterTasksEvent event, Emitter<TaskState> emit) async {
    final filteredTasks = event.showCompleted
        ? state.tasks.where((task) => task.completed).toList()
        : state.tasks.where((task) => !task.completed).toList();
    emit(state.copyWith(filteredTasks: filteredTasks));
  }

  // Метод для удаления задачи
  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = List<Task>.from(state.tasks)..remove(event.task);
    await prefs.setString('tasks', json.encode(tasks.map((task) => task.toJson()).toList()));
    emit(state.copyWith(tasks: tasks, filteredTasks: tasks));
  }

}
