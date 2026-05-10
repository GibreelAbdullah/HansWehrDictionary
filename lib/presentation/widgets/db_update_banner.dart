import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/db_update_provider.dart';
import '../../data/db_update_service.dart';

class DbUpdateBanner extends ConsumerStatefulWidget {
  const DbUpdateBanner({super.key});

  @override
  ConsumerState<DbUpdateBanner> createState() => _DbUpdateBannerState();
}

class _DbUpdateBannerState extends ConsumerState<DbUpdateBanner> {
  bool _updating = false;
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || _dismissed) return const SizedBox.shrink();
    final update = ref.watch(dbUpdateProvider);
    return update.when(
      data: (info) {
        if (info == null) return const SizedBox.shrink();
        final cs = Theme.of(context).colorScheme;
        return Card(
          color: cs.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _updating
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 12),
                      Text('Updating dictionary…'),
                    ],
                  )
                : Row(
                    children: [
                      Icon(Icons.update, color: cs.onPrimaryContainer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('A dictionary update is available.',
                            style: TextStyle(color: cs.onPrimaryContainer)),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _dismissed = true),
                        child: const Text('Later'),
                      ),
                      FilledButton(
                        onPressed: () => _doUpdate(info),
                        child: const Text('Update'),
                      ),
                    ],
                  ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Future<void> _doUpdate(DbUpdateInfo info) async {
    setState(() => _updating = true);
    try {
      await applyDbUpdate(info);
      if (mounted) {
        setState(() => _dismissed = true);
        ref.invalidate(dbUpdateProvider);
        ref.invalidate(dbVersionProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dictionary updated successfully.')),
        );
      }
    } catch (e, st) {
      debugPrint('DB update failed: $e\n$st');
      if (mounted) {
        setState(() => _updating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: $e')),
        );
      }
    }
  }
}
