part of 'taskflow.dart';

enum TaskFlowState {
  ok,
  canceled,
}

/// Context that shared by all tasks in a flow.
class TaskFlowContext {
  final Map<Object, Future<TaskResult>> _runningTasks = {};
  final Map<Object, TaskResult> _finishedTasks = {};

  TaskFlowState get state => _state;
  TaskFlowState _state = TaskFlowState.ok;

  void markAsRunning(Task task, Future<TaskResult> future) {
    assert(
      !_runningTasks.containsKey(task.key),
      'Duplicated task key detected',
    );
    _runningTasks[task.key] = future;
  }

  void markAsCompleted(Task task, TaskResult result) {
    _runningTasks.remove(task.key);
    _finishedTasks[task.key] = result;
  }

  bool get isCanceled => _state == TaskFlowState.canceled;
  void cancel() {
    _state = TaskFlowState.canceled;
  }

  TaskResult? resultOf(Object key) => _finishedTasks[key];
}
