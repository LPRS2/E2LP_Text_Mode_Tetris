/*
 * Copyright (c) 2009-2012 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 *
 *
 *
 */

#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xio.h"
#include "xbasic_types.h"
#include "xstatus.h"
#include "xil_io.h"
Xuint32 cursor_position;

#define GRAPHICS_MEM_OFF 0x2000000
#define TEXT_MEM_OFF 0x1000000
#define VGA_PERIPH_MEM_mWriteMemory(Address, Data) \
 	Xil_Out32(Address, (Xuint32)(Data))
#define VGA_PERIPH_MEM_mReadMemory(Address) \
 	Xil_In32(Address)
#define SCREEN_WIDTH_TEXT 480

#define lijevo 29
#define desno 23
#define ubrzaj 27
#define reset 30








void set_cursor(Xuint32 new_value) {
	cursor_position = new_value;
}

void print(char *str);

void draw_rot_square(Xuint32 BaseAddress, int pocetakR, int krajR, int pocetakK,
		int krajK) {
	int i, j, k;
	for (j = 0; j < 480; j++) {
		for (k = 0; k < (640 / 32); k++) {
			i = j * (640 / 32) + k;
			if ((j > pocetakR) && (j < krajR) && (k > pocetakK)
					&& (k < krajK)) {
				VGA_PERIPH_MEM_mWriteMemory(
						BaseAddress + GRAPHICS_MEM_OFF + i*4, 0xFFFFFFFF);
			} else {
				VGA_PERIPH_MEM_mWriteMemory(
						BaseAddress + GRAPHICS_MEM_OFF + i*4, 0x0);
			}
		}
	}
}

void clear_text_screen(Xuint32 BaseAddress) {
	int i;
	for (i = 0; i < 4800; i++) {
		VGA_PERIPH_MEM_mWriteMemory(BaseAddress + TEXT_MEM_OFF + i*4, 0x20);
	}
}

void print_string(Xuint32 BaseAddress, unsigned char string_s[], int lenght) {
	int i;
	for (i = 0; i < lenght; i++) {
		VGA_PERIPH_MEM_mWriteMemory(
				BaseAddress + TEXT_MEM_OFF + cursor_position + i*4,
				(string_s[i] - 0x40));
	}
}

void clear_graphics_screen(Xuint32 BaseAddress) {
	int i;
	for (i = 0; i < 9600; i++) {
		VGA_PERIPH_MEM_mWriteMemory(BaseAddress + GRAPHICS_MEM_OFF + i*4, 0x0);
	}
}

void draw_square(Xuint32 BaseAddress) {
	int i, j, k;
	for (j = 0; j < 480; j++) {
		for (k = 0; k < (640 / 32); k++) {
			i = j * (640 / 32) + k;
			if ((j > 200) && (j < 280) && (k > 8) && (k < 12)) {
				VGA_PERIPH_MEM_mWriteMemory(
						BaseAddress + GRAPHICS_MEM_OFF + i*4, 0xFFFFFFFF);
			} else {
				VGA_PERIPH_MEM_mWriteMemory(
						BaseAddress + GRAPHICS_MEM_OFF + i*4, 0x0);
			}
		}
	}
}
void pomeraj_kvadrat(Xuint32 BaseAddress, int row, int offset, unsigned char* str){
	int i, j;
	//for(j=0; j<480; j++){
		 set_cursor(offset + (row * SCREEN_WIDTH_TEXT));
		 VGA_PERIPH_MEM_mWriteMemory(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR + 0x0C, 1111);
			 VGA_PERIPH_MEM_mWriteMemory(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR + 0x04, 0b01);
			 VGA_PERIPH_MEM_mWriteMemory(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR + 0x10, 0xffffff);
			 print_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,str, strlen((char*)str));

	//}


}
void print_side_string(Xuint32 BaseAddress,
		int cursor_position){
	int i;
	char s = 'I';
	//for(i = 0; i < lenght; i++){
		VGA_PERIPH_MEM_mWriteMemory(
						BaseAddress + TEXT_MEM_OFF + cursor_position,
						(s /*- 0x40*/));
	//}
}
void print_score_string(Xuint32 BaseAddress,
		int cursor_position){
	int i;
	char s = 'S';
	char c = 'C';
	char o = 'O';
	char r = 'R';
	char e = 'E';

		VGA_PERIPH_MEM_mWriteMemory(
						BaseAddress + TEXT_MEM_OFF + cursor_position,
						s);
		VGA_PERIPH_MEM_mWriteMemory(
								BaseAddress + TEXT_MEM_OFF + (cursor_position + 4),
								(c));
		VGA_PERIPH_MEM_mWriteMemory(
								BaseAddress + TEXT_MEM_OFF + (cursor_position + 8),
								(o));
		VGA_PERIPH_MEM_mWriteMemory(
								BaseAddress + TEXT_MEM_OFF + (cursor_position + 12),
								(r));
		VGA_PERIPH_MEM_mWriteMemory(
								BaseAddress + TEXT_MEM_OFF + (cursor_position + 16),
								(e));

}
void print_NUMSCORE_string(Xuint32 BaseAddress,int *CheckScore,int *Deca){
	int score = (*CheckScore);
	int deca = (*Deca);

	if(score > 9){
		deca++;
		score = 0;
		*CheckScore = score;
		*Deca = deca;
		VGA_PERIPH_MEM_mWriteMemory(
								BaseAddress + TEXT_MEM_OFF + 650,
								(48+deca));
	}else
		VGA_PERIPH_MEM_mWriteMemory(
								BaseAddress + TEXT_MEM_OFF + 650,
								(48+deca));
	VGA_PERIPH_MEM_mWriteMemory(
							BaseAddress + TEXT_MEM_OFF + 654,
							(48+score));
}
void print_tetris_string(Xuint32 BaseAddress){
	    char z = 'Z';
		char e = 'E';
		char m = 'M';
		char o = 'O';
		char t = 'T';
		char r = 'R';
		char i = 'I';
		char s = 'S';
		char k = 'K';

		char z1 = '(';
		char z2 = ')';
		char c = 'C';
		char line = '-';
		char n1 = '2';
		char n2 = '0';
		char n3 = '1';
		char n4 = '5';



		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 105,
									z1);
		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 109,
									c);
		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 113,
									z2);
		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 121,
									r);
		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 125,
									t);
		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 129,
									line);
		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 133,
									r);
		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 137,
									k);

		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 117 + 320,
									n1);
		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 121 + 320,
									n2);
		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 125 + 320,
									n3);
		VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + 129 + 320,
									n4);


			VGA_PERIPH_MEM_mWriteMemory(
							BaseAddress + TEXT_MEM_OFF + 2185,
							z);
			VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + (2185 + 8),
									e);
			VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + (2185 + 16),
									m);
			VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + (2185 + 24),
									o);



			VGA_PERIPH_MEM_mWriteMemory(
									BaseAddress + TEXT_MEM_OFF + (2178 + 320),
									t);
			VGA_PERIPH_MEM_mWriteMemory(
												BaseAddress + TEXT_MEM_OFF + (2178 + 320 + 8),
												e);
			VGA_PERIPH_MEM_mWriteMemory(
												BaseAddress + TEXT_MEM_OFF + (2178 + 320 + 16),
												t);
			VGA_PERIPH_MEM_mWriteMemory(
												BaseAddress + TEXT_MEM_OFF + (2178 + 320 + 24),
												r);
			VGA_PERIPH_MEM_mWriteMemory(
												BaseAddress + TEXT_MEM_OFF + (2178 + 320 + 32),
												i);
			VGA_PERIPH_MEM_mWriteMemory(
												BaseAddress + TEXT_MEM_OFF + (2178 + 320 + 40),
												s);

}
void print_gameover_string(Xuint32 BaseAddress){
	char g = 'G';
	char a = 'A';
	char m = 'M';
	char e = 'E';
	char o = 'O';
	char v = 'V';
	char r = 'R';


	        VGA_PERIPH_MEM_mWriteMemory(
										BaseAddress + TEXT_MEM_OFF + 2275,
										g);
			VGA_PERIPH_MEM_mWriteMemory(
										BaseAddress + TEXT_MEM_OFF + 2275 + 16,
										a);
			VGA_PERIPH_MEM_mWriteMemory(
										BaseAddress + TEXT_MEM_OFF + 2275 + 32,
										m);
			VGA_PERIPH_MEM_mWriteMemory(
										BaseAddress + TEXT_MEM_OFF + 2275 + 48,
										e);
			VGA_PERIPH_MEM_mWriteMemory(
										BaseAddress + TEXT_MEM_OFF + 2275 + 320 + 48,
										o);
			VGA_PERIPH_MEM_mWriteMemory(
										BaseAddress + TEXT_MEM_OFF + 2275 + 320 + 64,
										v);
			VGA_PERIPH_MEM_mWriteMemory(
										BaseAddress + TEXT_MEM_OFF + 2275 + 320 + 80,
										e);
			VGA_PERIPH_MEM_mWriteMemory(
										BaseAddress + TEXT_MEM_OFF + 2275 + 320 + 96,
										r);



}

void print_rot_string(Xuint32 BaseAddress, unsigned char string_s[], int lenght,
		int cursor_position,int matrix[][10], int columnFree[10]) {
	int i,j,a;
	int t;
	//unsigned char SCC[2];

	int matrixTemp[30][10];
	for (t = 0; t < lenght; t++) {
		VGA_PERIPH_MEM_mWriteMemory(
				BaseAddress + TEXT_MEM_OFF + cursor_position + t*1,
				(string_s[t] - 0x40));
	}



	if(matrix[29][0] == 1 && matrix[29][1] == 1 && matrix[29][2] == 1 &&
			matrix[29][3] == 1 && matrix[29][4] == 1 && matrix[29][5] == 1
		&& matrix[29][6] == 1 && matrix[29][7] == 1 && matrix[29][8] == 1 && matrix[29][9] == 1){





		for(j = 0; j < 10; j++){
			matrixTemp[0][j] = 0;
			columnFree[j]++;
		}

		for(i = 0; i < 29; i++)
			for(j = 0; j < 10; j++){

				matrixTemp[i+1][j] = matrix[i][j];
			}

		for(i = 0; i < 30; i++)
				for(j = 0; j < 10; j++)
					matrix[i][j] = matrixTemp[i][j];


		}






	for(i = 0; i < 30; i++)
		for(j = 0; j < 10; j++){
			if(matrix[i][j] == 1){
				for (a = 0; a < lenght; a++) {
					VGA_PERIPH_MEM_mWriteMemory(
						BaseAddress + TEXT_MEM_OFF + (i*160 + j*4 + a)+40,
							(string_s[t] - 0x40));
				}
			}
		}

}

void sleep() {
	int i;
	for (i = 0; i < 6000000; i++) {
	}
}
void sleepSlower() {
	int i;
	for (i = 0; i < 2000000; i++) {
	}
}

void sleepSlower2() {
	int i;
	for (i = 0; i < 600000; i++) {
	}
}


void initialiseMatrix(int matrix[30][10]){

	matrix[29][0] = 1;matrix[29][1] = 1;matrix[29][2] = 1;matrix[29][3] = 1;matrix[29][4] = 1;matrix[29][5] = 1;matrix[29][6] = 1;matrix[29][7] = 1;matrix[29][8] = 1;matrix[29][9] = 1;
	matrix[28][0] = 1;matrix[28][1] = 1;matrix[28][2] = 1;matrix[28][3] = 1;matrix[28][4] = 1;matrix[28][5] = 1;matrix[28][6] = 1;matrix[28][7] = 1;matrix[28][8] = 1;matrix[28][9] = 1;
	matrix[27][0] = 0;matrix[27][1] = 1;matrix[27][2] = 1;matrix[27][3] = 1;matrix[27][4] = 1;matrix[27][5] = 1;matrix[27][6] = 1;matrix[27][7] = 1;matrix[27][8] = 1;matrix[27][9] = 1;
	matrix[26][0] = 0;matrix[26][1] = 1;matrix[26][2] = 1;matrix[26][3] = 1;matrix[26][4] = 1;matrix[26][5] = 1;matrix[26][6] = 1;matrix[26][7] = 0;matrix[26][8] = 1;matrix[26][9] = 1;
	matrix[25][0] = 0;matrix[25][1] = 1;matrix[25][2] = 1;matrix[25][3] = 0;matrix[25][4] = 1;matrix[25][5] = 1;matrix[25][6] = 1;matrix[25][7] = 0;matrix[25][8] = 1;matrix[25][9] = 1;
	matrix[24][0] = 0;matrix[24][1] = 1;matrix[24][2] = 1;matrix[24][3] = 0;matrix[24][4] = 1;matrix[24][5] = 0;matrix[24][6] = 1;matrix[24][7] = 0;matrix[24][8] = 1;matrix[24][9] = 0;


}

int checkLastRow(int matrix[30][10]){

	if(matrix[29][0] == 1 && matrix[29][1] == 1 && matrix[29][2] == 1 &&
			matrix[29][3] == 1 && matrix[29][4] == 1 && matrix[29][5] == 1
			&& matrix[29][6] == 1 && matrix[29][7] == 1 && matrix[29][8] == 1 && matrix[29][9] == 1)
		return 1;
	else return 0;
}

int checkGameOver(int columnFree[10]){

	int i;

	for(i = 0; i < 10; i++)
		if(columnFree[i] == 0) return 1;

	return 0;

}



void resetPresed(int matrix[30][10],int columnFree[10],int *start,int *CheckScore,int *Deca,int *position,int *cursorPosition){

	int i,j;

	for(i = 0; i < 30; i++)
		for(j = 0; j < 10; j++)
			matrix[i][j] = 0;

	for(i = 0; i < 10; i++)
		columnFree[i] = 29;

	*cursorPosition = 56;
   *CheckScore = 0;
   *Deca = 0;
   *position = 4;

}
int main() {

	int matrix[30][10];
	int x = Xil_In8(XPAR_MY_PERIPHERAL_0_BASEADDR);//iscitavanje prekidaca
	int cursor_position = 56;
	int next_step = 640/4;
	int i,j;
	int columnFree[10] = {27,23,23,25,23,24,23,26,23,24};
	int currentColumn;
	int start = 0;
	int position = 4;
	unsigned char s[] = " ";
	int length = 2;
	int CheckScore = 0;
	int Deca = 0;


		for(i = 0; i < 30; i++)
			for(j = 0; j < 10; j++)
				matrix[i][j] = 0;

		initialiseMatrix(matrix);

		while(1){

			x = Xil_In8(XPAR_MY_PERIPHERAL_0_BASEADDR);

			if(x == reset){
			resetPresed(matrix,columnFree,&start,&CheckScore,&Deca,&position,&cursor_position);
			} else{
			if(checkGameOver(columnFree) == 0){

			if(checkLastRow(matrix)) CheckScore++;

			sleepSlower();


			clear_text_screen(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR);
			VGA_PERIPH_MEM_mWriteMemory(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR + 0x04, 0b01);	//displey_mode, text
			VGA_PERIPH_MEM_mWriteMemory(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR + 0x0C, 0b0001);	//velicina
			VGA_PERIPH_MEM_mWriteMemory(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR + 0x010, 0xffff00); //boja

		if(position > 8)
			currentColumn = 9;
		else
			currentColumn = position;

		if( start < columnFree[currentColumn]) {
			start++;
			print_rot_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR, s, length,
			cursor_position,matrix,columnFree);

			}else{

			matrix[columnFree[currentColumn]][currentColumn] = 1;
			if(checkLastRow(matrix)) CheckScore++;
			columnFree[currentColumn]--;
			print_rot_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR, s, length,
			cursor_position,matrix,columnFree);

			start = 0;
			cursor_position = 56;
			position = 4;
			}

			cursor_position = cursor_position + next_step;
			//Playground


			print_NUMSCORE_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,&CheckScore,&Deca);
			print_tetris_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,39);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,199);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,359);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,519);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,679);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,839);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,999);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1159);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1319);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1479);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1639);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1799);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1959);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2119);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2279);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2439);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2599);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2759);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2919);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3079);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3239);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3399);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3559);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3719);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3879);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4039);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4199);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4359);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4519);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4679);

			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,81);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,241);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,401);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,561);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,721);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,881);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1041);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1201);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1361);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1521);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1681);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1841);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2001);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2161);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2321);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2481);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2641);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2801);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2961);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3121);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3281);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3441);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3601);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3761);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3921);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4081);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4241);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4401);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4561);
			print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4721);


			print_score_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,330);



			if(x == ubrzaj && start+2 < columnFree[position]){
				sleepSlower();
				sleepSlower();

				if(cursor_position += (columnFree[position]-start-3)*160 <= (columnFree[currentColumn])*next_step){
					clear_text_screen(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR);
					cursor_position += (columnFree[position]-start-3)*160;
					start += (columnFree[position]-start-3);
					print_rot_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR, s, length,
					cursor_position,matrix,columnFree);



				print_NUMSCORE_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,&CheckScore,&Deca);
				print_tetris_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,39);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,199);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,359);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,519);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,679);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,839);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,999);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1159);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1319);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1479);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1639);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1799);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1959);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2119);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2279);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2439);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2599);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2759);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2919);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3079);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3239);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3399);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3559);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3719);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3879);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4039);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4199);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4359);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4519);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4679);

				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,81);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,241);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,401);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,561);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,721);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,881);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1041);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1201);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1361);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1521);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1681);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1841);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2001);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2161);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2321);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2481);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2641);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2801);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2961);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3121);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3281);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3441);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3601);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3761);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3921);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4081);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4241);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4401);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4561);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4721);

				print_score_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,330);
				}

			}


			while(x == desno){

				if(position > 8 || (  start*160 >= columnFree[position+1]*160   )) break;
				else{
				position += 1;
				cursor_position = cursor_position + 4;

				clear_text_screen(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR);

				print_rot_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR, s, length,
				cursor_position,matrix,columnFree);



				print_NUMSCORE_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,&CheckScore,&Deca);

				print_tetris_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,39);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,199);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,359);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,519);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,679);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,839);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,999);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1159);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1319);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1479);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1639);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1799);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1959);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2119);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2279);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2439);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2599);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2759);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2919);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3079);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3239);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3399);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3559);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3719);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3879);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4039);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4199);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4359);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4519);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4679);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,81);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,241);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,401);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,561);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,721);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,881);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1041);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1201);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1361);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1521);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1681);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1841);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2001);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2161);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2321);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2481);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2641);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2801);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2961);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3121);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3281);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3441);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3601);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3761);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3921);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4081);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4241);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4401);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4561);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4721);

				print_score_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,330);

				break;
				}


			}


			while(x == lijevo){

				if(position < 1|| (  start*160 >= columnFree[position-1]*160  )) break;
				else{
				position -= 1;
				cursor_position = cursor_position - 4;

				clear_text_screen(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR);
				print_rot_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR, s, length,
				cursor_position,matrix,columnFree);

				print_NUMSCORE_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,&CheckScore,&Deca);

				print_tetris_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,39);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,199);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,359);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,519);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,679);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,839);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,999);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1159);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1319);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1479);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1639);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1799);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1959);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2119);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2279);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2439);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2599);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2759);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2919);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3079);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3239);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3399);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3559);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3719);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3879);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4039);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4199);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4359);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4519);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4679);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,81);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,241);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,401);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,561);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,721);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,881);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1041);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1201);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1361);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1521);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1681);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,1841);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2001);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2161);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2321);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2481);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2641);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2801);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,2961);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3121);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3281);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3441);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3601);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3761);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,3921);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4081);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4241);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4401);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4561);
				print_side_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,4721);

				print_score_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR,330);

			break;
				}


			}


	}else {

		sleep();
		clear_text_screen(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR);
		print_gameover_string(XPAR_VGA_PERIPH_MEM_0_S_AXI_MEM0_BASEADDR);

	}


		}
}

		return 0;
}


