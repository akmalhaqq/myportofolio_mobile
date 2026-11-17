import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('validates, previews, and resets each project submission', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(400, 550));
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byType(DrawerButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);

    Future<void> enterField(String label, String value) async {
      final field = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.labelText == label,
      );
      await tester.ensureVisible(field);
      await tester.enterText(field, value);
      await tester.pumpAndSettle();
    }

    Future<void> tapSave() async {
      final save = find.widgetWithText(ElevatedButton, 'Save');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
    }

    final dialog = find.byType(AlertDialog);
    await tapSave();
    expect(dialog, findsNothing);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);

    await enterField('Nama Proyek', '   ');
    await enterField('Deskripsi Proyek', '   ');
    await tapSave();
    expect(dialog, findsNothing);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);

    final description = List.filled(
      45,
      'Detail implementasi proyek.',
    ).join('\n');
    await enterField('Nama Proyek', '  MyPortfolio Mobile  ');
    await enterField('Deskripsi Proyek', description);

    final category = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mobile Development').hitTestable());
    await tester.pumpAndSettle();

    await enterField('Teknologi yang Digunakan', 'Flutter, Dart');
    await enterField('Tautan Proyek', 'https://example.com/portfolio');
    await tapSave();

    Finder dialogText(String text) =>
        find.descendant(of: dialog, matching: find.text(text));

    expect(dialogText('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(dialogText('Nama Proyek: MyPortfolio Mobile'), findsOneWidget);
    expect(dialogText('Deskripsi: $description'), findsOneWidget);
    expect(dialogText('Kategori: Mobile Development'), findsOneWidget);
    expect(dialogText('Teknologi: Flutter, Dart'), findsOneWidget);

    final link = dialogText('Tautan: https://example.com/portfolio');
    expect(link.hitTestable(), findsNothing);
    await tester.ensureVisible(link);
    await tester.pumpAndSettle();
    expect(link.hitTestable(), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();
    expect(dialog, findsNothing);
    final fields = tester.widgetList<EditableText>(find.byType(EditableText));
    expect(fields.map((field) => field.controller.text), ['', '', '', '']);
    expect(
      tester.state<FormFieldState<String>>(category).value,
      'Web Development',
    );

    await enterField('Nama Proyek', 'Proyek kedua');
    await enterField('Deskripsi Proyek', 'Deskripsi baru');
    await tapSave();
    expect(dialogText('Nama Proyek: Proyek kedua'), findsOneWidget);
    expect(dialogText('Deskripsi: Deskripsi baru'), findsOneWidget);
    expect(dialogText('Kategori: Web Development'), findsOneWidget);
    expect(dialogText('Teknologi: -'), findsOneWidget);
    expect(dialogText('Tautan: -'), findsOneWidget);
  });
}
