import 'package:flutter/material.dart';

import '../components/text_field_custom.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  static const String routeName = 'forgot-password';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isCodeSent = false;
  bool _isSendingCode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 24),
                  const Text(
                    'Nhập tên tài khoản và mã xác nhận\n được gửi đến email của bạn',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFieldCustom(
                    readOnly: _isCodeSent,
                    controller: _emailController,
                    label: 'Tài khoản',
                    hint: 'Nhập tên tài khoản',
                    isRequired: true,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isSendingCode = true;
                          });

                          await Future.delayed(const Duration(seconds: 3)).then((value) {
                            if (mounted) {
                              // sl<AuthRepository>().(_emailController.text);
                              setState(() {
                                _isSendingCode = false;
                                _isCodeSent = true;
                              });
                            }
                          });
                        }
                      },
                      icon: _isSendingCode ? const CircularProgressIndicator() : const Icon(Icons.send),
                    ),
                  ),
                  // when code is sent add more fields to form
                  if (_isCodeSent) ...[
                    const SizedBox(height: 12),
                    TextFieldCustom(
                      controller: _codeController,
                      label: 'Mã xác nhận',
                      hint: 'Nhập mã xác nhận',
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Chưa nhập mã xác nhận';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFieldCustom(
                      controller: _passwordController,
                      label: 'Mật khẩu mới',
                      hint: 'Nhập mật khẩu mới',
                      isRequired: true,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Chưa nhập mật khẩu mới';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFieldCustom(
                      controller: _confirmPasswordController,
                      label: 'Xác nhận mật khẩu mới',
                      hint: 'Nhập lại mật khẩu mới',
                      isRequired: true,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Chưa nhập lại mật khẩu mới';
                        } else if (value != _passwordController.text) {
                          return 'Mật khẩu không khớp';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đổi mật khẩu thành công, vui lòng đăng nhập lại'),
                              ),
                            );
                            // redirect to login page
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Đổi mật khẩu'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
