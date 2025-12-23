String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email required';
  final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  if (!regex.hasMatch(value.trim())) return 'Invalid email';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.length < 6) return 'Min 6 characters';
  return null;
}

String? validateDisplayName(String? value) {
  if (value == null || value.trim().length < 2) return 'Enter your name';
  return null;
}