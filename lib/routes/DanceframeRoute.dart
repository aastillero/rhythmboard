import 'package:flutter/material.dart';
import '../views/screens/mode3.dart';
import '../views/screens/mode3Test.dart';
import '../views/screens/nextpage.dart';
import '../views/screens/splash.dart';
import '../views/screens/newscreen.dart';
import '../views/screens/DeviceControl.dart';
import '../views/screens/change_device_mode.dart';
import '../views/screens/mode2.dart';

/*
  Author: Art

  [_MainFrameRoute] this class contains all routing/navigation path
  for the application. It also utilizes a fade transition when going
  to another screen
 */
class MainFrameRoute<T> extends MaterialPageRoute<T> {
  MainFrameRoute(WidgetBuilder builder, RouteSettings settings)
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    /*if (settings.isInitialRoute)
        return child;*/

    return FadeTransition(opacity: animation, child: child);
  }
}

/*
  Method for getting all the route for this application
 */
Route? getMainFrameOnRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (_) => Splash(),
        settings: settings,
      );
    case '/nextpage':
      return MaterialPageRoute(
        builder: (_) => NextPage(),
        settings: settings,
      );
    case '/newscreen':
      return MaterialPageRoute(
        builder: (_) => NewScreen(),
        settings: settings,
      );
    case '/devicecontrol':
      return MaterialPageRoute(
        builder: (_) => control_panel(),
        settings: settings,
      );
    case '/change_device_mode':
      return MaterialPageRoute(
        builder: (_) => change_device_mode(),
        settings: settings,
      );
    default:
      return null;
  }
}

Map<String, WidgetBuilder> getMainFrameRoute() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => Splash(),
    '/nextpage': (BuildContext context) => NextPage(),
    '/newscreen': (BuildContext context) => NewScreen(),
    '/devicecontrol': (BuildContext context) => control_panel(),
    '/change_device_mode': (BuildContext context) => change_device_mode(),
    '/mode2': (BuildContext context) => Mode2(),
    '/mode3': (BuildContext context) => Mode3(),
    '/mode3test': (BuildContext context) => Mode3Test(),
  };
}
