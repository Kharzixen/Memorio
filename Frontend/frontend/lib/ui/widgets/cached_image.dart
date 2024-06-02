import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/cubit/cached_network_image_cubit/cached_network_image_cubit.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:widget_zoom/widget_zoom.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String url;
  const CustomCachedNetworkImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    print("built");
    return BlocProvider(
      create: (context) =>
          CustomCachedNetworkImageCubit()..loadNetworkImage(url),
      child: Builder(builder: (context) {
        return BlocBuilder<CustomCachedNetworkImageCubit,
            CustomCachedNetworkImageState>(
          builder: (context, state) {
            if (state is CachedNetworkImageLoaded) {
              return Image.memory(state.imageBytes);
            }

            if (state is CachedNetworkImageLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      }),
    );
  }
}
