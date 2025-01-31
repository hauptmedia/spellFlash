package Spielmeister.Spell.Platform.Private.Graphics.DisplayList {

	import Spielmeister.Spell.Platform.Private.Graphics.StateStack
	import Spielmeister.Spell.Platform.Private.Graphics.StateStackElement

	import flash.display.Bitmap
	import flash.display.BitmapData
	import flash.display.CapsStyle
	import flash.display.Graphics
	import flash.display.LineScaleMode
	import flash.display.Shape
	import flash.display.Stage
	import flash.geom.ColorTransform
	import flash.geom.Matrix
	import flash.geom.Point
	import flash.geom.Rectangle
	import flash.external.ExternalInterface

	import net.richardlord.coral.Matrix3d
	import net.richardlord.coral.Point3d
	import net.richardlord.coral.Vector3d


	public class DisplayListContext {
		private var stage : Stage
		private var width : uint
		private var height : uint
		private var id : String
		private var colorBuffer : Bitmap
		private var clearColor : uint
		private var lineColor : uint
		private var magicScale : Number = 1.01
		private var pixelScale : Number = 0

		private var stateStack : StateStack = new StateStack( 32 )
		private var currentState : StateStackElement

		private var transferMatrix : Matrix = new Matrix()
		private var tmpShape : Shape        = new Shape()
		private var tmpGraphics : Graphics

		// view space to screen space transformation matrix
		private var viewToScreen : Matrix3d = new Matrix3d()

		// world space to view space transformation matrix
		private var worldToView : Matrix3d = new Matrix3d()

		// accumulated transformation world space to screen space transformation matrix
		private var worldToScreen : Matrix3d = new Matrix3d()

		// transformation from screen space to world space
		private var screenToWorld : Matrix3d = new Matrix3d()

		// temporaries
		private var tmpMatrix : Matrix3d = new Matrix3d()
		private var tmpMatrix2 : Matrix3d = new Matrix3d()
		private var tmpPoint : Point3d = new Point3d()
		private var tmpVector : Vector3d = new Vector3d()
		private var tmpRectangle : Rectangle = new Rectangle()


		public function DisplayListContext( stage : Stage, id : String, width : uint, height: uint ) {
			this.stage  = stage
			this.width  = width
			this.height = height
			this.id     = id
			clearColor  = 0x000000

			tmpGraphics = tmpShape.graphics

			// setting up the color buffer
			colorBuffer = new Bitmap()
			colorBuffer.bitmapData = new BitmapData(
				this.width,
				this.height,
				false,
				clearColor
			)

			this.stage.addChild( colorBuffer )

			this.stateStack.pushState()
			this.currentState = this.stateStack.popState()


			// initializing
			viewport( 0, 0, this.width, this.height )

			// world space to view space matrix
			var cameraWidth  = width,
				cameraHeight = height

			ortho(
				-cameraWidth / 2,
				cameraWidth / 2,
				-cameraHeight / 2,
				cameraHeight / 2,
				worldToView
			)

			worldToView.prependTranslation( -cameraWidth / 2, -cameraHeight / 2, 0 ) // WATCH OUT: apply inverse translation for camera position

			updateWorldToScreen( viewToScreen, worldToView )
		}


		private function modulo( dividend : Number, divisor : Number ) : Number {
			var tmp : Number = dividend % divisor

			return tmp < 0 ?
				( tmp + divisor ) % divisor :
				tmp
		}


		private function normalizeStartTexCoord( tc : Number ) {
			tc = modulo( tc, 1 )

			return tc * -1
		}


		private function clampToUnit( value : Number ) : Number {
			return Math.min( 1.0, Math.max( value, 0.0 ) )
		}


		private function createColorValue( vec : Array ) : uint {
			var color : uint = 0

			for( var i : int = 0; i < 3; i++ ) {
				color += uint( clampToUnit( vec[ i ] ) * 255 ) << ( ( 2 - i ) * 8 )
			}

			return color
		}


		private function copyMatrix3dToMatrix( matrix3d : Matrix3d, matrix : Matrix ) : void {
			matrix.a  = matrix3d.n11
			matrix.b  = matrix3d.n21
			matrix.c  = matrix3d.n12
			matrix.d  = matrix3d.n22
			matrix.tx = matrix3d.n14
			matrix.ty = matrix3d.n24
		}


		private function ortho( left : Number, right : Number, bottom : Number, top : Number, dest : Matrix3d ) : void {
			var rl : Number = ( right - left ),
				tb : Number = ( top - bottom )

			dest.n11 = 2 / rl
			dest.n21 = 0
			dest.n31 = 0
			dest.n41 = 0
			dest.n12 = 0
			dest.n22 = 2 / tb
			dest.n32 = 0
			dest.n32 = 0
			dest.n13 = 0
			dest.n23 = 0
			dest.n33 = 1
			dest.n43 = 0
			dest.n14 = -( left + right ) / rl
			dest.n24 = -( top + bottom ) / tb
			dest.n34 = 0
			dest.n44 = 1
		}


		/**
		 * Updates the world to screen matrix.
		 *
		 * @param viewToScreen
		 * @param worldToView
		 */
		private function updateWorldToScreen( viewToScreen : Matrix3d, worldToView : Matrix3d ) : void {
			var worldToScreen = this.worldToScreen

			pixelScale = Math.abs( 1 / worldToScreen.n11 )

			worldToScreen.reset()
			worldToScreen.prepend( viewToScreen )
			worldToScreen.prepend( worldToView )
			worldToScreen.inverse( this.screenToWorld )
		}

		public function setColor( vec : Array ) : void {
			currentState.color = createColorValue( vec )
		}


		public function setGlobalAlpha( u : Number ) : void {
			currentState.opacity = clampToUnit( u )
		}


		public function setClearColor( vec : Array ) : void {
			clearColor = createColorValue( vec )
		}


		public function save() : void {
			currentState = stateStack.pushState()
		}


		public function restore() : void {
			currentState = stateStack.popState()

			// restore viewMatrix
			worldToView.assign( currentState.viewMatrix )
			updateWorldToScreen( viewToScreen, worldToView )
		}


		public function scale( vec : Array ) : void {
			currentState.matrix.prependScale( vec[ 0 ], vec[ 1 ], 1 )
		}


		public function translate( vec : Array ) : void {
			currentState.matrix.prependTranslation( vec[ 0 ], vec[ 1 ], 0 )
		}


		public function rotate( u : Number ) : void {
			currentState.matrix.prependRotation( u, Vector3d.Z_AXIS )
		}


		public function drawTexture( texture : Object, destinationPosition : Array, destinationDimensions : Array, textureMatrix : Array ) : void {
			var dx : Number = destinationPosition[ 0 ],
				dy : Number = destinationPosition[ 1 ],
				dw : Number = destinationDimensions[ 0 ],
				dh : Number = destinationDimensions[ 1 ],
				tw : Number = texture.dimensions[ 0 ],
				th : Number = texture.dimensions[ 1 ]

			var colorTransform : ColorTransform = null

			if( currentState.opacity < 1 ) {
				colorTransform = new ColorTransform( 1, 1, 1, currentState.opacity )
			}

			tmpMatrix.assign( worldToScreen )
			tmpMatrix.prepend( currentState.matrix )

			// rotating the image so that it is not upside down
			tmpMatrix.prependTranslation( dx, dy, 0 )
			tmpMatrix.prependRotation( Math.PI, Vector3d.Z_AXIS )

			if( !textureMatrix ) {
				tmpMatrix.prependScale( -1, 1, 1 )
				tmpMatrix.prependTranslation( 0, -dh, 0 )

				// correcting scale
				tmpMatrix.prependScale( dw / tw, dh / th, 1 )

				copyMatrix3dToMatrix( tmpMatrix, transferMatrix )

				colorBuffer.bitmapData.draw(
					texture.privateBitmapDataResource,
					transferMatrix,
					colorTransform,
					null,
					null,
					true
				)

			} else {
				var clipRect = createClipRect( dx, dy, dw, dh )

				var xAxisInverted : Boolean = textureMatrix[ 0 ] < 0,
					yAxisInverted : Boolean = textureMatrix[ 4 ] < 0

				tmpMatrix.prependScale(
					xAxisInverted ? 1 : -1,
					yAxisInverted ? -1 : 1,
					1
				)

				tmpMatrix.prependTranslation(
					xAxisInverted ? -destinationDimensions[ 0 ] : 0,
					yAxisInverted ? 0 : -destinationDimensions[ 1 ],
					1
				)

				// correcting scale
				tmpMatrix.prependScale( dw / tw, dh / th, 1 )

				mapTexture(
					colorBuffer.bitmapData,
					texture,
					textureMatrix,
					colorTransform,
					tmpMatrix,
					clipRect
				)
			}
		}


		private function createClipRect( dx : Number, dy : Number , dw : Number, dh : Number ) : Rectangle {
			// position
			tmpPoint.x = dx
			tmpPoint.y = dy

			tmpMatrix.transformPoint( tmpPoint, tmpPoint )

			// dimensions
			tmpVector.x = dw
			tmpVector.y = dh

			tmpMatrix.transformVector( tmpVector, tmpVector )

			var clipRectWidth  = Math.abs( tmpVector.x ),
				clipRectHeight = Math.abs( tmpVector.y )

			tmpRectangle.x      = tmpPoint.x - clipRectWidth / 2
			tmpRectangle.y      = tmpPoint.y - clipRectHeight / 2
			tmpRectangle.width  = clipRectWidth
			tmpRectangle.height = clipRectHeight

			return tmpRectangle
		}


		private function mapTexture( bitmapData : BitmapData, texture : Object, textureMatrix : Array, colorTransform : ColorTransform, matrix : Matrix3d , clipRect : Rectangle ) {
			var scaleX         = Math.abs( textureMatrix[ 0 ] ),
				scaleY         = Math.abs( textureMatrix[ 4 ]),
				startTexCoordX = normalizeStartTexCoord( textureMatrix[ 6 ] ),
				startTexCoordY = normalizeStartTexCoord( textureMatrix[ 7 ] ),
				numIterationsX = Math.round( Math.ceil( scaleX ) - Math.floor( startTexCoordX ) ),
				numIterationsY = Math.round( Math.ceil( scaleY ) - Math.floor( startTexCoordY ) ),
				textureWidth   = texture.dimensions[ 0 ],
				textureHeight  = texture.dimensions[ 1 ]

			matrix.prependScale( 1 / scaleX, 1 / scaleY, 1 )

			for( var y = 0;
				 y < numIterationsY;
				 y++ ) {

				for( var x = 0;
					 x < numIterationsX;
					 x++ ) {

					tmpMatrix2.assign( matrix )

					tmpMatrix2.prependTranslation(
						( x + startTexCoordX ) * textureWidth,
						( y + startTexCoordY ) * textureHeight,
						0
					)

					copyMatrix3dToMatrix( tmpMatrix2, transferMatrix )

					bitmapData.draw(
						texture.privateBitmapDataResource,
						transferMatrix,
						colorTransform,
						null,
						clipRect,
						true
					)
				}
			}
		}


		public function drawSubTexture(
			texture : Object,
			sourcePosition : Array,
			sourceDimensions : Array,
			destinationPosition : Array,
			destinationDimensions : Array
		) : void {
			var sx : Number = sourcePosition[ 0 ],
				sy : Number = sourcePosition[ 1 ],
				sw : Number = sourceDimensions[ 0 ],
				sh : Number = sourceDimensions[ 1 ],
				dx : Number = destinationPosition[ 0 ],
				dy : Number = destinationPosition[ 1 ],
				dw : Number = destinationDimensions[ 0 ],
				dh : Number = destinationDimensions[ 1 ]

			tmpMatrix.assign( worldToScreen )
			tmpMatrix.prepend( currentState.matrix )

			// rotating the image so that it is not upside down
			tmpMatrix.prependTranslation( dx, dy, 0 )
			tmpMatrix.prependRotation( Math.PI, Vector3d.Z_AXIS )
			tmpMatrix.prependScale( -magicScale, magicScale, 1 )
			tmpMatrix.prependTranslation( 0, -dh, 0 )

			// correcting scale
			tmpMatrix.prependScale( dw / sw, dh / sh, 1 )

			transferMatrix.a  = tmpMatrix.n11
			transferMatrix.b  = tmpMatrix.n21
			transferMatrix.c  = tmpMatrix.n12
			transferMatrix.d  = tmpMatrix.n22
			transferMatrix.tx = tmpMatrix.n14
			transferMatrix.ty = tmpMatrix.n24

			/**
			 * Yes, your are eyes are not deceiving you. This method creates a temporary BitmapData instance in order to
			 * perform source texture cropping a.k.a. "a poor copy of a texture matrix". This is how it's done on htrae!
			 */
			var tmpBitmapData : BitmapData = new BitmapData( sw, sh, true, 0x00000000 )

			tmpBitmapData.copyPixels(
				texture.privateBitmapDataResource,
				new Rectangle( sx, sy, sw, sh ),
				new Point( 0, 0 )
			)

			colorBuffer.bitmapData.draw(
				tmpBitmapData,
				transferMatrix,
				currentState.opacity < 1 ? new ColorTransform( 1, 1, 1, currentState.opacity ) : null,
				null,
				null,
				true
			)
		}


		public function fillRect( dx : Number, dy : Number, dw : Number, dh : Number ) : void {
			tmpMatrix.assign( worldToScreen )
			tmpMatrix.prepend( currentState.matrix )

			// rotating the image so that it is not upside down
			tmpMatrix.prependTranslation( dx, dy, 0 )
			tmpMatrix.prependRotation( Math.PI, Vector3d.Z_AXIS )
			tmpMatrix.prependScale( -1, 1, 1 )
			tmpMatrix.prependTranslation( 0, -dh, 0 )

			transferMatrix.a  = tmpMatrix.n11
			transferMatrix.b  = tmpMatrix.n21
			transferMatrix.c  = tmpMatrix.n12
			transferMatrix.d  = tmpMatrix.n22
			transferMatrix.tx = tmpMatrix.n14
			transferMatrix.ty = tmpMatrix.n24

			tmpGraphics.clear()
			tmpGraphics.beginFill( currentState.color )
			tmpGraphics.drawRect( 0, 0, dw, dh )

			colorBuffer.bitmapData.draw( tmpShape, transferMatrix )
		}

		public function transform( matrix : Array ) : void {
			currentState.matrix.prepend(
				new Matrix3d(
					matrix[ 0 ],
					matrix[ 1 ],
					0,
					matrix[ 2 ],
					matrix[ 3 ],
					matrix[ 4 ],
					0,
					matrix[ 5 ],
					0,
					0,
					1,
					0,
					matrix[ 6 ],
					matrix[ 7 ],
					0,
					matrix[ 8 ]
				)
			)
		}

		public function setTransform( matrix : Array ) : void {
			var destination = currentState.matrix

			destination.n11 = matrix[ 0 ]
			destination.n21 = matrix[ 1 ]
			destination.n41 = matrix[ 2 ]
			destination.n12 = matrix[ 3 ]
			destination.n22 = matrix[ 4 ]
			destination.n42 = matrix[ 5 ]
			destination.n14 = matrix[ 6 ]
			destination.n24 = matrix[ 7 ]
			destination.n44 = matrix[ 8 ]
		}

		public function setViewMatrix( matrix : Array ) : void {
			worldToView.n11 = matrix[ 0 ]
			worldToView.n21 = matrix[ 1 ]
			worldToView.n12 = matrix[ 3 ]
			worldToView.n22 = matrix[ 4 ]
			worldToView.n14 = matrix[ 6 ]
			worldToView.n24 = matrix[ 7 ]

			currentState.viewMatrix.assign( worldToView )

			updateWorldToScreen( viewToScreen, worldToView )
		}

		public function viewport( dx : Number, dy : Number, dw : Number, dh : Number ) : void {
			viewToScreen.n11 = dw * 0.5
			viewToScreen.n22 = dh * 0.5 * -1 // mirroring y-axis
			viewToScreen.n14 = dx + dw * 0.5
			viewToScreen.n24 = dy + dh * 0.5

			updateWorldToScreen( viewToScreen, worldToView )
		}

		public function resizeColorBuffer ( newWidth : Number, newHeight : Number ) : void {
			ExternalInterface.call( 'spell_setDimensions', this.id + '-screen', newWidth, newHeight )

			while( stage.numChildren ) {
				stage.removeChildAt( 0 )
			}

			// setting up the color buffer
			colorBuffer = new Bitmap()
			colorBuffer.bitmapData = new BitmapData( newWidth, newHeight, false, clearColor )

			stage.addChild( colorBuffer )
		}


		public function clear() : void {
			tmpGraphics.clear()
			tmpGraphics.beginFill( clearColor )
			tmpGraphics.drawRect( 0, 0, colorBuffer.width, colorBuffer.height )

			transferMatrix.identity()

			colorBuffer.bitmapData.draw( tmpShape, transferMatrix )
		}


		public function createTexture( bitmapData : BitmapData ) : Object {
			return {
				/**
				 * public
				 */
				dimensions : [ bitmapData.width, bitmapData.height ],

				/**
				 * private
				 *
				 * This is an implementation detail of the class. If you write code that depends on this you better know what you are doing.
				 */
				privateBitmapDataResource: bitmapData
			}
		}


		public function getConfiguration() : Object {
			return {
				type   : "display-list",
				width  : width,
				height : height,
				info   : ''
			}
		}


		public function transformScreenToWorld( vec : Array ) : Array {
			tmpPoint.x = vec[ 0 ]
			tmpPoint.y = vec[ 1 ]

			this.screenToWorld.transformPoint( tmpPoint, tmpPoint )

			return [ tmpPoint.x, tmpPoint.y ]
		}


		public function drawRect( dx : Number, dy : Number, dw : Number, dh : Number, lineWidth : Number = 1 ) : void {
			tmpMatrix.assign( worldToScreen )
			tmpMatrix.prepend( currentState.matrix )

			transferMatrix.a  = tmpMatrix.n11
			transferMatrix.b  = tmpMatrix.n21
			transferMatrix.c  = tmpMatrix.n12
			transferMatrix.d  = tmpMatrix.n22
			transferMatrix.tx = tmpMatrix.n14
			transferMatrix.ty = tmpMatrix.n24

			var right : Number = dx + dw,
				top : Number   = dy + dh

			tmpGraphics.clear()
			tmpGraphics.lineStyle( pixelScale * lineWidth, lineColor )
			tmpGraphics.moveTo( dx, dy )
			tmpGraphics.lineTo( dx, top )
			tmpGraphics.lineTo( right, top )
			tmpGraphics.lineTo( right, dy )
			tmpGraphics.lineTo( dx, dy )

			colorBuffer.bitmapData.draw( tmpShape, transferMatrix, null )
		}

		public function drawCircle( dx : Number, dy : Number, radius : Number, lineWidth : Number = 1 ) : void {
			tmpMatrix.assign( worldToScreen )
			tmpMatrix.prepend( currentState.matrix )

			transferMatrix.a  = tmpMatrix.n11
			transferMatrix.b  = tmpMatrix.n21
			transferMatrix.c  = tmpMatrix.n12
			transferMatrix.d  = tmpMatrix.n22
			transferMatrix.tx = tmpMatrix.n14
			transferMatrix.ty = tmpMatrix.n24

			tmpGraphics.clear()
			tmpGraphics.lineStyle( pixelScale * lineWidth, lineColor )
			tmpGraphics.drawCircle( dx, dy, radius )

			colorBuffer.bitmapData.draw( tmpShape, transferMatrix, null )
		}

		public function drawLine( ax : Number, ay : Number, bx : Number, by : Number, lineWidth : Number = 1 ) : void {
			tmpMatrix.assign( worldToScreen )
			tmpMatrix.prepend( currentState.matrix )

			transferMatrix.a  = tmpMatrix.n11
			transferMatrix.b  = tmpMatrix.n21
			transferMatrix.c  = tmpMatrix.n12
			transferMatrix.d  = tmpMatrix.n22
			transferMatrix.tx = tmpMatrix.n14
			transferMatrix.ty = tmpMatrix.n24

			tmpGraphics.clear()
			tmpGraphics.lineStyle( pixelScale * lineWidth, lineColor )
			tmpGraphics.moveTo( ax, ay )
			tmpGraphics.lineTo( bx, by )

			colorBuffer.bitmapData.draw( tmpShape, transferMatrix, null )
		}

		public function setLineColor( vec : Array ) : void {
			lineColor = createColorValue( vec )
		}

		public function flush() : void {}
	}
}
