package Spielmeister.Spell.Platform.Private.Loader {

	import Spielmeister.Spell.Platform.Private.Graphics.DisplayList.DisplayListContext

	import flash.display.Bitmap
	import flash.display.Loader
	import flash.events.Event
	import flash.net.URLRequest


	public class ImageLoader implements Spielmeister.Spell.Platform.Private.Loader.Loader {
		private var renderingContext : DisplayListContext
		private var url : String
		private var onLoadCallback : Function
		private var onErrorCallback : Function
		private var loader : flash.display.Loader

		public function ImageLoader( renderingContext : DisplayListContext, url : String, onLoadCallback : Function, onErrorCallback : Function, onTimedOutCallback : Function ) {
			this.renderingContext = renderingContext
			this.url              = url
			this.onLoadCallback   = onLoadCallback
			this.onErrorCallback  = onErrorCallback
		}

		public function start() : void {
			loader = new flash.display.Loader()

			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoad )
			loader.load( new URLRequest( url ) )
		}

		private function onLoad( event : Event ) : void {
			this.onLoadCallback(
				this.renderingContext.createTexture(
					( loader.content as Bitmap ).bitmapData
				)
			)
		}
	}
}
