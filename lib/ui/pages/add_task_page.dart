import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final TaskController _taskController=Get.put(TaskController());
  final TextEditingController _titleController=TextEditingController();
  final TextEditingController _noteController=TextEditingController();

   DateTime _selectedDate=DateTime.now();
   String _startTime=DateFormat('hh:mm a').format(DateTime.now()).toString();
   String _endTime=DateFormat('hh:mm a').format(DateTime.now().add(const Duration(minutes: 15))).toString();

  int _selectedRemind=5;
  List<int> remindList=[5,10,15,20];
  String _selectedRepeat ='None';
  List<String> repeatList=['None','Daily','Weekly','Monthly'];
  int _selectedColor=0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appbar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Add Task',style: headingStyle,),
              InputField(title: 'Title',hint: 'Enter title',controller:_titleController),
              InputField(title: 'Note',hint: 'Enter note',controller:_noteController),
              InputField(title: 'Date',hint: DateFormat.yMd().format(_selectedDate),widget: IconButton(
                onPressed: ()=>_getDateFromUser(),
                icon: const Icon(Icons.calendar_today_outlined),
                color:Colors.grey ,
              ),
              ),
              Row(
                children: [
                  Expanded(child: InputField(title: 'Start time',hint: _startTime,widget: IconButton(
                    onPressed: ()=>_getTimeFromUser(isStartTime: true),
                    icon: const Icon(Icons.access_time),
                    color:Colors.grey ,
                  ),)),
                  const SizedBox(width: 12,),
                  Expanded(child: InputField(title: 'End time',hint: _endTime,widget: IconButton(
                    onPressed: ()=>_getTimeFromUser(isStartTime: false),
                    icon: const Icon(Icons.access_time),
                    color:Colors.grey ,
                  ),)),
                ],
              ),
              InputField(title: 'Remind',hint: '$_selectedRemind minutes early',widget:Row(
                children: [
                  DropdownButton(
                    dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(15),
                    onChanged: (int? newval){
                      setState(() {
                        _selectedRemind=newval!;
                      });
                    },
                      icon: const Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(height: 0,),
                      style: subtitleStyle,
                    items: remindList.map((value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value',style:
                        const TextStyle(color: Colors.white),
                        ),
                    ),
                    ).toList()
                  ),
                  const SizedBox(width: 6,)
                ],
              )),
              InputField(title: 'Repeat',hint: _selectedRepeat ,widget:Row(
                children: [
                  DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(15),
                      onChanged: (String? newval){
                        setState(() {
                          _selectedRepeat=newval!;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(height: 0,),
                      style: subtitleStyle,
                      items: repeatList.map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value,style:
                        const TextStyle(color: Colors.white),
                        ),
                      ),
                      ).toList()
                  ),
                  const SizedBox(width: 6,)
                ],
              )),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(label: 'Create Task', onTap: (){
                    _validateDate();
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      actions:const [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(width: 20,)
      ],
      centerTitle: true,
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: IconButton(
        onPressed: ()=>Get.back(),
        icon: const Icon(Icons.arrow_back_ios_new,size: 24,color: primaryClr,),
      ),
    );
  }

  _addTasksToDb() async {
    try {
      //print('here is the selected month ${_selectedDate.month}');
      //print('here is the selected day ${_selectedDate.day}');
      int value = await _taskController.addTask(
        task: Task(
          title: _titleController.text,
          note: _noteController.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
        ),
      );
      print('id value = $value');
    } catch (e) {
      print('Error = $e');
    }
  }

  _validateDate() {
    FocusScope.of(context).unfocus();
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'required',
        'All fields are required!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    } else
      print('############ SOMETHING BAD HAPPENED #################');
  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: titleStyle),
        const SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(
            3,
                (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                      ? pinkClr
                      : orangeClr,
                  radius: 14,
                  child: _selectedColor == index
                      ? const Icon(Icons.done, size: 16, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null)
      setState(() => _selectedDate = pickedDate);
    else
      print('It\'s null or something is wrong');
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
    );
    String formattedTime = pickedTime!.format(context);
    if (isStartTime)
      setState(() => _startTime = formattedTime);
    else if (!isStartTime)
      setState(() => _endTime = formattedTime);
    else
      print('time canceled or something is wrong');
  }
}
