import 'package:flutter/material.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/screens/authenticate/authenticate.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ required this.toggleView });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0,
        title: const Text('Sign In to Brew Crew'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Sign Up'),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              TextFormField(
                decoration: TextInputDecoration.copyWith(hintText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter an email.' : null,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: TextInputDecoration.copyWith(hintText: 'Password'),
                validator: (value) => value!.length < 6 ? 'Enter an password with at least 6 characters.' : null,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[400]),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if (result is String) {
                      setState(() {
                        error = result;
                        loading = false;
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                error,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
