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

package mx.controls
{

import flash.events.Event;
import flash.filesystem.File;
import flash.text.TextLineMetrics;
import mx.collections.CursorBookmark;
import mx.controls.ComboBox;
import mx.controls.fileSystemClasses.FileSystemComboBoxRenderer;
import mx.controls.fileSystemClasses.FileSystemControlHelper;
import mx.core.ClassFactory;
import mx.core.mx_internal;
import mx.events.FileEvent;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

use namespace mx_internal;

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="editable", kind="property")]
[Exclude(name="editableDisabledSkin", kind="style")]
[Exclude(name="editableDownSkin", kind="style")]
[Exclude(name="editableOverSkin", kind="style")]
[Exclude(name="editableUpSkin", kind="style")]

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the selected directory displayed by this control
 *  changes for any reason.
 *
 *  @eventType mx.events.FileEvent.DIRECTORY_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="directoryChange", type="mx.events.FileEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Specifies the icon that indicates
 *  the root directories of the computer.
 *  There is no default icon.
 *  In MXML, you can use the following syntax to set this property:
 *  <code>computerIcon="&#64;Embed(source='computerIcon.jpg');"</code>
 *
 *  @default null
 *  
 *  @langversion 3.0
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="computerIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
 *  Specifies the icon that indicates a directory.
 *  The default icon is located in the Assets.swf file.
 *  In MXML, you can use the following syntax to set this property:
 *  <code>directoryIcon="&#64;Embed(source='directoryIcon.jpg');"</code>
 *
 *  @default TreeNodeIcon
 *  
 *  @langversion 3.0
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="directoryIcon", type="Class", format="EmbeddedFile", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[IconFile("FileSystemComboBox.png")]

[ResourceBundle("aircontrols")]

/**
 *  The FileSystemComboBox control defines a combo box control for
 *  navigating up the chain of ancestor directories from a specified
 *  directory in a file system.
 *  You often use this control with the FileSystemList and FileSystemTree
 *  controls to change the current directory displayed by those controls.
 *
 *  <p>Unlike the standard ComboBox control, to populate the FileSystemComboBox control's
 *  <code>dataProvider</code> property,
 *  you set the <code>directory</code> property.
 *  This control then automatically sets the <code>dataProvider</code>
 *  property to an ArrayCollection of File objects
 *  that includes all the ancestor directories of the specified directory,
 *  starting with the <code>COMPUTER</code> File
 *  and ending with the specified directory.</p>
 *
 *  <p>When you select an entry in the dropdown list,
 *  this control dispatches a <code>change</code> event.
 *  After the event is dispatched data provider, and consequently the dropdown list,
 *  contain the selected directory's ancestors.</p>
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;mx:FileSystemComboBox&gt;</code> tag inherits all of the tag
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:FileSystemComboBox
 *    <strong>Properties</strong>
 *    directory="<i>null</i>"
 *    indent="8"
 *    showIcons="true"
 * 
 *    <strong>Styles</strong>
 *    computerIcon="<i>null</i>"
 *    directoryIcon="<i>TreeNodeIcon</i>"
 * 
 *    <strong>Events</strong>
 *    directoryChange="<i>No default</i>"
 *  /&gt;
 *  </pre>
 * 
 *  @see flash.filesystem.File
 *  @see mx.controls.FileSystemList
 *  @see mx.controls.FileSystemTree
 * 
 *  
 *  @langversion 3.0
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class FileSystemComboBox extends ComboBox
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  A constant that can be used as a value for the <code>directory</code> property,
     *  representing a pseudo-top level directory named "Computer". This pseudo-directory
     *  contains the root directories
     *  (such as C:\ and D:\ on Windows or / on Macintosh).
     *  
     *  @langversion 3.0
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const COMPUTER:File = FileSystemControlHelper.COMPUTER;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function FileSystemComboBox()
    {
        super();

        helper = new FileSystemControlHelper(this, false);

        itemRenderer = new ClassFactory(FileSystemComboBoxRenderer);
        labelFunction = helper.fileLabelFunction;
        rowCount = 10;

        addEventListener(Event.CHANGE, changeHandler);

        directory = COMPUTER;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  An undocumented class that implements functionality
     *  shared by various file system components.
     */
    mx_internal var helper:FileSystemControlHelper;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  directory
    //----------------------------------

    /**
     *  @private
     *  Storage for the directory property.
     */
    private var _directory:File;

    /**
     *  @private
     */
    private var directoryChanged:Boolean = false;

    [Bindable("directoryChanged")]

    /**
     *  A File object representing the directory
     *  whose ancestors are to be displayed in this control.
     *  The control displays each ancestor directory
     *  as a separate entry in the dropdown list.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get directory():File
    {
        return _directory;
    }

    /**
     *  @private
     */
    public function set directory(value:File):void
    {
        _directory = value;
        directoryChanged = true;

        invalidateProperties();

        dispatchEvent(new Event("directoryChanged"));
    }

    //----------------------------------
    //  indent
    //----------------------------------

    /**
     *  @private
     *  Storage for the indent property.
     */
    private var _indent:int = 8;

    /**
     *  The number of pixels to indent each entry in the dropdown list.
     *
     *  @default 8
     *  
     *  @langversion 3.0
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get indent():int
    {
        return _indent;
    }

    /**
     *  @private
     */
    public function set indent(value:int):void
    {
        _indent = value;
    }

    //----------------------------------
    //  showIcons
    //----------------------------------

    /**
     *  @private
     *  Storage for the showIcons property.
     */
    private var _showIcons:Boolean = true;

    /**
     *  A flag that determines whether icons are displayed
     *  before the directory names in the dropdown list.
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get showIcons():Boolean
    {
        return _showIcons;
    }

    /**
     *  @private
     */
    public function set showIcons(value:Boolean):void
    {
        _showIcons = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (directoryChanged)
        {
            dataProvider = getParentChain(_directory);
            selectedItem = _directory;

            var event:FileEvent = new FileEvent(FileEvent.DIRECTORY_CHANGE);
            event.file = _directory;
            dispatchEvent(event);

            directoryChanged = false;
        }
    }

    /**
     *  @private
     */
    override protected function resourcesChanged():void
    {
        super.resourcesChanged();

        // The name of the COMPUTER pseudo-directory is localizable.
        // It appears at the top of the dropdown,
        // and may also be displayed as the selected item.
        invalidateSize();
        invalidateDisplayList();
        selectedIndex = selectedIndex;
    }

    /**
     *  @private
     */
    override protected function calculatePreferredSizeFromData(count:int):Object
    {
        var maxW:Number = 0;
        var maxH:Number = 0;

        var bookmark:CursorBookmark = iterator ? iterator.bookmark : null;

        iterator.seek(CursorBookmark.FIRST, 0);

        var more:Boolean = iterator != null;

        var lineMetrics:TextLineMetrics;

        for (var i:int = 0; i < count; i++)
        {
            var data:Object;
            if (more)
                data = iterator ? iterator.current : null;
            else
                data = null;

            var txt:String = itemToLabel(data);

            lineMetrics = measureText(txt);

            lineMetrics.width += i * indent;

            maxW = Math.max(maxW, lineMetrics.width);
            maxH = Math.max(maxH, lineMetrics.height);

            if (iterator)
                iterator.moveNext();
        }

        if (prompt)
        {
            lineMetrics = measureText(prompt);

            maxW = Math.max(maxW, lineMetrics.width);
            maxH = Math.max(maxH, lineMetrics.height);
        }

        maxW += getStyle("paddingLeft") + getStyle("paddingRight");

        if (iterator)
            iterator.seek(bookmark, 0);

        return { width: maxW, height: maxH };
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Returns an Array of File objects
     *  representing the path to the specified directory.
     *  The first File represents a root directory.
     *  The last File represents the specified file's parent directory.
     */
    private function getParentChain(file:File):Array
    {
        if (helper.isComputer(file))
            return [ file ];

        var a:Array = [];

        for (var f:File = file; f != null; f = f.parent)
        {
            a.unshift(f);
        }

        a.unshift(COMPUTER);

        return a;
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  When the user chooses a directory along the path,
     *  change this control to display the path to that directory.
     */
    private function changeHandler(event:Event):void
    {
        directory = File(selectedItem);
    }
}

}
