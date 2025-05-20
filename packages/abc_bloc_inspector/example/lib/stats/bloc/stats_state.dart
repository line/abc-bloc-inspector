part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

final class StatsState extends Equatable {
  const StatsState({
    this.status = StatsStatus.initial,
    this.completedTodos = 0,
    this.activeTodos = 0,
  });

  factory StatsState.fromJson(Map<String, dynamic> json) => StatsState(
        status: StatsStatus.values
            .firstWhere((e) => e.toString() == 'StatsStatus.${json['status']}'),
        completedTodos: json['completedTodos'] as int,
        activeTodos: json['activeTodos'] as int,
      );

  final StatsStatus status;
  final int completedTodos;
  final int activeTodos;

  @override
  List<Object> get props => [status, completedTodos, activeTodos];

  StatsState copyWith({
    StatsStatus? status,
    int? completedTodos,
    int? activeTodos,
  }) =>
      StatsState(
        status: status ?? this.status,
        completedTodos: completedTodos ?? this.completedTodos,
        activeTodos: activeTodos ?? this.activeTodos,
      );

  Map<String, dynamic> toJson() => {
        'status': status.toString().split('.').last,
        'completedTodos': completedTodos,
        'activeTodos': activeTodos,
      };
}
