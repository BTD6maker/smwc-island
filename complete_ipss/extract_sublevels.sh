ips_file="$1"
smc_file="${ips_file%.*}.smc"

# apply IPS/BPS patch
./flips --apply "$1" "yi.smc" "../complete_smcs/${smc_file}"

# extract all levels
cd ../complete_smcs
./LevelTool.exe -e "${smc_file}"

# move only sublevels from command args to destination
for i in "${@:2}"
do
    mv "Levels/level${i}.yil" "../Levels/level${i}.yil"
done
