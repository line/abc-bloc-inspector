part of 'stats_bloc.dart';

sealed class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object> get props => [];
}

final class StatsSubscriptionRequested extends StatsEvent {
  const StatsSubscriptionRequested();
}

// Add the new event class
final class StatsUpdated extends StatsEvent {
  const StatsUpdated();
}

final class StatsBlocEventForDebug extends StatsEvent {
  const StatsBlocEventForDebug(this.stateData);

  final Map<String, dynamic> stateData;

  Map<String, dynamic> toJson() => {
        'event': 'EventForDebug',
        'state': stateData,
      };
}
