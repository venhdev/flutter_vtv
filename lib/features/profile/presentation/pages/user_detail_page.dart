import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/components/text_field_custom.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key, required this.userInfo});

  static const String routeName = 'user-detail';
  static const String path = '/user/user-detail';

  final UserInfoEntity userInfo;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  DateTime? _dob;
  bool? _gender;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.userInfo.fullName!;
    _emailController.text = widget.userInfo.email!;
    _dobController.text = StringHelper.convertDateTimeToString(widget.userInfo.birthday!);
    _genderController.text = widget.userInfo.gender! ? 'Nam' : 'Nữ';
    _dob = widget.userInfo.birthday;
    _gender = widget.userInfo.gender;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Set the background color to transparent
        title: const Text('Thông tin cá nhân'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Text('Name: ${userInfo.fullName}'),
                // Text('gender: ${userInfo.gender}'),
                // Text('Email: ${userInfo.email}'),
                // Text('birthday: ${userInfo.birthday}'),
                TextFieldCustom(
                  controller: _fullNameController,
                  label: 'Họ và tên',
                  hint: 'Nhập họ và tên',
                  prefixIcon: const Icon(Icons.badge),
                  isRequired: false,
                ),
                TextFieldCustom(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Nhập email',
                  prefixIcon: const Icon(Icons.email),
                  isRequired: false,
                  readOnly: true,
                  enabledBorderColor: Colors.grey.shade300,
                  focusedBorderColor: Colors.grey.shade300,
                ),
                TextFieldCustom(
                  controller: _genderController,
                  label: 'Giới tính',
                  hint: 'Chọn giới tính của bạn',
                  readOnly: true,
                  isRequired: false,
                  onTap: () async {
                    // show dialog to choose gender
                    final result = await showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: const Text('Chọn giới tính'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('Nam', style: TextStyle(fontSize: 16)),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('Nữ', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    );

                    setState(() {
                      _gender = result as bool?;
                      if (_gender == null) {
                        _genderController.clear();
                      } else if (_gender == true) {
                        _genderController.text = 'Nam';
                      } else {
                        _genderController.text = 'Nữ';
                      }
                    });
                  },
                  prefixIcon: const Icon(Icons.wc),
                ),
                TextFieldCustom(
                  controller: _dobController,
                  readOnly: true,
                  label: 'Ngày sinh',
                  hint: 'Chọn ngày sinh của bạn',
                  prefixIcon: const Icon(Icons.cake),
                  isRequired: false,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      fieldLabelText: 'Ngày sinh',
                      helpText: 'Chọn ngày sinh của bạn',
                      cancelText: 'Hủy',
                      confirmText: 'Chọn',
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(DateTime.now().year - 12), // least 12 years old
                    );

                    if (pickedDate != null) {
                      _dobController.text = StringHelper.convertDateTimeToString(pickedDate);
                      _dob = pickedDate;
                    }
                  },
                ),

                const SizedBox(height: 12),
                _buildSaveButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // add event to bloc
            await context.read<AuthCubit>().editUserProfile(
                    newInfo: UserInfoEntity(
                  customerId: null,
                  username: widget.userInfo.username!,
                  fullName: _fullNameController.text,
                  email: _emailController.text,
                  birthday: _dob,
                  gender: _gender,
                  status: null,
                  roles: null,
                ));
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.authenticating) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return const Text(
              'Lưu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }
}
