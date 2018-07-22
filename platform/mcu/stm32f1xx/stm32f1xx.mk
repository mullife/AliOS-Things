
NAME := stm32f1xx

HOST_OPENOCD := stm32f1xx

$(NAME)_TYPE := kernel

$(NAME)_COMPONENTS += platform/arch/arm/armv7m
$(NAME)_COMPONENTS += libc rhino hal modules.fs.kv vfs digest_algorithm

GLOBAL_DEFINES += CONFIG_AOS_KV_MULTIPTN_MODE
GLOBAL_DEFINES += CONFIG_AOS_KV_PTN=6
GLOBAL_DEFINES += CONFIG_AOS_KV_SECOND_PTN=7
GLOBAL_DEFINES += CONFIG_AOS_KV_PTN_SIZE=4096
GLOBAL_DEFINES += CONFIG_AOS_KV_BUFFER_SIZE=8192

GLOBAL_INCLUDES += ../../arch/arm/armv7m/gcc/m3

GLOBAL_INCLUDES += \
                   src/common/csp/lwip/include \
                   src/common/csp/wifi/inc     \
                   src/displayer/include   \
                   src/displayer/runapp    \
                   Drivers/STM32F1xx_HAL_Driver/Inc \
                   Drivers/STM32F1xx_HAL_Driver/Inc/Legacy \
                   Drivers/BSP/displayer \
                   Drivers/BSP/Components/es_wifi \
                   Drivers/BSP/Components/hts221 \
                   Drivers/BSP/Components/lis3mdl \
                   Drivers/BSP/Components/lps22hb \
                   Drivers/BSP/Components/lsm6dsl \
                   Drivers/BSP/Components/vl53l0x \
                   Drivers/CMSIS/Include \
                   ../../../include/hal \
                   Middlewares/USB_Device/Core/Inc

GLOBAL_CFLAGS += -DSTM32F103xB

ifeq ($(COMPILER),armcc)
GLOBAL_CFLAGS   += --c99 --cpu=7E-M -D__MICROLIB -g --apcs=interwork --split_sections
else ifeq ($(COMPILER),iar)
GLOBAL_CFLAGS += --cpu=Cortex-M3 \
                 --cpu_mode=thumb \
                 --endian=little
else
GLOBAL_CFLAGS += -mcpu=cortex-m3 \
                 -march=armv7-m  \
                 -mlittle-endian \
                 -mthumb -mthumb-interwork \
                 -w
endif

ifeq ($(COMPILER),armcc)
GLOBAL_ASMFLAGS += --cpu=7E-M -g --apcs=interwork --library_type=microlib --pd "__MICROLIB SETA 1"
else ifeq ($(COMPILER),iar)
GLOBAL_ASMFLAGS += --cpu Cortex-M3 \
                   --cpu_mode thumb \
                   --endian little
else
GLOBAL_ASMFLAGS += -mcpu=cortex-m3 \
                   -march=armv7-m  \
                   -mlittle-endian \
                   -mthumb -mthumb-interwork \
                   -w
endif

ifeq ($(COMPILER),armcc)
GLOBAL_LDFLAGS += -L --cpu=7E-M   \
                  -L --strict \
                  -L --xref -L --callgraph -L --symbols \
                  -L --info=sizes -L --info=totals -L --info=unused -L --info=veneers -L --info=summarysizes
else ifeq ($(COMPILER),iar)
GLOBAL_LDFLAGS += --silent --cpu=Cortex-M3.vfp

else
GLOBAL_LDFLAGS += -mcpu=cortex-m3  \
                  -mlittle-endian  \
                  -mthumb -mthumb-interwork \
                  -nostartfiles    \
                  --specs=nosys.specs \
                  $(CLIB_LDFLAGS_NANO_FLOAT)
endif

ifeq ($(COMPILER),armcc)
GLOBAL_LDFLAGS += -L --scatter=platform/mcu/stm32f1xx/STM32F103XB.sct
else ifeq ($(COMPILER),iar)
GLOBAL_LDFLAGS += --config platform/mcu/stm32f1xx/STM32F103XB.icf
else
GLOBAL_LDFLAGS += -T platform/mcu/stm32f1xx/STM32F103XB_FLASH.ld
endif

$(NAME)_SOURCES := src/displayer/runapp/stm32l4xx_hal_msp.c      \
                   src/displayer/runapp/stm32l4xx_it.c           \
                   src/displayer/runapp/soc_init.c          \
                   src/displayer/runapp/system_stm32l4xx.c      \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal.c        \
                   src/displayer/hal/flash_l4.c  \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_flash.c  \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_flash_ex.c \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_flash_ramfunc.c \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_i2c.c    \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_i2c_ex.c \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_pwr.c    \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_qspi.c   \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_rcc_ex.c \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_rng.c    \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_rtc.c    \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_rtc_ex.c \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_spi.c    \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_spi_ex.c \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_rcc.c    \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_uart.c   \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_uart_ex.c  \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_gpio.c   \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_dma.c    \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_pwr_ex.c \
                   Drivers/STM32F1xx_HAL_Driver/Src/stm32l4xx_hal_cortex.c \
                   Drivers/BSP/displayer/stm32l475e_iot01_accelero.c \
                   Drivers/BSP/displayer/stm32l475e_iot01_gyro.c \
                   Drivers/BSP/displayer/stm32l475e_iot01_hsensor.c \
                   Drivers/BSP/displayer/stm32l475e_iot01_magneto.c \
                   Drivers/BSP/displayer/stm32l475e_iot01_psensor.c \
                   Drivers/BSP/displayer/stm32l475e_iot01_tsensor.c \
                   Drivers/BSP/displayer/stm32l475e_iot01.c \
                   Drivers/BSP/Components/es_wifi/es_wifi.c \
                   Drivers/BSP/Components/hts221/hts221.c \
                   Drivers/BSP/Components/lis3mdl/lis3mdl.c \
                   Drivers/BSP/Components/lps22hb/lps22hb.c \
                   Drivers/BSP/Components/lsm6dsl/lsm6dsl.c \
                   Drivers/BSP/Components/vl53l0x/vl53l0x_api.c \
                   Drivers/BSP/Components/vl53l0x/vl53l0x_api_calibration.c \
                   Drivers/BSP/Components/vl53l0x/vl53l0x_api_core.c \
                   Drivers/BSP/Components/vl53l0x/vl53l0x_api_ranging.c \
                   Drivers/BSP/Components/vl53l0x/vl53l0x_api_strings.c \
                   Drivers/BSP/Components/vl53l0x/vl53l0x_platform_log.c \
                   aos/soc_impl.c                \
                   aos/trace_impl.c             \
                   src/displayer/runapp/aos.c                    \
                   src/common/csp/wifi/src/es_wifi_io.c        \
                   src/common/csp/wifi/src/wifi.c              \
                   src/displayer/hal/hw.c                     \
                   src/displayer/hal/flash_port.c              \
                   src/displayer/hal/ota_port.c              \
                   src/displayer/hal/hal_i2c_stm32l4.c       \
                   src/displayer/sensor/vl53l0x_platform.c \
                   src/displayer/sensor/vl53l0x_proximity.c \
                   src/displayer/sensor/sensors_data.c \
                   src/displayer/sensor/sensors.c \
                   src/displayer/hal/wifi_port.c

#ifneq ($(IDE),keil)                   
#$(NAME)_SOURCES += src/displayer/sensor/qspi.c \
#                   Middlewares/USB_Device/Core/Src/usbd_core.c \
#                   Middlewares/USB_Device/Core/Src/usbd_ctlreq.c \
#                   Middlewares/USB_Device/Core/Src/usbd_ioreq.c
#endif

ifeq ($(COMPILER),armcc)
$(NAME)_SOURCES += src/displayer/runapp/startup_stm32f103xb_armcc.s
$(NAME)_LINK_FILES := src/displayer/runapp/startup_stm32f103xb_armcc.o
$(NAME)_LINK_FILES += src/displayer/runapp/stm32f1xx_it.o
else ifeq ($(COMPILER),iar)
$(NAME)_SOURCES += src/displayer/runapp/startup_stm32f103xb_icc.s
else
$(NAME)_SOURCES += src/displayer/runapp/startup_stm32f103xb_gcc.s
endif

