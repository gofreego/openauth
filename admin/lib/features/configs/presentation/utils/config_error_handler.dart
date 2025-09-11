import '../bloc/config_entities_state.dart';
import '../bloc/configs_state.dart';

class ConfigErrorHandler {
  /// Get user-friendly error message for config entity errors
  static String getConfigEntityErrorMessage(ConfigEntitiesState state) {
    if (state is ConfigEntitiesListError) {
      return 'Failed to load config entities. ${state.message}';
    } else if (state is ConfigEntityCreateError) {
      return 'Failed to create config entity. ${state.message}';
    } else if (state is ConfigEntityUpdateError) {
      return 'Failed to update config entity. ${state.message}';
    } else if (state is ConfigEntityDeleteError) {
      return 'Failed to delete config entity. ${state.message}';
    } else if (state is ConfigEntityGetError) {
      return 'Failed to get config entity. ${state.message}';
    } else if (state is ConfigEntitiesError) {
      return 'An error occurred with config entities. ${state.message}';
    }
    return 'An unknown error occurred.';
  }

  /// Get user-friendly error message for config errors
  static String getConfigErrorMessage(ConfigsState state) {
    if (state is ConfigsListError) {
      return 'Failed to load configs. ${state.message}';
    } else if (state is ConfigCreateError) {
      return 'Failed to create config. ${state.message}';
    } else if (state is ConfigUpdateError) {
      return 'Failed to update config. ${state.message}';
    } else if (state is ConfigDeleteError) {
      return 'Failed to delete config. ${state.message}';
    } else if (state is ConfigGetError) {
      return 'Failed to get config. ${state.message}';
    } else if (state is ConfigsByKeysError) {
      return 'Failed to get configs by keys. ${state.message}';
    } else if (state is ConfigsError) {
      return 'An error occurred with configs. ${state.message}';
    }
    return 'An unknown error occurred.';
  }

  /// Check if the state is any kind of config entity error
  static bool isConfigEntityError(ConfigEntitiesState state) {
    return state is ConfigEntitiesListError ||
           state is ConfigEntityCreateError ||
           state is ConfigEntityUpdateError ||
           state is ConfigEntityDeleteError ||
           state is ConfigEntityGetError ||
           state is ConfigEntitiesError;
  }

  /// Check if the state is any kind of config error
  static bool isConfigError(ConfigsState state) {
    return state is ConfigsListError ||
           state is ConfigCreateError ||
           state is ConfigUpdateError ||
           state is ConfigDeleteError ||
           state is ConfigGetError ||
           state is ConfigsByKeysError ||
           state is ConfigsError;
  }

  /// Get appropriate retry action based on error type
  static String getRetryActionText(dynamic state) {
    if (state is ConfigEntitiesListError || state is ConfigsListError) {
      return 'Retry Loading';
    } else if (state is ConfigEntityCreateError || state is ConfigCreateError) {
      return 'Try Again';
    } else if (state is ConfigEntityUpdateError || state is ConfigUpdateError) {
      return 'Retry Update';
    } else if (state is ConfigEntityDeleteError || state is ConfigDeleteError) {
      return 'Retry Delete';
    } else if (state is ConfigEntityGetError || state is ConfigGetError) {
      return 'Retry Get';
    } else if (state is ConfigsByKeysError) {
      return 'Retry Get by Keys';
    }
    return 'Retry';
  }

  /// Determine if error should show different UI treatment
  static bool shouldShowInlineError(dynamic state) {
    // Create, update, delete errors might be better shown inline
    return state is ConfigEntityCreateError ||
           state is ConfigCreateError ||
           state is ConfigEntityUpdateError ||
           state is ConfigUpdateError ||
           state is ConfigEntityDeleteError ||
           state is ConfigDeleteError;
  }

  /// Determine if error should redirect to list view
  static bool shouldRedirectToList(dynamic state) {
    // Get errors and some operation errors should redirect to list
    return state is ConfigEntityGetError ||
           state is ConfigGetError ||
           state is ConfigEntityCreateError ||
           state is ConfigCreateError ||
           state is ConfigEntityUpdateError ||
           state is ConfigUpdateError ||
           state is ConfigEntityDeleteError ||
           state is ConfigDeleteError;
  }
}
