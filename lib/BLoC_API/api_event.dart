import 'package:vilavi/Models/task.dart';

import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTasksEvent extends TaskEvent {}

class ToggleTaskEvent extends TaskEvent {
  final Task task;

  ToggleTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class AddTaskEvent extends TaskEvent {
  final Task task;

  AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class FilterTasksEvent extends TaskEvent {
  final bool showCompleted;
  FilterTasksEvent(this.showCompleted);
}

class DeleteTaskEvent extends TaskEvent {
  final Task task;
  DeleteTaskEvent(this.task);
}



