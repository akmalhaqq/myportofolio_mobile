import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/validators/experience_validators.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

Future<void> openExperienceForm(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  final card = find.widgetWithText(ItemCard, 'Tambah Pengalaman');
  await tester.ensureVisible(card);
  await tester.tap(card);
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpAndSettle();
}

Finder textField(String label) => find.byWidgetPredicate(
  (widget) => widget is TextField && widget.decoration?.labelText == label,
);

Future<void> enterField(WidgetTester tester, String label, String value) async {
  final field = textField(label);
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

Future<void> tapSave(WidgetTester tester) async {
  final save = find.widgetWithText(ElevatedButton, 'Simpan');
  await tester.ensureVisible(save);
  await tester.tap(save);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('experience card opens the form and Back returns Home', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.widgetWithText(ItemCard, 'Tambah Pengalaman'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);
    expect(
      find.text('Kamu telah menekan tombol Tambah Pengalaman!').hitTestable(),
      findsOneWidget,
    );

    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsNothing);
    expect(
      find.widgetWithText(ItemCard, 'Tambah Pengalaman').hitTestable(),
      findsOneWidget,
    );
  });

  testWidgets('shared drawer links Home, Add Project, and Add Experience', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    Future<void> selectDrawerItem(String label) async {
      await tester.tap(find.byType(DrawerButton));
      await tester.pumpAndSettle();
      for (final option in ['Home', 'Add Project', 'Add Experience']) {
        expect(find.widgetWithText(ListTile, option), findsOneWidget);
      }
      await tester.tap(find.widgetWithText(ListTile, label));
      await tester.pumpAndSettle();
    }

    await selectDrawerItem('Add Experience');
    expect(find.byType(ExperienceFormPage), findsOneWidget);
    await selectDrawerItem('Home');
    expect(find.byType(ExperienceFormPage), findsNothing);
    expect(find.widgetWithText(ItemCard, 'Tambah Pengalaman'), findsOneWidget);

    await selectDrawerItem('Add Project');
    expect(find.text('Add Project Form'), findsOneWidget);
    await selectDrawerItem('Add Experience');
    expect(find.byType(ExperienceFormPage), findsOneWidget);
    await selectDrawerItem('Add Project');
    expect(find.text('Add Project Form'), findsOneWidget);
    await selectDrawerItem('Home');
    expect(find.widgetWithText(ItemCard, 'Tambah Pengalaman'), findsOneWidget);
  });

  test('required experience text rejects null, empty, and whitespace', () {
    for (final value in [null, '', ' \n\t ']) {
      expect(validateExperienceText(value, label: 'Deskripsi'), isNotNull);
    }
    expect(
      validateExperienceText(' Deskripsi valid ', label: 'Deskripsi'),
      isNull,
    );
  });

  test('text limits accept the boundary and count Unicode code points', () {
    for (final limit in [experienceTextMaxLength, experiencePeriodMaxLength]) {
      for (final character in ['a', '😀']) {
        final atLimit = List.filled(limit, character).join();
        expect(
          validateExperienceText(atLimit, label: 'Isian', maxLength: limit),
          isNull,
        );
        expect(
          validateExperienceText(
            '$atLimit$character',
            label: 'Isian',
            maxLength: limit,
          ),
          isNotNull,
        );
      }
    }
  });

  test('categories match the Experience model choices', () {
    for (final category in experienceCategories) {
      expect(validateExperienceCategory(category), isNull);
    }
    expect(validateExperienceCategory(null), isNotNull);
    expect(validateExperienceCategory('Unknown'), isNotNull);
  });

  testWidgets('invalid fields block the summary and show errors', (
    tester,
  ) async {
    await openExperienceForm(tester);
    final category = find.byType(DropdownButtonFormField<String>);
    expect(tester.state<FormFieldState<String>>(category).value, 'Other');

    const labels = [
      'Jabatan / Nama Pengalaman',
      'Perusahaan / Organisasi',
      'Periode',
      'Deskripsi',
      'Tags',
    ];
    await tapSave(tester);
    for (final label in labels) {
      expect(find.text('$label tidak boleh kosong!'), findsOneWidget);
      await enterField(tester, label, '   ');
    }
    await tapSave(tester);
    for (final label in labels) {
      expect(find.text('$label tidak boleh kosong!'), findsOneWidget);
    }
    expect(find.byType(AlertDialog), findsNothing);

    final tooLong = List.filled(256, 'a').join();
    await enterField(tester, labels[0], tooLong);
    await enterField(tester, labels[1], tooLong);
    await enterField(tester, labels[2], List.filled(101, 'a').join());
    await enterField(tester, labels[3], 'Deskripsi valid');
    await enterField(tester, labels[4], tooLong);
    await tapSave(tester);
    for (final label in [labels[0], labels[1], labels[4]]) {
      expect(find.text('$label maksimal 255 karakter!'), findsOneWidget);
    }
    expect(find.text('Periode maksimal 100 karakter!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('summary shows all current values and keeps inputs when closed', (
    tester,
  ) async {
    await openExperienceForm(tester);
    await enterField(tester, 'Jabatan / Nama Pengalaman', '  Flutter Intern  ');
    await enterField(tester, 'Perusahaan / Organisasi', 'Contoh Studio');
    await enterField(tester, 'Periode', 'Agustus–Desember 2026');
    final category = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Internship').hitTestable());
    await tester.pumpAndSettle();
    await enterField(tester, 'Deskripsi', 'Membangun antarmuka mobile.');
    await enterField(tester, 'Tags', 'Flutter, Dart');
    await tapSave(tester);

    final dialog = find.byType(AlertDialog);
    for (final text in [
      'Jabatan / Nama Pengalaman: Flutter Intern',
      'Perusahaan / Organisasi: Contoh Studio',
      'Periode: Agustus–Desember 2026',
      'Kategori: Internship',
      'Deskripsi: Membangun antarmuka mobile.',
      'Tags: Flutter, Dart',
    ]) {
      expect(
        find.descendant(of: dialog, matching: find.text(text)),
        findsOneWidget,
      );
    }
    await tester.tap(find.widgetWithText(TextButton, 'Tutup'));
    await tester.pumpAndSettle();
    expect(dialog, findsNothing);
    expect(
      tester
          .widget<TextField>(textField('Jabatan / Nama Pengalaman'))
          .controller!
          .text,
      '  Flutter Intern  ',
    );
    expect(tester.state<FormFieldState<String>>(category).value, 'Internship');

    await enterField(tester, 'Jabatan / Nama Pengalaman', 'Pengalaman kedua');
    await enterField(tester, 'Tags', 'Mentoring');
    await tapSave(tester);
    expect(
      find.text('Jabatan / Nama Pengalaman: Pengalaman kedua'),
      findsOneWidget,
    );
    expect(find.text('Tags: Mentoring'), findsOneWidget);
    expect(
      find.text('Jabatan / Nama Pengalaman: Flutter Intern'),
      findsNothing,
    );
  });

  testWidgets('form and long summary scroll on a phone with keyboard insets', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 480);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);
    await openExperienceForm(tester);
    tester.view.viewInsets = const FakeViewPadding(bottom: 200);
    await tester.pumpAndSettle();

    await enterField(tester, 'Jabatan / Nama Pengalaman', 'Mentor');
    await enterField(tester, 'Perusahaan / Organisasi', 'Komunitas');
    await enterField(tester, 'Periode', '2026');
    final description = List.filled(35, 'Detail pengalaman.').join('\n');
    await enterField(tester, 'Deskripsi', description);
    await enterField(tester, 'Tags', 'Mentoring');
    await tapSave(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Deskripsi: $description'), findsOneWidget);
    final tags = find.text('Tags: Mentoring');
    await tester.ensureVisible(tags);
    await tester.pumpAndSettle();
    expect(tags.hitTestable(), findsOneWidget);
    expect(find.text('Tutup').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
