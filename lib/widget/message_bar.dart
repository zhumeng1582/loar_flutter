import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loar_flutter/common/util/ex_widget.dart';

import '../common/colors.dart';

///Normal Message bar with more actions
///
/// following attributes can be modified
///
///
/// # BOOLEANS
/// [replying] is the additional reply widget top of the message bar
///
/// # STRINGS
/// [replyingTo] is the string to tag the replying message
/// [messageBarHitText] is the string to show as message bar hint
///
/// # WIDGETS
/// [actions] are the additional leading action buttons like camera
/// and file select
///
/// # COLORS
/// [replyWidgetColor] is the reply widget color
/// [replyIconColor] is the reply icon color on the left side of reply widget
/// [replyCloseColor] is the close icon color on the right side of the reply
/// widget
/// [messageBarColor] is the color of the message bar
/// [sendButtonColor] is the color of the send button
/// [messageBarHintStyle] is the style of the message bar hint
///
/// # METHODS
/// [onTextChanged] is the function which triggers after text every text change
/// [onSend] is the send button action
/// [onTapCloseReply] is the close button action of the close button on the
/// reply widget usually change [replying] attribute to `false`

class MessageBar extends StatefulWidget {
  final bool replying;
  final String replyingTo;
  final List<Widget> actions;
  final TextEditingController textController;
  final Color replyWidgetColor;
  final Color replyIconColor;
  final Color replyCloseColor;
  final Color messageBarColor;
  final String messageBarHitText;
  final TextStyle messageBarHintStyle;
  final Color sendButtonColor;
  final String sendButtonText;
  final void Function(String)? onTextChanged;
  final bool Function(String)? onSend;
  final void Function()? sendLocalMessage;
  final void Function()? onTapCloseReply;

  /// [MessageBar] constructor
  ///
  ///
  const MessageBar({
    super.key,
    required this.textController,
    this.replying = false,
    this.replyingTo = "",
    this.actions = const [],
    this.replyWidgetColor = const Color(0xffF4F4F5),
    this.replyIconColor = Colors.blue,
    this.replyCloseColor = Colors.black12,
    this.messageBarColor = const Color(0xffF4F4F5),
    this.sendButtonColor = const Color(0x00ffffff),
    this.sendButtonText = "发送",
    this.messageBarHitText = "请输入消息",
    this.messageBarHintStyle = const TextStyle(fontSize: 16),
    this.onTextChanged,
    this.onSend,
    this.sendLocalMessage,
    this.onTapCloseReply,
  });

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  int calculateLength() {
    int length = 0;
    for (int i = 0; i < widget.textController.text.runes.length; i++) {
      int rune = widget.textController.text.runes.elementAt(i);
      String char = String.fromCharCode(rune);
      if (RegExp(r'[\u4e00-\u9fa5]').hasMatch(char)) {
        length += 3; // 中文字符长度加3
      } else {
        length += 1; // 英文字符长度加1
      }
    }
    return length;
  }

  bool isSendText = false;

  @override
  Widget build(BuildContext context) {
    widget.textController.addListener(() {
      setState(() {
        isSendText = widget.textController.text.isNotEmpty;
      });
    });
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          widget.replying
              ? Container(
              color: widget.replyWidgetColor,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.reply,
                    color: widget.replyIconColor,
                    size: 24,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Re : ${widget.replyingTo}',
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onTapCloseReply,
                    child: Icon(
                      Icons.close,
                      color: widget.replyCloseColor,
                      size: 24,
                    ),
                  ),
                ],
              ))
              : Container(),
          widget.replying
              ? Container(
            height: 1,
            color: Colors.grey.shade300,
          )
              : Container(),
          Container(
            color: widget.messageBarColor,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: widget.textController,
                    keyboardType: TextInputType.multiline,
                    inputFormatters: [
                      CustomLengthTextInputFormatter(maxLength: 60)
                    ],
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 3,
                    // maxLength: 48,
                    // //最大100个字符
                    onChanged: widget.onTextChanged,
                    decoration: InputDecoration(
                      counterText: '${calculateLength()} / 69',
                      hintText: widget.messageBarHitText,
                      hintMaxLines: 1,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      hintStyle: widget.messageBarHintStyle,
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 0.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.black26,
                          width: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
                isSendText
                    ? Text(
                        widget.sendButtonText,
                        style: TextStyle(color: AppColors.white),
                      )
                        .padding(horizontal: 15, vertical: 5)
                        .borderRadius(all: 5, color: widget.sendButtonColor)
                        .padding(left: 16)
                    .onTap(() {
                  if (widget.textController.text.trim() != '') {
                    if (widget.onSend != null) {
                      bool isSuccess = widget
                          .onSend!(widget.textController.text.trim());
                      if (isSuccess) {
                        widget.textController.text = '';
                      }
                    }
                  }
                })
                    : const Icon(
                  Icons.place,
                  color: Colors.black,
                  size: 24,
                )
                    .padding(horizontal: 15, vertical: 5)
                        .onTap(widget.sendLocalMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomLengthTextInputFormatter extends TextInputFormatter {
  final int maxLength; // 设置最大长度

  CustomLengthTextInputFormatter({this.maxLength = 69});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int currentLength = 0;

    // 新值的所有字符
    final newText = StringBuffer();

    for (int i = 0; i < newValue.text.runes.length; i++) {
      int rune = newValue.text.runes.elementAt(i);
      String char = String.fromCharCode(rune);

      // 根据字符类型增加长度
      if (RegExp(r'[\u4e00-\u9fa5]').hasMatch(char)) {
        currentLength += 3; // 中文字符长度加3
      } else {
        currentLength += 1; // 英文字符长度加1
      }

      // 如果超过最大长度，则停止添加字符
      if (currentLength <= maxLength) {
        newText.write(char);
      } else {
        break;
      }
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
