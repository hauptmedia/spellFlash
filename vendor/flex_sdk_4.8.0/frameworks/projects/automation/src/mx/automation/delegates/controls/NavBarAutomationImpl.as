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

package mx.automation.delegates.controls 
{
	import flash.display.DisplayObject; 
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import mx.automation.Automation; 
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.events.AutomationRecordEvent;
	import mx.automation.delegates.core.ContainerAutomationImpl;
	import mx.controls.NavBar;
	import mx.core.mx_internal;
	import mx.events.ItemClickEvent;
	import mx.core.EventPriority;
	
	use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines methods and properties required to perform instrumentation for the 
	 *  NavBar control.
	 * 
	 *  @see mx.controls.NavBar 
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class NavBarAutomationImpl extends ContainerAutomationImpl 
	{
		include "../../../core/Version.as";
		
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
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function init(root:DisplayObject):void
		{
			Automation.registerDelegateClass(NavBar, NavBarAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj NavBar object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function NavBarAutomationImpl(obj:NavBar)
		{
			super(obj);
			
			recordClick = false;
			
			obj.addEventListener(AutomationRecordEvent.RECORD, automationRecordHandler, false, EventPriority.DEFAULT+1, true);
			
			obj.addEventListener(ItemClickEvent.ITEM_CLICK, itemClickHandler, false, 0, true);
			
		}
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		protected function get  nBar():NavBar
		{
			return uiComponent as NavBar;
		}
		
		/**
		 *  @private
		 *  Replays <code>click</code> events by dispatching a MouseEvent
		 *  to the item that was clicked.
		 */
		override public function replayAutomatableEvent(interaction:Event):Boolean
		{
			var help:IAutomationObjectHelper = Automation.automationObjectHelper;
			if (interaction is ItemClickEvent)
			{
				var itemClickInteraction:ItemClickEvent =
					ItemClickEvent(interaction);
				if (itemClickInteraction.relatedObject != null)
					return help.replayClick(itemClickInteraction.relatedObject);
				else
					return false;
			}
			else if (interaction is KeyboardEvent)
			{
				return help.replayKeyboardEvent(uiComponent, KeyboardEvent(interaction));
			}
			else
			{
				return super.replayAutomatableEvent(interaction);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function automationRecordHandler(event:AutomationRecordEvent):void
		{
			if (event.replayableEvent.type == MouseEvent.CLICK)
				event.stopImmediatePropagation();
		}
		
		/**
		 *  @private
		 */
		protected function itemClickHandler(event:ItemClickEvent):void
		{
			recordAutomatableEvent(event);
		}
		
		/**
		 * @private
		 */
		public function getItemsCount():int
		{
			if (nBar.dataProvider)
				return nBar.dataProvider.length;
			
			return 0;
		}
		
	}
	
}
