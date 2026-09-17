bool isValidName(String name) {
  return RegExp(r'^[A-Z][a-z]+(?:[ -][A-Z][a-z]+)*$').hasMatch(name.trim());
}
