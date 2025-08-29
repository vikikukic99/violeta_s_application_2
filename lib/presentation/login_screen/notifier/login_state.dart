import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Define placeholder controllers since the notifier isn't available
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(22),
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogoSection(context),
                  _buildTitleSection(context),
                  _buildFormSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget - Logo
  Widget _buildLogoSection(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: 36,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Section Widget - Title
  Widget _buildTitleSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        Text(
          'WalkTalk',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 14),
        Text(
          'Connect through walking',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  /// Section Widget - Form
  Widget _buildFormSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 46),
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[900]!),
              ),
              contentPadding: EdgeInsets.all(16),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value?.isEmpty == true ? 'Email required' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[900]!),
              ),
              contentPadding: EdgeInsets.all(16),
            ),
            obscureText: true,
            validator: (value) => value?.isEmpty == true ? 'Password required' : null,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[500],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
            ),
            onPressed: () => _onTapLogin(context),
            child: Text(
              'Log in',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Don\'t have an account?',
            style: TextStyle(fontSize: 16, color: Colors.grey[900]),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () => _onTapCreateAccount(context),
            child: Text(
              'Create Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildDividerSection(context),
          SizedBox(height: 16),
          _buildSocialButtonsSection(context),
        ],
      ),
    );
  }

  /// Section Widget - Divider
  Widget _buildDividerSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(width: 12),
        Text(
          'or continue with',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  /// Section Widget - Social Buttons
  Widget _buildSocialButtonsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.g_mobiledata, color: Colors.grey[900]),
            label: Text('Google', style: TextStyle(color: Colors.grey[900])),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            ),
            onPressed: () => _onTapGoogleLogin(context),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.apple, color: Colors.grey[900]),
            label: Text('Apple', style: TextStyle(color: Colors.grey[900])),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            ),
            onPressed: () => _onTapAppleLogin(context),
          ),
        ),
      ],
    );
  }

  /// Login button tap
  void _onTapLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to activity selection screen
      Navigator.pushReplacementNamed(context, '/activity_selection_screen');
    }
  }

  /// Create account tap
  void _onTapCreateAccount(BuildContext context) {
    Navigator.pushNamed(context, '/registration_screen');
  }

  /// Google login tap
  void _onTapGoogleLogin(BuildContext context) {
    // Handle Google login
  }

  /// Apple login tap
  void _onTapAppleLogin(BuildContext context) {
    // Handle Apple login
  }
}