import 'package:flutter/material.dart';
import '../../core/database/db_helper.dart';

class WorkerListScreen extends StatefulWidget {
  @override
  _WorkerListScreenState createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  List<Map<String, dynamic>> workers = [];

  Future<void> loadWorkers() async {
    final db = await DBHelper.database;
    final list = await db.query('workers');
    setState(() {
      workers = list;
    });
  }

  @override
  void initState() {
    super.initState();
    loadWorkers();
  }

  void showWorkerDialog({Map<String, dynamic>? worker}) {
    final nameCtrl = TextEditingController(text: worker?['name'] ?? '');
    final phoneCtrl = TextEditingController(text: worker?['phone'] ?? '');
    final roleCtrl = TextEditingController(text: worker?['role'] ?? '');
    final wageCtrl = TextEditingController(text: worker?['daily_wage']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(worker == null ? 'إضافة عامل' : 'تعديل عامل'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'الاسم')),
              TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: 'الهاتف')),
              TextField(controller: roleCtrl, decoration: InputDecoration(labelText: 'الوظيفة')),
              TextField(controller: wageCtrl, decoration: InputDecoration(labelText: 'الأجر اليومي'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              final db = await DBHelper.database;
              final data = {
                'name': nameCtrl.text,
                'phone': phoneCtrl.text,
                'role': roleCtrl.text,
                'daily_wage': double.tryParse(wageCtrl.text) ?? 0,
              };
              if (worker == null) {
                await db.insert('workers', data);
              } else {
                await db.update('workers', data, where: 'id = ?', whereArgs: [worker['id']]);
              }
              Navigator.pop(ctx);
              loadWorkers();
            },
            child: Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('قائمة العمال')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showWorkerDialog(),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: workers.length,
        itemBuilder: (ctx, i) {
          final w = workers[i];
          return ListTile(
            title: Text(w['name']),
            subtitle: Text('${w['role']} - ${w['phone']}'),
            trailing: Text('${w['daily_wage']} جنيه/يوم'),
            onTap: () => showWorkerDialog(worker: w),
            onLongPress: () async {
              final db = await DBHelper.database;
              await db.delete('workers', where: 'id = ?', whereArgs: [w['id']]);
              loadWorkers();
            },
          );
        },
      ),
    );
  }
}
