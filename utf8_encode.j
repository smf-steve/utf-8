// utf8: version:  left-to-right

public static int utf8_encode () {

    int buff[]= {0};
    int value;
    int byte_1;
    int byte_2;
    int byte_3;
    int byte_4;
    int label;

   	int last_codepoint_1 = 0x00007F; // (0x7F >>> 0)
   	int last_codepoint_2 = 0x00001F; // (0x7FF >>> 6)
   	int last_codepoint_3 = 0x00000F; // (0xFFFF >>> 12)
   	int last_codepoint_4 = 0x10FFFF; // (unaltered)

   	final int continuation_prefix = 0x80;
   	final int continuation_data   = 0x3F;

   	final int codepoint_2_prefix = 0xC0;   // 0b1100 0000
   	final int codepoint_3_prefix = 0xE0;   // 0b1110 0000
   	final int codepoint_4_prefix = 0xF0;   // 0b1111 0000

   	final int one_byte   = 1;   // label
   	final int two_byte   = 2;   // label
   	final int three_byte = 3;   // label
   	final int four_byte  = 4;   // label

    value	  = 0;
    byte_1	  = 0;  
    byte_2	  = 0;  
    byte_3	  = 0;  
    byte_4	  = 0;  
    label     = 0;

	for (; ;)  {
  		mips.read(0, buff, 4);   //-- issue, it reads intput as integers in dec format
		value = mips.retval();
		if (value == 0) {
		   break;
		}

		value = buff[0];    // lw $t0, 0(buff);

		if (value > last_codepoint_4) {
		   	// error: value is too large
		   	mips.print_di(-1);
			continue;
		}

  loop: do {
			if (value <= last_codepoint_1) {

		    	mips.print_d(value);
				// a one byte sequence
				byte_1 = value;

				label = one_byte;  // b one_byte;
				break loop;
			} 

			// make continuation byte
			byte_1 =  value  & 0x3F;
	    	byte_1 =  byte_1 | 0x80;
	
	    	value = value >>> 6;
     		if (value <= last_codepoint_2) { 
				// a two byte sequence
	
			 	byte_2 = value | 0xC0;  // 0b1100 0000

				label = two_byte;   // b two_byte;
				break loop;
			}
			// make continuation byte
			byte_2 =  value  & 0x3F;
	    	byte_2 =  byte_2 | 0x80;
	
	    	value = value >>> 6;
        	if (value <= last_codepoint_3) {
        		// a three byte sequence
	
				byte_3 = value | 0xE0;  // 0b1110 0000
				label = three_byte; // b three_byte;
				break loop;
			}
			// make continuation byte
			byte_3 =  value  & 0x3F;
	    	byte_3 =  byte_3 | 0x80;
	
	
	    	value = value >>> 6;
			// a four byte sequence
	   		byte_4 = value | 0xF0;  // 0b1111 0000 
            label = four_byte;  // b four_byte;
            break loop;
        } while (false);

	   	switch (label) {
			case four_byte:		
					mips.print_x(byte_4);
					mips.print_ci(' ');
			case three_byte:		
					mips.print_x(byte_3);
					mips.print_ci(' ');
			case two_byte:
					mips.print_x(byte_2);
					mips.print_ci(' ');
			case one_byte:		
					mips.print_x(byte_1);
					mips.print_ci('\n');
		}


	}
	return 0;
}
