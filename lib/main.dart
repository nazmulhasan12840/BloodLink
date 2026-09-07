import 'package:flutter/material.dart';

// ============================================================
// APP DATA
// ============================================================

class BloodRequest {
  final String bloodGroup;
  final int units;
  final String hospitalLocation;
  final String urgency;
  final String status;

  const BloodRequest({
    required this.bloodGroup,
    required this.units,
    required this.hospitalLocation,
    this.urgency = 'Urgent',
    this.status = 'Active',
  });
}

/// Simple in-memory source of truth for the prototype.
/// It keeps submitted requests visible across the app during the session.
class BloodLinkStore extends ChangeNotifier {
  BloodLinkStore._();

  static final BloodLinkStore instance = BloodLinkStore._();

  final List<BloodRequest> _requests = [
    const BloodRequest(
      bloodGroup: 'A+',
      units: 1,
      hospitalLocation: 'Royal Prince Alfred Hospital, Sydney',
      urgency: 'High',
      status: 'Completed',
    ),
  ];

  List<BloodRequest> get requests => List.unmodifiable(_requests);

  void addRequest({
    required String bloodGroup,
    required int units,
    required String hospitalLocation,
  }) {
    _requests.insert(
      0,
      BloodRequest(
        bloodGroup: bloodGroup,
        units: units,
        hospitalLocation: hospitalLocation,
      ),
    );
    notifyListeners();
  }

  BloodRequest? get latestActiveRequest {
    for (final request in _requests) {
      if (request.status == 'Active') return request;
    }
    return null;
  }
}

final bloodLinkStore = BloodLinkStore.instance;


void main() {
  runApp(const BloodLinkApp());
}

// ============================================================
// APP
// ============================================================

class BloodLinkApp extends StatelessWidget {
  const BloodLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BloodLink',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.red,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// ============================================================
// LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  void login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 35),
          child: Column(
            children: [
              const SizedBox(height: 35),

              // Heart icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: Colors.red, size: 40),
              ),

              const SizedBox(height: 28),

              const Text(
                'Welcome to BloodLink',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Connect donors with people in need.',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 45),

              // Email
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Forgot Password?'),
                          content: const Text(
                            'Password reset instructions would be sent to your email.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              const Text(
                'BloodLink • Save lives, one connection at a time.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CREATE ACCOUNT
// ============================================================

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String bloodGroup = 'O+';

  void createAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Account Created'),
          content: const Text(
            'Your BloodLink account has been created successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Join BloodLink',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Create an account to donate blood or request help.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            const Text(
              'Full Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Blood Group',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: bloodGroup,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.bloodtype, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map((group) {
                    return DropdownMenuItem(value: group, child: Text(group));
                  })
                  .toList(),
              onChanged: (value) {
                setState(() {
                  bloodGroup = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Create a password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DASHBOARD
// ============================================================

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 95),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE8EB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.favorite, color: Color(0xFFDB1426)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('BloodLink', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1A1F29))),
                  ),
                  IconButton(
                    tooltip: 'Logout',
                    onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false),
                    icon: const Icon(Icons.logout_outlined, color: Color(0xFF6E7580)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Hello, Nazmul', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF1A1F29))),
              const SizedBox(height: 6),
              const Text('Find blood. Help someone today.', style: TextStyle(fontSize: 15, color: Color(0xFF6E7580))),
              const SizedBox(height: 24),
              _DashboardUrgentCard(onTap: () => openPage(context, const FindDonorPage())),
              const SizedBox(height: 24),
              const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1F29))),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _QuickActionTile(icon: Icons.bloodtype_outlined, label: 'Request Blood', color: const Color(0xFFDB1426), onTap: () => openPage(context, const RequestBloodPage()))),
                  const SizedBox(width: 12),
                  Expanded(child: _QuickActionTile(icon: Icons.favorite_border, label: 'Donate Blood', color: const Color(0xFF1F8C57), onTap: () => openPage(context, const DonateBloodPage()))),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE0E3E8))),
                child: Row(
                  children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFFFE8EB), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFDB1426))),
                    const SizedBox(width: 12),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Emergency Blood Request', style: TextStyle(fontWeight: FontWeight.w700)), SizedBox(height: 4), Text('Request blood quickly for urgent needs.', style: TextStyle(fontSize: 13, color: Color(0xFF6E7580)))])),
                    TextButton(onPressed: () => openPage(context, const RequestBloodPage()), child: const Text('Request')),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: bloodLinkStore,
                builder: (context, _) {
                  final request = bloodLinkStore.latestActiveRequest;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE0E3E8)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF7F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.search, color: Color(0xFF1F8C57)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('My Requests', style: TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(
                                request == null
                                    ? 'No active requests'
                                    : '${request.bloodGroup} • ${request.units} ${request.units == 1 ? 'unit' : 'units'}',
                                style: const TextStyle(fontSize: 13, color: Color(0xFF6E7580)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                request == null ? 'You have no active request' : request.hospitalLocation,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF1F8C57)),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => openPage(context, const MyRequestsPage()),
                          child: const Text('View'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BloodLinkBottomNav(currentIndex: 0, onTap: (index) {
        if (index == 1) openPage(context, const FindDonorPage());
        if (index == 2) openPage(context, const MyRequestsPage());
        if (index == 3) openPage(context, const HistoryPage());
      }),
    );
  }
}

class _DashboardUrgentCard extends StatelessWidget {
  final VoidCallback onTap;
  const _DashboardUrgentCard({required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: const Color(0xFFFFE8EB), borderRadius: BorderRadius.circular(20)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Need blood urgently?', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Color(0xFF1A1F29))),
      const SizedBox(height: 7),
      const Text('Find nearby donors who match your blood group.', style: TextStyle(color: Color(0xFF6E7580))),
      const SizedBox(height: 16),
      SizedBox(height: 46, child: ElevatedButton(onPressed: onTap, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDB1426), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Find a Blood Donor', style: TextStyle(fontWeight: FontWeight.w700)))),
    ]),
  );
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _QuickActionTile({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE0E3E8))), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(.10), borderRadius: BorderRadius.circular(11)), child: Icon(icon, color: color)), const SizedBox(width: 9), Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)))])),
  );
}

class _BloodLinkBottomNav extends StatelessWidget {
  final int currentIndex; final ValueChanged<int> onTap;
  const _BloodLinkBottomNav({required this.currentIndex, required this.onTap});
  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: currentIndex,
    onDestinationSelected: onTap,
    backgroundColor: Colors.white,
    indicatorColor: const Color(0xFFFFE8EB),
    height: 70,
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Find'),
      NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Requests'),
      NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: 'History'),
    ],
  );
}

// ============================================================
// QUICK ACTION
// ============================================================

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 75,
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.red, size: 26),
            ),

            const SizedBox(height: 8),

            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DONOR CARD
// ============================================================

class DonorCard extends StatelessWidget {
  final String name;
  final String bloodGroup;
  final String distance;
  final VoidCallback onTap;

  const DonorCard({
    super.key,
    required this.name,
    required this.bloodGroup,
    required this.distance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bloodGroup,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Text(distance, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// REQUEST BLOOD PAGE
// ============================================================

class RequestBloodPage extends StatefulWidget {
  const RequestBloodPage({super.key});
  @override
  State<RequestBloodPage> createState() => _RequestBloodPageState();
}

class _RequestBloodPageState extends State<RequestBloodPage> {
  String selectedBloodGroup = 'O+';
  final TextEditingController unitsController = TextEditingController(text: '2');
  final TextEditingController hospitalController = TextEditingController();

  void submitRequest() {
    final units = int.tryParse(unitsController.text.trim());
    if (units == null || units < 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid number of units.')));
      return;
    }
    if (hospitalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter the hospital or location.')));
      return;
    }
    final hospitalLocation = hospitalController.text.trim();
    bloodLinkStore.addRequest(
      bloodGroup: selectedBloodGroup,
      units: units,
      hospitalLocation: hospitalLocation,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RequestSuccessPage(
          bloodGroup: selectedBloodGroup,
          units: units,
          hospital: hospitalLocation,
        ),
      ),
    );
  }

  @override
  void dispose() { unitsController.dispose(); hospitalController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8F9FB),
    appBar: AppBar(title: const Text('Request Blood', style: TextStyle(fontWeight: FontWeight.w700)), backgroundColor: const Color(0xFFF8F9FB), surfaceTintColor: Colors.transparent),
    body: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Request blood', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFF1A1F29))),
        const SizedBox(height: 6),
        const Text('Enter the details below so nearby donors can help.', style: TextStyle(color: Color(0xFF6E7580))),
        const SizedBox(height: 24),
        const Text('Blood group', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: const ['A+','A-','B+','B-','AB+','AB-','O+','O-'].map((group) => _BloodGroupChip(group: group)).toList()),
        const SizedBox(height: 22),
        const Text('Units required', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 9),
        TextField(controller: unitsController, keyboardType: TextInputType.number, decoration: _inputDecoration('e.g. 2', Icons.water_drop_outlined)),
        const SizedBox(height: 20),
        const Text('Hospital / location', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 9),
        TextField(controller: hospitalController, decoration: _inputDecoration('Enter hospital or location', Icons.location_on_outlined)),
        const SizedBox(height: 28),
        SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: submitRequest, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDB1426), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('Submit Request', style: TextStyle(fontWeight: FontWeight.w700)))),
      ]),
    ),
  );
}

class _BloodGroupChip extends StatelessWidget {
  final String group;
  const _BloodGroupChip({required this.group});
  @override
  Widget build(BuildContext context) {
    final selected = (context.findAncestorStateOfType<_RequestBloodPageState>()?.selectedBloodGroup == group);
    return ChoiceChip(label: Text(group), selected: selected, onSelected: (_) { final parent = context.findAncestorStateOfType<_RequestBloodPageState>(); if (parent == null) return; parent.setState(() { parent.selectedBloodGroup = group; }); }, labelStyle: TextStyle(fontWeight: FontWeight.w600, color: selected ? Colors.white : const Color(0xFF1A1F29)), selectedColor: const Color(0xFFDB1426), backgroundColor: Colors.white, side: const BorderSide(color: Color(0xFFE0E3E8)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  }
}

InputDecoration _inputDecoration(String hint, IconData icon) => InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: const Color(0xFF6E7580)), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E3E8))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E3E8))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDB1426), width: 1.5)));

class RequestSuccessPage extends StatelessWidget {
  final String bloodGroup; final int units; final String hospital;
  const RequestSuccessPage({super.key, required this.bloodGroup, required this.units, required this.hospital});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8F9FB),
    appBar: AppBar(backgroundColor: const Color(0xFFF8F9FB), surfaceTintColor: Colors.transparent),
    body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 82, height: 82, decoration: const BoxDecoration(color: Color(0xFFEAF7F0), shape: BoxShape.circle), child: const Icon(Icons.check, size: 46, color: Color(0xFF1F8C57))),
      const SizedBox(height: 22),
      const Text('Request submitted', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Text('$bloodGroup • $units ${units == 1 ? 'unit' : 'units'}', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFDB1426))),
      const SizedBox(height: 8),
      Text(hospital, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF6E7580))),
      const SizedBox(height: 28),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDB1426), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.w700)))),
    ]))),
  );
}

// ============================================================
// DONATE BLOOD PAGE
// ============================================================

class DonateBloodPage extends StatefulWidget {
  const DonateBloodPage({super.key});

  @override
  State<DonateBloodPage> createState() => _DonateBloodPageState();
}

class _DonateBloodPageState extends State<DonateBloodPage> {
  String bloodGroup = 'A+';

  void registerDonor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade50,
          title: const Text('Thank You!', style: TextStyle(fontSize: 25)),
          content: const Text('You have been registered as a blood donor.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Done', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Donate Blood',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: 42),
                  SizedBox(height: 15),
                  Text(
                    'Your donation can save lives.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Register as a donor and help people in your community.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Your blood group',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: bloodGroup,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.bloodtype),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map((group) {
                    return DropdownMenuItem(value: group, child: Text(group));
                  })
                  .toList(),
              onChanged: (value) {
                setState(() {
                  bloodGroup = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: registerDonor,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Register as Donor',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FIND DONOR PAGE
// ============================================================

class FindDonorPage extends StatefulWidget {
  const FindDonorPage({super.key});
  @override
  State<FindDonorPage> createState() => _FindDonorPageState();
}

class _FindDonorPageState extends State<FindDonorPage> {
  String selectedGroup = 'O+';
  String distance = 'Within 10 km';
  bool searched = false;

  final List<Map<String, String>> donors = const [
    {'name': 'Rahim K.', 'group': 'O+', 'distance': '2.4 km', 'status': 'Available now'},
    {'name': 'Sadia A.', 'group': 'O+', 'distance': '4.1 km', 'status': 'Available today'},
    {'name': 'Tanvir H.', 'group': 'O+', 'distance': '6.7 km', 'status': 'Available tomorrow'},
    {'name': 'Sarah A.', 'group': 'A+', 'distance': '3.4 km', 'status': 'Available now'},
    {'name': 'Imran H.', 'group': 'B+', 'distance': '4.0 km', 'status': 'Available today'},
  ];

  List<Map<String, String>> get results {
    final maxDistance = switch (distance) {
      'Within 5 km' => 5.0,
      'Within 10 km' => 10.0,
      _ => 20.0,
    };

    return donors.where((donor) {
      final donorDistance =
          double.tryParse(donor['distance']!.replaceAll(' km', '')) ?? 999;
      return donor['group'] == selectedGroup && donorDistance <= maxDistance;
    }).toList()
      ..sort((a, b) {
        final aDistance = double.tryParse(a['distance']!.replaceAll(' km', '')) ?? 999;
        final bDistance = double.tryParse(b['distance']!.replaceAll(' km', '')) ?? 999;
        return aDistance.compareTo(bDistance);
      });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8F9FB),
    appBar: AppBar(title: const Text('Find a Blood Donor', style: TextStyle(fontWeight: FontWeight.w700)), backgroundColor: const Color(0xFFF8F9FB), surfaceTintColor: Colors.transparent),
    body: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Find a blood donor', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        const Text('Search for nearby donors who match your blood group.', style: TextStyle(color: Color(0xFF6E7580))),
        const SizedBox(height: 24),
        const Text('Blood group', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: const ['A+','A-','B+','B-','AB+','AB-','O+','O-'].map((g) => _FindGroupChip(group: g)).toList()),
        const SizedBox(height: 22),
        const Text('Location', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 9),
        DropdownButtonFormField<String>(value: distance, decoration: _inputDecoration('Select distance', Icons.location_on_outlined), items: const ['Within 5 km','Within 10 km','Within 20 km'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => distance = v!)),
        const SizedBox(height: 18),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => setState(() => searched = true), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDB1426), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('Search Donors', style: TextStyle(fontWeight: FontWeight.w700)))),
        if (searched) ...[
          const SizedBox(height: 26),
          Row(children: [const Text('Available donors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), const Spacer(), Text('${results.length} found', style: const TextStyle(color: Color(0xFF6E7580), fontSize: 13))]),
          const SizedBox(height: 12),
          if (results.isEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 35), child: Center(child: Text('No donors found nearby.', style: TextStyle(color: Color(0xFF6E7580))))) else ...results.map((d) => _DonorResultCard(donor: d, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DonorProfilePage(donor: d))))),
        ],
      ]),
    ),
    bottomNavigationBar: _BloodLinkBottomNav(currentIndex: 1, onTap: (index) {
      if (index == 0) Navigator.pop(context);
      if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => const MyRequestsPage()));
      if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
    }),
  );
}

class _FindGroupChip extends StatelessWidget {
  final String group; const _FindGroupChip({required this.group});
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_FindDonorPageState>();
    final selected = state?.selectedGroup == group;
    return ChoiceChip(label: Text(group), selected: selected, onSelected: (_) { if (state == null) return; state.setState(() { state.selectedGroup = group; state.searched = false; }); }, labelStyle: TextStyle(fontWeight: FontWeight.w600, color: selected ? Colors.white : const Color(0xFF1A1F29)), selectedColor: const Color(0xFFDB1426), backgroundColor: Colors.white, side: const BorderSide(color: Color(0xFFE0E3E8)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  }
}

class _DonorResultCard extends StatelessWidget {
  final Map<String, String> donor;
  final VoidCallback onTap;

  const _DonorResultCard({required this.donor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E3E8)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE8EB),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  donor['group']!,
                  style: const TextStyle(
                    color: Color(0xFFDB1426),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(donor['name']!, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(donor['distance']!, style: const TextStyle(color: Color(0xFF6E7580), fontSize: 13)),
                      const SizedBox(width: 7),
                      Container(width: 5, height: 5, decoration: const BoxDecoration(color: Color(0xFF1F8C57), shape: BoxShape.circle)),
                      const SizedBox(width: 5),
                      Text(donor['status']!, style: const TextStyle(color: Color(0xFF1F8C57), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF6E7580)),
          ],
        ),
      ),
    );
  }
}

class DonorProfilePage extends StatelessWidget {
  final Map<String, String> donor;

  const DonorProfilePage({super.key, required this.donor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Donor Profile', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: const Color(0xFFF8F9FB),
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 25),
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(color: Color(0xFFFFE8EB), shape: BoxShape.circle),
              child: Center(child: Text(donor['group']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFFDB1426)))),
            ),
            const SizedBox(height: 16),
            Text(donor['name']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('Blood donor', style: TextStyle(color: Color(0xFF6E7580))),
            const SizedBox(height: 26),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE0E3E8))),
              child: Column(
                children: [
                  _ProfileRow(icon: Icons.bloodtype_outlined, label: 'Blood group', value: donor['group']!),
                  const Divider(height: 26),
                  _ProfileRow(icon: Icons.location_on_outlined, label: 'Distance', value: donor['distance']!),
                  const Divider(height: 26),
                  _ProfileRow(icon: Icons.access_time, label: 'Availability', value: donor['status']!, valueColor: const Color(0xFF1F8C57)),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Donor contact request sent.'))),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDB1426), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: const Text('Contact Donor', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _ProfileRow({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: valueColor ?? const Color(0xFF6E7580)),
        const SizedBox(width: 12),
        Text(label),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: valueColor)),
      ],
    );
  }
}

// ============================================================
// MY REQUESTS
// ============================================================

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          'My Requests',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFFF8F9FB),
        surfaceTintColor: Colors.transparent,
      ),
      body: AnimatedBuilder(
        animation: bloodLinkStore,
        builder: (context, _) {
          final requests = bloodLinkStore.requests;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              if (requests.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Column(
                    children: [
                      Icon(Icons.assignment_outlined, size: 52, color: Color(0xFF9AA1AC)),
                      SizedBox(height: 14),
                      Text(
                        'No blood requests yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Your submitted requests will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF6E7580)),
                      ),
                    ],
                  ),
                )
              else
                ...requests.map(
                  (request) => RequestCard(
                    bloodGroup: request.bloodGroup,
                    hospital: request.hospitalLocation,
                    location: request.hospitalLocation,
                    urgency: request.urgency,
                    status: request.status,
                    units: '${request.units} ${request.units == 1 ? 'unit' : 'units'}',
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: _BloodLinkBottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FindDonorPage()));
          } else if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
          }
        },
      ),
    );
  }
}

// ============================================================
// REQUEST CARD
// ============================================================

class RequestCard extends StatelessWidget {
  final String bloodGroup;
  final String hospital;
  final String location;
  final String urgency;
  final String status;
  final String units;

  const RequestCard({
    super.key,
    required this.bloodGroup,
    required this.hospital,
    required this.location,
    required this.urgency,
    required this.status,
    required this.units,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    bloodGroup,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  hospital,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Text(
                status,
                style: TextStyle(
                  color: status == 'Active' ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            location == hospital
                ? 'Hospital / location: $hospital'
                : 'Location: $location',
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 6),

          Text('Required: $units', style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 6),

          Text(
            'Urgency: $urgency',
            style: TextStyle(
              color: urgency == 'Urgent' ? Colors.red : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HISTORY
// ============================================================

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          HistoryCard(
            icon: Icons.favorite,
            title: 'Blood Donation',
            subtitle: 'Registered as O+ donor',
            date: '20 August 2026',
          ),

          HistoryCard(
            icon: Icons.bloodtype,
            title: 'Blood Request',
            subtitle: 'Requested 2 units of O+',
            date: '18 August 2026',
          ),

          HistoryCard(
            icon: Icons.favorite,
            title: 'Blood Donation',
            subtitle: 'Registered as A+ donor',
            date: '10 August 2026',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HISTORY CARD
// ============================================================

class HistoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String date;

  const HistoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.red),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 5),

                Text(subtitle, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 5),

                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
