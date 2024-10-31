import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../UI/home_ui.dart';
import '../../core/firebase/firebase_auth.dart';
import '../../core/firebase/firebase_sevice.dart';
import '../../core/utils/routes.dart';
import '../logic/register_cubit.dart';

class SignupUi extends StatefulWidget {
  const SignupUi({
    super.key,
  });

  @override
  State<SignupUi> createState() => _SigninUiState();
}

class _SigninUiState extends State<SignupUi> {
  final bool _validate = false;
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late bool _passwordVisible = true;
  late bool _passwordVisible2 = true;
  void _toggle() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _toggle2() {
    setState(() {
      _passwordVisible2 = !_passwordVisible2;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitRegistration() async {
    final formkey = context.read<RegisterCubit>().formKey;
    if (formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: context.read<RegisterCubit>().emailController.text,
          password: context.read<RegisterCubit>().passwordController.text,
        );

        await userCredential.user!.updateDisplayName(
            context.read<RegisterCubit>().usernameController.text);

        await FireAuth.createUser();

        print("User registered and display name updated successfully");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeUi()),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterCubit(FirebaseService()),
        child: BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Succes Registration"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacementNamed(context, Routes.signUpScreen);
              }
            },
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFFFFFFFF),
                  leading: const BackButton(),
                ),
                body: Container(
                  color: Colors.white,
                  child: Center(
                      child: Stack(
                    children: [
                      const Positioned.fill(
                        top: 50.0,
                        left: 45,
                        child: Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Text(
                            'Sign up with Email',
                            style: TextStyle(
                                color: Color(0xff3D4A7A),
                                fontSize: 33,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      const Positioned.fill(
                        top: 130,
                        left: 20,
                        child: Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Text(
                            'Get chatting with friends and family today by signing up for our chat app!',
                            style: TextStyle(
                                color: Color(0xff797C7B),
                                fontSize: 14,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 250,
                        child: Form(
                          key: context.read<RegisterCubit>().formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                controller: context
                                    .read<RegisterCubit>()
                                    .usernameController,
                                decoration: const InputDecoration(
                                    // border: OutlineInputBorder(),
                                    labelText: 'Your name',
                                    hintText: 'username'),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !value.contains('@')) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                                controller: context
                                    .read<RegisterCubit>()
                                    .emailController,
                                decoration: const InputDecoration(
                                  // border: OutlineInputBorder(),
                                  labelText: 'Your email',
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                obscureText: _passwordVisible,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 6) {
                                    return 'Please enter a valid password (at least 6 characters)';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                controller: context
                                    .read<RegisterCubit>()
                                    .passwordController,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    suffixIcon: IconButton(
                                      onPressed: _toggle,
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // TextFormField(
                              //   obscureText: _passwordVisible2,
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return 'Please enter your password';
                              //     }
                              //     if (value != passwordController.text)
                              //       return 'Not Match';
                              //     return null;
                              //   },
                              //   controller: context
                              //       .read<RegisterCubit>()
                              //       .confirmPassController,
                              //   decoration: InputDecoration(
                              //       // border: OutlineInputBorder(),
                              //       labelText: 'Confirm Password',
                              //       hintText: 'Enter your password',
                              //       suffixIcon: IconButton(
                              //         onPressed: _toggle2,
                              //         icon: Icon(
                              //           // Based on passwordVisible state choose the icon
                              //           _passwordVisible2
                              //               ? Icons.visibility
                              //               : Icons.visibility_off,
                              //           color:
                              //               Theme.of(context).primaryColorDark,
                              //         ),
                              //       )),
                              // ),
                              const SizedBox(
                                height: 50,
                              ),
                              BlocBuilder<RegisterCubit, RegisterState>(
                                builder: (context, state) {
                                  if (state is RegisterLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Center(
                                    child: Container(
                                      height: 70.0,
                                      width: 400,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.black,
                                            Color(0xff3D4A7A)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _submitRegistration,
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0x00ffffff)),
                                        child: const Text(
                                          'Create an account',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontSize: 19.0),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Positioned.fill(
                      //     top: 250,
                      //     child: Container(
                      //       padding: const EdgeInsets.all(10),
                      //       child: TextField(
                      //         controller: nameController,
                      //         decoration: const InputDecoration(
                      //           // border: OutlineInputBorder(),
                      //           labelText: 'Your name',
                      //         ),
                      //       ),
                      //     )),
                      // Positioned.fill(
                      //     top: 340,
                      //     child: Container(
                      //       padding: EdgeInsets.all(10),
                      //       child: TextField(
                      //         controller: emailController,
                      //         decoration: InputDecoration(
                      //           // border: OutlineInputBorder(),
                      //           labelText: 'Your Email',
                      //           errorText: _validate ? "Value Can't Be Empty" : null,
                      //         ),
                      //       ),
                      //     )),
                      // Positioned.fill(
                      //     top: 430,
                      //     child: Container(
                      //       padding: const EdgeInsets.all(10),
                      //       child: TextFormField(
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return 'Please enter some text';
                      //           }
                      //           return null;
                      //         },
                      //         controller: _controller,
                      //         obscureText: true,
                      //         decoration: const InputDecoration(
                      //           // border: OutlineInputBorder(),
                      //           labelText: 'Password',
                      //         ),
                      //       ),
                      //     )),
                      // // Positioned.fill(
                      // //     top: 520,
                      // //     child: Container(
                      // //       decoration:
                      // //           BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      // //       padding: const EdgeInsets.all(10),
                      // //       child: TextField(
                      // //         obscureText: true,
                      // //         controller: passwordController,
                      // //         decoration: const InputDecoration(
                      // //           labelText: 'Confirm Password',
                      // //         ),
                      // //       ),
                      // //     )),
                      // Positioned.fill(
                      //   top: 700,
                      //   bottom: 90,
                      //   right: 30,
                      //   left: 30,
                      //   child: Container(
                      //       child: GestureDetector(
                      //     onTap: () {
                      //       // Navigator.push(context,
                      //       //     MaterialPageRoute(builder: (context) => SigninUi()));
                      //     },
                      //     child: Container(
                      //       height: 50.0,
                      //       decoration: const BoxDecoration(
                      //         gradient: LinearGradient(
                      //           begin: Alignment.centerLeft,
                      //           end: Alignment.centerRight,
                      //           colors: [Colors.black, Color(0xff3D4A7A)],
                      //         ),
                      //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      //       ),
                      //       child: const Center(
                      //         child: Text(
                      //           'Create an account',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.white,
                      //               fontFamily: 'Poppins',
                      //               fontSize: 19.0),
                      //         ),
                      //       ),
                      //     ),
                      //   )),
                      // ),
                      // // Positioned.fill(
                      // //   top: 700,
                      // //   bottom: 90,
                      // //   right: 30,
                      // //   left: 30,
                      // //   child: Container(
                      // //       child: GestureDetector(
                      // //     onTap: () {
                      // //       // Navigator.push(context,
                      // //       //     MaterialPageRoute(builder: (context) => SigninUi()));
                      // //     },
                      // //     child: Container(
                      // //       height: 50.0,
                      // //       decoration: const BoxDecoration(
                      // //         gradient: LinearGradient(
                      // //           begin: Alignment.centerLeft,
                      // //           end: Alignment.centerRight,
                      // //           colors: [Colors.black, Color(0xff3D4A7A)],
                      // //         ),
                      // //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      // //       ),
                      // //       child: const Center(
                      // //         child: Text(
                      // //           'Create an account',
                      // //           style: TextStyle(
                      // //               fontWeight: FontWeight.bold,
                      // //               color: Colors.white,
                      // //               fontFamily: 'Poppins',
                      // //               fontSize: 19.0),
                      // //         ),
                      // //       ),
                      // //     ),
                      // //   )),
                      // // ),
                    ],
                  )),
                ))));
  }
}
