import 'package:flutter/material.dart';
import '../services/api.dart';
import './lists.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key); // Corrected constructor

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
            backgroundColor:
                Colors.green, // Optional: Set color to green for correct answers
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
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('login'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
