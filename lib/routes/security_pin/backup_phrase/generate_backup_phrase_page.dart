import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'verify_backup_phrase_page.dart';

class GenerateBackupPhrasePage extends StatefulWidget {
  final String mnemonics;

  GenerateBackupPhrasePage(this.mnemonics);

  @override
  GenerateBackupPhrasePageState createState() =>
      GenerateBackupPhrasePageState();
}

class GenerateBackupPhrasePageState extends State<GenerateBackupPhrasePage> {
  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  List<String> _mnemonicsList;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            textTheme: Theme.of(context).appBarTheme.textTheme,
            backgroundColor: Theme.of(context).canvasColor,
            automaticallyImplyLeading: false,
            leading: backBtn.BackButton(
              onPressed: () => _onWillPop(context),
            ),
            title: AutoSizeText(
              "Write these words",
              style: Theme.of(context).appBarTheme.textTheme.headline6,
              maxLines: 1,
            ),
            elevation: 0.0),
        body: _buildMnemonicSeedList(0),
        bottomNavigationBar: _buildNextBtn(),
      ),
    );
  }

  @override
  void initState() {
    _mnemonicsList = widget.mnemonics.split(" ");
    super.initState();
  }

  _buildMnemonicItem(int index, String mnemonic) {
    return Container(
      height: 48,
      width: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Row(children: [
        Text('${index + 1}.', style: theme.mnemonicsTextStyle),
        Expanded(
          child: AutoSizeText(
            mnemonic,
            style: theme.mnemonicsTextStyle,
            textAlign: TextAlign.center,
            maxLines: 1,
            minFontSize: MinFontSize(context).minFontSize,
            stepGranularity: 0.1,
            group: _autoSizeGroup,
          ),
        ),
      ]),
    );
  }

  Row _buildMnemonicSeedList(int page) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: List<Widget>.generate(
                6,
                (index) => _buildMnemonicItem(2 * index + (12 * (page)),
                    _mnemonicsList[2 * index + (12 * (page))])),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: List<Widget>.generate(
                6,
                (index) => _buildMnemonicItem(1 + 2 * index + 12 * (page),
                    _mnemonicsList[1 + 2 * index + 12 * (page)])),
          ),
        ]);
  }

  _buildNextBtn() {
    return SingleButtonBottomBar(
      text: "NEXT",
      onPressed: () {
        Navigator.push(
          context,
          FadeInRoute(
            builder: (_) => withBreezTheme(
              context,
              VerifyBackupPhrasePage(widget.mnemonics),
            ),
          ),
        );
      },
    );
  }

  _onWillPop(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName("/security"));
  }
}
