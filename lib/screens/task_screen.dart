import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:pmsn20232/widgets/CardTaskWidget.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  AgendaDB? agendaDB;
  TextEditingController searchController = TextEditingController();
  String? dropdownValue; // Opción predeterminada

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
    dropdownValue = 'Todos'; // Establecer la opción predeterminada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          if (GlobalValues.userType == 2)
            IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/add').then((value) {
                setState(() {});
              }),
              icon: Icon(Icons.task),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                // Agrega una lógica de retraso (debounce) para la búsqueda
                // para evitar solicitudes excesivas de filtrado.
                Timer(const Duration(milliseconds: 500), () {
                  setState(() {});
                });
              },
              decoration: InputDecoration(
                hintText: 'Search tasks',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          DropdownButton<String>(
            value: dropdownValue,
            items: ['Todos', 'Pendiente', 'Completado', 'En proceso']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                dropdownValue = value;
              });
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: agendaDB!.GETALLTASK(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TaskModel>> snapshot) {
                if (snapshot.hasData) {
                  var filteredTasks = snapshot.data!;

                  if (dropdownValue == 'Completado') {
                    filteredTasks = filteredTasks
                        .where((task) => task.sttTask == 'C')
                        .toList();
                  } else if (dropdownValue == 'En proceso') {
                    filteredTasks = filteredTasks
                        .where((task) => task.sttTask == 'E')
                        .toList();
                  } else if (dropdownValue == 'Pendiente') {
                    filteredTasks = filteredTasks
                        .where((task) => task.sttTask == 'P')
                        .toList();
                  }

                  if (searchController.text.isNotEmpty) {
                    filteredTasks = filteredTasks
                        .where((task) =>
                            task.nameTask != null &&
                            task.nameTask!
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase()))
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardTaskWidget(
                        taskModel: filteredTasks[index],
                        agendaDB: agendaDB,
                      );
                    },
                  );
                } else {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error!'),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
