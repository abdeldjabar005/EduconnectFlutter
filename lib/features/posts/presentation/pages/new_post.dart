import 'dart:developer';
import 'dart:io';

import 'package:educonnect/config/locale/app_localizations.dart';
import 'package:educonnect/core/api/end_points.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:educonnect/config/themes/custom_text_style.dart';
import 'package:educonnect/config/themes/theme_helper.dart';
import 'package:educonnect/core/utils/app_colors.dart';
import 'package:educonnect/core/utils/image_constant.dart';
import 'package:educonnect/core/utils/size_utils.dart';
import 'package:educonnect/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:educonnect/features/auth/presentation/widgets/custom_elevated_button.dart';
import 'package:educonnect/features/classrooms/presentation/cubit/post2_cubit.dart';
import 'package:educonnect/features/posts/data/models/post_m.dart';
import 'package:educonnect/features/posts/presentation/cubit/post_cubit.dart';
import 'package:educonnect/features/posts/presentation/widgets/custom_image_view.dart';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  late int? id;
  late String? name;
  late String? schoolClass;
  NewPost({Key? key, this.id, this.name, this.schoolClass}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _textController = TextEditingController();
  final _questionController = TextEditingController();

  List<XFile>? images;
  String type = "text";
  String errorMessage = '';
  String? selectedClassName;
  int? selectedClassId;
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _pollOptionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt']);
    if (result != null) {
      setState(() {
        images = result.paths.map((path) => XFile(path!)).toList();
        type = 'attachment';
      });
    }
  }

  void removeImage(XFile image) {
    setState(() {
      images!.remove(image);
      if (images!.isEmpty) {
        type = "text";
      }
    });
  }

  Map<String, String> roleTranslations = {
    'parent': 'والد',
    'teacher': 'معلم',
    'admin': 'مدير',
  };
  @override
  Widget build(BuildContext context) {
    bool isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final authState = context.watch<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      final classes = user.classes;

      log(type);
      return BlocConsumer<Post2Cubit, Post2State>(
        listener: (context, state) {
          if (state is Post2Loaded2) {
            Navigator.maybePop(context);
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                leading: const BackButton(
                  color: Colors.black,
                  style: ButtonStyle(),
                ),
                elevation: 0,
                title: Text(
                  AppLocalizations.of(context)!.translate('new_post')!,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(color: Colors.black.withOpacity(0.1))),
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 13.h,
                      vertical: 10.h,
                    ),
                    margin: EdgeInsets.all(
                      12.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 3.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomImageView(
                                border: Border.all(
                                  color: AppColors.gray200,
                                  width: 1.h,
                                ),
                                imagePath:
                                    '${EndPoints.storage}${user.profilePicture}',
                                height: 60.adaptSize,
                                width: 60.adaptSize,
                                radius: BorderRadius.circular(
                                  20.h,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16.h,
                                  top: 3.v,
                                  bottom: 3.v,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${user.firstName} ${user.lastName}',
                                      style: CustomTextStyles
                                          .bodyMediumRobotoGray900,
                                    ),
                                    SizedBox(height: 3.v),
                                    Text(
                                      isRtl
                                          ? roleTranslations[user.role] ??
                                              'مستخدم'
                                          : (user.role == 'admin'
                                              ? 'School Admin'
                                              : user.role),
                                      style: CustomTextStyles.titleGray,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20.h),
                              Container(
                                height: 50,
                                width: 130,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.v),
                        Container(
                          width: 297.h,
                          margin: EdgeInsets.only(right: 39.h),
                          child: TextFormField(
                            controller: _textController,
                            minLines: 1,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!
                                  .translate('write_something')!,
                              hintStyle: theme.textTheme.bodyLarge!.copyWith(
                                height: 1.38,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  errorMessage = AppLocalizations.of(context)!
                                      .translate('fill_text_fields')!;
                                });
                                return null;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 70.v),
                        if (type == 'poll') _buildPollOptions(),
                        if (images != null && images!.isNotEmpty)
                          Container(
                            height: 100.v,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images!.length,
                              itemBuilder: (context, index) {
                                final image = images![index];
                                final isVideo =
                                    image.path.toLowerCase().endsWith('.mp4');
                                final isDocument = type == 'attachment';

                                return Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.h),
                                      child: isVideo
                                          ? Text(
                                              image.path.split('/').last,
                                              style: TextStyle(fontSize: 16),
                                            )
                                          : isDocument
                                              ? Text(
                                                  image.path.split('/').last,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )
                                              : Image.file(
                                                  File(image.path),
                                                  height: 100.v,
                                                  width: 100.h,
                                                  fit: BoxFit.cover,
                                                ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          removeImage(image);
                                        },
                                        child: Container(
                                          height: 20.v,
                                          width: 20.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 20.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 10.v),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: type == 'attachment'
                                  ? null
                                  : () async {
                                      final ImagePicker _picker = ImagePicker();
                                      bool pickImage = true;
                                      if (images == null || images!.isEmpty) {
                                        // Ask the user if they want to pick a picture or a video.
                                        pickImage = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(AppLocalizations
                                                          .of(context)!
                                                      .translate(
                                                          'pick_pictures_video')!),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  'picture')!),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  'video')!),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            ) ??
                                            true; // Default to picking a picture.
                                      } else {
                                        pickImage = type == 'picture';
                                      }
                                      if (pickImage) {
                                        // Let the user pick multiple pictures.
                                        final List<XFile> pickedImages =
                                            await _picker.pickMultiImage();
                                        if (pickedImages.isNotEmpty) {
                                          setState(() {
                                            images = [
                                              ...?images,
                                              ...pickedImages
                                            ];
                                            type = 'picture';
                                          });
                                        }
                                      } else {
                                        // Let the user pick a video.
                                        final XFile? video =
                                            await _picker.pickVideo(
                                                source: ImageSource.gallery);
                                        if (video != null) {
                                          setState(() {
                                            images = [video];
                                            type = 'video';
                                          });
                                        }
                                      }
                                    },
                              child: Opacity(
                                opacity: type == 'attachment' ? 0.5 : 1.0,
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.gallery,
                                      height: 33.adaptSize,
                                      width: 33.adaptSize,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 3.v),
                                    ),
                                    SizedBox(width: 17.h),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('photo_video')!,
                                      style: CustomTextStyles
                                          .bodyMediumRobotoGray9002,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 13.v),
                            GestureDetector(
                              onTap: type == 'attachment'
                                  ? null
                                  : () async {
                                      final ImagePicker _picker = ImagePicker();
                                      bool takePicture = true;
                                      if (images == null || images!.isEmpty) {
                                        // Ask the user if they want to take a picture or a video.
                                        takePicture = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(AppLocalizations
                                                          .of(context)!
                                                      .translate(
                                                          'take_picture_video')!),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  'picture')!),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .translate(
                                                                  'video')!),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            ) ??
                                            true; // Default to taking a picture.
                                      } else {
                                        takePicture = type == 'picture';
                                      }
                                      if (takePicture) {
                                        // Let the user take a picture.
                                        final XFile? picture =
                                            await _picker.pickImage(
                                                source: ImageSource.camera);
                                        if (picture != null) {
                                          setState(() {
                                            images = [...?images, picture];
                                            type = 'picture';
                                          });
                                        }
                                      } else {
                                        // Let the user record a video.
                                        final XFile? video =
                                            await _picker.pickVideo(
                                                source: ImageSource.camera);
                                        if (video != null) {
                                          setState(() {
                                            images = [video];
                                            type = 'video';
                                          });
                                        }
                                      }
                                    },
                              child: Opacity(
                                opacity: type == 'attachment' ? 0.5 : 1.0,
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.camera,
                                      height: 33.adaptSize,
                                      width: 33.adaptSize,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 3.v),
                                    ),
                                    SizedBox(width: 17.h),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('camera')!,
                                      style: CustomTextStyles
                                          .bodyMediumRobotoGray9002,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 13.v),
                            GestureDetector(
                              onTap: type == 'picture' || type == 'video'
                                  ? null
                                  : () async {
                                      await pickDocument();
                                    },
                              child: Row(
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.attachment,
                                    height: 33.adaptSize,
                                    width: 33.adaptSize,
                                    margin: EdgeInsets.symmetric(vertical: 3.v),
                                  ),
                                  SizedBox(width: 17.h),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate('attachment')!,
                                    style: CustomTextStyles
                                        .bodyMediumRobotoGray9002,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 13.v),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      type = 'poll';
                                      images = null;
                                      _pollOptionControllers = [
                                        TextEditingController(),
                                        TextEditingController(),
                                      ];
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      CustomImageView(
                                        imagePath: ImageConstant.poll,
                                        height: 33.adaptSize,
                                        width: 33.adaptSize,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3.v),
                                      ),
                                      SizedBox(width: 17.h),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .translate('poll')!,
                                        style: CustomTextStyles
                                            .bodyMediumRobotoGray9002,
                                      ),
                                    ],
                                  ),
                                ),
                                _buildButton2(
                                    context,
                                    AppLocalizations.of(context)!
                                        .translate('post')!,
                                    state),
                              ],
                            ),
                            _buildThirtyNine(context, state),
                          ],
                        ),
                        SizedBox(height: 10.v),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  Widget _buildPollOptions() {
    return Column(
      children: [
        TextFormField(
          controller: _questionController,
          decoration: InputDecoration(
            labelText: 'Poll Question',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a question';
            }
            return null;
          },
        ),
        ..._pollOptionControllers.asMap().entries.map((entry) {
          int index = entry.key;
          TextEditingController controller = entry.value;
          return TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Option ${index + 1}',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter option ${index + 1}';
              }
              return null;
            },
          );
        }).toList(),
        if (_pollOptionControllers.length < 5)
          TextButton(
            onPressed: () {
              setState(() {
                _pollOptionControllers.add(TextEditingController());
              });
            },
            child: Text('Add Option'),
          ),
      ],
    );
  }

  Widget _buildThirtyNine(BuildContext context, state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.h, 5.v, 15.h, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          state is Post2Error
              ? Text(
                  state.message.contains('Server Failure')
                      ? AppLocalizations.of(context)!.translate('server_error')!
                      : state.message,
                  style: CustomTextStyles.titleMediumPoppinsBluegray100)
              : errorMessage.isNotEmpty
                  ? Text(errorMessage,
                      style: CustomTextStyles.titleMediumPoppinsBluegray100)
                  : Container(),
        ],
      ),
    );
  }

  Widget _buildButton2(BuildContext context, String buttonText, state) {
    return CustomElevatedButton(
      height: 40.v,
      width: 127.h,
      onPressed: () {
        String text = _textController.text;
        if (type == 'poll') {
          if (text.isEmpty) {
            setState(() {
              errorMessage = AppLocalizations.of(context)!.translate('text_post')!;
            });
            return;
          } else if (_questionController.text.isEmpty) {
            setState(() {
              errorMessage = AppLocalizations.of(context)!.translate('question_poll')!;
            });
            return;
          }
          List<String> pollOptions = _pollOptionControllers
              .map((controller) => controller.text)
              .where((option) => option.isNotEmpty)
              .toList();
          if (pollOptions.length < 2) {
            setState(() {
              errorMessage = AppLocalizations.of(context)!.translate('at_least_2_options')!;
            });
            return;
          }
          // Submit poll post
          context.read<Post2Cubit>().newPost(
                PostM(text: text, classOrSchoolId: widget.id, type: 'poll'),
                null,
                widget.schoolClass,
                _questionController.text,
                pollOptions,
              );
        } else {
          if (text.isEmpty) {
            setState(() {
              errorMessage =
                  AppLocalizations.of(context)!.translate('fill_text_fields')!;
            });
            print('Please enter some text.');
          } else {
            if (widget.id == null || widget.name == null) {
              setState(() {
                errorMessage = '';
              });
              if (images == null || images!.isEmpty) {
                context.read<Post2Cubit>().newPost(
                    PostM(
                        text: text,
                        classOrSchoolId: selectedClassId,
                        type: type),
                    null,
                    widget.schoolClass,
                    null,
                    null);
              } else {
                List<File> files =
                    images?.map((xFile) => File(xFile.path)).toList() ?? [];

                context.read<Post2Cubit>().newPost(
                    PostM(
                        text: text,
                        classOrSchoolId: selectedClassId,
                        type: type),
                    files,
                    widget.schoolClass,
                    null,
                    null);
              }
            } else {
              setState(() {
                errorMessage = '';
              });
              if (images == null || images!.isEmpty) {
                context.read<Post2Cubit>().newPost(
                    PostM(text: text, classOrSchoolId: widget.id, type: type),
                    null,
                    widget.schoolClass,
                    null,
                    null);
              } else {
                List<File> imagePaths = [];
                for (XFile file in images!) {
                  imagePaths.add(File(file.path));
                }
                context.read<Post2Cubit>().newPost(
                    PostM(text: text, classOrSchoolId: widget.id, type: type),
                    imagePaths,
                    widget.schoolClass,
                    null,
                    null);
              }
            }
          }
        }
      },
      buttonStyle: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.indigoA300),
      ),
      isLoading: state is Post2Loading,
      text: buttonText,
      margin: EdgeInsets.only(left: 2.h, right: 2.h),
      buttonTextStyle: CustomTextStyles.titleMediumPoppins12,
    );
  }
}
