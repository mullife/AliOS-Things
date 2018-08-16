NAME := stm32f1xx_cube
HOST_OPENOCD := stm32f1xx
$(NAME)_TYPE := kernel

$(NAME)_COMPONENTS += platform/arch/arm/armv7m
$(NAME)_COMPONENTS += libc rhino hal vfs cli modules.fs.kv digest_algorithm

GLOBAL_DEFINES += CONFIG_AOS_KV_MULTIPTN_MODE
GLOBAL_DEFINES += CONFIG_AOS_KV_PTN=6
GLOBAL_DEFINES += CONFIG_AOS_KV_SECOND_PTN=7
GLOBAL_DEFINES += CONFIG_AOS_KV_PTN_SIZE=4096
GLOBAL_DEFINES += CONFIG_AOS_KV_BUFFER_SIZE=8192

GLOBAL_INCLUDES += 	Drivers/STM32F1xx_HAL_Driver/Inc \
					Drivers/STM32F1xx_HAL_Driver/Inc/Legacy \
					Drivers/CMSIS/Include \
					Drivers/CMSIS/Device/ST/STM32F1xx/Include

$(NAME)_SOURCES := Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c  \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_crc.c  \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c  \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_dma.c \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio_ex.c \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pwr.c    \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_i2c.c \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_tim.c \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_tim_ex.c \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_uart.c \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_usart.c \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_wwdg.c \
				Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash.c \
				Drivers/CMSIS/Device/ST/STM32F1xx/Source/Templates/system_stm32f1xx.c

$(NAME)_SOURCES += aos/soc_impl.c \
				aos/trace_impl.c \
				aos/aos.c \
				hal/hal_uart_stm32f1.c \
				hal/hw.c \
				hal/hal_gpio_stm32f1.c \
				hal/hal_i2c_stm32f1.c \
				hal/hal_rtc_stm32f1.c \
				hal/hal_flash_stm32f1.c

ifeq ($(COMPILER),armcc)
	GLOBAL_CFLAGS   += --c99 --cpu=Cortex-M3 -D__MICROLIB -g --split_sections
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
	GLOBAL_CFLAGS  += -D__VFP_FP__
endif

ifeq ($(COMPILER),armcc)
	GLOBAL_ASMFLAGS += --cpu=Cortex-M3 -g --library_type=microlib --pd "__MICROLIB SETA 1"
else ifeq ($(COMPILER),iar)
	GLOBAL_ASMFLAGS += --cpu Cortex-M3 \
					 --cpu_mode thumb \
					 --endian little
else
	GLOBAL_ASMFLAGS += -mcpu=cortex-m3 \
					 -mlittle-endian \
					 -mthumb \
					 -w
endif

ifeq ($(COMPILER),armcc)
	GLOBAL_LDFLAGS += -L --cpu=Cortex-M3   \
					  -L --strict \
					  -L --xref -L --callgraph -L --symbols \
					  -L --info=sizes -L --info=totals -L --info=unused -L --info=veneers -L --info=summarysizes
else ifeq ($(COMPILER),iar)
	GLOBAL_LDFLAGS += --silent --cpu=Cortex-M3.vfp

else
	GLOBAL_LDFLAGS += -mcpu=cortex-m3  \
					-mlittle-endian  \
					-mthumb -mthumb-interwork \
    				--specs=nosys.specs \
					$(CLIB_LDFLAGS_NANO_FLOAT)
endif
