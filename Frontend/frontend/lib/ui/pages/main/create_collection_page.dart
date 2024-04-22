import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/collection_creation_cubit/collection_creation_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateCollectionPage extends StatefulWidget {
  final String albumId;
  const CreateCollectionPage({Key? key, required this.albumId})
      : super(key: key);

  @override
  State<CreateCollectionPage> createState() => _CreateCollectionPageState();
}

class _CreateCollectionPageState extends State<CreateCollectionPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _nameIsUnique = true;
  final _descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<CollectionCreationCubit, CollectionCreationState>(
        builder: (context, state) {
          if (state is CollectionCreationSuccessState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context, rootNavigator: true).pop();
              context.pop("removed");
            });
          }

          if (state is CollectionCreationInProgressState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showGeneralDialog(
                context: context,
                barrierColor:
                    Colors.black12.withOpacity(0.4), // Background color
                barrierDismissible: false,
                barrierLabel: 'Dialog',
                transitionDuration: Duration(milliseconds: 200),
                pageBuilder: (context, __, ___) {
                  return const Column(
                    children: <Widget>[
                      Expanded(
                          child: Center(
                        child: CircularProgressIndicator(),
                      ))
                    ],
                  );
                },
              );
            });
          }

          if (state is CollectionCreationErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context, rootNavigator: true).pop();
              _nameIsUnique = false;
              _formKey.currentState!.validate();
            });
          }

          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Create a new collection:",
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: TextFormField(
                        controller: _nameController,
                        minLines: 1,
                        maxLines: 1,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          label: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Collection name",
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          if (!_nameIsUnique) {
                            _nameIsUnique = true;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please give the collection a name';
                          }
                          if (!_nameIsUnique) {
                            return 'This collection name already exists';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: TextFormField(
                        controller: _descriptionController,
                        minLines: 2,
                        maxLines: 5,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          label: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Write description",
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<CollectionCreationCubit>()
                            .createCollection(
                                widget.albumId,
                                _nameController.text,
                                _descriptionController.text);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        "Create",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
