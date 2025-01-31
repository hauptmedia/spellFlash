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
package spark.collections
{
import mx.collections.IList;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.utils.OnDemandEventDispatcher;

[ExcludeClass]

// TODO: change the comment
/**
 *  Base class for creating a dynamic range for DateSpinner. Subclassing this class
 *  instead of generating all the dates statistically avoids the cost of applying
 *  DateTimeFormatter.format() to every date.
 *    
 *  @langversion 3.0
 *  @playerversion Flash 11
 *  @playerversion AIR 3
 *  @productversion Flex 4.6
 *
 *  @see
 */
public class OnDemandDataProvider extends OnDemandEventDispatcher implements IList
{
    //----------------------------------------------------------------------------------------------
    //
    //  Constructor
    //
    //----------------------------------------------------------------------------------------------
    
    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */
    public function OnDemandDataProvider()
    {
        super();
    }
    
    //----------------------------------------------------------------------------------------------
    //
    //  Variables
    //
    //----------------------------------------------------------------------------------------------
    
    /**
     *  @private
     *  Used for accessing localized Error messages.
     */
    private var resourceManager:IResourceManager =
        ResourceManager.getInstance();
    
    //----------------------------------------------------------------------------------------------
    //
    //  Properties
    //
    //----------------------------------------------------------------------------------------------
    
    //----------------------------------
    //  length
    //----------------------------------
    /**
     *  This function is not supported
     * 
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */ 
    public function get length():int
    {
        var message:String = resourceManager.getString(
            "collections", "lengthError");
        throw new Error(message);
        return null;       
    }
    
    //----------------------------------------------------------------------------------------------
    //
    //  Interface Methods
    //
    //----------------------------------------------------------------------------------------------
    
    /**
     *  This function is not supported
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */ 
    public function addItem(item:Object):void
    {
        var message:String = resourceManager.getString(
            "collections", "addItemError");
        throw new Error(message);
    }
    
    /**
     *  This function is not supported
     * 
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */ 
    public function addItemAt(item:Object, index:int):void
    {
        var message:String = resourceManager.getString(
            "collections", "addItemAtError");
        throw new Error(message);
    }

    /**
     *  This function is not supported
     * 
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */ 
    public function getItemAt(index:int, prefetch:int=0):Object
    {
        var message:String = resourceManager.getString(
            "collections", "getItemAtError");
        throw new Error(message);
        return null;
    }
    
    /**
     *  This function is not supported
     * 
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */ 
    public function getItemIndex(item:Object):int
    {
        var message:String = resourceManager.getString(
            "collections", "getItemIndexError");
        throw new Error(message);
        return null;
    }
    
    /**
     *  This function is not supported
     * 
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */ 
    public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
    {
        var message:String = resourceManager.getString(
            "collections", "itemUpdatedError");
        throw new Error(message);
    }
    
    /**
     *  This function is not supported
     * 
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */ 
    public function removeAll():void
    {
        var message:String = resourceManager.getString(
            "collections", "removeAllError");
        throw new Error(message);
    }
    
    /**
     *  This function is not supported
     * 
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */ 
    public function removeItemAt(index:int):Object
    {
        var message:String = resourceManager.getString(
            "collections", "removeItemAtError");
        throw new Error(message);
        return null;
    }
    
    /**
     *  This function is not supported
     * 
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */ 
    public function setItemAt(item:Object, index:int):Object
    {
        var message:String = resourceManager.getString(
            "collections", "setItemAtError");
        throw new Error(message);
        return null;
    }
    
    /**
     *  This function is not supported
     * 
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3
     *  @productversion Flex 4.6
     */ 
    public function toArray():Array
    {
        var message:String = resourceManager.getString(
            "collections", "toArrayError");
        throw new Error(message);
        return null;
    }
}    
}
