--		Color Palette Plugin
--		By InstantStudio

--		Build: Offical Release 1.05.0

function Run(plugin)
	local MainUi = plugin:CreateDockWidgetPluginGui(
		"GuiColorPalateInstant",
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
	local PluginToolbar = plugin:CreateToolbar("Ui Palate")
	local PluginButton = PluginToolbar:CreateButton("OpenPalateUi", "Open", "", "Open")
	local PluginButtonNewColor = PluginToolbar:CreateButton("NewPalateUi", "New", "", "New")
	local Ui = {
		["Palate"] = script.Parent.Ui.ImageButton;
		["Main"] = script.Parent.Ui.ScrollingFrame;
		["Button"] = script.Parent.Ui.TextButton;
	}
	
	Ui.Button.version.Text = "<font size=\"15\">" .. tostring(1.05) .. "</font>"
	
	local ActiveUiMain = Ui.Main:Clone()
	local AcitveUiButton = Ui.Button:Clone()
	ActiveUiMain.Parent = MainUi
	AcitveUiButton.Parent = MainUi

	local PalateFolder = game:GetService("StarterGui"):FindFirstChild("ColorPalate") or Instance.new("Folder")
	if PalateFolder.Name ~= "ColorPalate" then
		PalateFolder.Name = "ColorPalate"
		PalateFolder.Parent = game:GetService("StarterGui")
	end

	local function NewColorPalate()		
		local SelectionService = game:GetService("Selection")
		local newColorInstance = Ui.Palate:Clone()
		newColorInstance.Parent = ActiveUiMain
		newColorInstance.LayoutOrder = #PalateFolder:GetChildren()*-1

		local newDataColorInstance = Instance.new("Color3Value")
		newDataColorInstance.Name = "Color" .. tostring(#PalateFolder:GetChildren()+1)
		newDataColorInstance.Parent = PalateFolder
		SelectionService:Set({newDataColorInstance})

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
		}
	end
	
	AcitveUiButton.MouseButton1Click:Connect(function()
		NewColorPalate()
	end)
	PluginButtonNewColor.Click:Connect(function()
		NewColorPalate()
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
	plugin.Unloading:Connect(function()
		MainUi:Destroy()
		AcitveUiButton:Destroy()
		ActiveUiMain:Destroy()
		PluginToolbar:Destroy()
	end)
end

--		Safety Check
if game:GetService("RunService"):IsStudio() == true and game:GetService("RunService"):IsRunning() == false then
	Run(plugin)
else error("Failed to run, not a Plugin and game cannot be run.")
end