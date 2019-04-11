rm smwci.smc
rm -R Levels/
mkdir Levels

# free up space in fresh ROM
cp yi.smc smwci.smc
cd graphics
winpty ./ycompress.exe 1 120200 ../smwci.smc allgfx.bin
cd ../asm
./asar.exe free_space.asm ../smwci.smc
./asar.exe prevent_freespace.asm ../smwci.smc

# patch roms and extract levels
cd ../complete_ipss
sh all_levels.sh

# insert into rom
cd ..
./LevelTool.exe -i smwci.smc

# text
cd text
python texteditor.py ../smwci.smc import

# graphics
cd ..
complete_ipss/flips.exe --apply graphics/yoshicolorfix.ips smwci.smc

# apply all ASM
cd asm
./asar.exe level.asm ../smwci.smc
./asar.exe palettes.asm ../smwci.smc
./asar.exe taptap_fix.asm ../smwci.smc
./asar.exe poochy_bonus_game.asm ../smwci.smc
./asar.exe nep-enut.asm ../smwci.smc
./asar.exe scroll_rates.asm ../smwci.smc
./asar.exe revert_FFs.asm ../smwci.smc

# non-freespace
./asar.exe sluggytheunshowered.asm ../smwci.smc
./asar.exe raphael_hacks.asm ../smwci.smc
./asar.exe smallerboo.asm ../smwci.smc
./asar.exe salvo_fix.asm ../smwci.smc
./asar.exe naval_fix.asm ../smwci.smc
./asar.exe taptaptherednosedreindeer.asm ../smwci.smc
./asar.exe entrance_data.asm ../smwci.smc
# ./asar.exe text_levelnames.asm ../smwci.smc
./asar.exe rotating4doors.asm ../smwci.smc
./asar.exe better_midrings.asm ../smwci.smc
./asar.exe autumn_jungle_fix.asm ../smwci.smc
./asar.exe world6_fix.asm ../smwci.smc
./asar.exe spriteset_changes.asm ../smwci.smc
./asar.exe 5worlds.asm ../smwci.smc
./asar.exe kamek_fixes.asm ../smwci.smc

# cook BPS
cd ..
complete_ipss/flips.exe --create yi.smc smwci.smc smwci.bps