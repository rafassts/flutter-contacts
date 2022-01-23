import 'package:contacts/ios/styles.dart';
import 'package:flutter/cupertino.dart';

class AddressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              "Contato",
              style: TextStyle(color: primaryColor, fontSize: 24),
            ),
            trailing: CupertinoButton(
              child: Icon(CupertinoIcons.location),
              onPressed: () {},
            ),
          ),
          SliverFillRemaining(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Endereço",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Rua dos Dev, 401",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "Terra Nova, SP",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CupertinoTextField(
                    placeholder: "Pesquisar...",
                  ),
                ),
                SizedBox(height: 40),
                Expanded(
                  child: Container(color: primaryColor.withOpacity(0.2)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
