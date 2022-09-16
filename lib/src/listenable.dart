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

class ReactiveValueListenable<T>
    extends ReactiveListenable<ValueListenable<T>> {
  ValueListenable<T> get valueListenable => _listenable;
  final OnChanged<T>? _onChanged;
  T? _previousValue;

  ReactiveValueListenable(
    ReactiveControllerHost host, {
    required ValueListenable<T> listenable,
    bool updateHost = true,
    OnChanged<T>? onChanged,
  })  : _onChanged = onChanged,
        super(
          host,
          listenable: listenable,
          updateHost: updateHost,
        ) {
    _previousValue = _listenable.value;
    if (_onChanged != null) listenable.addListener(_onValueChange);
  }

  void _onValueChange() {
    if (_listenable.value == _previousValue) return;
    final prev = _previousValue;
    final next = _listenable.value;
    _previousValue = next;
    _onChanged?.call(prev, next);
  }

  @override
  void dispose() {
    if (_onChanged != null) _listenable.addListener(_onValueChange);
    super.dispose();
  }
}

class ReactiveChangeNotifier<T extends ChangeNotifier>
    extends ReactiveListenable<T> {
  T get notifier => _listenable;

  final VoidCallback? _onChanged;
  ReactiveChangeNotifier(
    ReactiveControllerHost host, {
    required T notifier,
    bool updateHost = false,
    VoidCallback? onChanged,
  })  : _onChanged = onChanged,
        super(
          host,
          listenable: notifier,
          updateHost: updateHost,
        ) {
    if (_onChanged != null) _listenable.addListener(_onChanged!);
  }

  @override
  void dispose() {
    _listenable.dispose();
    super.dispose();
  }
}

class ReactiveValueNotifier<T> extends ReactiveListenable<ValueNotifier<T>> {
  final OnChanged<T>? _onChanged;
  late T _previousValue;

  ValueNotifier<T> get notifier => _listenable;

  ReactiveValueNotifier(
    ReactiveControllerHost host, {
    required T initialValue,
    bool updateHost = true,
    OnChanged<T>? onChanged,
  })  : _onChanged = onChanged,
        super(
          host,
          listenable: ValueNotifier(initialValue),
          updateHost: updateHost,
        ) {
    _previousValue = initialValue;
    if (_onChanged != null) _listenable.addListener(_onValueChanged);
  }
  void _onValueChanged() {
    if (_listenable.value == _previousValue) return;
    final prev = _previousValue;
    final next = _listenable.value;
    _onChanged?.call(prev, next);
  }

  @override
  void dispose() {
    _listenable.dispose();
    super.dispose();
  }
}

class ReactiveAnimation<T> extends ReactiveValueListenable<T> {
  ReactiveAnimation(
    ReactiveControllerHost host,
    Animation<T> listenable, {
    bool updateHost = true,
    OnChanged? onChanged,
  }) : super(
          host,
          listenable: listenable,
          updateHost: updateHost,
          onChanged: onChanged,
        );
}
