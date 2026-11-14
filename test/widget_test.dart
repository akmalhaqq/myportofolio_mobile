import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';

void main() {
  testWidgets('shows the three portfolio profile cards', (tester) async {
    await tester.pumpWidget(const MyApp());

    const profile = {
      'NPM': '2506548295',
      'Name': 'Muhammad Akmal Haqqani',
      'Class': 'PBP D',
    };

    expect(find.byType(InfoCard), findsNWidgets(3));

    for (final field in profile.entries) {
      final card = find.widgetWithText(InfoCard, field.key);
      expect(card, findsOneWidget);
      expect(
        find.descendant(of: card, matching: find.text(field.value)),
        findsOneWidget,
      );
    }
  });

  const actions = {
    'Lihat Proyek': Icons.folder,
    'Tambah Proyek': Icons.add_circle,
    'Logout': Icons.logout,
  };

  for (final action in actions.entries) {
    testWidgets('shows the SnackBar for ${action.key}', (tester) async {
      await tester.pumpWidget(const MyApp());

      final label = find.text(action.key);
      expect(label, findsOneWidget);
      expect(find.byIcon(action.value), findsOneWidget);

      await tester.tap(label);
      await tester.pumpAndSettle();

      expect(
        find.text('Kamu telah menekan tombol ${action.key}!'),
        findsOneWidget,
      );
    });
  }
}