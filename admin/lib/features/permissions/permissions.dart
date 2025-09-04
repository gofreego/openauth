// Permissions Feature Exports

// Domain Layer
export 'domain/repositories/permissions_repository.dart';

// Data Layer
export 'data/datasources/permissions_remote_datasource_impl.dart';
export 'data/repositories/permissions_repository_impl.dart';

// Presentation Layer - API Integration
export 'presentation/bloc/permissions_bloc.dart';

// Presentation Layer - Legacy (UI components using mock data)
export 'presentation/pages/permissions_page.dart';
export 'presentation/pages/permissions_page_wrapper.dart';
export 'presentation/widgets/permissions_header.dart';
export 'presentation/widgets/permissions_grid.dart';
export 'presentation/widgets/permission_card.dart';

// Legacy Data Layer (to be removed when UI is updated)
export 'data/models/permission_model.dart';
