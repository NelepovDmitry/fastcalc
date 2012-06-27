//
//  EClockPlayer.h
//  Enso
//
//  Created by Gevorg Petrosyan on 16.04.12.
//  Copyright (c) 2012 rainwork@mail.ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface EClockPlayer : NSObject<AVAudioPlayerDelegate> {
    AVAudioPlayer *mAudioPlayer;
    NSTimer *mPlaybackTimer;
    
    float mStart;
    float mDuration;
    
    bool isPaused;
}

- (id)initWithFileName:(NSString *)name;
- (void)playAudio;
- (void)playAudioWithStart:(float )start duration:(float )duration;
- (void)stopAudio;
- (void)adjustVolume:(float)volume;

@end
