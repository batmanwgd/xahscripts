# -*- coding: utf-8 -*-
# Python

# process the monkey novel. split each chapter into 2 sections,and change whole chapter in pre tag to p tags by paragraph.
# XahLee.org, Tue Jun 28 15:34:25 PDT 2005

##########
# plan:
# * read in a chapter
# * strip headers and footers, assign as maintext
# * extract: title, chapter number (file name)
# * split maintext into paragraphs.
# * put together the text and write to new file

import string

sourceRoot= '/Users/t/web/_scripts/special/monkey_king_raw'
outputRoot= '/Users/t/web/p/monkey_king'
cpts=[
#['i01',u'附录',u'陈光蕊赴任逢灾 江流僧复仇报本'],
['001',u'第一回',u'灵根育孕源流出 心性修持大道生'],
['002',u'第二回',u'悟彻菩提真妙理 断魔归本合元神'],
['003',u'第三回',u'四海千山皆拱伏 九幽十类尽除名'],
['004',u'第四回',u'官封弼马心何足 名注齐天意未宁'],
['005',u'第五回',u'乱蟠桃大圣偷丹 反天宫诸神捉怪'],
['006',u'第六回',u'观音赴会问原因 小圣施威降大圣'],
['007',u'第七回',u'八卦炉中逃大圣 五行山下定心猿'],
['008',u'第八回',u'我佛造经传极乐 观音奉旨上长安'],
['009',u'第九回',u'袁守诚妙算无私曲 老龙王拙计犯天条'],
['010',u'第十回',u'二将军宫门镇鬼 唐太宗地府还魂'],
['011',u'第十一回',u'还受生唐王遵善果 度孤魂萧瑀正空门'],
['012',u'第十二回',u'玄奘秉诚建大会 观音显象化金蝉'],
['013',u'第十三回',u'陷虎穴金星解厄 双叉岭伯钦留僧'],
['014',u'第十四回',u'心猿归正 六贼无踪'],
['015',u'第十五回',u'蛇盘山诸神暗佑 鹰愁涧意马收缰'],
['016',u'第十六回',u'观音院僧谋宝贝 黑风山怪窃袈裟'],
['017',u'第十七回',u'孙行者大闹黑风山 观世音收伏熊罴怪'],
['018',u'第十八回',u'观音院唐僧脱难 高老庄行者降魔'],
['019',u'第十九回',u'云栈洞悟空收八戒 浮屠山玄奘受心经'],
['020',u'第二十回',u'黄风岭唐僧有难 半山中八戒争先'],
['021',u'第二十一回',u'护法设庄留大圣 须弥灵吉定风魔'],
['022',u'第二十二回',u'八戒大战流沙河 木叉奉法收悟净'],
['023',u'第二十三回',u'三藏不忘本 四圣试禅心'],
['024',u'第二十四回',u'万寿山大仙留故友 五庄观行者窃人参'],
['025',u'第二十五回',u'镇元仙赶捉取经僧 孙行者大闹五庄观'],
['026',u'第二十六回',u'孙悟空三岛求方 观世音甘泉活树'],
['027',u'第二十七回',u'尸魔三戏唐三藏 圣僧恨逐美猴王'],
['028',u'第二十八回',u'花果山群妖聚义 黑松林三藏逢魔'],
['029',u'第二十九回',u'脱难江流来国土 承恩八戒转山林'],
['030',u'第三十回',u'邪魔侵正法 意马忆心猿'],
['031',u'第三十一回',u'猪八戒义激猴王 孙行者智降妖怪'],
['032',u'第三十二回',u'平顶山功曹传信 莲花洞木母逢灾'],
['033',u'第三十三回',u'外道迷真性 元神助本心'],
['034',u'第三十四回',u'魔王巧算困心猿 大圣腾那骗宝贝'],
['035',u'第三十五回',u'外道施威欺正性 心猿获宝伏邪魔'],
['036',u'第三十六回',u'心猿正处诸缘伏 劈破旁门见月明'],
['037',u'第三十七回',u'鬼王夜谒唐三藏 悟空神化引婴儿'],
['038',u'第三十八回',u'婴儿问母知邪正 金木参玄见假真'],
['039',u'第三十九回',u'一粒金丹天上得 三年故主世间生'],
['040',u'第四十回',u'婴儿戏化禅心乱 猿马刀归木母空'],
['041',u'第四十一回',u'心猿遭火败 木母被魔擒'],
['042',u'第四十二回',u'大圣殷勤拜南海 观音慈善缚红孩'],
['043',u'第四十三回',u'黑河妖孽擒僧去 西洋龙子捉鼍回'],
['044',u'第四十四回',u'法身元运逢车力 心正妖邪度脊关'],
['045',u'第四十五回',u'三清观大圣留名 车迟国猴王显法'],
['046',u'第四十六回',u'外道弄强欺正法 心猿显圣灭诸邪'],
['047',u'第四十七回',u'圣僧夜阻通天水 金木垂慈救小童'],
['048',u'第四十八回',u'魔弄寒风飘大雪 僧思拜佛履层冰'],
['049',u'第四十九回',u'三藏有灾沉水宅 观音救难现鱼篮'],
['050',u'第五十回',u'情乱性从因爱欲 神昏心动遇魔头'],
['051',u'第五十一回',u'心猿空用千般计 水火无功难炼魔'],
['052',u'第五十二回',u'悟空大闹金山兜洞 如来暗示主人公'],
['053',u'第五十三回',u'禅主吞餐怀鬼孕 黄婆运水解邪胎'],
['054',u'第五十四回',u'法性西来逢女国 心猿定计脱烟花'],
['055',u'第五十五回',u'色邪淫戏唐三藏 性正修持不坏身'],
['056',u'第五十六回',u'神狂诛草寇 道昧放心猿'],
['057',u'第五十七回',u'真行者落伽山诉苦 假猴王水帘洞誊文'],
['058',u'第五十八回',u'二心搅乱大乾坤 一体难修真寂灭'],
['059',u'第五十九回',u'唐三藏路阻火焰山 孙行者一调芭蕉扇'],
['060',u'第六十回',u'牛魔王罢战赴华筵 孙行者二调芭蕉扇'],
['061',u'第六十一回',u'猪八戒助力败魔王 孙行者三调芭蕉扇'],
['062',u'第六十二回',u'涤垢洗心惟扫塔 缚魔归正乃修身'],
['063',u'第六十三回',u'二僧荡怪闹龙宫 群圣除邪获宝贝'],
['064',u'第六十四回',u'荆棘岭悟能努力 木仙庵三藏谈诗'],
['065',u'第六十五回',u'妖邪假设小雷音 四众皆遭大厄难'],
['066',u'第六十六回',u'诸神遭毒手 弥勒缚妖魔'],
['067',u'第六十七回',u'拯救驼罗禅性稳 脱离秽污道心清'],
['068',u'第六十八回',u'朱紫国唐僧论前世 孙行者施为三折肱'],
['069',u'第六十九回',u'心主夜间修药物 君王筵上论妖邪'],
['070',u'第七十回',u'妖魔宝放烟沙火 悟空计盗紫金铃'],
['071',u'第七十一回',u'行者假名降怪犼 观音现象伏妖王'],
['072',u'第七十二回',u'盘丝洞七情迷本 濯垢泉八戒忘形'],
['073',u'第七十三回',u'情因旧恨生灾毒 心主遭魔幸破光'],
['074',u'第七十四回',u'长庚传报魔头狠 行者施为变化能'],
['075',u'第七十五回',u'心猿钻透阴阳窍 魔王还归大道真'],
['076',u'第七十六回',u'心神居舍魔归性 木母同降怪体真'],
['077',u'第七十七回',u'群魔欺本性 一体拜真如'],
['078',u'第七十八回',u'比丘怜子遣阴神 金殿识魔谈道德'],
['079',u'第七十九回',u'寻洞擒妖逢老寿 当朝正主救婴儿'],
['080',u'第八十回',u'姹女育阳求配偶 心猿护主识妖邪'],
['081',u'第八十一回',u'镇海寺心猿知怪 黑松林三众寻师'],
['082',u'第八十二回',u'姹女求阳 元神护道'],
['083',u'第八十三回',u'心猿识得丹头 姹女还归本性'],
['084',u'第八十四回',u'难灭伽持圆大觉 法王成正体天然'],
['085',u'第八十五回',u'心猿妒木母 魔主计吞禅'],
['086',u'第八十六回',u'木母助威征怪物 金公施法灭妖邪'],
['087',u'第八十七回',u'凤仙郡冒天止雨 孙大圣劝善施霖'],
['088',u'第八十八回',u'禅到玉华施法会 心猿木母授门人'],
['089',u'第八十九回',u'黄狮精虚设钉钯宴 金木土计闹豹头山'],
['090',u'第九十回',u'师狮授受同归一 盗道缠禅静九灵'],
['091',u'第九十一回',u'金平府元夜观灯 玄英洞唐僧供状'],
['092',u'第九十二回',u'三僧大战青龙山 四星挟捉犀牛怪'],
['093',u'第九十三回',u'给孤园问古谈因 天竺国朝王遇偶'],
['094',u'第九十四回',u'四僧宴乐御花园 一怪空怀情欲喜'],
['095',u'第九十五回',u'假合真形擒玉兔 真阴归正会灵元'],
['096',u'第九十六回',u'寇员外喜待高僧 唐长老不贪富贵'],
['097',u'第九十七回',u'金酬外护遭魔毒 圣显幽魂救本原'],
['098',u'第九十八回',u'猿熟马驯方脱壳 功成行满见真如'],
['099',u'第九十九回',u'九九数完魔刬尽 三三行满道归根'],
['100',u'第一百回',u'径回东土 五圣成真'],
]

numOfChapters=len(cpts)

def partition(L, j): 
    '''parti(l,j) returns l partitioned with j elements per group. If j is not a factor of length of l, then the reminder elements are dropped.
    Example: parti([1,2,3,4,5,6],2) returns [[1,2],[3,4],[5,6]]
    Example: parti([1,2,3,4,5,6,7],3) returns [[1,2,3],[4,5,6]]'''
    return [L[k*j:(k+1)*j] for k in range(len(L)/j)] 


def partition2(L,j):
    '''partitions list L into j sublists. The last group may have more elements than previous groups. The result list will have length j.
    Example: print partition2(range(1,8+1),3)
    returns: [[1, 2], [3, 4], [5, 6], [7, 8, 7, 8]]'''
    quotient=len(L)/j
    remainder=len(L)%j
    if remainder==0:
        return partition(L,quotient)
    result = partition(L,quotient+1)
    nrm=len(L)%(quotient+1)
    result = result + [L[-nrm:]]
    return result

for el in cpts:
   chapterNumber=string._int(el[0])
   chapterNumberStr=el[0]
   chapterNumberText=el[1]
   chapterTitle=el[2]
   nextChapterNumberStr = "%03d"%( (chapterNumber+numOfChapters+1)%numOfChapters ) # e.g. '013'

   filename='x' + chapterNumberStr + '.html'
   filePath= sourceRoot + '/' + filename

   print 'reading:', filename
   inF = open(filePath,'rb')
   maintxt=unicode(inF.read(),'utf-8')
   inF.close()

   maintxt=maintxt.strip()
   paragraphs=maintxt.split('\n    ')

   pagesPerChapter=2

   print 'number of paragraphs: ', len(paragraphs)
   pageTexts= partition2(paragraphs, pagesPerChapter)
   print 'number of pages: ', len(pageTexts)
   pageTexts= map(lambda ar: '<p>' + string.join(ar,'</p>\n\n<p>') + '</p>' ,pageTexts)

   for i, pagedMainText in enumerate(pageTexts):
      pageNumberInt = i+1
      pageNumberStr = "%d"%(i+1)
      nextPageNumberStr ="%d"%(pageNumberInt+1)

      outfileName= 'x' + chapterNumberStr + '-' + pageNumberStr +'.html'
      outfilePath= outputRoot + '/' + outfileName

      if 0==(pageNumberInt % pagesPerChapter):
         nextfileName= 'x' + nextChapterNumberStr + '-1.html'
      else:
         nextfileName= 'x' + chapterNumberStr + '-' + nextPageNumberStr +'.html'

      if 1==pageNumberInt:
         headingText= '\n<h1>'+ chapterNumberText + ':' + chapterTitle + u'</h1>\n<p style="text-indent:0"></p>\n\n'
      else:
#         headingText= '\n' + u'<p style="text-indent:0">(' +chapterNumberText + u', 页'+ pageNumberStr + ')</p>\n\n'
         headingText= ''

      navtext=u'''\n\n<pre style="background-color:yellow;">★ 西游记,''' + chapterNumberText +  u', 页' + pageNumberStr + u''' <a href="monkey_king.html">↑</a><a href="'''+ nextfileName +u'''">→</a></pre>\n\n'''

      pretext=u'''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="StyleSheet" href="mk.css" type="text/css">
<title>西游记 (Monkey King)'''+chapterNumberText + "(%d"%(i+1) + u''')</title>
</head>
<body>

<p style="text-align:center; background-color:black; color:white; padding:2ex; width:60ex;">If you spend more than 30 minutes on this site, please send $1 to me. Go to <a href="http://paypal.com/">http://paypal.com/</a> and make a payment to xah@xahlee.org. Or send to: P. O. Box 390595, Mountain View, CA 94042-0290, USA.<span style="text-decoration:blink">♥</span></p>

'''
      posttext=u'''

<hr>
<pre><a href="http://xahlee.org/">李杀网</a> XahLee.org</pre>
<p align="center"><img src="../../Icons_dir/icon_sum.gif" width="32" height="32" alt="Xah Lee's Signet"></p>
</body>
</html>
'''
      outtext=pretext + navtext + headingText + pagedMainText +navtext +posttext
      
      print 'writing:', outfileName
      output = open(outfilePath,'wb')
      output.write(outtext.encode('utf-8'))
      output.close()
