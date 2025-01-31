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

package spark.automation.delegates.components.supportClasses
{
    import flash.display.DisplayObject;
    
    import mx.automation.Automation;
    import mx.core.mx_internal;
    
    import spark.components.Scroller;
    import spark.components.supportClasses.GroupBase;
    import spark.components.supportClasses.SkinnableContainerBase;
    
    use namespace mx_internal;
    
    [Mixin]
    /**
     * 
     *  Defines methods and properties required to perform instrumentation for the 
     *  SkinnableContainerBase control.
     * 
     *  @see spark.components.supportClasses.SkinnableContainerBase 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     *
     */
    public class SparkSkinnableContainerBaseAutomationImpl extends SparkSkinnableComponentAutomationImpl 
    {
        
        include "../../../../core/Version.as";
        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Registers the delegate class for a component class with automation manager.
         *  
         *  @param root The SystemManger of the application.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public static function init(root:DisplayObject):void
        {
            Automation.registerDelegateClass(spark.components.supportClasses.SkinnableContainerBase, SparkSkinnableContainerBaseAutomationImpl);
        }   
        
        /**
         *  Constructor.
         * @param obj SkinnableContainerBase object to be automated.     
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.5
         *  @productversion Flex 4
         */
        public function SparkSkinnableContainerBaseAutomationImpl(obj:spark.components.supportClasses.SkinnableContainerBase)
        {
            super(obj);
            
        }
        
        
        /**
         *  @private
         */
        private function get containerBase():SkinnableContainerBase
        {
            return uiComponent as SkinnableContainerBase;
        }
        
        /**
         * private
         */ 
        protected function getScrollBars(passedObj:Object, stopWithContetGroup:GroupBase):Array
        {
            var scroller:spark.components.Scroller = null;
            if(passedObj)
                scroller = getScroller(passedObj,stopWithContetGroup);
            else
                scroller = getScroller(containerBase,stopWithContetGroup);
            
            if(scroller)
            {
                var tempArray:Array = new Array();
                if(scroller.horizontalScrollBar && scroller.horizontalScrollBar.visible)
                    tempArray.push(scroller.horizontalScrollBar);
                if(scroller.verticalScrollBar && scroller.verticalScrollBar.visible)
                    tempArray.push(scroller.verticalScrollBar);
                
            }
            return tempArray;
            
        }
        
        /**
         * private
         */ 
        protected function getScroller(passedObj:Object, stopWithContentGroup:GroupBase):spark.components.Scroller
        {
            
            if(passedObj)
            {
                if( !(passedObj.hasOwnProperty("numChildren") && 
                    passedObj.hasOwnProperty("getChildAt")))
                    return null;
            }
            
            var requiredObject:Object = null;
            if(passedObj)
                requiredObject = passedObj;
            else
                // just to ensure that if no object is passed, we will consider it on the
                // current object.
                requiredObject = containerBase;
            
            var n:int = requiredObject.numChildren;
            
            var obj:Object;
            for (var i:int = 0; i<n ; i++)
            {
                obj  =  requiredObject.getChildAt(i);
                
                if(obj is spark.components.Scroller)
                    return obj as spark.components.Scroller;
                
                // check whether we need to proceed with the element to dig further
                // if it is a skin we need to proceed.
                // if the object corresponds to our contentGroup, we need not proceed further
                if(stopWithContentGroup &&(obj == stopWithContentGroup))
                    continue;
                do
                {
                    obj = getScroller(obj,stopWithContentGroup);
                }while(obj && !(obj is spark.components.Scroller))
                
                if(obj is spark.components.Scroller)
                    return obj as spark.components.Scroller;
            }
            return null;
        }
        
    }
    
}
