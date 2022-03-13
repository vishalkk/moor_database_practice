import 'package:flutter/material.dart';
import 'package:moor_database_practice/data/moor_database.dart';
import 'package:provider/provider.dart';

class NewTaskInput extends StatefulWidget {
  const NewTaskInput({Key? key}) : super(key: key);

  @override
  State<NewTaskInput> createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  late DateTime? newTaskDate;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
        _buildTextField(context),
        _buildDateButton(context),
      ]),
    );
  }

  Expanded _buildTextField(BuildContext context) {
    return Expanded(
        child: TextField(
      controller: controller,
      decoration: InputDecoration(hintText: 'Task Name'),
      onSubmitted: (inputName) {
        final database = Provider.of<AppDatabase>(context);
        final task = Task(name: inputName, dueDate: newTaskDate);
        database.insertTask(task);
        resetValuesAfterSubmit();
      },
    ));
  }

  IconButton _buildDateButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        newTaskDate = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2010),
            lastDate: DateTime(2050)));
      },
    );
  }

  void resetValuesAfterSubmit() {
    setState(() {
      newTaskDate = null;
      controller.clear();
    });
  }
}
