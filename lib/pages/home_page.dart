import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/food_item.dart';
import '../utils/notification_util.dart';
import 'add_food_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box box = Hive.box('foodBox');

  Color getStatusColor(DateTime storeTime, int keepDays) {
    final now = DateTime.now();
    final expire = storeTime.add(Duration(days: keepDays));
    final diff = expire.difference(now).inDays;
    if (diff < 0) return Colors.red;
    if (diff <= 2) return Colors.orange;
    return Colors.green;
  }

  String getLeftDay(DateTime storeTime, int keepDays) {
    final now = DateTime.now();
    final expire = storeTime.add(Duration(days: keepDays));
    final diff = expire.difference(now).inDays;
    if (diff < 0) return "已过期";
    return "剩余${diff}天";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("食材保鲜计时Pro")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddFoodPage()),
        ).then((_) => setState(() {})),
        child: const Icon(Icons.add),
      ),
      body: box.isEmpty
          ? const Center(child: Text("暂无食材，点击+添加"))
          : ListView.builder(
              itemCount: box.length,
              itemBuilder: (ctx, idx) {
                FoodItem item = box.getAt(idx);
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(getLeftDay(item.storeTime, item.keepDays)),
                  leading: CircleAvatar(
                    backgroundColor: getStatusColor(item.storeTime, item.keepDays),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await NotificationUtil.cancelNotify(item.notifyId);
                      item.delete();
                      setState(() {});
                    },
                  ),
                );
              },
            ),
    );
  }
}