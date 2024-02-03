--!nocheck

local Players = game:GetService("Players")
local RepS = game:GetService("ReplicatedStorage")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Clock = require(RepS.Modules.Packages.Clock)
local Events = require(RepS.Modules.Data.Events)

local wait = task.wait
local cfAngles = CFrame.Angles
local rad = math.rad

local connection: RBXScriptConnection = nil
local function setCamera(cam: BasePart, method: string?)
	if connection then connection:Disconnect() end

	local camera = workspace.CurrentCamera

	if cam == "Free" then
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = Players.LocalPlayer.Character.Humanoid

		UIS.ModalEnabled = false
		return
	end

	camera.CameraType = Enum.CameraType.Scriptable
	camera.CameraSubject = cam
	camera.CFrame = cam.CFrame

	UIS.ModalEnabled = true

	if method == "Follow" then
		connection = RS.RenderStepped:Connect(function()
			camera.CFrame = cam.CFrame
		end)
	end
end
Events.CameraPos:Connect(setCamera)


local function spinSpinner(duration: number)
	local spinner = workspace.Stage.Spinner :: Model

	local speed = 1.5
	local stop = Clock(0.01, function()
		spinner:PivotTo(spinner.PrimaryPart.CFrame * cfAngles(rad(speed), 0, 0))
	end)

	wait(duration)
	for _ = speed, 0.01, -0.01 do
		speed -= 0.01
		wait(0.01)
	end

	stop()
end
Events.SpinR:Connect(spinSpinner)
