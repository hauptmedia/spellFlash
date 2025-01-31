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

package mx.automation.delegates.charts 
{
	import flash.display.DisplayObject;
	
	import mx.automation.Automation;
	import mx.automation.AutomationIDPart; 
	import mx.automation.tabularData.CartesianChartTabularData;
	import mx.automation.IAutomationObject;
	import mx.automation.IAutomationObjectHelper;
	import mx.automation.IAutomationTabularData;
	import mx.automation.delegates.charts.ChartBaseAutomationImpl;
	import mx.charts.chartClasses.CartesianChart;
      import mx.core.mx_internal;

      use namespace mx_internal;
	
	[Mixin]
	/**
	 * 
	 *  Defines the methods and properties required to perform instrumentation for the 
	 *  CartesianChart base class. 
	 * 
	 *  @see mx.charts.chartClasses.CartesianChart
	 *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class CartesianChartAutomationImpl extends ChartBaseAutomationImpl 
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
			Automation.registerDelegateClass(CartesianChart, CartesianChartAutomationImpl);
		}   
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  @param obj CartesianChart object to be automated.      
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function CartesianChartAutomationImpl(obj:CartesianChart)
		{
			super(obj);
			
			cChart = obj;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  cartesianChart
		//----------------------------------
		
		/**
		 *  @private
		 *  storage for the owner component
		 */
		private var cChart:CartesianChart;
		
		
		/**
		 *  @private
		 */
		override public function getAutomationChildren():Array
		{
			var childList:Array = new Array();
			
			var tempArray1:Array = cChart.series;
			var n:int = 0;
			var i:int = 0;
			if (tempArray1)
			{
				n= tempArray1.length;
				for(i = 0; i < n ; i++)
				{
					childList.push(tempArray1[i]);
				}
			}
			
			if (cChart.verticalAxisRenderer )
				childList.push(cChart.verticalAxisRenderer);
			
			if (cChart.horizontalAxisRenderer)
				childList.push(cChart.horizontalAxisRenderer);
			return childList; 
		}
		
		/**
		 *  @private
		 */
		override public function getAutomationChildAt(index:int):IAutomationObject
		{
			var result:Object;
			var count:int = 0;
			if (cChart.series)
			{   
				count = cChart.series.length ;
				if (index < count)
					result = cChart.series[index];  
			}
			
			if (!result && cChart.verticalAxisRenderer)
			{
				++count;
				if (index < count)
					result = cChart.verticalAxisRenderer;
			}
			
			if (!result && cChart.horizontalAxisRenderer)
			{
				++count;
				if (index < count)
					result = cChart.horizontalAxisRenderer;
			}
			
			return result as IAutomationObject; 
		}
		
		/**
		 *  @private
		 */
		override public function get numAutomationChildren():int
		{
			var count:int = 0;
			if (cChart.series)
				count = cChart.series.length ;
			
			if (cChart.verticalAxisRenderer)
				++count;
			
			if (cChart.horizontalAxisRenderer)
				++count;
			
			return count;
		}
		
		/**
		 *  @private
		 */
		override public function get automationTabularData():Object
		{
			return new CartesianChartTabularData(uiAutomationObject);
		}
		
	}
	
}
