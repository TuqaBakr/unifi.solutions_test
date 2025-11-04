import 'package:flutter/material.dart';

import '../widgets/add_user_form.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New User'),
        backgroundColor: Colors.blueGrey,
      ),
      body: const SingleChildScrollView(
        child: AddUserForm(),
      ),
    );
  }
}
