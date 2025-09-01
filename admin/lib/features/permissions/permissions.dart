// Permissions Feature Exports

// Domain Layer
export 'domain/entities/permission_entity.dart';
export 'domain/repositories/permissions_repository.dart';
export 'domain/usecases/get_permissions_usecase.dart';
export 'domain/usecases/get_permission_usecase.dart';
export 'domain/usecases/create_permission_usecase.dart';
export 'domain/usecases/update_permission_usecase.dart';
export 'domain/usecases/delete_permission_usecase.dart';

// Data Layer
export 'data/datasources/permissions_remote_datasource_impl.dart';
export 'data/repositories/permissions_repository_impl.dart';

// Presentation Layer - API Integration
export 'presentation/bloc/permissions_bloc.dart';
export 'presentation/widgets/permissions_grid_api.dart';
export 'presentation/widgets/create_permission_dialog_api.dart';

// Presentation Layer - Legacy (UI components using mock data)
export 'presentation/pages/permissions_page.dart';
export 'presentation/pages/permissions_page_wrapper.dart';
export 'presentation/widgets/permissions_header.dart';
export 'presentation/widgets/permissions_search_bar.dart';
export 'presentation/widgets/permissions_grid.dart';
export 'presentation/widgets/permission_card.dart';
export 'presentation/widgets/permission_details_dialog.dart';
export 'presentation/widgets/create_permission_dialog.dart';

// Legacy Data Layer (to be removed when UI is updated)
export 'data/models/permission_model.dart';
