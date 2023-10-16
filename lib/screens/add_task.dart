import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  AddTask({Key? key, this.taskModel});

  final TaskModel? taskModel;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String? dropDownValue = "Pendiente";
  TextEditingController txtConName = TextEditingController();
  TextEditingController txtConDsc = TextEditingController();
  DateTime? selectedDate; // Fecha seleccionada
  List<String> dropDownValues = ['Pendiente', 'Completado', 'En proceso'];

  AgendaDB? agendaDB;
  DateTime? firstDay; // Fecha inicial
  DateTime? lastDay; // Fecha final
  DateTime? focusedDay; // Fecha enfocada

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
    firstDay = DateTime.now().subtract(Duration(days: 365));
    lastDay = DateTime.now().add(Duration(days: 365));
    focusedDay = DateTime.now();

    if (widget.taskModel != null) {
      txtConName.text = widget.taskModel!.nameTask!;
      txtConDsc.text = widget.taskModel!.dscTask!;
      selectedDate = widget.taskModel!.dateTask != null
          ? DateTime.parse(widget.taskModel!.dateTask!)
          : DateTime.now();
      switch (widget.taskModel!.sttTask) {
        case 'E':
          dropDownValue = "En proceso";
          break;
        case 'C':
          dropDownValue = "Completado";
          break;
        case 'P':
          dropDownValue = "Pendiente";
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtNameTask = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Tarea',
        border: OutlineInputBorder(),
      ),
      controller: txtConName,
    );

    final txtDscTask = TextField(
      decoration: const InputDecoration(
        labelText: 'Descripción',
        border: OutlineInputBorder(),
      ),
      maxLines: 6,
      controller: txtConDsc,
    );

    final space = SizedBox(
      height: 10,
    );

    final ddBStatus = DropdownButton(
      value: dropDownValue,
      items: dropDownValues
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      onChanged: (value) {
        setState(() {
          dropDownValue = value;
        });
      },
    );

    final calendar = TableCalendar(
      firstDay: firstDay!,
      lastDay: lastDay!,
      focusedDay: focusedDay!,
      selectedDayPredicate: (DateTime date) {
        // Esto marca el día seleccionado en el calendario
        return isSameDay(date, selectedDate);
      },
      onDaySelected: (DateTime date, DateTime focusedDay) {
        setState(() {
          selectedDate = date;
        });
      },
    );

    final btnGuardar = ElevatedButton(
      onPressed: () {
        if (widget.taskModel == null) {
          agendaDB!.INSERT('tblTareas', {
            'nameTask': txtConName.text,
            'dscTask': txtConDsc.text,
            'sttTask': dropDownValue!.substring(0, 1),
            'dateTask': selectedDate != null
                ? DateFormat('yyyy-MM-dd')
                    .format(selectedDate!) // Formatear la fecha
                : null,
          }).then((value) {
            var msj =
                (value > 0) ? 'La inserción fue exitosa!' : 'Ocurrió un error';
            var snackbar = SnackBar(content: Text(msj));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            Navigator.pop(context);
          });
        } else {
          agendaDB!.UPDATE('tblTareas', {
            'idTask': widget.taskModel!.idTask,
            'nameTask': txtConName.text,
            'dscTask': txtConDsc.text,
            'sttTask': dropDownValue!.substring(0, 1),
            'dateTask': selectedDate != null
                ? DateFormat('yyyy-MM-dd')
                    .format(selectedDate!) // Formatear la fecha
                : null,
          }).then((value) {
            GlobalValues.flagTask.value = !GlobalValues.flagTask.value;
            var msj = (value > 0)
                ? 'La actualización fue exitosa!'
                : 'Ocurrió un error';
            var snackbar = SnackBar(content: Text(msj));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            Navigator.pop(context);
          });
        }
      },
      child: Text('Guardar Tarea'),
    );

    return Scaffold(
      appBar: AppBar(
        title: widget.taskModel == null
            ? Text('Agregar Tarea')
            : Text('Actualizar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            txtNameTask,
            space,
            txtDscTask,
            space,
            calendar, // Reemplazamos el campo de fecha con el calendario
            space,
            ddBStatus,
            space,
            btnGuardar,
          ],
        ),
      ),
    );
  }
}
