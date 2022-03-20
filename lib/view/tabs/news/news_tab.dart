import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsTabState();
}

const List<Tab> tabs = <Tab>[
  // does this part d
  Tab(text: 'Now'),
  Tab(text: 'Upcoming'),
];

class _NewsTabState extends State<NewsTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const TabBar(
                tabs: [
                  Tab(text: "Current"),
                  Tab(text: "Upcoming"),
                  //more tabs here
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.settings_outlined))
              ],
            ),
            body: Container(
                child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[newsList()],
            )),
          ),
        );
      }),
    );
  }

  Widget newsList() {
    return Column(
      children: <Widget>[
        upgradingNewsItem("At Block 1 Dover Road", "1st Quarter 2022"),
        marketNewsItem(
          "Upper Boon Keng Road Blk 17 (Blk 17 Upper Boon Keng Market and Food Centre)",
          "10/1/2022",
          "11/1/2022",
        ),
        eventNewsItem("intro to chromatic harmonica", "5 Mar 2022, 3pm - 5pm"),
        dengueNewsItem("Joo Chiat Rd / Onan Rd", "3"),
        upgradingNewsItem(
            "Beside Block 268C Boon Lay Drive", "2nd Quarter 2022"),
        marketNewsItem("Telok Blangah Rise Blk 36 (Telok Blangah Rise Market)",
            "10/1/2022", "10/1/2022"),
        eventNewsItem("Jurong Spring IRCC Getai Nite 2022",
            "19 Mar 2022- 20 Mar 2022 , 7.30pm - 10pm"),
        dengueNewsItem("Hougang Ave 3 (Blk 24)", "2"),
        upgradingNewsItem("At Block 209 Boon Lay Place", "3rd Quarter 2022"),
        marketNewsItem("Toa Payoh Lorong 8 Blk 210", "10/1/2022", "11/1/2022"),
        eventNewsItem("Nanyang Shoe Recycling Drive Donation 2022",
            "15 Jan 2022 - 31 Dec 2022, 9.00am - 11:30pm"),
        dengueNewsItem("Hougang Ave 8 (Blk 626, 629, 630)", "3")
      ],
    );
  }

  Widget upgradingNewsItem(String location, String date) {
    //since for upgrading exact date is not given, only time period is given, only 1 date var
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.red.withAlpha(30),
          onTap: () {
            final popup = BeautifulPopup(
              context: context,
              template: TemplateGeolocation,
            );
            popup.show(
              title: 'Upgrading News',
              content: 'blah blah blah',
              actions: [
                popup.button(
                  label: 'More info',
                  onPressed: _launchURL,
                ),
              ],
              // bool barrierDismissible = false,
              // Widget close,
            );

            debugPrint(
                'Card tapped.'); // jamie i believe u shld be adding ur code here??? idk tbh
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Text("Upgrading"),
                title: Text(location),
                subtitle: Text("Estimated completion by " + date),
              )
            ],
          ),
        ),
      ),
    );
  } //type, location, date

  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  Widget marketNewsItem(
      String location, String date1, String date2, String URL) {
    //date 1 and date 2 is for if closed over period of time
    String _url = URL;
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.red.withAlpha(30),
          onTap: () {
            final popup = BeautifulPopup(
              context: context,
              template: TemplateGeolocation,
            );
            popup.show(
              title: 'Market News',
              content: 'blah blah blah',
              actions: [
                popup.button(label: 'Redirect', onPressed: _launchURL),
              ],
              // bool barrierDismissible = false,
              // Widget close,
            );

            debugPrint(
                'Card tapped.'); // jamie i believe u shld be adding ur code here??? idk tbh
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Text("Market Closure"),
                title: Text(location),
                subtitle: Text(date1 + "-" + date2),
              )
            ],
          ),
        ),
      ),
    );
  } //type, location, date

  Widget eventNewsItem(String name, String dateTime) {
    //event name and date and time
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.red.withAlpha(30),
          onTap: () {
            final popup = BeautifulPopup(
              context: context,
              template: TemplateGeolocation,
            );
            popup.show(
              title: 'Upgrading News',
              content: 'blah blah blah',
              actions: [
                popup.button(label: 'Redirect', onPressed: () {}),
              ],
              // bool barrierDismissible = false,
              // Widget close,
            );

            debugPrint(
                'Card tapped.'); // jamie i believe u shld be adding ur code here??? idk tbh
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Text("Events"),
                title: Text(name),
                subtitle: Text(dateTime),
              )
            ],
          ),
        ),
      ),
    );
  } //type, location, date

  Widget dengueNewsItem(String areaName, String caseSize) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.red.withAlpha(30),
          onTap: () {
            final popup = BeautifulPopup(
              context: context,
              template: TemplateGeolocation,
            );
            popup.show(
              title: 'Upgrading News',
              content: 'blah blah blah',
              actions: [
                popup.button(label: 'Redirect', onPressed: () {}),
              ],
              // bool barrierDismissible = false,
              // Widget close,
            );
            debugPrint(
                'Card tapped.'); // jamie i believe u shld be adding ur code here??? idk tbh
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Text("Dengue"),
                title: Text(areaName),
                subtitle: Text("No of cases: " + caseSize),
              )
            ],
          ),
        ),
      ),
    );
  } //type, location, date
}
