/* Represents a user in the Atlas application. */
class AtlasUser {
  final String uid; // Document reference ID.
  final String email; // User's email address.
  final String firstName; // User's first name.
  final String lastName; // User's last name.
  final String username; // User's username.

  /// Constructs a new [AtlasUser] instance.
  /// The [uid], [email], [firstName], [lastName], and [username] parameters are required.
  AtlasUser({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
  });
}
