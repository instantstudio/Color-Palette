--[[

Color Palette Plugin
By InstantStudio

Build: Offical Release 1.07.0

Change log:
 - Fixed Loading Bugs
 - Added Studio Theme Support
 - Visiblity Support

]]--

function Run(plugin)
	local MainUi = plugin:CreateDockWidgetPluginGui(
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
	local PluginButtonNewColor = PluginToolbar:CreateButton("NewPalatteUi", "New", "", "New")
	local Ui = {
		["Palatte"] = script.Parent.Ui.ImageButton;
		["Main"] = script.Parent.Ui.ScrollingFrame;
		["Button"] = script.Parent.Ui.TextButton;
	}
	
	local LoadedColorValues = {}
	
	Ui.Button.version.Text = "<font size=\"15\">" .. tostring(1.07) .. "</font>"

	local ActiveUiMain = Ui.Main:Clone()
	local AcitveUiButton = Ui.Button:Clone()
	ActiveUiMain.Parent = MainUi
	AcitveUiButton.Parent = MainUi

	local PalatteFolder = game:GetService("StarterGui"):FindFirstChild("ColorPalatte")

	local function UpdateSpecificTheme(Object:ImageButton)
		local theme = settings().Studio.Theme
		Object.BorderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
	end

	local function LoadColorPalatte(Number, Int)
		local SelectionService = game:GetService("Selection")
		local newColorInstance = Ui.Palatte:Clone()
		newColorInstance.Parent = ActiveUiMain
		newColorInstance.LayoutOrder = Int

		local newDataColorInstance = Int
		
		table.insert(LoadedColorValues, newDataColorInstance)

		local pt = {
			["brush"] = newColorInstance.Frame.trashcan;
			["can"] = newColorInstance.Frame.toolBrush;
			["textbutton"] = newColorInstance.Frame.TextBox;
			["baseButton"] = newColorInstance;
		}
		local pt_events = {
			["brush"] = {
				["hoverStart"] = pt.brush.MouseEnter:Connect(function(x, y)
					pt.brush.ImageColor3 = Color3.fromRGB(92, 103, 255)
				end);
				["hoverEnd"] = pt.brush.MouseLeave:Connect(function(x, y)
					pt.brush.ImageColor3 = Color3.fromRGB(255, 255, 255)
				end);
				["click"] = pt.brush.MouseButton1Click:Connect(function()
					for _, v in pairs(SelectionService:Get()) do
						if v:IsA("GuiObject") then

							v.BackgroundColor3 = newDataColorInstance.Value
							if v:IsA("ImageLabel") then
								v.ImageColor3 = newDataColorInstance.Value
							end
						elseif v:IsA("BasePart") then
							v.Color = newDataColorInstance.Value
						end
					end
				end);
			};
			["can"] = {
				["hoverStart"] = pt.can.MouseEnter:Connect(function(x, y)
					pt.can.ImageColor3 = Color3.fromRGB(255, 49, 49)
				end);
				["hoverEnd"] = pt.can.MouseLeave:Connect(function(x, y)
					pt.can.ImageColor3 = Color3.fromRGB(255, 255, 255)
				end);
				["click"] = pt.can.MouseButton1Click:Connect(function()
					newDataColorInstance:Destroy()
					newColorInstance:Destroy()
				end);
			};
			["textbutton"] = {
				["inputStart"] = pt.textbutton.Focused:Connect(function()
					pt.textbutton.BackgroundTransparency = 0
				end);
				["inputEnd"] = pt.textbutton.FocusLost:Connect(function(enterPressed:boolean, __trash)
					pt.textbutton.BackgroundTransparency = 1
					if pt.textbutton.Text == "" then
						newColorInstance.Name = pt.textbutton.PlaceholderText
						newDataColorInstance.Name = pt.textbutton.PlaceholderText
					else
						newColorInstance.Name = pt.textbutton.Text
						newDataColorInstance.Name = pt.textbutton.Text
					end
					SelectionService:Set({newDataColorInstance})
				end);
			};
			["baseButton"] = {
				["click"] = pt.baseButton.MouseButton1Click:Connect(function()
					for _, v in pairs(SelectionService:Get()) do
						if v:IsA("GuiObject") then
							v.BackgroundColor3 = newDataColorInstance.Value
							if v:IsA("ImageLabel") then
								v.ImageColor3 = newDataColorInstance.Value
							end
						end
					end
				end);
				["hoverStart"] = newColorInstance.MouseEnter:Connect(function(x, y)
					newColorInstance.Frame.Visible = true
				end);
				["hoverEnd"] = newColorInstance.MouseLeave:Connect(function(x, y)
					newColorInstance.Frame.Visible = false
				end);
			};
			["rawUpdate"] = {
				["init"] = newDataColorInstance.Changed:Connect(function(__trash)
					newColorInstance.BackgroundColor3 = newDataColorInstance.Value
					newColorInstance.Name = newDataColorInstance.Name
					pt.textbutton.PlaceholderText = newDataColorInstance.Name
				end)
			};
			["themeChange"] ={
				["init"] = settings().Studio.ThemeChanged:Connect(function()
					UpdateSpecificTheme(newColorInstance)
				end)
			};
		}
	end

	local function NewColorPalatte()		
		local SelectionService = game:GetService("Selection")
		local newColorInstance = Ui.Palatte:Clone()
		newColorInstance.Parent = ActiveUiMain
		newColorInstance.LayoutOrder = #PalatteFolder:GetChildren()*-1

		local newDataColorInstance = Instance.new("Color3Value")
		newDataColorInstance.Name = "Color" .. tostring(#PalatteFolder:GetChildren()+1)
		newDataColorInstance.Parent = PalatteFolder
		SelectionService:Set({newDataColorInstance})
		
		table.insert(LoadedColorValues, newDataColorInstance)

		local pt = {
			["brush"] = newColorInstance.Frame.trashcan;
			["can"] = newColorInstance.Frame.toolBrush;
			["textbutton"] = newColorInstance.Frame.TextBox;
			["baseButton"] = newColorInstance;
		}
		local pt_events = {
			["brush"] = {
				["hoverStart"] = pt.brush.MouseEnter:Connect(function(x, y)
					pt.brush.ImageColor3 = Color3.fromRGB(92, 103, 255)
				end);
				["hoverEnd"] = pt.brush.MouseLeave:Connect(function(x, y)
					pt.brush.ImageColor3 = Color3.fromRGB(255, 255, 255)
				end);
				["click"] = pt.brush.MouseButton1Click:Connect(function()
					for _, v in pairs(SelectionService:Get()) do
						if v:IsA("GuiObject") then
							v.BackgroundColor3 = newDataColorInstance.Value
							if v:IsA("ImageLabel") then
								v.ImageColor3 = newDataColorInstance.Value
							end
						end
					end
				end);
			};
			["can"] = {
				["hoverStart"] = pt.can.MouseEnter:Connect(function(x, y)
					pt.can.ImageColor3 = Color3.fromRGB(255, 49, 49)
				end);
				["hoverEnd"] = pt.can.MouseLeave:Connect(function(x, y)
					pt.can.ImageColor3 = Color3.fromRGB(255, 255, 255)
				end);
				["click"] = pt.can.MouseButton1Click:Connect(function()
					newDataColorInstance:Destroy()
					newColorInstance:Destroy()
				end);
			};
			["textbutton"] = {
				["inputStart"] = pt.textbutton.Focused:Connect(function()
					pt.textbutton.BackgroundTransparency = 0
				end);
				["inputEnd"] = pt.textbutton.FocusLost:Connect(function(enterPressed:boolean, __trash)
					pt.textbutton.BackgroundTransparency = 1
					if pt.textbutton.Text == "" then
						newColorInstance.Name = pt.textbutton.PlaceholderText
						newDataColorInstance.Name = pt.textbutton.PlaceholderText
					else
						newColorInstance.Name = pt.textbutton.Text
						newDataColorInstance.Name = pt.textbutton.Text
					end
					SelectionService:Set({newDataColorInstance})
				end);
			};
			["baseButton"] = {
				["click"] = pt.baseButton.MouseButton1Click:Connect(function()
					for _, v in pairs(SelectionService:Get()) do
						if v:IsA("GuiObject") then
							v.BackgroundColor3 = newDataColorInstance.Value
							if v:IsA("ImageLabel") then
								v.ImageColor3 = newDataColorInstance.Value
							end
						end
					end
				end);
				["hoverStart"] = newColorInstance.MouseEnter:Connect(function(x, y)
					newColorInstance.Frame.Visible = true
				end);
				["hoverEnd"] = newColorInstance.MouseLeave:Connect(function(x, y)
					newColorInstance.Frame.Visible = false
				end);
			};
			["rawUpdate"] = {
				["init"] = newDataColorInstance.Changed:Connect(function(__trash)
					newColorInstance.BackgroundColor3 = newDataColorInstance.Value
					newColorInstance.Name = newDataColorInstance.Name
					pt.textbutton.PlaceholderText = newDataColorInstance.Name
				end)
			};
			["themeChange"] ={
				["init"] = settings().Studio.ThemeChanged:Connect(function()
					UpdateSpecificTheme(newColorInstance)
				end)
			};
		}
	end

	if PalatteFolder == nil then
		PalatteFolder = Instance.new("Folder")
		PalatteFolder.Name = "ColorPalatte"
		PalatteFolder.Parent = game:GetService("StarterGui")
	elseif #PalatteFolder:GetChildren() then
		for i, v in pairs(PalatteFolder:GetChildren()) do
			LoadColorPalatte(i, v)
		end
	end

	local function UpdateTheme()
		local theme = settings().Studio.Theme
		ActiveUiMain.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground, Enum.StudioStyleGuideModifier.Default)
		AcitveUiButton.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainButton, Enum.StudioStyleGuideModifier.Default)
		AcitveUiButton.Frame.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground, Enum.StudioStyleGuideModifier.Default)
		AcitveUiButton.FrameA.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground, Enum.StudioStyleGuideModifier.Default)

		AcitveUiButton.credits.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground, Enum.StudioStyleGuideModifier.Default)
		AcitveUiButton.version.BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground, Enum.StudioStyleGuideModifier.Default)

		AcitveUiButton.TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.TitlebarText, Enum.StudioStyleGuideModifier.Default)
		AcitveUiButton.credits.TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default)
		AcitveUiButton.version.TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default)
	end

	UpdateTheme()

	settings().Studio.ThemeChanged:Connect(function()
		UpdateTheme()
	end)
	AcitveUiButton.MouseButton1Click:Connect(function()
		AcitveUiButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
		NewColorPalatte()
		delay(1, function()
			AcitveUiButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
		end)
	end)
	PluginButtonNewColor.Click:Connect(function()
		NewColorPalatte()
	end)
	PluginButton.Click:Connect(function()
		if PluginButton.Name == "Open" then
			MainUi.Enabled = false
			PluginButton.Name = "Close"
		else
			MainUi.Enabled = true
			PluginButton.Name = "Open"
		end
	end)
	--PalatteFolder.ChildAdded:Connect(function(child)
	--	delay(1, function()
	--		LoadColorPalatte(tostring(#PalatteFolder:GetChildren()+1), child)
	--	end)
	--end)
	plugin.Unloading:Connect(function()
		if #PalatteFolder:GetChildren() == 0 then
			PalatteFolder:Destroy()
		end
		MainUi:Destroy()
		AcitveUiButton:Destroy()
		ActiveUiMain:Destroy()
		PluginToolbar:Destroy()
	end)
end

--		Safety Check
if game:GetService("RunService"):IsStudio() == true and game:GetService("RunService"):IsRunning() == false then
	Run(plugin)
end