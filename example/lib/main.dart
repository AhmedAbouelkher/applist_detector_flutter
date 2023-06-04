import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:applist_detector_flutter/applist_detector_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _plugin = ApplistDetectorFlutter();
  bool isLoading = false;

  Map<String, DetectorResult> results = {};
  Set<String> selected = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    results.clear();
    try {
      results['Abnormal Environment'] = await _plugin.abnormalEnvironment();
      results['Libc File Detection'] = await _plugin.fileDetection();
      results['Syscall File Detection'] =
          await _plugin.fileDetection(useSysCall: true);
      results['Xposed Modules'] = await _plugin.xposedModules();
      results['lspatch Xposed Modules'] =
          await _plugin.xposedModules(lspatch: true);
      results['Magisk App'] = await _plugin.magiskApp();
      results['PM Command'] = await _plugin.pmCommand();
      results['PM Conventional APIs'] = await _plugin.pmConventionalAPIs();
      results['PM Sundry APIs'] = await _plugin.pmSundryAPIs();
      results['PM QueryIntentActivities'] =
          await _plugin.pmQueryIntentActivities();
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ApplistDetectorFlutter example'),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                setState(() => isLoading = true);
                _init();
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
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                child: Column(
                  children: [
                    ExpansionPanelList(
                      expansionCallback: (index, isExpanded) {
                        final key = results.keys.elementAt(index);
                        if (isExpanded) {
                          selected.remove(key);
                        } else {
                          selected.add(key);
                        }

                        if (mounted) setState(() {});
                      },
                      children: results.entries
                          .map(
                            (e) => buildExpPanel(e.value,
                                testName: e.key,
                                isExpanded: selected.contains(e.key)),
                          )
                          .toList(),
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

const Map<DetectorResultType, Widget> icons = {
  DetectorResultType.notFound: Icon(Icons.done),
  DetectorResultType.found: Icon(Icons.coronavirus, color: Colors.red),
  DetectorResultType.suspicious: Icon(Icons.visibility),
  DetectorResultType.methodUnavailable: Icon(Icons.code_off),
};

const Map<DetectorResultType, String> labels = {
  DetectorResultType.notFound: "Not Found",
  DetectorResultType.found: "Found",
  DetectorResultType.suspicious: "Suspicious",
  DetectorResultType.methodUnavailable: "Method Unavailable",
};

ExpansionPanel buildExpPanel(
  DetectorResult result, {
  required String testName,
  bool isExpanded = false,
}) {
  final details = result.details;
  return ExpansionPanel(
    isExpanded: isExpanded,
    headerBuilder: (context, isExpanded) {
      return ListTile(
        leading: icons[result.type],
        title: Text(testName),
      );
    },
    body: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ).add(const EdgeInsets.only(bottom: 15)),
      child: Column(
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
    ),
  );
}
