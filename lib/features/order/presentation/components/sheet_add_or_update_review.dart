import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../service_locator.dart';
import '../../../home/domain/repository/product_repository.dart';
import '../../domain/dto/add_review_dto.dart';

class SheetAddOrUpdateReview extends StatefulWidget {
  const SheetAddOrUpdateReview({
    super.key,
    required this.orderItemId,
    required this.onChange,
    required this.initParam,
    this.isAdding = true,
  });

  final String orderItemId;

  /// isAdding is true => add review sheet, [ReviewParam] return on onChange
  ///
  /// isAdding is false => view only sheet
  final bool isAdding;
  final ReviewParam initParam;
  final void Function(ReviewParam value)? onChange;

  @override
  State<SheetAddOrUpdateReview> createState() => _SheetAddOrUpdateReviewState();
}

class _SheetAddOrUpdateReviewState extends State<SheetAddOrUpdateReview> {
  late ReviewParam _param;

  @override
  void initState() {
    super.initState();
    _param = widget.initParam;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //# Rating
        Align(
          alignment: Alignment.center,
          child: RatingBar.builder(
            initialRating: 5,
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              if (widget.isAdding) {
                setState(() {
                  _param.rating = rating.toInt();
                  widget.onChange!(_param);
                });
              }
            },
          ),
        ),

        // Content (String)
        widget.isAdding
            ? TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Đánh giá của bạn...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onChanged: (String value) {
                  setState(() {
                    _param.content = value;
                    widget.onChange!(_param);
                  });
                },
              )
            : Text(_param.content),

        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: _param.imagePath != null
                    ? GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return PhotoViewPage(
                                imageUrl: _param.imagePath!,
                                isNetworkImage: widget.isAdding ? false : true,
                              );
                            },
                          ),
                        ),
                        child: widget.isAdding
                            ? Image.file(
                                File(_param.imagePath!),
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                _param.imagePath!,
                                fit: BoxFit.cover,
                              ),
                      )
                    : IconButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                          shape: MaterialStateProperty.all(const RoundedRectangleBorder()),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          ImagePicker().pickImage(source: ImageSource.gallery).then((pickedImage) {
                            if (pickedImage == null) return;

                            setState(() {
                              _param.imagePath = pickedImage.path;
                              _param.hasImage = true;
                              widget.onChange!(_param);
                            });
                          });
                        },
                        icon: const Icon(Icons.add_a_photo),
                      ),
              ),
              if (_param.hasImage && widget.isAdding)...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _param.imagePath = null;
                      _param.hasImage = false;
                      widget.onChange!(_param);
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Xóa ảnh'),
                ),
              ]
            ],
          ),
        ),

        if (!widget.isAdding) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () async{
              //> delete review
              final result = await sl<ProductRepository>().deleteReview(_param.reviewId!);
              result.fold(
                (error) => Fluttertoast.showToast(msg: error.message ?? error.toString()),
                (ok) {
                  Fluttertoast.showToast(msg: 'Xóa đánh giá thành công');
                  Navigator.of(context).pop();
                },
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Xóa đánh giá'),
          ),
        ],
        // ElevatedButton(
        //   onPressed: () async {
        //     final result = await sl<ProductRepository>().addReview(param);

        //     result.fold(
        //       (error) => Fluttertoast.showToast(msg: error.message ?? error.toString()),
        //       (ok) {
        //         Fluttertoast.showToast(msg: 'Đánh giá thành công');
        //         Navigator.of(context).pop();
        //       },
        //     );
        //   },
        //   child: const Text('Submit'),
        // ),
      ],
    );
  }
}
