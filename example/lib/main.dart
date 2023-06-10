import 'dart:async';
import 'dart:developer';

import 'package:applist_detector_flutter/applist_detector_flutter.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _plugin = ApplistDetectorFlutter();
  bool isLoading = false;

  List<ResultWrapper> results = [];
  Set<ResultWrapper> selected = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTests();
    });
  }

  void _startTests() async {
    try {
      final tests = [
        buildWrapper("Abnormal Environment", process: () {
          return _plugin.abnormalEnvironment();
        }),
        buildWrapper("Libc File Detection", process: () {
          return _plugin.fileDetection();
        }),
        buildWrapper("Syscall File Detection", process: () {
          return _plugin.fileDetection(useSysCall: true);
        }),
        buildWrapper("Xposed Modules", process: () {
          return _plugin.xposedModules();
        }),
        buildWrapper("lspatch Xposed Modules", process: () {
          return _plugin.xposedModules(lspatch: true);
        }),
        buildWrapper("Magisk App", process: () {
          return _plugin.magiskApp();
        }),
        buildWrapper("PM Command", process: () {
          return _plugin.pmCommand();
        }),
        buildWrapper("PM Conventional APIs", process: () {
          return _plugin.pmConventionalAPIs();
        }),
        buildWrapper("PM Sundry APIs", process: () {
          return _plugin.pmSundryAPIs();
        }),
        buildWrapper("PM QueryIntentActivities", process: () {
          return _plugin.pmQueryIntentActivities();
        }),
        buildWrapper("Settings Props", process: () {
          return _plugin.settingsProps();
        }),
        buildWrapper("Running Emulator", process: () {
          return _plugin.emulatorCheck();
        }),
      ];
      results = await Future.wait(tests);
    } catch (e, t) {
      log("ERROR Init", error: e, stackTrace: t);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ApplistDetectorFlutter'),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                setState(() => isLoading = true);
                _startTests();
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10, bottom: 40),
                child: Column(
                  children: [
                    if (results.isEmpty) ...[
                      const SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                    ExpansionPanelList(
                      dividerColor: Colors.grey.shade700,
                      expansionCallback: (index, isExpanded) {
                        final item = results[index];
                        if (isExpanded) {
                          selected.remove(item);
                        } else {
                          selected.add(item);
                        }
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      children: results.map((e) {
                        final isExpanded = selected.contains(e);
                        return buildExpPanel(
                          e,
                          testName: e.testName,
                          isExpanded: isExpanded,
                        );
                      }).toList(),
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

  static const Map<DetectorResultType, Widget> icons = {
    DetectorResultType.notFound: Icon(Icons.done),
    DetectorResultType.found: Icon(Icons.coronavirus, color: Colors.red),
    DetectorResultType.suspicious: Icon(Icons.visibility),
    DetectorResultType.methodUnavailable: Icon(Icons.code_off),
  };

  static const Map<DetectorResultType, String> labels = {
    DetectorResultType.notFound: "Not Found",
    DetectorResultType.found: "Found",
    DetectorResultType.suspicious: "Suspicious",
    DetectorResultType.methodUnavailable: "Method Unavailable",
  };

  ExpansionPanel buildExpPanel(
    ResultWrapper wrapper, {
    required String testName,
    bool isExpanded = false,
  }) {
    final details = wrapper.result.details;
    final type = wrapper.result.type;
    final error = wrapper.error;
    return ExpansionPanel(
      isExpanded: isExpanded,
      headerBuilder: (context, isExpanded) {
        return ListTile(
          leading: icons[type],
          title: Text(testName),
          trailing: Text(error != null ? "ERROR" : ""),
          subtitle: Text(labels[type] ?? "Unknown"),
        );
      },
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ).add(const EdgeInsets.only(bottom: 15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details.entries.map((e) {
                return Row(
                  children: [
                    icons[e.value]!,
                    const SizedBox(width: 10),
                    Expanded(child: Text(e.key)),
                  ],
                );
              }).toList(),
            ),
            if (error != null) ...[
              const SizedBox(height: 10),
              Text(error.toString()),
            ],
          ],
        ),
      ),
    );
  }
}

class ResultWrapper {
  final String testName;
  final DetectorResult result;
  final Object? error;
  final StackTrace? stackTrace;
  ResultWrapper({
    required this.testName,
    this.result = const DetectorResult(
      type: DetectorResultType.notFound,
      details: {},
    ),
    this.error,
    this.stackTrace,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResultWrapper && other.testName == testName;
  }

  @override
  int get hashCode {
    return testName.hashCode;
  }
}

Future<ResultWrapper> buildWrapper(
  String name, {
  required FutureOr<DetectorResult> Function() process,
}) async {
  try {
    final result = await process();
    return ResultWrapper(
      testName: name,
      result: result,
    );
  } catch (e, t) {
    return ResultWrapper(
      testName: name,
      error: e,
      stackTrace: t,
    );
  }
}
