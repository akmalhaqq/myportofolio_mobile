/// Uses the same tag labels for the live preview and submission summary.
List<String> parseExperienceTags(String value) {
  return value
      .split(',')
      .map((tag) => tag.trim())
      .where((tag) => tag.isNotEmpty)
      .toList();
}
