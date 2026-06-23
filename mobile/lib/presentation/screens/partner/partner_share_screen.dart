import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../logic/partner/partner_cubit.dart';
import '../../../logic/partner/partner_state.dart';

class PartnerShareScreen extends StatefulWidget {
  const PartnerShareScreen({super.key});

  @override
  State<PartnerShareScreen> createState() => _PartnerShareScreenState();
}

class _PartnerShareScreenState extends State<PartnerShareScreen> {
  final _linkCodeController = TextEditingController();
  bool _showLinkForm = false;

  @override
  void initState() {
    super.initState();
    context.read<PartnerCubit>().loadPartnerCode();
  }

  @override
  void dispose() {
    _linkCodeController.dispose();
    super.dispose();
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Partner code copied to clipboard')),
    );
  }

  void _linkPartner() {
    final code = _linkCodeController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    context.read<PartnerCubit>().linkToPartner(code);
  }

  void _unlinkPartner() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unlink Partner'),
        content: const Text(
          'Are you sure you want to unlink your partner? They will no longer see your calendar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PartnerCubit>().unlinkPartner();
            },
            child: const Text('Unlink'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partner Sharing')),
      body: BlocBuilder<PartnerCubit, PartnerState>(
        builder: (context, state) {
          if (state.status == PartnerStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.people,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Share Your Calendar',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your partner can view your period and fertility predictions with a pairing code.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Your Partner Code',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.partnerCode ?? '------',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: state.partnerCode != null
                                  ? () => _copyCode(state.partnerCode!)
                                  : null,
                              icon: const Icon(Icons.copy),
                              label: const Text('Copy'),
                            ),
                            const SizedBox(width: 16),
                            TextButton.icon(
                              onPressed: () =>
                                  context.read<PartnerCubit>().regenerateCode(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Regenerate'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (state.partnerView != null) ...[
                  Card(
                    color: AppTheme.fertileLight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: AppTheme.fertileGreen),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Linked with ${state.partnerView!.user.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'They can view your calendar',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _unlinkPartner,
                    icon: const Icon(Icons.link_off),
                    label: const Text('Unlink Partner'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ] else ...[
                  if (!_showLinkForm)
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _showLinkForm = true),
                      icon: const Icon(Icons.link),
                      label: const Text("Enter Partner's Code"),
                    )
                  else ...[
                    TextField(
                      controller: _linkCodeController,
                      decoration: InputDecoration(
                        labelText: "Partner's Code",
                        hintText: 'Enter the code your partner shared',
                        prefixIcon: const Icon(Icons.vpn_key),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _linkCodeController.clear(),
                        ),
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                setState(() => _showLinkForm = false),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _linkPartner,
                            child: const Text('Link'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
                if (state.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
