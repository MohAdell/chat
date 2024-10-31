import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../Profile/logic/users_cubit.dart';
import '../../Profile/model/users_info.dart';
import '../logic/rooms_cubit.dart';

class ContactsUi extends StatefulWidget {
  const ContactsUi({super.key});

  @override
  State<ContactsUi> createState() => _ContactsUiState();
}

class _ContactsUiState extends State<ContactsUi> {
  reloadedcontacts() {
    context.read<UsersCubit>().fetchAlluserWithoutme();
  }

  @override
  void initState() {
    reloadedcontacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Text(
            "Contacts",
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 30,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<UsersCubit, UsersState>(builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsersLoaded) {
            return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return CardSelectedUsers(
                    userProfile: user,
                  );
                });
          }

          if (state is UsersError) {
            return Center(child: Text("erro ${state.errormass}"));
          }
          return const Center(child: Text("no users"));
        }));
  }
}

class CardSelectedUsers extends StatelessWidget {
  final UserProfile userProfile;

  const CardSelectedUsers({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final DateTime lastActivated = DateTime.parse(userProfile.lastActivated);
    final formattedTime = DateFormat.jm().format(lastActivated);

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        color: const Color(0xffffffff),
        // decoration: BoxDecoration(color: Color(0xffffffff)),
        child: ListTile(
          selectedColor: const Color(0xff560d0d),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: Image.asset('assets/user-avatar.png'),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          title: Text(
            userProfile.name,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            userProfile.phoneNumber,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.normal,
            ),
          ),
          trailing: Text(
            formattedTime,
            style: const TextStyle(
                fontSize: 15, fontFamily: 'Poppins', color: Colors.black54),
          ),
          tileColor: Colors.black54,
          selectedTileColor: Colors.amber,
          onTap: () {
            context.read<RoomsCubit>().createRoom(userProfile.id);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
