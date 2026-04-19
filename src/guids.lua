
-- ============================================
-- MONSTERS PART

-----------------------------------------------
-- StS Mod GUIDs
sts_bags = {
    "8d449a", -- Act I  
    "1cf2a7", -- Act II 
    "189af1", -- Act III
    "189af1"  -- Act IV
}
sts_first_enemy_deck_guid = "e21cbf";
sts_enemy_deck_guid = {
    "4d2484", -- Act I  
    "edac78", -- Act II 
    "87f221"  -- Act III
}
sts_summon_deck_guid = {
    "66fbad", -- Act I  
    "485ed8", -- Act II 
    "e49dd1"  -- Act III
}
sts_elite_deck_guid = {
    "ff80bf", -- Act I  
    "e6e270", -- Act II 
    "b1c504", -- Act III
    "f4ea80"  -- Act IV
}
sts_boss_deck_guid = {
    "e07486", -- Act I
    "f69a29", -- Act II
    "2a2330", -- Act III
    "dd3174"  -- Act IV
}
sts_asc_guid = {
    { -- Asc 1 : Elite
        "6f9cd3", -- Act I
        "1236cd", -- Act II
        "6b4286", -- Act III
        "f4ea80"  -- Act IV
    },
    { -- Asc 7 : Enemy
        "e638d7", -- Act I
        "eb4750", -- Act II
        "d53139"  -- Act III
    },
    { -- Asc 12 : Elite
        "b16255", -- Act I
        "8be18d", -- Act II
        "0dd922", -- Act III
        "f4ea80"  -- Act IV
    },
    { -- Asc 10 : Boss
        "4cc01d", -- Act I
        "e58442", -- Act II
        "20ba8f", -- Act III
        "3076ab"  -- Act IV
    }
}
sts_silent_bag_guid = "92ba85"
sts_silent_poison_guids = {
    "926603",
    "57febf",
    "37c923"
}

act4_shield_guid = "cf672f"
act4_spear_guid = "2f9221"

-----------------------------------------------
-- This mod GUIDs
first_enemy_deck_guid = "dc7982"
enemy_deck_guid = {
    "aa8f35", -- Act I  
    "6b1f4c", -- Act II 
    "09078b"  -- Act III
}
summon_deck_guid = {
    "8d19ec", -- Act I  
    "8a9b73", -- Act II 
    "aaa415"  -- Act III
}
elite_deck_guid = {
    "61e76a", -- Act I  
    "f6e5ee", -- Act II 
    "8cf2b3", -- Act III
    "be7cb9"  -- Act IV
}

elite_asc_deck_guid = {
    "ec339c", -- Act I
    "bdd97c", -- Act II
    "75951d", -- Act III
}

boss_deck_guid = {
    "dd9b55", -- Act I  
    "ca9a32", -- Act II 
    "02e1f1", -- Act III
    "871ea6"  -- Act IV
}

boss_asc_deck_guid = {
    "b3f1ef", -- Act I
    "581519", -- Act II
    "227ea9", -- Act III
    "c3b8fc"  -- Act IV
}

-- ============================================
-- CHARACTER PART

-- Correlate base game card deck GUIDs to mod GUIDs.
-- Key = base game deck GUID, value = mod deck GUID to merge into it.
character_card_decks = {
    -- ironclad
    ['6355da'] = '743dbf', -- reward deck
    ['9a4007'] = 'c88204', -- rare deck
    ['2b8379'] = '89a14a', -- reward deck upg
    ['c16bb3'] = '4dce01', -- rare deck upg
    -- silent
    ['db37c0'] = '3dcc9f', -- reward deck
    ['0b9dcc'] = 'aea464', -- rare deck
    ['1641bf'] = 'a840ac', -- reward deck upg
    ['cdb9a0'] = '89a066', -- rare deck upg
    -- defect
    ['8cf2ec'] = 'c4ec57', -- reward deck
    ['e0769d'] = '4056b2', -- rare deck
    ['ba6c5b'] = 'a41fe0', -- reward deck upg
    ['07ecb9'] = 'd24f88', -- rare deck upg
    -- watcher
    ['d31ff8'] = '01bf76', -- reward deck
    ['2da0ab'] = '49e711', -- rare deck
    ['dc3185'] = '49435e', -- reward deck upg
    ['a15719'] = '537f0d', -- rare deck upg
    -- other
    ['80fcb6'] = 'aff298', -- colorless deck
    ['7f7cc9'] = 'f4ce1a', -- colorless upgrade deck
    ['9fc22a'] = 'e277f0', -- curse deck
    ['d6b384'] = 'd0e632', -- boss relic deck
    ['0f8234'] = 'cccf0b', -- relic deck
    ['72a869'] = '054422', -- potion deck
}
