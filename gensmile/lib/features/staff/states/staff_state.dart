// lib/features/staff/states/staff_state.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/staff_model.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────

final _mockStaff = <StaffMember>[
  StaffMember(
    id: '1',
    employeeId: 'EMP-2024-001',
    name: 'Dr. Smith Johnson',
    role: 'Lead Dentist',
    department: 'Dental Services',
    email: 'smith@clinic.com',
    phone: '+1 (555) 111-2222',
    address: '123 Main Street, New York, NY 10001',
    joinedDate: DateTime(2024, 1, 15),
    status: StaffStatus.active,
    permissions: const StaffPermissions(
      viewPatients: true,
      editPatients: true,
      runSimulations: true,
      viewReports: true,
    ),
    moduleAccess: ModuleAccess(
      dashboard: true,
      patients: true,
      labLinks: true,
      crudMap: {
        'dashboard': {'create', 'edit', 'remove', 'view'},
        'patients': {'create', 'edit', 'remove', 'view'},
        'labLinks': {'create', 'edit', 'remove', 'view'},
      },
    ),
    totalPatients: 47,
    activeCases: 12,
    completed: 35,
    avgRating: 4.8,
    recentActivity: [
      StaffActivity(
        description: 'Completed simulation for Sarah Johnson',
        timeAgo: '2 hours ago',
        type: StaffActivityType.simulation,
      ),
      StaffActivity(
        description: 'Updated patient record for Michael Davis',
        timeAgo: '5 hours ago',
        type: StaffActivityType.patient,
      ),
      StaffActivity(
        description: 'Generated lab link for Case #C123',
        timeAgo: '1 day ago',
        type: StaffActivityType.labLink,
      ),
      StaffActivity(
        description: 'Reviewed treatment plan for Emily Chen',
        timeAgo: '2 days ago',
        type: StaffActivityType.treatment,
      ),
      StaffActivity(
        description: 'Sent simulation results to patient',
        timeAgo: '3 days ago',
        type: StaffActivityType.email,
      ),
    ],
  ),
  StaffMember(
    id: '2',
    employeeId: 'EMP-2024-002',
    name: 'Dr. Emily Chen',
    role: 'Associate Dentist',
    department: 'Dental Services',
    email: 'emily@clinic.com',
    phone: '+1 (555) 222-3333',
    address: '456 Oak Ave, New York, NY 10002',
    joinedDate: DateTime(2024, 2, 1),
    status: StaffStatus.active,
    permissions: const StaffPermissions(viewPatients: true, editPatients: true),
    moduleAccess: const ModuleAccess(dashboard: true, patients: true),
    totalPatients: 32,
    activeCases: 8,
    completed: 24,
    avgRating: 4.6,
    recentActivity: [],
  ),
  StaffMember(
    id: '3',
    employeeId: 'EMP-2024-003',
    name: 'Sarah Williams',
    role: 'Treatment Coordinator',
    department: 'Coordination',
    email: 'sarah@clinic.com',
    phone: '+1 (555) 333-4444',
    address: '789 Pine St, New York, NY 10003',
    joinedDate: DateTime(2024, 3, 10),
    status: StaffStatus.active,
    permissions: const StaffPermissions(viewPatients: true),
    moduleAccess: const ModuleAccess(dashboard: true, patients: true),
    totalPatients: 18,
    activeCases: 5,
    completed: 13,
    avgRating: 4.7,
    recentActivity: [],
  ),
  StaffMember(
    id: '4',
    employeeId: 'EMP-2024-004',
    name: 'Michael Brown',
    role: 'Lab Coordinator',
    department: 'Laboratory',
    email: 'michael@clinic.com',
    phone: '+1 (555) 444-5555',
    address: '321 Elm Rd, New York, NY 10004',
    joinedDate: DateTime(2024, 4, 5),
    status: StaffStatus.pending,
    permissions: const StaffPermissions(),
    moduleAccess: const ModuleAccess(),
    totalPatients: 0,
    activeCases: 0,
    completed: 0,
    avgRating: 0.0,
    recentActivity: [],
  ),
  StaffMember(
    id: '5',
    employeeId: 'EMP-2024-005',
    name: 'Lisa Davis',
    role: 'Billing Manager',
    department: 'Finance',
    email: 'lisa@clinic.com',
    phone: '+1 (555) 555-6666',
    address: '654 Maple Ave, New York, NY 10005',
    joinedDate: DateTime(2024, 1, 20),
    status: StaffStatus.active,
    permissions: const StaffPermissions(manageBilling: true),
    moduleAccess: const ModuleAccess(dashboard: true, billing: true),
    totalPatients: 0,
    activeCases: 0,
    completed: 0,
    avgRating: 0.0,
    recentActivity: [],
  ),
  StaffMember(
    id: '6',
    employeeId: 'EMP-2024-006',
    name: 'James Wilson',
    role: 'Dental Hygienist',
    department: 'Dental Services',
    email: 'james@clinic.com',
    phone: '+1 (555) 666-7777',
    address: '987 Cedar Blvd, New York, NY 10006',
    joinedDate: DateTime(2024, 2, 15),
    status: StaffStatus.active,
    permissions: const StaffPermissions(viewPatients: true),
    moduleAccess: const ModuleAccess(dashboard: true, patients: true),
    totalPatients: 22,
    activeCases: 6,
    completed: 16,
    avgRating: 4.5,
    recentActivity: [],
  ),
  StaffMember(
    id: '7',
    employeeId: 'EMP-2024-007',
    name: 'Anna Martinez',
    role: 'Associate Dentist',
    department: 'Dental Services',
    email: 'anna@clinic.com',
    phone: '+1 (555) 777-8888',
    address: '147 Birch Lane, New York, NY 10007',
    joinedDate: DateTime(2024, 5, 1),
    status: StaffStatus.inactive,
    permissions: const StaffPermissions(),
    moduleAccess: const ModuleAccess(),
    totalPatients: 10,
    activeCases: 0,
    completed: 10,
    avgRating: 4.2,
    recentActivity: [],
  ),
  StaffMember(
    id: '8',
    employeeId: 'EMP-2024-008',
    name: 'David Lee',
    role: 'Associate Dentist',
    department: 'Dental Services',
    email: 'david@clinic.com',
    phone: '+1 (555) 888-9999',
    address: '258 Walnut Dr, New York, NY 10008',
    joinedDate: DateTime(2024, 3, 25),
    status: StaffStatus.active,
    permissions: const StaffPermissions(viewPatients: true, editPatients: true),
    moduleAccess: const ModuleAccess(dashboard: true, patients: true),
    totalPatients: 28,
    activeCases: 7,
    completed: 21,
    avgRating: 4.4,
    recentActivity: [],
  ),
];

// ── Providers ─────────────────────────────────────────────────────────────────

// Staff filter tab
enum StaffFilterTab { all, active, pending, inactive }

final staffFilterProvider = StateProvider<StaffFilterTab>(
  (ref) => StaffFilterTab.all,
);

// Staff search query
final staffSearchProvider = StateProvider<String>((ref) => '');

// All staff list (in a real app this would come from an API)
final staffListProvider = StateNotifierProvider<StaffNotifier, List<StaffMember>>(
  (ref) => StaffNotifier(_mockStaff),
);

class StaffNotifier extends StateNotifier<List<StaffMember>> {
  StaffNotifier(super.state);

  void addStaff(StaffMember member) {
    state = [...state, member];
  }

  void removeStaff(String id) {
    state = state.where((s) => s.id != id).toList();
  }

  void updateStaff(StaffMember updated) {
    state = state.map((s) => s.id == updated.id ? updated : s).toList();
  }
}

// Filtered staff list
final filteredStaffProvider = Provider<List<StaffMember>>((ref) {
  final all = ref.watch(staffListProvider);
  final filter = ref.watch(staffFilterProvider);
  final query = ref.watch(staffSearchProvider).toLowerCase();

  List<StaffMember> result = all;

  if (filter != StaffFilterTab.all) {
    result = result.where((s) {
      switch (filter) {
        case StaffFilterTab.active:
          return s.status == StaffStatus.active;
        case StaffFilterTab.pending:
          return s.status == StaffStatus.pending;
        case StaffFilterTab.inactive:
          return s.status == StaffStatus.inactive;
        default:
          return true;
      }
    }).toList();
  }

  if (query.isNotEmpty) {
    result = result.where((s) {
      return s.name.toLowerCase().contains(query) ||
          s.email.toLowerCase().contains(query) ||
          s.role.toLowerCase().contains(query);
    }).toList();
  }

  return result;
});

// Staff counts
final staffCountsProvider = Provider<Map<StaffFilterTab, int>>((ref) {
  final all = ref.watch(staffListProvider);
  return {
    StaffFilterTab.all: all.length,
    StaffFilterTab.active: all.where((s) => s.status == StaffStatus.active).length,
    StaffFilterTab.pending: all.where((s) => s.status == StaffStatus.pending).length,
    StaffFilterTab.inactive: all.where((s) => s.status == StaffStatus.inactive).length,
  };
});

// Total seats used / total seats
final seatUsageProvider = Provider<String>((ref) {
  final all = ref.watch(staffListProvider);
  return '${all.where((s) => s.status != StaffStatus.inactive).length}/10';
});
