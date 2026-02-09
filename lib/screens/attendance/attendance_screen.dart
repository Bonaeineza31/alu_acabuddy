import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// HEADER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF0B3C6D),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Back to Dashboard",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Attendance Overview",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "ALU's Academic Performance",
                      style: TextStyle(color: Colors.white70),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ATTENDANCE CARD
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Current Attendance Rate",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// CIRCULAR INDICATOR
                    Stack(
                      alignment: Alignment.center,
                      children: [

                        SizedBox(
                          height: 140,
                          width: 140,
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 10,
                            color: Colors.green,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),

                        const Column(
                          children: [
                            Text(
                              "100%",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text("Attendance")
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Excellent! You meet the attendance requirement.",
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// STATUS CARDS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  StatusCard(
                    title: "Present",
                    count: "1",
                    color: Colors.green,
                    icon: Icons.check,
                  ),
                  StatusCard(
                    title: "Late",
                    count: "0",
                    color: Colors.orange,
                    icon: Icons.access_time,
                  ),
                  StatusCard(
                    title: "Absent",
                    count: "0",
                    color: Colors.red,
                    icon: Icons.close,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// SUMMARY SECTION
              buildSummary(),

              const SizedBox(height: 20),

              /// RECENT HISTORY
              buildHistory(),
            ],
          ),
        ),
      ),
    );
  }
}



class StatusCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final IconData icon;

  const StatusCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Text(title),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////

Widget buildSummary() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Summary",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ListTile(
          title: Text("Total Sessions Tracked"),
          trailing: Text("1"),
        ),
        ListTile(
          title: Text("Sessions This Week"),
          trailing: Text("3"),
        ),
        ListTile(
          title: Text("Total Attended"),
          trailing: Text("1"),
        ),
      ],
    ),
  );
}

////////////////////////////////////////////////////////

Widget buildHistory() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const ListTile(
      title: Text("Entrepreneurial Leadership"),
      subtitle: Text("Jan 30, 2026 • 09:00"),
      trailing: Chip(
        label: Text("Present"),
        backgroundColor: Colors.green,
      ),
    ),
  );
}
