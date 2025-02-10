import 'package:flutter/material.dart';

void main() {
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
  final List<Map<String, dynamic>> _prince = [];
  void _toggleCheckbox(int index, bool? value) {

    setState(() {
      _prince[index]['isChecked'] = value ?? false;
    });
  }


void _delbutton(int index){

    setState(() {
      _prince.removeAt(index);

    });
  
}

  void _showInputDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(

            alignment: Alignment.bottomCenter,
            child: Container(

          width: MediaQuery.of(context).size.width * 0.7,
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
                  onPressed: () {

                    if (controller.text.isNotEmpty) {

                      setState(() {
                        _prince.add(({'title': controller.text, 'isChecked': false}));
                      });
                    }
                    Navigator.of(context).pop(); // Close dialog
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
                        value: _prince[index]['isChecked'],
                        onChanged: (value) => _toggleCheckbox(index, value),
                      ),

                        title: Text(_prince[index]['title']),
                        trailing:IconButton(onPressed: () =>_delbutton(index),

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