--[[

Color Palette Plugin
By InstantStudio

Build: Production 1.08.3

Change log:
 - Added Team Create Support
 - Fixed Loading Bugs
 - Added Studio Theme Support
 - Visiblity Support

]]--

local ScriptVersion = "Production 1.08.3"

function Run(plugin)
	local DockWidget = plugin:CreateDockWidgetPluginGui(
		"GuiColorPalatteInstant",
		DockWidgetPluginGuiInfo.new(
			Enum.InitialDockState.Float,
			true,
			true,
			500,
			500,
			200,
			200
		)
	)
	local PluginToolbar = plugin:CreateToolbar("Ui Palatte")
	local PluginButton = PluginToolbar:CreateButton("OpenPalatteUi", "Open", "", "Open")

	local UiFolder = script.Parent.Ui
	local StaticUi = {
		["Bar"] = UiFolder.Bar;
		["List"] = UiFolder.List;
		["Palatte"] = UiFolder.Palatte;
		["LinkedPalatte"] = UiFolder.LinkedPalatte;
		["Confirm"] = UiFolder.Confirm;
		["ConfirmTakeover"] = UiFolder.ConfirmTakeover;
	}
	
	local MainList = StaticUi.List:Clone()
	local MainBar = StaticUi.Bar:Clone()
	MainList.Parent, MainBar.Parent = DockWidget, DockWidget
	
	local ColorFolder = game:GetService("StarterGui"):FindFirstChild("ColorPalatte")
	local InsertFolder = script.Parent.Cache.Inserts

	type Confirm = {
		Open : () -> Confirm;
		Close : () -> Confirm;
		ConnectOnYes : (func:Function) -> Confirm;
		ConnectOnNo : (func:Function) -> Confirm;
		UpdateText : (Text:string) -> Confirm;
		Destroy : () -> nil;
	}

	local function CreateConfirm():Confirm
		local output = {}

		local Confirm = StaticUi.Confirm:Clone()
		local Takeover  = StaticUi.ConfirmTakeover:Clone()

		Confirm.Visible, Confirm.Position = false, UDim2.new(0.5, -150. -1.5, -100)
		Takeover.Visible = false

		local Events = {
			["TakeoverCheck"] = Takeover.MouseButton1Click:Connect(function()
				if Confirm.Visible == true then
					Confirm.UIStroke.Color = Color3.fromRGB(255, 255, 255)
					task.delay(.5)
					Confirm.UIStroke.Color = Color3.fromRGB(52, 52, 52)
				end
			end);
			["YesHover"] = Confirm.y.MouseEnter:Connect(function()
				Confirm.y.Text = "<b>Yes</b>"
			end);
			["YesHoverEnd"] = Confirm.y.MouseLeave:Connect(function()
				Confirm.y.Text = "Yes"
			end);
			["NoHover"] = Confirm.n.MouseEnter:Connect(function()
				Confirm.n.Text = "<b>No</b>"
			end);
			["NoHoverEnd"] = Confirm.n.MouseLeave:Connect(function()
				Confirm.n.Text = "No"
			end);
		}

		function output.Open()
			Confirm.Visible, Takeover.Visible = true, true
			Confirm:TweenPosition(
				UDim2.new(0.5, -150, 0.5, -100),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Circular,
				1.5
			)
			return output
		end
		function output.Close()
			Confirm:TweenPosition(
				UDim2.new(0.5, -150, -1.5, -100),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Circular,
				1.5
			)
			task.delay(1.5, function()
				Confirm.Visible, Takeover.Visible = false, false
				output:Destroy()
			end)
			return output
		end
		function output.ConnectOnYes(func:Function)
			Confirm.y.MouseButton1Click:Connect(function()
				Confirm.n.Visible = false
				func()
				output:Close()
				task.delay(1.5, function()
					output:Destroy()
				end)
			end)
			return output
		end
		function output.ConnectOnNo(func:Function)
			Confirm.y.MouseButton1Click:Connect(function()
				Confirm.y.Visible = false
				func()
				output:Close()
				task.delay(1.5, function()
					output:Destroy()
				end)
			end)
			return output
		end
		function output.UpdateText(Text:string)
			Confirm.TextLabel.Text = Text
			return output
		end
		function output:Destroy()
			Confirm:Destroy()
			Takeover:Destroy()
			output = nil
			return nil
		end
		return output
	end

	local ButtonFunctions = {
		Apply = function(Value:Color3Value, UiObject:GuiObject)
			local SelectionService = game:GetService("Selection")
			for _, v in pairs(SelectionService:Get()) do
				if v:IsA("GuiObject") then
					v.BackgroundColor3 = Value.Value
				elseif v:IsA("BasePart") then
					v.Color = Value.Value
				end
			end
		end,
		Delete = function(Value:Color3Value, UiObject:GuiObject)
			local Con = CreateConfirm()
			Con.UpdateText("Are you sure you want to delete " .. Value.Name .. "?")
			.Open()
			.ConnectOnYes(function()
				Con.UpdateText("Confirmed")
				Value:Destroy()
				UiObject:Destroy()
			end)
			.ConnectOnNo(function()
				Con.UpdateText("Canceled")
			end)
		end,
		Rename = function(Value:Color3Value, UiObject:GuiObject)
			if UiObject.Name == "LinkedPalatte" then
				return
			else
				local noSpaces = function(str:string):string
					local a = ""
					for _, v in pairs(str:split(" ")) do
						a = a .. v
					end
					return a
				end
				if noSpaces(UiObject.Frame.TextBox.Text) == "" then
					Value.Name = UiObject.Frame.TextBox.PlaceholderText
					UiObject.Frame.Textbox.Text = ""
				else
					Value.Name = noSpaces(UiObject.Frame.TextBox.Text)
					UiObject.Frame.Textbox.Text = noSpaces(UiObject.Frame.TextBox.Text)
				end
				return
			end
		end,
		Open = function(Object)
			local SelectionService = game:GetService("Selection")
			SelectionService:Set({Object})
			return
		end,
		ConvertFromLinked = function(Func, Name:string|nil, Color:Color3|nil)
			Func(Name, Color)
			return
		end,
		MenuHoverStart = function(UiObject:Frame)
			UiObject.Frame:TweenPosition(
				UDim2.new(0, 0, 0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Sine,
				.1
			)
		end,
		MenuHoverEnd = function(UiObject)
			UiObject.Frame:TweenPosition(
				UDim2.new(0, 0, -1, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Sine,
				.1
			)
		end,
		IconHoverStart = function(Object:ImageButton)
			Object.ImageColor3 = Color3.fromRGB(26, 56, 255)
		end,
		IconHoverEnd = function(Object:ImageButton)
			Object.ImageColor3 = Color3.fromRGB(0, 0, 0)
		end,
	}

	local Tabs = {
		["New"] = function()
			local Object = StaticUi.LinkedPalatte:Clone()
			Object.LayoutOrder = #InsertFolder:GetChildren()+1
			Object.Frame.TextBox.Text = ""
			Object.Frame.TextBox.PlaceholderText = "Color" .. tostring(#InsertFolder:GetChildren()+1)
			Object.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Object.Parent = MainList
			local DataValue = Instance.new("Color3Value")
			DataValue.Name = "Color" .. tostring(#InsertFolder:GetChildren()+1)
			DataValue.Value = Color3.fromRGB(255, 255, 255)
			DataValue.Parent = ColorFolder
			
			game:GetService("Selection"):Set({DataValue})
			
			--		Events
			Object.MouseEnter:Connect(function()
				ButtonFunctions.MenuHoverStart(Object)
			end)
			Object.MouseLeave:Connect(function()
				ButtonFunctions.MenuHoverEnd()
			end)
			Object.MouseButton1Click:Connect(function()
				ButtonFunctions.Apply(DataValue, Object)
			end)
			Object.Frame.toolBrush.MouseButton1Click:Connect(function()
				ButtonFunctions.Open(DataValue)
			end)
			Object.Frame.toolBrush.MouseEnter:Connect(function()
				ButtonFunctions.IconHoverStart(Object.Frame.toolBrush)
			end)
			Object.Frame.toolBrush.MouseLeave:Connect(function()
				ButtonFunctions.IconHoverEnd(Object.Frame.toolBrush)
			end)
			Object.Frame.trashcan.MouseButton1Click:Connect(function()
				ButtonFunctions.Delete(DataValue, Object)
			end)
			Object.Frame.trashcan.MouseEnter:Connect(function()
				ButtonFunctions.IconHoverStart(Object.Frame.trashcan)
			end)
			Object.Frame.trashcan.MouseLeave:Connect(function()
				ButtonFunctions.IconHoverEnd(Object.Frame.trashcan)
			end)
			Object.Frame.TextBox.InputEnded:Connect(function()
				ButtonFunctions.Rename(DataValue, Object)
			end)
		end,
		["Clear"] = function()
			local function CombineTables(...:table):table
				local tables = ...
				local returned = {}
				for _, _table in pairs(tables) do
					for _, tableObject in pairs(_table) do
						table.insert(returned, tableObject)
					end
				end
				return returned
			end
			
			local Everything = CombineTables(MainList:GetChildren(), ColorFolder:GetChildren(), InsertFolder:GetChildren())
			
			for i, v:Instance in pairs(Everything) do
				if v:IsA("GuiObject") or v:IsA("Color3Value") then
					v:Destroy()
				end
			end
			return
		end,
		["Insert"] = function()
			local SelectionService = game:GetService("Selection")
			local function NewLinkedObject(Name:string|nil, Color:Color3)
				local newLinked = StaticUi.LinkedPalatte:Clone()
				newLinked.LayoutOrder = 1000+#InsertFolder:GetChildren()+1
				newLinked.Frame.TextBox.Text = Name or ""
				newLinked.Frame.TextBox.PlaceholderText = "Color" .. tostring(#InsertFolder:GetChildren()+1)
				newLinked.BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255)
				newLinked.Parent = MainList
				local DataValue = Instance.new("Color3Value")
				DataValue.Name = Name or "Color" .. tostring(#InsertFolder:GetChildren()+1)
				DataValue.Value = Color
				DataValue.Parent = InsertFolder
				
				--	Events
				newLinked.MouseEnter:Connect(function()
					ButtonFunctions.MenuHoverStart(newLinked)
				end)
				newLinked.MouseLeave:Connect(function()
					ButtonFunctions.MenuHoverEnd(newLinked)
				end)
				newLinked.MouseButton1Click:Connect(function()
					ButtonFunctions.Apply(DataValue, newLinked)
				end)
				newLinked.Frame.toolBrush.MouseButton1Click:Connect(function()
					ButtonFunctions.Open(DataValue)
				end)
				newLinked.Frame.toolBrush.MouseEnter:Connect(function()
					ButtonFunctions.IconHoverStart(newLinked.Frame.toolBrush)
				end)
				newLinked.Frame.toolBrush.MouseLeave:Connect(function()
					ButtonFunctions.IconHoverEnd(newLinked.Frame.toolBrush)
				end)
				newLinked.Frame.trashcan.MouseButton1Click:Connect(function()
					--todo
					--ButtonFunctions.ConvertFromLinked()
				end)
				newLinked.Frame.trashcan.MouseEnter:Connect(function()
					ButtonFunctions.IconHoverStart(newLinked.Frame.trashcan)
				end)
				newLinked.Frame.trashcan.MouseLeave:Connect(function()
					ButtonFunctions.IconHoverEnd(newLinked.Frame.trashcan)
				end)
			end
			
			local function LoadChildren(Children:{[any]:Instance})
				for _, v in pairs(Children) do
					if v:IsA("BasePart") then
						NewLinkedObject(v.Name, v.Color)
					elseif v:IsA("GuiObject") then
						if v:IsA("ImageLabel") or v:IsA("ImageButton") and v.BackgroundTransparency == 1 then
							NewLinkedObject(v.Name, v.ImageColor3)
							else
							NewLinkedObject(v.Name, v.BackgroundColor3)
							end
					end
				end
			end
			
			if #SelectionService:Get() ~= 0 then
				for _, v in pairs(SelectionService:Get()) do
					local t = v:GetDescendants()
					table.insert(t, v)
					LoadChildren(v)
				end
			end
		end,
		["Export"] = function()
			if ColorFolder == nil then
				ColorFolder = Instance.new("ColorPalatte")
				ColorFolder.Name = ""
				ColorFolder.Parent = game:GetService("StarterGui")
			end

			local Export = ColorFolder:Clone()
			Export.Parent = game:GetService("StarterGui")
			Export.Name = "Export:" .. game:GetService("HttpService"):GenerateGUID(true)

			local SelectionService = game:GetService("Selection")
			SelectionService:Set({Export})
			return
		end,
	}
	
	
	PluginButton.Click:Connect(function()
		if DockWidget.Visible == true then
			DockWidget.Visible = false
		elseif DockWidget.Visible == false then
			DockWidget.Visible = true
		end
	end)
	MainBar.version.Text = ScriptVersion
	if os.date("%d %m") == "01 01" then
		MainBar.version.Text = "🥳 Happy New Year!  |  " .. MainBar.version.Text
	elseif os.date("%d %m") == "27 04" then
		MainBar.version.Text = "🎨 Happy Design Day!  |  " .. MainBar.version.Text
	end
	local TabControlers = {
		["New"] = MainBar.buttons.New.MouseButton1Click:Connect(function()
			Tabs.New()
		end);
		["Clear"] = MainBar.buttons.Clear.MouseButton1Click:Connect(function()
			Tabs.Clear()
		end);
		["Insert"] = MainBar.buttons.Insert.MouseButton1Click:Connect(function()
			Tabs.Insert()
		end);
		["Export"] = MainBar.buttons.Export.MouseButton1Click:Connect(function()
			Tabs.Export()
		end);
	}
	
	plugin.Unloading:Connect(function()
		DockWidget:Destroy()
		for _, v in pairs(InsertFolder:GetChildren()) do
			v:Destroy()
		end
		PluginButton:Destroy()
		PluginToolbar:Destroy()
	end)
end

--		Safety Check
if game:GetService("RunService"):IsStudio() == true and game:GetService("RunService"):IsRunning() == false then
	Run(plugin)
end