

#import <Foundation/Foundation.h>

@interface VoicePlayer : NSObject
{
    void *player;
}

- (id) init;
- (BOOL) isStopped;
- (void) setFreqs:(int *)_freqs freqCount:(int)_freqCount;
- (void) setVolume:(double)_volume;
- (void) play:(NSString *)_text playCount:(long)_playCount muteInterval:(int)_muteInterval;
- (void) playString:(NSString *)_text playCount:(long)_playCount muteInterval:(int)_muteInterval;
- (void) playWiFi:(char *)_mac macLen:(int)_macLen pwd:(NSString *)_pwd playCount:(long)_playCount muteInterval:(int)_muteInterval;
- (void) playSSIDWiFi:(NSString *)_ssid pwd:(NSString *)_pwd playCount:(long)_playCount muteInterval:(int)_muteInterval;
- (void) playPhone:(NSString *)_imei phoneName:(NSString *)_phoneName playCount:(long)_playCount muteInterval:(int)_muteInterval;

@end
