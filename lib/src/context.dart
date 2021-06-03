part of '../taskflow.dart';

/// Context that shared by all tasks in a flow.
class TaskFlowContext {
  final Map<Object, Future<void>> _runningTasks = {};
  final Set<Object> _finishedTasks = {};

  /// Flow cancellation flag.
  bool _canceled = false;
  bool get isCanceled => _canceled;
  void cancel() {
    _canceled = true;
  }

  void markAsRunning(Task task, Future<void> future) {
    assert(
      !_runningTasks.containsKey(task.key),
      'The task is already running. '
      'Please check if you are using same key for more than one tasks.',
    );
    _runningTasks[task.key] = future;
  }

  void markAsFinished(Task task) {
    _runningTasks.remove(task.key);
    _finishedTasks.add(task.key);
  }

  bool isFinished(Object key) {
    return _finishedTasks.contains(key);
  }
}
