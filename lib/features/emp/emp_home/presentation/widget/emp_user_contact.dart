import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/features/emp/emp_auth/domain/entities/emp_user_profile_entity.dart';

Future<ContactEntity?> showSelectContactSheet(
  BuildContext context, {
  required List<ContactEntity> contacts,
}) async {
  return await showModalBottomSheet<ContactEntity>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) {
          ContactEntity? selectedContact;

          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    // --- Handle bar ---
                    Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    // --- Title and close button ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        const Text(
                          "Select a Contact",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: CupertinoColors.label,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            CupertinoIcons.xmark,
                            color: Colors.grey,
                          ),
                          splashRadius: 20,
                        ),
                      ],
                    ),

                    const Text(
                      "Choose one of your saved contacts to continue.",
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // --- Contacts List ---
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          final isSelected = selectedContact == contact;

                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              // HapticFeedback.lightImpact();
                              setState(() => selectedContact = contact);
                            },
                            child: Container(
                              // duration: const Duration(milliseconds: 200),
                              // curve: Curves.easeIn,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppPalette.empPrimaryColor.withOpacity(
                                        0.05,
                                      )
                                    : CupertinoColors.systemBackground,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppPalette.empPrimaryColor.withOpacity(
                                          0.35,
                                        )
                                      : CupertinoColors.separator.withOpacity(
                                          0.4,
                                        ),
                                  width: isSelected ? 1.5 : 1,
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: AppPalette.empPrimaryColor
                                          .withOpacity(0.12),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppPalette.empPrimaryColor
                                                        .withOpacity(0.15)
                                                  : CupertinoColors.systemGrey5,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              CupertinoIcons.person_fill,
                                              size: 18,
                                              color: isSelected
                                                  ? AppPalette.empPrimaryColor
                                                  : CupertinoColors.systemGrey,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              contact.name ?? "Unnamed Contact",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: CupertinoColors.label,
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      // --- Contact Methods grouped in light box ---
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: CupertinoColors.systemGrey6,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (contact.telegram != null)
                                              _buildSmartRow(
                                                icon: Icons.send_rounded,
                                                value: contact.telegram!,
                                                platformColor: const Color(
                                                  0xFF229ED9,
                                                ),
                                              ),
                                            if (contact.whatsapp != null)
                                              _buildSmartRow(
                                                icon: Icons.phone_rounded,
                                                value: contact.whatsapp!,
                                                platformColor: const Color(
                                                  0xFF25D366,
                                                ),
                                              ),
                                            if (contact.vk != null)
                                              _buildSmartRow(
                                                icon: Icons.language_rounded,
                                                value: contact.vk!,
                                                platformColor: const Color(
                                                  0xFF4680C2,
                                                ),
                                              ),
                                            if (contact.email != null)
                                              _buildSmartRow(
                                                icon: CupertinoIcons
                                                    .envelope_fill,
                                                value: contact.email!,
                                                platformColor:
                                                    CupertinoColors.systemBlue,
                                              ),
                                            if (contact.phone != null)
                                              _buildSmartRow(
                                                icon: CupertinoIcons.phone_fill,
                                                value: contact.phone!,
                                                platformColor:
                                                    CupertinoColors.systemGrey,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // --- Checkmark indicator for selected contact ---
                                  if (isSelected)
                                    const Positioned(
                                      top: 6,
                                      right: 6,
                                      child: Icon(
                                        CupertinoIcons
                                            .checkmark_alt_circle_fill,
                                        color: AppPalette.empPrimaryColor,
                                        size: 24,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // --- Apply button ---
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: AnimatedOpacity(
                        opacity: selectedContact == null ? 0.6 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: selectedContact == null
                              ? null
                              : () => Navigator.pop(context, selectedContact),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                            backgroundColor: AppPalette.empPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            selectedContact == null
                                ? "Select Contact"
                                : "Apply",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

// ---- Helper UI Row Builder ----
Widget _buildSmartRow({
  required IconData icon,
  required String value,
  required Color platformColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: platformColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: platformColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.label.withOpacity(0.95),
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    ),
  );
}
