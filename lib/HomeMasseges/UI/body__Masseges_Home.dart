import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Contacts/model/roomModel.dart';
import '../../Profile/model/users_info.dart';
import '../../core/utils/routes.dart';

class UserCard extends StatelessWidget {
  final UserProfile userProfile;
  final Room room;

  const UserCard({super.key, required this.userProfile, required this.room});

  @override
  Widget build(BuildContext context) {
    final DateTime lastActivated = DateTime.parse(userProfile.lastActivated);
    final formattedTime = DateFormat.jm().format(lastActivated);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.chatScreen,
          arguments: userProfile,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  // color: Colors.red,
                  ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 26,
                        child: Text(
                          userProfile.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      if (userProfile.online)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2.5)),
                            child: const Icon(
                              Icons.brightness_1,
                              size: 8,
                              color: Colors.green,
                            ),
                          ),
                        )
                      else
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2.5)),
                            child: const Icon(
                              Icons.brightness_1_outlined,
                              size: 8,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 18, // Increased font size for the name
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 3),
            //   height: 1,
            //   color:
            //       Colors.grey.shade300, // Light grey color for the divider line
            // ),
          ],
        ),
      ),
    );
  }
}
