import 'package:flutter/material.dart';
import 'package:xocobaby13/feature/chat/presentation/widgets/chat_style.dart';

class ChatDialogs {
  const ChatDialogs._();

  static Future<void> showReportReasonSheet({
    required BuildContext context,
    required ValueChanged<String> onReasonSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: _ReportReasonSheet(
            onReasonSelected: (String reason) {
              Navigator.of(sheetContext).pop();
              onReasonSelected(reason);
            },
          ),
        );
      },
    );
  }

  static Future<void> showReportDoneDialog({
    required BuildContext context,
    required VoidCallback onReportSpotOwner,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (BuildContext dialogContext) {
        return _ReportDoneDialog(
          onReportSpotOwner: () {
            Navigator.of(dialogContext).pop();
            onReportSpotOwner();
          },
          onDone: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
  }

  static Future<void> showReportCompletedDialog({
    required BuildContext context,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return _ReportCompletedDialog(
          onClose: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
  }

  static Future<bool?> showBlockConfirmDialog({required BuildContext context}) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (BuildContext dialogContext) {
        return _BlockConfirmDialog(
          onCancel: () => Navigator.of(dialogContext).pop(false),
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        );
      },
    );
  }

  static Future<void> showBlockDoneDialog({required BuildContext context}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (BuildContext dialogContext) {
        return _BlockDoneDialog(
          onClose: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
  }
}

class _ReportReasonSheet extends StatelessWidget {
  final ValueChanged<String> onReasonSelected;

  const _ReportReasonSheet({required this.onReasonSelected});

  static const List<String> _reasons = <String>[
    "I just don't like it",
    'Bullying or unwanted contact',
    'Suicide, self-injury or eating disorders',
    'Violence, hate or exploitation',
    'Selling or promoting restricted items',
    'Nudity or sexual activity',
    'Scam, fraud or spam',
    'False information',
    'Intellectual property',
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Report',
                  style: TextStyle(
                    color: ChatPalette.dangerRed,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Why are you reporting this post?',
                style: TextStyle(
                  color: ChatPalette.bodyText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ..._reasons.map(
                (String reason) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => onReasonSelected(reason),
                    child: Text(
                      reason,
                      style: const TextStyle(
                        color: ChatPalette.titleText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportDoneDialog extends StatelessWidget {
  final VoidCallback onReportSpotOwner;
  final VoidCallback onDone;

  const _ReportDoneDialog({
    required this.onReportSpotOwner,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: ChatPalette.actionBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 12),
            const Text(
              'Thanks for your feedback',
              style: TextStyle(
                color: ChatPalette.bodyText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onReportSpotOwner,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.flag_outlined,
                    size: 14,
                    color: ChatPalette.dangerRed,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Report Spot Owner',
                    style: TextStyle(
                      color: ChatPalette.dangerRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ChatPalette.actionBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCompletedDialog extends StatelessWidget {
  final VoidCallback onClose;

  const _ReportCompletedDialog({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: ChatPalette.actionBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 12),
            const Text(
              'Thanks for your feedback',
              style: TextStyle(
                color: ChatPalette.bodyText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your feedback is important in helping\n'
              'us keep the fishing community safe.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ChatPalette.titleText,
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _BlockConfirmDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _BlockConfirmDialog({required this.onCancel, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: ChatPalette.dangerRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.block, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 12),
            const Text(
              'Are you sure want to block this person?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ChatPalette.bodyText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      onPressed: onCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChatPalette.neutralButton,
                        foregroundColor: ChatPalette.titleText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChatPalette.dangerRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.block, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Block',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BlockDoneDialog extends StatelessWidget {
  final VoidCallback onClose;

  const _BlockDoneDialog({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: ChatPalette.dangerRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.block, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 12),
            const Text(
              'You have successfully block this person.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ChatPalette.bodyText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ChatPalette.neutralButton,
                  foregroundColor: ChatPalette.titleText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Unblock',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
