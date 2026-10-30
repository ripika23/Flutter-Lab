import 'package:flutter/material.dart';

void main() {
  runApp(const SmartWaterIntakeTracker());
}

class SmartWaterIntakeTracker extends StatelessWidget {
  const SmartWaterIntakeTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Water Intake Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5FAFF),
      ),
      home: const WaterTrackerHome(),
    );
  }
}

class WaterTrackerHome extends StatefulWidget {
  const WaterTrackerHome({super.key});

  @override
  State<WaterTrackerHome> createState() => _WaterTrackerHomeState();
}

class _WaterTrackerHomeState extends State<WaterTrackerHome> {
  int waterConsumed = 0;
  int dailyGoal = 2000;

  // Stores every valid water entry made today.
  final List<int> waterEntries = [];

  int selectedPage = 0;

  // ----------------------------------------------------------
  // CALCULATED VALUES
  // ----------------------------------------------------------

  int get entryCount => waterEntries.length;

  int get remainingWater {
    final remaining = dailyGoal - waterConsumed;
    return remaining > 0 ? remaining : 0;
  }

  double get progress {
    if (dailyGoal <= 0) {
      return 0;
    }

    final value = waterConsumed / dailyGoal;

    return value > 1 ? 1 : value;
  }

  int get completionPercentage {
    if (dailyGoal <= 0) {
      return 0;
    }

    return ((waterConsumed / dailyGoal) * 100).round();
  }

  // ----------------------------------------------------------
  // ADD WATER
  // ----------------------------------------------------------

  void addWater(int amount) {
    // Extra safety validation.
    if (amount <= 0) {
      showMessage(
        'Please enter a water value greater than 0 mL.',
        isError: true,
      );
      return;
    }

    setState(() {
      waterConsumed += amount;
      waterEntries.add(amount);
    });

    showMessage('$amount mL added successfully! 💧');
  }

  // ----------------------------------------------------------
  // CUSTOM WATER INPUT
  // ----------------------------------------------------------

  void showCustomWaterDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.water_drop,
                color: Colors.blue,
              ),
              SizedBox(width: 10),
              Text('Add Water'),
            ],
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Water amount',
              hintText: 'Example: 350',
              suffixText: 'mL',
              prefixIcon: Icon(Icons.water_drop_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();

                // Empty input validation.
                if (text.isEmpty) {
                  showMessage(
                    'Please enter a water amount.',
                    isError: true,
                  );
                  return;
                }

                final amount = int.tryParse(text);

                // Invalid, zero or negative value validation.
                if (amount == null || amount <= 0) {
                  showMessage(
                    'Water amount must be greater than 0 mL.',
                    isError: true,
                  );
                  return;
                }

                Navigator.pop(dialogContext);
                addWater(amount);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------
  // RESET CONFIRMATION
  // ----------------------------------------------------------

  void showResetConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text('Reset Daily Intake?'),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to reset today\'s water intake and entry count?\n\nThis action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                resetWater();
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void resetWater() {
    setState(() {
      waterConsumed = 0;
      waterEntries.clear();
    });

    showMessage('Today\'s water intake has been reset.');
  }

  // ----------------------------------------------------------
  // CHANGE DAILY GOAL
  // ----------------------------------------------------------

  void showGoalDialog() {
    final controller = TextEditingController(
      text: dailyGoal.toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.flag,
                color: Colors.blue,
              ),
              SizedBox(width: 10),
              Text('Daily Water Goal'),
            ],
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Daily goal',
              hintText: 'Example: 2000',
              suffixText: 'mL',
              prefixIcon: Icon(Icons.flag_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                final goal = int.tryParse(text);

                if (goal == null || goal <= 0) {
                  showMessage(
                    'Daily goal must be greater than 0 mL.',
                    isError: true,
                  );
                  return;
                }

                setState(() {
                  dailyGoal = goal;
                });

                Navigator.pop(dialogContext);

                showMessage(
                  'Daily goal updated to $goal mL! 🎯',
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------
  // SNACKBAR
  // ----------------------------------------------------------

  void showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ----------------------------------------------------------
  // MAIN BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Water Intake Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: selectedPage == 0 ? buildHomePage() : buildSettingsPage(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPage,
        onDestinationSelected: (index) {
          setState(() {
            selectedPage = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // HOME PAGE
  // ----------------------------------------------------------

  Widget buildHomePage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          25,
        ),
        child: Column(
          children: [
            const Text(
              'Stay Hydrated! 💧',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Track your daily water intake and reach your hydration goal.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            // ------------------------------------------------
            // MAIN PROGRESS CARD
            // ------------------------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.water_drop,
                    color: Colors.white,
                    size: 55,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$waterConsumed mL',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'of $dailyGoal mL daily goal',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 22),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 15,
                      backgroundColor: Colors.white30,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '$completionPercentage% Completed',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    waterConsumed >= dailyGoal
                        ? 'Daily goal achieved! 🎉'
                        : '$remainingWater mL remaining',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ------------------------------------------------
            // STATISTICS
            // ------------------------------------------------

            Row(
              children: [
                Expanded(
                  child: statisticCard(
                    icon: Icons.local_drink,
                    title: 'Consumed',
                    value: '$waterConsumed mL',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: statisticCard(
                    icon: Icons.water_drop_outlined,
                    title: 'Remaining',
                    value: '$remainingWater mL',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: statisticCard(
                    icon: Icons.format_list_numbered,
                    title: 'Entries',
                    value: '$entryCount',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: statisticCard(
                    icon: Icons.percent,
                    title: 'Completed',
                    value: '$completionPercentage%',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ------------------------------------------------
            // QUICK ADD
            // ------------------------------------------------

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick Add Water',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: waterButton(250),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: waterButton(500),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: waterButton(750),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: customWaterButton(),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ------------------------------------------------
            // RESET BUTTON
            // ------------------------------------------------

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: showResetConfirmation,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Reset Today',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ------------------------------------------------
            // TODAY'S ENTRIES
            // ------------------------------------------------

            if (waterEntries.isNotEmpty) buildEntriesCard(),

            const SizedBox(height: 20),

            // ------------------------------------------------
            // TIP
            // ------------------------------------------------

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.blue.shade100,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.orange.shade700,
                    size: 32,
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Tip: Keep a water bottle nearby and drink water regularly throughout the day.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // STATISTIC CARD
  // ----------------------------------------------------------

  Widget statisticCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.blue.shade700,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // WATER BUTTON
  // ----------------------------------------------------------

  Widget waterButton(int amount) {
    return ElevatedButton(
      onPressed: () {
        addWater(amount);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade700,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          vertical: 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.water_drop),
          const SizedBox(height: 5),
          Text(
            '+ $amount mL',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // CUSTOM BUTTON
  // ----------------------------------------------------------

  Widget customWaterButton() {
    return ElevatedButton(
      onPressed: showCustomWaterDialog,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade700,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          vertical: 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.add),
          SizedBox(height: 5),
          Text(
            'Custom',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // TODAY'S ENTRIES CARD
  // ----------------------------------------------------------

  Widget buildEntriesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: Colors.blue.shade700,
              ),
              const SizedBox(width: 10),
              const Text(
                'Today\'s Entries',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '$entryCount entries',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(
            waterEntries.length,
            (index) {
              final amount = waterEntries[index];

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: Icon(
                    Icons.water_drop,
                    color: Colors.blue.shade700,
                  ),
                ),
                title: Text(
                  '$amount mL',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Water entry ${index + 1}',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SETTINGS PAGE
  // ----------------------------------------------------------

  Widget buildSettingsPage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Customize your hydration tracker.',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            // Daily goal card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.flag,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Daily Hydration Goal',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Current goal: $dailyGoal mL',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: showGoalDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text('Change Goal'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Reset card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.restart_alt,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Reset Progress',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Reset today\'s water intake and entry count.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: showResetConfirmation,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(
                          color: Colors.red,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Reset Progress'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // About card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Smart Water Intake Tracker',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This application helps users record their daily water intake, monitor their progress, and reach their personal hydration goal.',
                    style: TextStyle(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
