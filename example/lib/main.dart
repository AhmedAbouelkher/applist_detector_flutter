import 'dart:developer';

import 'package:applist_detector_flutter/applist_detector_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _plugin = ApplistDetectorFlutter();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final result = await _plugin.abnormalEnvironment();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.type.name),
                              ),
                            );
                          }
                        } catch (e) {
                          log("Error checking environment: $e");
                          return;
                        }
                      },
                      child: const Text("Check Abnormal Environment"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final result = await _plugin.fileDetection();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.type.name),
                              ),
                            );
                          }
                        } catch (e) {
                          log("Error checking file detection: $e");
                          return;
                        }
                      },
                      child: const Text("Check File Detection"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final result =
                              await _plugin.fileDetection(useSysCall: true);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.type.name),
                              ),
                            );
                          }
                        } catch (e) {
                          log("Error checking file detection with syscall: $e");
                          return;
                        }
                      },
                      child: const Text("Check File Detection (Syscall)"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final result = await _plugin.xposedModules();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.type.name),
                              ),
                            );
                          }
                        } catch (e) {
                          log("Error checking xposed modules: $e");
                          return;
                        }
                      },
                      child: const Text("Check Xposed Modules"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final result = await _plugin.magiskApp();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.type.name),
                              ),
                            );
                          }
                        } catch (e) {
                          log("Error checking magisk app: $e");
                          return;
                        }
                      },
                      child: const Text("Check Magisk App"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
