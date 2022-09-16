part of 'reactive.dart';

class ReactiveFocusNode extends ReactiveChangeNotifier<FocusNode> {
  ReactiveFocusNode(
    ReactiveControllerHost host, {
    String? debugLabel,
    KeyEventResult Function(FocusNode, RawKeyEvent)? onKey,
    KeyEventResult Function(FocusNode, KeyEvent)? onKeyEvent,
    bool skipTraversal = false,
    bool canRequestFocus = true,
    bool descendantsAreFocusable = true,
    bool descendantsAreTraversable = true,
    bool updateHost = false,
    VoidCallback? onChanged,
  }) : super(
          host,
          notifier: FocusNode(
            debugLabel: debugLabel,
            onKey: onKey,
            onKeyEvent: onKeyEvent,
            skipTraversal: skipTraversal,
            canRequestFocus: canRequestFocus,
            descendantsAreFocusable: descendantsAreFocusable,
            descendantsAreTraversable: descendantsAreTraversable,
          ),
          updateHost: updateHost,
          onChanged: onChanged,
        );
}

class ReactiveTextEditingController
    extends ReactiveChangeNotifier<TextEditingController> {
  ReactiveTextEditingController(
    ReactiveControllerHost host, {
    String? text,
    bool updateHost = false,
    VoidCallback? onChanged,
  }) : super(
          host,
          notifier: TextEditingController(text: text),
          updateHost: updateHost,
          onChanged: onChanged,
        );
}

class ReactiveScrollController
    extends ReactiveChangeNotifier<ScrollController> {
  ReactiveScrollController(
    ReactiveControllerHost host, {
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String? debugLabel,
    bool updateHost = false,
    VoidCallback? onChanged,
  }) : super(
          host,
          notifier: ScrollController(
            initialScrollOffset: initialScrollOffset,
            keepScrollOffset: keepScrollOffset,
            debugLabel: debugLabel,
          ),
          updateHost: updateHost,
          onChanged: onChanged,
        );
}

class ReactivePageController extends ReactiveChangeNotifier<PageController> {
  ReactivePageController(
    ReactiveControllerHost host, {
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
    bool updateHost = false,
    VoidCallback? onChanged,
  }) : super(
          host,
          notifier: PageController(
            initialPage: initialPage,
            keepPage: keepPage,
            viewportFraction: viewportFraction,
          ),
          updateHost: updateHost,
          onChanged: onChanged,
        );
}
