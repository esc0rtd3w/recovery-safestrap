LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ifndef RECOVERY_INCLUDE_DIR
    RECOVERY_INCLUDE_DIR := bootable/recovery/minuitwrp/include
endif

LOCAL_SRC_FILES := \
    graphics.cpp \
    graphics_fbdev.cpp \
    resources.cpp \
    graphics_overlay.cpp \
    graphics_utils.cpp \
    events.cpp

ifneq ($(TW_BOARD_CUSTOM_GRAPHICS),)
    $(warning ****************************************************************************)
    $(warning * TW_BOARD_CUSTOM_GRAPHICS support has been deprecated in TWRP.            *)
    $(warning ****************************************************************************)
    $(error stopping)
endif

ifeq ($(TW_TARGET_USES_QCOM_BSP), true)
  LOCAL_CFLAGS += -DMSM_BSP
endif

ifeq ($(TW_NEW_ION_HEAP), true)
  LOCAL_CFLAGS += -DNEW_ION_HEAP
endif

ifneq ($(wildcard external/libdrm/Android.mk),)
  LOCAL_CFLAGS += -DHAS_DRM
  LOCAL_SRC_FILES += graphics_drm.cpp
  LOCAL_WHOLE_STATIC_LIBRARIES += libdrm
endif

LOCAL_C_INCLUDES += \
    external/libpng \
    external/zlib \
    system/core/include \
    external/freetype/include \
    external/libcxx/include \
    $(RECOVERY_INCLUDE_DIR)

ifneq ($(TW_INCLUDE_JPEG),)
    LOCAL_C_INCLUDES += \
        external/jpeg
    LOCAL_CFLAGS += -DTW_INCLUDE_JPEG
endif

ifeq ($(RECOVERY_TOUCHSCREEN_SWAP_XY), true)
LOCAL_CFLAGS += -DRECOVERY_TOUCHSCREEN_SWAP_XY
endif

ifeq ($(RECOVERY_TOUCHSCREEN_FLIP_X), true)
LOCAL_CFLAGS += -DRECOVERY_TOUCHSCREEN_FLIP_X
endif

ifeq ($(RECOVERY_TOUCHSCREEN_FLIP_Y), true)
LOCAL_CFLAGS += -DRECOVERY_TOUCHSCREEN_FLIP_Y
endif

ifeq ($(RECOVERY_GRAPHICS_FORCE_USE_LINELENGTH), true)
LOCAL_CFLAGS += -DRECOVERY_GRAPHICS_FORCE_USE_LINELENGTH
endif

ifeq ($(TW_DISABLE_DOUBLE_BUFFERING), true)
LOCAL_CFLAGS += -DTW_DISABLE_DOUBLE_BUFFERING
endif

ifeq ($(TW_IGNORE_VIRTUAL_KEYS), true)
LOCAL_CFLAGS += -DTW_IGNORE_VIRTUAL_KEYS
endif

ifeq ($(RECOVERY_GRAPHICS_DONT_DOUBLE_BUFFER), true)
LOCAL_CFLAGS += -DRECOVERY_GRAPHICS_DONT_DOUBLE_BUFFER
endif

ifeq ($(RECOVERY_SKIP_SCREENINFO_PUT), true)
  LOCAL_CFLAGS += -DSKIP_SCREENINFO_PUT
endif

ifeq ($(RECOVERY_GRAPHICS_DONT_SET_ACTIVATE), true)
LOCAL_CFLAGS += -DRECOVERY_GRAPHICS_DONT_SET_ACTIVATE
endif

#Remove the # from the line below to enable event logging
#TWRP_EVENT_LOGGING := true
ifeq ($(TWRP_EVENT_LOGGING), true)
LOCAL_CFLAGS += -D_EVENT_LOGGING
endif

ifeq ($(subst ",,$(TARGET_RECOVERY_FORCE_PIXEL_FORMAT)),RGBA_8888)
  $(warning ****************************************************************************)
  $(warning * TARGET_RECOVERY_FORCE_PIXEL_FORMAT := RGBA_8888 not implemented yet      *)
  $(warning ****************************************************************************)
  $(error stopping)
  LOCAL_CFLAGS += -DRECOVERY_RGBA
endif
ifeq ($(subst ",,$(TARGET_RECOVERY_FORCE_PIXEL_FORMAT)),RGBX_8888)
  $(warning ****************************************************************************)
  $(warning * TARGET_RECOVERY_FORCE_PIXEL_FORMAT := RGBX_8888 not implemented yet      *)
  $(warning ****************************************************************************)
  $(error stopping)
  LOCAL_CFLAGS += -DRECOVERY_RGBX
endif
ifeq ($(subst ",,$(TARGET_RECOVERY_FORCE_PIXEL_FORMAT)),BGRA_8888)
  $(warning ****************************************************************************)
  $(warning * TARGET_RECOVERY_FORCE_PIXEL_FORMAT := BGRA_8888 not implemented yet      *)
  $(warning ****************************************************************************)
  $(error stopping)
  LOCAL_CFLAGS += -DRECOVERY_BGRA
endif
ifeq ($(subst ",,$(TARGET_RECOVERY_FORCE_PIXEL_FORMAT)),RGB_565)
  LOCAL_CFLAGS += -DRECOVERY_FORCE_RGB_565
endif

# This used to compare against values in double-quotes (which are just
# ordinary characters in this context).  Strip double-quotes from the
# value so that either will work.

ifeq ($(subst ",,$(TARGET_RECOVERY_PIXEL_FORMAT)),ABGR_8888)
  LOCAL_CFLAGS += -DRECOVERY_ABGR
endif
ifeq ($(subst ",,$(TARGET_RECOVERY_PIXEL_FORMAT)),RGBX_8888)
  LOCAL_CFLAGS += -DRECOVERY_RGBX
endif
ifeq ($(subst ",,$(TARGET_RECOVERY_PIXEL_FORMAT)),BGRA_8888)
  LOCAL_CFLAGS += -DRECOVERY_BGRA
endif

ifneq ($(TARGET_RECOVERY_OVERSCAN_PERCENT),)
  LOCAL_CFLAGS += -DOVERSCAN_PERCENT=$(TARGET_RECOVERY_OVERSCAN_PERCENT)
else
  LOCAL_CFLAGS += -DOVERSCAN_PERCENT=0
endif
ifeq ($(TW_SCREEN_BLANK_ON_BOOT), true)
    LOCAL_CFLAGS += -DTW_SCREEN_BLANK_ON_BOOT
endif

ifeq ($(BOARD_HAS_FLIPPED_SCREEN), true)
LOCAL_CFLAGS += -DBOARD_HAS_FLIPPED_SCREEN
endif

ifeq ($(TW_IGNORE_MAJOR_AXIS_0), true)
LOCAL_CFLAGS += -DTW_IGNORE_MAJOR_AXIS_0
endif

ifeq ($(TW_IGNORE_MT_POSITION_0), true)
LOCAL_CFLAGS += -DTW_IGNORE_MT_POSITION_0
endif

ifeq ($(TW_IGNORE_ABS_MT_TRACKING_ID), true)
LOCAL_CFLAGS += -DTW_IGNORE_ABS_MT_TRACKING_ID
endif

ifneq ($(TW_INPUT_BLACKLIST),)
  LOCAL_CFLAGS += -DTW_INPUT_BLACKLIST=$(TW_INPUT_BLACKLIST)
endif

ifneq ($(TW_WHITELIST_INPUT),)
  LOCAL_CFLAGS += -DWHITELIST_INPUT=$(TW_WHITELIST_INPUT)
endif

ifeq ($(TW_DISABLE_TTF), true)
    $(warning ****************************************************************************)
    $(warning * TW_DISABLE_TTF support has been deprecated in TWRP.                      *)
    $(warning ****************************************************************************)
    $(error stopping)
endif

LOCAL_CLANG := true

LOCAL_SHARED_LIBRARIES += libft2 libz libc libcutils libpng libutils
ifneq ($(TW_INCLUDE_JPEG),)
    LOCAL_SHARED_LIBRARIES += libjpeg
endif

LOCAL_STATIC_LIBRARIES += liblog libpixelflinger_static
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE := libminui_ss

include $(BUILD_STATIC_LIBRARY)
