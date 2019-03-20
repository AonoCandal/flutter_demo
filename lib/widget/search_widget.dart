import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key key,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.onEditingComplete,
    this.textInputAction,
    this.obscureText = false,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final bool autoFocus;
  final TextInputType keyboardType;
  final VoidCallback onEditingComplete;
  final TextInputAction textInputAction;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 4),
              child: Center(
                child: Image.asset(
                  'images/icon_search.png',
                  height: 18,
                  width: 18,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                autofocus: autoFocus,
                onSubmitted: onSubmitted,
                onChanged: onChanged,
                keyboardType: keyboardType,
                onEditingComplete: onEditingComplete,
                textInputAction: textInputAction,
                maxLines: 1,
                obscureText: obscureText,
                style: const TextStyle(fontSize: 15, color: Color(0xff333333)),
                decoration: const InputDecoration.collapsed(
                  hintText: '请输入型号、品牌、名称',
                  hintStyle: TextStyle(
                    color: Color(0xFFB0B0B0),
                    fontSize: 15,
                  ),
                ),
                cursorColor: const Color(0xff333333),
                controller: controller,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 12),
              child: Center(
                child: InkWell(
                  onTap: () => controller.clear(),
                  child: Image.asset(
                    'images/icon_search_del.png',
                    height: 18,
                    width: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
