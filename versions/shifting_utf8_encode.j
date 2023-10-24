if (unicode < 127) {
  mips.print_x(unicode);
} else {
  value = unicode;
  num_bytes=1;

  fb_frame_bits = 0xFFFFF80;  // - 128
  fb_data_mask  = 0b00011111;

  do {
    cont_byte = value & 0b00111111;
    value     = value >> 6;

    final_data = value | fb_data_mask;
    if (final == value) {
       // the value can fit
       // so it's the first byte
       break;
    }

    cont_byte = 0b10000000 | cont_byte;
    mips.push(cont_byte);       break;

    fb_frame_bits = fb_frame_bits >> 1;
    fb_data_mask  = fb_data_mask  >> 1;

    num_bytes++;
  } while (1 == 1);

  value = (prefix | value) & 0xFF;
  mips_push.pop();

  for(c=0; c< num_bytes; c++) {
    value = mips.pop();
    mips.print_x(value);
    mips.print_ci(' ');
  }
}
mips.print_ci('\n');
return c;
