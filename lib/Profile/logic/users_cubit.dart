import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/firebase/firebase_data.dart';
import '../model/users_info.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final FireBaseDataAll fireBaseData;
  UsersCubit(this.fireBaseData) : super(UsersInitial());

  StreamSubscription<List<UserProfile>>? _streamSubscription;

  void fetchAlluserWithoutme() {
    emit(UsersLoading());
    _streamSubscription = fireBaseData.getAllUsersWithoutme().listen((users) {
      emit(UsersLoaded(users));
    }, onError: (e) {
      emit(UsersError(e.toString()));
    });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
