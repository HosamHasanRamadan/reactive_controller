part of 'reactive.dart';

class ReactiveFuture<T> extends ReactiveController {
  final Future<T> future;
  final bool _updateHost;
  final OnChanged<AsyncSnapshot<T>>? _onChanged;

  AsyncSnapshot<T> _snapshot = const AsyncSnapshot.nothing();
  AsyncSnapshot<T> get snapshot => _snapshot;

  ReactiveFuture(
    ReactiveControllerHost host,
    this.future, {
    T? initialData,
    OnChanged<AsyncSnapshot<T>>? onChanged,
    bool updateHost = true,
  })  : _updateHost = updateHost,
        _onChanged = onChanged,
        super(host) {
    if (initialData != null) {
      _snapshot = AsyncSnapshot.withData(ConnectionState.waiting, initialData);
    }

    future.then((data) {
      final prev = _snapshot;
      _snapshot = AsyncSnapshot.withData(ConnectionState.done, data);
      _onChanged?.call(prev, snapshot);
      if (_updateHost) host.requestUpdate();
    }, onError: (err, st) {
      final prev = _snapshot;
      _snapshot = AsyncSnapshot.withError(ConnectionState.done, err, st);
      _onChanged?.call(prev, snapshot);
      if (_updateHost) host.requestUpdate();
    });
  }
}

class ReactiveStream<T> extends ReactiveController {
  final Stream<T> _stream;
  Stream<T> get stream => _stream;

  AsyncSnapshot<T> _snapshot = const AsyncSnapshot.nothing();
  AsyncSnapshot<T> get snapshot => _snapshot;

  StreamSubscription<T>? _subscription;

  final OnChanged<AsyncSnapshot<T>>? _onChanged;
  final bool _updateHost;

  ReactiveStream(
    ReactiveControllerHost host, {
    required Stream<T> stream,
    T? initialData,
    OnChanged<AsyncSnapshot<T>>? onChanged,
    bool updateHost = true,
  })  : _onChanged = onChanged,
        _updateHost = updateHost,
        _stream = stream,
        super(host) {
    if (initialData != null) {
      _snapshot = AsyncSnapshot.withData(ConnectionState.waiting, initialData);
    }

    _subscription = _stream.listen((T data) {
      final next = afterData(_snapshot, data);
      _onChange(next);
    }, onError: (Object error, StackTrace stackTrace) {
      final next = afterError(_snapshot, error, stackTrace);
      _onChange(next);
    }, onDone: () {
      final next = afterDone(_snapshot);
      _onChange(next);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  void _onChange(AsyncSnapshot<T> next) {
    final prev = _snapshot;
    _snapshot = next;
    _onChanged?.call(prev, next);
    if (_updateHost) host.requestUpdate();
  }

  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.waiting);

  AsyncSnapshot<T> afterData(
    AsyncSnapshot<T> current,
    T data,
  ) =>
      AsyncSnapshot<T>.withData(
        ConnectionState.active,
        data,
      );

  AsyncSnapshot<T> afterError(
    AsyncSnapshot<T> current,
    Object error,
    StackTrace stackTrace,
  ) =>
      AsyncSnapshot<T>.withError(
        ConnectionState.active,
        error,
        stackTrace,
      );

  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.done);

  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.none);
}
