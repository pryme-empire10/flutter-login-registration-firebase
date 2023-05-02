import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginandsignupwithfirebase/screens/registration_screen.dart';
import '../components/login_singup_btn.dart';
import '../components/mybutton.dart';
import '../components/mytext_field.dart';
import '../constants/image_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_sreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isShowPassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  String? errorMessage;

  bool _saving = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.asset(
                      logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        MyTextField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          labelText: 'Enter your email',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ('Please enter your email');
                            }
                            if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]')
                                .hasMatch(value)) {
                              return ('Enter valid email');
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _emailController.text = value.toString();
                          },
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        MyTextField(
                          controller: _passwordController,
                          obscure: _isShowPassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.done,
                          labelText: 'Enter your password',
                          onSaved: (value) {
                            _passwordController.text = value.toString();
                          },
                          validator: (value) {
                            RegExp regex = RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return ('Password is required for Login');
                            }
                            if (!regex.hasMatch(value)) {
                              return ('Enter a valid password(min. 6 characters)');
                            }
                            return null;
                          },
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: togglePasswordIcon(),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  MyButton(
                    text: 'Login'.toUpperCase(),
                    onPressed: () {
                      setState(() {
                        _saving = true;
                      });
                      signIn(_emailController.text, _passwordController.text);
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  LoginSignupButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                    text: 'SignUp',
                    title: 'Don\'t have account?',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget togglePasswordIcon() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isShowPassword = !_isShowPassword;
        });
      },
      icon: _isShowPassword
          ? const Icon(Icons.visibility)
          : const Icon(
              Icons.visibility_off,
              color: Colors.grey,
            ),
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(
                      msg: 'Login Successful', toastLength: Toast.LENGTH_LONG),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  )
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case 'Invalid Email':
            errorMessage = 'Your email address appears to be malformed';
            break;
          case 'Wrong Password':
            errorMessage = 'Your password is wrong';
            break;
          case 'User not found':
            errorMessage = 'user with this email does not exist';
            break;
          default:
            errorMessage = 'An underfined error happened';
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}
