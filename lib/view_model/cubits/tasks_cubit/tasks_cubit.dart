import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_app_116/model/task_model.dart';
import 'package:task_app_116/view_model/data/network/dio_helper.dart';
import 'package:task_app_116/view_model/data/network/end_points.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  static TasksCubit get(context) => BlocProvider.of<TasksCubit>(context);

  List<Task> tasks = [];

  Future<void> getTasks() async {
    emit(GetTasksLoadingState());
    await DioHelper.get(
      path: EndPoints.tasks,
      withToken: true,
    ).then((value) {
      tasks.clear();
      for (var i in value.data['data']['tasks']) {
        tasks.add(Task.fromJson(i));
      }
      emit(GetTasksSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 401) {
          emit(UnauthenticatedState());
        }
        debugPrint(error.response?.data.toString());
        emit(GetTasksErrorState(
            error.response?.data?.toString() ?? 'Error on Get Tasks'));
      }
      throw error;
    });
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  Future<void> addTask() async {
    emit(AddTaskLoadingState());
    Task task = Task(
      title: titleController.text,
      description: descriptionController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      status: 'new',
    );
    await DioHelper.post(
      path: EndPoints.tasks,
      body: task.toJson(),
    ).then((value) {
      print(value.data);
      tasks.insert(0, Task.fromJson(value.data['data']));
      clearData();
      emit(AddTaskSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        print(error.response?.data);
      }
      emit(AddTaskErrorState());
      throw error;
    });
  }

  void clearData() {
    titleController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();
  }

  final ImagePicker picker = ImagePicker();
  XFile? image;

  void selectImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    emit(SelectImageState());
  }
}
