// ignore_for_file: unnecessary_brace_in_string_interps

enum PolishCase { genitive, instrumental }

class PolishNameDeclension {
  static final _softEndings = <String>{
    'ś', 'ć', 'ź', 'ń', 'l', 'j', 'sz', 'cz', 'rz', 'ż', 'dz',
  };

  static final _velarEndings = <String>{'k', 'g'};

  static bool _isFeminine(String name) {
    return name.endsWith('a');
  }

  static bool _endsWithSoftConsonant(String name) {
    if (name.isEmpty) return false;
    final last = name[name.length - 1];
    return _softEndings.contains(last);
  }

  static bool _endsWithVelar(String name) {
    if (name.isEmpty) return false;
    final last = name[name.length - 1];
    return _velarEndings.contains(last);
  }

  static String _genitiveMasculine(String name) {
    return '${name}a';
  }

  static String _genitiveFeminine(String name) {
    if (!name.endsWith('a')) return name;

    final stem = name.substring(0, name.length - 1);

    if (name.endsWith('ia') && name.length > 2) {
      return '${stem}i';
    }

    if (stem.isNotEmpty && _velarEndings.contains(stem[stem.length - 1])) {
      return '${stem}i';
    }

    return '${stem}y';
  }

  static String _instrumentalMasculine(String name) {
    if (_endsWithSoftConsonant(name)) {
      return '${name}em';
    }
    if (_endsWithVelar(name)) {
      return '${name}iem';
    }
    if (name.endsWith('ł')) {
      return '${name}em';
    }
    return '${name}em';
  }

  static String _instrumentalFeminine(String name) {
    if (!name.endsWith('a')) return name;

    final stem = name.substring(0, name.length - 1);

    if (name.endsWith('ia') && name.length > 2) {
      return '${stem}ą';
    }

    return '${stem}ą';
  }

  static String decline(String name, PolishCase grammaticalCase) {
    if (name.isEmpty) return name;

    switch (grammaticalCase) {
      case PolishCase.genitive:
        return _isFeminine(name)
            ? _genitiveFeminine(name)
            : _genitiveMasculine(name);
      case PolishCase.instrumental:
        return _isFeminine(name)
            ? _instrumentalFeminine(name)
            : _instrumentalMasculine(name);
    }
  }

  static String possessive(String name) {
    return decline(name, PolishCase.genitive);
  }

  static String withName(String name) {
    return decline(name, PolishCase.instrumental);
  }
}
