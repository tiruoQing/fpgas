

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xttcps.h"
#include "Xscugic.h"
#include "xparameters.h"


#define GicDeviceId		XPAR_SCUGIC_SINGLE_DEVICE_ID

#define TTC00DeviceId	XPAR_XTTCPS_0_DEVICE_ID
#define TTC00IntId		XPS_TTC0_0_INT_ID

#define TTC01DeviceId	XPAR_XTTCPS_1_DEVICE_ID
#define TTC01IntId		XPS_TTC0_1_INT_ID

#define TTC0Freq		1
#define TTC1Freq		2

#define TTC_Option		XTTCPS_OPTION_INTERVAL_MODE | XTTCPS_OPTION_WAVE_DISABLE
#define TTC_Mask		XTTCPS_IXR_INTERVAL_MASK


XScuGic GicInst;
XTtcPs	ttc0Inst;
XTtcPs	ttc1Inst;


// 方便传递函数参数
typedef void (*TTC_Handler)(void *);
// 初始化中断系统
static void  SysInterruptSetup(u16 DeviceId, XScuGic* GicInstancePtr);
// 初始化ttc及中断
static void  TTC_Int_Init(u16 ttcDeviceId, XTtcPs* ttcInstancePtr, u16 ttcIntId, u32 Freq, TTC_Handler handlerFunc);
// 定义中断回调函数
static void	 TTC0_Handle(void *Callbackref);
static void  TTC1_Handle(void *Callbackref);

// 中断flag
u8 flag_ttc0;
u8 flag_ttc1;

int main()
{
    init_platform();
    SysInterruptSetup(GicDeviceId, &GicInst);

    TTC_Int_Init(TTC00DeviceId, &ttc0Inst, TTC00IntId, TTC0Freq, TTC0_Handle);
    TTC_Int_Init(TTC01DeviceId, &ttc1Inst, TTC01IntId, TTC1Freq, TTC1_Handle);
    while(1){
    	if(flag_ttc0){
    		flag_ttc0 = 0;
    		print("ttc0000000 has been detected!!! \r\n");
    	}
    	if(flag_ttc1){
    		flag_ttc1 = 0;
			print("ttc1111111 has been detected!!! \r\n");
		}
    }
    cleanup_platform();
    return 0;
}

static void SysInterruptSetup(u16 DeviceId, XScuGic* GicInstancePtr)
{
	XScuGic_Config* GicConfPtr;
	Xil_ExceptionInit();
	GicConfPtr = XScuGic_LookupConfig(GicDeviceId);
	XScuGic_CfgInitialize(GicInstancePtr, GicConfPtr, GicConfPtr->CpuBaseAddress);
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
					(Xil_ExceptionHandler) XScuGic_InterruptHandler,
					GicInstancePtr);
	Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);
}


static void  TTC_Int_Init(u16 ttcDeviceId, XTtcPs* ttcInstancePtr, u16 ttcIntId, u32 Freq, TTC_Handler handlerFunc)
{
	XInterval Interval;
	u8 Prescaler;
	XTtcPs_Config* ttcConfPtr;
	ttcConfPtr = XTtcPs_LookupConfig(ttcDeviceId);
	XTtcPs_CfgInitialize(ttcInstancePtr, ttcConfPtr, ttcConfPtr->BaseAddress);

	XTtcPs_SetOptions(ttcInstancePtr, XTTCPS_OPTION_WAVE_DISABLE | XTTCPS_OPTION_INTERVAL_MODE);
	XTtcPs_CalcIntervalFromFreq(ttcInstancePtr, Freq, &Interval, &Prescaler);
	XTtcPs_SetPrescaler(ttcInstancePtr, Prescaler);
	XTtcPs_SetInterval(ttcInstancePtr, Interval);

	XScuGic_Connect(&GicInst, ttcIntId, (Xil_ExceptionHandler)handlerFunc, (void *)ttcInstancePtr);
	XTtcPs_EnableInterrupts(ttcInstancePtr, TTC_Mask);
	XScuGic_Enable(&GicInst, ttcIntId);
	XTtcPs_Start(ttcInstancePtr);
}




static void	 TTC0_Handle(void *Callbackref)
{
	flag_ttc0 = 1;
	u32 status = XTtcPs_GetInterruptStatus((XTtcPs*)Callbackref);
	XTtcPs_ClearInterruptStatus((XTtcPs*)Callbackref, status);
}


static void  TTC1_Handle(void *Callbackref)
{
	flag_ttc1 = 1;
	u32 status = XTtcPs_GetInterruptStatus((XTtcPs*)Callbackref);
	XTtcPs_ClearInterruptStatus((XTtcPs*)Callbackref, status);
}
