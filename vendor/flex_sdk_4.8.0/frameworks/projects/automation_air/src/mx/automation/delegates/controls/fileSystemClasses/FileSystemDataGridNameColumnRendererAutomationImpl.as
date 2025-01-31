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

package mx.automation.delegates.controls.fileSystemClasses 
{
	import flash.display.DisplayObject;
	import flash.filesystem.File;
	
	import mx.automation.Automation;
	import mx.controls.fileSystemClasses.FileSystemDataGridNameColumnRenderer;
	import mx.automation.delegates.core.UIComponentAutomationImpl;
	import mx.core.mx_internal;
	
	use namespace mx_internal; 
	
	[Mixin]
	/**
	 * 
	 *  Defines methods and properties required to perform instrumentation for the 
	 *  DataGridItemRenderer class.
	 * 
	 *  @see mx.controls.dataGridClasses.DataGridItemRenderer 
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class FileSystemDataGridNameColumnRendererAutomationImpl extends UIComponentAutomationImpl 
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
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function init(root:DisplayObject):void
		{
			Automation.registerDelegateClass(FileSystemDataGridNameColumnRenderer, FileSystemDataGridNameColumnRendererAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 * @param obj DataGridItem object to be automated.     
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function FileSystemDataGridNameColumnRendererAutomationImpl(obj:FileSystemDataGridNameColumnRenderer)
		{
			super(obj);
		}
		
		/**
		 *  @private
		 */
		protected function get itemRenderer():FileSystemDataGridNameColumnRenderer
		{
			return uiComponent as FileSystemDataGridNameColumnRenderer;
		}
		
		override public function get automationName():String
		{
			var dataObject:File = itemRenderer.data as File;
			if(dataObject)
				return dataObject.name;
			else
				return null;
		}
	}
	
}
