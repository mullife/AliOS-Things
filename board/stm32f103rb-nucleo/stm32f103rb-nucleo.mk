NAME := STM32F103RB-Nucleo

JTAG := stlink-v2-1

$(NAME)_TYPE := kernel
MODULE               := 1062
HOST_ARCH            := Cortex-M3
HOST_MCU_FAMILY      := stm32f1xx_cube
SUPPORT_BINS         := no
HOST_MCU_NAME        := STM32F103xE
ENABLE_VFP           := 0

$(NAME)_SOURCES += aos/board_partition.c \
                   aos/soc_init.c

$(NAME)_SOURCES += Src/stm32f1xx_hal_msp.c

ifeq ($(HOST_MCU_NAME),STM32F103xB)	
	$(NAME)_SOURCES += startup_stm32f103xb.s
else ifeq ($(HOST_MCU_NAME),STM32F103xE)
	$(NAME)_SOURCES += startup_stm32f103xe.s
endif

GLOBAL_INCLUDES += . \
                   hal/ \
                   aos/ \
                   Inc/

ifeq ($(HOST_MCU_NAME),STM32F103xB)				   
	GLOBAL_CFLAGS += -DSTM32F103xB
else ifeq ($(HOST_MCU_NAME),STM32F103xE)
	GLOBAL_CFLAGS += -DSTM32F103xE
endif

GLOBAL_CFLAGS += -DCONFIG_UART1_ENABLE -DCONFIG_UART2_ENABLE

ifeq ($(HOST_MCU_NAME),STM32F103xB)	
	GLOBAL_LDFLAGS += -T board/stm32f103rb-nucleo/STM32F103XB_FLASH.ld
else ifeq ($(HOST_MCU_NAME),STM32F103xE)
	GLOBAL_LDFLAGS += -T board/stm32f103rb-nucleo/STM32F103XE_FLASH.ld
endif

sal ?= 1
ifeq (1,$(sal))
$(NAME)_COMPONENTS += sal
module ?= wifi.mk3060
else
GLOBAL_DEFINES += CONFIG_NO_TCPIP
endif

CONFIG_SYSINFO_PRODUCT_MODEL := ALI_AOS_F103-nucleo
CONFIG_SYSINFO_DEVICE_NAME := F103-nucleo

GLOBAL_CFLAGS += -DSYSINFO_OS_VERSION=\"$(CONFIG_SYSINFO_OS_VERSION)\"
GLOBAL_CFLAGS += -DSYSINFO_PRODUCT_MODEL=\"$(CONFIG_SYSINFO_PRODUCT_MODEL)\"
GLOBAL_CFLAGS += -DSYSINFO_DEVICE_NAME=\"$(CONFIG_SYSINFO_DEVICE_NAME)\"
