# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2024 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=chinadns-ng
PKG_VERSION:=2024.11.17
PKG_RELEASE:=1

ifeq ($(ARCH),aarch64)
  PKG_SOURCE_URL_FILE:=$(PKG_NAME)+wolfssl_noasm@aarch64-linux-musl@generic+v8a@fast+lto
  PKG_HASH:=b2e53d1fdc5d65b5f2a1dc26428bf15b86d84f51748ff1970d58bf301f69d2c0
else ifeq ($(ARCH),arm)
  # Referred to golang/golang-values.mk
  ARM_CPU_FEATURES:=$(word 2,$(subst +,$(space),$(call qstrip,$(CONFIG_CPU_TYPE))))
  ifeq ($(ARM_CPU_FEATURES),)
    PKG_SOURCE_URL_FILE:=$(PKG_NAME)+wolfssl@arm-linux-musleabi@generic+v5t+soft_float@fast+lto
    PKG_HASH:=9adfe309a41f21156cc5597333c42c36bc9e4e42eb1a71d18b92c39aed0340b2
  else ifneq ($(filter $(ARM_CPU_FEATURES),vfp vfpv2),)
    PKG_SOURCE_URL_FILE:=$(PKG_NAME)+wolfssl@arm-linux-musleabi@generic+v6+soft_float@fast+lto
    PKG_HASH:=511f9700e38b1f4ba65fefccd7c4f4a77773a8ebad0600c89e315286561e9288
  else
    PKG_SOURCE_URL_FILE:=$(PKG_NAME)+wolfssl@arm-linux-musleabihf@generic+v7a@fast+lto
    PKG_HASH:=13244ea7b722ad117ad7aaf32187a7ac11361ddda1201c632e9b9650fb24a824
  endif
else ifeq ($(ARCH),i386)
  ifneq ($(CONFIG_TARGET_x86_geode)$(CONFIG_TARGET_x86_legacy),)
    PKG_SOURCE_URL_FILE:=$(PKG_NAME)+wolfssl@i386-linux-musl@i686@fast+lto
    PKG_HASH:=35c21309fd334d43e3f5b5e7194d6acc49ceeb358e76b6074ecc3b9e370c2bd7
  else
    PKG_SOURCE_URL_FILE:=$(PKG_NAME)+wolfssl@i386-linux-musl@pentium4@fast+lto
    PKG_HASH:=aedfa24bee4759cf982623def4346d5dd8da84027a87f91c33571ec7aeb4ad69
  endif
else ifeq ($(ARCH),mips)
    PKG_SOURCE_URL_FILE:=$(PKG_NAME)+wolfssl@mips-linux-musl@mips32+soft_float@fast+lto
    PKG_HASH:=aca11ed4c513db6970c46f54f0449c9a49722eb4f80be11a915d4d550d2726e9
else ifeq ($(ARCH),mipsel)
  ifeq ($(CONFIG_HAS_FPU),)
    PKG_SOURCE_URL_FILE:=$(PKG_NAME)+wolfssl@mipsel-linux-musl@mips32+soft_float@fast+lto
    PKG_HASH:=82eed3511c11f1cb5c2e611a97d42f9264640bea1e029c04337d073788f65d19
  else
    PKG_SOURCE_URL_FILE:=$(PKG_NAME)+wolfssl@mipsel-linux-musl@mips32@fast+lto
    PKG_HASH:=98b8cbbde8473a51c3f24979664bfffb54ec5665f851437100e4859e3f674f5b
  endif
else ifeq ($(ARCH),x86_64)
  PKG_SOURCE_URL_FILE:=$(PKG_NAME)+wolfssl@x86_64-linux-musl@x86_64@fast+lto
  PKG_HASH:=30b02f9a6451f2a473d23210ea652b13c4ce6a1c01aadfabf34e5f47203b2628
else
  PKG_SOURCE_URL_FILE:=dummy
  PKG_HASH:=dummy
endif

PKG_SOURCE:=$(subst $(PKG_NAME),$(PKG_NAME)-$(PKG_VERSION),$(PKG_SOURCE_URL_FILE))
PKG_SOURCE_URL:=https://github.com/zfl9/chinadns-ng/releases/download/$(PKG_VERSION)/

PKG_LICENSE:=AGPL-3.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>

include $(INCLUDE_DIR)/package.mk

PKG_UNPACK:=:

define Package/chinadns-ng
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=ChinaDNS next generation, refactoring with epoll and ipset.
  URL:=https://github.com/zfl9/chinadns-ng
  DEPENDS:=@(aarch64||arm||i386||mips||mipsel||x86_64)
endef

define Build/Compile
endef

define Package/chinadns-ng/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(DL_DIR)/$(PKG_SOURCE) $(1)/usr/bin/chinadns-ng
endef

$(eval $(call BuildPackage,chinadns-ng))
