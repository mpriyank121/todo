class Todo {
  int ? id;
  String  title;
  bool isChecked;
  Todo({this.id,required this.title, this.isChecked = false});

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title' : title,
      'isChecked' : isChecked ? 1:0,
    };
  }
  factory Todo.fromMap(Map<String, dynamic>map){
    return Todo(
      id: map['id'],
      title: map['title'],
      isChecked: map['isChecked']== 1,
    );
  }
}
