rm smwci.smc
rm -R Levels/
mkdir Levels

# free up space in fresh ROM
cp yi.smc smwci.smc
cd graphics
winpty ./ycompress.exe 1 120200 ../smwci.smc cleangfx-cleaned.bin
cd ../asm
./asar.exe free_space.asm ../smwci.smc
./asar.exe prevent_freespace.asm ../smwci.smc

# patch roms and extract levels
cd ../complete_ipss
sh all_levels.sh

# insert into rom
cd ..
./LevelTool.exe -i smwci.smc

# apply all ASM
cd asm
./asar.exe level.asm ../smwci.smc
./asar.exe smwci-palettes.asm ../smwci.smc
./asar.exe nep-enut.asm ../smwci.smc
./asar.exe scroll_rates.asm ../smwci.smc
./asar.exe revert_FFs.asm ../smwci.smc

# non-freespace
./asar.exe sluggytheunshowered.asm ../smwci.smc
./asar.exe smallerboo.asm ../smwci.smc
./asar.exe salvo_fix.asm ../smwci.smc
./asar.exe entrance_data.asm ../smwci.smc
./asar.exe text_levelnames.asm ../smwci.smc
./asar.exe rotating4doors.asm ../smwci.smc
./asar.exe better_midrings.asm ../smwci.smc
