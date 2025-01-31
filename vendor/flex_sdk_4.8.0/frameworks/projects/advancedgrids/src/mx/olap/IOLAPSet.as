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

package mx.olap
{

import mx.collections.IList;
    
/**
 *  The IOLAPSet interface represents a set, 
 *  which is used to configure the axis of an OLAP query.
 *
 *  @see mx.olap.OLAPSet
 *  @see mx.olap.OLAPQueryAxis
 *  @see mx.olap.IOLAPResultAxis
 *  @see mx.olap.OLAPResultAxis
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IOLAPSet
{
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
   /**
    *  Adds a new member to the set.
    *
    *  <p>This method adds the appropriate elements to the set,
    *  depending on the type of element passed in.
    *  If an IOLAPHierarchy element is passed, it adds the default member of the hierarchy.
    *  If an IOLAPLevel element is passed, it adds all the members of the level.
    *  If an IOLAPMember element is passed, it is added to the set.</p>
    *
    *  @param element The member to add. 
    *  If <code>element</code> is a hierarchy or level, its members
    *  are added. If <code>element</code> is an instance of IOLAPMember, 
    *  it is added directly.
    *  A new tuple is created for each member.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
   function addElement(element:IOLAPElement):void

   /**
    *  Adds a list of members to the set. 
    *  This method can be called when members or children of a hierarchy
    *  or member need to be added to the set.
    *
    *  @param element The members to add, as a list of IOLAPMember instances. 
    *  A new tuple is created for each member.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
   function addElements(elements:IList):void
   
   /**
    *  Adds a new tuple to the set.
    *
    *  @param tuple The tuple to add.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
   function addTuple(tuple:IOLAPTuple):void;
   
   /**
    *  Returns a new IOLAPSet instance that contains a crossjoin of this 
    *  IOLAPSet instance and <code>input</code>.
    *
    *  @param input An IOLAPSet instance.
    *
    *  @return An IOLAPSet instance that contains a crossjoin of this 
    *  IOLAPSet instance and <code>input</code>.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
   function crossJoin(input:IOLAPSet):IOLAPSet;

   /**
    *  Returns a new IOLAPSet that is hierarchized version
    *  of this set.
    *   
    *  @param post If <code>true</code> indicates that children should precede parents.
    *  By default, parents precede children.
    *
    *  @return A new IOLAPSet that is hierarchized version
    *  of this set.
    *
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
   function hierarchize(post:Boolean=false):IOLAPSet;
   
   /**
    *  Returns a new IOLAPSet instance that contains a union of this 
    *  IOLAPSet instance and <code>input</code>.
    *
    *  @param input An IOLAPSet instance.
    *
    *  @return An IOLAPSet instance that contains a union of this 
    *  IOLAPSet instance and <code>input</code>.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
   function union(input:IOLAPSet/*, keepDuplicates:Boolean=false*/):IOLAPSet;
}

}
