import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garrib_app/core/util/style.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isPhone;

  const CustomInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isPhone = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) {
        final text = controller.text.trim();

        if (isPhone) {
          if (text.isEmpty) {
            return 'Please enter phone number';
          }

          if (text.length != 10) {
            return 'Please enter a valid phone number';
          }

          return null;
        }

        return validator?.call(text);
      },

      builder: (state) {
        final hasError = state.hasError;
        final currentLength = controller.text.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: hasError
                    ? Border.all(
                        color: Colors.red,
                        width: 1,
                      )
                    : Border.all(
                        color: const Color.fromARGB(
                          255,
                          227,
                          227,
                          227,
                        ),
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: isPhone
                  ? Row(
                      children: [
                        // Egypt Flag
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Image.asset(
                            'assets/images/eg.png',
                            width: 19,
                            height: 13,
                          ),
                        ),
                        

                        const SizedBox(width: 8),

                        // Country Code
                        Text(
                          '+20',
                          style: AppStyles.bodySmall.copyWith(
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Divider
                        Container(
                          height: 25,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),

                        const SizedBox(width: 8),

                        // Phone Number
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.phone,

                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],

                            style: AppStyles.bodySmall.copyWith(
                              fontSize: 13,
                            ),

                            onChanged: (value) {
                              state.didChange(value);
                            },

                            decoration: InputDecoration(
                              hintText: hintText,
                              hintStyle: AppStyles.bodySmall.copyWith(
                                color: Colors.grey.shade400,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : TextFormField(
                      controller: controller,
                      keyboardType: keyboardType,

                      style: AppStyles.bodySmall.copyWith(
                        fontSize: 13,
                      ),

                      onChanged: (value) {
                        state.didChange(value);
                      },

                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: AppStyles.bodySmall.copyWith(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
            ),

            // Validation Error
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 4,
                  bottom: 4,
                ),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                  ),
                ),
              )

            // Phone Counter
            else if (isPhone)
              Padding(
                padding: const EdgeInsets.only(
                  right: 12,
                  top: 4,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$currentLength/10',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              )

            else
              const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}