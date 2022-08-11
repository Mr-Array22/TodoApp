import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {

  final RxList<Task> taskList = <Task>[].obs;


  Future<int> addTask({Task? task}){
    return DBHelper.insert(task);
  }

  //get data from database
  Future<void> getTask()async{
    final List<Map<String,dynamic>> tasks= await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  //delete data from database
  void deleteTask(Task task)async{
    await DBHelper.delete(task);
    getTask();
  }

  void deleteAllTask()async{
    await DBHelper.deleteAll();
    getTask();
  }


  //update data from database
  void markUsCompleted(int id)async{

    await DBHelper.update(id);
    getTask();
  }


}
