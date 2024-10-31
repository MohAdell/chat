import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Profile/model/users_info.dart';
import '../../core/firebase/firebase_data.dart';
import '../model/roomModel.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  final FireBaseDataAll _baseData;
  RoomsCubit(this._baseData) : super(RoomsInitial());

  Future<void> createRoom(String userid) async {
    emit(RoomsLoading());
    try {
      final roomid = await _baseData.createRoom(userid);
      RoomsCreated(roomid);
    } catch (e) {
      emit(RoomsError("This error created room $e"));
    }
  }

  StreamSubscription<List<UserProfile>>? _usersSubscription;
  List<UserProfile> _cachedUsers = [];

  Future<void> fetchAllData() async {
    emit(RoomsLoading());
    try {
      _usersSubscription = _baseData.getAllUsers().listen((users) {
        _cachedUsers = users;
        print('Fetched users');
        fetchRooms();
      });
    } catch (e) {
      emit(RoomsError('Error fetching users: $e'));
    }
  }

  UserProfile? getUserProfile(String userId) {
    try {
      return _cachedUsers.firstWhere(
        (user) => user.id == userId,
        orElse: () => UserProfile(
          id: "",
          name: "Unknown User",
          email: "",
          about: "",
          phoneNumber: "",
          createdAt: "",
          lastActivated: "",
          pushToken: "",
          online: false,
        ),
      );
    } catch (e) {
      print('User not found: $userId');
      return null;
    }
  }

  //
  StreamSubscription<List<Room>>? streamSubscriptionrooms;

  void fetchRooms() {
    streamSubscriptionrooms = _baseData.getAllRooms().listen((rooms) {
      emit(RoomsLoaded(rooms));
    }, onError: (e) {
      emit(RoomsError(e.toString()));
    });
  }

  List<UserProfile> listRooms = [];
  Future fetchAllUseersRooms() async {
    emit(RoomsLoading());
    try {
      _usersSubscription = _baseData.getAllUsers().listen((users) {
        listRooms = users;
        fetchRooms();
      });
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  UserProfile? getUsersProfile(String userId) {
    try {
      return listRooms.firstWhere((user) => user.id == userId,
          orElse: () => UserProfile(
              id: '',
              name: '',
              email: '',
              about: '',
              phoneNumber: '',
              createdAt: '',
              lastActivated: '',
              pushToken: '',
              online: true));
    } catch (e) {
      print('user not found');
      return null;
    }
  }

  @override
  Future<void> close() {
    streamSubscriptionrooms?.cancel();
    _usersSubscription?.cancel();
    return super.close();
  }
}
