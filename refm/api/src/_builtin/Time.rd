= class Time < Object

include Comparable

時刻オブジェクト。[[m:Time#Time.now]] は現在の時刻を返します。
[[m:File#stat]] の返すファイルのタイムスタンプは Time
オブジェクトです。

Time オブジェクトは時刻を起算時からの経過秒数で保持しています。
起算時は協定世界時(UTC、もしくはその旧称から GMT とも表記されます) の
1970年1月1日午前0時です。なお、うるう秒を勘定するかどうかはシステムに
よります。

現在の Unix システムでの最大時刻は、
協定世界時の2038年1月19日午前3時14分7秒
です。
#@# ENV["TZ"]=""; p Time.at(0x7fffffff) # => Tue Jan 19 03:14:07 UTC 2038

Time オブジェクトが格納可能な時刻の範囲は環境によって異なります。
範囲の下限としては、上記起算時からの経過秒数として 0 および正数しか
受け付けない環境もあれば、負数も受け付ける環境もあります。
また、範囲の上限としては、上記の Unix システムでの最大時刻を越えて
64bit 値の範囲の経過秒数を受け付ける環境もあります。
さらに、他に特定の時点を越える時刻の値を受け付けない環境もあります。
Time オブジェクトを生成する各メソッドで、それぞれの環境での範囲外の
時刻を格納しようとした場合は例外が発生します。

また、Time オブジェクトは協定世界時と地方時のどちらのタイムゾー
ンを使用するかのフラグを内部に保持しています。ただし、この情報は
[[m:Marshal#Marshal.dump]] では保存されず、[[m:Marshal#Marshal.load]]
で読み込んだ Time オブジェクトのタイムゾーンは常に地方時になりま
す。

例:

  p Marshal.load(Marshal.dump(Time.now.gmtime)).zone
  # => "JST"

#@if (version >= "1.9.0")
1.9 以降、タイムゾーンのフラグは Marshal デー
タに保持されます。

例:

  p Marshal.load(Marshal.dump(Time.now.gmtime)).zone
  # => "UTC"
#@end

[[unknown:time]] ライブラリによって、[[m:time#Time.parse]], [[m:time#Time.rfc2822]], [[m:time#Time.httpdate]], [[m:time#Time.iso8601]] 等が拡張されます。

メソッド
[[m:Time#sec]], 
[[m:Time#min]], 
[[m:Time#hour]], 
[[m:Time#mday]], 
[[m:Time#day]](mday の別名), 
[[m:Time#mon]], 
[[m:Time#month]](mon の別名)
[[m:Time#year]], 
[[m:Time#wday]], 
[[m:Time#yday]], 
[[m:Time#isdst]], 
[[m:Time#dst?]](isdst の別名), 
[[m:Time#zone]]
時刻の要素を参照できます。

[[man:localtime(3)]] も参照しください。

注意: C 言語の tm 構造体とは異なり、month は 1 月に対
して 1 を返し、year は 1998 年に対して 1998 を返します。また、
yday は 1 から数えます。

== Class Methods

--- at(time[, usec])

time で指定した時刻の Time オブジェクトを返します。
time は Time オブジェクト、もしくは起算時からの経過秒
数を表わす整数か浮動小数点数です。

浮動小数点の精度では不十分な場合、usec を指定します。
time + (usec/1000000) の時刻を返します。この場合、
time、usec ともに整数でなければなりません。

生成された Time オブジェクトのタイムゾーンは地方時となります。

--- gm(year[, mon[, day[, hour[, min[, sec[, usec]]]]]])
--- gm(sec, min, hour, mday, mon, year, wday, yday, isdst, zone)
--- utc(year[, mon[, day[, hour[, min[, sec[, usec]]]]]])
--- utc(sec, min, hour, mday, mon, year, wday, yday, isdst, zone)

引数で指定した協定世界時の Time オブジェクトを返します。第 2
引数以降は省略可能で、省略した場合の値はその引数がとり得る最小の値
です。

数値を受け付ける引数には文字列も指定できます。

例:

  p Time.gm *"2002-03-17".split("-")
  # => Sun Mar 17 00:00:00 UTC 2002

mon は 1(1月)から 12(12月)の範囲の整数または文字列です。英語
の月名("Jan", "Feb", ... などの省略名。文字の大小は無視)も指定でき
ます。

引数の数が[[m:Time#to_a]] と全く同じ場合(こちらは秒が先
頭に来る形式ですが)、その順序を正しく解釈します。
この形式の引数 wday, yday, zone に指定した値は無
視されます。
isdst には夏時間(Daylight Saving Time (Summer Time))があるか
を真偽値で指定します。

--- local(year[, mon[, day[, hour[, min[, sec[, usec]]]]]])
--- local(sec, min, hour, mday, mon, year, wday, yday, isdst, zone)
--- mktime(year[, mon[, day[, hour[, min[, sec[, usec]]]]]])
--- mktime(sec, min, hour, mday, mon, year, wday, yday, isdst, zone)

引数で指定した地方時の Time オブジェクトを返します。引数の扱
いは [[m:Time#Time.gm]] と同じです。

--- new
--- now

現在時刻の Time オブジェクトを返します。

--- times  ((<obsolete>))

自身のプロセスとその子プロセスが消費したユーザ/システム CPU
時間の積算を [[c:Struct]]::Tms のオブジェクトとして返します。
Struct::Tms は以下のメンバを持つ構造体クラスです。

  utime           # user time
  stime           # system time
  cutime          # user time of children
  cstime          # system time of children

時間の単位は秒で、浮動小数点数で与えられます。詳細は
[[man:times(3)]] を参照してください。

#@if (version >= "1.7.0")
このメソッドは [[c:Process]] に移動しました。Time.times も使えます
が、警告メッセージが出力されます。
#@end

== Instance Methods

--- +(other)

self より other 秒だけ後の時刻を返します

--- -(other)

other が Time オブジェクトである時、ふたつの時刻の差を
[[c:Float]] で返します。単位は秒です。other が数値である時には self
より other 秒だけ前の時刻を返します。

--- <=>(other)

時刻の比較。other は Time オブジェクトか数値でなければ
なりません。数値の場合は起算時からの経過秒数とみなして比較します。

--- asctime
--- ctime

時刻を [[man:asctime(3)]] の形式の文字列に変換します。た
だし、末尾の \n は含まれません。

--- gmt?
--- utc?

self のタイムゾーンが協定世界時に設定されていれば真を返しま
す。

#@if (version >= "1.7.0")
--- getgm
--- getutc

タイムゾーンを協定世界時に設定した Time オブジェクトを新しく
生成して返します。
#@end

#@if (version >= "1.7.0")
--- getlocal

タイムゾーンを地方時に設定した Time オブジェクトを新しく生成
して返します。
#@end

--- gmtime
--- utc

タイムゾーンを協定世界時に設定します。self を返します。

このメソッドを呼び出した後は時刻変換を協定世界時として行ないます。
協定世界時を表示するためには以下のようにします。

  print Time.now.gmtime, "\n"

[[m:Time#localtime]], [[m:Time#gmtime]]の挙動はシステムの
[[man:localtime(3)]]の挙動に依存します。Time クラ
スでは時刻を起算時からの経過秒数として保持していますが、ある特定の
時刻までの経過秒は、システムがうるう秒を勘定するかどうかによって異
なる場合があります。システムを越えて Time オブジェクトを受け
渡す場合には注意する必要があります。

--- localtime

タイムゾーンを地方時に設定します(デフォルト)。self を返しま
す。

このメソッドを呼び出した後は時刻変換を協定地方時として行ないます。

[[m:Time#localtime]], [[m:Time#gmtime]]の挙動はシステムの
[[man:localtime(3)]]の挙動に依存します。Time クラ
スでは時刻を起算時からの経過秒数として保持していますが、ある特定の
時刻までの経過秒は、システムがうるう秒を勘定するかどうかによって異
なる場合があります。システムを越えて Time オブジェクトを受け
渡す場合には注意する必要があります。

--- strftime(format)

時刻を format 文字列に従って文字列に変換した結果を返します。
format 文字列として指定できるものは 以下の通りです。

  * %A: 曜日の名称(Sunday, Monday ... )
  * %a: 曜日の省略名(Sun, Mon ... )
  * %B: 月の名称(January, February ... )
  * %b: 月の省略名(Jan, Feb ... )
  * %c: 日付と時刻
  * %d: 日(01-31)
  * %H: 24時間制の時(00-23)
  * %I: 12時間制の時(01-12)
  * %j: 年中の通算日(001-366)
  * %M: 分(00-59)
  * %m: 月を表す数字(01-12)
  * %p: 午前または午後(AM,PM)
  * %S: 秒(00-60) (60はうるう秒)
  * %U: 週を表す数。最初の日曜日が第1週の始まり(00-53)
  * %W: 週を表す数。最初の月曜日が第1週の始まり(00-53)
  * %w: 曜日を表す数。日曜日が0(0-6)
  * %X: 時刻
  * %x: 日付
  * %Y: 西暦を表す数
  * %y: 西暦の下2桁(00-99)
  * %Z: タイムゾーン  [[unknown:trap|trap::Time]]
  * %%: %自身

現在の実装では、このメソッドは、システムの [[man:strftime(3)]]
をそのまま使用しています。そのためここにあげた指示子以外のものが使
用できる場合があります。ただし、上記以外の指示子を使用した場合、移
植性をそこなう可能性がある点に注意してください。

--- sec
秒を整数で返します。

--- min
分を整数で返します。

--- hour
時を整数で返します。

--- mday
--- day         (mday の別名)
日を整数で返します。

--- mon
--- month       (mon の別名)
月を整数で返します。

--- year
年を整数で返します。

--- wday
曜日を0(日曜日)から6(土曜日)の整数で返します。

--- yday
1月1日を1とした通算日(1から366まで)を整数で返します。

--- isdst
--- dst?        (isdst の別名)
夏時間があるなら true をなければ false を返します。

--- zone
タイムゾーンを表す文字列を返します。

#@if (version >= "1.8.0")
--- succ

self に 1 秒足した Time オブジェクトを生成して返します。
タイムゾーンは地方時になります。

例:

  t = Time.now
  p t
  p t.succ
  # => Sun Jul 18 01:41:22 JST 2004
       Sun Jul 18 01:41:23 JST 2004
#@end

#@if (version >= "1.6.7")
--- utc_offset
--- gmt_offset
--- gmtoff

協定世界時との時差を秒を単位とする数値として返します。

地方時が協定世界時よりも進んでいる場合(アジア、オーストラリアなど)
には正の値、遅れている場合(アメリカなど)には負の値になります。

例:

  p Time.now.zone  # => "JST"
  p Time.now.utc_offset
  # => 32400

タイムゾーンが協定世界時に設定されている場合は 0 を返します。

例:

  p Time.now.zone  # => "JST"
  p Time.now.getgm.utc_offset
  # => 0

このメソッドは Ruby 1.6.7 で導入されました。
#@end

--- to_a

時刻を10要素の配列で返します。その要素は順序も含めて以下の通りです。

  * sec:   秒 (整数 0-60)
  * min:   分 (整数 0-60)
  * hour:  時 (整数 1-24)
  * mday:  日 (整数)
  * mon:   月 (整数 1-12)
  * year:  年 (整数 2000年=2000)
  * wday:  曜日 (整数 0-6)
  * yday:  年内通算日 (整数 1-366)
  * isdst: 夏時間の有無 (true/false)
  * zone:  タイムゾーン (文字列)

例:

  p Time.now      # => Mon Oct 20 06:02:10 JST 2003
  p Time.now.to_a # => [10, 2, 6, 20, 10, 2003, 1, 293, false, "JST"]

要素の順序は C 言語の tm 構造体に合わせています。ただし、
tm 構造体に zone はありません。

注意: C 言語の tm 構造体とは異なり、month は 1 月に対
して 1 を返し、year は 1998 年に対して 1998 を返します。また、
yday は 1 から数えます。

--- to_f

起算時からの経過秒数を浮動小数点数で返します。1 秒に満たない経過も
表現されます。

--- to_i
--- tv_sec

起算時からの経過秒数を整数で返します。

--- to_s

時刻を [[man:date(1)]] のような形式の文字列に変換します。

self.strftime("%a %b %d %H:%M:%S %Z %Y")

と同じです。

例:

  p Time.now.to_s # => "Mon Oct 20 06:02:10 JST 2003"

--- usec
--- tv_usec

時刻のマイクロ秒の部分を返します。
