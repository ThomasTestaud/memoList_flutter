import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/lists.dart';
import './lists.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key); // Corrected constructor

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _offlineMode() {
    ServiceList.online = false;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ListsPage()),
    );
  }

  void _submitForm() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final api = Api();

    // Capture the context before the async call
    final BuildContext currentContext = context;

    try {
      var result = await api
          .post('/user/login', {'identifier': username, 'password': password});
      if (result['token'] is String) {
        Api.setToken(result['token']);

        // Show a SnackBar for a correct login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully logged in! Welcome back!'),
            backgroundColor: Colors
                .green, // Optional: Set color to green for correct answers
            duration:
                Duration(seconds: 2), // Optional: Adjust the duration as needed
          ),
        );

        Navigator.pushReplacement(
          currentContext, // Use the captured context
          MaterialPageRoute(builder: (context) => ListsPage()),
        );
      } else {
        // Show a SnackBar for an incorrect login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Server error. Try again!'),
            backgroundColor:
                Colors.red, // Optional: Set color to red for incorrect answers
            duration:
                Duration(seconds: 2), // Optional: Adjust the duration as needed
          ),
        );
      }
    } catch (error) {
      //print('Error: $error');

      // Show a SnackBar for an error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect login. Try again!'),
          backgroundColor:
              Colors.red, // Optional: Set color to red for incorrect answers
          duration:
              Duration(seconds: 2), // Optional: Adjust the duration as needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MemoList',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 255, 200, 0),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person), // Add an icon
                        border:
                            OutlineInputBorder(), // Adds border to the TextFormField
                        labelStyle: TextStyle(
                            color: Color.fromARGB(
                                255, 157, 123, 0)), // Custom label color
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock), // Add an icon
                        border:
                            OutlineInputBorder(), // Adds border to the TextFormField
                        labelStyle: TextStyle(
                            color: Color.fromARGB(
                                255, 157, 123, 0)), // Custom label color
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Log In', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        primary:
                            Color.fromARGB(255, 255, 200, 0), // Button color
                        onPrimary: Colors.white, // Text color
                        minimumSize: Size(double.infinity, 50), // Button size
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: _offlineMode,
                      child: Text('Offline mode', style: TextStyle(fontSize: 18)),
                      style: TextButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 200, 0), // Text color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
