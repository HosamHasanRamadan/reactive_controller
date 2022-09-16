import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:reactive_controller/src/migration_helper.dart';

typedef OnChanged<T> = void Function(T? previous, T next);

abstract class ReactiveController with Diagnosticable {
  @protected
  final ReactiveControllerHost host;

  ReactiveController(this.host) {
    host.addController(this);
  }

  @protected
  @mustCallSuper
  void didChangeDependencies() {}

  @protected
  @mustCallSuper
  void dispose() {}

  @protected
  @mustCallSuper
  void didUpdateWidget(covariant StatefulWidget oldWidget) {}

  @protected
  @mustCallSuper
  void activate() {}

  @protected
  @mustCallSuper
  void deactivate() {}
}

abstract class ReactiveControllerHost {
  void addController(ReactiveController controller);
  void removeController(ReactiveController controller);
  void requestUpdate();
  Future<void> get updateComplete;
  BuildContext get context;
}

@optionalTypeArgs
mixin ReactiveControllerHostMixin<T extends StatefulWidget> on State<T>
    implements ReactiveControllerHost {
  @protected
  final List<ReactiveController> reactiveControllers = [];

  @override
  void addController(ReactiveController controller) {
    reactiveControllers.add(controller);
  }

  @override
  void removeController(ReactiveController controller) {
    reactiveControllers.remove(controller);
  }

  @override
  void requestUpdate() {
    setState(() {});
  }

  @override
  Future<void> get updateComplete {
    final completer = Completer();
    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) {
      completer.complete();
    });
    return completer.future;
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final controller in reactiveControllers) {
      controller.didUpdateWidget(oldWidget);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final controller in reactiveControllers) {
      controller.didChangeDependencies();
    }
  }

  @override
  void activate() {
    super.activate();
    for (final controller in reactiveControllers) {
      controller.activate();
    }
  }

  @override
  void deactivate() {
    for (final controller in reactiveControllers) {
      controller.deactivate();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    for (final controller in reactiveControllers) {
      controller.dispose();
    }
    reactiveControllers.clear();
    super.dispose();
  }
}
