# 2007-10-13

find "/Users/xah/web/SpecialPlaneCurves_dir" -name "*\.gsp" -print0 | xargs -0 -l -i /Developer/Tools/SetFile -type 'GSPb' -creator 'GSP+' "{}"
find "/Users/xah/web/SpecialPlaneCurves_dir" -name "*\.fig" -print0 | xargs -0 -l -i /Developer/Tools/SetFile -type 'FIGU' "{}"

# /Developer/Tools/SetFile -type 'GSPk' -creator 'GSP!' /Users/o/web/SpecialPlaneCurves_dir/Cardioid_dir/cardioidByCaustic.gsp
# 
# /Developer/Tools/GetFileInfo -t /Users/o/web/SpecialPlaneCurves_dir/Cardioid_dir/cardioidByCaustic.gsp
# /Developer/Tools/GetFileInfo -c /Users/o/web/SpecialPlaneCurves_dir/Cardioid_dir/cardioidByCaustic.gsp