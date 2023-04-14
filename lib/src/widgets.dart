part of 'core.dart';

class ReactiveBuilder<T extends ReactiveController> extends StatefulWidget {
  final Widget? child;

  final T Function(ReactiveControllerHost host) create;

  final Widget Function(
    BuildContext context,
    T controller,
    Widget? child,
  ) builder;
  const ReactiveBuilder({
    Key? key,
    required this.create,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  State<ReactiveBuilder<T>> createState() => _ReactiveBuilderState<T>();
}

class _ReactiveBuilderState<T extends ReactiveController>
    extends State<ReactiveBuilder<T>> with ReactiveControllerHostMixin {
  late T controller;

  @override
  void initState() {
    super.initState();
    controller = widget.create(this);
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        controller,
        widget.child,
      );
}
