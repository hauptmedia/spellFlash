////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package spark.events
{
    
import flash.events.Event;
import flash.geom.Rectangle;


[ExcludeClass]

/**
 *  @private 
 * 
 *  The CaretBoundsChangeEvent class is dispatched when the caret bounds of a text
 *  component has changed
 *
 *  @see spark.components.TextArea
 *  
 *  @langversion 3.0
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
public class CaretBoundsChangeEvent extends Event
{
    /**
     *  Constructor
     */  
    public function CaretBoundsChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, oldCaretBounds:Rectangle=null, newCaretBounds:Rectangle=null)
    {
        this.oldCaretBounds = oldCaretBounds;
        this.newCaretBounds = newCaretBounds;
        super(type, bubbles, cancelable);
    }
    
    /**
     *  The <code>CaretBoundsChangeEvent.CARET_BOUNDS_CHANGE</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>caretBoundsChange</code> 
     *  event.  
     *
     *  <p>The properties of the event object have the following values:</p>
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>oldCaretBounds</code></td><td>null</td></tr>
     *     <tr><td><code>newCaretBounds</code></td><td>null</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>Type</code></td><td>CaretBoundsChangeEvent.CARET_BOUNDS_CHANGE</td></tr>
     *  </table>
     *
     *  @eventType removing
     *  
     *  @langversion 3.0
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static var CARET_BOUNDS_CHANGE:String = "caretBoundsChange";
    
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  oldCaretBounds
    //----------------------------------
    /**
     * @private
     * The old bounds of the caret in the target's coordinate space
     */   
    public var oldCaretBounds:Rectangle;
    
    
    //----------------------------------
    //  newCaretBounds
    //----------------------------------
    /**
     * @private
     * The new bounds of the caret in the target's coordinate space
     */ 
    public var newCaretBounds:Rectangle; 
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    override public function clone():Event
    {
        return new CaretBoundsChangeEvent(
            type, bubbles, cancelable, 
            oldCaretBounds, newCaretBounds);
    }
}
}
