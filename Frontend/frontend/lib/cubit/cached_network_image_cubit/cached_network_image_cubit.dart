import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/data_provider/utils/http_headers.dart';
import 'package:frontend/service/auth_service.dart';
import 'package:frontend/service/storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

part 'cached_network_image_state.dart';

class CustomCachedNetworkImageCubit
    extends Cubit<CustomCachedNetworkImageState> {
  CustomCachedNetworkImageCubit() : super(CachedNetworkImageInitialState());

  Uint8List image = Uint8List.fromList([]);
  void loadNetworkImage(String url) async {
    try {
      emit(CachedNetworkImageLoading());

      String token = (await StorageService().getAccessToken())!;
      bool hasExpired = JwtDecoder.isExpired(token);
      if (hasExpired) {
        bool refreshTokenHasExpired =
            JwtDecoder.isExpired((await StorageService().getRefreshToken())!);
        if (!refreshTokenHasExpired) {
          await TokenManager().refreshAccessToken();
        }
      }
      Map<String, String> headers =
          HttpHeadersFactory.getDefaultRequestHeaderForImage(token);

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        image = response.bodyBytes;
        emit(CachedNetworkImageLoaded(image));
      } else {
        emit(CachedNetworkImageError(response.body.toString()));
      }
    } catch (e) {
      emit(CachedNetworkImageError(e.toString()));
    }
  }

  void clearImageBytes() {
    image = Uint8List.fromList([]);
  }
}
