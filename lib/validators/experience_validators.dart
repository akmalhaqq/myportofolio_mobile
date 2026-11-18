import 'package:myportofolio_mobile/utils/experience_tags.dart';

const experienceCategories = [
  'Internship',
  'Organizational',
  'Leadership',
  'Teaching',
  'Competition',
  'Community',
  'Other',
];

const experienceDefaultCategory = 'Other';
const experienceTextMaxLength = 255;
const experiencePeriodMaxLength = 100;

/// Checks required text and the character limits from Django's Experience model.
String? validateExperienceText(
  String? value, {
  required String label,
  int? maxLength,
}) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) {
    return '$label tidak boleh kosong!';
  }

  // Count Unicode code points, as Django does, instead of UTF-16 code units.
  if (maxLength != null && text.runes.length > maxLength) {
    return '$label maksimal $maxLength karakter!';
  }

  return null;
}

String? validateExperienceCategory(String? value) {
  if (!experienceCategories.contains(value)) {
    return 'Pilih kategori pengalaman yang tersedia!';
  }
  return null;
}

String? validateExperienceTags(String? value) {
  final error = validateExperienceText(
    value,
    label: 'Tags',
    maxLength: experienceTextMaxLength,
  );
  if (error != null) return error;

  if (parseExperienceTags(value!).isEmpty) {
    return 'Masukkan minimal satu tag selain koma!';
  }
  return null;
}
