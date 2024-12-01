import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:hdlive_latest/models/device_info_model.dart';
import 'package:location/location.dart';

class HelperServices{

  static Future<DeviceInfoModel?>  getDeviceInfo()async{
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

    try{
      DeviceInfoModel? info;
      if(Platform.isAndroid){
        var build = await deviceInfoPlugin.androidInfo;
         info = DeviceInfoModel(
            deviceName: build.model,
           deviceVersion: build.version.toString(),
           identifier: build.androidId
         );
      }

      return info;
    }catch(e){
      print(e);
    }
  }

  static Future<LocationData?> getCurrentLocation()async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }
}