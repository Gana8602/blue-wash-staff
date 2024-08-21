class Phone {
  String number;

  Phone({required this.number});

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(number: json['phone_number']);
  }
}
