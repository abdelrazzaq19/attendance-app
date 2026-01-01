import 'dart:math' as math;

import 'package:attendance_app/controllers/history_controller.dart';
import 'package:attendance_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class AttendanceHistory extends GetView<HistoryController> {
  const AttendanceHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your History',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Divider(),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(thickness: 0.4),
            itemCount: state!.length,
            itemBuilder: (context, index) {
              final data = state[index];
              return ListTile(
                onTap: () {
                  Get.bottomSheet(
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Transform.rotate(
                            angle: -math.pi / 2,
                            child: Icon(Icons.chevron_left),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 300,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(
                                  data.location.latitude,
                                  data.location.longitude,
                                ),
                                initialZoom: 16,
                                interactionOptions: InteractionOptions(
                                  flags: InteractiveFlag.none,
                                ),
                                onTap: (tapPosition, point) =>
                                    Helper.openMap(data.location),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'com.example.attendance_app',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(
                                        data.location.latitude,
                                        data.location.longitude,
                                      ),
                                      width: 48,
                                      height: 48,
                                      alignment: Alignment.topCenter,
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 48,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Latitude: ${data.location.latitude}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Longitude: ${data.location.longitude}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Distance: ${data.distanceToTargetMeters.toStringAsFixed(2)} m',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  );
                },
                title: Text(data.type),
                titleTextStyle: Theme.of(context).textTheme.titleMedium,
                trailing: Text(
                  Helper.formatDateTime(data.timeStamp.toDate()),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              );
            },
          ),
        ],
      ),
      onError: (error) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Error fetching data.', textAlign: TextAlign.center)],
      ),
      onEmpty: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('No history found.', textAlign: TextAlign.center)],
      ),
      onLoading: Center(child: CircularProgressIndicator()),
    );
  }
}
