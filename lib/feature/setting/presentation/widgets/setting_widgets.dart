import 'package:subscription_manage/core/exported_files/exported_file.dart';

class SettingSectionHeader extends StatelessWidget {
  const SettingSectionHeader({
    super.key,
    required this.title,
    this.accentColor = const Color(0xFF8A7CFF),
  });

  final String title;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: accentColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.45),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ResponsiveText(
          text: title,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 1.0,
        ),
      ],
    );
  }
}

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.children,
    this.gradient = const LinearGradient(
      colors: [Color(0xFF20202A), Color(0xFF17171F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  });

  final List<Widget> children;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: children,
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    required this.trailing,
    required this.onTap,
    this.subtitle,
    this.enabled = true,
    this.leadingIcon = Icons.settings_outlined,
    this.leadingGradient = const LinearGradient(
      colors: [Color(0xFF7C4DFF), Color(0xFF4FC3F7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.backgroundGradient,
    this.titleColor = Colors.white,
    this.subtitleColor = const Color(0xFFB8C1D1),
    this.extraContent,
  });

  final String title;
  final Widget trailing;
  final VoidCallback onTap;
  final Widget? subtitle;
  final bool enabled;
  final IconData leadingIcon;
  final Gradient leadingGradient;
  final Gradient? backgroundGradient;
  final Color titleColor;
  final Color subtitleColor;
  final Widget? extraContent;

  @override
  Widget build(BuildContext context) {
    final Color rowOpacity = enabled ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.03);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : 0.55,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            gradient: backgroundGradient,
            color: backgroundGradient == null ? rowOpacity : null,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment:
                    subtitle != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: leadingGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C4DFF).withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(leadingIcon, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                          subtitle != null ? MainAxisAlignment.start : MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ResponsiveText(
                          text: title.toUpperCase(),
                          fontSize: 12.8,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 8),
                          subtitle!,
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: EdgeInsets.only(top: subtitle != null ? 2 : 0),
                    child: trailing,
                  ),
                ],
              ),
              if (extraContent != null) ...[
                const SizedBox(height: 12),
                extraContent!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SettingValuePill extends StatelessWidget {
  const SettingValuePill({
    super.key,
    required this.text,
    this.accent = const Color(0xFFFFC857),
    this.textColor = const Color(0xFF101010),
  });

  final String text;
  final Color accent;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.30),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ResponsiveText(
        text: text,
        fontSize: 11.2,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    );
  }
}

class SettingChoiceChips extends StatelessWidget {
  const SettingChoiceChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.enabled,
    this.accentColor = const Color(0xFF8A7CFF),
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;
  final bool enabled;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options
          .map(
            (option) => ChoiceChip(
              label: ResponsiveText(
                text: option,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: enabled
                    ? (selected == option ? Colors.white : const Color.fromARGB(255, 45, 46, 45))
                    : const Color(0xFF9299A8),
              ),
              selected: selected == option,
              selectedColor: accentColor,
              disabledColor: Colors.white.withValues(alpha: 0.05),
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              side: BorderSide(
                color: selected == option ? accentColor : Colors.white.withValues(alpha: 0.08),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              onSelected: enabled ? (_) => onSelected(option) : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            ),
          )
          .toList(),
    );
  }
}
