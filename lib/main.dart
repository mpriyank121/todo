import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'DB_helper.dart';
import 'to_do_model.dart';


void main() {
  // Initialize FFI

  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
   List<Todo> _prince = [];
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }
   Future<void> _toggleCheckbox(int index) async {
     final task = _prince[index];
     task.isChecked = !task.isChecked;
     await DB_helper.instance.updateTask(task);
     _loadTasks();
   }

   // Fetch tasks from database
  Future<void> _loadTasks() async {
    final tasks = await DB_helper.instance.fetchTasks();
    setState(() {
      _prince = tasks;
    });
  }

Future<void> _delbutton(int index)async{
final task = _prince[index];
if (task.id != null){
  await DB_helper.instance.deleteTask(task.id!);
   _loadTasks();
}
}
void _deleteDialog(int index){
    showDialog(context: context, builder: (context){
      return AlertDialog(
          title: Text('Are you sure You want to Delete?'),
          
          actions: [


            TextButton(onPressed: (){
      Navigator.of(context).pop();
                },

                child: Text('No')),

          TextButton(
          onPressed: () {
        _delbutton(index);
        Navigator.of(context).pop();// Close the dialog
      },
      child: Text("Yes"),
      ),
      ]
      );
    }
    );
}

  void _showInputDialog() {
    TextEditingController controller = TextEditingController();

    showGeneralDialog(
       context: context,

      transitionDuration: const Duration(milliseconds: 300), // Animation duration

      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(

          insetPadding: EdgeInsets.zero,
          alignment: Alignment.bottomCenter,
          child: Container(


            height:MediaQuery.of(context).size.height * 0.7 ,// 70% of screen width
            padding: EdgeInsets.all(50),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: Column(
                children:  [
                  Text("Add New Task"),
                  Padding(padding: EdgeInsets.only(top: 10,bottom: 10),
                    child:
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: "Enter task..."),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async{


                      if (controller.text.isNotEmpty) {

                        final newTask = Todo(title: controller.text, isChecked: false);
                        await DB_helper.instance.insertTask(newTask);  // ✅ Insert into DB
                        _loadTasks();  // ✅ Reload from DB
                      }
                      Navigator.of(context).pop(); // Close dialog
                      Fluttertoast.showToast(
                        msg: "Task Added Successfully!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM, // Change to CENTER
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                      );
                    },
                    child: const Text("Save"),
                  ),

                ],

              ),
            ),
          ),
        );

      },


    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('To-Do List'),
      actions:[ IconButton(
        icon: Icon(Icons.add),
        onPressed: _showInputDialog,
      )],
    ),
      body:Container(
        margin: EdgeInsets.all(10),
        child:  Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _prince.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                       leading: Checkbox(

                        activeColor: Colors.green,
                        value: _prince[index].isChecked,

                        onChanged: (value) => _toggleCheckbox(index) ,
                      ),

                        title:

                        Text(_prince[index].title,
                        style:TextStyle(
                    decoration: _prince[index].isChecked
                    ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                        ),
                        trailing:IconButton(onPressed: () =>_deleteDialog(index),

                            icon: Icon(Icons.delete)),



                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                    ),


                    );
                  }
              )

          )
        ],
      ),
    )
    );
  }
  }