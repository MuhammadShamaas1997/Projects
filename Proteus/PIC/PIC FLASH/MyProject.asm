
_UART1_Write_Line:

;MyProject.c,32 :: 		void UART1_Write_Line(char *uart_text) {
;MyProject.c,33 :: 		UART1_Write_Text(uart_text);
	MOVF        FARG_UART1_Write_Line_uart_text+0, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVF        FARG_UART1_Write_Line_uart_text+1, 0 
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,34 :: 		UART1_Write(13);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;MyProject.c,35 :: 		UART1_Write(10);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;MyProject.c,36 :: 		}
L_end_UART1_Write_Line:
	RETURN      0
; end of _UART1_Write_Line

_M_Create_New_File:

;MyProject.c,39 :: 		void M_Create_New_File() {
;MyProject.c,40 :: 		filename[7] = 'A';
	MOVLW       65
	MOVWF       _filename+7 
;MyProject.c,41 :: 		Cf_Fat_Set_File_Date(2005,6,21,10,35,0); // Set file date & time info
	MOVLW       213
	MOVWF       FARG_Cf_Fat_Set_File_Date_year+0 
	MOVLW       7
	MOVWF       FARG_Cf_Fat_Set_File_Date_year+1 
	MOVLW       6
	MOVWF       FARG_Cf_Fat_Set_File_Date_month+0 
	MOVLW       21
	MOVWF       FARG_Cf_Fat_Set_File_Date_day+0 
	MOVLW       10
	MOVWF       FARG_Cf_Fat_Set_File_Date_hours+0 
	MOVLW       35
	MOVWF       FARG_Cf_Fat_Set_File_Date_mins+0 
	CLRF        FARG_Cf_Fat_Set_File_Date_seconds+0 
	CALL        _Cf_Fat_Set_File_Date+0, 0
;MyProject.c,42 :: 		Cf_Fat_Assign(&filename, 0xA0);      // Find existing file or create a new one
	MOVLW       _filename+0
	MOVWF       FARG_Cf_Fat_Assign_filename+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Cf_Fat_Assign_filename+1 
	MOVLW       160
	MOVWF       FARG_Cf_Fat_Assign_file_cre_attr+0 
	CALL        _Cf_Fat_Assign+0, 0
;MyProject.c,43 :: 		Cf_Fat_Rewrite();                    // To clear file and start with new data
	CALL        _Cf_Fat_Rewrite+0, 0
;MyProject.c,44 :: 		for(loop = 1; loop <= 99; loop++) {
	MOVLW       1
	MOVWF       _loop+0 
L_M_Create_New_File0:
	MOVF        _loop+0, 0 
	SUBLW       99
	BTFSS       STATUS+0, 0 
	GOTO        L_M_Create_New_File1
;MyProject.c,45 :: 		UART1_Write('.');
	MOVLW       46
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;MyProject.c,46 :: 		file_contents[0] = loop / 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+0 
;MyProject.c,47 :: 		file_contents[1] = loop % 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+1 
;MyProject.c,48 :: 		Cf_Fat_Write(file_contents, LINE_LEN-1);   // write data to the assigned file
	MOVLW       _file_contents+0
	MOVWF       FARG_Cf_Fat_Write_fdata+0 
	MOVLW       hi_addr(_file_contents+0)
	MOVWF       FARG_Cf_Fat_Write_fdata+1 
	MOVLW       38
	MOVWF       FARG_Cf_Fat_Write_data_len+0 
	MOVLW       0
	MOVWF       FARG_Cf_Fat_Write_data_len+1 
	CALL        _Cf_Fat_Write+0, 0
;MyProject.c,44 :: 		for(loop = 1; loop <= 99; loop++) {
	INCF        _loop+0, 1 
;MyProject.c,49 :: 		}
	GOTO        L_M_Create_New_File0
L_M_Create_New_File1:
;MyProject.c,50 :: 		}
L_end_M_Create_New_File:
	RETURN      0
; end of _M_Create_New_File

_M_Create_Multiple_Files:

;MyProject.c,53 :: 		void M_Create_Multiple_Files() {
;MyProject.c,54 :: 		for(loop2 = 'B'; loop2 <= 'Z'; loop2++) {
	MOVLW       66
	MOVWF       _loop2+0 
L_M_Create_Multiple_Files3:
	MOVF        _loop2+0, 0 
	SUBLW       90
	BTFSS       STATUS+0, 0 
	GOTO        L_M_Create_Multiple_Files4
;MyProject.c,55 :: 		UART1_Write(loop2);                  // signal the progress
	MOVF        _loop2+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;MyProject.c,56 :: 		filename[7] = loop2;                 // set filename
	MOVF        _loop2+0, 0 
	MOVWF       _filename+7 
;MyProject.c,57 :: 		Cf_Fat_Set_File_Date(2005,6,21,10,35,0); // Set file date & time info
	MOVLW       213
	MOVWF       FARG_Cf_Fat_Set_File_Date_year+0 
	MOVLW       7
	MOVWF       FARG_Cf_Fat_Set_File_Date_year+1 
	MOVLW       6
	MOVWF       FARG_Cf_Fat_Set_File_Date_month+0 
	MOVLW       21
	MOVWF       FARG_Cf_Fat_Set_File_Date_day+0 
	MOVLW       10
	MOVWF       FARG_Cf_Fat_Set_File_Date_hours+0 
	MOVLW       35
	MOVWF       FARG_Cf_Fat_Set_File_Date_mins+0 
	CLRF        FARG_Cf_Fat_Set_File_Date_seconds+0 
	CALL        _Cf_Fat_Set_File_Date+0, 0
;MyProject.c,58 :: 		Cf_Fat_Assign(&filename, 0xA0);      // find existing file or create a new one
	MOVLW       _filename+0
	MOVWF       FARG_Cf_Fat_Assign_filename+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Cf_Fat_Assign_filename+1 
	MOVLW       160
	MOVWF       FARG_Cf_Fat_Assign_file_cre_attr+0 
	CALL        _Cf_Fat_Assign+0, 0
;MyProject.c,59 :: 		Cf_Fat_Rewrite();                    // To clear file and start with new data
	CALL        _Cf_Fat_Rewrite+0, 0
;MyProject.c,60 :: 		for(loop = 1; loop <= 44; loop++) {
	MOVLW       1
	MOVWF       _loop+0 
L_M_Create_Multiple_Files6:
	MOVF        _loop+0, 0 
	SUBLW       44
	BTFSS       STATUS+0, 0 
	GOTO        L_M_Create_Multiple_Files7
;MyProject.c,61 :: 		file_contents[0] = loop / 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+0 
;MyProject.c,62 :: 		file_contents[1] = loop % 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+1 
;MyProject.c,63 :: 		Cf_Fat_Write(file_contents, LINE_LEN-1);   // write data to the assigned file
	MOVLW       _file_contents+0
	MOVWF       FARG_Cf_Fat_Write_fdata+0 
	MOVLW       hi_addr(_file_contents+0)
	MOVWF       FARG_Cf_Fat_Write_fdata+1 
	MOVLW       38
	MOVWF       FARG_Cf_Fat_Write_data_len+0 
	MOVLW       0
	MOVWF       FARG_Cf_Fat_Write_data_len+1 
	CALL        _Cf_Fat_Write+0, 0
;MyProject.c,60 :: 		for(loop = 1; loop <= 44; loop++) {
	INCF        _loop+0, 1 
;MyProject.c,64 :: 		}
	GOTO        L_M_Create_Multiple_Files6
L_M_Create_Multiple_Files7:
;MyProject.c,54 :: 		for(loop2 = 'B'; loop2 <= 'Z'; loop2++) {
	INCF        _loop2+0, 1 
;MyProject.c,65 :: 		}
	GOTO        L_M_Create_Multiple_Files3
L_M_Create_Multiple_Files4:
;MyProject.c,66 :: 		}
L_end_M_Create_Multiple_Files:
	RETURN      0
; end of _M_Create_Multiple_Files

_M_Open_File_Rewrite:

;MyProject.c,69 :: 		void M_Open_File_Rewrite() {
;MyProject.c,70 :: 		filename[7] = 'C';
	MOVLW       67
	MOVWF       _filename+7 
;MyProject.c,71 :: 		Cf_Fat_Assign(&filename, 0);
	MOVLW       _filename+0
	MOVWF       FARG_Cf_Fat_Assign_filename+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Cf_Fat_Assign_filename+1 
	CLRF        FARG_Cf_Fat_Assign_file_cre_attr+0 
	CALL        _Cf_Fat_Assign+0, 0
;MyProject.c,72 :: 		Cf_Fat_Rewrite();
	CALL        _Cf_Fat_Rewrite+0, 0
;MyProject.c,73 :: 		for(loop = 1; loop <= 55; loop++) {
	MOVLW       1
	MOVWF       _loop+0 
L_M_Open_File_Rewrite9:
	MOVF        _loop+0, 0 
	SUBLW       55
	BTFSS       STATUS+0, 0 
	GOTO        L_M_Open_File_Rewrite10
;MyProject.c,74 :: 		file_contents[0] = loop / 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+0 
;MyProject.c,75 :: 		file_contents[1] = loop % 10 + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        _loop+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       _file_contents+1 
;MyProject.c,76 :: 		Cf_Fat_Write(file_contents, LINE_LEN-1);     // write data to the assigned file
	MOVLW       _file_contents+0
	MOVWF       FARG_Cf_Fat_Write_fdata+0 
	MOVLW       hi_addr(_file_contents+0)
	MOVWF       FARG_Cf_Fat_Write_fdata+1 
	MOVLW       38
	MOVWF       FARG_Cf_Fat_Write_data_len+0 
	MOVLW       0
	MOVWF       FARG_Cf_Fat_Write_data_len+1 
	CALL        _Cf_Fat_Write+0, 0
;MyProject.c,73 :: 		for(loop = 1; loop <= 55; loop++) {
	INCF        _loop+0, 1 
;MyProject.c,77 :: 		}
	GOTO        L_M_Open_File_Rewrite9
L_M_Open_File_Rewrite10:
;MyProject.c,78 :: 		}
L_end_M_Open_File_Rewrite:
	RETURN      0
; end of _M_Open_File_Rewrite

_M_Open_File_Append:

;MyProject.c,82 :: 		void M_Open_File_Append() {
;MyProject.c,83 :: 		filename[7] = 'B';
	MOVLW       66
	MOVWF       _filename+7 
;MyProject.c,84 :: 		Cf_Fat_Assign(&filename, 0);
	MOVLW       _filename+0
	MOVWF       FARG_Cf_Fat_Assign_filename+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Cf_Fat_Assign_filename+1 
	CLRF        FARG_Cf_Fat_Assign_file_cre_attr+0 
	CALL        _Cf_Fat_Assign+0, 0
;MyProject.c,85 :: 		Cf_Fat_Set_File_Date(2009, 1, 23, 17, 22, 0);
	MOVLW       217
	MOVWF       FARG_Cf_Fat_Set_File_Date_year+0 
	MOVLW       7
	MOVWF       FARG_Cf_Fat_Set_File_Date_year+1 
	MOVLW       1
	MOVWF       FARG_Cf_Fat_Set_File_Date_month+0 
	MOVLW       23
	MOVWF       FARG_Cf_Fat_Set_File_Date_day+0 
	MOVLW       17
	MOVWF       FARG_Cf_Fat_Set_File_Date_hours+0 
	MOVLW       22
	MOVWF       FARG_Cf_Fat_Set_File_Date_mins+0 
	CLRF        FARG_Cf_Fat_Set_File_Date_seconds+0 
	CALL        _Cf_Fat_Set_File_Date+0, 0
;MyProject.c,86 :: 		Cf_Fat_Append();                                    // Prepare file for append
	CALL        _Cf_Fat_Append+0, 0
;MyProject.c,87 :: 		Cf_Fat_Write(" for mikroElektronika 2010n", 27);   // Write data to assigned file
	MOVLW       ?lstr1_MyProject+0
	MOVWF       FARG_Cf_Fat_Write_fdata+0 
	MOVLW       hi_addr(?lstr1_MyProject+0)
	MOVWF       FARG_Cf_Fat_Write_fdata+1 
	MOVLW       27
	MOVWF       FARG_Cf_Fat_Write_data_len+0 
	MOVLW       0
	MOVWF       FARG_Cf_Fat_Write_data_len+1 
	CALL        _Cf_Fat_Write+0, 0
;MyProject.c,88 :: 		}
L_end_M_Open_File_Append:
	RETURN      0
; end of _M_Open_File_Append

_M_Open_File_Read:

;MyProject.c,91 :: 		void M_Open_File_Read() {
;MyProject.c,94 :: 		filename[7] = 'B';
	MOVLW       66
	MOVWF       _filename+7 
;MyProject.c,95 :: 		Cf_Fat_Assign(&filename, 0);
	MOVLW       _filename+0
	MOVWF       FARG_Cf_Fat_Assign_filename+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Cf_Fat_Assign_filename+1 
	CLRF        FARG_Cf_Fat_Assign_file_cre_attr+0 
	CALL        _Cf_Fat_Assign+0, 0
;MyProject.c,96 :: 		Cf_Fat_Reset(&size);             // To read file, procedure returns size of file
	MOVLW       _size+0
	MOVWF       FARG_Cf_Fat_Reset_size+0 
	MOVLW       hi_addr(_size+0)
	MOVWF       FARG_Cf_Fat_Reset_size+1 
	CALL        _Cf_Fat_Reset+0, 0
;MyProject.c,97 :: 		for (i = 1; i <= size; i++) {
	MOVLW       1
	MOVWF       _i+0 
	MOVLW       0
	MOVWF       _i+1 
	MOVWF       _i+2 
	MOVWF       _i+3 
L_M_Open_File_Read12:
	MOVF        _i+3, 0 
	SUBWF       _size+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Open_File_Read35
	MOVF        _i+2, 0 
	SUBWF       _size+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Open_File_Read35
	MOVF        _i+1, 0 
	SUBWF       _size+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Open_File_Read35
	MOVF        _i+0, 0 
	SUBWF       _size+0, 0 
L__M_Open_File_Read35:
	BTFSS       STATUS+0, 0 
	GOTO        L_M_Open_File_Read13
;MyProject.c,98 :: 		Cf_Fat_Read(&character);
	MOVLW       M_Open_File_Read_character_L0+0
	MOVWF       FARG_Cf_Fat_Read_bdata+0 
	MOVLW       hi_addr(M_Open_File_Read_character_L0+0)
	MOVWF       FARG_Cf_Fat_Read_bdata+1 
	CALL        _Cf_Fat_Read+0, 0
;MyProject.c,99 :: 		UART1_Write(character);        // Write data to UART
	MOVF        M_Open_File_Read_character_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;MyProject.c,97 :: 		for (i = 1; i <= size; i++) {
	MOVLW       1
	ADDWF       _i+0, 1 
	MOVLW       0
	ADDWFC      _i+1, 1 
	ADDWFC      _i+2, 1 
	ADDWFC      _i+3, 1 
;MyProject.c,100 :: 		}
	GOTO        L_M_Open_File_Read12
L_M_Open_File_Read13:
;MyProject.c,101 :: 		}
L_end_M_Open_File_Read:
	RETURN      0
; end of _M_Open_File_Read

_M_Delete_File:

;MyProject.c,105 :: 		void M_Delete_File() {
;MyProject.c,106 :: 		filename[7] = 'F';
	MOVLW       70
	MOVWF       _filename+7 
;MyProject.c,107 :: 		Cf_Fat_Assign(filename, 0);
	MOVLW       _filename+0
	MOVWF       FARG_Cf_Fat_Assign_filename+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Cf_Fat_Assign_filename+1 
	CLRF        FARG_Cf_Fat_Assign_file_cre_attr+0 
	CALL        _Cf_Fat_Assign+0, 0
;MyProject.c,108 :: 		Cf_Fat_Delete();
	CALL        _Cf_Fat_Delete+0, 0
;MyProject.c,109 :: 		}
L_end_M_Delete_File:
	RETURN      0
; end of _M_Delete_File

_M_Test_File_Exist:

;MyProject.c,113 :: 		void M_Test_File_Exist() {
;MyProject.c,119 :: 		filename[7] = 'B';       //uncomment this line to search for file that DOES exists
	MOVLW       66
	MOVWF       _filename+7 
;MyProject.c,121 :: 		if (Cf_Fat_Assign(filename, 0)) {
	MOVLW       _filename+0
	MOVWF       FARG_Cf_Fat_Assign_filename+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Cf_Fat_Assign_filename+1 
	CLRF        FARG_Cf_Fat_Assign_file_cre_attr+0 
	CALL        _Cf_Fat_Assign+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_M_Test_File_Exist15
;MyProject.c,123 :: 		Cf_Fat_Get_File_Date(&year, &month, &day, &hour, &minute);
	MOVLW       M_Test_File_Exist_year_L0+0
	MOVWF       FARG_Cf_Fat_Get_File_Date_year+0 
	MOVLW       hi_addr(M_Test_File_Exist_year_L0+0)
	MOVWF       FARG_Cf_Fat_Get_File_Date_year+1 
	MOVLW       M_Test_File_Exist_month_L0+0
	MOVWF       FARG_Cf_Fat_Get_File_Date_month+0 
	MOVLW       hi_addr(M_Test_File_Exist_month_L0+0)
	MOVWF       FARG_Cf_Fat_Get_File_Date_month+1 
	MOVLW       M_Test_File_Exist_day_L0+0
	MOVWF       FARG_Cf_Fat_Get_File_Date_day+0 
	MOVLW       hi_addr(M_Test_File_Exist_day_L0+0)
	MOVWF       FARG_Cf_Fat_Get_File_Date_day+1 
	MOVLW       M_Test_File_Exist_hour_L0+0
	MOVWF       FARG_Cf_Fat_Get_File_Date_hours+0 
	MOVLW       hi_addr(M_Test_File_Exist_hour_L0+0)
	MOVWF       FARG_Cf_Fat_Get_File_Date_hours+1 
	MOVLW       M_Test_File_Exist_minute_L0+0
	MOVWF       FARG_Cf_Fat_Get_File_Date_mins+0 
	MOVLW       hi_addr(M_Test_File_Exist_minute_L0+0)
	MOVWF       FARG_Cf_Fat_Get_File_Date_mins+1 
	CALL        _Cf_Fat_Get_File_Date+0, 0
;MyProject.c,124 :: 		UART1_Write_Text(" created: ");
	MOVLW       ?lstr2_MyProject+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_MyProject+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,125 :: 		WordToStr(year, outstr);
	MOVF        M_Test_File_Exist_year_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        M_Test_File_Exist_year_L0+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;MyProject.c,126 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,127 :: 		ByteToStr(month, outstr);
	MOVF        M_Test_File_Exist_month_L0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyProject.c,128 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,129 :: 		WordToStr(day, outstr);
	MOVF        M_Test_File_Exist_day_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;MyProject.c,130 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,131 :: 		WordToStr(hour, outstr);
	MOVF        M_Test_File_Exist_hour_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;MyProject.c,132 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,133 :: 		WordToStr(minute, outstr);
	MOVF        M_Test_File_Exist_minute_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;MyProject.c,134 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,137 :: 		Cf_Fat_Get_File_Date_Modified(&year, &month, &day, &hour, &minute);
	MOVLW       M_Test_File_Exist_year_L0+0
	MOVWF       FARG_Cf_Fat_Get_File_Date_Modified_year+0 
	MOVLW       hi_addr(M_Test_File_Exist_year_L0+0)
	MOVWF       FARG_Cf_Fat_Get_File_Date_Modified_year+1 
	MOVLW       M_Test_File_Exist_month_L0+0
	MOVWF       FARG_Cf_Fat_Get_File_Date_Modified_month+0 
	MOVLW       hi_addr(M_Test_File_Exist_month_L0+0)
	MOVWF       FARG_Cf_Fat_Get_File_Date_Modified_month+1 
	MOVLW       M_Test_File_Exist_day_L0+0
	MOVWF       FARG_Cf_Fat_Get_File_Date_Modified_day+0 
	MOVLW       hi_addr(M_Test_File_Exist_day_L0+0)
	MOVWF       FARG_Cf_Fat_Get_File_Date_Modified_day+1 
	MOVLW       M_Test_File_Exist_hour_L0+0
	MOVWF       FARG_Cf_Fat_Get_File_Date_Modified_hours+0 
	MOVLW       hi_addr(M_Test_File_Exist_hour_L0+0)
	MOVWF       FARG_Cf_Fat_Get_File_Date_Modified_hours+1 
	MOVLW       M_Test_File_Exist_minute_L0+0
	MOVWF       FARG_Cf_Fat_Get_File_Date_Modified_mins+0 
	MOVLW       hi_addr(M_Test_File_Exist_minute_L0+0)
	MOVWF       FARG_Cf_Fat_Get_File_Date_Modified_mins+1 
	CALL        _Cf_Fat_Get_File_Date_Modified+0, 0
;MyProject.c,138 :: 		UART1_Write_Text(" modified: ");
	MOVLW       ?lstr3_MyProject+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_MyProject+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,139 :: 		WordToStr(year, outstr);
	MOVF        M_Test_File_Exist_year_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        M_Test_File_Exist_year_L0+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;MyProject.c,140 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,141 :: 		ByteToStr(month, outstr);
	MOVF        M_Test_File_Exist_month_L0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;MyProject.c,142 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,143 :: 		WordToStr(day, outstr);
	MOVF        M_Test_File_Exist_day_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;MyProject.c,144 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,145 :: 		WordToStr(hour, outstr);
	MOVF        M_Test_File_Exist_hour_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;MyProject.c,146 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,147 :: 		WordToStr(minute, outstr);
	MOVF        M_Test_File_Exist_minute_L0+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVLW       0
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;MyProject.c,148 :: 		UART1_Write_Text(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;MyProject.c,151 :: 		fsize = Cf_Fat_Get_File_Size();
	CALL        _Cf_Fat_Get_File_Size+0, 0
;MyProject.c,152 :: 		LongToStr((signed long)fsize, outstr);
	MOVF        R0, 0 
	MOVWF       FARG_LongToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_LongToStr_input+1 
	MOVF        R2, 0 
	MOVWF       FARG_LongToStr_input+2 
	MOVF        R3, 0 
	MOVWF       FARG_LongToStr_input+3 
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_LongToStr_output+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_LongToStr_output+1 
	CALL        _LongToStr+0, 0
;MyProject.c,153 :: 		UART1_Write_Line(outstr);
	MOVLW       M_Test_File_Exist_outstr_L0+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(M_Test_File_Exist_outstr_L0+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;MyProject.c,154 :: 		}
	GOTO        L_M_Test_File_Exist16
L_M_Test_File_Exist15:
;MyProject.c,157 :: 		UART1_Write(0x55);
	MOVLW       85
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;MyProject.c,158 :: 		Delay_ms(1000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_M_Test_File_Exist17:
	DECFSZ      R13, 1, 1
	BRA         L_M_Test_File_Exist17
	DECFSZ      R12, 1, 1
	BRA         L_M_Test_File_Exist17
	DECFSZ      R11, 1, 1
	BRA         L_M_Test_File_Exist17
	NOP
	NOP
;MyProject.c,159 :: 		UART1_Write(0x55);
	MOVLW       85
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;MyProject.c,160 :: 		}
L_M_Test_File_Exist16:
;MyProject.c,161 :: 		}
L_end_M_Test_File_Exist:
	RETURN      0
; end of _M_Test_File_Exist

_M_Create_Swap_File:

;MyProject.c,166 :: 		void M_Create_Swap_File() {
;MyProject.c,169 :: 		for(i=0; i<512; i++)
	CLRF        M_Create_Swap_File_i_L0+0 
	CLRF        M_Create_Swap_File_i_L0+1 
L_M_Create_Swap_File18:
	MOVLW       2
	SUBWF       M_Create_Swap_File_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Create_Swap_File39
	MOVLW       0
	SUBWF       M_Create_Swap_File_i_L0+0, 0 
L__M_Create_Swap_File39:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Create_Swap_File19
;MyProject.c,170 :: 		Buffer[i] = i;
	MOVLW       _Buffer+0
	ADDWF       M_Create_Swap_File_i_L0+0, 0 
	MOVWF       FSR1L+0 
	MOVLW       hi_addr(_Buffer+0)
	ADDWFC      M_Create_Swap_File_i_L0+1, 0 
	MOVWF       FSR1L+1 
	MOVF        M_Create_Swap_File_i_L0+0, 0 
	MOVWF       POSTINC1+0 
;MyProject.c,169 :: 		for(i=0; i<512; i++)
	INFSNZ      M_Create_Swap_File_i_L0+0, 1 
	INCF        M_Create_Swap_File_i_L0+1, 1 
;MyProject.c,170 :: 		Buffer[i] = i;
	GOTO        L_M_Create_Swap_File18
L_M_Create_Swap_File19:
;MyProject.c,172 :: 		size = Cf_Fat_Get_Swap_File(5000, "mikroE.txt", 0x20);   // see help on this function for details
	MOVLW       136
	MOVWF       FARG_Cf_Fat_Get_Swap_File_sectors_cnt+0 
	MOVLW       19
	MOVWF       FARG_Cf_Fat_Get_Swap_File_sectors_cnt+1 
	MOVLW       0
	MOVWF       FARG_Cf_Fat_Get_Swap_File_sectors_cnt+2 
	MOVWF       FARG_Cf_Fat_Get_Swap_File_sectors_cnt+3 
	MOVLW       ?lstr4_MyProject+0
	MOVWF       FARG_Cf_Fat_Get_Swap_File_filename+0 
	MOVLW       hi_addr(?lstr4_MyProject+0)
	MOVWF       FARG_Cf_Fat_Get_Swap_File_filename+1 
	MOVLW       32
	MOVWF       FARG_Cf_Fat_Get_Swap_File_file_attr+0 
	CALL        _Cf_Fat_Get_Swap_File+0, 0
	MOVF        R0, 0 
	MOVWF       _size+0 
	MOVF        R1, 0 
	MOVWF       _size+1 
	MOVF        R2, 0 
	MOVWF       _size+2 
	MOVF        R3, 0 
	MOVWF       _size+3 
;MyProject.c,174 :: 		if (size) {
	MOVF        R0, 0 
	IORWF       R1, 0 
	IORWF       R2, 0 
	IORWF       R3, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_M_Create_Swap_File21
;MyProject.c,175 :: 		LongToStr((signed long)size, err_txt);
	MOVF        _size+0, 0 
	MOVWF       FARG_LongToStr_input+0 
	MOVF        _size+1, 0 
	MOVWF       FARG_LongToStr_input+1 
	MOVF        _size+2, 0 
	MOVWF       FARG_LongToStr_input+2 
	MOVF        _size+3, 0 
	MOVWF       FARG_LongToStr_input+3 
	MOVLW       _err_txt+0
	MOVWF       FARG_LongToStr_output+0 
	MOVLW       hi_addr(_err_txt+0)
	MOVWF       FARG_LongToStr_output+1 
	CALL        _LongToStr+0, 0
;MyProject.c,176 :: 		UART1_Write_Line(err_txt);
	MOVLW       _err_txt+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(_err_txt+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;MyProject.c,178 :: 		for(i=0; i<5000; i++) {
	CLRF        M_Create_Swap_File_i_L0+0 
	CLRF        M_Create_Swap_File_i_L0+1 
L_M_Create_Swap_File22:
	MOVLW       19
	SUBWF       M_Create_Swap_File_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__M_Create_Swap_File40
	MOVLW       136
	SUBWF       M_Create_Swap_File_i_L0+0, 0 
L__M_Create_Swap_File40:
	BTFSC       STATUS+0, 0 
	GOTO        L_M_Create_Swap_File23
;MyProject.c,179 :: 		Cf_Write_Sector(size++, Buffer);
	MOVF        _size+0, 0 
	MOVWF       FARG_Cf_Write_Sector_sector_number+0 
	MOVF        _size+1, 0 
	MOVWF       FARG_Cf_Write_Sector_sector_number+1 
	MOVF        _size+2, 0 
	MOVWF       FARG_Cf_Write_Sector_sector_number+2 
	MOVF        _size+3, 0 
	MOVWF       FARG_Cf_Write_Sector_sector_number+3 
	MOVLW       _Buffer+0
	MOVWF       FARG_Cf_Write_Sector_buffer+0 
	MOVLW       hi_addr(_Buffer+0)
	MOVWF       FARG_Cf_Write_Sector_buffer+1 
	CALL        _Cf_Write_Sector+0, 0
	MOVLW       1
	ADDWF       _size+0, 1 
	MOVLW       0
	ADDWFC      _size+1, 1 
	ADDWFC      _size+2, 1 
	ADDWFC      _size+3, 1 
;MyProject.c,180 :: 		UART1_Write('.');
	MOVLW       46
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;MyProject.c,178 :: 		for(i=0; i<5000; i++) {
	INFSNZ      M_Create_Swap_File_i_L0+0, 1 
	INCF        M_Create_Swap_File_i_L0+1, 1 
;MyProject.c,181 :: 		}
	GOTO        L_M_Create_Swap_File22
L_M_Create_Swap_File23:
;MyProject.c,182 :: 		}
L_M_Create_Swap_File21:
;MyProject.c,183 :: 		}
L_end_M_Create_Swap_File:
	RETURN      0
; end of _M_Create_Swap_File

_main:

;MyProject.c,186 :: 		void main() {
;MyProject.c,188 :: 		ADCON1 |= 0x0F;                  // Configure AN pins as digital
	MOVLW       15
	IORWF       ADCON1+0, 1 
;MyProject.c,192 :: 		UART1_Init(19200);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       103
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;MyProject.c,193 :: 		Delay_ms(10);
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_main25:
	DECFSZ      R13, 1, 1
	BRA         L_main25
	DECFSZ      R12, 1, 1
	BRA         L_main25
	NOP
;MyProject.c,195 :: 		UART1_Write_Line("PIC-Started"); // PIC present report
	MOVLW       ?lstr5_MyProject+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(?lstr5_MyProject+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;MyProject.c,198 :: 		if (Cf_Fat_Init() == 0) {
	CALL        _Cf_Fat_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main26
;MyProject.c,199 :: 		Delay_ms(2000);                // wait for a while until the card is stabilized
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main27:
	DECFSZ      R13, 1, 1
	BRA         L_main27
	DECFSZ      R12, 1, 1
	BRA         L_main27
	DECFSZ      R11, 1, 1
	BRA         L_main27
	NOP
;MyProject.c,202 :: 		UART1_Write_Line("Test Start.");
	MOVLW       ?lstr6_MyProject+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(?lstr6_MyProject+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;MyProject.c,204 :: 		M_Create_New_File();
	CALL        _M_Create_New_File+0, 0
;MyProject.c,206 :: 		M_Create_Multiple_Files();
	CALL        _M_Create_Multiple_Files+0, 0
;MyProject.c,207 :: 		M_Open_File_Rewrite();
	CALL        _M_Open_File_Rewrite+0, 0
;MyProject.c,208 :: 		M_Open_File_Append();
	CALL        _M_Open_File_Append+0, 0
;MyProject.c,209 :: 		M_Open_File_Read();
	CALL        _M_Open_File_Read+0, 0
;MyProject.c,210 :: 		M_Delete_File();
	CALL        _M_Delete_File+0, 0
;MyProject.c,211 :: 		M_Test_File_Exist();
	CALL        _M_Test_File_Exist+0, 0
;MyProject.c,212 :: 		M_Create_Swap_File();
	CALL        _M_Create_Swap_File+0, 0
;MyProject.c,214 :: 		UART1_Write_Line("Test End.");
	MOVLW       ?lstr7_MyProject+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(?lstr7_MyProject+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;MyProject.c,216 :: 		}
	GOTO        L_main28
L_main26:
;MyProject.c,218 :: 		UART1_Write_Line(err_txt); // Note: Cf_Fat_Init tries to initialize a card more than once.
	MOVLW       _err_txt+0
	MOVWF       FARG_UART1_Write_Line_uart_text+0 
	MOVLW       hi_addr(_err_txt+0)
	MOVWF       FARG_UART1_Write_Line_uart_text+1 
	CALL        _UART1_Write_Line+0, 0
;MyProject.c,220 :: 		}
L_main28:
;MyProject.c,222 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
