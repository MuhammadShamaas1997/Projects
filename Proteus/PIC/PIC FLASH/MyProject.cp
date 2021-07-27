#line 1 "D:/MuhammadShamaas/Projects_Github/Proteus/PIC/PIC SPI - Copy/MyProject.c"

char Cf_Data_Port at PORTD;

sbit CF_RDY at RB7_bit;
sbit CF_WE at LATB6_bit;
sbit CF_OE at LATB5_bit;
sbit CF_CD1 at RB4_bit;
sbit CF_CE1 at LATB3_bit;
sbit CF_A2 at LATB2_bit;
sbit CF_A1 at LATB1_bit;
sbit CF_A0 at LATB0_bit;

sbit CF_RDY_direction at TRISB7_bit;
sbit CF_WE_direction at TRISB6_bit;
sbit CF_OE_direction at TRISB5_bit;
sbit CF_CD1_direction at TRISB4_bit;
sbit CF_CE1_direction at TRISB3_bit;
sbit CF_A2_direction at TRISB2_bit;
sbit CF_A1_direction at TRISB1_bit;
sbit CF_A0_direction at TRISB0_bit;


const LINE_LEN = 39;
char err_txt[20] = "FAT16 not found";
char file_contents[LINE_LEN] = "XX CF FAT16 library by Anton Rieckertn";
char filename[14] = "MIKRO00x.TXT";
unsigned short loop, loop2;
unsigned long i, size;
char Buffer[512];


void UART1_Write_Line(char *uart_text) {
 UART1_Write_Text(uart_text);
 UART1_Write(13);
 UART1_Write(10);
}


void M_Create_New_File() {
 filename[7] = 'A';
 Cf_Fat_Set_File_Date(2005,6,21,10,35,0);
 Cf_Fat_Assign(&filename, 0xA0);
 Cf_Fat_Rewrite();
 for(loop = 1; loop <= 99; loop++) {
 UART1_Write('.');
 file_contents[0] = loop / 10 + 48;
 file_contents[1] = loop % 10 + 48;
 Cf_Fat_Write(file_contents, LINE_LEN-1);
 }
}


void M_Create_Multiple_Files() {
 for(loop2 = 'B'; loop2 <= 'Z'; loop2++) {
 UART1_Write(loop2);
 filename[7] = loop2;
 Cf_Fat_Set_File_Date(2005,6,21,10,35,0);
 Cf_Fat_Assign(&filename, 0xA0);
 Cf_Fat_Rewrite();
 for(loop = 1; loop <= 44; loop++) {
 file_contents[0] = loop / 10 + 48;
 file_contents[1] = loop % 10 + 48;
 Cf_Fat_Write(file_contents, LINE_LEN-1);
 }
 }
}


void M_Open_File_Rewrite() {
 filename[7] = 'C';
 Cf_Fat_Assign(&filename, 0);
 Cf_Fat_Rewrite();
 for(loop = 1; loop <= 55; loop++) {
 file_contents[0] = loop / 10 + 48;
 file_contents[1] = loop % 10 + 48;
 Cf_Fat_Write(file_contents, LINE_LEN-1);
 }
}



void M_Open_File_Append() {
 filename[7] = 'B';
 Cf_Fat_Assign(&filename, 0);
 Cf_Fat_Set_File_Date(2009, 1, 23, 17, 22, 0);
 Cf_Fat_Append();
 Cf_Fat_Write(" for mikroElektronika 2010n", 27);
}


void M_Open_File_Read() {
 char character;

 filename[7] = 'B';
 Cf_Fat_Assign(&filename, 0);
 Cf_Fat_Reset(&size);
 for (i = 1; i <= size; i++) {
 Cf_Fat_Read(&character);
 UART1_Write(character);
 }
}



void M_Delete_File() {
 filename[7] = 'F';
 Cf_Fat_Assign(filename, 0);
 Cf_Fat_Delete();
}



void M_Test_File_Exist() {
 unsigned long fsize;
 unsigned int year;
 unsigned short month, day, hour, minute;
 unsigned char outstr[12];

 filename[7] = 'B';

 if (Cf_Fat_Assign(filename, 0)) {

 Cf_Fat_Get_File_Date(&year, &month, &day, &hour, &minute);
 UART1_Write_Text(" created: ");
 WordToStr(year, outstr);
 UART1_Write_Text(outstr);
 ByteToStr(month, outstr);
 UART1_Write_Text(outstr);
 WordToStr(day, outstr);
 UART1_Write_Text(outstr);
 WordToStr(hour, outstr);
 UART1_Write_Text(outstr);
 WordToStr(minute, outstr);
 UART1_Write_Text(outstr);


 Cf_Fat_Get_File_Date_Modified(&year, &month, &day, &hour, &minute);
 UART1_Write_Text(" modified: ");
 WordToStr(year, outstr);
 UART1_Write_Text(outstr);
 ByteToStr(month, outstr);
 UART1_Write_Text(outstr);
 WordToStr(day, outstr);
 UART1_Write_Text(outstr);
 WordToStr(hour, outstr);
 UART1_Write_Text(outstr);
 WordToStr(minute, outstr);
 UART1_Write_Text(outstr);


 fsize = Cf_Fat_Get_File_Size();
 LongToStr((signed long)fsize, outstr);
 UART1_Write_Line(outstr);
 }
 else {

 UART1_Write(0x55);
 Delay_ms(1000);
 UART1_Write(0x55);
 }
}




void M_Create_Swap_File() {
 unsigned int i;

 for(i=0; i<512; i++)
 Buffer[i] = i;

 size = Cf_Fat_Get_Swap_File(5000, "mikroE.txt", 0x20);

 if (size) {
 LongToStr((signed long)size, err_txt);
 UART1_Write_Line(err_txt);

 for(i=0; i<5000; i++) {
 Cf_Write_Sector(size++, Buffer);
 UART1_Write('.');
 }
 }
}


void main() {

 ADCON1 |= 0x0F;



 UART1_Init(19200);
 Delay_ms(10);

 UART1_Write_Line("PIC-Started");


 if (Cf_Fat_Init() == 0) {
 Delay_ms(2000);


 UART1_Write_Line("Test Start.");

 M_Create_New_File();

 M_Create_Multiple_Files();
 M_Open_File_Rewrite();
 M_Open_File_Append();
 M_Open_File_Read();
 M_Delete_File();
 M_Test_File_Exist();
 M_Create_Swap_File();

 UART1_Write_Line("Test End.");

 }
 else {
 UART1_Write_Line(err_txt);

 }

}
