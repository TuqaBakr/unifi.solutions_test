import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unifi_solutions/core/constants/enums/toast_status.dart';
import 'package:unifi_solutions/core/utils/app_toast.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';


class AddUserForm extends StatefulWidget {
  const AddUserForm({super.key});

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
  TextEditingController(text: "John Doe");
  final TextEditingController _emailController =
  TextEditingController(text: "john.doe123@example.com");

  String _gender = "male";
  String _status = "active";

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _addUser() {
    if (_formKey.currentState!.validate()) {
      context.read<UserCubit>().addUser( name: _nameController.text,
        email: _emailController.text,
        gender: _gender,
        status: _status,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) =>
      current is AddUserSuccess || current is AddUserFailure,
      listener: (context, state) {
        if (state is AddUserSuccess) {
            AppToast.showToast(description: ' User "${state.newUser.name}" added successfully!', status: ToastStatus.success, context: context);
          context.pop();
        } else if (state is AddUserFailure) {
          AppToast.showToast(description: ' Error: ${state.failure.message}', status: ToastStatus.error, context: context);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                label: "Name",
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                value: _gender,
                items: const [
                  DropdownMenuItem(value: "male", child: Text("Male")),
                  DropdownMenuItem(value: "female", child: Text("Female")),
                ],
                onChanged: (value) => setState(() => _gender = value!),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                value: _status,
                items: const [
                  DropdownMenuItem(value: "active", child: Text("Active")),
                  DropdownMenuItem(value: "inactive", child: Text("Inactive")),
                ],
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 30),
              Center(
                child: BlocBuilder<UserCubit, UserState>(
                  buildWhen: (previous, current) => current is UserLoading || previous is UserLoading,
                  builder: (context, state) {
                    final isLoading = state is UserLoading;
                    return CustomButton(
                      label: "Add User",
                      fontSize: 18,
                      onPressed: isLoading ? null : _addUser,
                      isLoading: isLoading,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
