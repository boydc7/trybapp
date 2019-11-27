import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:trybapp/utils/device_utils.dart';
import 'package:trybapp/utils/enum_utils.dart';

import 'app_config.dart';

class DeviceInfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 10.0),
      title: Container(
        padding: EdgeInsets.all(15.0),
        child: Text(
          'Device Info',
          style: TextStyle(color: Colors.white),
        ),
      ),
      titlePadding: EdgeInsets.all(0),
      content: _getContent(),
    );
  }

  Widget _getContent() {
    if (Platform.isAndroid) {
      return _androidContext();
    }

    if (Platform.isIOS) {
      return _iosContent();
    }

    return Text(
        'You are not running Android or iOS. Is Windows? [${Platform.isWindows}. OS: [${Platform.operatingSystem}');
  }

  Widget _iosContent() {
    return FutureBuilder(
      future: DeviceUtils.iosDeviceInfo(),
      builder: (context, AsyncSnapshot<IosDeviceInfo> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        var device = snapshot.data;

        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTile('Flavor:', '${AppConfig.instance.appFlavorName}'),
              _buildTile('Build mode:', '${Enums.toEnumName(DeviceUtils.currentBuildMode().toString())}'),
              _buildTile('Physical device?:', '${device.isPhysicalDevice}'),
              _buildTile('UUID:', '${device.identifierForVendor}'),
              _buildTile('Device:', '${device.name}'),
              _buildTile('Model:', '${device.model}'),
              _buildTile('SysName:', '${device.systemName}'),
              _buildTile('Version:', '${device.systemVersion}'),
            ],
          ),
        );
      },
    );
  }

  Widget _androidContext() {
    return FutureBuilder(
      future: DeviceUtils.androidDeviceInfo(),
      builder: (context, AsyncSnapshot<AndroidDeviceInfo> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        var device = snapshot.data;

        return SingleChildScrollView(
            child: Column(
          children: <Widget>[
            _buildTile('Flavor:', '${AppConfig.instance.appFlavorName}'),
            _buildTile('Build mode:', '${Enums.toEnumName(DeviceUtils.currentBuildMode().toString())}'),
            _buildTile('Physical device?:', '${device.isPhysicalDevice}'),
            _buildTile('Manufacturer:', '${device.manufacturer}'),
            _buildTile('Model:', '${device.model}'),
            _buildTile('Android Ver:', '${device.version.release}'),
            _buildTile('Android SDK:', '${device.version.sdkInt}'),
            _buildTile('DeviceId:', '${device.androidId}'),
            _buildTile('Brand:', '${device.brand}'),
            _buildTile('Device:', '${device.device}'),
            _buildTile('Product:', '${device.product}'),
          ],
        ));
      },
    );
  }

  Widget _buildTile(String key, String value) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Text(
            key,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value)
        ],
      ),
    );
  }
}
