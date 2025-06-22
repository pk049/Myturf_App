class Turf {
  final String turfName;
  final String pinCode;
  final String price;
  final List<String> photos;
  final int availableSlots;
  final Owner owner;


  Turf({
    required this.turfName,
    required this.pinCode,
    required this.photos,
    required this.availableSlots,
    required this.owner,
    required this.price
  });

  factory Turf.fromJson(Map<String, dynamic> json)
  {
    List<String> photosList = [];
    if (json['photos'] != null)
    {
      photosList = List<String>.from(json['photos']);
    }

    return Turf(
      turfName: json['turf_name'] ?? '',
      pinCode: json['pin_code'] ?? '',
      photos: photosList,
      price:json['price'],
      availableSlots: json['available_slots'] ?? 0,
      owner: Owner.fromJson(json['owner'] ?? {}),
    );

  }

  // Convert Turf object to JSON for easy passing
  Map<String, dynamic> toJson() {
    return {
      'turf_name': turfName,
      'pin_code': pinCode,
      'photos': photos,
      'price':price,
      'available_slots': availableSlots,
      'owner': owner.toJson(),
    };
  }
}

class Owner {
  final String ownerName;
  final String contactNumber;
  final String email;

  Owner({
    required this.ownerName,
    required this.contactNumber,
    required this.email,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      ownerName: json['owner_name'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      email: json['email'] ?? '',
    );
  }

  // Convert Owner object to JSON
  Map<String, dynamic> toJson() {
    return {
      'owner_name': ownerName,
      'contact_number': contactNumber,
      'email': email,
    };
  }
}