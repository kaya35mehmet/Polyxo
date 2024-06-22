
String turkishToUpperCase(String input) {
  final turkishCharacters = {
    'i': 'İ',
    'ş': 'Ş',
    'ç': 'Ç',
    'ğ': 'Ğ',
    'ü': 'Ü',
    'ö': 'Ö',
    'ı': 'I'
  };

  String result = input;
  turkishCharacters.forEach((key, value) {
    result = result.replaceAll(key, value);
  });

  return result.toUpperCase();
}