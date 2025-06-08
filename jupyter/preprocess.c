#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void preprocess_input(unsigned char **bytearrays, int* sizes, int index) {

    unsigned char *bytearray = bytearrays[index];
    int size = sizes[index];
    
    // Calculate new size (multiple of 64) (+9 for 0x80 and 8 bytes for length)
    int new_size = (((size+9) + 63) / 64) * 64;

    // Allocate new bytearray
    unsigned char *new_bytearray = (unsigned char *)calloc(new_size, sizeof(unsigned char));

    // Copy old bytearray to new bytearray
    memcpy(new_bytearray, bytearray, size);
    
    // Update bytearrays and sizes
    bytearrays[index] = new_bytearray;
    sizes[index] = new_size;

    // Add a byte '0x80' after the end of the message
    new_bytearray[size] = 0x80;

    // Add original length of the message in bits at the end of the message
    long original_length = size * 8;
    for(int i = 0; i < 8; i++)
        new_bytearray[new_size - 8 + i] = (original_length >> (i * 8) & 0xff);
}

void interleave(unsigned char *output_buffer, unsigned char **bytearrays, int* sizes) {

    int pos = 0;
    for (int block_index = 0; block_index < sizes[0] / 64; block_index++) {
        for (int array_index = 0; array_index < 64; array_index++){
            memcpy(output_buffer + pos, bytearrays[array_index] + (block_index * 64), 64 * sizeof(char));
            pos += 64;
        }
    }
}

void preprocess(unsigned char* buffer_out, unsigned char **inputs, int *sizes) {
    
    for(int i = 0; i < 64; i++) 
        preprocess_input(inputs, sizes, i);
        
    interleave(buffer_out, inputs, sizes);
    
    for (int i = 0; i < 64; i++)
        free(inputs[i]);
}
