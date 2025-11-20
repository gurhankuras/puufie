//
//  ImageFilter.c
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

#include "ImageFilter.h"
#include "_types/_uint8_t.h"
#include "math.h"

void apply_grayscale_to_bgra(void *baseAddress, int32_t width, int32_t height,
                            int32_t bytesPerRow) {
    uint8_t *row = (uint8_t *)baseAddress;

    for (int32_t y = 0; y < height; y++) {
        uint8_t *pixel = row;

        for (int32_t x = 0; x < width; x++) {
  
            pixel[2] = (uint8_t) fmin(255, pixel[2] * 1.4);   // R %40 artır
            pixel[1] = pixel[1] * 0.6;             // G azalt
            pixel[0] = pixel[0] * 0.3;             // B çok azalt

            pixel += 4; // sıradaki piksele geç (BGRA = 4 byte)
        }

        row += bytesPerRow; // bir sonraki satıra geç
    }
}
