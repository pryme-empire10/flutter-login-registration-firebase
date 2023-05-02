import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginandsignupwithfirebase/screens/home_sreen.dart';
import '../components/login_singup_btn.dart';
import '../components/mybutton.dart';
import '../components/mytext_field.dart';
import '../constants/image_strings.dart';
import '../model/user_model.dart';
import 'login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  String? errorMessage;

  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Image.asset(logo),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyTextField(
                        controller: firstNameEditingController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        labelText: 'First name',
                        onSaved: (value) {
                          firstNameEditingController.text = value!;
                        },
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ('First Name cannot be empty');
                          }
                          if (!regex.hasMatch(value)) {
                            return ('Enter a valid name (min. 3 characters)');
                          }
                          return null;
                        },
                        prefixIcon: const Icon(Icons.person_outline),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      MyTextField(
                        controller: lastNameEditingController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        labelText: 'Last name',
                        onSaved: (value) {
                          lastNameEditingController.text = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ('Last Name cannot be empty');
                          }
                          return null;
                        },
                        prefixIcon: const Icon(Icons.person_outline),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      MyTextField(
                        controller: emailEditingController,
                         autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        textInputAction: TextInputAction.next,
                        labelText: 'Email',
                        onSaved: (value) {
                          emailEditingController.text = value!;
                        },
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
                      ),
                      // const SizedBox(
                      //   height: 20.0,
                      // ),
                      // MyTextField(
                      //   controller: phoneEditingController,
                      //   keyboardType: TextInputType.phone,
                      //   prefixIcon: const Icon(Icons.phone_android),
                      //   textInputAction: TextInputAction.next,
                      //   labelText: 'Phone',
                      //   onSaved: (value) {
                      //     confirmPasswordEditingController.text = value!;
                      //   },
                      //   validator: (value) {
                      //     if(confirmPasswordEditingController.text != _passwordEditingController.text){
                      //       return ('Password didn\'t match');
                      //     }
                      //     return null;
                      //   },
                      // ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      MyTextField(
                        controller: _passwordEditingController,
                         autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscure: true,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: const Icon(Icons.visibility),
                        textInputAction: TextInputAction.next,
                        labelText: 'Password',
                        onSaved: (value) {
                          confirmPasswordEditingController.text = value!;
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
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      MyTextField(
                        controller: confirmPasswordEditingController,
                         autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscure: true,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: const Icon(Icons.visibility),
                        textInputAction: TextInputAction.done,
                        labelText: 'Confirm Password',
                        onSaved: (value) {
                          confirmPasswordEditingController.text = value!;
                        },
                        validator: (value) {
                          if (confirmPasswordEditingController.text !=
                              _passwordEditingController.text) {
                            return ('Password didn\'t match');
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                MyButton(
                  text: 'CREATE ACCOUNT',
                  onPressed: () {
                    signUp(
                      emailEditingController.text,
                      _passwordEditingController.text,
                    );
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
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  text: 'Login',
                  title: 'Already have an account?',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFireStore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'Inavalid-email':
          errorMessage = 'Your email address appears to be malformed';
          break;
        case 'Wrong password':
          errorMessage = 'Your password is wrong';
          break;
        case 'User-not-found':
          errorMessage = 'User with the email dosn\'t exist';
          break;
        case 'user-disabled':
          errorMessage = 'User with this email has been disabled';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests';
          break;
        default:
          errorMessage = 'An undefined error happened';
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }

  postDetailsToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.lastName = lastNameEditingController.text;

    await firebaseFirestore
        .collection('Users')
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: 'Account created succefully');
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }
}
