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

package mx.automation.events
{
	import flash.events.Event;
	
	/**
	 *  The MarshalledAutomationEvents class represents event objects that are dispatched 
	 *  by the AutomationManager.This represents the marshalling related events.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 4
	 */
	public class MarshalledAutomationEvent extends Event
	{
		include "../../core/Version.as";
		
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const BEGIN_RECORDING:String = "BeginRecording";
		public static const END_RECORDING:String = "EndRecording";
		
		public static const UNIQUE_APPID_REQUEST:String = "GetUniqueAppID";
		public static const UNIQUE_APPID_REPLY:String = "GetUniqueAppIDReply";
		
		public static const POPUP_HANDLER_REQUEST:String = "HandlePopUp";
		public static const DRAG_DROP_PROXY_RETRIEVE_REQUEST:String = "GiveProxy";
		public static const DRAG_DROP_PROXY_RETRIEVE_REPLY:String = "GiveProxyReply";
		
		public static const UPDATE_SYCHRONIZATION:String = "UpdateSynchronization";
		public static const INITIAL_DETAILS_REQUEST:String = "InitialDetailsRequest";
		public static const INITIAL_DETAILS_REPLY:String = "InitialDetailsReply";
		
		public static const START_POINT_REQUEST:String = "startPointRequest";
		public static const START_POINT_REPLY:String = "startPointReply";
		
		public static const DRAG_DROP_COMPLETE_REQUEST:String = "completeDragDrop";
		public static const DRAG_DROP_PERFORM_REQUEST_TO_ROOT_APP:String = "performDragDropRequestToRootApp";
		public static const DRAG_DROP_PERFORM_REQUEST_TO_SUB_APP:String = "performDragDropRequestToSubApp";
		
		public static function marshal(event:Event):MarshalledAutomationEvent
		{
			var eventObj:Object = event;
			return new MarshalledAutomationEvent(eventObj.type,
				eventObj.bubbles,
				eventObj.cancelable,
				eventObj.applicationName,
				eventObj.interAppDataToSubApp ,
				eventObj.interAppDataToMainApp);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MarshalledAutomationEvent(type:String, 
												  bubbles:Boolean = true,
												  cancelable:Boolean = true,
												  applicationName:String = null , 
												  interAppDataToSubApp :Array =null,
												  interAppDataToMainApp:Array = null)
		{	
			super(type, bubbles, cancelable);
			this.applicationName = applicationName;
			this.interAppDataToSubApp = interAppDataToSubApp;
			this.interAppDataToMainApp = interAppDataToMainApp;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 *  Contains <code>string</code> which represents the application Name  for the application.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 4
		 */
		public var applicationName:String;
		
		
		/**
		 *  Contains <code>string</code> which represents the descriptionXML details for findObjectIDs.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 4
		 */
		public var interAppDataToSubApp:Array;
		
		/**
		 *  Contains <code>Object</code> which represents the result details for findObjectIDs.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 4
		 */
		public var interAppDataToMainApp:Array;
		
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: Event
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function clone():Event
		{
			return new MarshalledAutomationEvent(type, bubbles, cancelable,/*
				automationObject,
				replayableEvent,
				args,
				name,
				cacheable,*/
				applicationName, interAppDataToSubApp,interAppDataToMainApp);
		}
		
		
	}
}
