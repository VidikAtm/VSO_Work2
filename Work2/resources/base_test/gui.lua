globalsubscriptionHolder = SignalSubscriptionHolder()

function push_layer(layer)
	Screen:pushLayer(layer)
end

function pop_layer()
	Screen:popLayer()
end

function ShowTestUIOnHierarchy(nodesArr)
	local node = nodesArr[1]:GetParent()
	local myNode = nodesArr[2]

	WriteMessage("Node: "..tostring(node).." MyNode: "..tostring(myNode))

	node:SetActive(true)
	myNode:SetActive(false)

	WriteMessage("Node GetName: ")
	WriteMessage(node:GetName())

	Assert(node:IsAlive() and node:GetName() == "Button" and node:IsActive())

	local rect = node:CloneToTree(node:GetParent()):GetAbstractRectBehavior()
	local intersectButtonNode = rect:GetNode():CloneToTree(rect:GetNode():GetParent())
	local cnahgeWidgetPriorityNode = rect:GetNode():CloneToTree(rect:GetNode():GetParent())
	local intersectButton = intersectButtonNode:GetChildByPath("TestUIButton"):GetButtonBehaviour()
	local cnahgeWidgetPriorityButton = cnahgeWidgetPriorityNode:GetChildByPath("TestUIButton"):GetButtonBehaviour()
	local buttonOpen = rect:GetNode():GetChildByPath("TestUIButton"):GetButtonBehaviour()
	local textOpen = buttonOpen:GetNode():GetChildByPath("Text"):GetComponent()

	Assert(node:IsAlive())

	Assert(textOpen:GetType() == "label")
	Assert(buttonOpen:GetType() == "button")

	node:Destroy()

	Assert(not node:IsAlive())

	WriteMessage("rect: "..tostring(rect))

	intersectButtonNode:SetName("ButtonIntersect")
	rect:SetLeftBottom(rect:GetLeftBottom() + FPoint(400, 0))

	local layerPushed = false

	textOpen:SetText("Open widget")

	buttonOpen:SubscribeOnButtonClick(globalsubscriptionHolder, UIButtonBehaviour.ButtonEventType_Tap, function(evt)
		if layerPushed then
			layerPushed = false
			Screen:RemoveLayer("TestUILayer")

			textOpen:SetText("Open widget")
		else
			layerPushed = true
			Screen:pushLayer("TestUILayer")

			textOpen:SetText("Close widget")
		end

		if layerPushed then
			local layer = GUI:getLayer("TestUILayer")
			local buttonUnderAll = layer:getWidget("under_all")

			if buttonUnderAll then
				buttonUnderAll:SetSceneName("TestUILUA")
				buttonUnderAll:SetCustomPriority(10)
			end
		end
	end)

	local plus = true
	local plusPriority = false

	intersectButton:GetNode():GetChildByPath("Text"):GetComponent():SetText("Move button")
	cnahgeWidgetPriorityButton:GetNode():GetChildByPath("Text"):GetComponent():SetText("Change Widget Priority")

	intersectButton:SubscribeOnButtonClick(globalsubscriptionHolder, UIButtonBehaviour.ButtonEventType_Tap, function(evt)
		local transform = intersectButtonNode:GetTransform()

		if plus then
			transform:SetLocalPosition(transform:GetLocalPosition() + FPoint(200, 200))
		else
			transform:SetLocalPosition(transform:GetLocalPosition() - FPoint(200, 200))
		end

		plus = not plus
	end)

	cnahgeWidgetPriorityButton:SubscribeOnButtonClick(globalsubscriptionHolder, UIButtonBehaviour.ButtonEventType_Tap, function(evt)
		if layerPushed then
			local buttonUnderAll = GUI:getLayer("TestUILayer"):getWidget("under_all")

			local priorityToSet = -10

			if plusPriority then
				priorityToSet = 10
			end

			buttonUnderAll:SetCustomPriority(priorityToSet)

			ShowSystemDialog("@Priority changed", "@Widget button has priority: " .. priorityToSet, "@OK")

			plusPriority = not plusPriority
		else
			ShowSystemDialog("@Fatal error", "@Layer not pushed yet. Press 'Open widget' button", "@OK")
		end
	end)

	cnahgeWidgetPriorityNode:GetTransform():Move(FPoint(400, 200))
	cnahgeWidgetPriorityNode:GetTransform():Rotate(10);
end



function ShowTestUIOnHierarchyFSRT(nodesArr)
	local node = nodesArr[1]:GetParent()
	local myNode = nodesArr[2]

	WriteMessage("Node: "..tostring(node).." MyNode: "..tostring(myNode))

	node:SetActive(true)
	myNode:SetActive(false)

	Assert(node:IsAlive() and node:GetName() == "Button" and node:IsActive())

	local rect = node:CloneToTree(node:GetParent()):GetAbstractRectBehavior()
	local intersectButtonNode = rect:GetNode():CloneToTree(rect:GetNode():GetParent())
	local cnahgeWidgetPriorityNode = rect:GetNode():CloneToTree(rect:GetNode():GetParent())
	local intersectButton = intersectButtonNode:GetChildByPath("TestUIButton"):GetButtonBehaviour()
	local cnahgeWidgetPriorityButton = cnahgeWidgetPriorityNode:GetChildByPath("TestUIButton"):GetButtonBehaviour()
	local buttonOpen = rect:GetNode():GetChildByPath("TestUIButton"):GetButtonBehaviour()
	local textOpen = buttonOpen:GetNode():GetChildByPath("Text"):GetComponent()

	Assert(node:IsAlive())

	Assert(textOpen:GetType() == "label")
	Assert(buttonOpen:GetType() == "button")

	node:Destroy()

	Assert(not node:IsAlive())

	WriteMessage("rect: "..tostring(rect))

	intersectButtonNode:SetName("ButtonIntersect")
	rect:SetLeftBottom(rect:GetLeftBottom() + FPoint(400, 0))

	local layerPushed = false

	textOpen:SetText("Open widget")

	buttonOpen:SubscribeOnButtonClick(globalsubscriptionHolder, UIButtonBehaviour.ButtonEventType_Tap, function(evt)
		if layerPushed then
			layerPushed = false
			Screen:RemoveLayer("TestUIRTLayer")

			textOpen:SetText("Open widget")
		else
			layerPushed = true
			Screen:pushLayer("TestUIRTLayer")

			textOpen:SetText("Close widget")
		end

		if layerPushed then
			local layer = GUI:getLayer("TestUIRTLayer")
			local buttonUnderAll = layer:getWidget("under_all")

			if buttonUnderAll then
				buttonUnderAll:SetSceneName("ButtonsWithFS_RT")
				buttonUnderAll:SetCustomPriority(10)
			end
		end
	end)

	local plus = true
	local plusPriority = false

	intersectButton:GetNode():GetChildByPath("Text"):GetComponent():SetText("Move button")
	cnahgeWidgetPriorityButton:GetNode():GetChildByPath("Text"):GetComponent():SetText("Change Widget Priority")

	intersectButton:SubscribeOnButtonClick(globalsubscriptionHolder, UIButtonBehaviour.ButtonEventType_Tap, function(evt)
		local transform = intersectButtonNode:GetTransform()

		if plus then
			transform:SetLocalPosition(transform:GetLocalPosition() + FPoint(200, 200))
		else
			transform:SetLocalPosition(transform:GetLocalPosition() - FPoint(200, 200))
		end

		plus = not plus
	end)

	cnahgeWidgetPriorityButton:SubscribeOnButtonClick(globalsubscriptionHolder, UIButtonBehaviour.ButtonEventType_Tap, function(evt)
		if layerPushed then
			local buttonUnderAll = GUI:getLayer("TestUIRTLayer"):getWidget("under_all")

			local priorityToSet = -10

			if plusPriority then
				priorityToSet = 10
			end

			buttonUnderAll:SetCustomPriority(priorityToSet)

			ShowSystemDialog("@Priority changed", "@Widget button has priority: " .. priorityToSet, "@OK")

			plusPriority = not plusPriority
		else
			ShowSystemDialog("@Fatal error", "@Layer not pushed yet. Press 'Open widget' button", "@OK")
		end
	end)

	cnahgeWidgetPriorityNode:GetTransform():Move(FPoint(400, 200))
	cnahgeWidgetPriorityNode:GetTransform():Rotate(10);
end


function SendMessageInChat(nodesArr)
	local messageNode = nodesArr[1]
	local editBoxNode = nodesArr[2]

	local editBox = editBoxNode:GetEditBoxBehaviour()
	local textToSet = editBox:GetText()
	editBox:SetText("")
	editBox:ReleaseFocus()

	if textToSet ~= "" then
		local chatMessagesPool = messageNode:GetParent():GetChildByPath("ChatMessages.Layout")
		local messageNodeClone = messageNode:CloneToTree(chatMessagesPool)

		messageNodeClone:GetChildByPath("Text"):GetComponent():SetText(textToSet)
		messageNodeClone:SetActive(true)
	end
end

function CloseEditBoxes()
	Screen:RemoveLayer("EditBoxLayer")
end

function ToggleEditboxes(nodesArr)
	if (Screen:isLayerOnScreen("EditBoxLayer")) then
		Screen:RemoveLayer("EditBoxLayer")
	else
		Screen:pushLayer("EditBoxLayer")
	end
end

function EditBoxLayerFunc(message)
	if message:is("Layer", "Init") then
		GUI:getLayer("EditBoxLayer"):getWidget("EditBox"):AcceptMessage(Message("Enable"))
		GUI:getLayer("EditBoxLayer"):getWidget("EditBoxUpperCase"):AcceptMessage(Message("Enable"))

		GUI:getLayer("EditBoxLayer"):getWidget("EditBox"):AcceptMessage(Message("Set", "Text1"))
		GUI:getLayer("EditBoxLayer"):getWidget("EditBoxUpperCase"):AcceptMessage(Message("Set", "Text2"))
	end
end

function clear_text_message()
	return GUI:getLayer("EditBoxLayer"):getWidget("EditBox"):AcceptMessage(Message("Clear"))
end

function CreateEditBox(editBoxQuery, textItem, cursorItem)
	local sl, st, sr, sb = editBoxQuery:bounds()
	local editBox = CreateFlashEditBox(sl, st, sr, sb, textItem, cursorItem)
	editBoxQuery:get():Sprite():addChild(editBox)
	return editBox
end

function  onEditBoxFlashWidgetInitialized(container)
	WriteMessage("onEditBoxFlashWidgetInitialized")

	local flashRoot = CreateFlashObject("editbox.editboxs")
	container:addChild(flashRoot)
	local flashRootQuery = fQuery(flashRoot)
	flashRootQuery:position(500, 500)
	local editBox1 = CreateEditBox(flashRootQuery:children("eb1.bg1"), flashRootQuery:children("eb1.title"):get(), flashRootQuery:children("eb1.cursor"):get())
	--editBox1:SetAutoChangeKeyboardVisible(false)
	local editBox2 = CreateEditBox(flashRootQuery:children("eb2.bg1"), flashRootQuery:children("eb2.title"):get(), flashRootQuery:children("eb2.cursor"):get())
	--editBox2:SetAutoChangeKeyboardVisible(false)
end


function ValidateText(nodesArr)
	local localEditboxNode = nodesArr[1]
	local validatedNode = nodesArr[2]

	local editBox = localEditboxNode:GetEditBoxBehaviour()
	local labelComponnet = validatedNode:GetComponent()
	
	local activeText = "Text validation callback activated"
	
	if (labelComponnet:GetText() == activeText) then
		editBox:SetValidateTextCallback(nil)
		
		labelComponnet:SetText("Text validation callback inactive")
	else
		editBox:SetValidateTextCallback(function(text)
			text = string.gsub(text, "(a)", string.upper)
			text = string.gsub(text, "%%usernAme%%", "VSO user")
			
			return text
		end)
		
		labelComponnet:SetText(activeText)
	end
end
