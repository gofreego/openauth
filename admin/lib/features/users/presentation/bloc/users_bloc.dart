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
    final currentState = state;
    final isLoadMore = event.hasOffset() && event.offset > 0;
    
    if (!isLoadMore) {
      emit(UsersLoading());
    } else if (currentState is UsersLoaded) {
      // Set loading more state
      emit(currentState.copyWith(isLoadingMore: true));
    }

    final result = await repository.getUsers(event);
    result.fold(
      (failure) => emit(UsersError(failure)),
      (newUsers) {
        if (isLoadMore && currentState is UsersLoaded) {
          // Append new users to existing list
          final allUsers = [...currentState.users, ...newUsers];
          final hasReachedMax = newUsers.length < (event.hasLimit() ? event.limit : 20);
          
          emit(UsersLoaded(
            users: allUsers,
            hasReachedMax: hasReachedMax,
            currentSearch: event.hasSearch() ? event.search : null,
            isLoadingMore: false,
          ));
        } else {
          // First load or refresh
          final hasReachedMax = newUsers.length < (event.hasLimit() ? event.limit : 20);
          
          emit(UsersLoaded(
            users: newUsers,
            hasReachedMax: hasReachedMax,
            currentSearch: event.hasSearch() ? event.search : null,
            isLoadingMore: false,
          ));
        }
      },
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
          add(ListUsersRequest(
            limit: 20,
            offset: 0,
          ));
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
          add(ListUsersRequest(
            limit: 20,
            offset: 0,
          ));
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
          add(ListUsersRequest(
            limit: 20,
            offset: 0,
          ));
        }
      },
    );
  }
}