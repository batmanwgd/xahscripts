#-*- coding: utf-8 -*-
# 2013-04-28

# go thru a list of files
# gather a list of <span class="xnt">withal</span> elements's text contet, call this listA
# do the same for <b class="x3nt">withal</b>, call this listB.
# check if listA and listB are equivalent, in same order too. Report if not.
# also, either list cannot have duplicate items. Report if not.

# todo
# there are some file that has
#<div class="x-note">…</div>
#but without the x3nt tag inside
#⁖ http://wordyenglish.com/arabian_nights/an7.html
# need to catch that

import re
import collections

fileList = [
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt1ch01.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt1ch02.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt1ch03.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt1ch04.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt1ch05.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt1ch07.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt1ch08.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt2ch01.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt2ch03.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt2ch04.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt2ch05.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt2ch06.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt2ch07.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt2ch08.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt3ch01.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt3ch02.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt3ch03.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt3ch04.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt3ch06.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt3ch07.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt3ch08.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt3ch09.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt3ch10.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt3ch11.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt4ch01.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt4ch02.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt4ch04.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt4ch06.html",
"/home/xah/web/wordyenglish_com/Gullivers_Travels/gt4ch07.html",
"/home/xah/web/wordyenglish_com/alice/alice-ch01.html",
"/home/xah/web/wordyenglish_com/alice/alice-ch02.html",
"/home/xah/web/wordyenglish_com/alice/alice-ch03.html",
"/home/xah/web/wordyenglish_com/alice/alice-ch06.html",
"/home/xah/web/wordyenglish_com/alice/alice-ch07.html",
"/home/xah/web/wordyenglish_com/alice/alice-ch08.html",
"/home/xah/web/wordyenglish_com/alice/alice-ch09.html",
"/home/xah/web/wordyenglish_com/alice/lg-ch02.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin1.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin1_2.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin2_2.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin3.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin3_1.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin4.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin4_1.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin5.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin5_0.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin5_1.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin6.html",
"/home/xah/web/wordyenglish_com/arabian_nights/aladdin/aladdin6_1.html",
"/home/xah/web/wordyenglish_com/arabian_nights/an1-2.html",
"/home/xah/web/wordyenglish_com/arabian_nights/an1.html",
"/home/xah/web/wordyenglish_com/arabian_nights/an10.html",
"/home/xah/web/wordyenglish_com/arabian_nights/an2.html",
"/home/xah/web/wordyenglish_com/arabian_nights/an3.html",
"/home/xah/web/wordyenglish_com/arabian_nights/an4.html",
"/home/xah/web/wordyenglish_com/arabian_nights/an5.html",
"/home/xah/web/wordyenglish_com/arabian_nights/an6.html",
"/home/xah/web/wordyenglish_com/arabian_nights/an7.html",
"/home/xah/web/wordyenglish_com/arabian_nights/an8.html",
"/home/xah/web/wordyenglish_com/arabian_nights/an9.html",
"/home/xah/web/wordyenglish_com/arabian_nights/husband_parrot.html",
"/home/xah/web/wordyenglish_com/arabian_nights/prince_ogress.html",
"/home/xah/web/wordyenglish_com/arabian_nights/sage_duban.html",
"/home/xah/web/wordyenglish_com/arabian_nights/sindibad_falcon.html",
"/home/xah/web/wordyenglish_com/arabian_nights/ue3.html",
"/home/xah/web/wordyenglish_com/arabian_nights/ue3fn.html",
"/home/xah/web/wordyenglish_com/flatland/flat10.html",
"/home/xah/web/wordyenglish_com/flatland/flat12.html",
"/home/xah/web/wordyenglish_com/flatland/flat14.html",
"/home/xah/web/wordyenglish_com/flatland/flat16.html",
"/home/xah/web/wordyenglish_com/flatland/flat18.html",
"/home/xah/web/wordyenglish_com/flatland/flat19.html",
"/home/xah/web/wordyenglish_com/flatland/flat2.html",
"/home/xah/web/wordyenglish_com/flatland/flat20.html",
"/home/xah/web/wordyenglish_com/flatland/flat21.html",
"/home/xah/web/wordyenglish_com/flatland/flat22.html",
"/home/xah/web/wordyenglish_com/flatland/flat3.html",
"/home/xah/web/wordyenglish_com/flatland/flat4.html",
"/home/xah/web/wordyenglish_com/flatland/flat6.html",
"/home/xah/web/wordyenglish_com/flatland/flat7.html",
"/home/xah/web/wordyenglish_com/flatland/flat8.html",
"/home/xah/web/wordyenglish_com/flatland/flatpref.html",
"/home/xah/web/wordyenglish_com/lit/blog_past_2011-08.html",
"/home/xah/web/wordyenglish_com/lit/english_history_in_10_min.html",
"/home/xah/web/wordyenglish_com/lit/hunger_gamers_nasty_highbrowism.html",
"/home/xah/web/wordyenglish_com/lit/interloper_in_aue_theater.html",
"/home/xah/web/wordyenglish_com/lit/shakespeare_vs_dr_seuss_rap_battle.html",
"/home/xah/web/wordyenglish_com/lit/shiiit_southern_women_say.html",
"/home/xah/web/wordyenglish_com/monkey_king/x028-2.html",
"/home/xah/web/wordyenglish_com/p/1002_of_Scheherazade.html",
"/home/xah/web/wordyenglish_com/p/adventure_german_student.html",
"/home/xah/web/wordyenglish_com/p/cupid_psyche.html",
"/home/xah/web/wordyenglish_com/p/demonic_males.html",
"/home/xah/web/wordyenglish_com/p/george_orwell_english.html",
"/home/xah/web/wordyenglish_com/p/hillary_Camille_Paglia.html",
"/home/xah/web/wordyenglish_com/p/jeeves_and_the_phd.html",
"/home/xah/web/wordyenglish_com/p/masque_red_death.html",
"/home/xah/web/wordyenglish_com/p/religion_Russell.html",
"/home/xah/web/wordyenglish_com/p/russell-lecture.html",
"/home/xah/web/wordyenglish_com/p/the_Littlest_Harlot.html",
"/home/xah/web/wordyenglish_com/p/to_build_a_fire.html",
"/home/xah/web/wordyenglish_com/p/why_not_christian.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch01.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch02.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch03.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch04.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch05.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch06.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch07.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch08.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch09.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch10.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch11.html",
"/home/xah/web/wordyenglish_com/time_machine/tm-ch12.html",
"/home/xah/web/wordyenglish_com/titus/act1.html",
"/home/xah/web/wordyenglish_com/titus/act1p2.html",
"/home/xah/web/wordyenglish_com/titus/act2.html",
"/home/xah/web/wordyenglish_com/titus/act2s2.html",
"/home/xah/web/wordyenglish_com/titus/act2s3.html",
"/home/xah/web/wordyenglish_com/titus/act2s4.html",
"/home/xah/web/wordyenglish_com/titus/act3.html",
"/home/xah/web/wordyenglish_com/titus/act3s2.html",
"/home/xah/web/wordyenglish_com/titus/act4.html",
"/home/xah/web/wordyenglish_com/titus/act4s2.html",
"/home/xah/web/wordyenglish_com/titus/act4s3.html",
"/home/xah/web/wordyenglish_com/titus/act4s4.html",
"/home/xah/web/wordyenglish_com/titus/act5.html",
"/home/xah/web/wordyenglish_com/titus/act5s2.html",
"/home/xah/web/wordyenglish_com/titus/act5s3.html",
"/home/xah/web/wordyenglish_com/zh/burning_of_the_imperial_palace.html",
"/home/xah/web/xaharts_org/funny/whats_is_googleplus.html",
"/home/xah/web/xahlee_info/w/apache_nodejs_nginx.html",
"/home/xah/web/xahlee_org/music/damn.html",
"/home/xah/web/xahlee_org/music/gnaa_weev_song.html",
"/home/xah/web/xahlee_org/music/hiphop.html",
"/home/xah/web/xahlee_org/music/i_am_on_a_boat.html",
"/home/xah/web/xahlee_org/music/my_dick.html",
"/home/xah/web/xahlee_org/music/pimp_50_cent.html",
"/home/xah/web/xahlee_org/p/cindys_torment.html",
"/home/xah/web/xahlee_org/p/mopi/mopi1.html",
"/home/xah/web/xahlee_org/p/mopi/mopi2.html",
"/home/xah/web/xahlee_org/p/mopi/mopi3.html",
"/home/xah/web/xahlee_org/p/mopi/mopi4.html",
"/home/xah/web/xahlee_org/p/mopi/mopi5.html",
"/home/xah/web/xahlee_org/p/mopi/mopi6.html",
"/home/xah/web/xahlee_org/p/mopi/mopi7.html",
"/home/xah/web/xahlee_org/p/mopi/mopi8.html",
"/home/xah/web/xahlee_org/p/um/um-s01.html",
"/home/xah/web/xahlee_org/p/um/um-s02.html",
"/home/xah/web/xahlee_org/p/um/um-s03.html",
"/home/xah/web/xahlee_org/p/um/um-s04.html",
"/home/xah/web/xahlee_org/p/um/um-s05.html",
"/home/xah/web/xahlee_org/p/um/um-s06.html",
"/home/xah/web/xahlee_org/p/um/um-s09.html",
"/home/xah/web/xahlee_org/p/um/um-s10.html",
"/home/xah/web/xahlee_org/p/um/um-s11.html",
"/home/xah/web/xahlee_org/p/um/um-s12.html",
"/home/xah/web/xahlee_org/p/um/um-s13.html",
"/home/xah/web/xahlee_org/p/um/um-s14.html",
"/home/xah/web/xahlee_org/p/um/um-s15.html",
"/home/xah/web/xahlee_org/p/um/um-s16.html",
"/home/xah/web/xahlee_org/p/um/um-s17.html",
"/home/xah/web/xahlee_org/p/um/um-s18.html",
"/home/xah/web/xahlee_org/p/um/um-s19.html",
"/home/xah/web/xahlee_org/p/um/um-s20.html",
"/home/xah/web/xahlee_org/p/um/um-s21.html",
"/home/xah/web/xahlee_org/p/um/um-s22.html",
"/home/xah/web/xahlee_org/p/um/um-s23.html",
"/home/xah/web/xahlee_org/p/um/um-s24.html",
"/home/xah/web/xahlee_org/p/um/um-s25.html",
"/home/xah/web/xahlee_org/p/um/um-s26.html",
"/home/xah/web/xahlee_org/sex/the_american_pedo_craze.html",
"/home/xah/web/xahmusic_org/music/Bohemian_Rhapsody.html",
"/home/xah/web/xahmusic_org/music/a_whiter_shade_of_pale.html",
"/home/xah/web/xahmusic_org/music/arcade_fire-abrahams_daughter.html",
"/home/xah/web/xahmusic_org/music/beat_it.html",
"/home/xah/web/xahmusic_org/music/blondie_rapture.html",
"/home/xah/web/xahmusic_org/music/china_girl.html",
"/home/xah/web/xahmusic_org/music/david_bowie.html",
"/home/xah/web/xahmusic_org/music/do_it_to_it.html",
"/home/xah/web/xahmusic_org/music/dont_cry_for_me_argentina.html",
"/home/xah/web/xahmusic_org/music/f_ck_sh_t_stack.html",
"/home/xah/web/xahmusic_org/music/hollaback_girl.html",
"/home/xah/web/xahmusic_org/music/hotel_ca.html",
"/home/xah/web/xahmusic_org/music/information_high.html",
"/home/xah/web/xahmusic_org/music/like_it_or_not.html",
"/home/xah/web/xahmusic_org/music/little_red_corvette.html",
"/home/xah/web/xahmusic_org/music/one_night_in_Bangkok.html",
"/home/xah/web/xahmusic_org/music/poor_unfortunate_souls.html",
"/home/xah/web/xahmusic_org/music/possibly_maybe.html",
"/home/xah/web/xahmusic_org/music/she_bop.html",
"/home/xah/web/xahmusic_org/music/strut_Sheena_Easton.html",
"/home/xah/web/xahmusic_org/music/the_day_before_you_came.html",
"/home/xah/web/xahmusic_org/music/toe_jam.html",
"/home/xah/web/xahmusic_org/music/total_eclipse_of_the_heart.html",
"/home/xah/web/xahmusic_org/music/wandering_stars.html",
"/home/xah/web/xahmusic_org/music/whatever_you_like.html",
"/home/xah/web/xahmusic_org/music/white_n_nerdy.html",
"/home/xah/web/xahmusic_org/music/white_rabbit.html",
"/home/xah/web/xahmusic_org/music/young_americans.html",
"/home/xah/web/xahmusic_org/piano/21st_century_schizoid_man.html",
"/home/xah/web/xahmusic_org/piano/o_fortuna.html",

]

def myProcessFile(fp):

    xntList = []
    x3ntList = []
    content=open( fp , 'r').read()

    xntTextSegment = content.split(r'''class="xnt">''')
    xntTextSegment.pop(0);

    for seg in xntTextSegment:
        found = re.search(r"""^([^<]+?)</span>""", seg)
        if found:
            keyphrase = found.expand(r"\1")
            xntList.append(keyphrase)

    x3ntTextSegment = content.split(r'''class="x3nt">''')
    x3ntTextSegment.pop(0);

    for seg in x3ntTextSegment:
        found = re.search(r"""^([^<]+?)</b>""", seg)
        if found:
            keyphrase = found.expand(r"\1")
            x3ntList.append(keyphrase)

    xntSet = set(xntList)
    x3ntSet = set(x3ntList)

    if len(xntList) != len(xntSet):
        print("• {}\n has duplicate in xntList {}".format(fp, collections.Counter(xntList)))

    if len(x3ntList) != len(x3ntSet):
        print("• {}\n has duplicate in x3ntList {}".format(fp, collections.Counter(x3ntList)))

    if xntList != x3ntList:
        print("• {}\n xnt ＆ x3nt not same.".format(fp))
        print (xntList)
        print (x3ntList)

        overlapItems = xntSet.intersection( x3ntSet )

        xntExtra = xntSet - overlapItems
        x3ntExtra = x3ntSet - overlapItems

        print( " xntExtra {}\n x3ntExtra {}\n".format(xntExtra, x3ntExtra))

        if len(xntList) == len(x3ntList):
            for i,v in enumerate(xntList):
                if v != x3ntList[i]:
                    print( "first diff: 「{}」 「{}」".format(v, x3ntList[i]))
                    break

for fp in fileList:
    myProcessFile(fp);

