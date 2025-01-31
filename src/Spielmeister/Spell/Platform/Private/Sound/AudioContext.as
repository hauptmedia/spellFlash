package Spielmeister.Spell.Platform.Private.Sound {

	import Spielmeister.Spell.Platform.Private.Sound.FixedSoundChannel
	import Spielmeister.Spell.Platform.Private.Sound.SoundResource

	import flash.media.Sound
	import flash.media.SoundMixer
	import flash.media.SoundTransform
	import flash.events.Event
	import flash.net.URLRequest


	public class AudioContext {
		private var soundChannels : Object = {}
		private var allMuted : Boolean = false
		private var allPaused : Boolean = false
		private var nextSoundId : Number = 1

		public function AudioContext() {
		}

		private function addSoundChannel( id : Number, x : FixedSoundChannel ) : void {
			soundChannels[ id ] = x
		}

		private function getSoundChannel( id : Number ) : FixedSoundChannel {
			return soundChannels[ id ]
		}

		private function createNormalizedVolume( x : Number ) : Number {
			return Math.max( Math.min( x, 1 ), 0 )
		}

		public function tick() : void {}

		public function play( soundAsset : Object, volume : Number = 1, loop : Boolean = false ) : Number {
			var id = this.nextSoundId++

			var soundChannel : FixedSoundChannel = getSoundChannel( id )

			if( !soundChannel )  {
				addSoundChannel(
					id,
					new FixedSoundChannel( soundAsset.resource.sound, createNormalizedVolume( volume ), loop ).play()
				)

			} else {
				if( !soundChannel.playing ) {
					soundChannel.play()
				}
			}

			return id
		}

		public function setLoop( id : Number, loop : Boolean ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.loop = loop
		}

		public function setVolume( id : Number, volume : Number ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.setVolume( volume )
		}

		public function pause( id: Number ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.pause()
		}

		public function resume( id: Number ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.resume()
		}

		public function stop( id : Number ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.stop()
		}

		public function mute( id : Number ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			// HACK: In order to comply with the reference implementation mute is implemented as an alias to "setVolume(0)".
//			soundChannel.muted = true
			soundChannel.setVolume( 0 )
		}

		public function unmute( id : Number ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			// HACK: In order to comply with the reference implementation mute is implemented as an alias to "setVolume(1)".
//			soundChannel.muted = true
			soundChannel.setVolume( 1 )
		}

		public function muteContext( ) : void {
			allMuted = true
			SoundMixer.soundTransform = new SoundTransform( 0 )
		}

		public function unmuteContext( ) : void {
			allMuted = false
			SoundMixer.soundTransform = new SoundTransform( 1 )
		}

		public function isContextMuted() : Boolean {
			return allMuted
		}

		public function pauseContext( ) : void {
			allPaused = true

			for( var id in soundChannels ) {
				var soundChannel : FixedSoundChannel = getSoundChannel( id )
				if( soundChannel ) {
					soundChannel.pause()
				}
			}
		}

		public function resumeContext( ) : void {
			allPaused = false

			for( var id in soundChannels ) {
				var soundChannel : FixedSoundChannel = getSoundChannel( id )
				if( soundChannel ) {
					soundChannel.resume()
				}
			}

		}

		public function isContextPaused() : Boolean {
			return allPaused
		}

		public function destroy( id : Number ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.stop()

			delete soundChannels[ id ]
		}

		public function createSound( sound : Sound ) : SoundResource {
			return new SoundResource( sound )
		}

		public function loadBuffer( src : String, soundAsset : Object, onLoadCallback : Function ) : void {
			var sound : Sound = new Sound(),
				url : String  = src.substr( 0, src.lastIndexOf( '.' ) ) + '.mp3'

			sound.addEventListener(
				Event.COMPLETE,
				function( event : Event ) : void {
					onLoadCallback( event.target as Sound )
				}
			)

			sound.load( new URLRequest( url ) )
		}

		public function getConfiguration() : Object {
			return { type : 'flash' }
		}
	}
}
