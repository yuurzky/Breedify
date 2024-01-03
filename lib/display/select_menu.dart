import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectMenu extends StatefulWidget {
  const SelectMenu({Key? key}) : super(key: key);

  @override
  State<SelectMenu> createState() => _SelectMenuState();
}

class _SelectMenuState extends State<SelectMenu> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => const AlertOnExit(),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext build) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => const AlertOnExit(),
            ) ??
            false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Breedify',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.black, fontFamily: 'BalsamiqSans', fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _onWillPop();
              },
              icon: Image.asset(
                'assets/exit_icon.png',
                width: 16,
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IdentifyWidget(context: context),
              AskWidget(context: context),
            ],
          ),
        ),
      ),
    );
  }
}

class AskWidget extends StatelessWidget {
  const AskWidget({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFFE3D26F),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/ask');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE3D26F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Ask MeowAI",
                      style: TextStyle(
                          fontFamily: 'BalsamiqSans', fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(
              'assets/ask.png',
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class IdentifyWidget extends StatelessWidget {
  const IdentifyWidget({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      height: 150,
      margin: const EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF2F1B25),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/identify');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F1B25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/identify.png',
              height: 100,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Identify Your Cat's Breed",
                      style: TextStyle(
                          fontFamily: 'BalsamiqSans', fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertOnExit extends StatelessWidget {
  const AlertOnExit({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Confirm Exit',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'BalsamiqSans',
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      content: const Text(
        'Are you sure you want to exit?',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'BalsamiqSans',
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No', style: TextStyle(
            color: Colors.green,
            fontFamily: 'BalsamiqSans',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),),
        ),
        TextButton(
          onPressed: () => SystemNavigator.pop(),
          child: const Text('Yes',style: TextStyle(
            color: Colors.red,
            fontFamily: 'BalsamiqSans',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),),
        ),
      ],
    );
  }
}
