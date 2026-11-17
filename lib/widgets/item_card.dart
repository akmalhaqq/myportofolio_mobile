import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/project_form.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  final SnackBarAction? snackBarAction;

  const ItemCard(this.item, {super.key, this.snackBarAction});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Kamu telah menekan tombol ${item.name}!'),
                action: snackBarAction,
              ),
            );

          if (item.name == 'Tambah Proyek') {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(builder: (_) => const ProjectFormPage()),
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
