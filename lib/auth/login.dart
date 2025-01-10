import 'package:chef_palette/admin/admin_dashboard.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/index.dart';
import 'package:chef_palette/style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chef_palette/auth/resetpassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Index;
import 'package:shared_preferences/shared_preferences.dart'; 
//since we have a class named Index in index.dart, we need to hide it to avoid conflict

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;
  bool _isLoading = false;
  

Future<void> _login() async {
    //check valid email format to differentiate error 
     final bool emailValid = 
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text);

        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please fill in both email and password.";
      });
      return;
    }

    //let user know the email is not registered + check role
        QuerySnapshot query =  
        await FirebaseFirestore.instance.collection('users').
        where("email", isEqualTo:_emailController.text).
        get();
        
        if (query.docs.isEmpty && emailValid) {
          setState(() {
            _errorMessage = "Email not registered in database.";
          });
          return;
        }
      
      if(query.docs.isNotEmpty){
          if (!emailValid ) {
            setState(() {
              _errorMessage = "Wrong email format.";
            });
            return;
          }
        try{
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );
            
          if (query.docs.first.get('role') == 'admin') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboard()), // Admin login page
              (route) => false,
            );

          } else {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('isLoggedIn', true);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Index(initIndex: 0,)), // Home page after login
              (route) => false, // This removes all routes (i.e., Auth, Login, etc.) from the stack
            );
      }

      setState(() {
      _isLoading = true; // Start loading state 
      _errorMessage = null; 
    });
        
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false; // Stop loading state
        _errorMessage = e.message; // Display error message
      });
    }
    
    
    // else {
    //   setState(() {
    //     _errorMessage = "User role not found.";
    //   });
     }

}


  Future<void> _resetPassword() async {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgotPassword()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
  
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.png', 
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(125, 0, 0, 0),
                      Color.fromARGB(50, 0, 0, 0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 120.0),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 1,
                        ),
                      ]
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height*0.65,
                  margin: const EdgeInsets.only(top: 80),
                  padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 77, 77, 77),
                        offset: Offset(0, -3),
                        blurRadius: 3,
                        blurStyle: BlurStyle.normal,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Welcome Back,",style: CustomStyle.h3,),
                      ),
                      const SizedBox(height: 40),
                      // Email TextField
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          label: Text("Email"),
                          prefixIcon: Icon(Icons.email_rounded),
                          fillColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password TextField
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible, // Toggle visibility based on state
                        decoration: InputDecoration(
                          label: const Text("Password"),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible; // Toggle state
                            });
                          },
                        ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: _resetPassword,
                          child: const Text(
                            "Forgot Password ?",
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      
                      RectButton(
                        bg: CustomStyle.primary,
                        fg: const Color.fromARGB(255, 255, 255, 255),
                        text: "Login",
                        func: _login, 
                        rad: 10,
                      ),
                      if (_errorMessage != null) 
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _errorMessage ?? '',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    
                    ],
                    
                  ),
                ),
              ],
            ),
              if (_isLoading) 
                        Positioned.fill(
                          child: Container(
                        color: Colors.black.withOpacity(0.5), 
                        child: const Center(
                              child: CircularProgressIndicator(), 
                           ),
                          ),
                        ),
          ],
        ),
      )
    );
  }
}