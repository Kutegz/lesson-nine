import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson_nine/app/login/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool obscureTextPassword = true;
  bool obscureTextConfirmPassword = true;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: const Text('Register User'),
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
                  "Let's create an account for you!",
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
                        prefixIcon: const Icon(Icons.email)),
                    validator: (value) => validateEmail(value),
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
                      if (value != null && value.length < 6) {
                        // do additional validation rules
                        return 'Password must be 6 or more characters long';
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
                    controller: confirmPasswordController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: obscureTextConfirmPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.enhanced_encryption),
                      labelText: "Confirm Password",
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
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() => obscureTextConfirmPassword =
                              !obscureTextConfirmPassword);
                        },
                        child: obscureTextConfirmPassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty && value.length < 6) {
                        // do additional validation rules
                        return 'Confirm password must be 6 or more characters long';
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
                      final confirmPassword = confirmPasswordController.text;

                      if (password != confirmPassword) {
                        const error =
                            'Password and Confirm password must match!';
                        showErrorMessage(context, error);
                        return;
                      }

                      // call firebase to create user
                      await registerWithEmailPassword(context, email, password);

                      emailController.clear();
                      passwordController.clear();
                      confirmPasswordController.clear();
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
                        'Sign Up',
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
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                      },
                      child: const Text(
                        'Log in now',
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

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isEmpty || !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
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

  // Register with email and password
  Future<void> registerWithEmailPassword(
      BuildContext context, String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      final token = userCredential.credential?.accessToken;
      final tokenInt = userCredential.credential?.token;

      debugPrint(user?.uid);
      debugPrint(token);
      debugPrint(tokenInt.toString());

      // return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          debugPrint("Email and password auth not enabled.");
          break;
        // case "email-already-in-use":
        //   break;
        default:
          showErrorMessage(context, e.code);
          break;
      }
    }
  }
}
