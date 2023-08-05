# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= DeYouOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
else
# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/lineage/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/lineage/prebuilt/common/bin/50-lineage.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-lineage.sh

# PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/addon.d/50-lineage.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/lineage/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/lineage/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_postinstall.sh

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Lineage-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/lineage/config/permissions/lineage-sysconfig.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/lineage-sysconfig.xml

# Lineage-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/init/init.lineage-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.lineage-system_ext.rc

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/lineage/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# This is Lineage!
PRODUCT_COPY_FILES += \
    vendor/lineage/config/permissions/org.lineageos.android.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.android.xml

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

ifneq ($(TARGET_DISABLE_LINEAGE_SDK), true)
# Lineage SDK
include vendor/lineage/config/lineage_sdk_common.mk
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

ifneq ($(TARGET_DISABLE_EPPE),true)
# Require all requested packages to exist
$(call enforce-product-packages-exist-internal,$(wildcard device/*/$(LINEAGE_BUILD)/$(TARGET_PRODUCT).mk),product_manifest.xml rild Calendar Launcher3 Launcher3Go Launcher3QuickStep Launcher3QuickStepGo android.hidl.memory@1.0-impl.vendor vndk_apex_snapshot_package)
endif

# Bootanimation
TARGET_SCREEN_WIDTH ?= 1080
TARGET_SCREEN_HEIGHT ?= 1920
PRODUCT_PACKAGES += \
    bootanimation.zip

# Build Manifest
PRODUCT_PACKAGES += \
    build-manifest

# Lineage packages
PRODUCT_PACKAGES += \
    LineageParts \
    LineageSettingsProvider
    # LineageSetupWizard
    # Updater

PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/init/init.lineage-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.lineage-updater.rc

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Extra tools in Lineage
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/lineage/overlay/no-rro
PRODUCT_PACKAGE_OVERLAYS += \
    vendor/lineage/overlay/common \
    vendor/lineage/overlay/no-rro

PRODUCT_PACKAGES += \
    DocumentsUIOverlay \
    NetworkStackOverlay \
    TrebuchetOverlay

PRODUCT_PACKAGES += \
    android.hardware.brawn-service \
    brawnShell \
    brawnClient \
    BrawnApp \
    SogouIME

# redsocks
PRODUCT_PACKAGES += \
    redsocks \
    frida-server

# google apps
PRODUCT_COPY_FILES += \
    vendor/brawn/google/system/product/app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk:system/product/app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk \
    vendor/brawn/google/system/product/app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk:system/product/app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk \
    vendor/brawn/google/system/product/app/MarkupGoogle/MarkupGoogle.apk:system/product/app/MarkupGoogle/MarkupGoogle.apk \
    vendor/brawn/google/system/product/app/PrebuiltExchange3Google/PrebuiltExchange3Google.apk:system/product/app/PrebuiltExchange3Google/PrebuiltExchange3Google.apk \
    vendor/brawn/google/system/product/app/SpeechServicesByGoogle/SpeechServicesByGoogle.apk:system/product/app/SpeechServicesByGoogle/SpeechServicesByGoogle.apk \
    vendor/brawn/google/system/product/app/talkback/talkback.apk:system/product/app/talkback/talkback.apk \
    vendor/brawn/google/system/product/etc/default-permissions/default-permissions-google.xml:system/product/etc/default-permissions/default-permissions-google.xml \
    vendor/brawn/google/system/product/etc/default-permissions/default-permissions-mtg.xml:system/product/etc/default-permissions/default-permissions-mtg.xml \
    vendor/brawn/google/system/product/etc/permissions/com.google.android.dialer.support.xml:system/product/etc/permissions/com.google.android.dialer.support.xml \
    vendor/brawn/google/system/product/etc/permissions/privapp-permissions-google-product.xml:system/product/etc/permissions/privapp-permissions-google-product.xml \
    vendor/brawn/google/system/product/etc/security/fsverity/gms_fsverity_cert.der:system/product/etc/security/fsverity/gms_fsverity_cert.der \
    vendor/brawn/google/system/product/etc/sysconfig/d2d_cable_migration_feature.xml:system/product/etc/sysconfig/d2d_cable_migration_feature.xml \
    vendor/brawn/google/system/product/etc/sysconfig/google_build.xml:system/product/etc/sysconfig/google_build.xml \
    vendor/brawn/google/system/product/etc/sysconfig/google-hiddenapi-package-allowlist.xml:system/product/etc/sysconfig/google-hiddenapi-package-allowlist.xml \
    vendor/brawn/google/system/product/etc/sysconfig/google.xml:system/product/etc/sysconfig/google.xml \
    vendor/brawn/google/system/product/framework/com.google.android.dialer.support.jar:system/product/framework/com.google.android.dialer.support.jar \
    vendor/brawn/google/system/product/lib/libjni_latinimegoogle.so:system/product/lib/libjni_latinimegoogle.so \
    vendor/brawn/google/system/product/lib64/libjni_latinimegoogle.so:system/product/lib64/libjni_latinimegoogle.so \
    vendor/brawn/google/system/product/overlay/GmsOverlay.apk:system/product/overlay/GmsOverlay.apk \
    vendor/brawn/google/system/product/overlay/GmsSettingsProviderOverlay.apk:system/product/overlay/GmsSettingsProviderOverlay.apk \
    vendor/brawn/google/system/product/priv-app/AndroidAutoStub/AndroidAutoStub.apk:system/product/priv-app/AndroidAutoStub/AndroidAutoStub.apk \
    vendor/brawn/google/system/product/priv-app/GmsCore/GmsCore.apk:system/product/priv-app/GmsCore/GmsCore.apk \
    vendor/brawn/google/system/product/priv-app/GsfCore/GsfCore.apk:system/product/priv-app/GsfCore/GsfCore.apk \
    vendor/brawn/google/system/product/priv-app/GooglePartnerSetup/GooglePartnerSetup.apk:system/product/priv-app/GooglePartnerSetup/GooglePartnerSetup.apk \
    vendor/brawn/google/system/product/priv-app/GoogleRestore/GoogleRestore.apk:system/product/priv-app/GoogleRestore/GoogleRestore.apk \
    vendor/brawn/google/system/product/priv-app/Phonesky/Phonesky.apk:system/product/priv-app/Phonesky/Phonesky.apk \
    vendor/brawn/google/system/product/priv-app/Velvet/Velvet.apk:system/product/priv-app/Velvet/Velvet.apk \
    vendor/brawn/google/system/system_ext/etc/permissions/privapp-permissions-google-system-ext.xml:system/system_ext/etc/permissions/privapp-permissions-google-system-ext.xml \
    vendor/brawn/google/system/system_ext/priv-app/GoogleFeedback/GoogleFeedback.apk:system/system_ext/priv-app/GoogleFeedback/GoogleFeedback.apk \
    vendor/brawn/google/system/system_ext/priv-app/GoogleServicesFramework/GoogleServicesFramework.apk:system/system_ext/priv-app/GoogleServicesFramework/GoogleServicesFramework.apk


# android.hardware.virtualmedia@1.0-service \
# VirtualMedia \
# PRODUCT_PROPERTY_OVERRIDES += ro.hardware.camera=virtual

# Translations
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/crowdin/overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/crowdin/overlay

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/lineage/build/target/product/security/lineage

include vendor/lineage/config/version.mk

-include vendor/lineage-priv/keys/keys.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/lineage/config/partner_gms.mk

PRODUCT_SOONG_NAMESPACES += \
    hardware/brawn/interfaces
