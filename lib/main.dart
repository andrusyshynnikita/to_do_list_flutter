import 'package:flutter/material.dart';
import 'package:to_do_list_flutter/Models/TaskModel.dart';

import 'Views/TaskDeteils.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'To Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TaskModel> _tasksList = [];

  void _addToDoItem(TaskModel task) {
    setState(() {
      _tasksList.add(task);
    });
  }

  void _changeTaskStatus(int index) {
    setState(() {
      _tasksList[index].isComplete = !_tasksList[index].isComplete;
    });
  }

  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < _tasksList.length) {
          return _buildTodoItem(context, _tasksList[index], index);
        }
      },
    );
  }

  Widget _buildTodoItem(BuildContext context, TaskModel task, int index) {
    return new Dismissible(
        key: Key(task.title),
        onDismissed: (directody) {
          setState(() {
            _tasksList.removeAt(index);
          });
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("$task.title dismissed")));
        },
        background: Container(color: Colors.red),
        child: new ListTile(
          title: new Text(task.title),
          trailing: new IconButton(
            icon: _tasksList[index].isComplete
                ? Icon(Icons.check_box)
                : Icon(Icons.indeterminate_check_box),
            color: _tasksList[index].isComplete ? Colors.green : Colors.red,
            onPressed: () {
              _changeTaskStatus(index);
            },
          ),
          onTap: () => _pushAddTodoScreen(index: index),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              setState(() {
                _pushAddTodoScreen(isNewTask: true);
              });
            })
      ]),
      body: _buildTodoList(),
    );
  }

  _pushAddTodoScreen({bool isNewTask = false, int index}) async {
    final result = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
              task: (!isNewTask && _tasksList[index] != null)
                  ? _tasksList[index]
                  : TaskModel(),
            )));

    if (result != null && (_tasksList.length == 0 || index == null)) {
      _tasksList.add(result);
    }
    if (result != null && _tasksList[index] != null) {
      _tasksList[index] = result;
    }
  }
}
