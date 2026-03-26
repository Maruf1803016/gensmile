// lib/features/staff/data/models/staff_model.dart

class StaffPermissions {
  final bool viewPatients;
  final bool editPatients;
  final bool deletePatients;
  final bool runSimulations;
  final bool viewReports;
  final bool manageBilling;
  final bool manageStaff;

  const StaffPermissions({
    this.viewPatients = false,
    this.editPatients = false,
    this.deletePatients = false,
    this.runSimulations = false,
    this.viewReports = false,
    this.manageBilling = false,
    this.manageStaff = false,
  });

  StaffPermissions copyWith({
    bool? viewPatients,
    bool? editPatients,
    bool? deletePatients,
    bool? runSimulations,
    bool? viewReports,
    bool? manageBilling,
    bool? manageStaff,
  }) => StaffPermissions(
    viewPatients: viewPatients ?? this.viewPatients,
    editPatients: editPatients ?? this.editPatients,
    deletePatients: deletePatients ?? this.deletePatients,
    runSimulations: runSimulations ?? this.runSimulations,
    viewReports: viewReports ?? this.viewReports,
    manageBilling: manageBilling ?? this.manageBilling,
    manageStaff: manageStaff ?? this.manageStaff,
  );
}

class ModuleAccess {
  final bool dashboard;
  final bool patients;
  final bool simulation;
  final bool results;
  final bool labLinks;
  final bool billing;
  final bool settings;

  // per-module CRUD flags (desktop view shows Create/Edit/Remove/View)
  // mobile view shows Edit/View only
  final Map<String, Set<String>>
  crudMap; // module -> {'create','edit','remove','view'}

  const ModuleAccess({
    this.dashboard = false,
    this.patients = false,
    this.simulation = false,
    this.results = false,
    this.labLinks = false,
    this.billing = false,
    this.settings = false,
    this.crudMap = const {},
  });

  ModuleAccess copyWith({
    bool? dashboard,
    bool? patients,
    bool? simulation,
    bool? results,
    bool? labLinks,
    bool? billing,
    bool? settings,
    Map<String, Set<String>>? crudMap,
  }) => ModuleAccess(
    dashboard: dashboard ?? this.dashboard,
    patients: patients ?? this.patients,
    simulation: simulation ?? this.simulation,
    results: results ?? this.results,
    labLinks: labLinks ?? this.labLinks,
    billing: billing ?? this.billing,
    settings: settings ?? this.settings,
    crudMap: crudMap ?? this.crudMap,
  );
}

enum StaffStatus { active, pending, inactive }

class StaffMember {
  final String id;
  final String employeeId;
  final String name;
  final String role;
  final String department;
  final String email;
  final String phone;
  final String address;
  final DateTime joinedDate;
  final StaffStatus status;
  final StaffPermissions permissions;
  final ModuleAccess moduleAccess;
  final int totalPatients;
  final int activeCases;
  final int completed;
  final double avgRating;
  final List<StaffActivity> recentActivity;

  const StaffMember({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.role,
    required this.department,
    required this.email,
    required this.phone,
    required this.address,
    required this.joinedDate,
    required this.status,
    required this.permissions,
    required this.moduleAccess,
    this.totalPatients = 0,
    this.activeCases = 0,
    this.completed = 0,
    this.avgRating = 0.0,
    this.recentActivity = const [],
  });

  // ✅ Proper copyWith
  StaffMember copyWith({
    String? id,
    String? employeeId,
    String? name,
    String? role,
    String? department,
    String? email,
    String? phone,
    String? address,
    DateTime? joinedDate,
    StaffStatus? status,
    StaffPermissions? permissions,
    ModuleAccess? moduleAccess,
    int? totalPatients,
    int? activeCases,
    int? completed,
    double? avgRating,
    List<StaffActivity>? recentActivity,
  }) {
    return StaffMember(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      name: name ?? this.name,
      role: role ?? this.role,
      department: department ?? this.department,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      joinedDate: joinedDate ?? this.joinedDate,
      status: status ?? this.status,
      permissions: permissions ?? this.permissions,
      moduleAccess: moduleAccess ?? this.moduleAccess,
      totalPatients: totalPatients ?? this.totalPatients,
      activeCases: activeCases ?? this.activeCases,
      completed: completed ?? this.completed,
      avgRating: avgRating ?? this.avgRating,
      recentActivity: recentActivity ?? this.recentActivity,
    );
  }

  String get initials {
    if (name.trim().isEmpty) return '?';

    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';

    if (parts.length == 1) {
      final w = parts[0];
      return w.length >= 2
          ? w.substring(0, 2).toUpperCase()
          : w.substring(0, 1).toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class StaffActivity {
  final String description;
  final String timeAgo;
  final StaffActivityType type;

  const StaffActivity({
    required this.description,
    required this.timeAgo,
    required this.type,
  });
}

enum StaffActivityType { simulation, patient, labLink, treatment, email }
