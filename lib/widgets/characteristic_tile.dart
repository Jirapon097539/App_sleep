// ignore_for_file: avoid_print

import 'dart:async';

import 'package:app_login/Page/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../utils/snackbar.dart';

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;

  const CharacteristicTile({
    Key? key,
    required this.characteristic,
  }) : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  List<int> _value = [];

  late StreamSubscription<List<int>> _lastValueSubscription;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription =
        widget.characteristic.lastValueStream.listen((value) {
      _value = value;
      if (mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onReadPressed(context);
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BluetoothCharacteristic get c => widget.characteristic;

  Future<void> onReadPressed(BuildContext context) async {
    // Add BuildContext context
    try {
      List<int> value = await c.read();
      String currentDecodedValue = String.fromCharCodes(value);
      print(currentDecodedValue);
      // Navigate to Dashboard with the decoded value and characteristic
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            characteristic: c,
          ),
        ),
      );
      Snackbar.show(ABC.c, "Read: Success", success: true); // Update this line
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Read Error:", e),
          success: false); // Update this line
    }
  }

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    return Text(data, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
      child: const Text(""),
      onPressed: () async {
        await onReadPressed(context); // Pass context here
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget buildButtonRow(BuildContext context) {
    bool read = widget.characteristic.properties.read;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (read) buildReadButton(context), // Pass context here
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildButtonRow(context), // Pass context here
      ],
    );
  }
}
