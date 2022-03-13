import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moor_database_practice/data/moor_database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildTaskList(context)),
          //NewTaskInput(),
        ],
      ),
    );
  }

  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    return StreamBuilder(
        stream: database.watchAllTask(),
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
          final task = snapshot.data ?? [];
          return ListView.builder(
              itemCount: task.length,
              itemBuilder: (_, index) {
                final itemTask = task[index];

                return _buildListItem(itemTask, database);
              });
        });
  }

  Widget _buildListItem(Task itemTask, AppDatabase database) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            label: 'Archive',
            backgroundColor: Colors.blue,
            icon: Icons.archive,
            onPressed: (context) {
              database.deleteTask(itemTask);
            },
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            label: 'Delete',
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (context) {
              database.deleteTask(itemTask);
            },
          ),
        ],
      ),
      child: CheckboxListTile(
        title: Text(itemTask.name),
        subtitle: Text(itemTask.dueDate?.toString() ?? " No date"),
        value: itemTask.completed,
        onChanged: (newValue) {
          database.updateTask(itemTask.copyWith(completed: newValue));
        },
      ),
    );
  }
}
