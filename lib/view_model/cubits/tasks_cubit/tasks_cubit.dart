import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_app_116/model/task_model.dart';
import 'package:task_app_116/view_model/data/firebase/firebase_keys.dart';
import 'package:task_app_116/view_model/data/local/shared_helper.dart';
import 'package:task_app_116/view_model/data/local/shared_keys.dart';
import 'package:task_app_116/view_model/data/network/dio_helper.dart';
import 'package:task_app_116/view_model/data/network/end_points.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  static TasksCubit get(context) => BlocProvider.of<TasksCubit>(context);

  List<Task> tasks = [];
  int page = 1;

  Future<void> getTasks() async {
    page = 1;
    emit(GetTasksLoadingState());
    await DioHelper.get(
      path: EndPoints.tasks,
      queryParameters: {
        'page': page,
      },
      withToken: true,
    ).then((value) {
      for (var i in value.data['data']['tasks']) {
        tasks.add(Task.fromJson(i));
      }
      page++;
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
    FormData formData = FormData.fromMap(
      {
        ...task.toJson(),
        if (image != null) 'image': await MultipartFile.fromFile(image!.path),
      },
    );
    await DioHelper.post(
      path: EndPoints.tasks,
      formData: formData,
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
    image = null;
  }

  void initData(int index) {
    titleController.text = tasks[index].title ?? '';
    descriptionController.text = tasks[index].description ?? '';
    startDateController.text = tasks[index].startDate ?? '';
    endDateController.text = tasks[index].endDate ?? '';
  }

  final ImagePicker picker = ImagePicker();
  XFile? image;

  void selectImage() async {
    image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    emit(SelectImageState());
  }

  ScrollController scrollController = ScrollController();

  void addScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        print('Bottom');
        getMoreTasks();
      }
    });
  }

  bool getMoreLoading = false;
  bool moreData = true;

  Future<void> getMoreTasks() async {
    if (getMoreLoading || !moreData) return;
    getMoreLoading = true;
    emit(GetMoreTasksLoadingState());
    await DioHelper.get(
      path: EndPoints.tasks,
      queryParameters: {
        'page': page,
      },
      withToken: true,
    ).then((value) {
      if (value.data['data']['tasks'].isEmpty) {
        moreData = false;
      } else {
        for (var i in value.data['data']['tasks']) {
          tasks.add(Task.fromJson(i));
        }
        page++;
      }
      getMoreLoading = false;
      emit(GetMoreTasksSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.statusCode == 401) {
          emit(UnauthenticatedState());
        }
        debugPrint(error.response?.data.toString());
        getMoreLoading = false;
        emit(GetMoreTasksErrorState(
            error.response?.data?.toString() ?? 'Error on Get Tasks'));
      }
      throw error;
    });
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addTaskFirebase() async {
    emit(AddTaskLoadingState());
    Task task = Task(
      title: titleController.text,
      description: descriptionController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      status: 'new',
    );
    if(image != null) {
      await uploadImageToFireStorage();
      task.image = imageUrl;
    }
    await db.collection(FirebaseKeys.tasks).add(task.toJson()).then((value) {
      emit(AddTaskSuccessState());
    }).catchError((error) {
      if (error is FirebaseException) {
        print(error.message ?? 'Error on Add Task');
      }
      emit(AddTaskErrorState());
    });
  }

  Future<void> getTasksFirebase() async {
    emit(GetTasksLoadingState());
    db
        .collection(FirebaseKeys.tasks)
        .where(FirebaseKeys.userUid,
            isEqualTo: SharedHelper.getData(SharedKeys.uid))
        .snapshots()
        .listen((value) {
      tasks.clear();
      for (var i in value.docs) {
        tasks.add(Task.fromJson(i.data())..id = i.id);
      }
      emit(GetTasksSuccessState());
    }, onError: (error) {
      if (error is FirebaseException) {
        print(error.message ?? 'Get Tasks FireBase');
      }
      emit(GetTasksErrorState(error.message ?? 'Get Tasks FireBase'));
    });
  }

  Future<void> editTaskFirebase(int index) async {
    emit(EditTaskLoadingState());
    Task task = Task(
      id: tasks[index].id,
      title: titleController.text,
      description: descriptionController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      status: tasks[index].status,
    );
    await db
        .collection(FirebaseKeys.tasks)
        .doc(tasks[index].id)
        .update(task.toJson())
        .then((value) {
      emit(EditTaskSuccessState());
    }).catchError((error) {
      if (error is FirebaseException) {
        print(error.message ?? 'Error on Add Task');
      }
      emit(EditTaskErrorState());
    });
  }

  Future<void> deleteTaskFirebase(int index) async {
    emit(DeleteTaskLoadingState());
    await db
        .collection(FirebaseKeys.tasks)
        .doc(tasks[index].id)
        .delete()
        .then((value) {
      emit(DeleteTaskSuccessState());
    }).catchError((error) {
      if (error is FirebaseException) {
        print(error.message ?? 'Error on Add Task');
      }
      emit(DeleteTaskErrorState());
    });
  }

  String imageUrl = '';

  Future<String> uploadImageToFireStorage() async {
    if(image == null) return '';
    emit(UploadImageToFireStorageLoadingState());
    await storage.FirebaseStorage.instance
        .ref()
        .child('${FirebaseKeys.tasks}/${DateTime.now().toString()}.jpg')
        .putFile(
          File(image?.path ?? ''),
        )
        .then((value) async {
      imageUrl = await value.ref.getDownloadURL();
      print(imageUrl);
      emit(UploadImageToFireStorageSuccessState());
      return imageUrl;
      // .then((value) {
      // print(value);
      // emit(UploadImageToFireStorageSuccessState());
      // return value;
      // }).catchError((error) {
      // if (error is FirebaseException) {
      // print(error.message ?? 'Error on Upload Image');
      // }
      // emit(UploadImageToFireStorageErrorState());
      // return null;
      // })
    }).catchError((error) {
      if (error is FirebaseException) {
        print(error.message ?? 'Error on Upload Image');
      }
      emit(UploadImageToFireStorageErrorState());
      return '';
    });
    return '';
  }
}
