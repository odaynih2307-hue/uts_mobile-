class User {
  final String id;
  final String name;
  final String username;
  final String role; // 'admin', 'helpdesk', 'user'

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
  });
}
