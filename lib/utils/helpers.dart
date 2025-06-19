// lib/utils/helpers.dart

String generateImagePath(String categoryTitle, String cardName) {
  const categoryToFolderMap = {
    'Cartas de Tarô': 'tarot',
    'Cartas Espectrais': 'spectral',
    'Cartas Celestiais': 'celestial',
    'Coringas': 'jokers',
    'Baralhos': 'decks',
  };

  String slugify(String text) {
    String str = text.toLowerCase();
    str = str.replaceAll('á', 'a').replaceAll('ã', 'a').replaceAll('â', 'a').replaceAll('à', 'a');
    str = str.replaceAll('é', 'e').replaceAll('ê', 'e');
    str = str.replaceAll('í', 'i');
    str = str.replaceAll('ó', 'o').replaceAll('õ', 'o').replaceAll('ô', 'o');
    str = str.replaceAll('ú', 'u');
    str = str.replaceAll('ç', 'c');
    str = str.replaceAll(' ', '_');
    str = str.replaceAll(RegExp(r'[^a-z0-9_]'), '');
    return str;
  }

  final folderName = categoryToFolderMap[categoryTitle] ?? 'default';
  final fileName = slugify(cardName);

  return 'assets/images/cards/$folderName/$fileName.png';
}