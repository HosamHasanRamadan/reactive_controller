part of 'reactive.dart';

class ReactiveListenable<T extends Listenable> extends ReactiveController {
  final T _listenable;
  final bool _updateHost;

  ReactiveListenable(
    ReactiveControllerHost host, {
    required T listenable,
    bool updateHost = false,
  })  : _updateHost = updateHost,
        _listenable = listenable,
        super(host) {
    if (_updateHost) _listenable.addListener(host.requestUpdate);
  }

  @override
  void dispose() {
    if (_updateHost) _listenable.removeListener(host.requestUpdate);
    super.dispose();
  }
}

class ReactiveValueListenable<T> extends ReactiveController {
  final ValueListenable<T> _valueListenable;

  ValueListenable<T> get valueListenable => _valueListenable;
  T get value => _valueListenable.value;

  final OnChanged<T>? _onChanged;
  T? _previousValue;

  final bool _updateHost;

  ReactiveValueListenable(
    ReactiveControllerHost host, {
    required ValueListenable<T> valueListenable,
    bool updateHost = true,
    OnChanged<T>? onChanged,
  })  : _onChanged = onChanged,
        _valueListenable = valueListenable,
        _updateHost = updateHost,
        super(host) {
    _previousValue = valueListenable.value;
    if (_onChanged != null) valueListenable.addListener(_onValueChange);
  }

  void _onValueChange() {
    if (_valueListenable.value == _previousValue) return;
    final prev = _previousValue;
    final next = _valueListenable.value;
    _onChanged?.call(prev, next);
    if (_updateHost) host.requestUpdate();
    _previousValue = next;
  }

  @override
  void dispose() {
    valueListenable.removeListener(_onValueChange);
    super.dispose();
  }
}

class ReactiveChangeNotifier<T extends ChangeNotifier>
    extends ReactiveController {
  final T _notifier;
  T get notifier => _notifier;
  final bool _updateHost;
  final VoidCallback? _onChanged;

  ReactiveChangeNotifier(
    ReactiveControllerHost host, {
    required T changeNotifier,
    bool updateHost = false,
    VoidCallback? onChanged,
  })  : _onChanged = onChanged,
        _updateHost = updateHost,
        _notifier = changeNotifier,
        super(host) {
    if (_onChanged != null) _notifier.addListener(_onChanged!);
    if (_updateHost) _notifier.addListener(host.requestUpdate);
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }
}

class ReactiveValueNotifier<T> extends ReactiveController {
  final OnChanged<T>? _onChanged;

  late T _previousValue;

  late ValueNotifier<T> _valueNotifier;

  ValueNotifier<T> get valueNotifier => _valueNotifier;
  T get value => _valueNotifier.value;

  final bool _updateHost;
  ReactiveValueNotifier(
    ReactiveControllerHost host, {
    required T initialValue,
    bool updateHost = true,
    OnChanged<T>? onChanged,
  })  : _onChanged = onChanged,
        _updateHost = updateHost,
        super(host) {
    _valueNotifier = ValueNotifier(initialValue);
    _previousValue = initialValue;
    if (_onChanged != null) _valueNotifier.addListener(_onValueChanged);
  }
  void _onValueChanged() {
    if (_valueNotifier.value == _previousValue) return;
    final prev = _previousValue;
    final next = _valueNotifier.value;
    _onChanged?.call(prev, next);
    if (_updateHost) host.requestUpdate();
    _previousValue = next;
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }
}

class ReactiveAnimation<T> extends ReactiveValueListenable<T> {
  late final animation = valueListenable;

  ReactiveAnimation(
    ReactiveControllerHost host,
    Animation<T> animation, {
    bool updateHost = false,
    OnChanged<T>? onChanged,
  }) : super(
          host,
          valueListenable: animation,
          updateHost: updateHost,
          onChanged: onChanged,
        );
}
