src     = Split('''
       src/displayer/runapp/stm32f1xx_hal_msp.c      
       src/displayer/runapp/stm32f1xx_it.c           
       src/displayer/runapp/soc_init.c          
       src/displayer/runapp/system_stm32f1xx.c      
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c        
       src/displayer/hal/flash_l4.c  
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash.c  
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash_ex.c 
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash_ramfunc.c 
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_i2c.c    
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_i2c_ex.c 
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pwr.c    
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_qspi.c   
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc_ex.c 
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rng.c    
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rtc.c    
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rtc_ex.c 
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_spi.c    
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_spi_ex.c 
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c    
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_uart.c   
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_uart_ex.c  
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c   
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_dma.c    
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pwr_ex.c 
       Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c  
       Drivers/BSP/displayer/stm32l475e_iot01.c 
       Drivers/BSP/Components/es_wifi/es_wifi.c  
       aos/soc_impl.c                
       aos/trace_impl.c             
       src/displayer/runapp/aos.c                    
       src/common/csp/wifi/src/es_wifi_io.c        
       src/common/csp/wifi/src/wifi.c              
       src/displayer/hal/hw.c                     
       src/displayer/hal/flash_port.c              
       src/displayer/hal/ota_port.c               
       src/displayer/hal/wifi_port.c 
''')

if aos_global_config.compiler == 'armcc':
    src.append( 'src/displayer/runapp/startup_stm32f103xb_armcc.s' )
elif aos_global_config.compiler == 'iar':
    src.append( 'src/displayer/runapp/startup_stm32f103xb_icc.s' )
else:
    src.append( 'src/displayer/runapp/startup_stm32f103xb_gcc.s' )

#if aos_global_config.ide != 'keil':
#    src.append( 'src/displayer/sensor/qspi.c')
#    src.append( 'Middlewares/USB_Device/Core/Src/usbd_core.c' )
#    src.append( 'Middlewares/USB_Device/Core/Src/usbd_ctlreq.c' )
#    src.append( 'Middlewares/USB_Device/Core/Src/usbd_ioreq.c' )

prefix = ''
if aos_global_config.compiler == "gcc":
    prefix = 'arm-none-eabi-'
        
component = aos_mcu_component('stm32f1xx', prefix, src)
if aos_global_config.compiler == 'armcc':
    component.add_prebuilt_objs('src/displayer/runapp/startup_stm32f103xb_armcc.o')
    component.add_prebuilt_objs('src/displayer/runapp/stm32f1xx_it.o')

component.add_comp_deps('platform/arch/arm/armv7m')
component.add_comp_deps('utility/libc')
component.add_comp_deps('kernel/rhino')
component.add_comp_deps('kernel/vcall')
component.add_comp_deps('kernel/init')
component.add_comp_deps('kernel/hal')
component.add_comp_deps('kernel/modules/fs/kv')
component.add_comp_deps('kernel/vfs')
component.add_comp_deps('utility/digest_algorithm')

component.set_global_arch('Cortex-M3')

include_tmp = Split('''
       ../../arch/arm/armv7m/gcc/m3
       src/common/csp/lwip/include 
       src/common/csp/wifi/inc     
       src/displayer/include   
       src/displayer/runapp    
       Drivers/STM32F1xx_HAL_Driver/Inc 
       Drivers/STM32F1xx_HAL_Driver/Inc/Legacy 
       Drivers/BSP/displayer 
       Drivers/BSP/Components/es_wifi  
       Drivers/CMSIS/Include 
       ../../../include/hal 
''')

for i in include_tmp:
    component.add_global_includes(i)
    
macro_tmp = Split('''
   CONFIG_AOS_KV_MULTIPTN_MODE
   CONFIG_AOS_KV_PTN=6
   CONFIG_AOS_KV_SECOND_PTN=7
   CONFIG_AOS_KV_PTN_SIZE=4096
   CONFIG_AOS_KV_BUFFER_SIZE=8192
   STM32L475xx
   RHINO_CONFIG_WORKQUEUE=1
''') 

for i in macro_tmp:
    component.add_global_macros(i)

if aos_global_config.compiler == 'armcc':
    cflags_tmp = Split('''
        --c99 
        --cpu=7E-M 
        -D__MICROLIB 
        -g 
        --apcs=interwork 
        --split_sections
    ''')
elif aos_global_config.compiler == 'iar':
    cflags_tmp = Split('''
        --cpu=Cortex-M3
        --cpu_mode=thumb
        --endian=little
    ''')
else:    
    cflags_tmp = Split('''
        -mcpu=cortex-m3
        -march=armv7-m  
        -mlittle-endian 
        -mthumb
        -mthumb-interwork
        -w
    ''')
for i in cflags_tmp: 
    component.add_global_cflags(i)

if aos_global_config.compiler == 'armcc':
    asflags_tmp = Split('''
        --cpu=7E-M
        -g
        --apcs=interwork
        --library_type=microlib
        --pd "__MICROLIB SETA 1"
    ''')
elif aos_global_config.compiler == 'iar':
    asflags_tmp = Split('''
        --cpu Cortex-M3
        --cpu_mode thumb
        --endian little
    ''')
else:
    asflags_tmp = Split('''
        -mcpu=cortex-m3 
        -march=armv7-m   
        -mlittle-endian 
        -mthumb 
        -mthumb-interwork 
        -w
    ''') 
for i in asflags_tmp:
    component.add_global_asflags(i)

if aos_global_config.compiler == 'armcc':
    ldflags_tmp = Split('''
        -L --cpu=7E-M
        -L --strict
        -L --xref -L --callgraph -L --symbols
        -L --info=sizes -L --info=totals -L --info=unused -L --info=veneers -L --info=summarysizes
    ''')
    ldflags_tmp.append('-L')
    ldflags_tmp.append('--scatter=platform/mcu/stm32f1xx/STM32F103XB.sct')
elif aos_global_config.compiler == 'iar':
    ldflags_tmp = Split('''
        --silent 
        --cpu=Cortex-M3.vfp
    ''')     
    ldflags_tmp.append('--config')
    ldflags_tmp.append('platform/mcu/stm32f1xx/STM32F103XB.icf')
else:
    ldflags_tmp  = Split('''
        -mcpu=cortex-m3  
        -mlittle-endian  
        -mthumb 
        -mthumb-interwork 
        -nostartfiles    
        --specs=nosys.specs 
    ''') 
    CLIB_LDFLAGS_NANO_FLOAT = aos_global_config.get('CLIB_LDFLAGS_NANO_FLOAT')
    ldflags_tmp.append( CLIB_LDFLAGS_NANO_FLOAT )
    ldflags_tmp.append('-T')
    ldflags_tmp.append('platform/mcu/stm32f1xx/STM32F103XB_FLASH.ld')

for i in ldflags_tmp:
    component.add_global_ldflags(i)
