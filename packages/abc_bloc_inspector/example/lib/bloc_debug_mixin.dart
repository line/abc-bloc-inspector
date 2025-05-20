import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocDebugMixin<Event, State> on Bloc<Event, State> {
  late final void Function(Event event) _debugEventHandler;

  void setDebugEventHandler(
    void Function(Event event) handler,
  ) {
    _debugEventHandler = handler;
  }

  @override
  // ignore: must_call_super
  void onEvent(covariant Event event) {
    // ignore: invalid_use_of_protected_member
    if (event.runtimeType.toString().contains('EventForDebug')) {
      _debugEventHandler(event);
    } else {
      // ignore: invalid_use_of_protected_member
      super.onEvent(event);
    }
  }
}
