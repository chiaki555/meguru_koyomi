# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "holiday_jp"

# 初期データ作成：季節湯
bath_templates = [
  {
    name: "松湯",
    month: 1,
    day: 7,
    date_type: :fixed,
    description: <<~TEXT
      お正月に飾る門松の松の葉を使った新年を祝う縁起の良いお風呂です。
      冬でも緑を保つ松は「不老長寿」や「生命力」の象徴とされています。
    TEXT
  },
  {
    name: "大根湯",
    date_type: :variable,
    description: <<~TEXT
      大根の葉を使う保温効果のあるお風呂です。
      「白」は魔を退ける効果があるとされています。
      「身を清める」象徴としての待乳山聖天への欠かせないお供えものでもあります。
    TEXT
  },
  {
    name: "蓬湯",
    month: 3,
    day: 3,
    date_type: :fixed,
    description: <<~TEXT
      蓬（よもぎ）の葉を使うハーブ系の香りでリラックス効果のあるお風呂です。
      蓬はその強い香りや生命力から「魔除け」「厄除け」「無病息災」「子孫繁栄」の縁起物とされています。
    TEXT
  },
  {
    name: "桜湯",
    month: 4,
    day: 8,
    date_type: :fixed,
    description: <<~TEXT
      桜の樹皮や葉を煮出して作る春の訪れを感じさせるお風呂です。
      咲き始めは「生命力や未来」、満開は「繁栄や財力」、散り際は「浄化や厄除け」の象徴とされています。
    TEXT
  },
  {
    name: "菖蒲湯",
    month: 5,
    day: 5,
    date_type: :fixed,
    description: <<~TEXT
      菖蒲（しょうぶ）の葉や根を使う独特の強い香りのお風呂です。
      菖蒲が「勝負」や「尚武」と同じ読みであるや、葉の形が剣に似ていることから、
      武家社会で男の子の健康や成長を祈るために行われていたとされています。
    TEXT
  },
  {
    name: "どくだみ湯",
    month: 6,
    day: 30,
    date_type: :fixed,
    description: <<~TEXT
      どくだみの茎や葉を使う独特の強い香りのお風呂です。
      生薬名の十薬（じゅうやく）は馬がかかる十種の病に効果があるという江戸時代の言い伝えによるようです。
      現の証拠（げんのしょうこ）、千振（せんぶり）と並ぶ、日本三大民間薬のひとつです。
    TEXT
  },
  {
    name: "桃湯",
    date_type: :variable,
    description: <<~TEXT
      桃の葉を使うほんのり優しい香りのお風呂です。
      江戸時代には土用の丑の日に夏バテ防止や疲労回復のため「桃湯」に入る風習があり、これを「丑湯」と呼ぶそうです。
      桃は古くから「魔除けの力」を持つと信じられています。
    TEXT
  },
  {
    name: "薄荷湯",
    date_type: :variable,
    description: <<~TEXT
      薄荷の葉や油を使った爽やかな香りのお風呂です。
      古くから目の疲れを癒したり眠気を覚ましたりする作用から目草や目覚め草などの別名がありますが、
      血行促進効果で体を内側から温めてくれるので冷房病対策にも効果的です。
    TEXT
  },
  {
    name: "菊湯",
    month: 9,
    day: 9,
    date_type: :fixed,
    description: <<~TEXT
      菊の花を湯船に浮かべる目にも鮮やかなお風呂です。
      平安時代に中国より伝わった重陽の節句には菊湯に入り風習があります。
      天皇家の紋章にも用いられている菊は古くから不老長寿の象徴とされてきました。
    TEXT
  },
  {
    name: "生姜湯",
    date_type: :variable,
    description: <<~TEXT
      スライスした生姜やすりおろした生姜を使う爽やかな香りのお風呂です。
      夏に売られている新生姜の多くはハウス栽培で、秋の新生姜は露地栽培です。
      露地栽培は収穫量が他の時期に比べて少ないためなかなかスーパーなどではなかなか見かけませんが、
      ハウス栽培より皮がやや厚く、しっかりした辛味があるのが特徴です。
    TEXT
  },
  {
    name: "蜜柑湯",
    date_type: :variable,
    description: <<~TEXT
      蜜柑の皮を使うリラックス効果のあるお風呂です。
      蜜柑の皮は漢方で「陳皮（ちんぴ）」と呼ばれ、気の巡りを良くして胃腸の調子を整えたり（理気健脾）、
      咳や痰を鎮めたり（燥湿化痰）する作用があります。
      陳皮の「陳」は「古い」という意味で、古いものほど効能が優れているそうです。
    TEXT
  },
  {
    name: "柚子湯",
    date_type: :variable,
    description: <<~TEXT
      柚子を湯船に浮かべる香り高いお風呂です。
      冬至は運が上昇に転じる日とされ、運気を呼び込む前の潔斎（けっさい）をして身を清めていたそうです。
      入浴中に『一陽来復』と唱えるとさらに効果があるそうです。
    TEXT
  }
]

# 初期データ作成：行事
event_templates = [
  {
    name: "元日",
    date_type: :fixed,
    source_type: :auto,
    area_type: :national,
    description: <<~TEXT
      新年に年神様を迎える日です。
      年神様は豊作と子孫繁栄をもたらすと考えられていました。
      新しい歳を授ける神ともいわれ、正月を迎えると年齢に1歳足す「数え年」の習慣はここから生まれました。
    TEXT
  },
  {
    name: "人日の節句",
    month: 1,
    day: 7,
    date_type: :fixed,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      中国の風習（7種類の野菜の汁物を食べる「七種菜羹（しちしゅさいこう）」）と
      日本の風習（雪の中から芽吹いた若菜の生命力を取り込む「若菜摘み」）結びついたものです。
      源氏物語の注釈書「河海抄（かかいしょう）」の中で、
      「せり、なずな、ごぎょう、はこべら、ほとけのざ、すずな、すずしろ、これぞ七草」という形で紹介され、定着していったといわれています。
      七草を包丁で刻んで6日の夜から年神様に供え、7日の朝に粥に入れて頂きます。
    TEXT
  },
  {
    name: "鏡開き",
    month: 1,
    day: 11,
    date_type: :fixed,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      年神様にお供えしていた鏡餅は年神様の拠り所です。
      その鏡餅を開くことで年神様をお送りし、餅を食べることで年神様から力を分けて頂きます。
      硬くなった餅は刃物は使わず、木槌や金づちで叩いて割ります。
      難しい場合は、水につけたり電子レンジで柔らかくしましょう。
    TEXT
  },
  {
    name: "節分",
    date_type: :variable,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      「節分」とは季節の分かれ目という意味で、立春・立夏・立秋・立冬の前日を指します。
      元々は方相氏（ほうそうし）が疫病や悪鬼を矢などで追い払い、邪気を払う大事な行事でした。
      豆まきで使う豆は、大豆を前日に神棚にお供えし、当日に炒って作ります。
      撒き終わった豆を数え歳と同じ数食べて無病息災を祈ります。
      旧暦では節分が大晦日にあたる日でした。
    TEXT
  },
  {
    name: "初午",
    date_type: :variable,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      京都の伏見稲荷大社のご祭神が降臨したのが旧暦2月の最初の午の日とされています。
      この日に合わせて、全国の稲荷神社で初午祭が行われ、参拝（初午詣）する習慣が広まりました。
      神様の眷属(けんぞく)である狐の好物「油揚げ」を使った稲荷寿司（初午稲荷）を食べる風習があります。
      なお、稲荷神社の御祭神は主に宇迦之御魂神（うかのみたまのかみ）で、穀物や食物を司ります。
    TEXT
  },
  {
    name: "上巳の節句",
    month: 3,
    day: 3,
    date_type: :fixed,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      中国から伝わった上巳の祓（水辺で身の穢れを清める風習）が由来です。
      この時期に行われていた日本の風習（物忌みや祓い）と結びつき、身に降りかかる災いを紙などで作った人形に移し
      川や海に流す「流し雛」になりました。
      これが現在の雛祭りの原型です。
      「流し雛」の風習が平安貴族の「ひいな遊び」と結びつき、流すから飾るに変化し、
      江戸時代には女の子の初節句として定着したそうです。
    TEXT
  },
  {
    name: "春彼岸",
    date_type: :variable,
    source_type: :auto,
    area_type: :national,
    description: <<~TEXT
      春分の日を挟んだ前後3日間、合わせて7日間です。
      彼岸の初日を「彼岸の入り」、真ん中を「彼岸の中日」、最終日を「彼岸の明け」と呼びます。
      「彼岸」とは仏教用語で、私たちが住む「此岸（しがん）」に対して、ご先祖様がいる「西方浄土（極楽浄土）」を意味します。
      春彼岸のお供え物である「ぼたもち」は春に咲く「牡丹」を見立て、こしあんを使った丸い形状のものです。
    TEXT
  },
  {
    name: "灌仏会",
    month: 4,
    day: 8,
    date_type: :fixed,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      仏教の開祖である御釈迦様の御生誕を祝う日です。
      花御堂（はなみどう）に安置した誕生仏に甘茶をかけるのが特徴で、宗派を超えて日本各地の寺院で行われます。
      お釈迦様がお生まれになった際、天から神々が降りてきて祝福のために甘露の水を注いだという経典の説示に由来しています。
      「天上天下唯我独尊（てんじょうてんげゆいがどくそん）」とは、お釈迦様が誕生時に発したとされる言葉です。
      直訳は「天の上にも天の下にも、ただ私だけが最も尊い」となりますが、これは表面的な意味で、
      本来は「この世のすべての命（人々）が、それぞれかけがえのない存在として尊い」という仏教の平等思想を表す言葉です。
    TEXT
  },
  {
    name: "端午の節句",
    month: 5,
    day: 5,
    date_type: :fixed,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      端午の端は「はじめ」という意味で、「端午（たんご）」は5月最初の午（うま）の日のことでした。
      それが、午（ご）という文字の音が五に通じることなどから、奈良時代以降、5月5日が端午の節句として定着していきました。
      縁起の良い食べ物として、関西では「粽（ちまき）」、関東では「柏餅」を食べるのが一般的です。
      人望も厚く正義感の強かった屈原という政治家が陰謀により国を追われ、
      国を憂いながら旧暦5月5日に汨羅江（べきらこう）という川に身を投げました。
      中国では彼を供養するために5月5日を祭りの日とし、それが徐々に病気や災厄を避ける行事となりました。
      これが日本にも伝わり「端午の節句」になったといわれています。
    TEXT
  },
  {
    name: "夏越の大祓",
    month: 6,
    day: 30,
    date_type: :fixed,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      年が明けてから半年の間に心身についた罪やケガレ、災厄などを祓い浄め、残りの半年間の無病息災を祈願する神事です。
      人型に切り取られた形代に、名前や生年月日などを書き、全身を左・右・左と撫で祓い、特に悪いところは念入りに撫でます。 
      身の内の罪や穢れを移すように形代に息を三回、腹から大きく深く吹きかけます。
      それを川に流したり神社に納めたりして清めます。
      また、参拝者は「水無月の夏越の祓する人は千歳の命延ぶと云うなり」と唱えながら、
      茅の輪を左回り・右回り・左回りと8の字を描くように3回くぐり、疫病除け・厄除けを祈願します。
    TEXT
  },
  {
    name: "七夕の節句",
    month: 7,
    day: 7,
    date_type: :fixed,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      中国から伝わった牽牛星（けんぎゅうせい）と織女星（しょくじょせい）の星祭りの伝説と
      「乞巧奠（きこうでん）（機織り・裁縫上達を願う行事）」が起源とされています。
      これらが日本の神事（乙女が川などの清らかな水辺に設（しつらえ）られた機屋（はたや）にこもって俗世から離れ、
      神様にお供えする着物を織る）と「神衣（かむみそ）を織る女性」に結びついたものとされています。
      織姫はこと座のベガ、彦星はわし座のアルタイルで天の川を挟んで向かい合っています。
      このふたつの星と、はくちょう座のデネブを結んだのが「夏の大三角形」です。
    TEXT
  },
  {
    name: "盂蘭盆会",
    date_type: :fixed,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      「盂蘭盆」は仏教用語で、「さかさまにつるされる苦しみ」という意味があります。
      目連尊者（もくれんそんじゃ）は優れた神通力の使い手で、御釈迦様の十大弟子のひとりとされています。
      神通力で亡き母親の姿を探したところ餓鬼道(飢えと渇きに苦しむ世界)に落ちて苦しんでいるのを見つけました。
      母を救うために祖先を供養したのが旧暦の7月15日で、それが先祖の霊を祀る日になったといわれています。
      お盆の初日の13日の夕方、家の前でおがら（麻の茎）を焚いて、「迎え火」で先祖の霊を迎えます。
      最終日の16日（地域によっては15日）の夕方、初日と同じようにして家の前で「送り火」を焚いて
      御先祖様を彼岸へお送りします。
    TEXT
  },
  {
    name: "重陽の節句",
    month: 9,
    day: 9,
    date_type: :fixed,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      五節句の最後を締めくくる日です。
      中国の陰陽思想では奇数は「陽」の数で縁起が良いとされ、
      その最大値である9が重なる9月9日を「重陽（ちょうよう）」と呼びました。
      陽の数が重なると災いが起こりやすいとも考えられたため、邪気を払う行事も生まれました。
      桃の節句（3月3日）で飾った雛人形を、半年後の重陽の節句（9月9日）に虫干しを兼ねて再び飾り、
      健康、長寿、厄除けなどを願う風習を「後の雛」といい、江戸時代に庶民の間に広がったとされています。
      3月3日の上巳の節句が女の子の健やかな成長を祈る節句であるのに対し、重陽の節句は無病息災・長寿を祈る節句であるため、
      大人の女性の健やかな日々を祈る、「大人の雛祭り」として近年注目を集めるようになりました。
    TEXT
  },
  {
    name: "秋彼岸",
    date_type: :variable,
    source_type: :auto,
    area_type: :national,
    description: <<~TEXT
      秋分の日を挟んだ前後3日間、合わせて7日間です。
      極楽浄土は西にあり、春分の日や秋分の日は太陽が真西に沈むため、「西方浄土（極楽浄土）」と繋がりやすい日とされ、
      現世（此岸）とあの世（彼岸）が最も近くなると信じられています。
      秋彼岸のお供え物である「おはぎ」は秋に咲く「萩」を見立て、粒あんを使った俵型のものです。
      祝日法では、春分の日は「自然をたたえ生物をいつくしむ日」、
      秋分の日は「祖先を敬い亡くなった人々をしのぶ日」とされています。
    TEXT
  },
  {
    name: "十五夜",
    date_type: :variable,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      「十五夜」は本来、旧暦の毎月15日の夜を指します。
      旧暦8月15日の夜に見える月は一年で最も美しく見えることから「中秋の名月」呼ばれるようになったとされています。
      月の軌道が楕円形であり、新月から満月までにかかる日数が最大で15.6日、最小で13.9日と大きく変化するため、
      中秋の名月が必ずしも満月とは限りません。
      お月見行事は十五夜だけではなく「十三夜」と「十日夜（とおかんや）」があり、
      これら3つを合わせて「三月見（さんげつみ）」と呼び、すべての日が晴れて、月を見ることができれば、とても縁起のいいとされています。
    TEXT
  },
  {
    name: "十三夜",
    date_type: :variable,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      旧暦9月13日に見える月で、十五夜（中秋の名月）に次いで美しいとされています。
      十五夜が今年の豊作を祈願する日に対して、十三夜は今年の収穫に感謝する日です。
      また、里芋をはじめとした芋類を月に供えするため、別名「芋名月」と呼ばれる十五夜に対し、
      この時期に収穫される栗や豆、枝豆をお供えすることから「栗名月」や「豆名月」と呼ばれます。
      十五夜はもともと中国が発祥ですが、十三夜は日本発祥の風習なんだそうです。
    TEXT
  },
  {
    name: "年越しの大祓",
    month: 12,
    day: 31,
    date_type: :fixed,
    source_type: :manual,
    area_type: :national,
    description: <<~TEXT
      夏越の大祓を終えてから年末までに心身についた罪やケガレ、災厄などを祓い浄め、、新年を迎える準備として行われる神事です。
      食糧の生産・社会や生活の安穏に，支障を生じさせる可能性があるものが「罪」とされます。
      どんな善人であってもこの「積み」が重なり，祓い除かないと災厄を引き寄せる原因になるともいわれています。
      避けたいと思わせたり不穏を感じさせたりするモノやコトが「穢」を生じさせます。
      穢れは「気枯れ」ともいい、生命力や霊力を現す「気」が衰えた状態をいうとも考えられています。
    TEXT
  }
]

bath_templates.each do |attrs|
  ::SeasonalBaths::SeasonalBathTemplate.find_or_create_by!(name: attrs[:name]) do |bath|
    bath.assign_attributes(attrs)
  end
end

event_templates.each do |attrs|
  ::EventTemplates::EventTemplate.find_or_create_by!(name: attrs[:name]) do |event|
    event.assign_attributes(attrs)
  end
end

# 行事食を複数行事にまとめて紐づけるメソッド
def attach_food_to_events(food_name, event_names)
  # 食べ物テンプレートを取得（なければ作成）
  food = ::EventFoods::EventFood.find_or_create_by!(name: food_name)

  event_names.each do |event_name|
    template = ::EventTemplates::EventTemplate.find_by(name: event_name)
    next unless template

    # 中間テーブルで紐づけ（重複は作らない）
    ::EventTemplateFoods::EventTemplateFood.find_or_create_by!(
      event_template: template,
      event_food: food
    )
  end
end

# おすすめスポットを複数行事にまとめて紐づけるメソッド
def attach_spot_to_events(spot_name, event_names)
  # スポットテンプレートを取得（なければ作成）
  spot = ::RecommendedSpots::RecommendedSpot.find_or_create_by!(name: spot_name)

  event_names.each do |event_name|
    template = ::EventTemplates::EventTemplate.find_by(name: event_name)
    next unless template

    # 中間テーブルで紐づけ（重複は作らない）
    ::EventTemplateSpots::EventTemplateSpot.find_or_create_by!(
      event_template: template,
      recommended_spot: spot
    )
  end
end

# 使用：行事食
attach_food_to_events("御節", [ "元日" ])
attach_food_to_events("御屠蘇", [ "元日" ])

attach_food_to_events("七草粥", [ "人日の節句" ])

attach_food_to_events("御汁粉", [ "鏡開き" ])
attach_food_to_events("御雑煮", [ "鏡開き" ])

attach_food_to_events("恵方巻", [ "節分" ])
attach_food_to_events("稲荷寿司", [ "節分", "初午" ])
attach_food_to_events("鰯", [ "節分" ])
attach_food_to_events("初午団子", [ "初午" ])

attach_food_to_events("ちらし寿司", [ "人日の節句" ])
attach_food_to_events("蛤の御吸い物", [ "人日の節句" ])
attach_food_to_events("菱餅", [ "人日の節句" ])
attach_food_to_events("雛あられ", [ "人日の節句" ])
attach_food_to_events("白酒", [ "人日の節句" ])

attach_food_to_events("牡丹餅", [ "春彼岸" ])
attach_food_to_events("入り団子", [ "春彼岸", "秋彼岸" ])
attach_food_to_events("赤飯", [ "春彼岸", "秋彼岸" ])
attach_food_to_events("明け団子", [ "春彼岸", "秋彼岸" ])

attach_food_to_events("甘茶", [ "灌仏会" ])

attach_food_to_events("柏餅", [ "端午の節句" ])
attach_food_to_events("粽", [ "端午の節句" ])
attach_food_to_events("草餅", [ "端午の節句" ])

attach_food_to_events("水無月", [ "夏越の大祓" ])
attach_food_to_events("夏越御飯", [ "夏越の大祓" ])
attach_food_to_events("夏越豆腐", [ "夏越の大祓" ])

attach_food_to_events("索餅", [ "七夕の節句" ])
attach_food_to_events("素麺", [ "七夕の節句", "盂蘭盆会" ])

attach_food_to_events("迎え団子", [ "盂蘭盆会" ])
attach_food_to_events("送り団子", [ "盂蘭盆会" ])
attach_food_to_events("精進揚げ", [ "盂蘭盆会" ])

attach_food_to_events("菊酒", [ "重陽の節句" ])
attach_food_to_events("栗御飯", [ "重陽の節句" ])
attach_food_to_events("秋茄子", [ "重陽の節句" ])

attach_food_to_events("御萩", [ "秋彼岸" ])

attach_food_to_events("月見団子", [ "十五夜", "十三夜" ])
attach_food_to_events("月見酒", [ "十五夜", "十三夜" ])
attach_food_to_events("薩摩芋御飯", [ "十五夜" ])
attach_food_to_events("月餅", [ "十五夜", "十三夜" ])

attach_food_to_events("栗御飯", [ "十三夜" ])
attach_food_to_events("豆御飯", [ "十三夜" ])

attach_food_to_events("年越し蕎麦", [ "年越しの大祓" ])

# 使用：おすすめのスポット
attach_spot_to_events("氏神様", [ "元日", "夏越の大祓", "年越しの大祓" ])
attach_spot_to_events("稲荷神社", [ "初午" ])
attach_spot_to_events("仏教寺院", [ "灌仏会" ])

# 西暦を追加可能
years = [ 2025, 2026, 2027 ]

# 季節湯：固定日設定用
bath_fixed_templates = ::SeasonalBaths::SeasonalBathTemplate.where(date_type: :fixed)

# 行事：固定日設定用（手動登録）
event_fixed_templates = ::EventTemplates::EventTemplate.where(date_type: :fixed, source_type: :manual)

# 季節湯：サムネイル設定用
sakura = ::SeasonalBaths::SeasonalBathTemplate.find_by(name: "桜湯")

# 行事：日付＆サムネイル設定用
ganjitsu = ::EventTemplates::EventTemplate.find_by(name: "元日")
nagoshi = ::EventTemplates::EventTemplate.find_by(name: "夏越の大祓" )
obon = ::EventTemplates::EventTemplate.find_by(name: "盂蘭盆会")
jugoya  = ::EventTemplates::EventTemplate.find_by(name: "十五夜")
jusanya = ::EventTemplates::EventTemplate.find_by(name: "十三夜")

# 行事食：サムネイル設定用
osechi = ::EventFoods::EventFood.find_by(name: "御節")

# おすすめスポット：サムネイル設定用
ujigamisama = ::RecommendedSpots::RecommendedSpot.find_by(name: "氏神様")

# 季節湯：固定
years.each do |year|
  bath_fixed_templates.each do |template|
    ::SeasonalBaths::SeasonalBath.find_or_create_by!(
      seasonal_bath_template: template,
      year: year
    )
  end
end

# 行事：固定
years.each do |year|
  event_fixed_templates.each do |template|
    ::Events::Event.find_or_create_by!(
      event_template: template,
      year: year
    )
  end
end

# 盂蘭盆会用
years.each do |year|
  (13..16).each do |day|
    ::Events::Event.find_or_create_by!(
      event_template: obon,
      date: Date.new(year, 8, day)
    )
  end
end

# 十五夜用
jugoya_dates = {
  2025 => Date.new(2025, 10, 6),
  2026 => Date.new(2026, 9, 25),
  2027 => Date.new(2027, 9, 15)
}

jugoya_dates.each do |year, date|
  ::Events::Event.find_or_create_by!(
    event_template: jugoya,
    date: date
  )
end

# 十三夜用
jusanya_dates = {
  2025 => Date.new(2025, 11, 2),
  2026 => Date.new(2026, 10, 23),
  2027 => Date.new(2027, 10, 12)
}

jusanya_dates.each do |year, date|
  ::Events::Event.find_or_create_by!(
    event_template: jusanya,
    date: date
  )
end

# holiday_jp
years.each do |year|
  HolidayJp.between(Date.new(year, 1, 1), Date.new(year, 12, 31)).each do |holiday|
    template = ::EventTemplates::EventTemplate.find_by(name: holiday.name)

    if template
      ::Events::Event.find_or_create_by!(
        event_template: template,
        date: holiday.date
      )
    end

    case holiday.name
    when "春分の日"
      spring_higan = ::EventTemplates::EventTemplate.find_by(name: "春彼岸")
      next unless spring_higan

      (-3..3).each do |offset|
        ::Events::Event.find_or_create_by!(
          event_template: spring_higan,
          date: holiday.date + offset
        )
      end

    when "秋分の日"
      autumn_higan = ::EventTemplates::EventTemplate.find_by(name: "秋彼岸")
      next unless autumn_higan

      (-3..3).each do |offset|
        ::Events::Event.find_or_create_by!(
          event_template: autumn_higan,
          date: holiday.date + offset
        )
      end
    end
  end
end

# 季節湯サムネイル：桜（桜湯用）
sakura.bath_thumbnail.attach(
  io: File.open(Rails.root.join("db/seed_images/sakura.jpg")),
  filename: "sakura.jpg",
  content_type: "image/jpeg"

# 行事サムネイル：初日の出（元日用）
ganjitsu.event_thumbnail.attach(
  io: File.open(Rails.root.join("db/seed_images/hatsuhinode.jpg")),
  filename: "hatsuhinode.jpg",
  content_type: "image/jpeg"
)

# 行事食サムネイル：御節（元日用）
osechi.thumbnail.attach(
  io: File.open(Rails.root.join("db/seed_images/osechi.jpg")),
  filename: "osechi.jpg",
  content_type: "image/jpeg"
)

# おすすめスポットサムネイル：氏神様（夏越の大祓用）
nagoshi_ujigamisama = EventTemplateSpots::EventTemplateSpot.find_by!(
  event_template: "nagoshi",
  recommended_spot: "ujigamisama"
)

nagoshi_ujigamisama.spot_image.attach(
  io: File.open(Rails.root.join("db/seed_images/oharae.jpg")),
  filename: "oharae.jpg",
  content_type: "image/jpeg"
)
