import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_mama/core/extensions/padding_ex.dart';
import 'package:new_mama/core/extensions/sized_box_ex.dart';
import 'package:new_mama/core/extensions/theme_ex.dart';
import 'package:new_mama/core/helper/app_toast.dart';
import 'package:new_mama/core/extensions/localization_ex.dart';
import 'package:new_mama/core/helpers/child_image_helper.dart';
import 'package:new_mama/core/localization/translation_keys.dart';
import 'package:new_mama/core/widgets/custom_loading_indicator.dart';
import 'package:new_mama/core/widgets/full_screen_image_gallery.dart';
import 'package:new_mama/feature/children/domain/entities/child.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_cubit.dart';
import 'package:new_mama/feature/children/presentation/cubit/children_state.dart';
import 'package:new_mama/feature/children/presentation/widgets/detail_components/child_detail_app_bar.dart';
import 'package:new_mama/feature/children/presentation/widgets/detail_components/child_info_grid.dart';
import 'package:new_mama/feature/children/presentation/widgets/children_ui_components.dart';
import 'package:new_mama/feature/children/presentation/widgets/premium_child_components.dart';
import 'package:new_mama/core/widgets/delete_confirmation_dialog.dart';

class ChildDetailView extends StatefulWidget {
  final Child child;
  const ChildDetailView({super.key, required this.child});

  @override
  State<ChildDetailView> createState() => _ChildDetailViewState();
}

class _ChildDetailViewState extends State<ChildDetailView> {
  final picker = ImagePicker();

  bool _isPickingImage = false;

  Future<void> _pickAndUploadPhoto(int childId) async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);
    try {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null && mounted) {
        context.read<ChildrenCubit>().uploadPhoto(childId, File(picked.path));
      }
    } catch (_) {
      // Ignore concurrent active errors quietly
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  Future<bool> _showDeleteAction(Child child, bool isPhoto) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => DeleteConfirmationDialog(
            title: isPhoto
                ? context.trContext(TK.childrenRemovePhoto)
                : context.trContext(TK.childrenRemoveBaby),
            content: isPhoto
                ? context.trContext(TK.childrenRemoveCurrentPhoto)
                : context.trContext(
                    TK.childrenSureRemoveBaby,
                    namedArgs: {'name': child.fullName},
                  ),
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChildrenCubit, ChildrenState>(
      listener: (context, state) {
        if (state is ChildActionSuccess) {
          AppToast.success(context, message: context.trContext(state.message));
          context.read<ChildrenCubit>().restoreLoaded();
          if (!state.children.any((c) => c.childId == widget.child.childId)) {
            context.pop();
          }
        } else if (state is ChildrenError) {
          AppToast.error(context, message: context.trContext(state.message));
          context.read<ChildrenCubit>().restoreLoaded();
        }
      },
      builder: (context, state) {
        final isLoading = state is ChildrenActionLoading;
        List<Child> allChildren = [];
        if (state is ChildrenLoaded) allChildren = state.children;
        if (state is ChildActionSuccess) allChildren = state.children;
        if (state is ChildrenActionLoading) allChildren = state.children;

        final currentChild = allChildren.cast<Child>().firstWhere(
          (c) => c.childId == widget.child.childId,
          orElse: () => widget.child,
        );

        final isBoy = currentChild.isBoy;
        final bgGradient = isBoy
            ? [
                context.ext.colors.backgroundBlueDarker,
                context.ext.colors.backgroundBlue,
              ]
            : [
                context.ext.colors.primaryTint,
                context.ext.colors.primaryExtraLight,
              ];

        final elementGradient = isBoy
            ? [context.ext.colors.primaryDark, context.ext.colors.primary]
            : [
                context.ext.colors.primaryAccent,
                context.ext.colors.primaryLighter,
              ];

        return Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              ChildBackgroundDecoration(colors: bgGradient),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  ChildDetailAppBar(
                    child: currentChild,
                    onImageTap: () {
                      if (currentChild.photoUrl != null) {
                        final url = ChildImageHelper.getChildImageUrl(
                          currentChild.photoUrl,
                        );
                        if (url.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenImageGallery(
                                images: [url],
                                showDownloadButton: true,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    onActionTap: () async {
                      if (currentChild.photoUrl != null) {
                        final cubit = context.read<ChildrenCubit>();
                        final confirm = await _showDeleteAction(currentChild, true);
                        if (confirm && mounted) {
                          cubit.deletePhoto(currentChild.childId);
                        }
                      } else {
                        _pickAndUploadPhoto(currentChild.childId);
                      }
                    },
                    onDelete: () async {
                      final cubit = context.read<ChildrenCubit>();
                      final confirm = await _showDeleteAction(
                        currentChild,
                        false,
                      );
                      if (confirm && mounted) {
                        cubit.deleteChild(
                          currentChild.childId,
                        );
                      }
                    },
                  ),
                
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: 24.hPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.trContext(TK.childrenChildInfo),
                            style: context.text.titleLarge!.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          20.height,
                          ChildInfoGrid(child: currentChild),
                          40.height,
                          if (currentChild.photoUrl == null)
                            PremiumActionButton(
                              icon: Icons.photo_camera_back_rounded,
                              label: context.trContext(TK.childrenAddProfilePhoto),
                              gradient: elementGradient,
                              onTap: () =>
                                  _pickAndUploadPhoto(currentChild.childId),
                            ),
                          80.height,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (isLoading)
                Container(
                  color: context.colors.onSurface.withAlpha(50),
                  child: Center(
                    child: CustomLoadingIndicator(
                      color: context.colors.primary,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
