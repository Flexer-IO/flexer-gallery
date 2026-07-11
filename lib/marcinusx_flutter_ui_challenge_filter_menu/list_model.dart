import 'task.dart';
import 'task_row.dart';
import 'package:flutter/material.dart';

class ListModel {
  ListModel(this.listKey, List<Task> items) : items = List.of(items);

  final GlobalKey<AnimatedListState> listKey;
  final List<Task> items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void insert(int index, Task item) {
    items.insert(index, item);
    _animatedList?.insertItem(index, duration: const Duration(milliseconds: 150));
  }

  Task removeAt(int index) {
    final Task removedItem = items.removeAt(index);
    _animatedList?.removeItem(
      index,
      (context, animation) => TaskRow(
        task: removedItem,
        animation: animation,
      ),
      duration: Duration(milliseconds: (150 + 200 * (index / length)).toInt()),
    );
    return removedItem;
  }

  int get length => items.length;

  Task operator [](int index) => items[index];

  int indexOf(Task item) => items.indexOf(item);
}