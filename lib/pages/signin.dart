import 'package:flutter/material.dart';
import 'package:smart_parking/pages/color.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controllers for form inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  // Loading state
  bool _isLoading = false;

  // Handle registration API call
  Future<void> _handleRegistration() async {
    // Validate input
    if (_nameController.text.trim().isEmpty) {
      _showErrorMessage('Please enter your full name');
      return;
    }
    
    if (_phoneController.text.trim().isEmpty) {
      _showErrorMessage('Please enter your phone number');
      return;
    }
    
    if (_passwordController.text.trim().isEmpty) {
      _showErrorMessage('Please enter your password');
      return;
    }

    // if (_passwordController.text.trim().length < 6) {
    //   _showErrorMessage('Password must be at least 6 characters long');
    //   return;
    // }
    
    if (_confirmPasswordController.text.trim().isEmpty) {
      _showErrorMessage('Please confirm your password');
      return;
    }

    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      _showErrorMessage('Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call your Flask registration API
      final response = await AuthService.register(
        _phoneController.text.trim(),
        _nameController.text.trim(), 
        _passwordController.text.trim()
      );

      if (AuthService.isRegistrationSuccessful(response)) {
        // Registration successful
        _showSuccessMessage('Account created successfully! You can now login.');
        
        // Navigate back to login page
        Navigator.pop(context);
        
      } else {
        // Registration failed - show error from server
        final errorMessage = AuthService.getRegistrationErrorMessage(response);
        _showErrorMessage(errorMessage);
      }
      
    } catch (e) {
      // Handle different types of errors with specific messages
      print('Registration error: $e');
      
      String errorMessage;
      
      if (e is NetworkException) {
        errorMessage = 'Unable to connect to server. Please check your internet connection and try again.';
      } else if (e is ConflictException) {
        errorMessage = 'Phone number already registered. Please use a different phone number or login instead.';
      } else if (e is BadRequestException) {
        errorMessage = 'Please fill in all required fields correctly.';
      } else if (e is ServerException) {
        errorMessage = 'Server is temporarily unavailable. Please try again later.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Connection refused')) {
        errorMessage = 'Unable to connect to server. Please check your internet connection.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Connection timeout. Please check your internet connection and try again.';
      } else {
        errorMessage = 'Registration failed. Please try again.';
      }
      
      _showErrorMessage(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Show success message
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 40),),
                  SizedBox(height: 10,),
                  Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 18),),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 60,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(
                            color: Color.fromRGBO(225, 95, 27, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10)
                          )]
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                              ),
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: "Full Name",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                              ),
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: "Phone Number",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 40,),
                      GestureDetector(
                        onTap: _isLoading ? null : _handleRegistration,
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: _isLoading ? Colors.grey : primaryColor
                          ),
                          child: Center(
                            child: _isLoading 
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      SizedBox(height: 40,),
                      Text("Already have an account? Login", style: TextStyle(color: Colors.grey),),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: primaryColor),
                            color: Colors.white
                          ),
                          child: Center(
                            child: Text("Back to Login", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}