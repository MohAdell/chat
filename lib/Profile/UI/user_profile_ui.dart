import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Sign In/logic/login_cubit.dart';
import '../model/users_info.dart';
import 'Personal_Profile_Ui.dart';

class UserProfileUi extends StatefulWidget {
  const UserProfileUi({super.key});

  @override
  State<UserProfileUi> createState() => _UserProfileUiState();
}

class _UserProfileUiState extends State<UserProfileUi> {
  late final UserProfile usersProfil;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('usersProfil.name'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Color(0xffffffff)),
          // color: Color(0xffffffff),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/user-avatar.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dear Programmer",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "FLUTTER",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  )),
                  SizedBox(
                    width: 80,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade100,
                                Colors.blue.shade400
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.blue,
                                blurRadius: 2,
                                offset: Offset(0, 2))
                          ]),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const PersonalProfileUi()));
                        },
                        minWidth: double.maxFinite,
                        height: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        textColor: const Color(0xff1a2b79),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Material(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ListTile(
                      title: Text('123'),
                      subtitle: Text('Frineds'),
                    )),
                    Expanded(
                        child: ListTile(
                      title: Text('5647'),
                      subtitle: Text('Followers'),
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue.shade100, Colors.blue.shade400],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.blue,
                          blurRadius: 2,
                          offset: Offset(0, 2))
                    ]),
                child: const Column(
                  children: [
                    Text(
                      'Account',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: ()async {
                  SharedPreferences sp = await SharedPreferences.getInstance();

                  sp.clear();
                  context.read<LoginCubit>().logout(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.red.shade100, Colors.red.shade400],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.blue,
                            blurRadius: 2,
                            offset: Offset(0, 2))
                      ]),
                  child: const Column(
                    children: [
                      Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
