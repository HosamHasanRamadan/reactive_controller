part of 'reactive.dart';

class ReactiveDouble extends ReactiveValueNotifier<double> {
  ReactiveDouble(
    ReactiveControllerHost host, {
    required double initialValue,
    OnChanged<double>? onChange,
    bool updateHost = true,
  }) : super(
          host,
          initialValue: initialValue,
          onChanged: onChange,
          updateHost: updateHost,
        );
}

class ReactiveInt extends ReactiveValueNotifier<int> {
  ReactiveInt(
    ReactiveControllerHost host, {
    required int initialValue,
    OnChanged<int>? onChange,
    bool updateHost = true,
  }) : super(
          host,
          initialValue: initialValue,
          onChanged: onChange,
          updateHost: updateHost,
        );
}

class ReactiveBool extends ReactiveValueNotifier<bool> {
  ReactiveBool(
    ReactiveControllerHost host, {
    required bool initialValue,
    OnChanged<bool>? onChange,
    bool updateHost = true,
  }) : super(
          host,
          initialValue: initialValue,
          onChanged: onChange,
          updateHost: updateHost,
        );
}

class ReactiveString extends ReactiveValueNotifier<String> {
  ReactiveString(
    ReactiveControllerHost host, {
    required String initialValue,
    OnChanged<String>? onChange,
    bool updateHost = true,
  }) : super(
          host,
          initialValue: initialValue,
          onChanged: onChange,
          updateHost: updateHost,
        );
}
