import 'package:flutter_test/flutter_test.dart';

import 'package:diu_transport_student_app/barikoi_map.dart';
import 'package:diu_transport_student_app/main.dart';

void main() {
  testWidgets('Map widget initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(socket: null,));

    // Verify that the map widget is present
    expect(find.byType(SymbolMap), findsOneWidget);

    // Add more assertions relevant to your map functionality
  });
}