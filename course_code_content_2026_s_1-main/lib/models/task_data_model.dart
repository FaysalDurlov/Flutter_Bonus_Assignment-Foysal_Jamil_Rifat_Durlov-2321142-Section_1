class TaskDataModel {
    String id;
    String title;
    String discreption;
    String password;
    String assignedTo;
    String createdAt;
    String number;

    TaskDataModel({
        required this.id,
        required this.title,
        required this.discreption,
        required this.password,
        required this.assignedTo,
        required this.createdAt,
        required this.number,
    });

    factory TaskDataModel.fromJson(
      Map<String, dynamic> json,
      String id,
    ) {
      return TaskDataModel(
        id: id,
        title: json["title"],
        discreption: json["discreption"],
        password: json["password"],
        assignedTo: json["assigned_to"],
        createdAt: json["created_at"],
        number: json["number"],
      );
    }

    Map<String, dynamic> toJson() => {
        "title": title,
        "discreption": discreption,
        "password": password,
        "assigned_to": assignedTo,
        "created_at": createdAt,
        "number": number,
    };
}
