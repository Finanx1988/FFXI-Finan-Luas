-- Original: Motenten / Modified: Arislan

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+H ]           Toggle Charm Defense Mods
--              [ WIN+D ]           Toggle Death Defense Mods
--              [ WIN+K ]           Toggle Knockback Defense Mods
--              [ WIN+A ]           AttackMode: Capped/Uncapped WS Modifier
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Use current Rune
--              [ CTRL+- ]          Rune element cycle forward.
--              [ CTRL+= ]          Rune element cycle backward.
--              [ CTRL+` ]          Use current Rune
--
--              [ CTRL+Numpad/ ]    Berserk/Meditate/Souleater
--              [ CTRL+Numpad* ]    Warcry/Sekkanoki/Arcane Circle
--              [ CTRL+Numpad- ]    Aggressor/Third Eye/Weapon Bash
--
--
--  Weapons:    [ CTRL+G ]          Cycles between available greatswords
--              [ CTRL+W ]          Toggle Weapon Lock
--
--  WS:         [ CTRL+Numpad7 ]    Resolution
--              [ CTRL+Numpad8 ]    Upheaval
--              [ CTRL+Numpad9 ]    Dimidiation
--              [ CTRL+Numpad5 ]    Ground Strike
--              [ CTRL+Numpad6 ]    Full Break
--              [ CTRL+Numpad1 ]    Herculean Slash
--              [ CTRL+Numpad2 ]    Shockwave
--              [ CTRL+Numpad3 ]    Armor Break
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------


--  gs c rune                       Uses current rune
--  gs c cycle Runes                Cycles forward through rune elements
--  gs c cycleback Runes            Cycles backward through rune elements


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    res = require 'resources'
end

-- Setup vars that are user-independent.
function job_setup()


	include('Mote-TreasureHunter')

    -- /BLU Spell Maps
    blue_magic_maps = {}

    blue_magic_maps.Enmity = S{'Blank Gaze', 'Geist Wall', 'Jettatura', 'Soporific',
        'Poison Breath', 'Blitzstrahl', 'Sheep Song', 'Chaotic Eye'}
    blue_magic_maps.Cure = S{'Wild Carrot'}
    blue_magic_maps.Buffs = S{'Cocoon', 'Refueling'}

    rayke_duration = 35
    gambit_duration = 96

    lockstyleset = 9

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'PDT', 'MDT')
    state.WeaponskillMode:options('Normal')
    state.HybridMode:options('Normal', 'DT')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'Refresh')
    state.PhysicalDefenseMode:options('PDT', 'HP')
    state.MagicalDefenseMode:options('MDT')
	state.TreasureMode:options('Tag', 'None')

    state.Knockback = M(false, 'Knockback')

	state.TH = M(false, "Treasure Hunter Mode")
    state.WeaponSet = M{['description']='Weapon Set', 'Epeolatry', 'Lionheart', 'Aettir', 'GreatAxe'}
    state.AttackMode = M{['description']='Attack', 'Uncapped', 'Capped'}
    state.CP = M(false, "Capacity Points Mode")
    state.WeaponLock = M(false, 'Weapon Lock')

    state.Runes = M{['description']='Runes', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae'}

    -- Additional local binds
	
	if player.sub_job == 'BLU' then
        send_command('lua l azureSets')
    end 

    send_command('bind @a gs c cycle AttackMode')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @c gs c toggle CP')
	send_command('bind @` gs c cycle treasuremode')
	send_command('bind @1 input //assist me; wait 0.5; input //send Aurorasky /attack')
	send_command('bind @2 input //assist me; wait 0.5; input //send Ardana /attack')
	send_command('bind @q input //assist me; wait 0.5; input //send Ardana /ma "Distract" <t>')
	send_command('bind @numpad1 input //send Aurorasky /ws "Last Stand <t>')
	
	send_command('bind ^numpad0 input /ra <t>')

    send_command('bind ^numpad1 input /ws "Resolution" <t>')
    send_command('bind ^numpad2 input /ws "Dimidiation" <t>')
    send_command('bind ^numpad3 input /ws "Ground Strike" <t>')
	send_command('bind ^numpad4 input /ws "Shockwave" <t>')
	send_command('bind ^numpad5 input /ja "Swipe" <t>')
    send_command('bind ^numpad6 input /ja "Lunge" <t>')
	send_command('bind !numpad1 input /ws "Frostbite" <t>')

    

    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^f11')
    send_command('unbind ^insert')
    send_command('unbind ^delete')
    send_command('unbind @a')
    send_command('unbind @c')
    send_command('unbind @w')
	send_command('unbind @`')
	send_command('unbind @1')
	send_command('unbind @2')
	send_command('unbind @q')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind @numpad*')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad6')
	send_command('unbind ^numpad7')
	send_command('unbind ^numpad8')
	send_command('unbind !numpad1')
    send_command('unbind !numpad2')
	send_command('unbind !numpad3')
    send_command('unbind !numpad4')
	send_command('unbind !numpad5')
    send_command('unbind !numpad6')
	send_command('unbind !numpad7')
	send_command('unbind !numpad8')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Enmity sets
	sets.Enmity = {
		ammo="Aqreqaq Bomblet",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +1",
		feet="Ahosi Leggings",
		neck="Futhark Torque +2",
		waist="Kasiri Belt",
		left_ear="Cryptic Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.Enmity.HP = {
		ammo="Aqreqaq Bomblet",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +1",
		feet="Ahosi Leggings",
		neck="Futhark Torque +2",
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}

    sets.precast.JA['Vallation'] = {
		ammo="Aqreqaq Bomblet",
		head="Halitus Helm",
		body="Runeist's Coat +3",
		hands="Kurys Gloves",
		legs="Futhark Trousers +3",
		feet="Ahosi Leggings",
		neck="Futhark Torque +2",
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}}}
		
		
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
	
    sets.precast.JA['Pflug'] = {ammo="Aqreqaq Bomblet",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +1",
		feet="Ahosi Leggings",
		neck="Futhark Torque +2",
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.JA['Battuta'] = {
		ammo="Aqreqaq Bomblet",
		head="Futhark Bandeau +3",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +1",
		feet="Ahosi Leggings",
		neck="Futhark Torque +2",
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.JA['Liement'] = {
		ammo="Aqreqaq Bomblet",
		head="Halitus Helm",
		body="Futhark Coat +3",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +1",
		feet="Ahosi Leggings",
		neck="Futhark Torque +2",
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}

    sets.precast.JA['Lunge'] = {
		ammo="Pemphredo Tathlum",
		head="Rune. Bandeau +3",
		body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs={ name="Herculean Trousers", augments={'"Dual Wield"+1','Pet: VIT+8','Weapon skill damage +8%','Accuracy+1 Attack+1','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Friomisi Earring",
		right_ear="Hecate's Earring",
		left_ring="Acumen Ring",
		right_ring="Eihwaz Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
	
    sets.precast.JA['Gambit'] = {hands="Runeist's Mitons +2"}
    sets.precast.JA['Rayke'] = {feet="Futhark Boots"}
    sets.precast.JA['Elemental Sforzo'] = {
		ammo="Aqreqaq Bomblet",
		head="Halitus Helm",
		body="Futhark Coat +3",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +1",
		feet="Ahosi Leggings",
		neck="Futhark Torque +2",
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Supershear Ring",
		right_ring="Eihwaz Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.JA['Swordplay'] = {hands="Futhark Mitons"}
    sets.precast.JA['Vivacious Pulse'] = {head="Erilaz Galea +1"}
	
	sets.precast.RA = {
		range="Trollbane",
		head="Turms Cap +1",
		body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +1",
		feet="Turms Leggings +1",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}


    -- Fast cast sets for spells
    sets.precast.FC = {
		ammo="Sapience Orb",
		head="Rune. Bandeau +3",
		body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs="Aya. Cosciales +2",
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Orunmila's Torque",
		waist="Kasiri Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}

		

    


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo="Knobkierrie",
		head={ name="Lustratio Cap +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		body={ name="Lustr. Harness +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		hands="Meg. Gloves +2",
		legs="Meg. Chausses +2",
		feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Epona's Ring",
		back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Resolution'] = {
		ammo="Knobkierrie",
		head={ name="Lustratio Cap +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		body={ name="Lustr. Harness +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		hands="Meg. Gloves +2",
		legs="Meg. Chausses +2",
		feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Dimidiation'] = {
		ammo="Knobkierrie",
		head={ name="Lustratio Cap +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		body={ name="Herculean Vest", augments={'Accuracy+4','Weapon skill damage +4%','DEX+10','Attack+13',}},
		hands="Meg. Gloves +2",
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Niqmaddu Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+2','Weapon skill damage +10%',}},}


    sets.precast.WS['Herculean Slash'] = sets.precast.JA['Lunge']

    sets.precast.WS['Shockwave'] = {
		ammo="Pemphredo Tathlum",
		head="Wh. Rarab Cap +1",
		body="Ayanmo Corazza +2",
		hands={ name="Herculean Gloves", augments={'Weapon skill damage +1%','Magic dmg. taken -2%','"Treasure Hunter"+2','Accuracy+12 Attack+12',}},
		legs="Aya. Cosciales +2",
		feet="Aya. Gambieras +2",
		neck="Sanctity Necklace",
		waist="Chaac Belt",
		left_ear="Gwati Earring",
		right_ear="Digni. Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+2','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Frostbite'] = {
		ammo="Seething Bomblet",
		head="Wh. Rarab Cap +1",
		body="Meg. Cuirie +2",
		hands={ name="Herculean Gloves", augments={'Weapon skill damage +1%','Magic dmg. taken -2%','"Treasure Hunter"+2','Accuracy+12 Attack+12',}},
		legs="Meg. Chausses +2",
		feet="Turms Leggings +1",
		neck="Sanctity Necklace",
		waist="Chaac Belt",
		left_ear="Telos Earring",
		right_ear="Digni. Earring",
		left_ring="Rufescent Ring",
		right_ring="Regal Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}

    sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {
        feet="Lustra. Leggings +1",
        ear2="Ishvara Earring",
        back=gear.RUN_WS1_Cape,
        })

    sets.precast.WS['Upheaval'] = sets.precast.WS['Resolution']
    
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	
	sets.midcast.RA = {
		range="Trollbane",
		head="Turms Cap +1",
		body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +1",
		feet="Turms Leggings +1",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = set_combine(sets.midcast.FastRecast, sets.midcast.SpellInterrupt, {{
        ammo="Staunch Tathlum +1", --11
        legs="Carmine Cuisses +1", --20
        --feet=gear.Taeon_Phalanx_feet, --10
        back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},
        }}) -- +10% from merit points

    sets.midcast.Cure = {
		ammo="Aqreqaq Bomblet",
		head="Turms Cap +1",
		body="Runeist's Coat +3",
		hands="Buremte Gloves",
		legs="Eri. Leg Guards +1",
		feet="Turms Leggings +1",
		neck="Phalaina Locket",
		waist="Gishdubar Sash",
		left_ear="Roundel Earring",
		right_ear="Mendi. Earring",
		left_ring="Vocane Ring",
		right_ring="Lebeche Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}

    sets.midcast['Enhancing Magic'] = {
		ammo="Aqreqaq Bomblet",
		head="Erilaz Galea +1",
		body="Manasa Chasuble",
		hands="Runeist's Mitons +2",
		legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Odnowa Earring +1",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}

    
    sets.midcast['Phalanx'] = {
		ammo="Aqreqaq Bomblet",
		head={ name="Fu. Bandeau +3", augments={'Enhances "Battuta" effect',}},
		body={ name="Taeon Tabard", augments={'Phalanx +3',}},
		hands="Runeist's Mitons +2",
		legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
		feet={ name="Taeon Boots", augments={'Phalanx +3',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}
		
	sets.midcast['Temper'] = {
		ammo="Aqreqaq Bomblet",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Manasa Chasuble",
		hands="Runeist's Mitons +2",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Spell interruption rate down-10%',}},}


    sets.midcast['Regen'] = {
		ammo="Aqreqaq Bomblet",
		head="Rune. Bandeau +3",
		body="Manasa Chasuble",
		hands="Runeist's Mitons +2",
		legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
		feet="Turms Leggings +1",
		neck="Incanter's Torque",
		waist="Gishdubar Sash",
		left_ear="Andoaa Earring",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
	
	
    sets.midcast.Refresh = set_combine(sets.midcast.FastRecast, {head="Erilaz Galea +1", waist="Gishdubar Sash", legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},})
    

    --sets.midcast['Divine Magic'] = {}

    sets.midcast.Flash = sets.Enmity
    sets.midcast.Foil = sets.Enmity
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast['Blue Magic'] = {}
    sets.midcast['Blue Magic'].Enmity = sets.Enmity
    sets.midcast['Blue Magic'].Cure = sets.midcast.Cure
    sets.midcast['Blue Magic'].Buff = sets.midcast['Enhancing Magic']


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		ammo="Staunch Tathlum +1",
		head="Turms Cap +1",
		body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +1",
		feet="Turms Leggings +1",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}
		
	sets.idle.Refresh = {
		ammo="Homiliary",
		head="Rawhide Mask",
		body="Runeist's Coat +3",
		hands="Erilaz Gauntlets +1",
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Erilaz Greaves +1",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Fucho-no-Obi",
		left_ear="Eabani Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}



    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.Knockback = {back="Repulse Mantle"}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
		sub="Utu Grip",
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck="Anu Torque",
		waist="Olseni Belt",
		left_ear="Dedition Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Ilabrat Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
	sets.engaged.PDT =	{
		sub="Mensch Strap +1",																											--5%PDT
		ammo="Staunch Tathlum +1",																										--3%DT
		head="Turms Cap +1",
		body={ name="Futhark Coat +3", augments={'Enhances "Elemental Sforzo" effect',}},												--9%DT
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +1",																										--7%PDT
		feet="Turms Leggings +1",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},																		--7%DT
		waist="Flume Belt +1",																											--4%PDT
		left_ear="Eabani Earring",
		right_ear="Odnowa Earring +1",																									--2%MDT
		left_ring="Defending Ring",																										--10%DT
		right_ring="Vocane Ring",																										--7%DT
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Parrying rate+5%',}},}		
			--36% DT 16% PDT 2% MDT

	sets.engaged.MDT = {
		sub="Mensch Strap +1",																											--5%PDT
		ammo="Staunch Tathlum +1",																										--3%DT
		head="Turms Cap +1",
		body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +1",																										--7%PDT
		feet="Turms Leggings +1",
		neck={ name="Futhark Torque +2", augments={'Path: A',}},																		--7%DT
		waist="Flume Belt +1",																											--4%PDT
		left_ear="Eabani Earring",
		right_ear="Odnowa Earring +1",																									--2%MDT
		left_ring="Defending Ring",																										--10%DT
		right_ring="Vocane Ring",																										--7%DT
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken-10%',}},}	--10%PDT
			--27% DT 26% PDT 2@ MDT
		
	

    sets.engaged.Aftermath = {
        }


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.Hybrid = {
		sub="Utu Grip",
		ammo="Yamarang",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Meg. Chausses +2",
		feet={ name="Herculean Boots", augments={'Accuracy+10 Attack+10','"Triple Atk."+4','Accuracy+14',}},
		neck={ name="Futhark Torque +2", augments={'Path: A',}},
		waist="Ioskeha Belt",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Defending Ring",
		right_ring="Vocane Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
		}

    sets.engaged.DT = set_combine(sets.engaged, sets.Hybrid)
	
	sets.TH = {
		hands={ name="Herculean Gloves", augments={'Weapon skill damage +1%','Magic dmg. taken -2%','"Treasure Hunter"+2','Accuracy+12 Attack+12',}},
		waist="Chaac Belt"}



--[[sets.engaged.Aftermath.DT = {
        }
]]

    sets.engaged.Aftermath.DT = {
        head="Aya. Zucchetto +2",
        body="Ashera Harness",
        hands=gear.Adhemar_B_hands,
        legs="Meg. Chausses +2",
        feet=gear.Herc_STP_feet,
        neck="Futhark Torque +2",
        ear1="Sherida Earring",
        ear2="Dedition Earring",
        ring1="Moonlight Ring",
        ring2="Defending Ring",
        back=gear.RUN_TP_Cape,
        waist="Ioskeha Belt +1",
        }    
		


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.TreasureHunter = {
		head="Wh. Rarab Cap +1",
		hands={ name="Herculean Gloves", augments={'Weapon skill damage +1%','Magic dmg. taken -2%','"Treasure Hunter"+2','Accuracy+12 Attack+12',}}, --TH+2
		waist="Chaac Belt",} --TH+1

    sets.buff.Doom = {
        waist="Gishdubar Sash", --10
        }

    sets.Embolden = set_combine(sets.midcast.EnhancingDuration, {back="Evasionist's Cape"})
    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}

    sets.Epeolatry = {main="Epeolatry"}
    sets.Lionheart = {main="Lionheart"}
    sets.Aettir = {main="Aettir"}
    sets.GreatAxe = {main="Hepatizon Axe +1"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    equip(sets[state.WeaponSet.current])

    if buffactive['terror'] or buffactive['petrification'] or buffactive['stun'] or buffactive['sleep'] then
        add_to_chat(167, 'Stopped due to status.')
        eventArgs.cancel = true
        return
    end
    if spell.english == 'Lunge' then
        local abil_recasts = windower.ffxi.get_ability_recasts()
        if abil_recasts[spell.recast_id] > 0 then
            send_command('input /jobability "Swipe" <t>')
--            add_to_chat(122, '***Lunge Aborted: Timer on Cooldown -- Downgrading to Swipe.***')
            eventArgs.cancel = true
            return
        end
    end
    if spell.english == 'Valiance' then
        local abil_recasts = windower.ffxi.get_ability_recasts()
        if abil_recasts[spell.recast_id] > 0 then
            send_command('input /jobability "Vallation" <me>')
            eventArgs.cancel = true
            return
        elseif spell.english == 'Valiance' and buffactive['vallation'] then
            cast_delay(0.2)
            send_command('cancel Vallation') -- command requires 'cancel' add-on to work
        end
    end
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
end

function job_midcast(spell, action, spellMap, eventArgs)
    if state.DefenseMode.value == 'HP' and spell.english ~= "Phalanx" then
        eventArgs.handled = true
        if spell.action_type == 'Magic' then
            if spell.English == 'Flash' or spell.English == 'Foil' or spell.English == 'Stun'
                or blue_magic_maps.Enmity:contains(spell.english) then
                equip(sets.Enmity.HP)
            elseif spell.skill == 'Enhancing Magic' then
                equip(sets.midcast.EnhancingDuration)
            end
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english == 'Lunge' or spell.english == 'Swipe' then
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
    if state.DefenseMode.value == 'None' then
        if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
            if spellMap == 'Refresh' then
                equip(sets.midcast.Refresh)
            end
		end
        if spell.english == 'Phalanx' and buffactive['Embolden'] then
            equip(sets.midcast.EnhancingDuration)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    equip(sets[state.WeaponSet.current])

    if spell.name == 'Rayke' and not spell.interrupted then
        send_command('@timers c "Rayke ['..spell.target.name..']" '..rayke_duration..' down spells/00136.png')
        send_command('wait '..rayke_duration..';input /echo [Rayke just wore off!];')
    elseif spell.name == 'Gambit' and not spell.interrupted then
        send_command('@timers c "Gambit ['..spell.target.name..']" '..gambit_duration..' down spells/00136.png')
        send_command('wait '..gambit_duration..';input /echo [Gambit just wore off!];')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.Charm.current)
    classes.CustomDefenseGroups:append(state.Knockback.current)
    classes.CustomDefenseGroups:append(state.Death.current)

    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.Charm.current)
    classes.CustomMeleeGroups:append(state.Knockback.current)
    classes.CustomMeleeGroups:append(state.Death.current)
end

function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

    if buff == "terror" then
        if gain then
            equip(sets.defense.PDT)
        end
    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
             disable('waist')
        else
            enable('waist')
            handle_equipping_gear(player.status)
        end
    end

    if buff == 'Embolden' then
        if gain then
            equip(sets.Embolden)
            disable('head','legs','back')
        else
            enable('head','legs','back')
            status_change(player.status)
        end
    end

    if buff:startswith('Aftermath') then
        state.Buff.Aftermath = gain
        customize_melee_set()
        handle_equipping_gear(player.status)
    end

    if buff == 'Battuta' and not gain then
        status_change(player.status)
    end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end

    equip(sets[state.WeaponSet.current])

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_update(cmdParams, eventArgs)
    equip(sets[state.WeaponSet.current])
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
	if state.TH.current == 'on' then
        equip(sets.TH)
		disable('hands')
        disable('waist')
    else
		enable('hands')
        enable('waist')
    end
    if state.Knockback.value == true then
        idleSet = set_combine(idleSet, sets.defense.Knockback)
    end

    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry"
        and state.DefenseMode.value == 'None' then
        if state.HybridMode.value == "DT" then
            meleeSet = set_combine(meleeSet, sets.engaged.Aftermath.DT)
        else
            meleeSet = set_combine(meleeSet, sets.engaged.Aftermath)
        end
    end
    if state.Knockback.value == true then
        meleeSet = set_combine(meleeSet, sets.defense.Knockback)
    end
	if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end

function customize_defense_set(defenseSet)
    if buffactive['Battuta'] then
        defenseSet = set_combine(defenseSet, sets.defense.Parry)
    end
    if state.Knockback.value == true then
        defenseSet = set_combine(defenseSet, sets.defense.Knockback)
    end

    return defenseSet
end

-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local r_msg = state.Runes.current
    local r_color = ''
    if state.Runes.current == 'Ignis' then r_color = 167
    elseif state.Runes.current == 'Gelus' then r_color = 210
    elseif state.Runes.current == 'Flabra' then r_color = 204
    elseif state.Runes.current == 'Tellus' then r_color = 050
    elseif state.Runes.current == 'Sulpor' then r_color = 215
    elseif state.Runes.current == 'Unda' then r_color = 207
    elseif state.Runes.current == 'Lux' then r_color = 001
    elseif state.Runes.current == 'Tenebrae' then r_color = 160 end

    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local am_msg = '(' ..string.sub(state.AttackMode.value,1,1).. ')'

    local ws_msg = state.WeaponskillMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.Knockback.value == true then
        msg = msg .. ' Knockback Resist |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end

    add_to_chat(r_color, string.char(129,121).. '  ' ..string.upper(r_msg).. '  ' ..string.char(129,122)
        ..string.char(31,210).. ' Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002).. ' |'
        ..string.char(31,207).. ' WS' ..am_msg.. ': ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060)
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002).. ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002).. ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'rune' then
        send_command('@input /ja '..state.Runes.value..' <me>')
    end
end

function get_custom_wsmode(spell, action, spellMap)
    if spell.type == 'WeaponSkill' and state.AttackMode.value == 'Uncapped' then
        return "Uncapped"
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book: (set, book)
    if player.sub_job == 'BLU' then
        set_macro_page(1, 7)
    elseif player.sub_job == 'DRK' then
        set_macro_page(1, 7)
    elseif player.sub_job == 'WHM' then
        set_macro_page(1, 7)
    else
        set_macro_page(1, 7)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end