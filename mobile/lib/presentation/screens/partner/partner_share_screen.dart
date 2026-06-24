import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
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
    final t = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.codeCopied),
        backgroundColor: AppTheme.fertileGreen,
      ),
    );
  }

  void _linkPartner() {
    final code = _linkCodeController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    context.read<PartnerCubit>().linkToPartner(code);
    setState(() => _showLinkForm = false);
  }

  void _unlinkPartner() {
    final t = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.unlinkPartner),
        content: Text(t.unlinkConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PartnerCubit>().unlinkPartner();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.periodRed,
            ),
            child: Text(t.unlink),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.partnerSharing),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<PartnerCubit, PartnerState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: AppTheme.periodRed,
              ),
            );
            context.read<PartnerCubit>().clearError();
          }
        },
        builder: (context, state) {
          if (state.status == PartnerStatus.loading && state.partnerCode == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.people,
                    size: 32,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  t.shareYourCalendar,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.onSurface,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.shareSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          t.yourPartnerCode,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppTheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.partnerCode ?? '------',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                                color: AppTheme.primary,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: state.partnerCode != null
                                  ? () => _copyCode(state.partnerCode!)
                                  : null,
                              icon: const Icon(Icons.copy, size: 18),
                              label: Text(t.copy),
                            ),
                            const SizedBox(width: 16),
                            TextButton.icon(
                              onPressed: () =>
                                  context.read<PartnerCubit>().regenerateCode(),
                              icon: const Icon(Icons.refresh, size: 18),
                              label: Text(t.regenerate),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (state.partnerView != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.fertileLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppTheme.fertileGreen),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.linkedWithText(state.partnerView!.user.name),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.onSurface,
                                ),
                              ),
                              Text(
                                t.theyCanView,
                                style: TextStyle(
                                  color: AppTheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _unlinkPartner,
                    icon: const Icon(Icons.link_off, size: 20),
                    label: Text(t.unlinkPartner),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.periodRed,
                      side: const BorderSide(color: AppTheme.periodRed),
                    ),
                  ),
                ] else ...[
                  if (!_showLinkForm)
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _showLinkForm = true),
                      icon: const Icon(Icons.link),
                      label: Text(t.enterPartnerCode),
                    )
                  else ...[
                    TextField(
                      controller: _linkCodeController,
                      decoration: InputDecoration(
                        labelText: t.partnerCodeLabel,
                        hintText: t.partnerCodeHint,
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
                            child: Text(t.cancel),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _linkPartner,
                            child: Text(t.link),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
