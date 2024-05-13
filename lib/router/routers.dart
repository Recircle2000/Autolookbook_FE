import 'package:flutter/material.dart';

import 'package:autolookbook/page/add_account_page.dart';
import 'package:autolookbook/page/navBarPage.dart';

final routes = {
  '/': (BuildContext context) => NavBarPage(),
  '/account': (BuildContext context) => AddAccountPage(),
};