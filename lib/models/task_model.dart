class TaskModel {
  int? idTask;
  String? nameTask;
  String? dscTask;
  String? sttTask;
  String? dateTask; // Agregar el campo de fecha

  TaskModel(
      {this.sttTask,
      this.idTask,
      this.nameTask,
      this.dscTask,
      this.dateTask}); // Añadir el campo de fecha al constructor

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      idTask: map['idTask'],
      dscTask: map['dscTask'],
      nameTask: map['nameTask'],
      sttTask: map['sttTask'],
      dateTask: map['dateTask'], // Obtener la fecha desde el mapa
    );
  }
}
