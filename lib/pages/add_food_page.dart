import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/food_item.dart';
import '../utils/notification_util.dart';
import 'dart:math';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController dayCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("添加食材")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "食材名称"),
            ),
            TextField(
              controller: dayCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "保鲜天数"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final days = int.tryParse(dayCtrl.text.trim());
                if (name.isEmpty || days == null) return;

                int notifyId = Random().nextInt(100000);
                DateTime expireTime = DateTime.now().add(Duration(days: days));

                FoodItem food = FoodItem(
                  name: name,
                  storeTime: DateTime.now(),
                  keepDays: days,
                  notifyId: notifyId,
                );
                await Hive.box('foodBox').add(food);

                await NotificationUtil.scheduleNotify(
                  id: notifyId,
                  title: "食材到期提醒",
                  body: "【$name】保鲜期限已到，请尽快处理",
                  targetTime: expireTime,
                );

                if (mounted) Navigator.pop(context);
              },
              child: const Text("保存"),
            ),
          ],
        ),
      ),
    );
  }
}