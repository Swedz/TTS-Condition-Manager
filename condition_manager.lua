-- Swedz's D&D 5e Condition Manager [Version 1.4] for Tabletop Simulator

-- These are core variables for the script to work. If these are edited, things may break. Do not touch these values.
script_guid = self.getGUID()
button_suffix_condition_active = "_active"
button_suffix_condition_inactive = "_inactive"
conditions_count = 0
condition_button_width = 1500
condition_counter_button_width = 250
selected_object = nil
menu_player = nil

-- Some configuration options, if you are strong enough for it.
config = {
	-- Should hovering on conditions display the description?
	condition_hover_tooltip = true
}

-- Create a color given the RGB values (0 -> 255)
function rgb(red, green, blue)
	return Color(red / 255, green / 255, blue / 255)
end

-- The conditions table, you can edit this as needed
conditions = {
	bane = {
		name = "Bane",
		color = rgb(191, 103, 52),
		description = "While banished, the target is incapacitated. The target remains in the realm the caster picks until the spell ends, at which point the target reappears in the space it left or in the nearest unoccupied space if that space is occupied."
	},
	banished = {
		name = "Banished",
		color = rgb(64, 64, 64),
		description = "While banished, the target is incapacitated. The target remains in the realm the caster picks until the spell ends, at which point the target reappears in the space it left or in the nearest unoccupied space if that space is occupied."
	},
	bladesinging = {
		name = "Bladesinging",
		color = rgb(98, 184, 227),
		description = "You gain a bonus to your AC equal to your Intelligence modifier (minimum of +1).\n\nYour walking speed increases by 10 feet.\n\nYou have advantage on Dexterity (Acrobatics) checks.\n\nYou gain a bonus to any Constitution saving throw you make to maintain your concentration on a spell. The bonus equals your Intelligence modifier (minimum of +1)."
	},
	blessed = {
		name = "Blessed",
		color = rgb(252, 255, 176),
		description = "Whenever the creature makes an attack roll or a saving throw before the spell ends, the creature can roll a d4 and add the number rolled to the attack roll or saving throw."
	},
	blinded = {
		name = "Blinded",
		color = rgb(92, 92, 92),
		description = "A blinded creature can't see and automatically fails any ability check that requires sight.\n\nAttack rolls against the creature have advantage, and the creature's attack rolls have disadvantage."
	},
	bloodied = {
		name = "Bloodied",
		color = rgb(53, 3, 3),
		description = "A bloodied creature is one that has been reduced to less than 50% of its maximum hit points."
	},
	blur = {
		name = "Blur",
		color = rgb(196, 196, 196),
		description = "Your body becomes blurred, shifting and wavering to all who can see you. For the duration, any creature has disadvantage on attack rolls against you. An attacker is immune to this effect if it doesn't rely on sight, as with blindsight, or can see through illusions, as with truesight."
	},
	channeldivinity = {
		name = "Channel Divinity",
		color = rgb(240, 255, 253),
		description = "Some Channel Divinities target a single creature."
	},
	charmed = {
		name = "Charmed",
		color = rgb(255, 128, 227),
		description = "A charmed creature can't attack the charmer or target the charmer with harmful abilities or magical effects.\n\nThe charmer has advantage on any ability check to interact socially with the creature."
	},
	concentrating = {
		name = "Concentrating",
		color = rgb(97, 94, 255),
		description = "Some spells require you to maintain concentration in order to keep their magic active. If you lose concentration, such a spell ends.\n\nTaking damage, the DC is 10 OR half the damage taken. This depends on the higher number of the two."
	},
	deafened = {
		name = "Deafened",
		color = rgb(112, 52, 99),
		description = "A deafened creature can't hear and automatically fails any ability check that requires hearing."
	},
	dodging = {
		name = "Dodging",
		color = rgb(145, 100, 100),
		description = "When you take the Dodge action, you focus entirely on avoiding attacks. Until the start of your next turn, any Attack roll made against you has disadvantage if you can see the attacker, and you make Dexterity Saving Throws with advantage. You lose this benefit if you are Incapacitated (as explained in Conditions ) or if your speed drops to 0."
	},
	exhausted = {
		name = "Exhausted",
		color = rgb(145, 100, 100),
		description = "For every point of exhaustion you have, you get a -1 penalty to all saving throws, ability checks, and attacks. When you reach 10 points of exhaustion, you die.",
		counter = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
	},
	faeriefire = {
		name = "Faerie Fire",
		color = rgb(254, 255, 181),
		description = "Any creature in the area when the spell is cast is also outlined in light if it fails a Dexterity saving throw. For the duration, objects and affected creatures shed dim light in a 10-foot radius.\n\nAny attack roll against an affected creature or object has advantage if the attacker can see it, and the affected creature or object can’t benefit from being invisible."
	},
	frightened = {
		name = "Frightened",
		color = rgb(201, 209, 38),
		description = "A frightened creature has disadvantage on ability checks and attack rolls while the source of its fear is within line of sight.\n\nThe creature can't willingly move closer to the source of its fear."
	},
	grappled = {
		name = "Grappled",
		color = rgb(38, 209, 209),
		description = "A grappled creature's speed becomes 0, and it can't benefit from any bonus to its speed.\n\nThe condition ends if the grappler is incapacitated (see the condition).\n\nThe condition also ends if an effect removes the grappled creature from the reach of the grappler or grappling effect, such as when a creature is hurled away by the thunderwave spell."
	},
	hasted = {
		name = "Hasted",
		color = rgb(250, 255, 99),
		description = "The creature's speed is doubled, it gains a +2 bonus to AC, it has advantage on Dexterity saving throws, and it gains an additional action on each of its turns. That action can be used only to take the Attack (one weapon attack only), Dash, Disengage, Hide, or Use an Object action.\n\nWhen the spell ends, the creature can't move or take actions until after its next turn, as a wave of lethargy sweeps over it."
	},
	heatmetal = {
		name = "Heat Metal",
		color = rgb(255, 184, 51),
		description = "Choose a manufactured metal object, such as a metal weapon or a suit of heavy or medium metal armor, that you can see within range. You cause the object to glow red-hot. Any creature in physical contact with the object takes 2d8 fire damage when you cast the spell. Until the spell ends, you can use a bonus action on each of your subsequent turns to cause this damage again.\n\nIf a creature is holding or wearing the object and takes the damage from it, the creature must succeed on a Constitution saving throw or drop the object if it can. If it doesn't drop the object, it has disadvantage on attack rolls and ability checks until the start of your next turn.\n\nWhen you cast this spell using a spell slot of 3rd level or higher, the damage increases by 1d8 for each slot level above 2nd."
	},
	hexed = {
		name = "Hexed",
		color = rgb(175, 94, 255),
		description = "The target is cursed. Until the spell ends, you deal an extra 1d6 necrotic damage to the target when attacking. Also, choose one ability, when you cast the spell. The target has disadvantage on ability checks with the chosen ability.\n\nIf the target drops to 0 hit points before this spell ends, you can use a bonus action on a subsequent turn of yours to curse a new creature."
	},
	huntersmark = {
		name = "Hunter's Mark",
		color = rgb(45, 214, 73),
		description = "The target is mystically marked as your quarry. Until the spell ends, you deal an extra 1d6 damage to the target whenever you hit it with a weapon attack, and you have advantage on any Wisdom (Perception) or Wisdom (Survival) checks you make to find it.\n\nIf the target drops to 0 hit points before this spell ends, you can use a bonus action on a subsequent turn of yours to mark a new creature."
	},
	incapacitated = {
		name = "Incapacitated",
		color = rgb(176, 86, 30),
		description = "An incapacitated creature can't take actions or reactions."
	},
	invisible = {
		name = "Invisible",
		color = rgb(255, 255, 255),
		description = "An invisible creature is impossible to see without the aid of magic or a special sense. For the purpose of hiding, the creature is heavily obscured. The creature's location can be detected by any noise it makes or any tracks it leaves.\n\nAttack rolls against the creature have disadvantage, and the creature's attack rolls have advantage."
	},
	legendaryaction = {
		name = "Legendary Action",
		color = rgb(255, 215, 0),
		description = "The number of Legendary Actions this creature has remaining this round. Legendary Actions can only be used at the end of another creature's turn, and only one legendary action can be used at a time.",
		counter = { 4, 3, 2, 1, 0 }
	},
	mirrorimage = {
		name = "Mirror Image",
		color = rgb(218, 163, 255),
		description = "Three illusory duplicates of yourself appear in your space. Until the spell ends, the duplicates move with you and mimic your actions, shifting position so it's impossible to track which image is real. You can use your action to dismiss the illusory duplicates.\n\nEach time a creature targets you with an attack during the spell's duration, roll a d20 to determine whether the attack instead targets one of your duplicates.\n\nIf you have three duplicates, you must roll a 6 or higher to change the attack's target to a duplicate. With two duplicates, you must roll an 8 or higher. With one duplicate, you must roll an 11 or higher.\n\nA duplicate's AC equals 10 + your Dexterity modifier. If an attack hits a duplicate, the duplicate is destroyed. A duplicate can be destroyed only by an attack that hits it. It ignores all other damage and effects. The spell ends when all three duplicates are destroyed.\n\nA creature is unaffected by this spell if it can't see, if it relies on senses other than sight, such as blindsight, or if it can perceive illusions as false, as with truesight.",
		counter = { 3, 2, 1 }
	},
	paralyzed = {
		name = "Paralyzed",
		color = rgb(176, 30, 174),
		description = "A paralyzed creature is incapacitated (see the condition) and can't move or speak.\n\nThe creature automatically fails Strength and Dexterity saving throws. Attack rolls against the creature have advantage.\n\nAny attack that hits the creature is a critical hit if the attacker is within 5 feet of the creature."
	},
	petrified = {
		name = "Petrified",
		color = rgb(246, 255, 189),
		description = "A petrified creature is transformed, along with any nonmagical object it is wearing or carrying, into a solid inanimate substance (usually stone). Its weight increases by a factor of ten, and it ceases aging.\n\nThe creature is incapacitated (see the condition), can't move or speak, and is unaware of its surroundings.\n\nAttack rolls against the creature have advantage.\n\nThe creature automatically fails Strength and Dexterity saving throws.\n\nThe creature has resistance to all damage.\n\nThe creature is immune to poison and disease, although a poison or disease already in its system is suspended, not neutralized."
	},
	poisoned = {
		name = "Poisoned",
		color = rgb(11, 128, 0),
		description = "A poisoned creature has disadvantage on attack rolls and ability checks."
	},
	prone = {
		name = "Prone",
		color = rgb(140, 88, 136),
		description = "A prone creature's only movement option is to crawl, unless it stands up and thereby ends the condition.\n\nThe creature has disadvantage on attack rolls.\n\nAn attack roll against the creature has advantage if the attacker is within 5 feet of the creature. Otherwise, the attack roll has disadvantage."
	},
	raging = {
		name = "Raging",
		color = rgb(112, 17, 17),
		description = "You have advantage on Strength check and Strength saves.\n\nWhen you make a melee weapon attack using Strength, you gain a +2 to the damage roll. This bonus increases at 9th and 16th level.\n\nYou have resistance to bludgeoning, piercing, and slashing damage."
	},
	restrained = {
		name = "Restrained",
		color = rgb(0, 121, 128),
		description = "A restrained creature's speed becomes 0, and it can't benefit from any bonus to its speed.\n\nAttack rolls against the creature have advantage, and the creature's attack rolls have disadvantage.\n\nThe creature has disadvantage on Dexterity saving throws."
	},
	shadowofmoil = {
		name = "Shadow of Moil",
		color = rgb(88, 28, 148),
		description = "Flame-like shadows wreathe your body until the spell ends, causing you to become heavily obscured to others. The shadows turn dim light within 10 feet of you into darkness, and bright light in the same area to dim light.\n\nUntil the spell ends, you have resistance to radiant damage. In addition, whenever a creature within 10 feet of you hits you with an attack, the shadows lash out at that creature, dealing it 2d8 necrotic damage."
	},
	shield = {
		name = "Shield",
		color = rgb(161, 255, 246),
		description = "An invisible barrier of magical force appears and protects you. Until the start of your next turn, you have a +5 bonus to AC, including against the triggering attack, and you take no damage from magic missile."
	},
	silenced = {
		name = "Silenced",
		color = rgb(178, 190, 181),
		description = "A silenced creature cannot speak or use any spells or abilities that require verbal components."
	},
	slowed = {
		name = "Slowed",
		color = rgb(53, 49, 112),
		description = "You alter time around up to six creatures of your choice in a 40-foot cube within range. Each target must succeed on a Wisdom saving throw or be affected by this spell for the duration.\n\nAn affected target's speed is halved, it takes a −2 penalty to AC and Dexterity saving throws, and it can't use reactions. On its turn, it can use either an action or a bonus action, not both. Regardless of the creature's abilities or magic items, it can't make more than one melee or ranged attack during its turn.\n\nIf the creature attempts to cast a spell with a casting time of 1 action, roll a d20. On an 11 or higher, the spell doesn't take effect until the creature's next turn, and the creature must use its action on that turn to complete the spell. If it can't, the spell is wasted.\n\nA creature affected by this spell makes another Wisdom saving throw at the end of each of its turns. On a successful save, the effect ends for it."
	},
	stunned = {
		name = "Stunned",
		color = rgb(181, 251, 255),
		description = "A stunned creature is incapacitated (see the condition), can't move, and can speak only falteringly.\n\nThe creature automatically fails Strength and Dexterity saving throws.\n\nAttack rolls against the creature have advantage."
	},
	unconscious = {
		name = "Unconscious",
		color = rgb(255, 0, 0),
		description = "An unconscious creature is incapacitated, can't move or speak, and is unaware of its surroundings.\n\nThe creature drops whatever it's holding and falls prone.\n\nThe creature automatically fails Strength and Dexterity saving throws.\n\nAttack rolls against the creature have advantage.\n\nAny attack that hits the creature is a critical hit if the attacker is within 5 feet of the creature."
	},
	wounded = {
		name = "Wounded",
		color = rgb(207, 51, 41),
		description = "You have been seriously injured. What this means varies from effect to effect, so I will not be writing a description. So sorry.",
		counter = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
	}
}

-- Data used for keeping track of conditions and their metadata
object_conditions = {}
object_condition_metadata = {}

-- Triggered when the script loads.
function onLoad(script_state)
	-- Count how many conditions we have loaded, so we can use it later
	conditions_count = sizeOf(conditions)
	-- Determine the width condition buttons should be
	condition_button_width = 1500
	for condition_id, condition in pairs(conditions) do
		local condition_name = condition["name"]
		local condition_name_width = string.len(condition_name) * 135
		if condition_name_width > condition_button_width then
			condition_button_width = condition_name_width
		end
	end
	condition_button_width = math.ceil(condition_button_width / 100) * 100
	
	-- Load in our saved data
	local state = default(JSON.decode(script_state), {})
	object_conditions = default(state["object_conditions"], {})
	object_condition_metadata = default(state["object_condition_metadata"], {})
	
	-- Set up the global context menu to reload the script, in case some weird stuff happen
	clearContextMenu()
	addContextMenuItem("Run Condition Script", runScript, false, false)
	
	-- Runs the script, so we don't need to manually do so each load
	runScript(nil)
end

-- Triggered when the script is being saved
function onSave()
	local state = {
		object_conditions = object_conditions,
		object_condition_metadata = object_condition_metadata
	}
	return JSON.encode(state)
end

-- Run the condition script. This is either triggered by load clicking the run button in the table's global context menu.
function runScript(player_color)
	for _, obj in ipairs(getAllObjects()) do
		if isFigurine(obj) then
			setupConditionableObject(obj)
		end
	end
end

-- Sets up the object to be conditionable.
function setupConditionableObject(obj)
	-- Creates the context menu items. Removes them before, just in case it already existed for this object
	obj.clearContextMenu()
	obj.addContextMenuItem("Conditions", function(player_color)
		openConditionMenu(player_color, obj)
	end, false)
	obj.addContextMenuItem("Clear Conditions", function(player_color)
		clearConditions(obj)
	end, false)
	
	-- Clears the existing buttons (displayed conditions) from the object
	obj.clearButtons()
	
	-- Creates the active condition displays
	for index, condition_id in ipairs(getActiveConditions(obj)) do
		createConditionDisplay(obj, condition_id, index)
	end
end

-- Creates the condition display for the specified condition at the index on the object.
-- The "condition display" is the button that appears above figurines when they have conditions.
function createConditionDisplay(obj, condition_id, index)
	local is_heroforge_model = isHeroForgeModel(obj)
	local condition = conditions[condition_id]
	
	local y_pos = 2.2 + ((index - 1) * 0.3) -- Should probably use relative height of the object instead of 2.2, but it seems to work for most models.
	
	-- The rotations for hero forge models are different from the generic models the tabletop model mod.
	local condition_rotation = { 270, 0, 0 }
	if is_heroforge_model then
		condition_rotation = { 0, 90, 270 }
	end
	
	-- The description for the condition is conditional based on the config
	local condition_tooltip
	if config["condition_hover_tooltip"] then
		condition_tooltip = condition["name"] .. ":\n\n" .. condition["description"]
	end
	
	if condition["counter"] == nil then
		obj.createButton({
			click_function = "clickedConditionDisplay",
			function_owner = self,
			label = condition["name"],
			position = { 0, y_pos, 0 },
			rotation = condition_rotation,
			scale = { 0.5, 0.5, 0.5 },
			color = condition["color"],
			hover_color = condition["color"],
			press_color = condition["color"],
			font_color = { 1, 1, 1 },
			width = condition_button_width,
			height = 250,
			font_size = 200,
			tooltip = condition_tooltip,
			alignment = 3
		})
	else
		-- I do not have a justification for this magic multiplier. Do not ask me.
		local magic_multiplier = 0.00104
		local condition_name_button_width = condition_button_width - condition_counter_button_width
		local condition_name_button_position = { ((condition_button_width / 2) - condition_counter_button_width - (condition_name_button_width / 2)) * magic_multiplier, y_pos, 0 }
		local condition_counter_button_position = { ((condition_button_width / 2) - (condition_counter_button_width / 2)) * magic_multiplier, y_pos, 0 }
		if is_heroforge_model then
			flip(condition_name_button_position, 1, 3)
			flip(condition_counter_button_position, 1, 3)
		end
		
		obj.createButton({
			click_function = "clickedConditionDisplay",
			function_owner = self,
			label = condition["name"],
			position = condition_name_button_position,
			rotation = condition_rotation,
			scale = { 0.5, 0.5, 0.5 },
			color = condition["color"],
			hover_color = condition["color"],
			press_color = condition["color"],
			font_color = { 1, 1, 1 },
			width = condition_name_button_width,
			height = 250,
			font_size = 200,
			tooltip = condition_tooltip
		})
		
		local counter_function_name = obj.getGUID() .. "_clickedConditionCounter_" .. condition_id
		_G[counter_function_name] = function(obj, player_color, alt_click)
			clickedConditionCounter(obj, player_color, alt_click, condition_id)
		end
		local counter_array = condition["counter"]
		local counter = default(getConditionMetadata(obj, condition_id)["counter"], counter_array[1])
		obj.createButton({
			click_function = counter_function_name,
			function_owner = self,
			label = counter,
			position = condition_counter_button_position,
			rotation = condition_rotation,
			scale = { 0.5, 0.5, 0.5 },
			color = condition["color"],
			hover_color = condition["color"],
			press_color = condition["color"],
			font_color = { 1, 1, 1 },
			width = condition_counter_button_width,
			height = 250,
			font_size = 200
		})
	end
end

-- Triggered when the condition display is clicked.
-- The "condition display" is the button that appears above figurines when they have conditions.
function clickedConditionDisplay(obj, player_color, alt_click)
	-- do nothing at the moment
end

-- Triggered when the condition counter is clicked.
function clickedConditionCounter(obj, player_color, alt_click, condition_id)
	-- Figure out what is the next counter value in the array
	local counter_array = conditions[condition_id]["counter"]
	local metadata = getConditionMetadata(obj, condition_id)
	local current_value = default(metadata["counter"], counter_array[1])
	local current_index = default(indexOf(counter_array, current_value), 1)
	local max_index = sizeOf(counter_array)
	local next_index = current_index
	if alt_click then
		next_index = next_index - 1
		if next_index < 1 then
			next_index = max_index
		end
	else
		next_index = next_index + 1
		if next_index > max_index then
			next_index = 1
		end
	end
	local next_value = counter_array[next_index]
	-- Update the metadata value to use the next value in the array
	metadata["counter"] = next_value
	setConditionMetadata(obj, condition_id, metadata)
	
	-- Update the display for the conditions
	setupConditionableObject(obj)
end

-- Build the UI XML for a condition's button
function buildUIConditionButton(condition_id, condition, active)
	local color = condition["color"]:toHex(false)
	local button = "<Button id=\"" .. condition_id
	if active then
		button = button .. button_suffix_condition_active .. "\" onClick=\"" .. script_guid .. "/clickRemoveCondition\""
	else
		button = button .. button_suffix_condition_inactive .. "\" onClick=\"" .. script_guid .. "/clickAddCondition\""
	end
	return button .. " class=\"condition_toggle\" color=\"#" .. color .. "\">" .. condition["name"] .. "</Button>"
end

-- Builds the UI XML to display
-- Automatically includes buttons for all conditions in the configuration
function buildUIXml()
	local xml = self.UI.getXml()
	local xml_inactive_buttons = {}
	local xml_active_buttons = {}
	local condition_index = 1
	for condition_id, condition in pairs(conditions) do
		xml_inactive_buttons[condition_index] = buildUIConditionButton(condition_id, condition, false)
		xml_active_buttons[condition_index] = buildUIConditionButton(condition_id, condition, true)
		condition_index = condition_index + 1
	end
	xml = string.gsub(xml, "{{INACTIVE_BUTTONS}}", table.concat(xml_inactive_buttons))
	xml = string.gsub(xml, "{{ACTIVE_BUTTONS}}", table.concat(xml_active_buttons))
	return xml
end

-- Opens the condition UI for the object.
function openConditionMenu(player_color, obj)
	-- If the menu is already opened, prevent the player from opening it
	if menu_player ~= nil and menu_player ~= player_color and Player[menu_player].seated then
		Player[player_color].showInfoDialog("The condition menu is already opened by " .. Player[menu_player].steam_name .. ".")
		return
	end
	
	selected_object = obj
	menu_player = player_color
	UI.setXml(buildUIXml(), {})
	local function afterLoad()
		UI.setAttribute("close", "onClick", script_guid .. "/closeConditionMenu")
		UI.setAttribute("conditions_panel", "visibility", player_color)
		
		-- Hide and show which buttons depending on what conditions are active.
		for condition_id, condition in pairs(conditions) do
			local active_id = condition_id .. button_suffix_condition_active
			local inactive_id = condition_id .. button_suffix_condition_inactive
			if hasCondition(obj, condition_id) then
				UI.setAttribute(active_id, "active", "true")
				UI.setAttribute(inactive_id, "active", "false")
			else
				UI.setAttribute(active_id, "active", "false")
				UI.setAttribute(inactive_id, "active", "true")
			end
		end
		
		-- Show the menu itself
		UI.show("conditions_panel")
		UI.setAttribute("conditions_panel", "active", "true")
	end
	local function condition()
		return not UI.loading
	end
	local function timeout()
		Player[player_color].showInfoDialog("Took too long to load the condition menu. Something may have gone wrong?")
	end
	Wait.condition(afterLoad, condition, 10, timeout)
end

-- Triggered when the X button is pressed in the UI.
-- Closes the UI menu.
function closeConditionMenu(player, value, id)
	UI.hide("conditions_panel")
	UI.setAttribute("conditions_panel", "active", "false")
	selected_object = nil
	menu_player = nil
end

-- Triggered when an inactive condition is clicked in the UI.
function clickAddCondition(player, _, id)
	if selected_object == nil then
		return
	end
	local condition_id = string.gsub(id, button_suffix_condition_inactive, "")
	addCondition(selected_object, condition_id)
end

-- This will hide the clicked button (inactive condition) and show the active condition button.
function addCondition(obj, condition_id)
	setCondition(obj, condition_id, true)
	setupConditionableObject(obj)
	
	UI.show(condition_id .. button_suffix_condition_active)
	UI.hide(condition_id .. button_suffix_condition_inactive)
end

-- Triggered when an active condition is clicked in the UI.
function clickRemoveCondition(player, _, id)
	if selected_object == nil then
		return
	end
	local condition_id = string.gsub(id, button_suffix_condition_active, "")
	removeCondition(selected_object, condition_id)
end

-- This will hide the clicked button (active condition) and show the inactive condition button.
function removeCondition(obj, condition_id)
	setCondition(obj, condition_id, false)
	setConditionMetadata(obj, condition_id, nil)
	
	setupConditionableObject(obj)
	
	UI.show(condition_id .. button_suffix_condition_inactive)
	UI.hide(condition_id .. button_suffix_condition_active)
end

-- Remove all of the conditions from the object.
function clearConditions(obj)
	for condition_id, condition in pairs(conditions) do
		setCondition(obj, condition_id, false)
		setConditionMetadata(obj, condition_id, nil)
		UI.show(condition_id .. button_suffix_condition_inactive)
		UI.hide(condition_id .. button_suffix_condition_active)
	end
	setupConditionableObject(obj)
end

-- Modify the condition state for an object
function setCondition(obj, condition_id, active)
	local object_data = default(object_conditions[obj.getGUID()], {})
	if active then
		object_data[condition_id] = true
	else
		object_data[condition_id] = nil
	end
	object_conditions[obj.getGUID()] = object_data
end

-- Check if the object has the following condition
function hasCondition(obj, condition_id)
	local object_data = default(object_conditions[obj.getGUID()], {})
	return object_data[condition_id] ~= nil
end

-- Get all of the active conditions for an object
-- Returns a table of {id = condition_id} relations
function getActiveConditions(obj)
	local conditions_active = {}
	local index = 1
	for condition_id, condition in pairs(conditions) do
		if hasCondition(obj, condition_id) then
			conditions_active[index] = condition_id
			index = index + 1
		end
	end
	return conditions_active
end

-- Get the condition metadata for the object with the specified condition
function getConditionMetadata(obj, condition_id)
	local object_data = default(object_condition_metadata[obj.getGUID()], {})
	return default(object_data[condition_id], {})
end

-- Update the object's condition metadata for the condition to be the metadata specified
function setConditionMetadata(obj, condition_id, metadata)
	local object_data = default(object_condition_metadata[obj.getGUID()], {})
	object_data[condition_id] = metadata
	object_condition_metadata[obj.getGUID()] = object_data
end

-- Events

-- Track when new figurines are spawned in. Automatically set them up to be conditionable.
function onObjectSpawn(obj)
	if isFigurine(obj) then
		setupConditionableObject(obj)
	end
end

-- Utility methods

-- Get the number of elements in the table
function sizeOf(table)
	local count = 0
	for k, v in pairs(table) do
		count = count + 1
	end
	return count
end

-- Get the index of an element in the table
function indexOf(table, element)
	for index, e in ipairs(table) do
		if e == element then
			return index
		end
	end
end

-- Flip the values in the table given the two indexes
function flip(table, index_a, index_b)
	local value_a = table[index_a]
	table[index_a] = table[index_b]
	table[index_b] = value_a
end

-- Return either the value or the default_value. If the value is nil, the default_value is returned.
function default(value, default_value)
	if value == nil then
		return default_value
	else
		return value
	end
end

-- Check if the object is a figurine
function isFigurine(obj)
	return obj.type == "Figurine"
end

-- Check if the object is a hero forge model
function isHeroForgeModel(obj)
	return obj.AssetBundle ~= nil
end