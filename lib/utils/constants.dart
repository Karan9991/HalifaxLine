class AppConstants {
  static const String appName = 'Halifax Line';

  // Radius for Halifax geofence (meters).
  static const double halifaxRadiusMeters = 25000; // 25 km

  // Links
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsUrl = 'https://example.com/terms';
  static const String guidelinesUrl = 'https://example.com/guidelines';

  // Time slot minutes for overlap bucketing
  static const int slotMinutes = 15;

  // Collections
  static const String usersCollection = 'users';
  static const String chatsCollection = 'chats';
  static const String messagesSubcollection = 'messages';
  static const String matchesCollection = 'matches';
  static const String blocksSubcollection = 'blocks';
}