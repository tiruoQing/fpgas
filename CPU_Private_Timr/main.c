

#include "xparameters.h"
#include "platform.h"
#include "xscutimer.h"
#include "Xscugic.h"
#include "stdio.h"


#define TimerDeviceId	XPAR_XSCUTIMER_0_DEVICE_ID
#define IntDeviceId		XPAR_SCUGIC_0_DEVICE_ID
#define TimerIntId		XPS_SCU_TMR_INT_ID

#define TIMER_FREQ		5		// hz
#define SYS_CPU_CLK 	XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ
#define TIMER_VALUE		SYS_CPU_CLK/2/TIMER_FREQ


// instance timer and interrupt
XScuGic 	IntInst;
XScuTimer 	TimerInst;


// interrupt callback
static void IntHandle();
// setup timer and  interrupt
static void Init(XScuGic* IntInstance, XScuTimer* TimerInstance, u16 IntDeviceID, u16 TimerDeviceID, u16 IntID);

// define a cnt variable to observe
static u16 cnt;
static u8 flag;


int main()
{
	cnt = 0;
	Init(&IntInst, &TimerInst, IntDeviceId, IntDeviceId, TimerIntId);
	XScuTimer_LoadTimer(&TimerInst, TIMER_VALUE);
	XScuTimer_Start(&TimerInst);
	while(1)
	{
		if(flag)
			printf("cnt is %d  \r\n", cnt);
		flag = 0;
	}
	return 0;
}


static void Init(XScuGic* IntInstance, XScuTimer* TimerInstance, u16 IntDeviceID, u16 TimerDeviceID, u16 IntID)
{
	/** Timer init  **/
	XScuTimer_Config * TimerConfPtr;
	TimerConfPtr = XScuTimer_LookupConfig(TimerDeviceID);
	XScuTimer_CfgInitialize(TimerInstance, TimerConfPtr, TimerConfPtr->BaseAddr);

	/** Interrupt init **/
	XScuGic_Config * IntConfPtr;
	IntConfPtr = XScuGic_LookupConfig(IntDeviceID);
	XScuGic_CfgInitialize(IntInstance, IntConfPtr, IntConfPtr->CpuBaseAddress);

	/** timer and interrupt config **/
	// register global Interrupt
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, IntInstance);
	// attach callback function to interrupt
	XScuGic_Connect(IntInstance, IntID, (Xil_ExceptionHandler)IntHandle, (void *)TimerInstance);

	// config timer auto reload
	XScuTimer_EnableAutoReload(TimerInstance);
	// enbale timer interrupt
	XScuTimer_EnableInterrupt(TimerInstance);
	// enable interrupt source
	XScuGic_Enable(IntInstance, IntID);
	// enable global interrupt
	Xil_ExceptionEnable();
}


static void IntHandle()
{
	flag = 1;
	cnt += 1;
	XScuTimer_ClearInterruptStatus(&TimerInst);
}
