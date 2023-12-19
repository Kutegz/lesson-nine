import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson_nine/app/register/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureTextPassword = true;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: const Text('Login User'),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Icon(Icons.lock),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(r'assets/images/clinicmaster_logo.png'),
                const SizedBox(height: 15),
                Text(
                  "Welcome, good to see you again!",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.grey.shade500),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade900),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        // do additional validation rules
                        return 'Please enter email';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: obscureTextPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.enhanced_encryption),
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.grey.shade500),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade900),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(
                              () => obscureTextPassword = !obscureTextPassword);
                        },
                        icon: obscureTextPassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Password must be entered';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      final email = emailController.text;
                      final password = passwordController.text;

                      // call firebase to login user
                      final result = await signInWithEmailPassword(
                          context, email, password);

                      if (result) {
                        emailController.clear();
                        passwordController.clear();
                        debugPrint("Succesfully Logged in");
                      } else {
                        debugPrint("Failed to Logged in");
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                Divider(
                  thickness: 0.5,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not yet a member?',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ));
                      },
                      child: const Text(
                        'Register here',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepOrange,
        title: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Login with email and password
  Future<bool> signInWithEmailPassword(
      BuildContext context, String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      debugPrint(user?.uid);
      debugPrint(await user?.getIdToken());

      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          debugPrint("Email and password auth not enabled.");
          break;

        default:
          showErrorMessage(context, e.code);
          break;
      }

      return false;
    }
  }
}
