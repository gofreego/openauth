import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/theme_bloc.dart';
import '../../core/bloc/theme_event.dart';
import '../../core/bloc/theme_state.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        IconData icon;
        String tooltip;
        
        if (state is ThemeLight) {
          icon = Icons.light_mode;
          tooltip = 'Light Mode';
        } else if (state is ThemeDark) {
          icon = Icons.dark_mode;
          tooltip = 'Dark Mode';
        } else {
          icon = Icons.brightness_auto;
          tooltip = 'System Mode';
        }

        return IconButton(
          icon: Icon(icon),
          tooltip: tooltip,
          onPressed: () {
            context.read<ThemeBloc>().add(const ThemeChanged());
          },
        );
      },
    );
  }
}

class ThemeToggleTile extends StatelessWidget {
  const ThemeToggleTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        IconData icon;
        String title;
        String subtitle;
        
        if (state is ThemeLight) {
          icon = Icons.light_mode;
          title = 'Light Mode';
          subtitle = 'App will use light theme';
        } else if (state is ThemeDark) {
          icon = Icons.dark_mode;
          title = 'Dark Mode';
          subtitle = 'App will use dark theme';
        } else {
          icon = Icons.brightness_auto;
          title = 'System Mode';
          subtitle = 'App will follow system preference';
        }

        return ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              context.read<ThemeBloc>().add(const ThemeChanged());
            },
          ),
          onTap: () {
            context.read<ThemeBloc>().add(const ThemeChanged());
          },
        );
      },
    );
  }
}
