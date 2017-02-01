/**
 * MBLRGBData.m
 * MetaWear
 *
 * Created by Stephen Schiffli on 2/17/16.
 * Copyright 2016 MbientLab Inc. All rights reserved.
 *
 * IMPORTANT: Your use of this Software is limited to those specific rights
 * granted under the terms of a software license agreement between the user who
 * downloaded the software, his/her employer (which must be your employer) and
 * MbientLab Inc, (the "License").  You may not use this Software unless you
 * agree to abide by the terms of the License which can be found at
 * www.mbientlab.com/terms.  The License limits your use, and you acknowledge,
 * that the Software may be modified, copied, and distributed when used in
 * conjunction with an MbientLab Inc, product.  Other than for the foregoing
 * purpose, you may not use, reproduce, copy, prepare derivative works of,
 * modify, distribute, perform, display or sell this Software and/or its
 * documentation for any purpose.
 *
 * YOU FURTHER ACKNOWLEDGE AND AGREE THAT THE SOFTWARE AND DOCUMENTATION ARE
 * PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, TITLE,
 * NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL
 * MBIENTLAB OR ITS LICENSORS BE LIABLE OR OBLIGATED UNDER CONTRACT, NEGLIGENCE,
 * STRICT LIABILITY, CONTRIBUTION, BREACH OF WARRANTY, OR OTHER LEGAL EQUITABLE
 * THEORY ANY DIRECT OR INDIRECT DAMAGES OR EXPENSES INCLUDING BUT NOT LIMITED
 * TO ANY INCIDENTAL, SPECIAL, INDIRECT, PUNITIVE OR CONSEQUENTIAL DAMAGES, LOST
 * PROFITS OR LOST DATA, COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY,
 * SERVICES, OR ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY
 * DEFENSE THEREOF), OR OTHER SIMILAR COSTS.
 *
 * Should you have any questions regarding your right to use this Software,
 * contact MbientLab via email: hello@mbientlab.com
 */

#import "MBLRGBData+Private.h"
#import "MBLDataSample+Private.h"

@interface MBLRGBData()
@property (nonatomic) uint16_t red;
@property (nonatomic) uint16_t green;
@property (nonatomic) uint16_t blue;
@property (nonatomic) uint16_t clear;
@end

@implementation MBLRGBData

- (instancetype)initWithRed:(uint16_t)red green:(uint16_t)green blue:(uint16_t)blue clear:(uint16_t)clear timestamp:(NSDate *)timestamp
{
    self = [super initWithTimestamp:timestamp];
    if (self) {
        self.red = red;
        self.green = green;
        self.blue = blue;
        self.clear = clear;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"R:%d, G:%d, B:%d, C:%d", self.red, self.green, self.blue, self.clear];
}

- (NSString *)csvRepresentation
{
    return [NSString stringWithFormat:@"%f,%d,%d,%d,%d\n", self.timestamp.timeIntervalSince1970, self.red, self.green, self.blue, self.clear];
}

@end
