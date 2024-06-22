class Dictionary {
  String meaning;
  String word;
  int puan;
  List<String>? letters;

  Dictionary({required this.word, required this.meaning, required this.puan, this.letters});

  factory Dictionary.fromMap(Map<String, dynamic> map) {
    return Dictionary(
        meaning: map["meaning"],
        word: map["word"],
        letters: [], puan: map["puan"]);
  }
}


