import 'package:flutter/material.dart';
import '../workers/worker_list_screen.dart';
import '../../core/database/db_helper.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int workersCount = 0;
  double totalWages = 0;

  Future<void> _loadStats() async {
    final db = await DBHelper.database;
    final workers = await db.query('workers');
    double sum = 0;
    for (var w in workers) {
      sum += (w['daily_wage'] as num?)?.toDouble() ?? 0;
    }
    setState(() {
      workersCount = workers.length;
      totalWages = sum;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة التحكم')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(child: ListTile(title: const Text('عدد العمال'), trailing: Text('$workersCount'))),
            Card(child: ListTile(title: const Text('إجمالي الأجور اليومية'), trailing: Text('$totalWages جنيه'))),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => WorkerListScreen()));
                _loadStats();
              },
              child: const Text('إدارة العمال'),
            ),
          ],
        ),
      ),
    );
  }
}
