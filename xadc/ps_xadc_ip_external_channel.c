

#include "xsysmon.h"
#include "xparameters.h"
#include "stdio.h"
#include "xgpio.h"
#include "platform.h"
#include <unistd.h>



#define SYSMON_DEVICE_ID 	XPAR_SYSMON_0_DEVICE_ID
#define KEY_DEVICE_ID		XPAR_AXI_GPIO_0_DEVICE_ID
#define LED_DEVICE_ID		XPAR_AXI_GPIO_1_DEVICE_ID


#define Enable_CH	XSM_SEQ_CH_AUX01 | \
				XSM_SEQ_CH_AUX06 | \
				XSM_SEQ_CH_AUX09 | \
				XSM_SEQ_CH_AUX15


static void GpioInit();
static void XadcInit(XSysMon * XadcInstance, u16 DeviceId);


XGpio 	LedInst ;
XGpio 	KeyInst ;
XSysMon	XadcInst;



int main()
{
	u16 	adcdata[4];
	uint 	keystate;
	u8		cnt;
    init_platform();
    GpioInit();
    XadcInit(&XadcInst, SYSMON_DEVICE_ID);

//    XSysMon_StartAdcConversion(&XadcInst);
    while(1)
    {
    	for(cnt=0;cnt<=3;cnt++)
    	{
			/*ch1 : 17
			 *ch6 : 22
			 *ch9 : 25
			 *ch15: 31
			 * */
    		adcdata[0] = 0;
    		if(cnt==0) adcdata[0] = XSysMon_GetAdcData(&XadcInst, 17);
    		if(cnt==1) adcdata[1] = XSysMon_GetAdcData(&XadcInst, 25);
    		if(cnt==2) adcdata[2] = XSysMon_GetAdcData(&XadcInst, 22);
    		if(cnt==3) adcdata[3] = XSysMon_GetAdcData(&XadcInst, 31);

//    		adcfdata[cnt] = (adcdata[cnt] & 0XFFF0) / 4095;
    		printf("the voltage of ch %d is : %.2fV \r\n", cnt, ((((float)(adcdata[cnt]))* (3.3f))/65536.0f));
    		usleep(20000);
    	}
    	keystate = XGpio_DiscreteRead(&KeyInst, 1);
    	XGpio_DiscreteWrite(&LedInst, 1, keystate);

    	if(cnt == 3) cnt = 0;

    }
    cleanup_platform();
    return 0;
}




static void GpioInit()
{
	XGpio_Initialize(&LedInst, LED_DEVICE_ID);
	XGpio_Initialize(&KeyInst, KEY_DEVICE_ID);
	XGpio_SetDataDirection(&LedInst, 1, 0x0); // 0 -> output
	XGpio_SetDataDirection(&KeyInst, 1, 0xFFFF); // 1 -> input
	XGpio_DiscreteWrite(&LedInst, 1, 0x0); // init output
}



static void XadcInit(XSysMon * XadcInstance, u16 DeviceId)
{
	XSysMon_Config* XSysMonConfPtr;
	XSysMonConfPtr = XSysMon_LookupConfig(DeviceId);
	XSysMon_CfgInitialize(XadcInstance, XSysMonConfPtr, XSysMonConfPtr->BaseAddress);
	XSysMon_SetSequencerMode(XadcInstance, XSM_SEQ_MODE_SAFE);
	XSysMon_SetCalibEnables(XadcInstance, XSM_CFR1_CAL_ADC_OFFSET_MASK); // adc offset calibration
	XSysMon_SetSeqInputMode(XadcInstance, 0x1); // differential input

	/* Enable ch1,6,9,15 channels*/
	XSysMon_SetSeqChEnables(XadcInstance, Enable_CH);
	XSysMon_SetSequencerMode(XadcInstance, XSM_SEQ_MODE_CONTINPASS);
	XSysMon_GetStatus(XadcInstance); /* Clear the old status */
	while ((XSysMon_GetStatus(XadcInstance) & XSM_SR_EOS_MASK) != XSM_SR_EOS_MASK);

	XSysMon_GetStatus(XadcInstance);	/* Clear the latched status */
}





