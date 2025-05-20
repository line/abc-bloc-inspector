# ABC Bloc Inspector

The ABC Bloc Inspector is a Flutter package that aids in debugging by providing advanced tools like `AbcBlocInspectorObserver` for tracking state changes in DevTools, and `StateReplayBloc` for directly overwriting state with a `Map`. These features assist in tracking state and mocking state in the DevTools extension, providing a robust environment for testing and debugging.

## Features

- **DevTools Integration**: Track state changes using `AbcBlocInspectorObserver` in the DevTools Extension.
- **Direct State Overwrite**: Use `StateReplayBloc` to overwrite state directly with a `Map` without needing events.

## Getting Started

To start using Bloc Tool in your Flutter project, add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  abc_bloc_inspector: ^1.0.0
```

Ensure you have the Flutter SDK installed and configured on your machine. For more information on setting up Flutter, visit the [official Flutter website](https://flutter.dev).

## Usage

Bloc Tool provides `AbcBlocInspectorObserver` and `StateReplayBloc` to enhance your Flutter applications with advanced state management capabilities.

### AbcBlocInspectorObserver

`AbcBlocInspectorObserver` is used to monitor state changes in your bloc instances. It can be helpful for debugging and logging purposes.
To use ABC Bloc Inspector, should register `AbcBlocInspectorObserver` with `Bloc.observer`.
To effectively track state changes, ensure that your state objects implement a `toJson` method.

```dart
import 'package:abc_bloc_inspector/abc_bloc_inspector.dart';
import 'package:bloc/bloc.dart';

void main() {
  Bloc.observer = AbcBlocInspectorObserver();
  // Run your app
}
```

### StateReplayBloc

`StateReplayBloc` extends the standard bloc with additional functionality for state overwrite It is primarily used in the ABC bloc inspector devtools extension to change states. You can provide a `Map` representing the state you wish to overwrite.


```dart
import 'package:abc_bloc_inspector/abc_bloc_inspector.dart';

abstract class CounterEvent {}

class Increment extends CounterEvent {}

class Decrement extends CounterEvent {}

class CounterState {
  final int value;

  CounterState(this.value);

  factory CounterState.fromMap(Map<String, dynamic> map) =>
      CounterState(map['value'] as int);


  Map<String, dynamic> toJson() => {'value': value};
}

class CounterBloc extends StateReplayBloc<CounterEvent, CounterState> {
  CounterBloc()
      : super(
          CounterState(0),
          stateConverter: CounterState.fromMap,
        ) {
    on<Increment>((event, emit) => emit(CounterState(state.value + 1)));
    on<Decrement>((event, emit) => emit(CounterState(state.value - 1)));
  }
}

// Example of using applyState
void main() {
  final bloc = CounterBloc();
  bloc.applyState({'value': 10}); // Apply a specific state using a Map
  print(bloc.state.value); // Outputs: 10
}
```

For more detailed examples and documentation, please refer to the `/example` directory.

## Contributing Guidelines

For more information, contributions, or to report issues, please read the [contributing guidelines](CONTRIBUTING.md). We welcome contributions and feedback from the community to improve and expand the capabilities of Bloc Tool.

## License

See the [LICENSE](LICENSE) file for more details.
