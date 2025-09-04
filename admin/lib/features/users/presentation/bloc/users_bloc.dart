import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/users/data/repositories/users_repository.dart';
import 'package:openauth/src/generated/openauth/v1/users.pbserver.dart';
import 'package:protobuf/protobuf.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<GeneratedMessage, UsersState> {
  final UsersRepository repository;

  UsersBloc({
    required this.repository,
  }) : super(UsersInitial()) {
    on<ListUsersRequest>(_onLoadUsers);
    on<SignUpRequest>(_onCreateUser);
    on<UpdateUserRequest>(_onUpdateUser);
    on<DeleteUserRequest>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(ListUsersRequest event, Emitter<UsersState> emit) async {
    emit(UsersLoading());

    final result = await repository.getUsers(event);
    result.fold(
      (failure) => emit(UsersError(failure)),
      (users) => emit(UsersLoaded(
        users: users,
      )),
    );
  }

  Future<void> _onCreateUser(SignUpRequest event, Emitter<UsersState> emit) async {
    emit(UserCreating());

    final result = await repository.createUser(event);

    result.fold(
      (failure) => emit(UsersError(failure)),
      (user) {
        emit(UserCreated(user));
        // Refresh the users list
        if (!isClosed) {
          add(ListUsersRequest());
        }
      },
    );
  }

  Future<void> _onUpdateUser(UpdateUserRequest event, Emitter<UsersState> emit) async {
    emit(UserUpdating());

    final result = await repository.updateUser(event);

    result.fold(
      (failure) => emit(UsersError(failure)),
      (user) {
        emit(UserUpdated(user));
        // Refresh the users list
        if (!isClosed) {
          add(ListUsersRequest());
        }
      },
    );
  }

  Future<void> _onDeleteUser(DeleteUserRequest event, Emitter<UsersState> emit) async {
    emit(UserDeleting());

    final result = await repository.deleteUser(event);

    result.fold(
      (failure) => emit(UsersError(failure)),
      (_) {
        emit(UserDeleted(event.uuid));
        // Refresh the users list
        if (!isClosed) {
          add(ListUsersRequest());
        }
      },
    );
  }
}