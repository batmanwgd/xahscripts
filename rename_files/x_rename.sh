# for i in Picture*; do j=`echo $i | sed 's/Picture //'`; mv "$i" $j; done;

# convert png files to jpg, and rename it so
# find . -name "*png" | xargs -l -i basename -s ".png" {} | xargs -l -i convert {}.png {}.jpg