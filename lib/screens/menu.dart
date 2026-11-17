import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:myportofolio_mobile/widgets/project_preview.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  final String npm = "2506548295";
  final String nama = "Muhammad Akmal Haqqani";
  final String kelas = "PBP D";

  static const _viewProjects = ItemHomepage(
    'Lihat Proyek',
    Icons.folder,
    Color(0xFF526B50),
  );

  final List<ItemHomepage> items = const [
    _viewProjects,
    ItemHomepage(
      'Tambah Proyek',
      Icons.add_circle,
      Color(0xFF7EA87A),
      foregroundColor: Color(0xFF12181F),
    ),
    ItemHomepage('Logout', Icons.logout, Color(0xFF9B4D4D)),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur visual dasar halaman.
    return Scaffold(
      // AppBar menampilkan bar bagian atas aplikasi.
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 12.0;
              final cardWidth = constraints.maxWidth < 600
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 2 * spacing) / 3;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: InfoCard(title: 'NPM', content: npm),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: InfoCard(title: 'Name', content: nama),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: InfoCard(title: 'Class', content: kelas),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Selamat datang di MyPortfolio Mobile!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (final item in items)
                          SizedBox(
                            width: cardWidth,
                            child: ItemCard(
                              item,
                              snackBarAction: item == _viewProjects
                                  ? SnackBarAction(
                                      label: 'Buka Proyek',
                                      onPressed: () =>
                                          showModalBottomSheet<void>(
                                            context: context,
                                            isScrollControlled: true,
                                            useSafeArea: true,
                                            builder: (_) =>
                                                const ProjectPreview(),
                                          ),
                                    )
                                  : null,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
