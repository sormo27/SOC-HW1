#include "xparameters.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "sleep.h"

//------------------------------------------------------
// AXI IP ���O�����}����
//------------------------------------------------------
#define BASE_ADDR    XPAR_MYIP_0_S00_AXI_BASEADDR
#define REG_PATTERN  0x08    // �g�J LED pattern�]AXI �H�s�� slv_reg2�^
#define REG_STATUS   0x0C    // Ū�� Switch ���A�]AXI �H�s�� slv_reg3�^

int main()
{
    // �ʺA�ĪG���Ȧs���A�ܼ�
    u8 shift_l = 0x01;       // �]���O ��
    u8 shift_r = 0x80;       // �]���O ��
    u8 breathe = 0x00;       // �I�l���G
    u8 toggle  = 0x00;       // �{�{���A

    // �蹳���y�ĪG���A
    static u8 mirror_pos = 0x80;  // �q LED7 �}�l���k���y
    static u8 fade_mask  = 0x00;  // �O�d�e�����y���ݼv

    xil_printf("=== �h�Ҧ����w LED ��� (SW[7:0]) �Ұ� ===\r\n");

    while (1) {
        // Ū���}�����A�]SW[7:0]�^�A�� PL �۰ʧ�s slv_reg3 �H�s��
        u8 sw = Xil_In32(BASE_ADDR + REG_STATUS) & 0xFF;
        u8 pattern = 0x00;

        //------------------------------------------------------
        // �U�}�������\��]�i�h�ӦP�ɶ}�ҡA�ĪG�|�[�^
        //------------------------------------------------------

        if (sw & 0x01) pattern |= shift_l;                       // SW0�G�]���O ��
        if (sw & 0x02) pattern |= shift_r;                       // SW1�G�]���O ��
        if (sw & 0x04) pattern |= breathe++;                     // SW2�G�I�l�O�]���G�^
        if (sw & 0x08) pattern |= (toggle++ & 0x01) ? 0xFF : 0x00; // SW3�G�{�{

        if (sw & 0x10) pattern |= 0xAA;                          // SW4�G�_�ƿO�G
        if (sw & 0x20) pattern |= 0x55;                          // SW5�G���ƿO�G

        if (sw & 0x40) pattern |= breathe--;                     // SW6�G�I�l�O�ϦV�]���G�^
        if (sw & 0x80) pattern = 0xFF;     // SW7�G�j����G�]�u���׳̰��^

        //------------------------------------------------------
        // �g�J AXI �H�s�� �� ��s LED ���
        //------------------------------------------------------
        Xil_Out32(BASE_ADDR + REG_PATTERN, pattern);

        //------------------------------------------------------
        // ��s�ʺA�ܼơ]�첾�B�I�l�B�{�{�^
        //------------------------------------------------------
        if (sw & 0x01) shift_l = (shift_l == 0x80) ? 0x01 : (shift_l << 1);
        if (sw & 0x02) shift_r = (shift_r == 0x01) ? 0x80 : (shift_r >> 1);

        usleep(150000); // �C 150ms ��s�@��
    }

    return 0;
}
