public static int decode() {

    int num_bytes;
	int prefix;

    int value;
	int next;

	int c;

    value = -1;

	mips.read_x();
	value = mips.retval();

    if (value <= 0x7F) {
    	// one byte sequence
    	return value;
    }

    // We have a multi-byte sequence
    prefix = value & 0xF7;			// 0b1111 1-xxx
	switch (prefix) {

	case 0xF0:	;               	// 0b1111 0-xxx
		    num_bytes = 4;
		    value = value & 0x07;
			break;
	case 0xE0:                  	// 0b1110- xxxx
		    num_bytes = 3;
		    value = value & 0x0F;
		    break;

	case 0xC0:                 		// 0b110-0 xxxx
	case 0xD0:                    	// 0b110-1 xxxx
		    num_bytes = 2;
		    value = value & 0x1F;
		    break;

	default:                       // 0b10-xx xxxx
			// error
			return -1;
	}

    for(c = 1; c < num_bytes; c++) {   // one byte is already read
			mips.read_x();
			next = mips.retval();
			// insert error check
			value = (value << 6 ) | (next & 0x3F);
	}
	return value;


}
