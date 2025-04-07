import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/api/auth_api.dart';
import 'loginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      User? user = await _authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
        _phoneController.text.trim(),
      );
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup Successful'), behavior: SnackBarBehavior.floating)
        );
        user = null;
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage(verify: true,)), (_) => false);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup Failed'), behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup Failed: $e'), behavior: SnackBarBehavior.floating),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff16A085),
                Color(0xff0B3D2E),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 80.0, left: 22),
              child: Text(
                'Create Your\nAccount',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                color: Colors.white,
              ),
             height: double.infinity,
             width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person,
                          validator: (value) =>
                          value!.isEmpty ? 'Name is required' : null,
                        ),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email ID',
                          icon: Icons.email,
                          validator: (value) {
                            if (value!.isEmpty) return 'Email is required';
                            if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock,
                          obscureText: true,
                          validator: (value) =>
                          value!.length < 6 ? 'Password must be 6+ chars' : null,
                        ),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          icon: Icons.lock,
                          obscureText: true,
                          validator: (value) =>
                          value != _passwordController.text
                              ? 'Passwords do not match'
                              : null,
                        ),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) return 'Phone number is required';
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(value))
                              return 'Enter a valid phone number';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : _buildSignUpButton(),
                        const SizedBox(height: 80),
                      ],
                    ),
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          suffixIcon: Icon(icon, color: Colors.grey),
          labelText: label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff16A085),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      height: 55,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(colors: [
          Color(0xff16A085),
          Color(0xff0B3D2E),
        ]),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: _signUp,
        child: const Text(
          'SIGN UP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
