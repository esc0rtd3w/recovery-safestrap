LOCAL_PATH := $(call my-dir)

RELINK := $(LOCAL_PATH)/relink.sh

#dummy file to trigger required modules
include $(CLEAR_VARS)
LOCAL_MODULE := teamwin
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/sbin

# Manage list 
RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/dump_image
RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/flash_image
RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/erase_image
RELINK_SOURCE_FILES += $(TARGET_OUT_OPTIONAL_EXECUTABLES)/busybox
RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/pigz
RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/dosfsck
RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/dosfslabel
RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/mkdosfs
RELINK_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/e2fsck
RELINK_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/mke2fs
RELINK_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/tune2fs
RELINK_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/linker
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libc.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libcutils.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libdl.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libext2_blkid.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libext2_com_err.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libext2_e2p.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libext2fs.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libext2_profile.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libext2_uuid.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/liblog.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libm.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libstdc++.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libz.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libminuitwrp.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libminadbd.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libminzip.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libmtdutils.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libtar.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libblkid.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libmmcutils.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libbmlutils.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libflashutils.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libstlport.so
#RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libmincrypt.so
ifeq ($(TARGET_USERIMAGES_USE_EXT4), true)
    RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libext4_utils.so
else
ifeq ($(HAVE_SELINUX), true)
    RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libext4_utils.so
endif
endif
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libaosprecovery.so
RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libjpeg.so
ifeq ($(TWHAVE_SELINUX), true)
    RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libselinux.so
    ifneq ($(TARGET_USERIMAGES_USE_EXT4), true)
        RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libext4_utils.so
    endif
endif
ifeq ($(BUILD_ID), GINGERBREAD)
    TW_NO_EXFAT := true
endif
ifneq ($(TW_NO_EXFAT), true)
    RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/exfat-fuse
    RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/mkexfatfs
    RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libexfat.so
endif
ifeq ($(TW_INCLUDE_BLOBPACK), true)
    RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/blobpack
endif
ifeq ($(TW_INCLUDE_INJECTTWRP), true)
    RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/injecttwrp
endif
ifeq ($(TW_INCLUDE_DUMLOCK), true)
    RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/htcdumlock
endif
ifeq ($(TW_INCLUDE_CRYPTO), true)
    RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libcryptfsics.so
    RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libcrypto.so
endif
ifeq ($(TW_INCLUDE_JB_CRYPTO), true)
    RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libcryptfsjb.so
    RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libcrypto.so
endif
ifeq ($(TARGET_USERIMAGES_USE_EXT4), true)
    RELINK_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/make_ext4fs
endif
ifneq ($(wildcard system/core/libsparse/Android.mk),)
    RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libsparse.so
endif
ifneq ($(TW_EXCLUDE_ENCRYPTED_BACKUPS), true)
    RELINK_SOURCE_FILES += $(TARGET_RECOVERY_ROOT_OUT)/sbin/openaes
    RELINK_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libopenaes.so
endif
ifeq ($(TARGET_USERIMAGES_USE_F2FS), true)
    RELINK_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/mkfs.f2fs
    RELINK_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/fsck.f2fs
    RELINK_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/fibmap.f2fs
endif

TWRP_AUTOGEN := $(intermediates)/teamwin

GEN := $(intermediates)/teamwin
$(GEN): $(RELINK)
$(GEN): $(RELINK_SOURCE_FILES) $(call intermediates-dir-for,EXECUTABLES,recovery)/recovery
	$(RELINK) $(TARGET_RECOVERY_ROOT_OUT)/sbin $(RELINK_SOURCE_FILES)
	$(RELINK) $(call intermediates-dir-for,EXECUTABLES,recovery) $(call intermediates-dir-for,EXECUTABLES,recovery)/recovery

LOCAL_GENERATED_SOURCES := $(GEN)
LOCAL_SRC_FILES := teamwin $(GEN)
include $(BUILD_PREBUILT)

#fix_permissions
include $(CLEAR_VARS)
LOCAL_MODULE := fix_permissions.sh
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/sbin
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

#mke2fs.conf
include $(CLEAR_VARS)
LOCAL_MODULE := mke2fs.conf
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/etc
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

#ifeq ($(BOARD_HAS_NO_REAL_SDCARD),)
	#parted
	include $(CLEAR_VARS)
	LOCAL_MODULE := parted
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/sbin
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)
#endif

# copy license file for OpenAES
ifneq ($(TW_EXCLUDE_ENCRYPTED_BACKUPS), true)
	include $(CLEAR_VARS)
	LOCAL_MODULE := ../openaes/LICENSE
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/license/openaes
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)
endif

ifeq ($(TW_INCLUDE_DUMLOCK), true)
	#htcdumlock for /system for dumlock
	include $(CLEAR_VARS)
	LOCAL_MODULE := htcdumlocksys
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/res/htcd
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)

	#flash_image for /system for dumlock
	include $(CLEAR_VARS)
	LOCAL_MODULE := flash_imagesys
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/res/htcd
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)

	#dump_image for /system for dumlock
	include $(CLEAR_VARS)
	LOCAL_MODULE := dump_imagesys
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/res/htcd
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)

	#libbmlutils for /system for dumlock
	include $(CLEAR_VARS)
	LOCAL_MODULE := libbmlutils.so
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/res/htcd
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)

	#libflashutils for /system for dumlock
	include $(CLEAR_VARS)
	LOCAL_MODULE := libflashutils.so
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/res/htcd
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)

	#libmmcutils for /system for dumlock
	include $(CLEAR_VARS)
	LOCAL_MODULE := libmmcutils.so
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/res/htcd
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)

	#libmtdutils for /system for dumlock
	include $(CLEAR_VARS)
	LOCAL_MODULE := libmtdutils.so
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/res/htcd
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)

	#HTCDumlock.apk
	include $(CLEAR_VARS)
	LOCAL_MODULE := HTCDumlock.apk
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/res/htcd
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)
endif

ifneq ($(TW_EXCLUDE_SUPERSU), true)
	#su binary
	include $(CLEAR_VARS)
	LOCAL_MODULE := su
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/supersu
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)

       #install-recovery.sh
	include $(CLEAR_VARS)
	LOCAL_MODULE := install-recovery.sh
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/supersu
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)

       #99SuperSUDaemon
	include $(CLEAR_VARS)
	LOCAL_MODULE := 99SuperSUDaemon
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/supersu
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)

	#SuperSU special installer APK
	include $(CLEAR_VARS)
	LOCAL_MODULE := Superuser.apk
	LOCAL_MODULE_TAGS := eng
	LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
	LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/supersu
	LOCAL_SRC_FILES := $(LOCAL_MODULE)
	include $(BUILD_PREBUILT)
endif
