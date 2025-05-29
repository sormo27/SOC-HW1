#include "xparameters.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "sleep.h"

//------------------------------------------------------
// AXI IP 的記憶體位址對應
//------------------------------------------------------
#define BASE_ADDR    XPAR_MYIP_0_S00_AXI_BASEADDR
#define REG_PATTERN  0x08    // 寫入 LED pattern（AXI 寄存器 slv_reg2）
#define REG_STATUS   0x0C    // 讀取 Switch 狀態（AXI 寄存器 slv_reg3）

int main()
{
    // 動態效果的暫存狀態變數
    u8 shift_l = 0x01;       // 跑馬燈 ←
    u8 shift_r = 0x80;       // 跑馬燈 →
    u8 breathe = 0x00;       // 呼吸漸亮
    u8 toggle  = 0x00;       // 閃爍狀態

    // 鏡像掃描效果狀態
    static u8 mirror_pos = 0x80;  // 從 LED7 開始往右掃描
    static u8 fade_mask  = 0x00;  // 保留前次掃描的殘影

    xil_printf("=== 多模式炫泡 LED 控制器 (SW[7:0]) 啟動 ===\r\n");

    while (1) {
        // 讀取開關狀態（SW[7:0]），由 PL 自動更新 slv_reg3 寄存器
        u8 sw = Xil_In32(BASE_ADDR + REG_STATUS) & 0xFF;
        u8 pattern = 0x00;

        //------------------------------------------------------
        // 各開關對應功能（可多個同時開啟，效果疊加）
        //------------------------------------------------------

        if (sw & 0x01) pattern |= shift_l;                       // SW0：跑馬燈 ←
        if (sw & 0x02) pattern |= shift_r;                       // SW1：跑馬燈 →
        if (sw & 0x04) pattern |= breathe++;                     // SW2：呼吸燈（漸亮）
        if (sw & 0x08) pattern |= (toggle++ & 0x01) ? 0xFF : 0x00; // SW3：閃爍

        if (sw & 0x10) pattern |= 0xAA;                          // SW4：奇數燈亮
        if (sw & 0x20) pattern |= 0x55;                          // SW5：偶數燈亮

        if (sw & 0x40) pattern |= breathe--;                     // SW6：呼吸燈反向（漸亮）
        if (sw & 0x80) pattern = 0xFF;     // SW7：強制全亮（優先度最高）

        //------------------------------------------------------
        // 寫入 AXI 寄存器 → 更新 LED 顯示
        //------------------------------------------------------
        Xil_Out32(BASE_ADDR + REG_PATTERN, pattern);

        //------------------------------------------------------
        // 更新動態變數（位移、呼吸、閃爍）
        //------------------------------------------------------
        if (sw & 0x01) shift_l = (shift_l == 0x80) ? 0x01 : (shift_l << 1);
        if (sw & 0x02) shift_r = (shift_r == 0x01) ? 0x80 : (shift_r >> 1);

        usleep(150000); // 每 150ms 更新一次
    }

    return 0;
}
