import 'package:flutter/material.dart';

class AccusedSection extends StatelessWidget {
  final List<TextEditingController> accusedControllers;
  final VoidCallback onAddAccused;
  final Function(int) onRemoveAccused;

  const AccusedSection({
    super.key,
    required this.accusedControllers,
    required this.onAddAccused,
    required this.onRemoveAccused,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.blue.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.blue.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.blue.shade900.withOpacity(0.2),
                        Colors.blue.shade900.withOpacity(0.1),
                      ]
                    : [
                        Colors.blue.withOpacity(0.1),
                        Colors.blue.withOpacity(0.05),
                      ],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? theme.cardColor : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.2)
                                : Colors.blue.withOpacity(0.2),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: isDark ? Colors.blue.shade300 : Colors.blue,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Accused Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onAddAccused,
                  icon: Icon(
                    Icons.add,
                    color: isDark ? Colors.blue.shade300 : Colors.blue,
                    size: 16,
                  ),
                  label: Text(
                    'Add Another',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.blue.shade300 : Colors.blue,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: isDark
                        ? Colors.blue.shade900.withOpacity(0.2)
                        : Colors.blue.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: accusedControllers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: accusedControllers[index],
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Accused ${index + 1}',
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.grey.shade300
                                : Colors.grey.shade700,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color:
                                  isDark ? Colors.blue.shade300 : Colors.blue,
                              width: 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isDark ? Colors.red.shade300 : Colors.red,
                            ),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? Colors.grey.shade900
                              : Colors.grey.shade50,
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.blue.shade900.withOpacity(0.2)
                                  : Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color:
                                  isDark ? Colors.blue.shade300 : Colors.blue,
                              size: 16,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter accused name' : null,
                      ),
                    ),
                    if (accusedControllers.length > 1)
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: isDark ? Colors.red.shade300 : Colors.red,
                          size: 20,
                        ),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        onPressed: () => onRemoveAccused(index),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
