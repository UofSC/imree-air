////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom SDK
//
//  Version: MPL 1.1/GPL 3/LGPL 3
//
//  The contents of this file are subject to the Mozilla Public License Version
//  1.1 (the "License"); you may not use this file except in compliance with
//  the License. You may obtain a copy of the License at
//  http://www.mozilla.org/MPL/
//
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
//  for the specific language governing rights and limitations under the
//  License.
//
//  The Original Code is the OpenZoom SDK.
//
//  The Initial Developer of the Original Code is Daniel Gasienica.
//  Portions created by the Initial Developer are Copyright (c) 2007-2010
//  the Initial Developer. All Rights Reserved.
//
//  Contributor(s):
//    Daniel Gasienica <daniel@gasienica.ch>
//
//  Alternatively, the contents of this file may be used under the terms of
//  either the GNU General Public License Version 3 or later (the "GPL"), or
//  the GNU Lesser General Public License Version 3 or later (the "LGPL"),
//  in which case the provisions of the GPL or the LGPL are applicable instead
//  of those above. If you wish to allow use of your version of this file only
//  under the terms of either the GPL or the LGPL, and not to allow others to
//  use your version of this file under the terms of the MPL, indicate your
//  decision by deleting the provisions above and replace them with the notice
//  and other provisions required by the GPL or the LGPL. If you do not delete
//  the provisions above, a recipient may use your version of this file under
//  the terms of any one of the MPL, the GPL or the LGPL.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.utils
{
    import flash.display.InteractiveObject;
    import flash.events.ContextMenuEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    
    import org.openzoom.flash.core.openzoom_internal;

    use namespace openzoom_internal;

    /**
     * Utility for adding attribution to products built on OpenZoom SDK.
     */
    public final class LicenseUtil
    {
        include "../core/Version.as"

        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------
        /**
         *  Adds a "About OpenZoom..." context menu item
         *  to the context menu of the given object.
         *  Creates a context menu if none exists.
         */
        public static function addAboutMenuItem(interactiveObject:InteractiveObject,
                                                hideBuiltInItems:Boolean=true):void
        {
            if (interactiveObject.contextMenu == null)
            {
                interactiveObject.contextMenu = new ContextMenu()
                if (hideBuiltInItems)
                    interactiveObject.contextMenu.hideBuiltInItems()
            }

            var item:ContextMenuItem = new ContextMenuItem("About OpenZoom...", true)

            item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,
                function(event:ContextMenuEvent):void
                {
                    if (event.target == item)
                        navigateToURL(new URLRequest("http://openzoom.org"), "_blank")
                }
            )

            interactiveObject.contextMenu.customItems.push(item)
        }
    }
}
