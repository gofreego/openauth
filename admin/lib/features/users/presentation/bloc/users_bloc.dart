import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openauth/src/generated/openauth/v1/users.pbserver.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsersUseCase getUsersUseCase;
  final GetUserUseCase getUserUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  UsersBloc({
    required this.getUsersUseCase,
    required this.getUserUseCase,
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
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

    final result = await getUsersUseCase(
      request: ListUsersRequest(
        offset: 0,
        limit: 50,
        search: event.search,
        isActive: event.isActive,
      ),
    );

    result.fold(
      (failure) => emit(UsersError(failure)),
      (users) => emit(UsersLoaded(
        users: users,
        currentSearch: event.search,
        currentFilter: event.isActive,
      )),
    );
  }

  Future<void> _onRefreshUsers(RefreshUsersEvent event, Emitter<UsersState> emit) async {
    final result = await getUsersUseCase(
     request: ListUsersRequest(
        offset: 0,
        limit: 50,
        search: event.search,
        isActive: event.isActive,
     ),
    );

    result.fold(
      (failure) => emit(UsersError(failure)),
      (users) => emit(UsersLoaded(
        users: users,
        currentSearch: event.search,
        currentFilter: event.isActive,
      )),
    );
  }

  Future<void> _onCreateUser(CreateUserEvent event, Emitter<UsersState> emit) async {
    emit(UserCreating());

    final result = await createUserUseCase(
      request: event.request,
    );

    result.fold(
      (failure) => emit(UsersError(failure)),
      (user) {
        emit(UserCreated(user));
        // Refresh the users list
        if (!isClosed) {
          add(const RefreshUsersEvent());
        }
      },
    );
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<UsersState> emit) async {
    emit(UserUpdating());

    final result = await updateUserUseCase(
      request: event.request,
    );

    result.fold(
      (failure) => emit(UsersError(failure)),
      (user) {
        emit(UserUpdated(user));
        // Refresh the users list
        if (!isClosed) {
          add(const RefreshUsersEvent());
        }
      },
    );
  }

  Future<void> _onDeleteUser(DeleteUserEvent event, Emitter<UsersState> emit) async {
    emit(UserDeleting());

    final result = await deleteUserUseCase(event.userIdOrUuid);

    result.fold(
      (failure) => emit(UsersError(failure)),
      (_) {
        emit(UserDeleted(event.userIdOrUuid));
        // Refresh the users list
        if (!isClosed) {
          add(const RefreshUsersEvent());
        }
      },
    );
  }

  Future<void> _onSearchUsers(SearchUsersEvent event, Emitter<UsersState> emit) async {
    final currentState = state;
    final currentFilter = currentState is UsersLoaded ? currentState.currentFilter : null;

    final result = await getUsersUseCase(
      request: ListUsersRequest(
        offset: 0,
        limit: 50,
        search: event.query.isEmpty ? null : event.query,
        isActive: currentFilter,
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
    final result = await getUserUseCase(event.idOrUuid);
    
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

    final result = await getUsersUseCase(
      request: ListUsersRequest(
        offset: 0,
        limit: 50,
        search: currentSearch,
        isActive: event.isActive,
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