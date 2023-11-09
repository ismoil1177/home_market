class Facilities {
  final String icon;
  final String name;
  Facilities({required this.icon, required this.name});

  factory Facilities.fromJson(Map<String, Object?> json) =>
      Facilities(icon: json['icon'] as String, name: json['name'] as String);

  Map<String, Object?> toJson() => {
        "icon": icon,
        "name": name,
      };

  // @override
  // String toString() {
  //   return "icon: $icon\nname: $name";
  // }

  @override
  bool operator ==(Object? other) {
    return other is Facilities && icon == other.icon && name == other.name;
  }

  @override
  int get hashCode => Object.hash(icon, name);
}
