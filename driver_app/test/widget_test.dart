import 'package:dropzone_driver_app/presentation/app/driver_app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('renders driver auth screen while signed out',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DriverApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Driver sign in'), findsOneWidget);
    expect(find.text('Enter as linked demo driver'), findsOneWidget);
  });
}
