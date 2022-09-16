part of 'reactive.dart';

class ReactiveAnimationController extends ReactiveController {
  late final AnimationController controller;
  final VoidCallback? _onChanged;
  final bool _updateHost;

  ReactiveAnimationController(
    ReactiveControllerHost host, {
    required TickerProvider vsync,
    double? value,
    Duration? duration,
    Duration? reverseDuration,
    String? debugLabel,
    double lowerBound = 0.0,
    double upperBound = 1.0,
    AnimationBehavior animationBehavior = AnimationBehavior.normal,
    bool updateHost = false,
    VoidCallback? onChanged,
  })  : _onChanged = onChanged,
        _updateHost = updateHost,
        super(host) {
    controller = AnimationController(
      vsync: vsync,
      value: value,
      duration: duration,
      reverseDuration: reverseDuration,
      debugLabel: debugLabel,
      lowerBound: lowerBound,
      upperBound: upperBound,
      animationBehavior: animationBehavior,
    );

    if (_updateHost) controller.addListener(host.requestUpdate);
    if (_onChanged != null) controller.addListener(_onChanged!);
  }

  @override
  void dispose() {
    if (_onChanged != null) controller.removeListener(_onChanged!);
    if (_updateHost) controller.removeListener(host.requestUpdate);

    controller.dispose();
    super.dispose();
  }
}

class ReactiveTabController extends ReactiveController {
  late final TabController controller;
  final bool _updateHost;
  final VoidCallback? _onChanged;

  ReactiveTabController(
    ReactiveControllerHost host, {
    int initialIndex = 0,
    required int length,
    required TickerProvider vsync,
    bool updateHost = false,
    VoidCallback? onChanged,
  })  : _updateHost = updateHost,
        _onChanged = onChanged,
        super(host) {
    controller = TabController(
      initialIndex: initialIndex,
      length: length,
      vsync: vsync,
    );
    if (_updateHost) controller.addListener(host.requestUpdate);
    if (_onChanged != null) controller.addListener(_onChanged!);
  }

  @override
  void dispose() {
    if (_updateHost) controller.removeListener(host.requestUpdate);
    if (_onChanged != null) controller.removeListener(_onChanged!);
    controller.dispose();
    super.dispose();
  }
}
