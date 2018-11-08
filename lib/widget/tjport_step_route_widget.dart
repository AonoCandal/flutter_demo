import 'package:flutter/material.dart';

class TJPortStepRoute {
  TJPortStepStatus status;
  String timeNode;
  String timeDescription;
  String mainAddress;
  String subAddress;

  TJPortStepRoute(
      {this.status,
      this.timeNode,
      this.mainAddress,
      this.subAddress,
      this.timeDescription});
}

class TJPortStepStatus {
  String stepTitle;
  String stepSubTitle;
  Color color;

  TJPortStepStatus({this.stepTitle, this.stepSubTitle, this.color});
}

Map<String, TJPortStepStatus> stepStatus = {
  '提': TJPortStepStatus(stepTitle: '提', color: Color(0xff2196F3)),
  '运': TJPortStepStatus(stepTitle: '运', color: Color(0xffFFA600)),
  '还': TJPortStepStatus(stepTitle: '还', color: Color(0xff2196F3)),
  '装': TJPortStepStatus(stepTitle: '装', color: Color(0xff2196F3)),
  '抵': TJPortStepStatus(stepTitle: '抵', color: Color(0xff2196F3)),
  '配普': TJPortStepStatus(
      stepTitle: '配', color: Color(0xff10C2B0), stepSubTitle: '普货'),
  '配箱': TJPortStepStatus(
      stepTitle: '配', color: Color(0xffF7703F), stepSubTitle: '箱货'),
};

class TJPortStepRouteWidget extends StatelessWidget {
  final List<TJPortStepRoute> addressList;

  TJPortStepRouteWidget(this.addressList);

  @override
  Widget build(BuildContext context) {
    if (addressList == null || addressList.length == 0) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 16.0, right: 16.0, bottom: 6.0),
      child: Column(
        children: addressList.map((address) {
          return _buildStepWidget(address);
        }).toList(),
      ),
    );
  }

  Widget _buildStepWidget(TJPortStepRoute address) {
    return Container(
      height: 85.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(addressList.indexOf(address), address),
          Expanded(child: _buildContent(address)),
        ],
      ),
    );
  }

  _buildHeader(int index, TJPortStepRoute address) {
    return Column(
      children: <Widget>[
        isDistribution(address)
            ? _buildOval(address.status)
            : _buildCircle(address.status),
        Expanded(
          child: index == addressList.length - 1 ? Container() : _buildLine(),
        )
      ],
    );
  }

  Widget _buildCircle(TJPortStepStatus status) {
    return new Container(
      width: 32.0,
      height: 32.0,
      child: new AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: new BoxDecoration(
          color: status.color,
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: Text(
            '${status.stepTitle ?? ''}',
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildOval(TJPortStepStatus status) {
    return new Container(
      width: 32.0,
      height: 44.0,
      child: new AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: new BoxDecoration(
            color: status.color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${status.stepTitle ?? ''}',
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '${status.stepSubTitle ?? ''}',
              style: TextStyle(fontSize: 12.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: 0.5,
      color: Color(0xff2196F3),
    );
  }

  _buildContent(TJPortStepRoute address) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 32.0,
            alignment: Alignment.centerLeft,
            child: Text(
              '${address.timeDescription ?? ''}',
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xff2196F3),
              ),
            ),
          ),
          Text(
            '${address.mainAddress ?? ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xff292929),
            ),
          ),
          Container(height: 8.0),
          Text(
            '${address.subAddress ?? ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              color: Color(0xff7a7a7a),
            ),
          ),
        ],
      ),
    );
  }

  bool isDistribution(TJPortStepRoute address) {
    return address.status == stepStatus['配普'] ||
        address.status == stepStatus['配箱'];
  }
}
