//
//  ImageFilter.h
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

#ifndef ImageFilter_h
#define ImageFilter_h

#include <stdio.h>

void apply_grayscale_to_bgra(void *baseAddress, int32_t width, int32_t height,
                             int32_t bytesPerRow);

#endif /* ImageFilter_h */
