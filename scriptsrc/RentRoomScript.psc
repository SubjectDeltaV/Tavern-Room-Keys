Scriptname RentRoomScript extends Actor  Conditional
{script for anyone who rents a room}

ObjectReference Property Bed  Auto  
{bed to rent}

Key Property RoomKey  Auto 

Key Property HouseKey Auto

WIFunctionsScript Property WI Auto
{Pointer to WIFunctionsScript attached to WI quest}

; rent room or clear rental
function RentRoom(DialogueGenericScript pQuestScript)
	Bed.SetActorOwner(Game.GetPlayer().GetActorBase())
	RegisterForSingleUpdateGameTime (pQuestScript.RentHours)
	Game.GetPlayer().RemoveItem(pQuestScript.Gold, pQuestScript.RoomRentalCost.GetValueInt())
	Game.GetPlayer().AddItem(RoomKey, 1, False)
	Game.GetPlayer().AddItem(HouseKey, 1, False)
	; used to conditionalize innkeeper dialogue
	SetActorValue("Variable09", 1.0)
	WI.ShowPlayerRoom(self, Bed)
endFunction

function ClearRoom()
; 	debug.trace(self + " ClearRoom called on RentRoomScript - room rental expired")
	; clear ownership - either rental expired or I died
	Bed.SetActorOwner((self as Actor).GetActorBase())
	Game.GetPlayer().RemoveItem(RoomKey, 1)
	Game.GetPlayer().RemoveItem(HouseKey, 1)
	UnregisterForUpdateGameTime()
	; used to conditionalize innkeeper dialogue
	SetActorValue("Variable09", 0.0)
endFunction

; when this is called, reset the ownership on the bed
event OnUpdateGameTime()
	ClearRoom()
endEvent

; if I die, clear the room rental as well, to stop the timer
Event OnDeath(Actor akKiller)
	ClearRoom()
endEvent
