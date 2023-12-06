// ========== Memory-Mapped I/O ==========
// f000:      LEDR
// f001:      LEDG
// f002:      HEX3-HEX0
// f003:      HEX7-HEX4
// f004:      SW
// f005:      KEY
// f006:      rx_valid
// f007:      rx_valid_clr
// f008:      rx_byte
// f009:      tx_byte
// f00a:      tx_start
// f00b:      tx_active
// f020-f03f: LCD
// f050-f06f: msg             (read + write)
// 0xf070:    msg_len_minus_1 (write)
// 0xf071:    start           (write)
// 0xf072:    busy            (read)

// ========== REGISTER DESCRIPTIONS ==========
// --- NUMERICAL CONSTANTS ---
//  r0: const 8: offset
//  r1: const 1: increment
//  r2: const 10: carriage return
// --- TEMPORARY VARIABLES ---
//  r3: temp
//  r4: temp
//  r5: temp for comparisons
// --- SPECIFIC VAIRABLES ---
//  r6: branch condition
//  r7: inc
//  r8: target addr
//  r9: current character
// r10: chars
// --- ADDRESS CONSTANTS ---
// r11: const 0xf000: UART
// r12: const 0xf020: LCD
// r13: const 0xf050: scrambler msg
// r14: const 0xf070: scrambler controls (len-1)
// r15: reserved for JAL

// ========== BEGIN DATA SEGMENT ==========
.data
UART: 0xf000
LCD: 0xf020
msg: 0xf050
controls: 0xf070

// ========== BEGIN TEXT SEGMENT ==========
.text
// load constants
ldi r0, 8   // set const offset
ldi r1, 1   // set const increment
ldi r2, 0xd // set const carriage return

ldi r3, high(UART)
shl r3, r3, r0
ldi r3, low(UART)
or r4, r3, r3
ld r11, r4, 0

ldi r3, high(LCD)
shl r3, r3, r0
ldi r3, low(LCD)
or r4, r3, r3
ld r12, r4, 0

ldi r3, high(msg)
shl r3, r3, r0
ldi r3, low(msg)
or r4, r3, r3
ld r13, r4, 0

ldi r3, high(controls)
shl r3, r3, r0
ldi r3, low(controls)
or r4, r3, r3
ld r14, r4, 0

// *** BEGIN DEBUG ***
// st r1, r11, 6   // write to rx_valid
// ldi r3, 0
// st r3, r14, 2   // busy = 0 
// st r3, r11, 0xb // tx_active = 0
// *** END DEBUG ***

// ========== BEGIN MAIN PROGRAM LOOP ==========
start:
    ldi r10, 0     // initialize chars
read_loop:
    // *** BEGIN DEBUG *** 
    // st r10, r11, 8      // rx_byte = # of chars
    // st r1, r11, 6       // rx_valid = true
    // *** END DEBUG ***

    ld r6, r11, 6       // read rx_valid
    bz r6, read_loop
    ld r9, r11, 8       // get character
    st r0, r11, 7       // clear rx_valid
    st r9, r11, 2       // write char code to HEX3-HEX0
    sub r6, r9, r2      // condition for character == '\n'
    bz r6, newline
    br not_newline
    
newline:
    jal send_char     // echo char to terminal
    st r10, r11, 3    // store number of chars to HEX7-HEX4
    jal clear_LCD
    ldi r5, 0
    sub r6, r5, r10   // condition for chars > 0
    bn r6, start_HLSM
    br start

start_HLSM:
    st r0, r14, 1
    ldi r3, 2
    add r8, r14, r3 // target = 0xf072
    jal busy_loop
    br data_out

not_newline:
    ldi r5, 32
    sub r6, r10, r5   // condition for chars < 32
    bn r6, store_char
    br read_loop

store_char:
    jal send_char    // echo char to terminal
    add r8, r13, r10 // target = 0xf050 + chars
    st r9, r8, 0     // append char to msg
    st r10, r14, 0   // update len - 1
                     // NOTE: since we increment chars after we update len-1, 
                     //       we do not need to subtract anything
    add r10, r10, r1 // chars += 1
    st r10, r11, 3   // update HEX7-HEX4
    br read_loop

data_out:
    ldi r7, 0        // set inc = 0
data_out_loop:
    sub r6, r7, r10  // condition: (inc == chars)
    bz r6, finished  

    add r8, r13, r7  // target = 0xf050 + inc
    ld r9, r8, 0     // load current char
    
    add r8, r12, r7  // target = LCD + inc
    st r9, r8, 0     // store char into LCD

    jal send_char    // send current char

    add r7, r7, r1   // inc += 1
    
    br data_out_loop

finished:
    ldi r9, 0xd   
    jal send_char // send carriage return
    // *** BEGIN DEBUG ***
    // quit
    // *** END DEBUG ***
    br start

// ========== FUNCTIONS ==========
// PARAMS:   (r8: addr of monitor value)
// CLOBBERS: (r6)
busy_loop:    
    ld r6, r8, 0          // read target addr
    bz r6, busy_loop_done
    br busy_loop
busy_loop_done:
    jr r15

// PARAMS:   (r9: char to send)
// CLOBBERS: (r3, r4, r8, r15)
send_char:
    or r4, r9, r9   // r4 = current char
    shl r4, r4, r0  // shift character bits up
    or r4, r4, r10  // r4 = {send char, chars}
    st r4, r11, 3   // HEX7-HEX4 = {send char, chars}
    
    st r9, r11, 9   // store char in tx_byte
    st r0, r11, 0xa // tx_start
    ldi r4, 0xb
    add r8, r11, r4 // target = 0xf00b (tx_active)
    or r3, r15, r15 // r3 = r15
    jal busy_loop   // wait for tx_active to go low
    jr r3           // return from function

// PARAMS:   ()
// CLOBBERS: (r3, r4, r5, r6, r8)
clear_LCD:
    ldi r3, 32            // clear LCD with spaces (ASCII code = 32)
    ldi r4, 0             // inc
    ldi r5, 32            // offset check
clear_LCD_loop:
    sub r6, r5, r4
    bz r6, clear_LCD_done // check if (inc == 32)
    add r8, r12, r4       // target = 0xf020 + inc
    st r3, r8, 0          // M[target] = 0
    add r4, r4, r1        // inc += 1
    br clear_LCD_loop
clear_LCD_done:
    jr r15

