import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wodka/app/home/models/wod.dart';
import 'package:wodka/app/home/wods/format.dart';
import 'package:wodka/common_widgets/show_alert_dialog.dart';
import 'package:wodka/common_widgets/show_exception_alert_dialog.dart';
import 'package:wodka/services/database.dart';

class EditWodPage extends StatefulWidget {
  const EditWodPage({Key key, @required this.database, this.wod})
      : super(key: key);
  final Database database;
  final Wod wod;

  static Future<void> show(BuildContext context,
      {Database database, Wod wod}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditWodPage(
          database: database,
          wod: wod,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditWodPageState createState() => _EditWodPageState();
}

class _EditWodPageState extends State<EditWodPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime _name;
  String _wodDescription;
  String _myScore;
  DateTime _selectedDate;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.wod != null) {
      _name = widget.wod.wodDate;
      _wodDescription = widget.wod.wodDescription;
      _myScore = widget.wod.myScore;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final wods = await widget.database.wodsStream().first;
        final allNames = wods.map((wod) => wod.wodDate).toList();
        if (widget.wod != null) {
          allNames.remove(widget.wod.wodDate);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'This date was already assigned a wod',
            content:
                'Please choose a different date or delete the current wod for this date',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.wod?.id ?? documentIdFromCurrentDate();
          final wod = Wod(
              id: id,
              wodDate: _name,
              myScore: _myScore,
              wodDescription: _wodDescription);
          await widget.database.setWod(wod);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.wod == null ? 'New Job' : 'Edit job'),
        actions: [
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    _textEditingController.text = _name != null
        ? '${Format.dayOfWeek(_name)}, ${Format.date(_name)}'
        : '';

    return [
      GestureDetector(
        onTap: () => _selectDate(),
        child: AbsorbPointer(
          child: TextFormField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: 'WOD date'),
            validator: (value) =>
                value.isNotEmpty ? null : 'Name can\'t be empty',
            onSaved: (value) => _name,
          ),
        ),
      ),
      TextFormField(
        //enabled: false,
        minLines: 20,
        maxLines: 20,
        decoration: InputDecoration(labelText: 'WOD description'),
        initialValue: _wodDescription,
        validator: (value) =>
            value.isNotEmpty ? null : 'Wod description can\'t be empty',
        onSaved: (value) => _wodDescription = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'My Score:'),
        initialValue: _myScore != null ? '$_myScore' : '',
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        onSaved: (value) => _myScore = value,
      ),
    ];
  }

  void _selectDate() async {
    DateTime pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate;
        return Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text('Done'),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(tempPickedDate ?? DateTime.now());
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    minimumYear: DateTime.now().year - 1,
                    maximumYear: DateTime.now().year + 1,
                    initialDateTime: _name ?? DateTime.now(),
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _name) {
      setState(() {
        _name = pickedDate;
        _textEditingController.text =
            '${Format.dayOfWeek(pickedDate)}, ${Format.date(pickedDate)}';
      });
    }
  }
}
