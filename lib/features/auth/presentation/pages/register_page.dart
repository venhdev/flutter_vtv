import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/helpers/converter.dart';
import '../../domain/dto/register_params.dart';
import '../bloc/auth_cubit.dart';
import '../components/text_field_custom.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String routeName = 'register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool? _gender;
  DateTime? _dob;

  @override
  void dispose() {
    _fullNameController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "VTV",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ribeye(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFieldCustom(
                    controller: _fullNameController,
                    label: 'Họ và tên',
                    hint: 'Nhập tên đầy đủ của bạn',
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  const SizedBox(height: 12),
                  TextFieldCustom(
                    controller: _genderController,
                    label: 'Giới tính',
                    hint: 'Chọn giới tính của bạn',
                    readOnly: true,
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
                  const SizedBox(height: 12),
                  TextFieldCustom(
                    controller: _dobController,
                    readOnly: true,
                    label: 'Ngày sinh',
                    hint: 'Chọn ngày sinh của bạn',
                    prefixIcon: const Icon(Icons.cake),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(DateTime.now().year - 12), // least 12 years old
                      );

                      if (pickedDate != null) {
                        _dobController.text = convertDateTimeToString(pickedDate, pattern: 'dd/MM/yyyy');
                        _dob = pickedDate;
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFieldCustom(
                    controller: _usernameController,
                    label: 'Tài khoản',
                    hint: 'Nhập tên tài khoản',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 12),
                  TextFieldCustom(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Nhập email',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 12),
                  TextFieldCustom(
                    controller: _passwordController,
                    label: 'Mật khẩu',
                    hint: 'Nhập mật khẩu',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 12),
                  TextFieldCustom(
                    controller: _confirmPasswordController,
                    label: 'Xác nhận mật khẩu',
                    hint: 'Nhập lại mật khẩu',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock),
                  ),

                  const SizedBox(height: 18),
                  // btn login
                  _buildRegisterButton(context),
                  const SizedBox(height: 12),
                  // redirect to login page
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => context.go('/user/login'),
                      child: const Text(
                        'Đã có tài khoản? Đăng nhập ngay',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildRegisterButton(BuildContext context) {
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
            await context.read<AuthCubit>().register(RegisterParams(
                  username: _usernameController.text.trim(),
                  password: _passwordController.text.trim(),
                  email: _emailController.text.trim(),
                  fullName: _fullNameController.text.trim(),
                  gender: _gender!,
                  birthday: _dob!,
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
              'Đăng ký',
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
