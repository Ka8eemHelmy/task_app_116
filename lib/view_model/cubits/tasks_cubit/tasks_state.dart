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

final class GetMoreTasksLoadingState extends TasksState {}

final class GetMoreTasksSuccessState extends TasksState {}

final class GetMoreTasksErrorState extends TasksState {
  final String msg;

  GetMoreTasksErrorState(this.msg);
}

final class EditTaskLoadingState extends TasksState {}

final class EditTaskSuccessState extends TasksState {}

final class EditTaskErrorState extends TasksState {}

final class DeleteTaskLoadingState extends TasksState {}

final class DeleteTaskSuccessState extends TasksState {}

final class DeleteTaskErrorState extends TasksState {}

final class UploadImageToFireStorageLoadingState extends TasksState {}

final class UploadImageToFireStorageSuccessState extends TasksState {}

final class UploadImageToFireStorageErrorState extends TasksState {}