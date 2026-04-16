# Aura Spell Filters – Implementation Guide

## Overview

LunaUnitFrames now supports **centralised spell-ID filter lists** that can be reused across any frame category (player, target, party, raid, etc.). Each frame's Aura settings can reference a named filter list and apply it as a **whitelist** (only show matching spells) or **blacklist** (hide matching spells) independently for buffs and debuffs.

## Architecture

### 1. Profile Data (`defaults.lua`)

- **`profile.filters`** – A top-level table storing named filter lists. Each key is a user-defined name, and each value is a table of `{ [spellId] = true }`.
- **`profile.units.<unit>.auras.filters`** – Per-unit aura filter preferences:
  - `buffs` – Name of the filter list to apply to buffs (empty string = none).
  - `debuffs` – Name of the filter list to apply to debuffs (empty string = none).
  - `buffMode` – `"disabled"`, `"whitelist"`, or `"blacklist"`.
  - `debuffMode` – `"disabled"`, `"whitelist"`, or `"blacklist"`.

All filter data lives inside the profile, so it is fully covered by the existing profile system (copy, switch, reset, auto-switch).

### 2. Filters Menu (`Options.lua`)

A new **"Filters"** left-side menu item is registered (order 26.5, between the last unit and "Hide Blizzard"). It provides:

- **Create** – Type a name and create a new empty filter list.
- **Select** – Dropdown to pick an existing filter list for editing.
- **Delete** – Remove a filter list and clean up any unit references to it.
- **Add Spell** – Text input that accepts either a **spell ID** (number) or a **spell name**. When a name is entered, `C_Spell.GetSpellInfo()` is used to resolve it to an ID. This means users don't need to copy IDs from external sources.
- **Spell List** – Each spell in the selected list is displayed with its **icon** (via `|T...|t` texture escapes) and name. Clicking the entry removes it (with confirmation).

### 3. Per-Unit Aura Filter Selectors (`Options.lua` – Auras module)

The existing "Auras" tab for every unit now includes a **Filter Lists** section at the bottom with:

- **Buff Filter List** – Dropdown listing all defined filter lists (or "No Filter").
- **Buff Filter Mode** – Shown only when a list is selected: Disabled / Whitelist / Blacklist.
- **Debuff Filter List** / **Debuff Filter Mode** – Same for debuffs.

### 4. Runtime Filtering (`oUF_SimpleAuras.lua`)

A helper function `ShouldShowAura(spellID, filterList, filterMode)` is injected before the `UpdateAuras` function. It returns:

- `true` if mode is `"disabled"` or no list is set.
- `true` if mode is `"whitelist"` and `spellID` is in the list.
- `true` if mode is `"blacklist"` and `spellID` is **not** in the list.

The buff and debuff iteration loops in `UpdateAuras` now call this function before calling `updateIcon`, skipping auras that don't pass the filter.

### 5. Config → Element Bridge (`LunaUnitFrames.lua`)

In `LUF.ApplySettings`, after setting up the existing aura properties, the filter configuration is read from `AuraConfig.filters` and passed to the `SimpleAuras` element as:

- `Auras.buffFilterList` / `Auras.buffFilterMode`
- `Auras.debuffFilterList` / `Auras.debuffFilterMode`

These are resolved at apply-time so that filter list content changes take effect on the next reload.

## Usage

1. Open LunaUnitFrames settings (`/luf`).
2. Go to **Filters** in the left menu.
3. Create a filter list (e.g. "Important Buffs").
4. Add spells by name or ID – icons are shown for verification.
5. Go to any unit (e.g. **Raid** → **Auras** tab).
6. Scroll to "Filter Lists" and select "Important Buffs" for buffs.
7. Set mode to **Whitelist** to only show those buffs, or **Blacklist** to hide them.

## Profile Compatibility

All filter data (`profile.filters` and each unit's `auras.filters.*`) is stored inside the AceDB profile. This means:

- Switching profiles loads different filter lists and assignments.
- Copying a profile copies all filter configuration.
- Resetting a profile clears all filters.
- Auto-profile switching carries filter settings per profile.

