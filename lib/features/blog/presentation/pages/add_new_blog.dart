import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constant/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});
  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final blogController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<String> selectedTopic = [];
  File? image;

  Future<void> selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopic.isNotEmpty &&
        image != null) {
      final posterId =
          ((context.read<AppUserCubit>().state) as AppUserLoggedIn).user.id;
      print(posterId);
      context.read<BlogBloc>().add(
            BlogUpload(
              posterId: posterId,
              title: titleController.text.trim(),
              content: blogController.text.trim(),
              image: image!,
              topics: selectedTopic,
            ),
          );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    blogController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              print('Starting upload');
              uploadBlog();
            },
            icon: const Icon(
              Icons.done_rounded,
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            return showSnackbar(context, state.error);
          } else if (state is BlogSuccessUpload) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) return const Loader();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if (image == null)
                      GestureDetector(
                        onTap: selectImage,
                        child: DottedBorder(
                          color: AppPallete.borderColor,
                          dashPattern: const [
                            20,
                            4,
                          ],
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,
                          child: const SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Select your Image',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: selectImage,
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.topics
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    selectedTopic.contains(e)
                                        ? selectedTopic.remove(e)
                                        : selectedTopic.add(e);
                                    setState(() {});
                                  },
                                  child: Chip(
                                    color: selectedTopic.contains(e)
                                        ? const WidgetStatePropertyAll(
                                            AppPallete.gradient1,
                                          )
                                        : null,
                                    label: Text(
                                      e,
                                    ),
                                    side: selectedTopic.contains(e)
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog Title',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                      controller: blogController,
                      hintText: 'Blog Content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
