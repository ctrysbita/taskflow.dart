part of '../taskflow.dart';

typedef ConditionFunc = Future<bool> Function();

/// The task executes only when given condition satisfied.
class ConditionalTask extends _Task {
  final ConditionFunc condition;

  ConditionalTask(
    this.condition,
    TaskFunc task, {
    Object? key,
  }) : super(task, key: key);

  @override
  Future<void> call(TaskFlowContext context) async {
    if (context.isCanceled || !await condition()) return;

    return super.call(context);
  }
}
