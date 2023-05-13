import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:timelines/timelines.dart';

// import '../widget.dart';

const kTileHeight = 50.0;

class ProductTimeLineDetails extends StatelessWidget {
  const ProductTimeLineDetails({
    Key key,
    @required this.installationStatus,
    @required this.serviceStatus,
    @required this.installedAt,
    @required this.assignedDate,
  });

  final String installationStatus;
  final String serviceStatus;
  final String installedAt;
  final String assignedDate;

  _OrderInfo _data(int id) => _OrderInfo(
        id: id,
        date: DateTime.now(),
        deliveryProcesses: [
          serviceStatus == "Done"
              ? _DeliveryProcess.complete():
          serviceStatus == "Request sent"?
          _DeliveryProcess(
            "Service Status",
            messages: [
              _DeliveryMessage(
                serviceStatus,
                "Service ",
              ),
            ],
          ): _DeliveryProcess.requested(),
          installationStatus == "Installed"
              ? _DeliveryProcess(
            "Product Installed On "+
                DateFormat("dd/MM/yyyy").format(DateTime.parse(installedAt)),
            messages: [
              _DeliveryMessage(
                DateFormat("hh:mm").format(DateTime.parse(installedAt)),
                'At ',
              ),
              // _DeliveryMessage(
              //   DateFormat("hh:mm").format(DateTime.parse(installedAt)),
              //   'Mark In for Installation',
              // ),
              // _DeliveryMessage(
              //   DateFormat("hh:mm").format(DateTime.parse(installedAt)),
              //   'Mark Out for Installation',
              // ),
              // _DeliveryMessage('11:30am', 'Mark in for installation'),
              // _DeliveryMessage('11:40am', 'Mark Out after Installation'),
            ],
          )
              : _DeliveryProcess(
            "Installation Pending",
            messages: [
              _DeliveryMessage(
                "--:--",
                'Installation Pending',
              ),
            ],
          ),
          _DeliveryProcess(
            'Product Assigned On ' +
                DateFormat("dd/MM/yyyy").format(DateTime.parse(assignedDate)),
            messages: [
              _DeliveryMessage(
                DateFormat("hh:mm").format(DateTime.parse(assignedDate)),
                'At ',
              ),
            ],
          ),

          // serviceStatus == "Request sent"
          //     ? _DeliveryProcess.complete()
        ],
      );
  @override
  Widget build(BuildContext context) {
    final data = _data(1);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,20.0),
          child: _OrderTitle(
            orderInfo: data,
          ),
        ),
        //Divider(height: 1.0),
        _DeliveryProcesses(processes: data.deliveryProcesses),
        //Divider(height: 1.0),
        Padding(
          padding: const EdgeInsets.all(20.0),
        ),
      ],
    );
  }
}

class _OrderTitle extends StatelessWidget {
  const _OrderTitle({
    Key key,
    @required this.orderInfo,
  }) : super(key: key);

  final _OrderInfo orderInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Spacer(),
        // Text(
        //   '${orderInfo.date.day}/${orderInfo.date.month}/${orderInfo.date.year}',
        //   style: TextStyle(
        //     color: Color(0xffb6b2b2),
        //   ),
        // ),
      ],
    );
  }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    @required this.messages,
  });

  final List<_DeliveryMessage> messages;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                thickness: 1.0,
              ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                size: 10.0,
                position: 0.5,
              ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
              !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }
            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                messages[index - 1].toString(),
              ),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
              isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({Key key, @required this.processes})
      : super(key: key);

  final List<_DeliveryProcess> processes;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              if(processes[index].isRequested){
                return SizedBox();
              }
              else {
                if (processes[index].isCompleted)
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Up to Date",
                      style: DefaultTextStyle
                          .of(context)
                          .style
                          .copyWith(
                        fontSize: 18.0,
                        color: Colors.green
                      ),
                    ),
                  );
                return Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        processes[index].name,
                        style: DefaultTextStyle
                            .of(context)
                            .style
                            .copyWith(
                          fontSize: 15.0,
                          color: (processes[0].isRequested && processes[index].name.contains('Product Installed On'))?Colors.green:
                          (processes[0].isRequested && processes[index].name.contains('Installation Pending'))?Colors.amber:
                          processes[index].name.contains('Service Status')?
                              Colors.amber:Colors.black,
                          fontFamily: 'PriximaNova',
                          fontWeight: (processes[0].isRequested && processes[index].name.contains('Product Installed On'))?FontWeight.bold:
                          (processes[0].isRequested && processes[index].name.contains('Installation Pending'))?FontWeight.bold:
                          processes[index].name.contains('Service Status')?FontWeight.bold:
                              FontWeight.w500
                        ),
                      ),
                      _InnerTimeline(messages: processes[index].messages),
                    ],
                  ),
                );
              }
            },
            indicatorBuilder: (_, index) {
              if(processes[index].isRequested){
                return SizedBox();
              }
              else if (processes[index].isCompleted) {
                return DotIndicator(
                  color: Color(0xff66c97f),
                  child: Icon(
                    Icons.check,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 12.0,
                  ),
                );
              }
              else if(processes[0].isRequested && processes[index].name.contains('Product Installed On')){
                return DotIndicator(
                  color: Colors.green,
                );
              }
              else if(processes[0].isRequested && processes[index].name.contains('Installation Pending')){
                return DotIndicator(
                  color: Colors.amber,
                );
              }
              else if(processes[index].name.contains('Service Status')){
                return DotIndicator(
                  color: Colors.amber,
                );
              }
              else {
                return OutlinedDotIndicator(
                  borderWidth: 2.5,
                );
              }
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: processes[index].isCompleted ? Color(0xff66c97f) : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderInfo {
  const _OrderInfo({
    @required this.id,
    @required this.date,
    @required this.deliveryProcesses,
  });
  final int id;
  final DateTime date;
  final List<_DeliveryProcess> deliveryProcesses;
}

class _DriverInfo {
  const _DriverInfo({
    @required this.name,
    @required this.thumbnailUrl,
  });

  final String name;
  final String thumbnailUrl;
}

class _DeliveryProcess {
  const _DeliveryProcess(
    this.name, {
    this.messages = const [],
  });

  const _DeliveryProcess.complete()
      : this.name = 'Done',
        this.messages = const [];

  const _DeliveryProcess.requested()
      : this.name = 'Requested',
        this.messages = const [];

  final String name;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
  bool get isRequested => name == 'Requested';
}

class _DeliveryMessage {
  const _DeliveryMessage(this.createdAt, this.message);

  final String createdAt; // final DateTime createdAt;
  final String message;

  @override
  String toString() {
    return '$message$createdAt';
  }
}
