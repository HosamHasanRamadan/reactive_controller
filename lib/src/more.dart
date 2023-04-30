part of 'reactive.dart';

class ReactiveAppLifecycle extends ReactiveController
    with WidgetsBindingObserver {
  final OnChanged<AppLifecycleState>? _onChanged;
  AppLifecycleState? _state = WidgetsBinding.instance.lifecycleState;
  AppLifecycleState? get state => _state;

  final bool _updateHost;
  ReactiveAppLifecycle(
    ReactiveControllerHost host, {
    OnChanged<AppLifecycleState>? onChanged,
    bool updateHost = false,
  })  : _updateHost = updateHost,
        _onChanged = onChanged,
        super(host) {
    ambiguate(WidgetsBinding.instance)?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _onChanged?.call(_state, state);
    _state = state;
    if (_updateHost) {
      host.requestUpdate();
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    super.dispose();
  }
}

class ReactiveListenableSelector<T extends Listenable, S>
    extends ReactiveController {
  final S Function(T) _selector;
  final T _listenable;
  Listenable get listenable => _listenable;
  late S _value;
  S get value => _value;

  final bool _updateHost;
  final OnChanged<S>? _onChanged;

  ReactiveListenableSelector(
    ReactiveControllerHost host, {
    required T listenable,
    required S Function(T) selector,
    bool updateHost = true,
    OnChanged<S>? onChanged,
  })  : _listenable = listenable,
        _selector = selector,
        _updateHost = updateHost,
        _onChanged = onChanged,
        super(host) {
    _value = _selector(listenable);
    _listenable.addListener(_onValueChanged);
  }
  void _onValueChanged() {
    final next = _selector(_listenable);
    if (next == _value) return;
    final prev = _value;
    _value = next;

    if (_updateHost) host.requestUpdate();
    _onChanged?.call(prev, next);
  }

  @override
  void dispose() {
    _listenable.removeListener(_onValueChanged);
    super.dispose();
  }
}

class ReactiveValue<T> extends ReactiveController {
  ReactiveValue(
    ReactiveControllerHost host, {
    required this.initial,
    this.onChange,
    this.updateHost = true,
  }) : super(host) {
    _value = initial;
  }
  final T initial;
  late T _value;
  late T? _prev;
  final OnChanged<T>? onChange;
  final bool updateHost;

  T get value => _value;
  set value(T value) {
    if (value == _value) return;
    if (isMounted == false) return;
    _prev = _value;
    _value = value;
    onChange?.call(_prev, _value);

    if (updateHost) {
      host.requestUpdate();
    }
  }
}
