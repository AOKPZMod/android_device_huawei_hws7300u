# Bootloader, radio
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true
TARGET_BOOTLOADER_BOARD_NAME := Mediapad

# Platform
TARGET_BOARD_PLATFORM := msm8660
TARGET_BOARD_PLATFORM_GPU := qcom-adreno200

# Architecture
TARGET_ARCH := arm
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_CPU_VARIANT := scorpion
TARGET_ARCH_VARIANT := armv7-a-neon
ARCH_ARM_HAVE_TLS_REGISTER := true
ARCH_ARM_HAVE_NEON := true
ARCH_ARM_HAVE_ARMV7A := true
TARGET_USE_QCOM_BIONIC_OPTIMIZATION := true
BOARD_USES_LEGACY_MMAP := true

# Flags
TARGET_GLOBAL_CFLAGS += -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mfpu=neon -mfloat-abi=softfp

# Wifi
BOARD_WPA_SUPPLICANT_DRIVER := WEXT
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wext
WPA_SUPPLICANT_VERSION      := VER_0_8_X
WIFI_DRIVER_MODULE_PATH     := "/system/lib/modules/dhd.ko"
WIFI_DRIVER_MODULE_NAME     := "dhd"
BOARD_WLAN_DEVICE           := bcm4329
WIFI_DRIVER_FW_PATH_STA     := "/etc/wifi/rtecdc-bcm4329.bin"
WIFI_DRIVER_FW_PATH_AP      := "/etc/wifi/rtecdc-apsta-bcm4329.bin"
WIFI_DRIVER_MODULE_ARG      := "firmware_path=/system/etc/wifi/rtecdc-bcm4329.bin nvram_path=/system/etc/wifi/nvram-bcm4329.txt"
BOARD_HAVE_HUAWEI_WIFI := true
TARGET_NO_WIFI_HAL := true
TARGET_NO_NETD_AF_INET := true

# Bluetooth                                           `
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/huawei/hws7300u/bluetooth/include
BOARD_BLUEDROID_VENDOR_CONF := device/huawei/hws7300u/bluetooth/vnd_hws7300u.txt


# QCOM hardware
COMMON_GLOBAL_CFLAGS += -DQCOM_HARDWARE -DQCOM_NO_SECURE_PLAYBACK
#BOARD_USES_LEGACY_QCOM := true
BOARD_USES_QCOM_HARDWARE := true
#TARGET_USES_QCOM_BSP := true


# GPS
TARGET_GPS_HAL_PATH := device/huawei/hws7300u/gps
BOARD_VENDOR_QCOM_GPS_LOC_API_AMSS_VERSION := 50000
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := default


# Media
TARGET_NO_ADAPTIVE_PLAYBACK := true

# Graphics
USE_OPENGL_RENDERER := true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_ION := true
BOARD_EGL_CFG := device/huawei/hws7300u/prebuilt/lib/egl/egl.cfg
BOARD_EGL_NEEDS_LEGACY_FB := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_QCOM_DISPLAY_VARIANT := caf
TARGET_QCOM_MEDIA_VARIANT := caf
TARGET_DISPLAY_USE_RETIRE_FENCE := true
TARGET_DISPLAY_INSECURE_MM_HEAP := true
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

# Audio
COMMON_GLOBAL_CFLAGS += -DQCOM_ACDB_ENABLED -DQCOM_VOIP_ENABLED

BOARD_USE_QCOM_LPA := true
TARGET_QCOM_AUDIO_VARIANT := caf
BOARD_USES_LEGACY_ALSA_AUDIO := true
BOARD_QCOM_TUNNEL_LPA_ENABLED := true
#BOARD_QCOM_VOIP_LEGACY_ENABLED := true
BOARD_QCOM_VOIP_ENABLED := true

# Webkit
ENABLE_WEBGL := true
TARGET_FORCE_CPU_UPLOAD := true

#art hacks
ART_USE_CUSTOM_NMSC := 32
ART_DONT_CHECK_GAP := true

# Camera
COMMON_GLOBAL_CFLAGS += -DICS_CAMERA_BLOB -DDISABLE_HW_ID_MATCH_CHECK  -DNEEDS_VECTORIMPL_SYMBOLS
BOARD_NEEDS_MEMORYHEAPPMEM := true
TARGET_PROVIDES_CAMERA_HAL := true
TARGET_DISABLE_ARM_PIE := true
TARGET_NEEDS_NON_PIE_SUPPORT := true
BOARD_USES_QCOM_LEGACY_CAM_PARAMS := true
USE_CAMERA_STUB := false

#kernel
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.hardware=hws7300u androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x40300000
BOARD_KERNEL_PAGESIZE := 2048
TARGET_KERNEL_CUSTOM_TOOLCHAIN := arm-eabi-4.7
TARGET_KERNEL_SOURCE := kernel/huawei/hws7300u
TARGET_KERNEL_CONFIG := mediapad_defconfig

# USB
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/class/android_usb/android0/f_mass_storage/lun%d/file

# Radio
BOARD_RIL_NO_CELLINFOLIST := true
BOARD_PROVIDES_LIBRIL := true

# Filesystem
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 12582912 # 12M
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216 # 16M
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 395313152 # 377M
BOARD_USERDATAIMAGE_PARTITION_SIZE := 5368709120 # 5G
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_HAS_NO_SELECT_BUTTON := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_RECOVERY_FSTAB := device/huawei/hws7300u/root/fstab.hws7300u
RECOVERY_FSTAB_VERSION := 2

# CWM specific
BOARD_CUSTOM_GRAPHICS:= ../../../device/huawei/hws7300u/recovery/graphics.c

# Reduce font size
EXTENDED_FONT_FOOTPRINT := false
SMALLER_FONT_FOOTPRINT := true
MINIMAL_FONT_FOOTPRINT := true

# Remove packages
REMOVE_PRODUCT_PACKAGES += Gallery2 Exchange2 LiveWallpapers Galaxy4 Camera2
REMOVE_PRODUCT_PACKAGES += Email

# SELinux
BOARD_SEPOLICY_DIRS += device/huawei/hws7300u/sepolicy

BOARD_SEPOLICY_UNION += \
    file_contexts \
    file.te
