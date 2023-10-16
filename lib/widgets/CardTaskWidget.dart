import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:pmsn20232/screens/add_task.dart';

class CardTaskWidget extends StatelessWidget {
  CardTaskWidget({Key? key, required this.taskModel, this.agendaDB});

  final TaskModel taskModel;
  final AgendaDB? agendaDB;

  // Función para obtener el color de fondo basado en el estado de la tarea
  Color getBackgroundColor() {
    final taskStatus = taskModel.sttTask ?? '';

    switch (taskStatus) {
      case 'C':
        return Colors.green;
      case 'E':
        return Colors.yellow;
      case 'P':
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: getBackgroundColor(),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(taskModel.nameTask ?? ''),
                  Text(taskModel.dscTask ?? ''),
                ],
              ),
              Text(
                taskModel.dateTask ?? '', // Mostrar la fecha
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTask(taskModel: taskModel),
                  ),
                ),
                child: Image.asset('assets/naranja.png', height: 50),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Mensaje del sistema'),
                        content: Text('¿Deseas borrar la tarea?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              agendaDB!
                                  .DELETE('tblTareas', taskModel.idTask!)
                                  .then((value) {
                                Navigator.pop(context);
                                GlobalValues.flagTask.value =
                                    !GlobalValues.flagTask.value;
                              });
                            },
                            child: Text('Si'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('No'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
