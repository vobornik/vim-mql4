" Vim syntax file
" Language:	mql4
" Maintainer:	Vaclav Vobornik <git@vobornik.eu>
" Last Change:	2011 Dec 31
" Used Bram Moolenaar syntax for C as a source.

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" A bunch of useful keywords
syn keyword	mql4Statement	break return continue
syn keyword	mql4Label		case default
syn keyword	mql4Conditional	if else switch
syn keyword	mql4Repeat		while for

syn keyword	mql4Todo		contained TODO FIXME XXX

" It's easy to accidentally add a space after a backslash that was intended
" for line continuation.  Some compilers allow it, which makes it
" unpredicatable and should be avoided.
syn match	mql4BadContinuation contained "\\\s\+$"

" mql4CommentGroup allows adding matches for special things in comments
syn cluster	mql4CommentGroup	contains=mql4Todo,mql4BadContinuation

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match	mql4Special	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
if !exists("c_no_utf")
  syn match	mql4Special	display contained "\\\(u\x\{4}\|U\x\{8}\)"
endif
if exists("c_no_mql4Format")
  syn region	mql4String		start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=mql4Special,@Spell
  " mql4CppString: same as mql4String, but ends at end of line
  syn region	mql4CppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=mql4Special,@Spell
else
  if !exists("c_no_c99") " ISO C99
    syn match	mql4Format		display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjzt]\|ll\|hh\)\=\([aAbdiuoxXDOUfFeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  else
    syn match	mql4Format		display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlL]\|ll\)\=\([bdiuoxXDOUfeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  endif
  syn match	mql4Format		display "%%" contained
  syn region	mql4String		start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=mql4Special,mql4Format,@Spell
  " mql4CppString: same as mql4String, but ends at end of line
  syn region	mql4CppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=mql4Special,mql4Format,@Spell
endif

syn match	mql4Character	"L\='[^\\]'"
syn match	mql4Character	"L'[^']*'" contains=mql4Special
if exists("c_gnu")
  syn match	mql4SpecialError	"L\='\\[^'\"?\\abefnrtv]'"
  syn match	mql4SpecialCharacter "L\='\\['\"?\\abefnrtv]'"
else
  syn match	mql4SpecialError	"L\='\\[^'\"?\\abfnrtv]'"
  syn match	mql4SpecialCharacter "L\='\\['\"?\\abfnrtv]'"
endif
syn match	mql4SpecialCharacter display "L\='\\\o\{1,3}'"
syn match	mql4SpecialCharacter display "'\\x\x\{1,2}'"
syn match	mql4SpecialCharacter display "L'\\x\x\+'"

"when wanted, highlight trailing white space
if exists("c_space_errors")
  if !exists("c_no_trail_space_error")
    syn match	mql4SpaceError	display excludenl "\s\+$"
  endif
  if !exists("c_no_tab_space_error")
    syn match	mql4SpaceError	display " \+\t"me=e-1
  endif
endif

" This should be before mql4ErrInParen to avoid problems with #define ({ xxx })
if exists("c_curly_error")
  syntax match mql4CurlyError "}"
  syntax region	mql4Block		start="{" end="}" contains=ALLBUT,mql4CurlyError,@mql4ParenGroup,mql4ErrInParen,mql4CppParen,mql4ErrInBracket,mql4CppBracket,mql4CppString,@Spell fold
else
  syntax region	mql4Block		start="{" end="}" transparent fold
endif

"catch errors caused by wrong parenthesis and brackets
" also accept <% for {, %> for }, <: for [ and :> for ] (C99)
" But avoid matching <::.
syn cluster	mql4ParenGroup	contains=mql4ParenError,mql4Included,mql4Special,mql4CommentSkip,mql4CommentString,mql4Comment2String,@mql4CommentGroup,mql4CommentStartError,mql4UserCont,mql4UserLabel,mql4BitField,mql4OctalZero,mql4CppOut,mql4CppOut2,mql4CppSkip,mql4Format,mql4Number,mql4Float,mql4Octal,mql4OctalError,mql4NumbersCom
if exists("c_no_curly_error")
  syn region	mql4Paren		transparent start='(' end=')' contains=ALLBUT,@mql4ParenGroup,mql4CppParen,mql4CppString,@Spell
  " mql4CppParen: same as mql4Paren but ends at end-of-line; used in mql4Define
  syn region	mql4CppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@mql4ParenGroup,mql4Paren,mql4String,@Spell
  syn match	mql4ParenError	display ")"
  syn match	mql4ErrInParen	display contained "^[{}]\|^<%\|^%>"
elseif exists("c_no_bracket_error")
  syn region	mql4Paren		transparent start='(' end=')' contains=ALLBUT,@mql4ParenGroup,mql4CppParen,mql4CppString,@Spell
  " mql4CppParen: same as mql4Paren but ends at end-of-line; used in mql4Define
  syn region	mql4CppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@mql4ParenGroup,mql4Paren,mql4String,@Spell
  syn match	mql4ParenError	display ")"
  syn match	mql4ErrInParen	display contained "[{}]\|<%\|%>"
else
  syn region	mql4Paren		transparent start='(' end=')' contains=ALLBUT,@mql4ParenGroup,mql4CppParen,mql4ErrInBracket,mql4CppBracket,mql4CppString,@Spell
  " mql4CppParen: same as mql4Paren but ends at end-of-line; used in mql4Define
  syn region	mql4CppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@mql4ParenGroup,mql4ErrInBracket,mql4Paren,mql4Bracket,mql4String,@Spell
  syn match	mql4ParenError	display "[\])]"
  syn match	mql4ErrInParen	display contained "[\]{}]\|<%\|%>"
  syn region	mql4Bracket	transparent start='\[\|<::\@!' end=']\|:>' contains=ALLBUT,@mql4ParenGroup,mql4ErrInParen,mql4CppParen,mql4CppBracket,mql4CppString,@Spell
  " mql4CppBracket: same as mql4Paren but ends at end-of-line; used in mql4Define
  syn region	mql4CppBracket	transparent start='\[\|<::\@!' skip='\\$' excludenl end=']\|:>' end='$' contained contains=ALLBUT,@mql4ParenGroup,mql4ErrInParen,mql4Paren,mql4Bracket,mql4String,@Spell
  syn match	mql4ErrInBracket	display contained "[);{}]\|<%\|%>"
endif

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match	mql4Numbers	display transparent "\<\d\|\.\d" contains=mql4Number,mql4Float,mql4OctalError,mql4Octal
" Same, but without octal error (for comments)
syn match	mql4NumbersCom	display contained transparent "\<\d\|\.\d" contains=mql4Number,mql4Float,mql4Octal
syn match	mql4Number		display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match	mql4Number		display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
syn match	mql4Octal		display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=mql4OctalZero
syn match	mql4OctalZero	display contained "\<0"
syn match	mql4Float		display contained "\d\+f"
"floating point number, with dot, optional exponent
syn match	mql4Float		display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match	mql4Float		display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match	mql4Float		display contained "\d\+e[-+]\=\d\+[fl]\=\>"
if !exists("c_no_c99")
  "hexadecimal floating point number, optional leading digits, with dot, with exponent
  syn match	mql4Float		display contained "0x\x*\.\x\+p[-+]\=\d\+[fl]\=\>"
  "hexadecimal floating point number, with leading digits, optional dot, with exponent
  syn match	mql4Float		display contained "0x\x\+\.\=p[-+]\=\d\+[fl]\=\>"
endif

" flag an octal number with wrong digits
syn match	mql4OctalError	display contained "0\o*[89]\d*"
syn case match

if exists("c_comment_strings")
  " A comment can contain mql4String, mql4Character and mql4Number.
  " But a "*/" inside a mql4String in a mql4Comment DOES end the comment!  So we
  " need to use a special type of mql4String: mql4CommentString, which also ends on
  " "*/", and sees a "*" at the start of the line as comment again.
  " Unfortunately this doesn't very well work for // type of comments :-(
  syntax match	mql4CommentSkip	contained "^\s*\*\($\|\s\+\)"
  syntax region mql4CommentString	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=mql4Special,mql4CommentSkip
  syntax region mql4Comment2String	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=mql4Special
  syntax region  mql4CommentL	start="//" skip="\\$" end="$" keepend contains=@mql4CommentGroup,mql4Comment2String,mql4Character,mql4NumbersCom,mql4SpaceError,@Spell
  if exists("c_no_comment_fold")
    " Use "extend" here to have preprocessor lines not terminate halfway a
    " comment.
    syntax region mql4Comment	matchgroup=mql4CommentStart start="/\*" end="\*/" contains=@mql4CommentGroup,mql4CommentStartError,mql4CommentString,mql4Character,mql4NumbersCom,mql4SpaceError,@Spell extend
  else
    syntax region mql4Comment	matchgroup=mql4CommentStart start="/\*" end="\*/" contains=@mql4CommentGroup,mql4CommentStartError,mql4CommentString,mql4Character,mql4NumbersCom,mql4SpaceError,@Spell fold extend
  endif
else
  syn region	mql4CommentL	start="//" skip="\\$" end="$" keepend contains=@mql4CommentGroup,mql4SpaceError,@Spell
  if exists("c_no_comment_fold")
    syn region	mql4Comment	matchgroup=mql4CommentStart start="/\*" end="\*/" contains=@mql4CommentGroup,mql4CommentStartError,mql4SpaceError,@Spell extend
  else
    syn region	mql4Comment	matchgroup=mql4CommentStart start="/\*" end="\*/" contains=@mql4CommentGroup,mql4CommentStartError,mql4SpaceError,@Spell fold extend
  endif
endif
" keep a // comment separately, it terminates a preproc. conditional
syntax match	mql4CommentError	display "\*/"
syntax match	mql4CommentStartError display "/\*"me=e-1 contained

syn keyword	mql4Operator	false true
syn match       mql4Operator       "\(&&\|||\|==\|!=\|<\|>\|<=\|>=\)"

syn match       mql4Define         "#import"
syn match       mql4Define         "#define"
syn match       mql4Define         "#property\s\+\(copyright\|link\|stacksize\|library\|indicator_chart_window\|indicator_separate_window\|indicator_buffers\|indicator_minimum\|indicator_maximum\|indicator_color[1-8]\|indicator_width[1-8]\|indicator_style[1-8]\|indicator_level[1-8]\|indicator_levelcolor\|indicator_levelwidth\|indicator_levelstyle\|show_confirm\|show_inputs\)\(\s\+\|$\)"

syn keyword	mql4Type		bool color datetime double int string void

syn keyword	mql4Structure	extern static

syn keyword     mql4Constant       MODE_OPEN MODE_LOW MODE_HIGH MODE_CLOSE MODE_VOLUME MODE_TIME
syn keyword     mql4Constant       PERIOD_M1 PERIOD_M5 PERIOD_M15 PERIOD_M30 PERIOD_H1 PERIOD_H4 PERIOD_D1 PERIOD_W1 PERIOD_MN1
syn keyword     mql4Constant       OP_BUY OP_SELL OP_BUYLIMIT OP_SELLLIMIT OP_BUYSTOP OP_SELLSTOP
syn keyword     mql4Constant       SELECT_BY_POS SELECT_BY_TICKET MODE_TRADES MODE_HISTORY
syn keyword     mql4Constant       PRICE_CLOSE PRICE_OPEN PRICE_HIGH PRICE_LOW PRICE_MEDIAN PRICE_TYPICAL PRICE_WEIGHTED
syn keyword     mql4Constant       MODE_ASCEND MODE_DESCEND
syn keyword     mql4Constant       TIME_DATE TIME_MINUTES TIME_SECONDS
syn keyword     mql4Constant       FILE_BIN FILE_CSV FILE_READ FILE_WRITE
syn keyword     mql4Constant       CHAR_VALUE SHORT_VALUE LONG_VALUE FLOAT_VALUE DOUBLE_VALUE
syn keyword     mql4Constant       SEEK_CUR SEEK_SET SEEK_END
syn keyword     mql4Constant       MODE_GATORJAW MODE_GATORTEETH MODE_GATORLIPS
syn keyword     mql4Constant       CHART_BAR CHART_CANDLE CHART_LINE
syn keyword     mql4Constant       MODE_LOW MODE_HIGH MODE_TIME MODE_BID MODE_ASK MODE_POINT MODE_DIGITS MODE_SPREAD MODE_STOPLEVEL MODE_LOTSIZE MODE_TICKVALUE MODE_TICKSIZE MODE_SWAPLONG MODE_SWAPSHORT MODE_STARTING MODE_EXPIRATION MODE_TRADEALLOWED MODE_MINLOT MODE_LOTSTEP MODE_MAXLOT MODE_SWAPTYPE MODE_PROFITCALCMODE MODE_MARGINCALCMODE MODE_MARGININIT MODE_MARGINMAINTENANCE MODE_MARGINHEDGED MODE_MARGINREQUIRED MODE_FREEZELEVEL
syn keyword     mql4Constant       DRAW_LINE DRAW_SECTION DRAW_HISTOGRAM DRAW_ARROW DRAW_ZIGZAG DRAW_NONE
syn keyword     mql4Constant       STYLE_SOLID STYLE_DASH STYLE_DOT STYLE_DASHDOT STYLE_DASHDOTDOT
syn keyword     mql4Constant       SYMBOL_THUMBSUP SYMBOL_THUMBSDOWN SYMBOL_ARROWUP SYMBOL_ARROWDOWN SYMBOL_STOPSIGN SYMBOL_CHECKSIGN
syn keyword     mql4Constant       SYMBOL_LEFTPRICE SYMBOL_RIGHTPRICE
syn keyword     mql4Constant       Black 	DarkGreen 	DarkSlateGray 	Olive 	Green 	Teal 	Navy 	Purple Maroon 	Indigo 	MidnightBlue 	DarkBlue 	DarkOliveGreen 	SaddleBrown 	ForestGreen 	OliveDrab SeaGreen 	DarkGoldenrod 	DarkSlateBlue 	Sienna 	MediumBlue 	Brown 	DarkTurquoise 	DimGray LightSeaGreen 	DarkViolet 	FireBrick 	MediumVioletRed 	MediumSeaGreen 	Chocolate 	Crimson 	SteelBlue Goldenrod 	MediumSpringGreen 	LawnGreen 	CadetBlue 	DarkOrchid 	YellowGreen 	LimeGreen 	OrangeRed DarkOrange 	Orange 	Gold 	Yellow 	Chartreuse 	Lime 	SpringGreen 	Aqua DeepSkyBlue 	Blue 	Magenta 	Red 	Gray 	SlateGray 	Peru 	BlueViolet LightSlateGray 	DeepPink 	MediumTurquoise 	DodgerBlue 	Turquoise 	RoyalBlue 	SlateBlue 	DarkKhaki IndianRed 	MediumOrchid 	GreenYellow 	MediumAquamarine 	DarkSeaGreen 	Tomato 	RosyBrown 	Orchid MediumPurple 	PaleVioletRed 	Coral 	CornflowerBlue 	DarkGray 	SandyBrown 	MediumSlateBlue 	Tan DarkSalmon 	BurlyWood 	HotPink 	Salmon 	Violet 	LightCoral 	SkyBlue 	LightSalmon Plum 	Khaki 	LightGreen 	Aquamarine 	Silver 	LightSkyBlue 	LightSteelBlue 	LightBlue PaleGreen 	Thistle 	PowderBlue 	PaleGoldenrod 	PaleTurquoise 	LightGray 	Wheat 	NavajoWhite Moccasin 	LightPink 	Gainsboro 	PeachPuff 	Pink 	Bisque 	LightGoldenrod 	BlanchedAlmond LemonChiffon 	Beige 	AntiqueWhite 	PapayaWhip 	Cornsilk 	LightYellow 	LightCyan 	Linen Lavender 	MistyRose 	OldLace 	WhiteSmoke 	Seashell 	Ivory 	Honeydew 	AliceBlue LavenderBlush 	MintCream 	Snow 	White 			
syn keyword     mql4Constant       MODE_MAIN MODE_SIGNAL MODE_PLUSDI MODE_MINUSDI MODE_UPPER MODE_LOWER
syn keyword     mql4Constant       MODE_TENKANSEN MODE_KIJUNSEN MODE_SENKOUSPANA MODE_SENKOUSPANB MODE_CHINKOUSPAN
syn keyword     mql4Constant       MODE_SMA MODE_EMA MODE_SMMA MODE_LWMA
syn keyword     mql4Constant       IDOK IDCANCEL IDABORT IDRETRY IDIGNORE IDYES IDNO IDTRYAGAIN IDCONTINUE
syn keyword     mql4Constant       MB_OK MB_OKCANCEL MB_ABORTRETRYIGNORE MB_YESNOCANCEL MB_YESNO MB_RETRYCANCEL MB_CANCELTRYCONTINUE
syn keyword     mql4Constant       MB_ICONSTOP MB_ICONERROR MB_ICONHAND MB_ICONQUESTION MB_ICONEXCLAMATION MB_ICONWARNING MB_ICONINFORMATION MB_ICONASTERISK
syn keyword     mql4Constant       MB_DEFBUTTON1 MB_DEFBUTTON2 MB_DEFBUTTON3 MB_DEFBUTTON4
syn keyword     mql4Constant       OBJ_VLINE OBJ_HLINE OBJ_TREND OBJ_TRENDBYANGLE OBJ_REGRESSION OBJ_CHANNEL OBJ_STDDEVCHANNEL OBJ_GANNLINE OBJ_GANNFAN OBJ_GANNGRID OBJ_FIBO OBJ_FIBOTIMES OBJ_FIBOFAN OBJ_FIBOARC OBJ_EXPANSION OBJ_FIBOCHANNEL OBJ_RECTANGLE OBJ_TRIANGLE OBJ_ELLIPSE OBJ_PITCHFORK OBJ_CYCLES OBJ_TEXT OBJ_ARROW OBJ_LABEL
syn keyword     mql4Constant       OBJPROP_TIME1 OBJPROP_PRICE1 OBJPROP_TIME2 OBJPROP_PRICE2 OBJPROP_TIME3 OBJPROP_PRICE3 OBJPROP_COLOR OBJPROP_STYLE OBJPROP_WIDTH OBJPROP_BACK OBJPROP_RAY OBJPROP_ELLIPSE OBJPROP_SCALE OBJPROP_ANGLE OBJPROP_ARROWCODE OBJPROP_TIMEFRAMES OBJPROP_DEVIATION OBJPROP_FONTSIZE OBJPROP_CORNER OBJPROP_XDISTANCE OBJPROP_YDISTANCE OBJPROP_FIBOLEVELS OBJPROP_LEVELCOLOR OBJPROP_LEVELSTYLE OBJPROP_LEVELWIDTH 
syn match       mql4Constant       "OBJPROP_FIRSTLEVEL[0-9]\([^a-z0-9A-Z]\|$\)"
syn match       mql4Constant       "OBJPROP_FIRSTLEVEL[1-2][0-9]\([^a-z0-9A-Z]\|$\)"
syn match       mql4Constant       "OBJPROP_FIRSTLEVEL3[01]\([^a-z0-9A-Z]\|$\)"
syn keyword     mql4Constant       OBJ_PERIOD_M1 OBJ_PERIOD_M5 OBJ_PERIOD_M15 OBJ_PERIOD_M30 OBJ_PERIOD_H1 OBJ_PERIOD_H4 OBJ_PERIOD_D1 OBJ_PERIOD_W1 OBJ_PERIOD_MN1 OBJ_ALL_PERIODS NULL EMPTY
syn keyword     mql4Constant       REASON_REMOVE REASON_RECOMPILE REASON_CHARTCHANGE REASON_CHARTCLOSE REASON_PARAMETERS REASON_ACCOUNT
syn keyword     mql4Constant       NULL EMPTY EMPTY_VALUE CLR_NONE WHOLE_ARRAY
syn keyword     mql4Constant       ERR_NO_ERROR ERR_NO_RESULT ERR_COMMON_ERROR ERR_INVALID_TRADE_PARAMETERS ERR_SERVER_BUSY ERR_OLD_VERSION ERR_NO_CONNECTION ERR_NOT_ENOUGH_RIGHTS ERR_TOO_FREQUENT_REQUESTS ERR_MALFUNCTIONAL_TRADE ERR_ACCOUNT_DISABLED ERR_INVALID_ACCOUNT ERR_TRADE_TIMEOUT ERR_INVALID_PRICE ERR_INVALID_STOPS ERR_INVALID_TRADE_VOLUME ERR_MARKET_CLOSED ERR_TRADE_DISABLED ERR_NOT_ENOUGH_MONEY ERR_PRICE_CHANGED ERR_OFF_QUOTES ERR_BROKER_BUSY ERR_REQUOTE ERR_ORDER_LOCKED ERR_LONG_POSITIONS_ONLY_ALLOWED ERR_TOO_MANY_REQUESTS ERR_TRADE_MODIFY_DENIED ERR_TRADE_CONTEXT_BUSY ERR_TRADE_EXPIRATION_DENIED ERR_TRADE_TOO_MANY_ORDERS ERR_TRADE_HEDGE_PROHIBITED ERR_TRADE_PROHIBITED_BY_FIFO
syn keyword     mql4Constant       ERR_NO_MQLERROR ERR_WRONG_FUNCTION_POINTER ERR_ARRAY_INDEX_OUT_OF_RANGE ERR_NO_MEMORY_FOR_CALL_STACK ERR_RECURSIVE_STACK_OVERFLOW ERR_NOT_ENOUGH_STACK_FOR_PARAM ERR_NO_MEMORY_FOR_PARAM_STRING ERR_NO_MEMORY_FOR_TEMP_STRING ERR_NOT_INITIALIZED_STRING ERR_NOT_INITIALIZED_ARRAYSTRING ERR_NO_MEMORY_FOR_ARRAYSTRING ERR_TOO_LONG_STRING ERR_REMAINDER_FROM_ZERO_DIVIDE ERR_ZERO_DIVIDE ERR_UNKNOWN_COMMAND ERR_WRONG_JUMP ERR_NOT_INITIALIZED_ARRAY ERR_DLL_CALLS_NOT_ALLOWED ERR_CANNOT_LOAD_LIBRARY ERR_CANNOT_CALL_FUNCTION ERR_EXTERNAL_CALLS_NOT_ALLOWED ERR_NO_MEMORY_FOR_RETURNED_STR ERR_SYSTEM_BUSY ERR_INVALID_FUNCTION_PARAMSCNT ERR_INVALID_FUNCTION_PARAMVALUE ERR_STRING_FUNCTION_INTERNAL ERR_SOME_ARRAY_ERROR ERR_INCORRECT_SERIESARRAY_USING ERR_CUSTOM_INDICATOR_ERROR ERR_INCOMPATIBLE_ARRAYS ERR_GLOBAL_VARIABLES_PROCESSING ERR_GLOBAL_VARIABLE_NOT_FOUND ERR_FUNC_NOT_ALLOWED_IN_TESTING ERR_FUNCTION_NOT_CONFIRMED ERR_SEND_MAIL_ERROR ERR_STRING_PARAMETER_EXPECTED ERR_INTEGER_PARAMETER_EXPECTED ERR_DOUBLE_PARAMETER_EXPECTED ERR_ARRAY_AS_PARAMETER_EXPECTED ERR_HISTORY_WILL_UPDATED ERR_TRADE_ERROR ERR_END_OF_FILE ERR_SOME_FILE_ERROR ERR_WRONG_FILE_NAME ERR_TOO_MANY_OPENED_FILES ERR_CANNOT_OPEN_FILE ERR_INCOMPATIBLE_FILEACCESS ERR_NO_ORDER_SELECTED ERR_UNKNOWN_SYMBOL ERR_INVALID_PRICE_PARAM ERR_INVALID_TICKET ERR_TRADE_NOT_ALLOWED ERR_LONGS_NOT_ALLOWED ERR_SHORTS_NOT_ALLOWED ERR_OBJECT_ALREADY_EXISTS ERR_UNKNOWN_OBJECT_PROPERTY ERR_OBJECT_DOES_NOT_EXIST ERR_UNKNOWN_OBJECT_TYPE ERR_NO_OBJECT_NAME ERR_OBJECT_COORDINATES_ERROR ERR_NO_SPECIFIED_SUBWINDOW ERR_SOME_OBJECT_ERROR
syn keyword     mql4Variable       Ask Bars Bid Digits Point 
syn keyword     mql4Series         Close High Low Open Time Volume
syn keyword     mql4Function       AccountBalance AccountCredit AccountCompany AccountCurrency AccountEquity AccountFreeMargin AccountFreeMarginCheck AccountFreeMarginMode AccountLeverage AccountMargin AccountName AccountNumber AccountProfit AccountServer AccountStopoutLevel AccountStopoutMode
syn keyword     mql4Function       ArrayBsearch ArrayCopy ArrayCopyRates ArrayCopySeries ArrayDimension ArrayGetAsSeries ArrayInitialize ArrayIsSeries ArrayMaximum ArrayMinimum ArrayRange ArrayResize ArraySetAsSeries ArraySize ArraySort
syn keyword     mql4Function       GetLastError IsConnected IsDemo IsDllsAllowed IsExpertEnabled IsLibrariesAllowed IsOptimization IsStopped IsTesting IsTradeAllowed IsTradeContextBusy IsVisualMode UninitializeReason
syn keyword     mql4Function       TerminalCompany TerminalName TerminalPath
syn keyword     mql4Function       Alert Comment GetTickCount MarketInfo MessageBox PlaySound Print SendFTP SendMail SendNotification Sleep
syn keyword     mql4Function       CharToStr DoubleToStr NormalizeDouble StrToDouble StrToInteger StrToTime TimeToStr
syn keyword     mql4Function       IndicatorBuffers IndicatorCounted IndicatorDigits IndicatorShortName SetIndexArrow SetIndexBuffer SetIndexDrawBegin SetIndexEmptyValue SetIndexLabel SetIndexShift SetIndexStyle SetLevelStyle SetLevelValue
syn keyword     mql4Function       Day DayOfWeek DayOfYear Hour Minute Month Seconds TimeCurrent TimeDay TimeDayOfWeek TimeDayOfYear TimeHour TimeLocal TimeMinute TimeMonth TimeSeconds TimeYear Year
syn keyword     mql4Function       FileClose FileDelete FileFlush FileIsEnding FileIsLineEnding FileOpen FileOpenHistory FileReadArray FileReadDouble FileReadInteger FileReadNumber FileReadString FileSeek FileSize FileTell FileWrite FileWriteArray FileWriteDouble FileWriteInteger FileWriteString
syn keyword     mql4Function       GlobalVariableCheck GlobalVariableDel GlobalVariableGet GlobalVariableName GlobalVariableSet GlobalVariableSetOnCondition GlobalVariablesDeleteAll GlobalVariablesTotal
syn keyword     mql4Function       MathAbs MathArccos MathArcsin MathArctan MathCeil MathCos MathExp MathFloor MathLog MathMax MathMin MathMod MathPow MathRand MathRound MathSin MathSqrt MathSrand MathTan
syn keyword     mql4Function       ObjectCreate ObjectDelete ObjectDescription ObjectFind ObjectGet ObjectGetFiboDescription ObjectGetShiftByValue ObjectGetValueByShift ObjectMove ObjectName ObjectsDeleteAll ObjectSet ObjectSetFiboDescription ObjectSetText ObjectsTotal ObjectType 
syn keyword     mql4Function       StringConcatenate StringFind StringGetChar StringLen StringSetChar StringSubstr StringTrimLeft StringTrimRight
syn keyword     mql4Function       iAC iAD iAlligator iADX iATR iAO iBearsPower iBands iBandsOnArray iBullsPower iCCI iCCIOnArray iCustom iDeMarker iEnvelopes iEnvelopesOnArray iForce iFractals iGator iIchimoku iBWMFI iMomentum iMomentumOnArray iMFI iMA iMAOnArray iOsMA iMACD iOBV iSAR iRSI iRSIOnArray iRVI iStdDev iStdDevOnArray iStochastic iWPR
syn keyword     mql4Function       iBars iBarShift iClose iHigh iHighest iLow iLowest iOpen iTime iVolume
syn keyword     mql4Function       OrderClose OrderCloseBy OrderClosePrice OrderCloseTime OrderComment OrderCommission OrderDelete OrderExpiration OrderLots OrderMagimql4Number OrderModify OrderOpenPrice OrderOpenTime OrderPrint OrderProfit OrderSelect OrderSend OrdersHistoryTotal OrderStopLoss OrdersTotal OrderSwap OrderSymbol OrderTakeProfit OrderTicket OrderType
syn keyword     mql4Function       HideTestIndicators Period RefreshRates Symbol WindowBarsPerChart WindowExpertName WindowFind WindowFirstVisibleBar WindowHandle WindowIsVisible WindowOnDropped WindowPriceMax WindowPriceMin WindowPriceOnDropped WindowRedraw WindowScreenShot WindowTimeOnDropped WindowsTotal WindowXOnDropped WindowYOnDropped
syn keyword     mql4Obsolete      BarsPerWindow ClientTerminalName CurTime CompanyName FirstVisibleBar Highest HistoryTotal LocalTime Lowest ObjectsRedraw PriceOnDropped ScreenShot ServerAddress TimeOnDropped       

" Accept %: for # (C99)
syn region      mql4PreCondit      start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$"  keepend contains=mql4Comment,mql4CommentL,mql4CppString,mql4Character,mql4CppParen,mql4ParenError,mql4Numbers,mql4CommentError,mql4SpaceError
syn match	mql4PreCondit	display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
if !exists("c_no_if0")
  if !exists("c_no_if0_fold")
    syn region	mql4CppOut		start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=mql4CppOut2 fold
  else
    syn region	mql4CppOut		start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=mql4CppOut2
  endif
  syn region	mql4CppOut2	contained start="0" end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=mql4SpaceError,mql4CppSkip
  syn region	mql4CppSkip	contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=mql4SpaceError,mql4CppSkip
endif
syn region	mql4Included	display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	mql4Included	display contained "<[^>]*>"
syn match	mql4Include	display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=mql4Included
"syn match mql4LineSkip	"\\$"
syn cluster	mql4PreProcGroup	contains=mql4PreCondit,mql4Included,mql4Include,mql4Define,mql4ErrInParen,mql4ErrInBracket,mql4UserLabel,mql4Special,mql4OctalZero,mql4CppOut,mql4CppOut2,mql4CppSkip,mql4Format,mql4Number,mql4Float,mql4Octal,mql4OctalError,mql4NumbersCom,mql4String,mql4CommentSkip,mql4CommentString,mql4Comment2String,@mql4CommentGroup,mql4CommentStartError,mql4Paren,mql4Bracket,mql4Multi
syn region	mql4Define		start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" keepend contains=ALLBUT,@mql4PreProcGroup,@Spell
syn region	mql4PreProc	start="^\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@mql4PreProcGroup,@Spell

" Highlight User Labels
syn cluster	mql4MultiGroup	contains=mql4Included,mql4Special,mql4CommentSkip,mql4CommentString,mql4Comment2String,@mql4CommentGroup,mql4CommentStartError,mql4UserCont,mql4UserLabel,mql4BitField,mql4OctalZero,mql4CppOut,mql4CppOut2,mql4CppSkip,mql4Format,mql4Number,mql4Float,mql4Octal,mql4OctalError,mql4NumbersCom,mql4CppParen,mql4CppBracket,mql4CppString
syn region	mql4Multi		transparent start='?' skip='::' end=':' contains=ALLBUT,@mql4MultiGroup,@Spell
" Avoid matching foo::bar() in C++ by requiring that the next char is not ':'
syn cluster	mql4LabelGroup	contains=mql4UserLabel
syn match	mql4UserCont	display "^\s*\I\i*\s*:$" contains=@mql4LabelGroup
syn match	mql4UserCont	display ";\s*\I\i*\s*:$" contains=@mql4LabelGroup
syn match	mql4UserCont	display "^\s*\I\i*\s*:[^:]"me=e-1 contains=@mql4LabelGroup
syn match	mql4UserCont	display ";\s*\I\i*\s*:[^:]"me=e-1 contains=@mql4LabelGroup

syn match	mql4UserLabel	display "\I\i*" contained

" Avoid recognizing most bitfields as labels
syn match	mql4BitField	display "^\s*\I\i*\s*:\s*[1-9]"me=e-1 contains=mql4Type
syn match	mql4BitField	display ";\s*\I\i*\s*:\s*[1-9]"me=e-1 contains=mql4Type

if exists("c_minlines")
  let b:c_minlines = c_minlines
else
  if !exists("c_no_if0")
    let b:c_minlines = 50	" #if 0 constructs can be long
  else
    let b:c_minlines = 15	" mostly for () constructs
  endif
endif
if exists("c_curly_error")
  syn sync fromstart
else
  exec "syn sync ccomment mql4Comment minlines=" . b:c_minlines
endif

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link mql4Format		mql4Special
hi def link mql4CppString		mql4String
hi def link mql4CommentL		mql4Comment
hi def link mql4CommentStart	mql4Comment
hi def link mql4Label		Label
hi def link mql4UserLabel		Label
hi def link mql4Conditional	Conditional
hi def link mql4Repeat		Repeat
hi def link mql4Character		Character
hi def link mql4SpecialCharacter	mql4Special
hi def link mql4Number		Number
hi def link mql4Octal		Number
hi def link mql4OctalZero		PreProc	 " link this to Error if you want
hi def link mql4Float		Float
hi def link mql4OctalError		mql4Error
hi def link mql4ParenError		mql4Error
hi def link mql4ErrInParen		mql4Error
hi def link mql4ErrInBracket	mql4Error
hi def link mql4CommentError	mql4Error
hi def link mql4CommentStartError	mql4Error
hi def link mql4SpaceError		mql4Error
hi def link mql4SpecialError	mql4Error
hi def link mql4CurlyError		mql4Error
hi def link mql4Operator		Operator
hi def link mql4Structure		Structure
hi def link mql4StorageClass	StorageClass
hi def link mql4Include		Include
hi def link mql4PreProc		PreProc
hi def link mql4Define		Macro
hi def link mql4Included		mql4String
hi def link mql4Error		Error
hi def link mql4Statement		Statement
hi def link mql4PreCondit		PreCondit
hi def link mql4Type		Type
hi def link mql4Constant		Constant
hi def link mql4Variable		Constant
hi def link mql4Series		Constant
hi def link mql4Function           Structure
hi def link mql4Obsolete           Error
hi def link mql4CommentString	mql4String
hi def link mql4Comment2String	mql4String
hi def link mql4CommentSkip	mql4Comment
hi def link mql4String		String
hi def link mql4Comment		Comment
hi def link mql4Special		SpecialChar
hi def link mql4Todo		Todo
hi def link mql4BadContinuation	Error
hi def link mql4CppSkip		mql4CppOut
hi def link mql4CppOut2		mql4CppOut
hi def link mql4CppOut		Comment

let b:current_syntax = "c"

" vim: ts=8
