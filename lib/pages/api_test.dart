// Quick test file to verify Flask API connection
// Add this temporarily to test your API

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ApiTestPage extends StatefulWidget {
  @override
  _ApiTestPageState createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  String _result = 'Not tested yet';
  bool _isLoading = false;

  Future<void> _testLoginAPI() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing...';
    });

    try {
      // Test with sample data
      final response = await AuthService.login('1234567890', 'testpassword');
      
      setState(() {
        _result = 'Response: ${response.toString()}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Test')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _testLoginAPI,
              child: _isLoading 
                ? CircularProgressIndicator() 
                : Text('Test Login API'),
            ),
            SizedBox(height: 20),
            Text('Result:'),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(_result),
            ),
          ],
        ),
      ),
    );
  }
}