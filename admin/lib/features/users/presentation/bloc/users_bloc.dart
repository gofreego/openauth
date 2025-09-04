import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/features/users/data/repositories/users_repository.dart';
import 'package:openauth/src/generated/openauth/v1/users.pbserver.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository repository;

  UsersBloc({
    required this.repository,
  }) : super(UsersInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<RefreshUsersEvent>(_onRefreshUsers);
    on<CreateUserEvent>(_onCreateUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<SearchUsersEvent>(_onSearchUsers);
    on<SearchUserByIdEvent>(_onSearchUserById);
    on<FilterUsersEvent>(_onFilterUsers);
  }

  Future<void> _onLoadUsers(LoadUsersEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoading());

    final result = await repository.getUsers(
      request: event.request
    );

    result.fold(
      (failure) => emit(UsersError(failure)),
      (users) => emit(UsersLoaded(
        users: users,
      )),
    );
  }

  Future<void> _onRefreshUsers(RefreshUsersEvent event, Emitter<UsersState> emit) async {
    final result = await repository.getUsers(
      request: event.request,
    );

    result.fold(
      (failure) => emit(UsersError(failure)),
      (users) => emit(UsersLoaded(
        users: users
      )),
    );
  }

  Future<void> _onCreateUser(CreateUserEvent event, Emitter<UsersState> emit) async {
    emit(UserCreating());

    final result = await repository.createUser(event.request);

    result.fold(
      (failure) => emit(UsersError(failure)),
      (user) {
        emit(UserCreated(user));
        // Refresh the users list
        if (!isClosed) {
          add(RefreshUsersEvent(request: ListUsersRequest()));
        }
      },
    );
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<UsersState> emit) async {
    emit(UserUpdating());

    final result = await repository.updateUser(event.request);

    result.fold(
      (failure) => emit(UsersError(failure)),
      (user) {
        emit(UserUpdated(user));
        // Refresh the users list
        if (!isClosed) {
          add(RefreshUsersEvent(request: ListUsersRequest()));
        }
      },
    );
  }

  Future<void> _onDeleteUser(DeleteUserEvent event, Emitter<UsersState> emit) async {
    emit(UserDeleting());

    final result = await repository.deleteUser(event.userIdOrUuid);

    result.fold(
      (failure) => emit(UsersError(failure)),
      (_) {
        emit(UserDeleted(event.userIdOrUuid));
        // Refresh the users list
        if (!isClosed) {
          add(RefreshUsersEvent(request: ListUsersRequest()));
        }
      },
    );
  }

  Future<void> _onSearchUsers(SearchUsersEvent event, Emitter<UsersState> emit) async {
    final currentState = state;
    final currentFilter = currentState is UsersLoaded ? currentState.currentFilter : null;

    final result = await repository.getUsers(
      request: ListUsersRequest(
        offset: 0,
        limit: 50,
        search: event.query.isEmpty ? null : event.query,
      ),
    );

    result.fold(
      (failure) => emit(UsersError(failure)),
      (users) => emit(UsersLoaded(
        users: users,
        currentSearch: event.query.isEmpty ? null : event.query,
        currentFilter: currentFilter,
      )),
    );
  }

  Future<void> _onSearchUserById(SearchUserByIdEvent event, Emitter<UsersState> emit) async {
    // First try to get the specific user by ID/UUID
    final result = await repository.getUser(event.idOrUuid);

    result.fold(
      (failure) {
        // If direct lookup fails, fall back to general search
        add(SearchUsersEvent(event.idOrUuid));
      },
      (user) => emit(UsersLoaded(
        users: [user],
        currentSearch: event.idOrUuid,
        currentFilter: null,
      )),
    );
  }

  Future<void> _onFilterUsers(FilterUsersEvent event, Emitter<UsersState> emit) async {
    final currentState = state;
    final currentSearch = currentState is UsersLoaded ? currentState.currentSearch : null;

    final result = await repository.getUsers(
      request: ListUsersRequest(
        offset: 0,
        limit: 50,
        search: currentSearch,
      ),
    );

    result.fold(
      (failure) => emit(UsersError(failure)),
      (users) => emit(UsersLoaded(
        users: users,
        currentSearch: currentSearch,
        currentFilter: event.isActive,
      )),
    );
  }
}