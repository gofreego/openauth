import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import 'users_event.dart';
import 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsersUseCase getUsersUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  UsersBloc({
    required this.getUsersUseCase,
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
    on<FilterUsersEvent>(_onFilterUsers);
  }

  Future<void> _onLoadUsers(LoadUsersEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoading());

    final result = await getUsersUseCase(
      page: event.page,
      limit: event.limit,
      search: event.search,
      isActive: event.isActive,
    );

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (users) => emit(UsersLoaded(
        users: users,
        currentSearch: event.search,
        currentFilter: event.isActive,
      )),
    );
  }

  Future<void> _onRefreshUsers(RefreshUsersEvent event, Emitter<UsersState> emit) async {
    final result = await getUsersUseCase(
      page: 1,
      limit: 50,
      search: event.search,
      isActive: event.isActive,
    );

    result.fold(
      (failure) => emit(UsersError(failure.message)),
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
      username: event.username,
      email: event.email,
      password: event.password,
      phone: event.phone,
    );

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (user) {
        emit(UserCreated(user));
        // Refresh the users list
        add(const RefreshUsersEvent());
      },
    );
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<UsersState> emit) async {
    emit(UserUpdating());

    final result = await updateUserUseCase(
      uuid: event.uuid,
      username: event.username,
      email: event.email,
      phone: event.phone,
      isActive: event.isActive,
    );

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (user) {
        emit(UserUpdated(user));
        // Refresh the users list
        add(const RefreshUsersEvent());
      },
    );
  }

  Future<void> _onDeleteUser(DeleteUserEvent event, Emitter<UsersState> emit) async {
    emit(UserDeleting());

    final result = await deleteUserUseCase(event.userIdOrUuid);

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (_) {
        emit(UserDeleted(event.userIdOrUuid));
        // Refresh the users list
        add(const RefreshUsersEvent());
      },
    );
  }

  Future<void> _onSearchUsers(SearchUsersEvent event, Emitter<UsersState> emit) async {
    final currentState = state;
    final currentFilter = currentState is UsersLoaded ? currentState.currentFilter : null;

    final result = await getUsersUseCase(
      search: event.query.isEmpty ? null : event.query,
      isActive: currentFilter,
    );

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (users) => emit(UsersLoaded(
        users: users,
        currentSearch: event.query.isEmpty ? null : event.query,
        currentFilter: currentFilter,
      )),
    );
  }

  Future<void> _onFilterUsers(FilterUsersEvent event, Emitter<UsersState> emit) async {
    final currentState = state;
    final currentSearch = currentState is UsersLoaded ? currentState.currentSearch : null;

    final result = await getUsersUseCase(
      search: currentSearch,
      isActive: event.isActive,
    );

    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (users) => emit(UsersLoaded(
        users: users,
        currentSearch: currentSearch,
        currentFilter: event.isActive,
      )),
    );
  }
}