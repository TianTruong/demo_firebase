import 'package:flutter/material.dart';
import 'package:demo_firebase/page/add_page/add_page.dart';
import 'package:demo_firebase/page/home_page/user_page.dart';
import 'package:demo_firebase/page/home_page/post_page.dart';

class HomePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Cloud Firestore Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Users ...',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 30, color: Colors.black),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const AddUserWidget();
                    }),
                  ),
                ),
              ],
            ),
            const UserWidget(),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'Posts ...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            const PostWidget()
          ],
        ),
      ),
    );
  }
}
