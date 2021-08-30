import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _toDoController = TextEditingController();

  List _toDoList = [];

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
      _toDoList = json.decode(data);
      });
    });
  }

  void _addToList() {
    setState(() {
      Map<String, dynamic> newTask = Map();

      newTask['title'] = _toDoController.text;
      _toDoController.text = '';

      newTask['done'] = false;

      _toDoList.add(newTask);

      _saveData();
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();

    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      throw Exception('Error reading data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDoList'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17, 4, 7, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                      labelText: 'New Task',
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => _addToList(),
                    child: Text('Add'),
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 8),
              itemCount: _toDoList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_toDoList[index]['title']),
                  value: _toDoList[index]['done'],
                  secondary: CircleAvatar(
                    child: Icon(
                        _toDoList[index]['done'] ? Icons.check : Icons.error),
                  ),
                  onChanged: (bool? value) {
                    setState(() {
                      _toDoList[index]['done'] = value;
                      _saveData();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
