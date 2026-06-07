import 'package:subscription_manage/feature/subscription/presentation/screens/subscription_screen.dart';
import 'package:subscription_manage/feature/setting/presentation/screen/setting_screen.dart';

import '../../../../core/exported_files/exported_file.dart';
import '../controller/main_bottom_nav_controller.dart';
import '../../../setting/presentation/controller/setting_controller.dart';

class MainBottomNavScreen extends StatelessWidget {
  MainBottomNavScreen({super.key});

  final MainBottomNavController controller =
      Get.find<MainBottomNavController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      builder: (_) {
        final brightness = Theme.of(context).brightness;
        final surfaceGradient = brightness == Brightness.dark
            ? AppColors.surfaceGradient
            : const LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              );
        final borderColor = Theme.of(context).dividerColor.withValues(alpha: 0.6);
        final shadowColor = brightness == Brightness.dark
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.black.withValues(alpha: 0.08);

        return Scaffold(
          extendBody: true,
          body: Obx(() {
            final index = controller.selectedIndex.value;
            Widget buildContent() {
              switch (index) {
                case 0:
                  return RepaintBoundary(child: SubscriptionScreen());
                case 2:
                  return RepaintBoundary(child: SettingScreen());
                default:
                  return RepaintBoundary(child: SubscriptionScreen());
              }
            }

            return buildContent();
          }),
          bottomNavigationBar: SafeArea(
            top: false,
            child: SizedBox(
              height: 100,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Positioned.fill(
                    top: 12,
                    child: ClipPath(
                      clipper: _BottomNavClipper(),
                      child: Container(
                          decoration: BoxDecoration(
                            gradient: surfaceGradient,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor,
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(
                          top: 18,
                          left: 22,
                          right: 22,
                          bottom: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => _BottomNavItem(
                                  icon: Icons.subscriptions_outlined,
                                  isSelected: controller.selectedIndex.value == 0,
                                  onTap: () => controller.changeTab(0),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ),
                            const SizedBox(width: 92),
                            Expanded(
                              child: Obx(
                                () => _BottomNavItem(
                                  icon: Icons.settings_outlined,
                                  isSelected: controller.selectedIndex.value == 2,
                                  onTap: () => controller.changeTab(2),
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -28,
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.createScreen),
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.m1, AppColors.m2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.m2.withValues(alpha: 0.18),
                              blurRadius: 14,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: borderColor,
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 36,
                          color: brightness == Brightness.dark
                              ? AppColors.white
                              : AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.alignment,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return InkWell(
      onTap: onTap,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                width: isSelected ? 44 : 36,
                height: isSelected ? 44 : 36,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [AppColors.m1, AppColors.m2],
                        )
                      : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: isSelected ? 22 : 20,
                  color: isSelected
                      ? AppColors.white
                      : (brightness == Brightness.dark
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.m1 : Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double cornerRadius = 24;
    const double notchRadius = 40;
    const double notchWidth = 96;
    final double notchCenterX = size.width / 2;
    final double notchLeft = notchCenterX - notchWidth / 2;
    final double notchRight = notchCenterX + notchWidth / 2;

    final Path path = Path();
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(notchLeft + 8, 0);
    path.quadraticBezierTo(notchLeft + 18, 0, notchLeft + 22, 12);
    path.quadraticBezierTo(
      notchCenterX - notchRadius / 2,
      notchRadius,
      notchCenterX,
      notchRadius,
    );
    path.quadraticBezierTo(
      notchCenterX + notchRadius / 2,
      notchRadius,
      notchRight - 22,
      12,
    );
    path.quadraticBezierTo(notchRight - 18, 0, notchRight - 8, 0);
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
