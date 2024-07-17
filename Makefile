# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2024 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=chinadns-ng
PKG_VERSION:=2024.07.16
PKG_RELEASE:=2

ifeq ($(ARCH),aarch64)
  PKG_SOURCE:=$(PKG_NAME)@aarch64-linux-musl@generic+v8a@fast+lto
  PKG_HASH:=e2f630159c26c1363526ea2f9134bb459709637c2157d9856f244a145f03fe43
else ifeq ($(ARCH),arm)
  # Referred to golang/golang-values.mk
  ARM_CPU_FEATURES:=$(word 2,$(subst +,$(space),$(call qstrip,$(CONFIG_CPU_TYPE))))
  ifeq ($(ARM_CPU_FEATURES),)
    PKG_SOURCE:=$(PKG_NAME)@arm-linux-musleabi@generic+v5t+soft_float@fast+lto
    PKG_HASH:=ebb0782a3379756f59d3fdda2c6041ae22aa0ee6a2cfdaceb7b1b1e5a0d7819d
  else ifneq ($(filter $(ARM_CPU_FEATURES),vfp vfpv2),)
    PKG_SOURCE:=$(PKG_NAME)@arm-linux-musleabi@generic+v6+soft_float@fast+lto
    PKG_HASH:=3baabfbe4e467458e7d31b9e9e9957356b64701dde967d3943deedb317638e80
  else
    PKG_SOURCE:=$(PKG_NAME)@arm-linux-musleabihf@generic+v7a@fast+lto
    PKG_HASH:=9b9d2fb3804eee10b76740564047c9611c6ed3b055d25febbaa5c53aaee75575
  endif
else ifeq ($(ARCH),i386)
  ifneq ($(CONFIG_TARGET_x86_geode)$(CONFIG_TARGET_x86_legacy),)
    PKG_SOURCE:=$(PKG_NAME)@i386-linux-musl@i686@fast+lto
    PKG_HASH:=03d15849f28fd9f5ec59575b73b5fcec4389552e42319e75c7fbcf7bb46fc5a4
  else
    PKG_SOURCE:=$(PKG_NAME)@i386-linux-musl@pentium4@fast+lto
    PKG_HASH:=6c1de87eecf45014ec59ef87ae4fe7ba223287921823f508dbb846d3810895b7
  endif
else ifeq ($(ARCH),mips)
  ifeq ($(CPU_TYPE),mips32)
    PKG_SOURCE:=$(PKG_NAME)@mips-linux-musl@mips32+soft_float@fast+lto
    PKG_HASH:=054fef78fad4d6936257bb3174aaf262ebf8b3d448968f1a7eeeaf134e048b44
  else
    PKG_SOURCE:=$(PKG_NAME)@mips-linux-musl@mips32r2+soft_float@fast+lto
    PKG_HASH:=82cf0b874c4b84ab6ca85714ecaae8a0a641926dcf24e4b7815b379b11d89ce7
  endif
else ifeq ($(ARCH),mipsel)
  ifeq ($(CPU_TYPE),)
    PKG_SOURCE:=$(PKG_NAME)@mipsel-linux-musl@mips32+soft_float@fast+lto
    PKG_HASH:=c5af2963c0ced59de6927108fbf6e58b545c07686bf0021178ef4e13ca641642
  else ifeq ($(CONFIG_HAS_FPU),)
    PKG_SOURCE:=$(PKG_NAME)@mipsel-linux-musl@mips32r2+soft_float@fast+lto
    PKG_HASH:=a09cddb06227234a35112f0e9c8b8a93208646f37f4da861c2959409284b0aeb
  else
    PKG_SOURCE:=$(PKG_NAME)@mipsel-linux-musl@mips32r2@fast+lto
    PKG_HASH:=e05650a643f7c0df29801b48697a5266c39670fb7d22454f7d871fb91062098c
  endif
else ifeq ($(ARCH),x86_64)
  PKG_SOURCE:=$(PKG_NAME)@x86_64-linux-musl@x86_64@fast+lto
  PKG_HASH:=979aafd629c62b0ecb127ffe16cf39acee3487aa33319caf4eb239a2ccfcec8e
else
  PKG_SOURCE:=dummy
  PKG_HASH:=dummy
endif
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
