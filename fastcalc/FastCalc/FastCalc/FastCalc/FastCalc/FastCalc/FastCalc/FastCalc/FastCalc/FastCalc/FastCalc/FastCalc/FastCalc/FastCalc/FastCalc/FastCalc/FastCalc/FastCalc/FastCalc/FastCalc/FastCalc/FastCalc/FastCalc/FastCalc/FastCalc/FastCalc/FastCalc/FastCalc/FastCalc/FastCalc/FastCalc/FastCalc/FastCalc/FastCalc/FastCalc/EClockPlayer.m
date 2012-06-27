//
//  EClockPlayer.m
//  Enso
//
//  Created by Gevorg Petrosyan on 16.04.12.
//  Copyright (c) 2012 rainwork@mail.ru. All rights reserved.
//

#import "EClockPlayer.h"

@interface EClockPlayer()

- (void)updateTime;

@end

@implementation EClockPlayer

- (id)initWithFileName:(NSString *)name {
    self = [super init];
    if(self) {
        //Setup our Audio Session
        //OSStatus status = AudioSessionInitialize(NULL, NULL, NULL, NULL);    
        //We want our audio to play if the screen is locked or the mute switch is on
        //UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        //status = AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (sessionCategory), &sessionCategory);
        //We want our audio to mix with other app's audio
        //UInt32 shouldMix = true;
        //status = AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (shouldMix), &shouldMix);
        //Enable "ducking" of the iPod volume level while our sounds are playing
        UInt32 shouldDuck = true;
        AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(shouldDuck), &shouldDuck);
        //Activate our audio session
        AudioSessionSetActive(YES);
        
        NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
        NSString *retPathToSoundTemplates = [NSString stringWithFormat:@"/%@", name];
        retPathToSoundTemplates = [bundleRoot stringByAppendingString:retPathToSoundTemplates];
        
        NSData * nsData=[NSData dataWithContentsOfFile:retPathToSoundTemplates];
        mAudioPlayer = [[AVAudioPlayer alloc] initWithData:nsData error:nil];
        mAudioPlayer.delegate = self;
        [mAudioPlayer performSelectorInBackground:@selector(prepareToPlay) withObject:nil];
        isPaused = false;
    }
    return self; 
}

#pragma mark - Custom functions

- (void)playAudioWithStart:(float )start duration:(float )duration {
    [self stopAudio];
    [mAudioPlayer setCurrentTime:start];
    mStart = start;
    mDuration = duration;
    [mAudioPlayer play];
    [self updateTime];
    mPlaybackTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    isPaused = false;
}


- (void)playAudio {
    [self stopAudio];
    [mAudioPlayer setCurrentTime:0];
    //mPlaybackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [mAudioPlayer play];
}

- (void)stopAudio {
    [mAudioPlayer stop];
    if(mPlaybackTimer) {
        [mPlaybackTimer invalidate];
        mPlaybackTimer = nil;
    }
}

- (void)adjustVolume:(float)volume {
    if (mAudioPlayer != nil) {
        mAudioPlayer.volume = volume;
    }
}

- (void)updateTime {
    float minutes = floor(mAudioPlayer.currentTime / 60);
    float seconds = mAudioPlayer.currentTime - (minutes * 60);
    
    if(seconds >= mStart + mDuration) {
        [self stopAudio];
    }
}

#pragma mark - Memory managment

- (void)dealloc {
	[mAudioPlayer release];
	[super dealloc];
}

@end
