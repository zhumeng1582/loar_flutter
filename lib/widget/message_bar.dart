import 'package:flutter/material.dart';
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
    this.sendButtonColor = Colors.blue,
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
                            'Re : ' + widget.replyingTo,
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
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 3,
                    maxLength: 100,
                    //最大100个字符
                    onChanged: widget.onTextChanged,
                    decoration: InputDecoration(
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
                        "发送",
                        style: TextStyle(color: AppColors.white),
                      )
                        .padding(horizontal: 15, vertical: 5)
                        .borderRadius(all: 5, color: AppColors.commonPrimary)
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
