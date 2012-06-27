//
//  AudioFilePlayer.m
//  ExampleProject
//
//  Created by Aurelius Prochazka on 6/16/12.
//  Copyright (c) 2012 Hear For Yourself. All rights reserved.
//

#import "AudioFilePlayer.h"
#import "OCSLoopingOscillator.h"
#import "OCSReverb.h"
#import "OCSAudio.h"

@interface AudioFilePlayer () {
    OCSProperty *frequencyMultiplier;
}
@end

@implementation AudioFilePlayer

- (id)init {
    self = [super init];
    if (self) {
        
        // INPUTS AND CONTROLS =================================================
        
        frequencyMultiplier = [[OCSProperty alloc] init];
        [frequencyMultiplier setConstant:[OCSParamConstant paramWithString:@"FrequencyMultiplier"]]; 
        [self addProperty:frequencyMultiplier];
        
        // INSTRUMENT DEFINITION ===============================================
        
        NSString * file = [[NSBundle mainBundle] pathForResource:@"hellorcb" ofType:@"aif"];
        OCSSoundFileTable * fileTable = [[OCSSoundFileTable alloc] initWithFilename:file];
        [self addFunctionTable:fileTable];
        
        OCSLoopingOscillator * trigger = [[OCSLoopingOscillator alloc] initWithSoundFileTable:fileTable
                                                                                    Amplitude:ocsp(0.5)
                                                                          FrequencyMultiplier:[frequencyMultiplier constant]];
        [self addOpcode:trigger];
        
        OCSReverb * reverb = [[OCSReverb alloc] initWithMonoInput:[trigger output1] 
                                                    FeedbackLevel:ocsp(0.85)
                                                  CutoffFrequency:ocsp(12000)];
        [self addOpcode:reverb];
        
        // AUDIO OUTPUT ========================================================

        OCSAudio * audio = [[OCSAudio alloc] initWithLeftInput:[reverb outputLeft] 
                                                    RightInput:[reverb outputRight]]; 
        [self addOpcode:audio];
    }
    return self;
}

- (void)play {
    [self playNoteForDuration:3.0f];
}

- (void)playWithFrequencyMultiplier:(float)freqMutiplier {
    frequencyMultiplier.value = freqMutiplier;
    NSLog(@"Playing file at %0.2fx original speed", freqMutiplier);
    [self playNoteForDuration:3.0f];
}


@end