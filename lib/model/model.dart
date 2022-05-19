class User {
  final String name;
  final int age;
  final int phone;

  const User({
    required this.name,
    required this.age,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        age: json['age'],
        phone: json['phone']);
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'age': age, 'phone': phone};

  static List<User> listFromJson(List<dynamic> list) =>
      List<User>.from(list.map((e) => User.fromJson(e)));
}