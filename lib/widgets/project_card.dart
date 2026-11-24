import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          if (item.name == 'Lihat Proyek') {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const ProjectListScreen(),
              ),
            );
            return;
          }

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Kamu telah menekan tombol ${item.name}!'),
              ),
            );

          if (item.name == 'Tambah Proyek') {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(builder: (_) => const ProjectFormPage()),
            );
          }
          if (item.name == 'Tambah Pengalaman') {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const ExperienceFormPage(),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: item.foregroundColor, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: item.foregroundColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
