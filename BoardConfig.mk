TARGET_SPECIFIC_HEADER_PATH := device/huawei/hws7300u/include

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
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_SMP := true
ARCH_ARM_HAVE_TLS_REGISTER := true
ARCH_ARM_HAVE_NEON := true
ARCH_ARM_HAVE_ARMV7A := true


# Flags
TARGET_GLOBAL_CFLAGS += -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mfpu=neon -mfloat-abi=softfp
COMMON_GLOBAL_CFLAGS += -DQCOM_HARDWARE

# Scorpion optimizations
TARGET_USE_SCORPION_BIONIC_OPTIMIZATION := true
TARGET_USE_SCORPION_PLD_SET := true
TARGET_SCORPION_BIONIC_PLDOFFS := 6
TARGET_SCORPION_BIONIC_PLDSIZE := 128

# Wifi
BOARD_WPA_SUPPLICANT_DRIVER := WEXT
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wext
WPA_SUPPLICANT_VERSION      := VER_0_8_X
WIFI_DRIVER_MODULE_PATH     := "/system/lib/modules/dhd.ko"
WIFI_DRIVER_MODULE_NAME     := "dhd"
BOARD_WLAN_DEVICE           := bcm4329
WIFI_DRIVER_FW_PATH_STA     := "/etc/wifi/rtecdc-bcm4329.bin"
WIFI_DRIVER_FW_PATH_AP      := "/etc/wifi/rtecdc-apsta-bcm4329.bin"
WIFI_DRIVER_MODULE_ARG      := "firmware_path=/etc/wifi/rtecdc-bcm4329.bin nvram_path=/etc/wifi/nvram-bcm4329.txt"
BOARD_HAVE_HUAWEI_WIFI := true
BOARD_USE_OLD_SOFTAP := true
# Bluetooth
#BOARD_HAVE_BLUETOOTH := true
#BOARD_HAVE_BLUETOOTH_BCM := true
#BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR ?= device/htc/msm8660-common/bluetooth/include
#BOARD_BLUEDROID_VENDOR_CONF := device/huawei/hws7300u/bluetooth/vnd_hws7300u.txt

# QCOM hardware
BOARD_USES_QCOM_HARDWARE := true
TARGET_QCOM_DISPLAY_VARIANT := legacy
TARGET_QCOM_AUDIO_VARIANT := caf
BOARD_USES_LEGACY_OVERLAY := true

# GPS
BOARD_USES_QCOM_GPS := true
BOARD_VENDOR_QCOM_GPS_LOC_API_AMSS_VERSION := 50000
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := default

# Graphics
USE_OPENGL_RENDERER := true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_PMEM := true
BOARD_EGL_CFG := device/huawei/hws7300u/prebuilt/etc/egl.cfg

# Webkit
ENABLE_WEBGL := true
TARGET_FORCE_CPU_UPLOAD := true

# Camera
BOARD_NEEDS_MEMORYHEAPPMEM := true
TARGET_DISABLE_ARM_PIE := true
COMMON_GLOBAL_CFLAGS += -DICS_CAMERA_BLOB

# FM
BOARD_HAVE_FM_RADIO := true
BOARD_GLOBAL_CFLAGS += -DHAVE_FM_RADIO

#kernel
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.hardware=hws7300u vmalloc=578M kgsl.ptcount=16
BOARD_KERNEL_BASE := 0x40300000
BOARD_KERNEL_PAGESIZE := 2048
#TARGET_PREBUILT_KERNEL := device/huawei/hws7300u/kernel
TARGET_KERNEL_SOURCE := kernel/huawei/hws7300u
TARGET_KERNEL_CONFIG := mediapad_defconfig

# Usb connection to PC
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/class/android_usb/android0/f_mass_storage/lun%d/file

# Audio
# BOARD_USE_QCOM_LPA := true

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

# CWM specific
BOARD_CUSTOM_GRAPHICS:= ../../../device/huawei/hws7300u/recovery/graphics.c

# TWRP specific
# DEVICE_RESOLUTION := 1280x800
# SP1_NAME := "cust"
# SP1_BACKUP_METHOD := image
# SP1_MOUNTABLE := 1
# TW_INTERNAL_STORAGE_PATH := "/data/media"
# TW_INTERNAL_STORAGE_MOUNT_POINT := "data"
# TW_EXTERNAL_STORAGE_PATH := "/external_sd"
# TW_EXTERNAL_STORAGE_MOUNT_POINT := "/external_sd"
# TW_FLASH_FROM_STORAGE := true
# RECOVERY_SDCARD_ON_DATA := true

# Hacks
TARGET_NO_HW_VSYNC := true
COMMON_GLOBAL_CFLAGS += -DQCOM_NO_SECURE_PLAYBACK
BOARD_USES_LEGACY_QCOM := true
