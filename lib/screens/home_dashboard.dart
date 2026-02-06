import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/app_colors.dart';

/// Home Dashboard - Main screen after login
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final attendanceProvider = Provider.of<AssignmentProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView( // Prevents Pixel overflow errors
        child: Column(
          children: [
            // --- SECTION 1: HEADER (Blue Box from Figma) ---
            Container(
              padding: const EdgeInsets.only(top: 60, left 20, right: 20, bottom: 30),
              decoration: const BoxDecoration(
                color: AppColors.primary, // Dark Blue 
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
             ),
              child: Coloum(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Week 4", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  const Text("Welcome back, Bonae! 👋", 
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text("Monday, January 26, 2026", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // --- SECTION 2: SUMMARY CARDS (Logic-driven) ---
                  Row(
                    children: [
                      // Attendance Card
                      Expanded(
                        child: _buildStatCard(
                          title: "${attendanceProvider.attendancePercentage.toStringAsFixed(0)}%",
                          subtitle: "Attendance Rate",
                          // LOGIC: Turns Red if below 75%, otherwise Green
                          color: attendanceProvider.isBelowMinimum ? AppColors.danger : AppColors.success,
                          icon: Icons.calendar_today,
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Pending Tasks Card
                      Expanded(
                        child: _buildStatCard(
                          title: "${assignmentProvider.pendingCount}", // Pulls from your Task provider
                          subtitle: "Pending Tasks",
                          color: AppColors.primary,
                          icon: Icons.local_fire_department,
                        ),
                      ),
                    ],
                  ),

                  // --- SECTION 3: AT-RISK WARNING (Only shows if < 75%) ---
                  if (attendanceProvider.isBelowMinimum)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withOpacity(0.1),
                        border: Border.all(color: AppColors.danger),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.warning, color: AppColors.danger),
                          SizedBox(width: 10),
                          Text("AT RISK: Keep attendance above 75%!", 
                            style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),

                  // --- SECTION 4: TODAY'S SCHEDULE (ListView) ---
                  const SizedBox(height: 25),
                  _sectionHeader("Today's Schedule"),
                  // You will build a ListView.builder here to pull from session_provider
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable card widget to match your Figma's rounded corners
  Widget _buildStatCard({required String title, required String subtitle, required Color color, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const Icon(Icons.more_horiz),
      ],
    );
  }
}
                
            
}
