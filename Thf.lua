-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

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
--              [ CTRL+` ]          Cycle Treasure Hunter Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ ALT+` ]           Flee
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Exenterator
--              [ CTRL+Numpad8 ]    Mandalic Stab
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
--
--  TH Modes:  None                 Will never equip TH gear
--             Tag                  Will equip TH gear sufficient for initial contact with a mob (either melee,
--
--             SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
--             Fulltime - Will keep TH gear equipped fulltime


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
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}



    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    state.CP = M(false, "Capacity Points Mode")

    lockstyleset = 11
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'HighAcc')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'Refresh')
	state.Warp = M(false, 'Warp')

    -- Additional local binds
    send_command('lua l gearinfo')

    send_command('bind ^` gs c cycle treasuremode')
    send_command('bind @c gs c toggle CP')
	send_command('bind @h gs c toggle Warp')
	send_command('bind @1 input //assist me; wait 0.5; input //send Aurorasky /attack')
	send_command('bind @2 input //assist me; wait 0.5; input //send Ardana /attack')
	send_command('bind @q input //assist me; wait 0.5; input //send Ardana /ma "Distract" <t>')



    send_command('bind ^numpad1 input /ws "Evisceration" <t>')
    send_command('bind ^numpad2 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad3 input /ws "Mandalic Stab" <t>')
    send_command('bind ^numpad4 input /ws "Aeolian Edge" <t>')
	send_command('bind ^numpad5 input /ws "Exenterator" <t>')
	send_command('bind ^numpad6 input /ws "Shark Bite" <t>')
	send_command('bind @numpad1 input //send Aurorasky /ws "Last Stand <t>')


    send_command('bind ^numpad0 input /ja "Sneak Attack" <me>')
    send_command('bind ^numpad. input /ja "Trick Attack" <me>')

    select_default_macro_book()
    set_lockstyle()

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind @c')
    send_command('unbind @r')
	send_command('unbind @h')
	send_command('unbind @1')
	send_command('unbind @2')
	send_command('unbind @q')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')
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
	
    send_command('lua u gearinfo')

end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.TreasureHunter = {
        feet="Skulk. Poulaines +1", --3
        waist="Chaac Belt", --1
        }

    sets.buff['Sneak Attack'] = {
        ammo="Yetshila +1",
        head="Pill. Bonnet +3",
        body="Pillager's Vest +3",
        hands=gear.Adhemar_B_hands,
        legs="Lustr. Subligar +1",
        feet="Lustra. Leggings +1",
        neck="Caro Necklace",
        ear1="Sherida Earring",
        ear2="Mache Earring +1",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        back=gear.THF_TP_Cape,
        }

    sets.buff['Trick Attack'] = {
        ammo="Yetshila +1",
        head="Pill. Bonnet +3",
        body="Pillager's Vest +3",
        hands="Pillager's Armlets +1",
        legs="Pill. Culottes +3",
        feet="Meg. Jam. +2",
        ear2="Infused Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        back=gear.THF_TP_Cape,
        waist="Svelt. Gouriz +1",
        }

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {head="Skulker's Bonnet +1"}
    sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet +1"}
    sets.precast.JA['Flee'] = {feet="Pill. Poulaines +2"}
    sets.precast.JA['Hide'] = {body="Pillager's Vest +3"}
    sets.precast.JA['Conspirator'] = {body="Skulker's Vest +1"}

    sets.precast.JA['Steal'] = {
        ammo="Barathrum", --3
        --head="Asn. Bonnet +2",
        hands="Pillager's Armlets +1",
        feet="Pill. Poulaines +2",
        }

    sets.precast.JA['Despoil'] = {ammo="Barathrum",    legs="Skulk. Culottes +1", feet="Skulk. Poulaines +1"}
    sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
    sets.precast.JA['Feint'] = {legs="Plunderer's Culottes +1"}
    --sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    --sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

    sets.precast.Waltz = {
        ammo="Yamarang",
        body="Passion Jacket",
        legs="Dashing Subligar",
        neck="Phalaina Locket",
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Malignance Boots",
		neck="Orunmila's Torque",
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Lebeche Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
    sets.precast.RA = {
		range="Trollbane",
		head={ name="Taeon Chapeau", augments={'"Snapshot"+5','"Snapshot"+5',}},
		body={ name="Taeon Tabard", augments={'"Snapshot"+5','"Snapshot"+5',}},
		hands="Malignance Gloves",
		legs={ name="Taeon Tights", augments={'"Snapshot"+4','"Snapshot"+5',}},
		feet="Meg. Jam. +2",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Vocane Ring",
		right_ring="Defending Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},} 


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo="Yetshila +1",
		head="Pill. Bonnet +3",
		body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
		hands="Meg. Gloves +2",
		legs={ name="Plun. Culottes +3", augments={'Enhances "Feint" effect',}},
		feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
		neck="Caro Necklace",
		waist="Grunfeld Rope",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Ishvara Earring",
		left_ring="Ilabrat Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},}

    sets.precast.WS['Evisceration'] = {
		ammo="Yetshila +1",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
		hands="Mummu Wrists +2",
		legs="Pill. Culottes +3",
		feet={ name="Adhe. Gamashes +1", augments={'STR+12','DEX+12','Attack+20',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Odr Earring",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Mummu Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}
		
	sets.precast.WS['Rudra\'s Storm'] = {
		ammo="Yetshila +1",
		head="Pill. Bonnet +3",
		body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
		hands="Meg. Gloves +2",
		legs={ name="Plun. Culottes +3", augments={'Enhances "Feint" effect',}},
		feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
		neck="Caro Necklace",
		waist="Grunfeld Rope",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Ilabrat Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Mandalic Stab'] = {
		ammo="Yetshila +1",
		head="Pill. Bonnet +3",
		body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
		hands="Meg. Gloves +2",
		legs={ name="Plun. Culottes +3", augments={'Enhances "Feint" effect',}},
		feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
		neck="Caro Necklace",
		waist="Grunfeld Rope",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Ilabrat Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Shark Bite'] = {
		ammo="Yetshila +1",
		head="Pill. Bonnet +3",
		body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
		hands="Meg. Gloves +2",
		legs={ name="Plun. Culottes +3", augments={'Enhances "Feint" effect',}},
		feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
		neck="Caro Necklace",
		waist="Grunfeld Rope",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Odr Earring",
		left_ring="Ilabrat Ring",
		right_ring="Epaminondas's Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},}

	sets.precast.WS['Aeolian Edge'] = {
		ammo="Seething Bomblet",
		head={ name="Herculean Helm", augments={'Pet: Accuracy+21 Pet: Rng. Acc.+21','"Subtle Blow"+3','Weapon skill damage +7%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		body={ name="Samnuha Coat", augments={'Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+5','"Dual Wield"+5',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Herculean Trousers", augments={'"Dual Wield"+1','Pet: VIT+8','Weapon skill damage +8%','Accuracy+1 Attack+1','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
		feet={ name="Adhe. Gamashes +1", augments={'STR+12','DEX+12','Attack+20',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Dingir Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},}

    sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ring1="Evanescence Ring", --5
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt
	
	sets.midcast.RA = {
		range="Trollbane",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Iskur Gorget",
		waist="Eschan Stone",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Ilabrat Ring",
		right_ring="Dingir Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
		main="Tauret",
		sub={ name="Sandung", augments={'Accuracy+50','Crit. hit rate+5%','"Triple Atk."+3',}},
		ammo="Staunch Tathlum +1",	--3%
		head="Malignance Chapeau",	--6%
		body="Malignance Tabard",	--9%
		hands="Malignance Gloves",	--5%
		legs="Malignance Tights", 	--7%
		feet="Malignance Boots",	--4%
		neck="Sanctity Necklace",
		waist="Kasiri Belt",
		left_ear="Eabani Earring",
		right_ear="Hearty Earring",
		left_ring="Chirich Ring +1",
		right_ring="Defending Ring",	--10%
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},	--10%PDT
		} --44% DT / 10% PDT
		
	sets.idle.Refresh = {
		main="Tauret",
		sub={ name="Sandung", augments={'Accuracy+50','Crit. hit rate+5%','"Triple Atk."+3',}},
		ammo="Staunch Tathlum +1",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Jute Boots +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body="Pillager's Vest +3",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Dedition Earring",
		left_ring="Epona's Ring",
		right_ring="Ilabrat Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.engaged.HighAcc = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body="Pillager's Vest +3",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Sanctity Necklace",
		waist="Olseni Belt",
		left_ear="Telos Earring",
		right_ear="Digni. Earring",
		left_ring="Epona's Ring",
		right_ring="Ilabrat Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    -- * DNC Native DW Trait: 30% DW
    -- * DNC Job Points DW Gift: 5% DW

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},											--6%
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Anu Torque", 
		waist="Reiki Yotai", 																									--7%
		left_ear="Eabani Earring", 																								--4%
		right_ear="Suppanomimi", 																								--5%
		left_ring="Hetairoi Ring",
		right_ring="Gere Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 27% Gear = 57%

    sets.engaged.DW.HighAcc = {
		ammo="Yamarang",
		head="Malignance Chapeau",
		body="Pillager's Vest +3",
		hands="Malignance Gloves",
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Digni. Earring",
		right_ear="Telos Earring",
		left_ring="Mummu Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 7% Gear = 37%

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},											--6%
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Anu Torque", 
		waist="Reiki Yotai", 																									--7%
		left_ear="Eabani Earring", 																								--4%
		right_ear="Suppanomimi", 																								--5%
		left_ring="Hetairoi Ring",
		right_ring="Gere Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 27% Gear = 57%


    sets.engaged.DW.HighAcc.LowHaste = {
		ammo="Yamarang",
		head="Malignance Chapeau",
		body="Pillager's Vest +3",
		hands="Malignance Gloves",
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Digni. Earring",
		right_ear="Telos Earring",
		left_ring="Mummu Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 7% Gear = 37%


    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},											--6%
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Anu Torque", 
		waist="Reiki Yotai", 																									--7%
		left_ear="Eabani Earring", 																								--4%
		right_ear="Suppanomimi", 																								--5%
		left_ring="Hetairoi Ring",
		right_ring="Gere Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 27% Gear = 57%

    sets.engaged.DW.HighAcc.MidHaste = {
		ammo="Yamarang",
		head="Malignance Chapeau",
		body="Pillager's Vest +3",
		hands="Malignance Gloves",
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Digni. Earring",
		right_ear="Telos Earring",
		left_ring="Mummu Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 7% Gear = 37%

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body="Pillager's Vest +3",
		hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},		--5%
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Anu Torque", 
		waist="Reiki Yotai", 																									--7%
		left_ear="Eabani Earring", 																								--4%
		right_ear="Suppanomimi", 																								--5%
		left_ring="Hetairoi Ring",
		right_ring="Gere Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 22% Gear = 52%

    sets.engaged.DW.HighAcc.HighHaste = {
		ammo="Yamarang",
		head="Malignance Chapeau",
		body="Pillager's Vest +3",
		hands="Malignance Gloves",
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Digni. Earring",
		right_ear="Telos Earring",
		left_ring="Mummu Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 7% Gear = 37%

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body="Pillager's Vest +3",
		hands={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Anu Torque", 
		waist="Reiki Yotai", 																									--7%
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Hetairoi Ring",
		right_ring="Gere Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 7% Gear = 37%


    sets.engaged.DW.HighAcc.MaxHaste = {
		ammo="Yamarang",
		head="Malignance Chapeau",
		body="Pillager's Vest +3",
		hands="Malignance Gloves",
		legs="Pill. Culottes +3",
		feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Digni. Earring",
		right_ear="Telos Earring",
		left_ring="Mummu Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		} --30% JA + 7% Gear = 37%


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head="Malignance Chapeau", 		--6%
		body="Malignance Tabard",		--9%
		hands="Malignance Gloves", 		--5%
		feet="Malignance Boots", 		--4%
		legs="Malignance Tights", 		--7%
        left_ring="Defending Ring", 	--10%
		back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}, --10%
        } --48%

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    
    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)
    
    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)
    
    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)
    
    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)
    
    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)
    

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

	sets.Warp = {left_ring="Warp Ring"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}
    sets.CP = {back="Mecisto. Mantle"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
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
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true or state.Buff['Trick Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)

--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /p Doomed.')
             disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

    if not midaction() then
        handle_equipping_gear(player.status)
    end
end

function job_state_change(stateField, newValue, oldValue)
	if state.Warp.value == true then
		equip(sets.Warp)
        disable('left_ring')
    else
        enable('left_ring')
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
end

function job_update(cmdParams, eventArgs)
	check_gear()
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end

function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end

    return idleSet
end

function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
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

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value ~= 'None' then
        msg = msg .. ' TH: ' ..state.TreasureMode.value.. ' |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 6 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 6 and DW_needed <= 22 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 22 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 26 and DW_needed <= 37 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 37 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
              end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
              if tonumber(cmdParams[3]) ~= Haste then
                  Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end


function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

windower.register_event('zone change', 
    function()
        send_command('gi ugs true')
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 8)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 8)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 8)
    else
        set_macro_page(1, 8)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end