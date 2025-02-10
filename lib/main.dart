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
  final List<String> _prince = [];
  final TextEditingController _controller = TextEditingController();


  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _prince.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('-Do List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Enter a task'),
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                itemCount: _prince.length,
                itemBuilder: (context,index){
                  return ListTile(

                    title: Text(_prince[index]),
                  );
                }
              )

          )
        ],
      ),
    );
  }
}
