part of 'tasks_cubit.dart';

@immutable
sealed class TasksState {}

final class TasksInitial extends TasksState {}

final class GetTasksLoadingState extends TasksState {}

final class GetTasksSuccessState extends TasksState {}

final class GetTasksErrorState extends TasksState {
  final String msg;

  GetTasksErrorState(this.msg);
}

final class UnauthenticatedState extends TasksState {}

final class AddTaskLoadingState extends TasksState {}

final class AddTaskSuccessState extends TasksState {}

final class AddTaskErrorState extends TasksState {}

final class SelectImageState extends TasksState {}
