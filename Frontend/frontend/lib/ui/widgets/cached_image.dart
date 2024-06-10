import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/cached_network_image_cubit/cached_network_image_cubit.dart';

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
