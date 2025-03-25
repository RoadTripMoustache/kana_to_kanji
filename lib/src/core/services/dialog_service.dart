import "package:flutter/material.dart" as material;

class DialogService {
  final material.GlobalKey<material.NavigatorState> navigatorKey =
      material.GlobalKey<material.NavigatorState>();

  Future<T?> showModalBottomSheet<T>({
    required material.WidgetBuilder builder,
    material.Color? backgroundColor,
    String? barrierLabel,
    double? elevation,
    material.ShapeBorder? shape,
    material.Clip? clipBehavior,
    material.BoxConstraints? constraints,
    material.Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    bool useSafeArea = false,
    material.RouteSettings? routeSettings,
    material.AnimationController? transitionAnimationController,
    material.Offset? anchorPoint,
  }) async {
    if (navigatorKey.currentContext == null) {
      throw Exception("Navigator context not available");
    }
    return material.showModalBottomSheet(
      context: navigatorKey.currentContext!,
      builder: builder,
      backgroundColor: backgroundColor,
      barrierLabel: barrierLabel,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
    );
  }
}
