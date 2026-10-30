
import 'package:flutter/material.dart';

void main() {
  runApp(const MediCareApp());
}

const Color teal = Color(0xFF087F8C);
const Color darkBlue = Color(0xFF183B56);
const Color background = Color(0xFFF4F8FB);

class MediCareApp extends StatelessWidget {
  const MediCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediCare',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: teal),
      ),
      home: const LoginPage(),
    );
  }
}

// LOGIN PAGE

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  void login() {
    if (nameController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your details'),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          userName: nameController.text.trim(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Container(
                  height: 95,
                  width: 95,
                  decoration: BoxDecoration(
                    color: teal.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    color: teal,
                    size: 55,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'MediCare',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Personal Medicine Companion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login to manage your medicines.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: nameController,
                  decoration: inputDecoration(
                    'User Name',
                    Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: inputDecoration(
                    'Password',
                    Icons.lock_outline,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Take care of your health every day.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// COMMON INPUT DECORATION

InputDecoration inputDecoration(
  String label,
  IconData icon,
) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: teal),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
  );
}

// MEDICINE MODEL

class Medicine {
  String name;
  String dosage;
  TimeOfDay time;

  Medicine({
    required this.name,
    required this.dosage,
    required this.time,
  });
}

// HOME PAGE

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({
    super.key,
    required this.userName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final dosageController = TextEditingController();

  final List<Medicine> medicines = [];
  final List<String> completedMedicines = [];

  TimeOfDay selectedTime =
      const TimeOfDay(hour: 8, minute: 0);

  int selectedTab = 0;

  // SELECT TIME

  Future<void> chooseTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // ADD MEDICINE

  void addMedicine() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter medicine name'),
        ),
      );
      return;
    }

    setState(() {
      medicines.add(
        Medicine(
          name: nameController.text.trim(),
          dosage: dosageController.text.trim().isEmpty
              ? 'As prescribed'
              : dosageController.text.trim(),
          time: selectedTime,
        ),
      );

      nameController.clear();
      dosageController.clear();
    });

    Navigator.pop(context);
  }

  // ADD MEDICINE BOTTOM SHEET

  void showAddMedicine() {
    nameController.clear();
    dosageController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 22,
                right: 22,
                top: 25,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + 25,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add New Medicine',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: inputDecoration(
                        'Medicine Name',
                        Icons.medication_outlined,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: dosageController,
                      decoration: inputDecoration(
                        'Dosage (as prescribed)',
                        Icons.description_outlined,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.access_time,
                          color: teal,
                        ),
                        title: const Text('Reminder Time'),
                        subtitle: Text(
                          selectedTime.format(context),
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );

                          if (picked != null) {
                            setState(() {
                              selectedTime = picked;
                            });
                            setSheetState(() {});
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: addMedicine,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: teal,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('SAVE MEDICINE'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // MARK AS TAKEN

  void markTaken(int index) {
    setState(() {
      completedMedicines.add(medicines[index].name);
      medicines.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medicine marked as completed'),
      ),
    );
  }

  // DELETE MEDICINE

  void deleteMedicine(int index) {
    setState(() {
      medicines.removeAt(index);
    });
  }

  // DASHBOARD

  Widget dashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF087F8C),
                Color(0xFF36A6A2),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GOOD DAY 👋',
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hello, ${widget.userName}!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Stay healthy. Stay on schedule.',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: statItem(
                      '${medicines.length}',
                      'Pending',
                      Icons.medication,
                    ),
                  ),
                  Expanded(
                    child: statItem(
                      '${completedMedicines.length}',
                      'Completed',
                      Icons.check_circle_outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Schedule",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedTab = 1;
                });
              },
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        medicineList(),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: showAddMedicine,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('ADD NEW MEDICINE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // DASHBOARD STATISTICS

  Widget statItem(
    String count,
    String label,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 27),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 23,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  // MEDICINE LIST

  Widget medicineList() {
    if (medicines.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.medication_outlined,
              size: 45,
              color: teal,
            ),
            SizedBox(height: 10),
            Text(
              'No medicines added yet',
              style: TextStyle(color: Colors.grey),
            ),
            Text('Add your first medicine to get started.'),
          ],
        ),
      );
    }

    return Column(
      children: List.generate(medicines.length, (index) {
        final medicine = medicines[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            leading: Checkbox(
              value: false,
              activeColor: teal,
              onChanged: (value) {
                if (value == true) {
                  markTaken(index);
                }
              },
            ),
            title: Text(
              medicine.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: darkBlue,
              ),
            ),
            subtitle: Text(
              '${medicine.dosage}  •  ${medicine.time.format(context)}',
            ),
            trailing: IconButton(
              tooltip: 'Delete medicine',
              onPressed: () => deleteMedicine(index),
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 26,
              ),
            ),
          ),
        );
      }),
    );
  }

  // HISTORY PAGE

  Widget historyPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medicine History',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        const SizedBox(height: 15),
        if (completedMedicines.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(35),
              child: Text('No completed medicines yet'),
            ),
          )
        else
          ...completedMedicines.map(
            (name) => Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                title: Text(name),
                subtitle: const Text('Marked as taken'),
              ),
            ),
          ),
      ],
    );
  }

  // USER PROFILE PAGE

  Widget profilePage() {
    return Column(
      children: [
        const SizedBox(height: 25),
        const CircleAvatar(
          radius: 55,
          backgroundColor: Color(0xFFE0F2F1),
          child: Icon(
            Icons.person,
            size: 65,
            color: teal,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          widget.userName,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        const Text(
          'MediCare User',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        Card(
          color: Colors.white,
          child: ListTile(
            leading: const Icon(
              Icons.person_outline,
              color: teal,
            ),
            title: const Text('User Name'),
            subtitle: Text(widget.userName),
          ),
        ),
        Card(
          color: Colors.white,
          child: const ListTile(
            leading: Icon(
              Icons.medical_services_outlined,
              color: teal,
            ),
            title: Text('Application'),
            subtitle: Text('MediCare Medicine Assistant'),
          ),
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('LOGOUT'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    super.dispose();
  }

  // MAIN SCREEN

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'MediCare',
          style: TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: teal,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: selectedTab == 0
              ? dashboard()
              : selectedTab == 1
                  ? historyPage()
                  : profilePage(),
        ),
      ),
      floatingActionButton: selectedTab == 1
          ? FloatingActionButton(
              onPressed: showAddMedicine,
              backgroundColor: teal,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: teal.withOpacity(0.12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
