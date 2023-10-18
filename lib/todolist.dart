import 'package:flutter/material.dart';
class Task {
  String title;
  bool isCompleted;
  Task(this.title, this.isCompleted);
}
class TodoListAnimation extends StatefulWidget {
  const TodoListAnimation({Key? key}) : super(key: key);

  @override
  State<TodoListAnimation> createState() => _TodoListAnimationState();
}

class _TodoListAnimationState extends State<TodoListAnimation> {
  List<Task> tasks = [];
  bool isLoading = false;
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
       appBar: AppBar(
         title: Text("Todo List"),
       ),
      body: Stack(
        children: [
          AnimatedList(
            key: _animatedListKey,
            initialItemCount: tasks.length,
            itemBuilder: (context, index, animation) {
              return _buildTaskItem(tasks[index], animation, index);
            },

          ),
          if (isLoading)
            const Opacity(
              opacity: 0,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (isLoading)
            Center(
              child: Center(child: AnimatedLoader()),
            ),
        ],
      )
    );
  }

  Widget AnimatedLoader(){
    return CircularProgressIndicator(
      color: Colors.red,
    );
  }
  void _addTask() async {
    Task newTask = Task('New Task ${tasks.length + 1}', false);
    await loadData();
    tasks.add(newTask);
    _animatedListKey.currentState!.insertItem(tasks.length - 1);
  }

  void _removeTask(int index) async {
    await loadData();
    _animatedListKey.currentState!.removeItem(index,
            (context, animation) => _buildTaskItem(tasks[index], animation, index));
    tasks.removeAt(index);
  }

  Widget _buildTaskItem(Task task, Animation<double> animation, int index) {
    return SizeTransition(
        sizeFactor: animation,
        child: Card(
          color: Colors.white,
          child: ListTile(
            title: Text(task.title),
            onTap: () => _removeTask(index),
          ),
        ));
  }
}
