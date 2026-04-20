import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:veto_app/main.dart';

void main() {
  testWidgets('App starts with auth screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: VetoApp()));

    // Verify that we see the VETO title
    expect(find.text('VETO'), findsOneWidget);
    expect(find.text('ДИКТАТОР РЕШЕНИЙ'), findsOneWidget);
  });
}
