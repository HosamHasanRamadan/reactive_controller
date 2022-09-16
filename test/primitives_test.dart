import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_controller/reactive_controller.dart';

void main() {
  Widget getApp() => MaterialApp(home: Scaffold(body: _PrimitiveTestWidget()));
  testWidgets('defaults / initial values', (tester) async {
    /// create a state so we can construct reactive directly
    final state = _PrimitiveTestWidgetState(); //
    expect(ReactiveInt(state, initialValue: 0).value, 0);
    expect(ReactiveInt(state, initialValue: 1).value, 1);
    expect(ReactiveDouble(state, initialValue: 0.0).value, 0);
    expect(ReactiveDouble(state, initialValue: 1).value, 1);
    expect(ReactiveString(state, initialValue: '').value, '');
    expect(ReactiveString(state, initialValue: 'a').value, 'a');
    expect(ReactiveBool(state, initialValue: false).value, false);
    expect(ReactiveBool(state, initialValue: true).value, true);
  });

  testWidgets('widgets rebuild when data changes', (tester) async {
    await tester.pumpWidget(getApp());
    _PrimitiveTestWidgetState state =
        tester.state(find.byType(_PrimitiveTestWidget));
    expect(find.text('0'), findsOneWidget);
    expect(find.text('0.0'), findsOneWidget);
    expect(find.text('false'), findsOneWidget);
    expect(find.text(''), findsOneWidget);
    state.someInt.value = 1;
    state.someDouble.value = 1.0;
    state.someString.value = 'hello';
    state.someBool.value = true;
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('1.0'), findsOneWidget);
    expect(find.text('true'), findsOneWidget);
    expect(find.text('hello'), findsOneWidget);
  });
}

class _PrimitiveTestWidget extends StatefulWidget {
  @override
  _PrimitiveTestWidgetState createState() => _PrimitiveTestWidgetState();
}

class _PrimitiveTestWidgetState extends State<_PrimitiveTestWidget>
    with ReactiveControllerHostMixin {
  late final ReactiveInt someInt = ReactiveInt(this, initialValue: 0);
  late final ReactiveDouble someDouble = ReactiveDouble(
    this,
    initialValue: 0.0,
  );
  late final ReactiveString someString = ReactiveString(
    this,
    initialValue: '',
  );
  late final ReactiveBool someBool = ReactiveBool(this, initialValue: false);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${someInt.value}'),
        Text('${someDouble.value}'),
        Text(someString.value),
        Text('${someBool.value}'),
      ],
    );
  }
}
