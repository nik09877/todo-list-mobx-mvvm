import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_mvvm_architecture_weather_app/view_model/todo_list.dart';
import 'package:provider/provider.dart';

class TodoExample extends StatelessWidget {
  const TodoExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Provider<TodoList>(
      create: (_) => TodoList(),
      child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Todos')),
            backgroundColor: Colors.teal,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                AddTodo(),
                const SizedBox(height: 10),
                const ActionBar(),
                const SizedBox(height: 10),
                const Description(),
                const SizedBox(height: 10),
                const TodoListView(),
              ],
            ),
          )));
}

class Description extends StatelessWidget {
  const Description({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<TodoList>(context);

    return Observer(
        builder: (_) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              list.itemsDescription,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )));
  }
}

class TodoListView extends StatelessWidget {
  const TodoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<TodoList>(context);

    return Observer(
        builder: (_) => Flexible(
              child: ListView.builder(
                  itemCount: list.visibleTodos.length,
                  itemBuilder: (_, index) {
                    final todo = list.visibleTodos[index];
                    return Observer(
                        builder: (_) => Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: todo.done,
                                onChanged: (flag) => todo.done = flag!,
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      todo.description,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => list.removeTodo(todo),
                                    )
                                  ],
                                ),
                              ),
                            ));
                  }),
            ));
  }
}

class ActionBar extends StatelessWidget {
  const ActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<TodoList>(context);

    return Column(children: <Widget>[
      Observer(
        builder: (_) {
          final selections = VisibilityFilter.values
              .map((f) => f == list.filter)
              .toList(growable: false);
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(8),
                  onPressed: (index) {
                    list.filter = VisibilityFilter.values[index];
                  },
                  isSelected: selections,
                  fillColor: Colors.teal,
                  selectedColor: Colors.white,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('All'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Pending'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Completed'),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
      const SizedBox(
        height: 10,
      ),
      Observer(
          builder: (_) => ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: list.canRemoveAllCompleted
                        ? list.removeCompleted
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          list.canRemoveAllCompleted ? Colors.red : Colors.grey,
                    ),
                    child: const Text('Remove Completed'),
                  ),
                  ElevatedButton(
                    onPressed: list.canMarkAllCompleted
                        ? list.markAllAsCompleted
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          list.canMarkAllCompleted ? Colors.green : Colors.grey,
                    ),
                    child: const Text('Mark All Completed'),
                  )
                ],
              ))
    ]);
  }
}

class AddTodo extends StatelessWidget {
  final _textController = TextEditingController(text: '');

  AddTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<TodoList>(context);

    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'Add a Todo',
        contentPadding: const EdgeInsets.all(8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            list.addTodo(_textController.text);
            _textController.clear();
          },
        ),
      ),
      controller: _textController,
      textInputAction: TextInputAction.done,
      onSubmitted: (String value) {
        list.addTodo(value);
        _textController.clear();
      },
    );
  }
}
