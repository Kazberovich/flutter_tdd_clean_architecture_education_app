import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

String fixture(String fileName) =>
    File('test/fixtures/$fileName').readAsStringSync();
