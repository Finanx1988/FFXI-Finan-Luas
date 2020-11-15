-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Mode
--              [ F10 ]             Cycle Idle Mode
--              [ F11 ]             Cycle Casting Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ Windows+F9 ]      Cycle Hybrid Modes
--              [ Windows+H ]       Equip Warp Ring
--
--
--  Abilities:  [ CTRL+` ]          Composure
--				[ CTRL+- ]          Convert
--
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--  			[ CTRL+R ]          Toggles Range Lock
--
--  WS:         
--				[ CTRL+Numpad1 ]    Sanguine Blade
--				[ CTRL+Numpad2 ]    Seraph Blade
--				[ CTRL+Numpad3 ]    Requiescat
--				[ CTRL+Numpad4 ]    Savage Blade
--				[ CTRL+Numpad5 ]    Chant Du Cygne
--				[ CTRL+Numpad6 ]    Death Blossom
--				[ CTRL+Numpad7 ]    Circle Blade
--				
--				[ ALT+Numpad1 ]     Black Halo
--				[ ALT+Numpad2 ]     True Strike
--				[ ALT+Numpad4 ]     Aeolian Edge
--				[ ALT+Numpad5 ]     Evisceration
--				[ ALT+Numpad7 ]     Empyreal Arrow
--
--
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.
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

    state.Buff.Saboteur = buffactive.Saboteur or false
    state.Buff.Stymie = buffactive.Stymie or false

    enfeebling_magic_acc = S{'Bind', 'Break', 'Dispel', 'Distract', 'Distract II', 'Frazzle',
        'Frazzle II',  'Gravity', 'Gravity II', 'Silence', 'Sleep', 'Sleep II', 'Sleepga'}
    enfeebling_magic_skill = S{'Distract III', 'Frazzle III', 'Poison II'}
    enfeebling_magic_effect = S{'Dia', 'Dia II', 'Dia III', 'Diaga'}
	
    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
					"Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    skill_spells = S{
        'Temper', 'Temper II', 'Enfire', 'Enfire II', 'Enblizzard', 'Enblizzard II', 'Enaero', 'Enaero II',
        'Enstone', 'Enstone II', 'Enthunder', 'Enthunder II', 'Enwater', 'Enwater II'}

    lockstyleset = 1
end


-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Magic')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal')
    state.CastingMode:options('Normal','MagicBurst')
    state.IdleMode:options('Normal')
	state.TreasureMode:options('Tag', 'None')

    state.WeaponLock = M(false, 'Weapon Lock')
	state.RangeLock = M(false, 'Range Lock')
    state.MagicBurst = M(false, 'Magic Burst')
	state.Warp = M(false, 'Warp')
    state.NM = M(false, 'NM')

    -- Additional local binds
	if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        send_command('lua l gearinfo')
    end
    send_command('bind ^` input /ja "Composure" <me>')
	send_command('bind ^- input /ja "Convert" <me>')
    send_command('bind @w gs c toggle WeaponLock')
	send_command('bind @r gs c toggle RangeLock')
	send_command('bind @h gs c toggle Warp')
	send_command('bind @` gs c cycle treasuremode')
	send_command('bind ^numpad0 input /ra <t>')
	send_command('bind @1 input //assist me; wait 0.5; input //send Aurorasky /attack')
	send_command('bind @2 input //assist me; wait 0.5; input //send Ardana /attack')
	send_command('bind @q input //assist me; wait 0.5; input //send Ardana /ma "Distract" <t>')

    send_command('bind ^numpad1 input /ws "Sanguine Blade" <t>')
    send_command('bind ^numpad2 input /ws "Seraph Blade" <t>')
    send_command('bind ^numpad3 input /ws "Requiescat" <t>')
	send_command('bind ^numpad4 input /ws "Savage Blade" <t>')
    send_command('bind ^numpad5 input /ws "Chant du Cygne" <t>')
    send_command('bind ^numpad6 input /ws "Death Blossom" <t>')
	send_command('bind ^numpad7 input /ws "Circle Blade" <t>')
	send_command('bind !numpad1 input /ws "Black Halo" <t>')
    send_command('bind !numpad2 input /ws "True Strike" <t>')
	send_command('bind !numpad4 input /ws "Aeolian Edge" <t>')
	send_command('bind !numpad5 input /ws "Evisceration" <t>')
	send_command('bind !numpad7 input /ws "Empyreal Arrow" <t>')
	send_command('bind @numpad1 input //send Aurorasky /ws "Last Stand" <t>')
    
	
	
    select_default_macro_book()
    set_lockstyle()

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
	autoassist()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        send_command('lua u gearinfo')
    end
    send_command('unbind ^`')
	send_command('unbind ^-')
	send_command('unbind @w')
	send_command('unbind @r')
	send_command('unbind @h')
	send_command('unbind @`')
	send_command('unbind @1')
	send_command('unbind @2')
	send_command('unbind @q')
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
	
	
	
end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Viti. Tabard +3"}
	sets.precast.JA['Convert'] = {main="Murgleis"}

    -- Fast cast sets for spells

    -- Fast cast sets for spells
    sets.precast.FC = {
		ammo="Staunch Tathlum +1",
		head="Atrophy Chapeau +3",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10',}},
		}



    sets.precast.FC.Impact = {
		main="Crocea Mors",
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head=empty,
		body="Twilight Cloak",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
		neck="Orunmila's Torque",
		waist="Witful Belt",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10',}},}
		
	sets.precast.FC.Dispelga = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum +1",
		head="Atrophy Chapeau +3",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10',}},
		}




    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs="Jhakri Slops +2",
		feet="Jhakri Pigaches +2",
		neck="Dls. Torque +2",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Rufescent Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Chant du Cygne'] = {
		ammo="Yetshila +1",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Ayanmo Corazza +2",
		hands="Malignance Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Begrudging Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},}
	
	sets.precast.WS['Evisceration'] = sets.precast.WS['Chant du Cygne']


    sets.precast.WS['Savage Blade'] = {
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs="Jhakri Slops +2",
		feet={ name="Chironic Slippers", augments={'Enmity-3','STR+8','Weapon skill damage +6%','Accuracy+10 Attack+10','Mag. Acc.+3 "Mag.Atk.Bns."+3',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Rufescent Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Death Blossom'] = sets.precast.WS['Savage Blade']
		
	sets.precast.WS['Circle Blade'] = {
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Chironic Doublet", augments={'Pet: Phys. dmg. taken -1%','Phys. dmg. taken -2%','"Treasure Hunter"+2',}},
		hands={ name="Chironic Gloves", augments={'MND+4','Phys. dmg. taken -2%','"Treasure Hunter"+1','Accuracy+5 Attack+5',}},
		legs={ name="Viti. Tights +3", augments={'Enspell Damage','Accuracy',}},
		feet="Jhakri Pigaches +2",
		neck="Fotia Gorget",
		waist="Chaac Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Rufescent Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}


	sets.precast.WS['Black Halo'] = {
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs="Jhakri Slops +2",
		feet={ name="Chironic Slippers", augments={'Enmity-3','STR+8','Weapon skill damage +6%','Accuracy+10 Attack+10','Mag. Acc.+3 "Mag.Atk.Bns."+3',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Regal Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Rufescent Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}


    sets.precast.WS['Requiescat'] = {
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs="Jhakri Slops +2",
		feet="Jhakri Pigaches +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Rufescent Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Aeolian Edge'] = {
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Freke Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
    sets.precast.WS['Sanguine Blade'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Archon Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Red Lotus Blade'] = {
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Freke Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Seraph Blade'] = {
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Freke Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Empyreal Arrow'] = {
		ammo="Chapuli Arrow",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Telos Earring",
		right_ear="Enervating Earring",
		left_ring="Ilabrat Ring",
		right_ring="Rufescent Ring",
		back={ name="Sucellos's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}
	
	

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

	sets.Enmity = {
		ammo="Sapience Orb",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Malignance Gloves",
		legs={ name="Zoar Subligar +1", augments={'Path: A',}},
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Kasiri Belt",
		left_ear="Friomisi Earring",
		right_ear="Cryptic Earring",
		left_ring="Eihwaz Ring",
		right_ring="Petrov Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10',}},}

		

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.Cure = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Sirona's Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}

    sets.midcast.CureWeather = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Vanya Hood", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs="Atrophy Tights +3",
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Hachirin-no-Obi",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Sirona's Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}

    sets.midcast.CureSelf = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Phalaina Locket",
		waist="Gishdubar Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Vocane Ring",
		right_ring="Kunaji Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}

    sets.midcast.Curaga = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','"Cure" potency +6%','"Conserve MP"+7',}},
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Stikini Ring +1",
		right_ring="Sirona's Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}

    sets.midcast.StatusRemoval = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Viti. Gloves +3", augments={'Enhancing Magic duration',}},
		legs="Atrophy Tights +3",
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Haoma's Ring",
		right_ring="Sirona's Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}

    sets.midcast.Cursna = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Viti. Gloves +3", augments={'Enhancing Magic duration',}},
		legs="Atrophy Tights +3",
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Beatific Earring",
		right_ear="Meili Earring",
		left_ring="Haoma's Ring",
		right_ring="Sirona's Ring",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}

    sets.midcast['Enhancing Magic'] = {
		main="Crocea Mors",
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet="Leth. Houseaux +1",
		neck="Dls. Torque +2",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10',}},}

    sets.midcast['Phalanx'] = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Fast Cast"+4','Enh. Mag. eff. dur. +10',}},
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands="Atrophy Gloves +3",
		legs={ name="Telchine Braconi", augments={'"Fast Cast"+3','Enh. Mag. eff. dur. +10',}},
		feet={ name="Taeon Boots", augments={'Phalanx +3',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		right_ear="Mimir Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +1','Enha.mag. skill +10','Mag. Acc.+5','Enh. Mag. eff. dur. +18',}},}

    sets.midcast.EnhancingSkill = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Sapience Orb",
		head="Befouled Crown",
		body={ name="Viti. Tabard +3", augments={'Enhances "Chainspell" effect',}},
		hands={ name="Viti. Gloves +3", augments={'Enhancing Magic duration',}},
		legs="Atrophy Tights +3",
		feet="Leth. Houseaux +1",
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Mimir Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Ghostfyre Cape", augments={'Enfb.mag. skill +1','Enha.mag. skill +10','Mag. Acc.+5','Enh. Mag. eff. dur. +18',}},}
		
    sets.midcast['Gain-STR'] = set_combine(sets.midcast['Enhancing Magic'], {hands="Viti. Gloves +3",})
	sets.midcast['Gain-DEX'] = set_combine(sets.midcast['Enhancing Magic'], {hands="Viti. Gloves +3",})
	sets.midcast['Gain-AGI'] = set_combine(sets.midcast['Enhancing Magic'], {hands="Viti. Gloves +3",})
	sets.midcast['Gain-VIT'] = set_combine(sets.midcast['Enhancing Magic'], {hands="Viti. Gloves +3",})
	sets.midcast['Gain-MND'] = set_combine(sets.midcast['Enhancing Magic'], {hands="Viti. Gloves +3",})
	sets.midcast['Gain-INT'] = set_combine(sets.midcast['Enhancing Magic'], {hands="Viti. Gloves +3",})
	sets.midcast['Gain-CHR'] = set_combine(sets.midcast['Enhancing Magic'], {hands="Viti. Gloves +3",})
	
	
    sets.midcast.Refresh = {
		main="Crocea Mors",
		sub="Ammurapi Shield",
		ammo="Homiliary",
		head="Amalric Coif +1",
		body="Atrophy Tabard +3",
		hands="Atrophy Gloves +3",
		legs="Leth. Fuseau +1",
		feet="Leth. Houseaux +1",
		neck="Dls. Torque +2",
		waist="Witful Belt",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Sucellos's Cape", augments={'"Fast Cast"+10',}},}

    sets.midcast.RefreshSelf = set_combine(sets.midcast.Refresh, {
        waist="Gishdubar Sash",})

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        neck="Nodens Gorget",
        })

    sets.midcast.Storm = sets.midcast['Enhancing Magic']

     -- Enfeebling Spells
	 
	sets.midcast['Enfeebling Magic'] = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +1",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Haste+2','MND+13','Mag. Acc.+12',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck={ name="Dls. Torque +2", augments={'Path: A',}},
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Snotra Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}
		
	sets.midcast['Enfeebling Magic'].Potency ={
		main="Crocea Mors",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Lethargy Sayon +1",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Haste+2','MND+13','Mag. Acc.+12',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Dls. Torque +2",
		waist="Luminary Sash",
		left_ear="Snotra Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}
		
	sets.midcast['Enfeebling Magic'].MACC = {
		main="Crocea Mors",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head="Atrophy Chapeau +3",
		body="Atrophy Tabard +3",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Haste+2','MND+13','Mag. Acc.+12',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Dls. Torque +2",
		waist="Luminary Sash",
		left_ear="Snotra Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}
		
	sets.midcast.Dispelga = {
		main="Daybreak",
		sub="Ammurapi Shield",
		range="Kaja Bow",
		head="Atrophy Chapeau +3",
		body="Atrophy Tabard +3",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Haste+2','MND+13','Mag. Acc.+12',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Dls. Torque +2",
		waist="Luminary Sash",
		left_ear="Snotra Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}
		
	sets.midcast['Dia III'] = {
		main="Crocea Mors",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head="Wh. Rarab Cap +1",
		body={ name="Chironic Doublet", augments={'Pet: Phys. dmg. taken -1%','Phys. dmg. taken -2%','"Treasure Hunter"+2',}},
		hands={ name="Chironic Gloves", augments={'MND+4','Phys. dmg. taken -2%','"Treasure Hunter"+1','Accuracy+5 Attack+5',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Haste+2','MND+13','Mag. Acc.+12',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Dls. Torque +2",
		waist="Chaac Belt",
		left_ear="Snotra Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}
	
	sets.midcast['Distract'] = sets.midcast['Enfeebling Magic'].Potency
	sets.midcast['Frazzle'] = sets.midcast['Enfeebling Magic'].Potency
	sets.midcast['Distract II'] = sets.midcast['Enfeebling Magic'].Potency
	sets.midcast['Frazzle II'] = sets.midcast['Enfeebling Magic'].Potency	
	sets.midcast['Distract III'] = sets.midcast['Enfeebling Magic'].Potency
	sets.midcast['Frazzle III'] = sets.midcast['Enfeebling Magic'].Potency
	sets.midcast['Poison'] = sets.midcast['Enfeebling Magic'].Potency
	sets.midcast['Poison II'] = sets.midcast['Enfeebling Magic'].Potency
	sets.midcast['Sleepga'] = sets.midcast['Enfeebling Magic'].MACC
	sets.midcast['Gravity'] = sets.midcast['Enfeebling Magic'].MACC
	sets.midcast['Gravity II'] = sets.midcast['Enfeebling Magic'].MACC
	sets.midcast['Dispel'] = sets.midcast['Enfeebling Magic'].MACC
	sets.midcast['Silence'] = sets.midcast['Enfeebling Magic'].MACC
	sets.midcast['Inundation'] = sets.midcast['Enfeebling Magic'].MACC
		
    sets.midcast['Dark Magic'] = {
		main="Crocea Mors",
		sub="Ammurapi Shield",
		ammo="Regal Gem",
		head="Atrophy Chapeau +3",
		body="Atrophy Tabard +3",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Haste+2','MND+13','Mag. Acc.+12',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Dls. Torque +2",
		waist="Luminary Sash",
		left_ear="Snotra Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10',}},}

    sets.midcast.Drain = {
		main="Crocea Mors",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Evanescence Ring",
		right_ring="Archon Ring",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast['Elemental Magic'] = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'Mag. Acc.+20','"Mag.Atk.Bns."+20','"Conserve MP"+7',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring="Shiva Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

	sets.midcast['Elemental Magic'].MagicBurst = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Ea Hat +1",																								--7 +7
		body="Ea Houppe. +1",																							--9 +9
		hands="Ea Cuffs +1",																							--6 +6
		legs="Ea Slops +1",																								--8 +8
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Mizu. Kubikazari",																						--10
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Mujin Band",																							--0 +5
		right_ring="Freke Ring",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
		--40 +35 = 75%

    sets.midcast.Impact = {
		main="Crocea Mors",
		sub="Ammurapi Shield",
		range="Kaja Bow",
		head=empty,
		body="Twilight Cloak",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Haste+2','MND+13','Mag. Acc.+12',}},
		feet={ name="Vitiation Boots +3", augments={'Immunobreak Chance',}},
		neck="Dls. Torque +2",
		waist="Luminary Sash",
		left_ear="Snotra Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    sets.buff.Saboteur = {hands="Leth. Gantherots +1"}


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
		main="Daybreak",																		
		sub="Genmei Shield",																												--10% PDT
		ammo="Homiliary",
		head={ name="Viti. Chapeau +3", augments={'Enfeebling Magic duration','Magic Accuracy',}},
		body="Jhakri Robe +2",
		hands="Malignance Gloves",																											--5%
		legs="Malignance Tights",																											--7%
		feet="Malignance Boots",																											--4%
		neck="Loricate Torque +1",																											--6%
		waist="Flume Belt +1",
		left_ear="Eabani Earring",
		right_ear="Hearty Earring",
		left_ring="Vocane Ring",																											--7%
		right_ring="Defending Ring",																										--10%
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},} --10% PDT
		--29% DT + 20 PDT

    sets.resting = {}

    sets.latent_refresh = {waist="Fucho-no-obi"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		main="Naegling",
		sub="Genmei Shield",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Ilabrat Ring",
		right_ring="Hetairoi Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    sets.engaged.Magic = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Ammurapi Shield",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Aya. Manopolas +2",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Orpheus's Sash",
		left_ear="Sherida Earring",
		right_ear="Digni. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
		main="Naegling",
		sub="Tauret",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},												--9%
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Ilabrat Ring",
		right_ring="Hetairoi Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},} 	--10%
		--41%GDW + 25%JADW = 66%

	sets.engaged.DW.Magic = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Daybreak",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Aya. Manopolas +2",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},												--9%
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},} --10%
		--41%GDW + 25%JADW = 66%

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
		main="Naegling",
		sub="Tauret",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},												--9%
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Ilabrat Ring",
		right_ring="Hetairoi Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},} 	--10%
		--41%GDW + 25%JADW = 66%

    sets.engaged.DW.Magic.LowHaste = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Daybreak",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Aya. Manopolas +2",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},												--9%
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},} --10%
		--41%GDW + 25%JADW = 66%

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
		main="Naegling",
		sub="Tauret",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Ilabrat Ring",
		right_ring="Hetairoi Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},} 	--10%
		--32%GDW + 25%JADW = 57%

    sets.engaged.DW.Magic.MidHaste = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Daybreak",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Aya. Manopolas +2",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},												--9%
		neck="Anu Torque",
		waist="Orpheus's Sash",
		left_ear="Sherida Earring",
		right_ear="Suppanomimi",																											--5%
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},} --10%
		--30%GDW + 25%JADW = 57%

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
		main="Naegling",
		sub="Tauret",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Suppanomimi",																											--5%
		left_ring="Ilabrat Ring",
		right_ring="Hetairoi Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},} 	--10%
		--26%GDW + 25%JADW = 51%

    sets.engaged.DW.Magic.HighHaste = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Daybreak",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Aya. Manopolas +2",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},											--6%
		feet={ name="Taeon Boots", augments={'Accuracy+25','"Dual Wield"+5','STR+5 DEX+5',}},												--9%
		neck="Anu Torque",
		waist="Orpheus's Sash",
		left_ear="Sherida Earring",
		right_ear="Digni. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},} --10%
		--26%GDW + 25%JADW = 51%

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
		main="Naegling",
		sub="Tauret",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",																												--7%
		left_ear="Eabani Earring",																											--4%
		right_ear="Sherida Earring",
		left_ring="Ilabrat Ring",
		right_ring="Hetairoi Ring",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		--11%GDW + 25%JADW = 36%

    sets.engaged.DW.Magic.MaxHaste = {
		main={ name="Crocea Mors", augments={'Path: C',}},
		sub="Daybreak",
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Aya. Manopolas +2",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Orpheus's Sash",
		left_ear="Sherida Earring",
		right_ear="Digni. Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},} --10%
		--10%GDW + 25%JADW = 35%


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head="Malignance Chapeau", --6%
		body="Malignance Tabard",  --9%
		hands="Malignance Gloves", --5%
		legs="Malignance Tights", --7%
		feet="Malignance Boots", --4%
		right_ring="Defending Ring", --10
		back={ name="Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}, --10%
        }--41% DT + 10% PDT
		
    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.Magic.DT = set_combine(sets.engaged.Magic, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.Magic.DT = set_combine(sets.engaged.DW.Magic, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Magic.DT.LowHaste = set_combine(sets.engaged.DW.Magic.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Magic.DT.MidHaste = set_combine(sets.engaged.DW.Magic.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Magic.DT.HighHaste = set_combine(sets.engaged.DW.Magic.HighHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.Magic.DT.MaxHaste = set_combine(sets.engaged.DW.Magic.MaxHaste, sets.engaged.Hybrid)
	
	
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------


    sets.TreasureHunter = {
		head="Wh. Rarab Cap +1", --TH1
		body={ name="Chironic Doublet", augments={'Pet: Phys. dmg. taken -1%','Phys. dmg. taken -2%','"Treasure Hunter"+2',}}, --TH2
		waist="Chaac Belt",} --TH+1


    sets.buff.Doom = {
        waist="Gishdubar Sash", --10
        }
		
	sets.Warp = {left_ring="Warp Ring"}

    sets.Obi = {waist="Hachirin-no-Obi"}
	sets.Empyreal = {range="Kaja Bow", ammo="Chapuli Arrow"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
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

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
	    if spell.name == 'Dispelga' then
        equip(sets.precast.FC.Dispelga)
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Sleep II' then
        if state.Buff.Saboteur then
            equip(sets.buff.Saboteur)
        end
    end
    if spell.skill == 'Enhancing Magic' then
        if classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
        elseif skill_spells:contains(spell.english) then
            equip(sets.midcast.EnhancingSkill)
        elseif spell.english:startswith('Gain') then
        end
    end
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
    if spell.skill == 'Elemental Magic' then
        if spell.english == "Impact" then
                equip(sets.midcast.Impact)
        end
		if spell.english == "Dispelga" then
                equip(sets.midcast.Dispelga)
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.english:contains('Sleep') and not spell.interrupted then
        set_sleep_timer(spell)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff,gain)
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
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
	if state.RangeLock.value == true then
		equip(sets.Empyreal)
        disable('range','ammo')
    else
        enable('range','ammo')
    end
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
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
            if (world.weather_element == 'Light' or world.day_element == 'Light') then
                return 'CureWeather'
            end
        end
    end
end

--  Modify the default melee set after it was constructed.

function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end

--auto assist with assist addon

function autoassist(newStatus,oldStatus, eventArgs)
	if newStatus == 'Engaged' then
		send_command('@input //assist me')
	end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
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

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 26 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 26 and DW_needed <= 31 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 31 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'scholar' then
        handle_strategems(cmdParams)
        eventArgs.handled = true
    elseif cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    end

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

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.

windower.register_event('zone change', 
    function()
        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
            send_command('gi ugs true')
        end
    end
)

function set_sleep_timer(spell)
    local self = windower.ffxi.get_player()

    if spell.en == "Sleep II" then 
        base = 90
    elseif spell.en == "Sleep" or spell.en == "Sleepga" then 
        base = 60
    end

    if state.Buff.Saboteur then
        if state.NM.value then
			base = base * 1.25
		else
			base = base * 2
		end
    end

    -- Job Points Buff
    base = base + self.job_points.rdm.enfeebling_magic_duration

	if state.Buff.Stymie then
		base = base + self.job_points.rdm.stymie_effect
	end

	add_to_chat(004, 'Base Duration: ' ..base)

    --User enfeebling duration enhancing gear total
    gear_mult = 1.10
    --User enfeebling duration enhancing augment total
	aug_mult = 1.17

    totalDuration = math.floor(base * gear_mult * aug_mult)
        
    -- Create the custom timer
    if spell.english == "Sleep II" then
        send_command('@timers c "Sleep II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00259.png')
    elseif spell.english == "Sleep" or spell.english == "Sleepga" then
        send_command('@timers c "Sleep ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00253.png')
    end

end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 6)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end