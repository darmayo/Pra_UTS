class Item {
  int id;
  String website;
  String email;
  String iconPath;

  Item({required this.id, required this.website, required this.email, required this.iconPath});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      website: json['title'],
      email: json['body'],
      iconPath: _getIconPath(json['title']),
    );
  }

  static String _getIconPath(String website) {
    if (website.contains("memememe")) {
      return 'assets/icons/memememe.png';
    } else {
      return 'assets/icons/default_icon.png';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': website,
      'body': email,
    };
  }
}