-- Original: Arislan / Modified: Finanx
-- Haste/DW Detection Requires Gearinfo Addon
-- Dressup is setup to auto load with this Lua
-- Itemizer addon is required for auto gear sorting / Warp Scripts / Range Scripts
--
-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      	[ F9 ]              Cycle Offense Mode
--              	[ F10 ]             Cycle Idle Mode
--              	[ F11 ]             Cycle Casting Mode
--              	[ F12 ]             Update Current Gear / Report Current Status
--					[ CTRL + F9 ]		Cycle Weapon Skill Mode
--					[ ALT + F9 ]		Cycle Range Mode
--              	[ Windows + F9 ]    Cycle Hybrid Modes
--					[ Windows + ` ]		Toggles Treasure Hunter Mode
--              	[ Windows + C ]     Toggle Capacity Points Mode
--
--
--  Abilities:  	[ CTRL + ` ]        Perfect Counter
--					[ Alt + ` ]        	Innin
--
--
--  Weapons:    	[ CTRL + W ]        Toggles Weapon Lock
--  				[ CTRL + R ]        Toggles Range Lock
--
--
--  WS:         	[ CTRL + Numpad1 ]    Victory Smite
--					[ CTRL + Numpad2 ]    Tornado Kick
--					[ CTRL + Numpad3 ]    Raging Fists
--					[ CTRL + Numpad4 ]    Howling Fist
--					[ CTRL + Numpad5 ]    Shijin Spiral
--					[ CTRL + Numpad6 ]    Asuran Fists
--					[ CTRL + Numpad7 ]    Spinning Attack
--				
--					[ ALT + Numpad1 ]     Shell Crusher
--
--
-- Item Binds:		[ Windows + Numpad1 ]	Echo Drops
--					[ Windows + Numpad2 ]	Remedy
--					[ Windows + Numpad3 ]	Panacea
--					[ Windows + Numpad4 ]	Sublime Sushi
--					[ Windows + Numpad5 ]	Red Curry Bun
--					[ Windows + Numpad6 ]	Miso Ramen
--					[ Windows + Numpad7 ]	Tropical Crepe
--
--
-- Warp Script:		[ CTRL + Numpad+ ]	Warp Ring
--					[ ALT + Numpad+ ]	Dimensional Ring Dem
--
--
-- Range Script:	[ CTRL + Numpad0 ] (Auto Retrieves Trollbane from Satchel and puts it back once finished)
--
--
-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------
--
--
--  TH Modes:  None                 Will never equip TH gear
--             Tag                  Will equip TH gear sufficient for initial contact with a mob
--
--
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

	include('Mote-TreasureHunter')
	
    state.Buff.Footwork = buffactive.Footwork or false
    state.Buff.Impetus = buffactive.Impetus or false

    state.FootworkWS = M(false, 'Footwork on WS')

    info.impetus_hit_count = 0
    windower.raw_register_event('action', on_action_for_impetus)
	
	lockstyleset = 10
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT', 'Counter')
	state.TreasureMode:options('Tag', 'None')

    state.CP = M(false, "Capacity Points Mode")
    update_combat_form()
    update_melee_groups()
	
	--Load Dressup Lua

	send_command('wait 5; lua l Dressup')
	
    --Global Monk binds (^ = CTRL)(! = ALT)(@ = Windows key)(~ = Shift)(# = Apps key)

	send_command('bind @` gs c cycle treasuremode')
	send_command('bind @w gs c cycle WeaponSet')
    send_command('bind @c gs c toggle CP')
	send_command('bind ^` input /ja "Perfect Counter" <me>')

	--Weaponskill Binds

    send_command('bind ^numpad1 input /ws "Victory Smite" <t>')
    send_command('bind ^numpad2 input /ws "Tornado Kick" <t>')
    send_command('bind ^numpad3 input /ws "Raging Fists" <t>')
	send_command('bind ^numpad4 input /ws "Howling Fist" <t>')
	send_command('bind ^numpad5 input /ws "Shijin Spiral" <t>')
    send_command('bind ^numpad6 input /ws "Asuran Fists" <t>')
	send_command('bind ^numpad7 input /ws "Spinning Attack" <t>')
	send_command('bind ^numpad9 input /ws "Ascetic\'s Fury" <t>')
	
	send_command('bind !numpad1 input /ws "Shell Crusher" <t>')	
	
	--Dual Box binds
	
	send_command('bind @1 input //assist me; wait 0.5; input //send Aurorasky /attack')
	send_command('bind @2 input //assist me; wait 0.5; input //send Ardana /attack')
	send_command('bind @q input //assist me; wait 0.5; input //send Ardana /ma "Distract" <t>')
	
	--Item binds
	
	send_command('bind @numpad1 input /item "Echo Drops" <me>')
    send_command('bind @numpad2 input /item "Remedy" <me>')
    send_command('bind @numpad3 input /item "Panacea" <me>')
	send_command('bind @numpad4 input /item "Sublime Sushi" <me>')
	send_command('bind @numpad5 input /item "Red Curry Bun" <me>')
	send_command('bind @numpad6 input /item "Miso Ramen" <me>')
	send_command('bind @numpad7 input /item "Tropical Crepe" <me>')
		
	--Ranged Scripts (This allows every job ranged / trollbane to stay in satchel fulltime) (Requires Itemizer Addon)

	send_command('bind ^numpad0 input //get Trollbane satchel;wait 0.5;input /ra <t>;wait 5; input //put Trollbane satchel')

	--Warp scripts (this allows the ring to stay in your satchel fulltime) (Requires Itemizer Addon)

	send_command('bind ^numpad+ input //get Warp Ring satchel; wait 1; input /equip Ring1 "Warp Ring"; wait 12; input /item "Warp Ring" <me>; wait 60; input //put Warp Ring satchel')
	send_command('bind !numpad+ input //get Dim. Ring (Dem) satchel; wait 1; input /equip Ring1 "Dim. Ring (Dem)"; wait 12; input /item "Dim. Ring (Dem)" <me>; wait 60; input //put Dim. Ring (Dem) satchel')
	
	--Gear Retrieval Commands
	
	--send_command('wait 3; input //get Ochu Case all')


	--Job Settings

    select_default_macro_book()
	set_lockstyle()
end


function user_unload()

	--Remove Global Ninja Binds
	
    send_command('unbind @`')
    send_command('unbind @w')
    send_command('unbind @e')
	send_command('unbind ^`')
	
	
	--Remove Dual Box Binds
	
	send_command('unbind @1')
	send_command('unbind @2')
	send_command('unbind @q')
	
	--Remove Weaponskill Binds
    
	send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad6')
	send_command('unbind ^numpad7')
	
	send_command('unbind !numpad1')
    send_command('unbind !numpad2')
	send_command('unbind !numpad3')
    send_command('unbind !numpad4')
	send_command('unbind !numpad5')
    send_command('unbind !numpad6')
	send_command('unbind !numpad7')
	
	
	--Remove Item Binds
	
	send_command('unbind @numpad1')
    send_command('unbind @numpad2')
	send_command('unbind @numpad3')
    send_command('unbind @numpad4')
	send_command('unbind @numpad5')
    send_command('unbind @numpad6')
	send_command('unbind @numpad7')
	
	--Remove Ranged Scripts
	
	send_command('unbind ^numpad0')
	
	--Remove Warp Scripts
	
	send_command('unbind ^numpad+')
	send_command('unbind !numpad+')
	
	--Unload Dressup Lua
	
	send_command('lua u Dressup')
	
	--Gear Removal Commands

	--send_command('input //put Ochu Case all')
	
	
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
    
    -- Precast sets to enhance JAs on use
    sets.precast.JA['Hundred Fists'] = {legs="Hesychast's Hose +1"}
    sets.precast.JA['Boost'] = {hands="Anchorite's Gloves +1"}
    sets.precast.JA['Dodge'] = {feet="Anchorite's Gaiters +1"}
    sets.precast.JA['Focus'] = {head="Anchorite's Crown +1"}
    sets.precast.JA['Counterstance'] = {feet="Hesychast's Gaiters +1"}
    sets.precast.JA['Footwork'] = {feet="Tantra Gaiters +2"}
    sets.precast.JA['Formless Strikes'] = {body="Hesychast's Cyclas"}
    sets.precast.JA['Mantra'] = {feet="Hesychast's Gaiters +1"}

    sets.precast.JA['Chi Blast'] = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Staunch Tathlum +1",
		head="Rawhide Mask",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Ahosi Leggings",
		neck="Phalaina Locket",
		waist="Luminary Sash",
		left_ear="Genmei Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.precast.JA['Chakra'] = {    
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Hiza. Hizayoroi +2",
		feet="Tatena. Sune. +1",
		neck="Loricate Torque +1",
		waist="Kasiri Belt",
		left_ear="Genmei Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Niqmaddu Ring",
		right_ring="Regal Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    -- Fast cast sets for spells
    
    sets.precast.FC = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Malignance Boots",
		neck="Orunmila's Torque",
		waist="Kasiri Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Knobkierrie",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Herculean Vest", augments={'Accuracy+4','Weapon skill damage +4%','DEX+10','Attack+13',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Hiza. Hizayoroi +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.WS.Acc = {}	
		
	sets.precast.WS["Victory Smite"] = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Knobkierrie",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		legs="Hiza. Hizayoroi +2",
		feet="Mummu Gamash. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Odr Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.precast.WS['Tornado Kick'] = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Knobkierrie",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Herculean Vest", augments={'Accuracy+4','Weapon skill damage +4%','DEX+10','Attack+13',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Hiza. Hizayoroi +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Tornado Kick'].Acc = {}
	
	sets.precast.WS['Raging Fists'] = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Knobkierrie",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Herculean Vest", augments={'Accuracy+4','Weapon skill damage +4%','DEX+10','Attack+13',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Hiza. Hizayoroi +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS["Raging Fists"].Acc = {}
	
	sets.precast.WS['Shijin Spiral'] = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Knobkierrie",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Hiza. Hizayoroi +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Mache Earring +1",
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Shijin Spiral'].Acc = {}
	
	sets.precast.WS['Howling Fist'] = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Knobkierrie",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Herculean Vest", augments={'Accuracy+4','Weapon skill damage +4%','DEX+10','Attack+13',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Hiza. Hizayoroi +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Howling Fist'].Acc = {}
	
		sets.precast.WS['Asuran Fists'] = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Knobkierrie",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Herculean Vest", augments={'Accuracy+4','Weapon skill damage +4%','DEX+10','Attack+13',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Hiza. Hizayoroi +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS["Ascetic's Fury"] = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Knobkierrie",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		legs="Hiza. Hizayoroi +2",
		feet="Mummu Gamash. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Odr Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Spinning Attack'] = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Knobkierrie",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Herculean Vest", augments={'Accuracy+4','Weapon skill damage +4%','DEX+10','Attack+13',}},
		hands="Mummu Wrists +2",
		legs="Hiza. Hizayoroi +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Ishvara Earring",
		right_ear="Sherida Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Gere Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
		
		
    -- Midcast Sets
    sets.midcast.FastRecast = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Malignance Boots",
		neck="Orunmila's Torque",
		waist="Kasiri Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Defending Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
        
    -- Specific spells

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {    
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Kasiri Belt",
		left_ear="Eabani Earring",
		right_ear="Hearty Earring",
		left_ring="Defending Ring",
		right_ring="Chirich Ring +1",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
    

    -- Idle sets
    sets.idle = {    
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Kasiri Belt",
		left_ear="Eabani Earring",
		right_ear="Hearty Earring",
		left_ring="Defending Ring",
		right_ring="Chirich Ring +1",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

 

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee sets
    sets.engaged = {
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Ginsen",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Moonbeam Nodowa",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.engaged.Acc = {ammo="Honed Tathlum",
        head="Whirlpool Mask",neck="Ej Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Hesychast's Gloves +1",ring1="Patricius Ring",ring2="Epona's Ring",
        back="Letalis Mantle",waist="Anguinus Belt",legs="Manibozho Brais",feet="Qaaxo Leggings"}


    -- Defensive melee hybrid sets
    sets.engaged.DT = {    
		main={ name="Hammerfists", augments={'DMG:+15','STR+20','Accuracy+15',}},
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Moonbeam Nodowa",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Defending Ring",
		back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.engaged.Acc.DT = {ammo="Honed Tathlum",
        head="Whirlpool Mask",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Patricius Ring",ring2="Epona's Ring",
        back="Letalis Mantle",waist="Anguinus Belt",legs="Qaaxo Tights",feet="Qaaxo Leggings"}
    
	sets.engaged.Counter = {ammo="Thew Bomblet",
        head="Whirlpool Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="K'ayres Ring",ring2="Epona's Ring",
        back="Atheling Mantle",waist="Windbuffet Belt",legs="Anchorite's Hose",feet="Otronif Boots +1"}
    
	sets.engaged.Acc.Counter = {ammo="Honed Tathlum",
        head="Whirlpool Mask",neck="Ej Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Hesychast's Gloves +1",ring1="Patricius Ring",ring2="Epona's Ring",
        back="Letalis Mantle",waist="Anguinus Belt",legs="Anchorite's Hose",feet="Otronif Boots +1"}


    -- Hundred Fists/Impetus melee set mods
    sets.engaged.HF = set_combine(sets.engaged)
    sets.engaged.HF.Impetus = set_combine(sets.engaged, {body="Tantra Cyclas +2"})
    sets.engaged.Acc.HF = set_combine(sets.engaged.Acc)
    sets.engaged.Acc.HF.Impetus = set_combine(sets.engaged.Acc, {body="Tantra Cyclas +2"})
    sets.engaged.Counter.HF = set_combine(sets.engaged.Counter)
    sets.engaged.Counter.HF.Impetus = set_combine(sets.engaged.Counter, {body="Tantra Cyclas +2"})
    sets.engaged.Acc.Counter.HF = set_combine(sets.engaged.Acc.Counter)
    sets.engaged.Acc.Counter.HF.Impetus = set_combine(sets.engaged.Acc.Counter, {body="Tantra Cyclas +2"})


    -- Footwork combat form
    
	sets.engaged.Footwork = {ammo="Thew Bomblet",
        head="Felistris Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Qaaxo Harness",hands="Hesychast's Gloves +1",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Atheling Mantle",waist="Windbuffet Belt",legs="Hesychast's Hose +1",feet="Anchorite's Gaiters +1"}
    
	sets.engaged.Footwork.Acc = {ammo="Honed Tathlum",
        head="Whirlpool Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Hesychast's Gloves +1",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Letalis Mantle",waist="Anguinus Belt",legs="Hesychast's Hose +1",feet="Anchorite's Gaiters +1"}
		
	-- Hybrid Sets

	sets.engaged.Hybrid = {
		head="Malignance Chapeau", --6%
		body="Malignance Tabard",  --9%
		hands="Malignance Gloves", --5%
		legs="Malignance Tights", --7%
		feet="Malignance Boots", --4%
		right_ring="Defending Ring", --10
        }
		
	sets.engaged.Hybrid.Counter = {}
        
    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.impetus_body = {body="Tantra Cyclas +2"}
	
    sets.footwork_kick_feet = {feet="Anchorite's Gaiters +1"}

    sets.buff.Doom = {
        waist="Gishdubar Sash", --10
        }

    sets.CP = {back="Mecisto. Mantle"}
    
	sets.TreasureHunter = {
		head="Wh. Rarab Cap +1",
		hands={ name="Herculean Gloves", augments={'Weapon skill damage +1%','Magic dmg. taken -2%','"Treasure Hunter"+2','Accuracy+12 Attack+12',}}, --TH+2
		waist="Chaac Belt",}


end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Don't gearswap for weaponskills when Defense is on.
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        eventArgs.handled = true
    end
end

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and state.DefenseMode.current ~= 'None' then
        if state.Buff.Impetus and (spell.english == "Ascetic's Fury" or spell.english == "Victory Smite") then
            -- Need 6 hits at capped dDex, or 9 hits if dDex is uncapped, for Tantra to tie or win.
            if (state.OffenseMode.current == 'Fodder' and info.impetus_hit_count > 5) or (info.impetus_hit_count > 8) then
                equip(sets.impetus_body)
            end
        elseif state.Buff.Footwork and (spell.english == "Dragon's Kick" or spell.english == "Tornado Kick") then
            equip(sets.footwork_kick_feet)
        end
        
        -- Replace Moonshade Earring if we're at cap TP
        if player.tp == 3000 then
            equip(sets.precast.MaxTP)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and not spell.interrupted and state.FootworkWS and state.Buff.Footwork then
        send_command('cancel Footwork')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- Set Footwork as combat form any time it's active and Hundred Fists is not.
    if buff == 'Footwork' and gain and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    elseif buff == "Hundred Fists" and not gain and buffactive.footwork then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
    
    -- Hundred Fists and Impetus modify the custom melee groups
    if buff == "Hundred Fists" or buff == "Impetus" then
        classes.CustomMeleeGroups:clear()
        
        if (buff == "Hundred Fists" and gain) or buffactive['hundred fists'] then
            classes.CustomMeleeGroups:append('HF')
        end
        
        if (buff == "Impetus" and gain) or buffactive.impetus then
            classes.CustomMeleeGroups:append('Impetus')
        end
    end

    -- Update gear if any of the above changed
    if buff == "Hundred Fists" or buff == "Impetus" or buff == "Footwork" then
        handle_equipping_gear(player.status)
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function customize_idle_set(idleSet)
    if player.hpp < 75 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    update_combat_form()
    update_melee_groups()
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


function update_combat_form()
    if buffactive.footwork and not buffactive['hundred fists'] then
        state.CombatForm:set('Footwork')
    else
        state.CombatForm:reset()
    end
end

function update_melee_groups()
    classes.CustomMeleeGroups:clear()
    
    if buffactive['hundred fists'] then
        classes.CustomMeleeGroups:append('HF')
    end
    
    if buffactive.impetus then
        classes.CustomMeleeGroups:append('Impetus')
    end
end

function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
	
    if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end
	
    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'THF' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'RUN' then
        set_macro_page(1, 1)
    else
        set_macro_page(1, 1)
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Custom event hooks.
-------------------------------------------------------------------------------------------------------------------

-- Keep track of the current hit count while Impetus is up.
function on_action_for_impetus(action)
    if state.Buff.Impetus then
        -- count melee hits by player
        if action.actor_id == player.id then
            if action.category == 1 then
                for _,target in pairs(action.targets) do
                    for _,action in pairs(target.actions) do
                        -- Reactions (bitset):
                        -- 1 = evade
                        -- 2 = parry
                        -- 4 = block/guard
                        -- 8 = hit
                        -- 16 = JA/weaponskill?
                        -- If action.reaction has bits 1 or 2 set, it missed or was parried. Reset count.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 1
                        end
                    end
                end
            elseif action.category == 3 then
                -- Missed weaponskill hits will reset the counter.  Can we tell?
                -- Reaction always seems to be 24 (what does this value mean? 8=hit, 16=?)
                -- Can't tell if any hits were missed, so have to assume all hit.
                -- Increment by the minimum number of weaponskill hits: 2.
                for _,target in pairs(action.targets) do
                    for _,action in pairs(target.actions) do
                        -- This will only be if the entire weaponskill missed or was parried.
                        if (action.reaction % 4) > 0 then
                            info.impetus_hit_count = 0
                        else
                            info.impetus_hit_count = info.impetus_hit_count + 2
                        end
                    end
                end
            end
        elseif action.actor_id ~= player.id and action.category == 1 then
            -- If mob hits the player, check for counters.
            for _,target in pairs(action.targets) do
                if target.id == player.id then
                    for _,action in pairs(target.actions) do
                        -- Spike effect animation:
                        -- 63 = counter
                        -- ?? = missed counter
                        if action.has_spike_effect then
                            -- spike_effect_message of 592 == missed counter
                            if action.spike_effect_message == 592 then
                                info.impetus_hit_count = 0
                            elseif action.spike_effect_animation == 63 then
                                info.impetus_hit_count = info.impetus_hit_count + 1
                            end
                        end
                    end
                end
            end
        end
        
        --add_to_chat(123,'Current Impetus hit count = ' .. tostring(info.impetus_hit_count))
    else
        info.impetus_hit_count = 0
    end
    
end

function set_lockstyle()
    send_command('wait 3; input /lockstyleset ' .. lockstyleset)
end
