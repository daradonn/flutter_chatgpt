import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt/features/global/search_text_field/search_text_field_widget.dart';
import 'package:flutter_chatgpt/features/text_completion/presentation/cubit/text_completion_cubit.dart';
import 'package:share_plus/share_plus.dart';

class TextAssistantPage extends StatefulWidget {
  const TextAssistantPage({Key? key}) : super(key: key);

  @override
  State<TextAssistantPage> createState() => _TextAssistantPageState();
}

class _TextAssistantPageState extends State<TextAssistantPage> {
  TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    _searchTextController.addListener(() {
      setState(() {});
    });
    _clearTextField();
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Assistant Page"),
      ),
      body: Center(
        child: Column(children: [
          Expanded(
            child: BlocBuilder<TextCompletionCubit, TextCompletionState>(
              builder: (context, textCompletionState) {
                if (textCompletionState is TextCompletionLoading) {
                  return Center(
                    child: Container(
                        width: 300,
                        height: 300,
                        child: Image.asset("assets/loading.gif")),
                  );
                }
                if (textCompletionState is TextCompletionLoaded) {
                  final choicesData =
                      textCompletionState.textCompletionModelData.choices;

                  return ListView.builder(
                    itemCount: choicesData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final textData = choicesData[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                textData.text,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Share.share(textData.text);
                                      },
                                      child: Icon(Icons.share, size: 35)),
                                  InkWell(
                                      onTap: () {
                                        Clipboard.setData(
                                            ClipboardData(text: textData.text));
                                      },
                                      child: Icon(
                                        Icons.copy,
                                        size: 35,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                if (textCompletionState is TextCompletionLoadedTurbo) {
                  final choicesData =
                      textCompletionState.textCompletionModelTurboData.choices;

                  return ListView.builder(
                    itemCount: choicesData?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final textData = choicesData?[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                textData?.message?.content ?? "",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Share.share(
                                            textData?.message?.content ?? "");
                                      },
                                      child: Icon(Icons.share, size: 35)),
                                  InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: textData?.message?.content ??
                                                ""));
                                      },
                                      child: Icon(
                                        Icons.copy,
                                        size: 35,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return Center(
                    child: Text(
                  "OpenAI Text Assistant",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ));
              },
            ),
          ),
          SearchTextFieldWidget(
              textEditingController: _searchTextController,
              onTap: () {
                BlocProvider.of<TextCompletionCubit>(context)
                    .textCompletionTurbo(
                        query: _searchTextController.text, role: "assistant")
                    .then((value) => _clearTextField());
              }),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  void _clearTextField() {
    setState(() {
      _searchTextController.clear();
    });
  }
}
