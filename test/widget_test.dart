import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

void main() {
  testWidgets('uses the web portfolio background in the dark theme', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final scaffold = find.byType(Scaffold);
    final theme = Theme.of(tester.element(scaffold));
    expect(theme.brightness, Brightness.dark);
    expect(
      tester.widget<Scaffold>(scaffold).backgroundColor ??
          theme.scaffoldBackgroundColor,
      const Color(0xFF12181F),
    );
  });

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

  testWidgets('renders each portfolio action with its own color', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    const expectedColors = {
      'Lihat Proyek': (Color(0xFF526B50), Colors.white),
      'Tambah Proyek': (Color(0xFF7EA87A), Color(0xFF12181F)),
      'Logout': (Color(0xFF9B4D4D), Colors.white),
    };

    for (final action in expectedColors.entries) {
      final (backgroundColor, foregroundColor) = action.value;
      final card = find.widgetWithText(ItemCard, action.key);
      expect(card, findsOneWidget);

      final background = find.descendant(
        of: card,
        matching: find.byType(Material),
      );
      expect(background, findsOneWidget);
      expect(tester.widget<Material>(background).color, backgroundColor);

      final icon = find.descendant(of: card, matching: find.byType(Icon));
      expect(tester.widget<Icon>(icon).color, foregroundColor);
      expect(
        tester.widget<Text>(find.text(action.key)).style?.color,
        foregroundColor,
      );
    }
  });

  testWidgets(
    'keeps all actions reachable on a narrow screen with large text',
    (tester) async {
      addTearDown(() async {
        tester.platformDispatcher.clearTextScaleFactorTestValue();
        await tester.binding.setSurfaceSize(null);
      });

      await tester.binding.setSurfaceSize(const Size(320, 480));
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      await tester.pumpWidget(const MyApp());

      expect(tester.takeException(), isNull);

      for (final label in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
        final action = find.text(label);
        await tester.ensureVisible(action);
        await tester.pumpAndSettle();

        expect(action.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    },
  );

  const actions = {'Lihat Proyek': Icons.folder, 'Logout': Icons.logout};

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
      expect(
        find.text('Buka Proyek'),
        action.key == 'Lihat Proyek' ? findsOneWidget : findsNothing,
      );
    });
  }

  testWidgets('opens the form from Tambah Proyek and returns on Back', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    final addProject = find.text('Tambah Proyek');
    expect(find.byIcon(Icons.add_circle), findsOneWidget);
    await tester.tap(addProject);
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);
    expect(
      find.text('Kamu telah menekan tombol Tambah Proyek!').hitTestable(),
      findsOneWidget,
    );
    expect(find.text('Buka Proyek'), findsNothing);

    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsNothing);
    expect(addProject.hitTestable(), findsOneWidget);
  });

  testWidgets('opens and closes the project preview from the SnackBar', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buka Proyek'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('MyPortfolio Mobile'), findsOneWidget);
    expect(find.text('Dibangun dengan Flutter dan Dart.'), findsOneWidget);

    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsNothing);
    expect(find.text('Lihat Proyek').hitTestable(), findsOneWidget);
  });
}
