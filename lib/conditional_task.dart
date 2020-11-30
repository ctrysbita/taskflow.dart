part of 'taskflow.dart';

/// The task executes only when given condition satisfied.
class ConditionalTask extends _Task {
  Future<bool> Function() condition;

  ConditionalTask(
    this.condition,
    TaskFunc task, {
    Object? key,
  }) : super(task, key: key);

  @override
  Future<TaskResult> call(TaskFlowContext context) async {
    if (context.isCanceled) return TaskResult.canceled();
    if (!await condition()) return TaskResult.skipped();

    return super(context);
  }
}
