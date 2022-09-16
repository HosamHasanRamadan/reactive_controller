part of 'reactive.dart';

class ReactiveDouble extends ReactiveValue<double> {
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

class ReactiveInt extends ReactiveValue<int> {
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

class ReactiveBool extends ReactiveValue<bool> {
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

class ReactiveString extends ReactiveValue<String> {
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

class ReactiveValue<T> extends ReactiveController {
  ReactiveValue(
    ReactiveControllerHost host, {
    required T initialValue,
    OnChanged<T>? onChanged,
    bool updateHost = true,
  })  : _updateHost = updateHost,
        _onChanged = onChanged,
        super(host) {
    _value = initialValue;
  }
  late T _value;
  final OnChanged<T>? _onChanged;
  final bool _updateHost;

  T get value => _value;
  set value(T newValue) {
    if (newValue == _value) return;
    final prev = _value;
    _value = newValue;
    _onChanged?.call(prev, _value);

    if (_updateHost) {
      host.requestUpdate();
    }
  }
}
