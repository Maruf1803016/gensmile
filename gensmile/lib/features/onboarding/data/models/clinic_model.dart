class ClinicModel {
  ClinicModel({
    required this.id,
    this.name = '',
    this.address = '',
    this.phoneNumber = '',
    this.logoPath,
  });

  final String id;
  String name;
  String address;
  String phoneNumber;
  String? logoPath;
}

class StaffModel {
  StaffModel({
    required this.id,
    this.name = '',
    this.email = '',
    this.role,
  });

  final String id;
  String name;
  String email;
  String? role;
}

const staffRoles = [
  'Admin',
  'Doctor',
  'Receptionist',
  'Nurse',
  'Manager',
];
