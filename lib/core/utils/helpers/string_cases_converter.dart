String camelToSnakeCase(String camelCase) {
  String snakeCase = '';
  for (int i = 0; i < camelCase.length; i++) {
    final letter = camelCase[i];
    if (letter != letter.toUpperCase()) {
      snakeCase += letter;
    } else {
      snakeCase += '_${letter.toLowerCase()}';
    }
  }
  return snakeCase;
}

String snakeToCamelCase(String snakeCase) {
  String camelCase = '';
  bool isCapital = false;
  for (int i = 0; i < snakeCase.length; i++) {
    final letter = snakeCase[i];
    if (letter != '_') {
      if (!isCapital) {
        camelCase += letter;
      } else {
        camelCase += letter.toUpperCase();
        isCapital = false;
      }
    } else {
      isCapital = true;
    }
  }
  return camelCase;
}