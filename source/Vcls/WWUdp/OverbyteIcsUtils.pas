{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       Arno Garrels <arno.garrels@gmx.de>
Description:  A place for common utilities.
Creation:     Apr 25, 2008
Version:      V9.5
EMail:        http://www.overbyte.be       francois.piette@overbyte.be
Support:      https://en.delphipraxis.net/forum/37-ics-internet-component-suite/
Legal issues: Copyright (C) 2002-2025 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium.

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to Francois PIETTE. Use a nice stamp and mention your name,
                 street address, EMail address and any comment you like to say.

History:
Apr 25, 2008 V1.00 AGarrels added first functions UnicodeToAscii, UnicodeToAnsi,
             AnsiToUnicode and IsUsAscii .
May 01, 2008 V1.01 AGarrels added StreamWriteString.
May 02, 2008 V1.02 AGarrels a few optimizations and a bugfix in StreamWriteString.
May 11, 2008 V1.03 USchuster added atoi implementations (moved from several units)
May 15, 2008 V1.04 AGarrels fix in IcsAppendStr made StreamWriteString a function.
May 19, 2008 V1.05 AGarrels added BOM-support to StreamWriteString plus two
             overloads. Made UnicodeString a type alias of WideString in compiler
             versions < COMPILER12 in order to enable use of some conversion
             routines for older compilers as well.
May 19, 2008 V1.06 Don't check actual string codepage but assume UTF-16 Le
             in function StreamWriteString() (temp fix).
Jul 14, 2008 V1.07 atoi improved, should be around 3 times faster.
Jul 17, 2008 V1.08 Added OverbyteIcsTypes to the uses clause and removed
             SysUtils, removed some defines for unsupported old compilers.
             StreamWriteString should work with WideStrings as well with old
             compilers.
Jul 20, 2008 V1.09 Added Utf-8 string functions.
Jul 29, 2008 V1.10 Added parameter "SetCodePage" to UnicodeToAnsi(), defaults
             to "False". Utf-8 functions adjusted accordingly. Does effect
             compiler post RDS2007 only.
Jun 05, 2008 Utf-8 functions modified to take and return AnsiString rather than
             UTF8String.
Aug 11, 2008 CheckUnicodeToAnsi() added. Changed the DefaultFailChar to "?".
Aug 23, 2008 Utf-8 functions modified RawByteString rather than AnsiString.
Aug 27, 2008 Arno Garrels added WideString functions and other stuff.
Sep 11, 2008 Angus added more widestring functions
             No range checking so they all work (IcsFileGetAttrW in particular)
Sep 20, 2008 V1.16 Angus still adding WideString functions
Sep 21, 2008 V1.17 Link RtlCompareUnicodeString() dynamically at run-time
Sep 27, 2008 V1.18 Arno fixed a bug in StringToUtf8.
Sep 28, 2008 V1.19 A. Garrels Moved IsDigit, IsXDigit, XDigit, htoi2 and htoin
             from OverbyteIcsUrl and added overloads. Fixed a bug in
             ConvertCodepage().
Oct 03, 2008 V1.20 A. Garrels moved some double helper functions to this unit.
             Added symbol USE_INLINE that enables inlining.
Oct 23, 2008 V7.21 A. Garrels added IcsStrNextChar, IcsStrPrevChar and
             IcsStrCharLength, see description below. Useful when converting
             a ANSI character stream with known code page to Unicode in
             chunks. Added a PAnsiChar overload to function AnsiToUnicode.
Nov 13, 2008 v7.22 Arno added CharsetDetect, IsUtf8Valid use CharsetDetect.
Dec 05, 2008 v7.23 Arno added function IcsCalcTickDiff.
Apr 18, 2009 V7.24 Arno added a PWideChar overload to UnicodeToAnsi().
May 02, 2009 V7.25 Arno added IcsNextCharIndex().
May 03, 2009 V7.26 Arno added IsUtf8TrailByte and IsLeadChar.
May 14, 2009 V7.27 Arno changed IcsNextCharIndex() to avoid a compiler
             warning in C++ Builder (assertion moved one line up).
             Removed uneccessary overload directives from IcsCharNextUtf8
             and IcsCharPrevUtf8.
May 17, 2009 V7.28 Arno prefixed argument names of various UTF-8 overloads
             by "Utf8" so that C++Builder user know that UTF-8 encoded
             AnsiStrings are expected.
June 4, 2009 V7.29 Angus added IcsExtractLastDir
Jun 22, 2009 V7.30 Angus avoid D2009 error with IcsExtractLastDir
Sep 24, 2009 V7.31 Arno added TIcsIntegerList and IcsBufferToHex.
             Small fix in ConvertCodepage(). Added check for nil in
             IcsCharNextUtf8(). Added global consts CP_UTF16, CP_UTF16Be,
             CP_UTF32 and CP_UTF32Be. New functions IcsBufferToUnicode,
             IcsGetWideCharCount and IcsGetWideChars see comments in interface
             section. Added fast functions to swap byte order: IcsSwap16,
             IcsSwap16Buf, IcsSwap32, IcsSwap32Buf and IcsSwap64Buf.
Dec 15, 2009 V7.32 Arno added typedef PInt64 for CB 2006 and CB2007.
Mar 06, 2010 V7.33 Arno fixed IcsGetWideCharCount, MultiByteToWideChar() does
             not support flag "MB_ERR_INVALID_CHARS" with all code pages.
             Fixed some ugly bugs in UTF-8 helper functions too. Added
             IsUtf8LeadByte() and IcsUtf8Size().
Apr 26, 2010 V7.34 Arno removed some Windows dependencies. Charset conversion
             functions optionally may use GNU iconv library (LGPL) by explicitly
             defining conditional "USE_ICONV".
May 07, 2010 V7.35 Arno added IcsIsSBCSCodepage.
Aug 21, 2010 V7.36 Arno fixed a bug in the UTF-8 constructor of TIcsFileStreamW.
Sep 05, 2010 V7.37 Arno added procedure IcsNameThreadForDebugging
Apr 15, 2011 V7.38 Arno prepared for 64-bit.
May 06, 2011 V7.39 Arno moved TThreadID to OverbyteIcsTypes.
Jun 08, 2011 v7.40 Arno added x64 assembler routines, untested so far.
Jun 14, 2011 v7.41 aguser added Unicode Normalization as IcsNormalizeString()
             see http://www.unicode.org/reports/tr15/tr15-33.html.
Aug 14, 2011 v7.42 Arno fixed IcsSwap64 BASM 32-bit (not yet used in ICS)
Feb 08, 2012 v7.43 Arno - The IcsFileCreateW and IcsFileOpenW functions return a
             THandle in XE2+ now. Same as SysUtils.FileCreate and SysUtils.FileOpen
             in XE2+.
Feb 29, 2012 V7.44 Arno added IcsRandomInt() and IcsCryptGenRandom(), see
             comments at IcsRandomInt's implementation.
Apr 27, 2012 V7.45 Arno added IcsFileUtcModified().
May 2012 - V8.00 - Arno added FireMonkey cross platform support with POSIX/MacOS
                   also IPv6 support, include files now in sub-directory
Oct 06, 2012 v8.01 Arno simplified TIcsIntegerList.IndexOf().
Nov 10, 2012 v8.02 Bugfix IcsCompareTextA IcsCompareStrA
Apr 25, 2013 V8.03 Arno minor XE4 changes. Added IcsStrLen(), IcsStrPas()
                  IcsStrCopy().
Mai 03, 2013 V8.04 Compile some overloaded versions of new functions from V8.03
             in Delphi 2009+ only.
Jul 06, 2013 V8.05 FPiette fixed confitional compilation for IcsStrPCopy so
             that it compiles with Delphi7.
Jul 06, 2013 V8.06 Arno reverted the conditional define from previous fix and
             fixed IcsStrPCopy instead.
Jul 13, 2013 V8.07 Arno added an overloaded version of IcsGetBufferCodepage that
             returns BOM's size.
Nov 23, 2015 V8.08 Eugene Kotlyarov fix MacOSX compilation and compiler warnings
Feb 22, 2016 V8.09 Angus moved RFC1123_Date and RFC1123_StrToDate from HttpProt
Nov 15, 2016 V8.38 Angus moved IcsGetFileVerInfo from OverbyteIcsSSLEAY
                   Added IcsVerifyTrust to check authenticode code signing digital
                     certificate and hash on EXE and DLL files, note currently
                     ignores certificate revoke checking since so slow
Apr 4, 2017  V8.45 Added $EXTERNALSYM to satisfy C++. thanks to Jarek Karciarz
May 12, 2017 V8.47 Added IcsCheckTrueFalse
Jun 23, 2017 V8.49 Fixes for MacOs
                   Added several functions for copying and searching TBytes buffers
                     that receive socket data, converting them to Strings
                   Moved IcsGetFileSize and IcsGetUAgeSizeFile here from FtpSrvT
Sep 19, 2017 V8.50 Added IcsMoveTBytesToString and IcsMoveStringToTBytes that take
                      a codepage for proper Unicode conversion
Nov 17, 2017 V8.51 Added IcsGetFileUAge
Feb 12, 2018 V8.52 Added IcsFmtIpv6Addr, IcsFmtIpv6AddrPort and IcsStripIpv6Addr to
                      format browser friendly IPv6 addresses with []
                   Added useful constants like IcsLF and IcsCR, etc.
Apr 04, 2018 V8.53 Added sanity test to IcsBufferToHex to avoid exceptions
                   Added RFC3339_StrToDate and RFC3339_DateToStr, aka ISO 8601 dates
                   Added IcsBufferToHex overload with AnsiString
                   Added IcsHextoBin
Apr 25, 2018 V8.54 Moved IntToKbyte and ticks stuff from OverbyteIcsFtpSrvT
Sep 18, 2018 V8.57 Added IcsWireFmtToStrList and IcsStrListToWireFmt converting
                     Wire Format concatenated length prefixed strings to TStrings
                     and vice versa, used by SSL hello.
                   Added IcsEscapeCRLF and IcsUnEscapeCRLF to change CRLF to \n
                     and vice versa
                   Added IcsSetToInt, IcsIntToSet, IcsSetToStr, IcsStrToSet to
                     ease saving set bit maps to INI files and registry.
                   Added IcsExtractNameOnly, IsPathDelim and IcsGetCompName
Dec 17, 2019 V8.59 Added IcsGetExceptMess
Mar 11, 2019 V8.60 Added IcsFormatSettings to replace formatting public vars removed in XE3.
                   Added IcsAddThouSeps to add thousand separators to a numeric string.
                   Added IcsInt64ToCStr and IcsIntToCStr integer to thou sep strings.
                   Added GetBomFromCodePage
                   Added TIcsFindList descendent of TList with a Find function
                        using binary search identical to sorting.
                   Added IcsDeleteFile, IcsRenameFile and IcsForceDirsEx
                   Added IcsTransChar, IcsPathUnixToDos and IcsPathDosToUnix
                   Added IcsSecsToStr and IcsGetTempPath
Jun 19, 2019 V8.62 Added IcsGetLocalTZBiasStr get time zone bias as string, ie -0700.
                   Added Time Zone support for date string conversions, to UTC time with
                      a time zone, and back to local time using a time zone.
                   RFC3339_DateToStr and RFC1123_Date add time zone bias if AddTZ=True, ie -0700.
                   Added RFC3339_DateToUtcStr and RFC1123_UtcDate which convert local
                      time to UTC and format it per RFC3339 with time zone bias.
                   RFC3339_StrToDate and RFC1123_StrToDate now recognise time zone
                      bias and adjust result if UseTZ=True from UTC to local time.
Nov 7, 2018  V8.63 Better error handling in RFC1123_StrToDate to avoid exceptions.
                   Added TypeInfo enumeration sanity check for IcsSetToStr and IcsStrToSet.
Mar 18, 2020 V8.64 Allow IcsGetUTCTime, IcsSetUTCTime, GetIcsFormatSettings to build
                     on MacOS again, they use Windows only APIs.
                   IcsGetTempPath builds on MacOS.
                   IcsGetCompName now Windows only, only used in samples.
                   IcsStrListToWireFmt supports Unicode correctly.
                   IcsWireFmtToStrList checks buffer length valid, added IcsWireFmtToCSV
                   Declare TBytess function parameters as const to avoid reference
                     counting corruption with cast pointers, thanks to Kas Ob for
                     finding this, which caused stack corruption and unexpected
                     errors mainly with 64-bit applications, probably.
                   Added support for International Domain Names for Applications,
                     i.e. using accents and unicode characters in domain names.
                   IcsIDNAToASCII converts a Unicode domain or host name into
                     A-Label (Punycode ASCII) if any characters over x7F, preceding
                     with ACE (ASCII Compatible Encoding) prefix xn--.
                   IcsIDNAToUnicode converts an A-Label (Punycode ASCII) domain or
                     host name into Unicode if any ACE (ASCII Compatible Encoding)
                     prefixes xn-- are found.
                   IcsToASCII and IcsToUnicode are similar but work on simple
                     labels (the nodes in a domain name), uses ACE.
                   IcsPunyEncode and IcsPunyDecode do the actual Unicode conversion
                     to and from A-Label (Punycode ASCII), no ACE.
                   Sample OverbyteIcsBatchDnsLookup has lots of ISN test names.
Dec 17, 2020 V8.65 Builds under Delphi 7 again, no inline.
                   Added some literals to build Json.
                   Added IcsPosEx with compatibility for all compilers.
                   MacOS64 and Linux do not support inline assembler so set PUREPASCAL.
                   Fix TIcsFindList.AddSorted result mismatch with MacOS64.
                   FileSetAttr is windows only, so can not delete read only files on Posix.
                   Lot of minor changes preparing for Linux support, several
                      MACOS changed to POSIX, some TODO functions.
                   Replaced some LongInts with Integer for Posix.
                   Added IcsMakeLongLong to make Int64
                   Corrected RFC1123_StrToDate to accept single digit day of the
                     month, which is illegal but common.
Sep 22, 2021 V8.67 Added overloaded AnsiToUnicode with specified size buffer. used by
                     IcsMoveTBytesToString and some IcsHtmlToStr conversion to resolve
                     problem processing buffer with no terminating null, so extra
                     characters got added beyond buffer end.
                   Added common computer size literals IcsKBYTE, IcsMBYTE, IcsGBYTE.
                   Added IcsStringBuild class moved from OverbyteIcsBlacklist,
                     works on all compilers.
                   Added IcsGetShellPath based on GetCommonAppDataFolder in
                     OverbyteIcsIniFiles.
                   Added IcsDirExists to replace DirExists in OverbyteIcsFtpSrv.
                   Moved Base64Encode/Base64Decode here from OverbyteIcsMimeUtils.
                   Moved IcsBase64UrlDecode, IcsBase64UrlEncode/A and IcsJsonPair
                     here from OverbyteIcsSslJose to ease circular referencing.
                   IcsBase64UrlEncodeA avoid string conversions should be used
                     for encoding binary fields with nulls.
                   Added IcsBase64UrlDecodeA avoid string conversions should be
                     used for decoding binary fields with nulls.
Dec 13, 2021 V8.68 Trying to keep C++ happy.
                   Moved IcsFileInUse and IcsTruncateFile here from OverbyteIcsCopy.
May 04, 2022 V8.69 Split IcsMoveStringToTBytes (no code page) into two versions,
                     one for Unicode String, one for AnsiString.
Oct 11, 2022 V8.70 Added file system extended path name constants and IcsAddLongPath
                     to adjust long file name to add them for names longer than 260
                     chars, if supported by the disk file system, unicode APIs only.
                   IcsForceDirsEx, IcsRenameFile, IcsDeleteFile, IcsGetUAgeSizeFile,
                     IcsGetFileAge and IcsGetFileSize now support long file paths.
                   Added IcsBuiltWith and IcsBuiltWithEx to return compiler version
                     number or name and platform information, for debugging.
                   Added a few byte constants, for use with TBytes, ie IcsbNULL,
                     IcsbCR,IcsbLF, etc.
Nov 9, 2022  V8.70 Corrected typo in IcsBuiltWith, 10.4 missing colon.
Jul 19, 2023 V8.71 Corrected RFC3339_DateToStr to add colon to time zone, RFC3359
                     requires +00:00, ISO also accepts +0000.
                   Ensure IcsGetTickCount never returns 0.
                   Added StringToUtf8TB convert string to TBytes.
                   Added IcsTextOnStart case insensitive text at start of line.
                   Added function IcsTBytesToString convert TBytes to unicode string.
                   None of the 32-bit tick functions like IcsGetTickCount are now used in
                     ICS, only 64-bit functions in OverbyteIcsTicks64, they remain here
                     in case used in end user applications, but recommend changing to
                     Int64 versions.
                   IcsBuiltWith recognises Delphi 11.3 and maybe 11.4.
                   IcsWcToMb and IcsMbToWc now use cross platform RTL functions instead
                     of OverbyteIcsIconv and USE_ICONV which have been removed.
                     IcsIconvNameFromCodePage is now POSIX instead of USE_ICONV.
Aug 08, 2023 V9.0  Updated version to major release 9.
Feb 08, 2024 V9.1  Added IcsTBToHex for a TBytes buffer.
                   IcsTBytesToString now sets length if not specified.
                   Added IcsFormatHexStr to break long hex string into groups and lines,
                     defaulting to eight chars per group, 64 per line.
                   Added IcsStrRemCntls to replace control codes (< space) in string
                     with ~,  optionally leaving line endings, IcsStrRemCntlsA takes
                     an AnsiString or buffer, IcsStrRemCntlsTB is TBytes buffer.
                   Added IcsStrBeakup to break up text into multiple lines of specified
                     length, default 80.
                   Added IcsTimeToZStr to convert DataTime to string hh:mm:ss:zzz.
                   Added IcsResourceGetTB to read TBytes from a named resource.
                   Added IcsResourceSaveFile to save a file from a named resource.
                   Report mobile platforms to IcsBuiltWithEx.
                   Fix some problems building for Android.
                   IcsFileStreamW now only for non-unicode compilers.
                   Added IcsDataSaveFile and IcsDataLoadFile to save TBytes to
                     a file, and load it from a file, no error reporting.
                   Another IcsMoveTBytesToString overload for AnsiString.
                   Renamed IcsToASCII to IcsPunyToAsci and IcsToUnicode to
                     IcsPunyToUnicode so they don't get used for the wrong purpose.
                   Added IcsTBytesToStringA, IcsStringToTBytes and IcsStringAToTBytes
                     for simple TBytes to/from Ansi and Unicode strings.
                   Added Base64EncodeTB for a TBytes buffer, Base64EncodeA for AnsiString,
                     Base64DecodeTB to a TBytes buffer.
                   Added IcsBase64UrlDecodeTB and IcsBase64UrlDecodeATB to TBytes, and
                     IcsBase64UrlEncodeTB and IcsBase64UrlEncodeATB from TBytes.
                   Added Utf8ToStringTB for TBytes to String.
                   Added function IcsAbsolutisePath, moved from HttpSrv.
Aug 07, 2024 V9.3  IcsResourceGetTB now supported on Posix.
                   IcsGetCompName now supported on Posix.
                   Moved various IPv4/6 conversion functions here from OverbyteIcsWSocket
                     so they can be used without sockets.
                   IcsBuiltWith reports new versions of Delphi 12.
                   Moved IcsSimpleLogging here from Blacklist.
                   Moved IcsParseEmail here from SmtpProt.
                   Moved many literals to Types.
Jan 06, 2025 V9.4  Finished cleanup of old Base64 functions, by added new IcsBase64
                     functions using TBytes internally to replace old Base64 functions
                     that used AnsiChars, no overloaded versions for simplicity.
                     Old Base64 versions retained as deprecated for user applications,
                     please update to the IcsBase versions.
                   Added IcsTBytesCompare to compare two TBytes.
                   Added IcsOutputDebugStr for Posix and Windows, from Logger.
                   Added IcsDateToAStr and IcsDateTimeToAStr with alpha month (Jan/Feb).
Aug 14, 2025 V9.5  Added MaskIpAddr to mask an ASCII IP address,
                     ie 192.168.1.222/255.255.255.0 gives 192.168.1.0.
                   Added IcsHexToTB, skips : separators.
                   Added IcsLinesToDynArray to convert multiple lines of text into
                     multiple strings, one per line.
                   Updated IcsBuiltWith for Delphi 13 and 14 (future).
                   Added IcsReverseIPArpa to convert daddress to reverse DNS lookup
                     arpa domain name, no period on end.
                   Added IcsIntToKbyte, better name for IntToKbyte.
                   Added WSocketFamilyFromAF find TSocketFamily from Windows APIs.
                   Moved IcsInitializeAddr and IcsSizeOfAddr here from WSocket.
                   Added IcsInitializeIpv6 to clear an TIcsIPv6Address.
                   Added WSocketIPv6ToSocAddr convert binary IPv6 into SocAddr.
                   Added IcsIPv4AddrFromSocAddr get binary IPv4 from SocAddr.
                   Added IcsIPv6AddrFromSocAddr get binary IPv6 from SocAddr.
                   Added IcsFamilyFromSocAddr get Socket Family from SocAddr.
                   Added WSocketIPStrToSocAddr convert ASCII IP address and port into SocAddr.
                   Added IcsIpBytes convert an IPv4/v6 SocAddr into TTcsIpBytes, 4 or 16 byte TBytes.
                   Added IcsIpBytesToStr to convert TcsIpBytes into string IPv4/v6 address.
                   Try to stop a range error in IcsGetUAgeSizeFile.
                   Added IcsCompareTBytes to compare two binary TByes, used by sorting functions.



IcsSimpleLogging is a non-buffered log file function which writes text
to the end of old or new file, opening and closing file for each line,
ignoring any errors, not designed for continual updating!  The file name
is in date/time mask format, typically for one log file per day.

 * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsUtils;

interface

{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$X+}           { Enable extended syntax              }
{$H+}           { Use long strings                    }
{$J+}           { Allow typed constant to be modified }
{$R-}           { no range checking, otherwise DWORD=Integer fails with some Windows APIs }
{$I Include\OverbyteIcsDefs.inc}
{$IFDEF COMPILER14_UP}
  {$IFDEF NO_EXTENDED_RTTI}
    {$RTTI EXPLICIT METHODS([]) FIELDS([]) PROPERTIES([])}
  {$ENDIF}
{$ENDIF}
{$IFDEF COMPILER12_UP}
    {$WARN IMPLICIT_STRING_CAST       OFF}
    {$WARN IMPLICIT_STRING_CAST_LOSS  OFF}
    {$WARN EXPLICIT_STRING_CAST       OFF}
    {$WARN EXPLICIT_STRING_CAST_LOSS  OFF}
{$ENDIF}
{$WARN SYMBOL_PLATFORM   OFF}
{$WARN SYMBOL_LIBRARY    OFF}
{$WARN SYMBOL_DEPRECATED OFF}
{$IFDEF BCB}
  {$ObjExportAll On}
{$ENDIF}
{ V8.65 MacOS64 and Linux does not support inline assembler }
{$IFDEF POSIX}
    {$DEFINE PUREPASCAL}
{$ENDIF}
{$IFDEF ANDROID}
    {$UNDEF USE_ICONV}       { V9.1 }
{$ENDIF}

uses
{$IFDEF MSWINDOWS}
    {$IFDEF RTL_NAMESPACES}Winapi.Windows{$ELSE}Windows{$ENDIF},
    OverbyteIcsWinnls,
    {$IFDEF Rtl_Namespaces}System.Win.Registry{$ELSE}Registry{$ENDIF},   { V9.4 }
{$ENDIF}
{$IFDEF POSIX}
    Posix.SysTypes,
    Posix.Iconv,
    Posix.Errno,
    Posix.Unistd,
    Posix.Stdio,
    Posix.SysStatvfs,
    Posix.PThread,
    Posix.Time,
    Posix.NetDB,         { V9.3 for PAddrInfo }
    Ics.Posix.WinTypes,
  {$IFDEF MACOS}
    Macapi.CoreFoundation,
    MacApi.CoreServices,
  {$ENDIF}
{$ENDIF}
    {$IFDEF RTL_NAMESPACES}System.Classes{$ELSE}Classes{$ENDIF},
    {$IFDEF RTL_NAMESPACES}System.SysUtils{$ELSE}SysUtils{$ENDIF},
    {$IFDEF RTL_NAMESPACES}System.RtlConsts{$ELSE}RtlConsts{$ENDIF},
    {$IFDEF RTL_NAMESPACES}System.SysConst{$ELSE}SysConst{$ENDIF},
    {$IFDEF RTL_NAMESPACES}System.TypInfo{$ELSE}TypInfo{$ENDIF},
    {$IFDEF Rtl_Namespaces}System.DateUtils{$ELSE}DateUtils{$ENDIF},  { V8.60 }
    {$IFDEF Rtl_Namespaces}System.Types{$ELSE}Types{$ENDIF},          { V9.1 }
{$IFDEF COMPILER16_UP}
//    System.Generics.Collections,                                   { V9.1 }
    System.SyncObjs,
    System.IOUtils,    { V8.64 }
    {$IFDEF Rtl_Namespaces}System.TimeSpan{$ELSE}TimeSpan{$ENDIF},    { V9.1 }
{$ENDIF}
{$IFDEF COMPILER12_UP}
    {$IFDEF RTL_NAMESPACES}System.AnsiStrings{$ELSE}AnsiStrings{$ENDIF},
{$ENDIF}
{$IFNDEF COMPILER17_UP}
    StrUtils,   { V8.65 not needed for XE3 and later }
{$ENDIF}
    OverbyteIcsMD5,
    OverbyteIcsTypes; // common types

type
{$IFNDEF COMPILER12_UP}
  (*$HPPEMIT 'namespace System' *)
  (*$HPPEMIT '{' *)
  (*$HPPEMIT '  typedef __int64* PInt64;' *)
  (*$HPPEMIT '}' *)
{$ENDIF}

{$IFNDEF COMPILER15_UP}
    PLongBool     =  ^LongBool;
{$ENDIF}
    TIcsDbcsLeadBytes = TSysCharset;

const
    { From Win 7 GetCPInfoEx() DBCS lead bytes }
    ICS_LEAD_BYTES_932   : TIcsDbcsLeadBytes = [#$81..#$9F, #$E0..#$FC];              // (ANSI/OEM - Japanese Shift-JIS) DBCS Lead Bytes: 81..9F E0..FC
    ICS_LEAD_BYTES_936_949_950 : TIcsDbcsLeadBytes = [#$81..#$FE];                    // (ANSI/OEM - Simplified Chinese GBK) DBCS Lead Bytes: 81..FE
    //ICS_LEAD_BYTES_949   = LEAD_BYTES_936;                                          // (ANSI/OEM - Korean) DBCS Lead Bytes: 81..FE
    //ICS_LEAD_BYTES_950   = LEAD_BYTES_936;                                          // (ANSI/OEM - Traditional Chinese Big5) DBCS Lead Bytes: 81..FE
    ICS_LEAD_BYTES_1361  : TIcsDbcsLeadBytes = [#$84..#$D3, #$D8..#$DE, #$E0..#$F9];  // (Korean - Johab) DBCS Lead Bytes: 84..D3 D8..DE E0..F9
    ICS_LEAD_BYTES_10001 : TIcsDbcsLeadBytes = [#$81..#$9F, #$E0..#$FC];              // (MAC - Japanese) DBCS Lead Bytes: 81..9F E0..FC
    ICS_LEAD_BYTES_10002 : TIcsDbcsLeadBytes = [#$81..#$FC];                          // (MAC - Traditional Chinese Big5) DBCS Lead Bytes: 81..FC
    ICS_LEAD_BYTES_10003 : TIcsDbcsLeadBytes = [#$A1..#$AC, #$B0..#$C8, #$CA..#$FD];  // (MAC - Korean) DBCS Lead Bytes: A1..AC B0..C8 CA..FD
    ICS_LEAD_BYTES_10008 : TIcsDbcsLeadBytes = [#$A1..#$A9, #$B0..#$F7];              // (MAC - Simplified Chinese GB 2312) DBCS Lead Bytes: A1..A9 B0..F7
    ICS_LEAD_BYTES_20000 : TIcsDbcsLeadBytes = [#$A1..#$FE];                          // (CNS - Taiwan) DBCS Lead Bytes: A1..FE
    ICS_LEAD_BYTES_20001 : TIcsDbcsLeadBytes = [#$81..#$84, #$91..#$D8, #$DF..#$FC];  // (TCA - Taiwan) DBCS Lead Bytes: 81..84 91..D8 DF..FC
    ICS_LEAD_BYTES_20002 : TIcsDbcsLeadBytes = [#$81..#$AF, #$DD..#$FE];              // (Eten - Taiwan) DBCS Lead Bytes: 81..AF DD..FE
    ICS_LEAD_BYTES_20003 : TIcsDbcsLeadBytes = [#$81..#$84, #$87..#$87, #$89..#$E8, #$F9..#$FB]; // (IBM5550 - Taiwan) DBCS Lead Bytes: 81..84 87..87 89..E8 F9..FB
    ICS_LEAD_BYTES_20004 : TIcsDbcsLeadBytes = [#$A1..#$FE];                          // (TeleText - Taiwan) DBCS Lead Bytes: A1..FE
    ICS_LEAD_BYTES_20005 : TIcsDbcsLeadBytes = [#$8D..#$F5, #$F9..#$FC];              // (Wang - Taiwan) DBCS Lead Bytes: 8D..F5 F9..FC
    ICS_LEAD_BYTES_20261 : TIcsDbcsLeadBytes = [#$C1..#$CF];                          // (T.61) DBCS Lead Bytes: C1..CF
    ICS_LEAD_BYTES_20932 : TIcsDbcsLeadBytes = [#$8E..#$8E, #$A1..#$FE];              // (JIS X 0208-1990 & 0212-1990) DBCS Lead Bytes: 8E..8E A1..FE
    ICS_LEAD_BYTES_20936 : TIcsDbcsLeadBytes = [#$A1..#$A9, #$B0..#$F7];              // (Simplified Chinese GB2312) DBCS Lead Bytes: A1..A9 B0..F7
    ICS_LEAD_BYTES_51949 : TIcsDbcsLeadBytes = [#$A1..#$AC, #$B0..#$C8, #$CA..#$FD];  // (EUC-Korean) DBCS Lead Bytes: A1..AC B0..C8 CA..FD

{$IFDEF MSWINDOWS}
  {$IFNDEF COMPILER12_UP}
    {$EXTERNALSYM MB_ERR_INVALID_CHARS}
    MB_ERR_INVALID_CHARS            = $00000008;  // Missing in Windows.pas
    {$IFDEF COMPILER11_UP} {$EXTERNALSYM WC_ERR_INVALID_CHARS} {$ENDIF}
    WC_ERR_INVALID_CHARS            = $80;        // Missing in Windows.pas
  {$ENDIF}
{$ENDIF}
    { Unicode code page ID }
    CP_UTF16      = 1200;
    CP_UTF16Be    = 1201;
    CP_UTF32      = 12000;
    CP_UTF32Be    = 12001;

(* moved to OverbyteIcsTypes
{ V8.52 some useful string constants, make sure names are unique }
const
  IcsNULL            =  #0;
  IcsSTX             =  #2;
  IcsETX             =  #3;
  IcsEOT             =  #4;
  IcsBACKSPACE       =  #8;
  IcsTAB             =  #9;
  IcsLF              = #10;
  IcsFF              = #12;
  IcsCR              = #13;
  IcsEOF             = #26;
  IcsESC             = #27;
  IcsFIELDSEP        = #28;
  IcsRECSEP          = #30;
  IcsBLANK           = #32;
  IcsSQUOTE          = #39 ;
  IcsDQUOTE          = #34 ;
  IcsSPACE           = #32;
  IcsHEX_PREFIX      = '$';     { prefix for hexnumbers }
  IcsCRLF            = #13#10;
  IcsDoubleCRLF      = #13#10#13#10;
  IcsCOLON           = ':';     { V8.65 }
  IcsCOMMA           = ',';     { V8.65 }
  IcsCURLYO          = '{';     { V8.65 }
  IcsCURLYC          = '}';     { V8.65 }
  IcsAmpersand       = '&';     { V8.65 }

{ V8.70 a few byte constants, for use with TBytes }
  IcsbNULL            =  0;
  IcsbSTX             =  2;
  IcsbETX             =  3;
  IcsbEOT             =  4;
  IcsbBACKSPACE       =  8;
  IcsbTAB             =  9;
  IcsbLF              = 10;
  IcsbFF              = 12;
  IcsbCR              = 13;
  IcsbEOF             = 26;
  IcsbESC             = 27;
  IcsbFIELDSEP        = 28;
  IcsbRECSEP          = 30;
  IcsbBLANK           = 32;
  IcsbSQUOTE          = 39 ;
  IcsbDQUOTE          = 34 ;
  IcsbSPACE           = 32;

  { V8.54 Tick and Trigger constants }
  TicksPerDay      : longword =  24 * 60 * 60 * 1000 ;
  TicksPerHour     : longword = 60 * 60 * 1000 ;
  TicksPerMinute   : longword = 60 * 1000 ;
  TicksPerSecond   : longword = 1000 ;
  TriggerDisabled  : longword = $FFFFFFFF ;
  TriggerImmediate : longword = 0 ;
  OneSecondDT: TDateTime = 1 / SecsPerDay ;         { V8.60 }
  OneMinuteDT: TDateTime = 1 / (SecsPerDay / 60) ;  { V8.60 }
  MinutesPerDay      = 60.0 * 24.0;                 { V8.62 }

  { V8.60 date and time masks }
  ISOTimeMask = 'hh:nn:ss' ;
  ISOLongTimeMask = 'hh:nn:ss:zzz' ;
  ISODateMask = 'yyyy-mm-dd' ;
  ISODateTimeMask = 'yyyy-mm-dd"T"hh:nn:ss' ;
  ISODateLongTimeMask = 'yyyy-mm-dd"T"hh:nn:ss.zzz' ;

  { V8.64 International Domain Name support }
  ACE_PREFIX = 'xn--';

 { V8.67 common computer sizes }
  IcsKBYTE = Sizeof(Byte) shl 10;
  IcsMBYTE = IcsKBYTE shl 10;
  IcsGBYTE = IcsMBYTE shl 10;

  { V8.70 file system extended path names, if file system supports them, unicode APIs only }
  sPathExtended = '\\?\';         { \\?\d:\filepath }
  sPathExtendedUNC = '\\?\UNC\';  { \\?\UNC\server\share\filepath }
  IcsMaxPath = 260;
*)

var
  IcsFormatSettings: TFormatSettings;  { V8.60 }

type
    EIcsStringConvertError = class(Exception);
    TCharsetDetectResult = (cdrAscii, cdrUtf8, cdrUnknown);

    TIcsNormForm = (
      icsNormalizationOther,
      icsNormalizationC,
      icsNormalizationD,
      icsNormalizationKC = 5,
      icsNormalizationKD);

{$IFDEF COMPILER12_UP}
    TIcsSearchRecW = {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.TSearchRec;
{$ELSE}
    TIcsSearchRecW = record
        Time        : Integer;
        Size        : Integer;
        Attr        : Integer;
        Name        : UnicodeString;
        ExcludeAttr : Integer;
        FindHandle  : THandle;
        FindData    : TWin32FindDataW;
    end;
{$ENDIF}

{$IFDEF MSWINDOWS}
    TUnicode_String = record
        Length        : Word;
        MaximumLength : Word;
        Buffer        : PWideChar;
    end;
    PUnicode_String = ^TUnicode_String;

    TRtlCompareUnicodeString = function(String1, String2: PUnicode_String; CaseInSensitive: Boolean): Integer; stdcall;
{$ENDIF}

{$IFNDEF UNICODE}     { V9.1 not needed for unicode compilers }
{$IFNDEF COMPILER12_UP}
    TIcsFileStreamW = class(THandleStream)
{$ELSE}
    TIcsFileStreamW = class(TFileStream)
{$ENDIF}
    private
        FFileName: UnicodeString;
    public
        constructor Create(const FileName: UnicodeString; Mode: Word); overload;
        constructor Create(const FileName: UnicodeString; Mode: Word; Rights: Cardinal); overload;
        constructor Create(const Utf8FileName: UTF8String; Mode: Word); overload;
        constructor Create(const Utf8FileName: UTF8String; Mode: Word; Rights: Cardinal); overload;
        destructor  Destroy; override;
        property    FileName: UnicodeString read FFileName;
    end;
{$ENDIF UNICODE}


    function  IcsIsValidAnsiCodePage(const CP: LongWord): Boolean;
{$IFDEF POSIX}              { V8.71 was USE_ICONV }
const
    ICONV_UNICODE     = 'UTF-16LE';
    function IcsIconvNameFromCodePage(CodePage: LongWord): AnsiString;
{$ENDIF}
    procedure IcsCharLowerA(var ACh: AnsiChar); {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsGetCurrentThreadID: TThreadID;
    function  IcsGetFreeDiskSpace(const APath: String): Int64;
    function  IcsGetLocalTimeZoneBias: Integer;  { V8.65 }
    function  IcsGetLocalTZBiasStr: String;                   { V8.62 }
    function  IcsDateTimeToUTC (dtDT: TDateTime): TDateTime;
    function  IcsUTCToDateTime (dtDT: TDateTime): TDateTime;
    function  RFC1123_Date(aDate : TDateTime; AddTZ: Boolean = False) : String;      { V8.09, V8.62 AddTZ }
    function  RFC1123_UtcDate(aDate : TDateTime) : String;    { V8.62 }
    function  RFC1123_StrToDate(aDate : String; UseTZ: Boolean = False) : TDateTime;  { V8.09, V8.62 UseTZ }
    function  RFC3339_StrToDate(aDate: String; UseTZ: Boolean = False): TDateTime; { aka ISO 8601 date } { V8.53, V8.62 UseTZ }
    function  RFC3339_DateToStr(DT: TDateTime; AddTZ: Boolean = False): String;    { aka ISO 8601 date } { V8.53, V8.62 AddTZ }
    function  RFC3339_DateToUtcStr(DT: TDateTime): String;   { aka ISO 8601 date }  { V8.62 }
    function  IcsDateToAStr(const DateTime: TDateTime): string;                   { V9.4 }
    function  IcsDateTimeToAStr(const DateTime: TDateTime): string;               { V9.4 }
    function  IcsGetUTCTime: TDateTime;                       { V8.60 }
    function  IcsSetUTCTime (DateTime: TDateTime): boolean ;  { V8.60 }
    function  IcsGetNewTime (DateTime, Difference: TDateTime): TDateTime ; { V8.60 }
    function  IcsChangeSystemTime (Difference: TDateTime): boolean ;       { V8.60 }
    function  IcsGetUnixTime: Int64;                          { V8.60 }
    function  IcsWcToMb(CodePage: LongWord; Flags: Cardinal;
                        WStr: PWideChar; WStrLen: Integer; MbStr: PAnsiChar;
                        MbStrLen: Integer; DefaultChar: PAnsiChar;
                        UsedDefaultChar: PLongBool): Integer;
    function  IcsMbToWc(CodePage: LongWord; Flags: Cardinal;
                        MbStr: PAnsiChar; MbStrLen: Integer; WStr: PWideChar;
                        WStrLen: Integer): Integer;
    function  IcsGetDefaultWindowsUnicodeChar(CodePage: LongWord): WideChar; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsGetDefaultWindowsAnsiChar(CodePage: LongWord): AnsiChar; {$IFDEF USE_INLINE} inline; {$ENDIF}
    procedure IcsGetAcp(var CodePage: LongWord);
    function  IcsIsDBCSCodePage(CodePage: LongWord): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsIsDBCSLeadByte(Ch: AnsiChar; CodePage: LongWord): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsIsMBCSCodePage(CodePage: LongWord): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsIsSBCSCodePage(CodePage: LongWord): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsGetLeadBytes(CodePage: LongWord): TIcsDbcsLeadBytes; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  UnicodeToUsAscii(const Str: UnicodeString; FailCh: AnsiChar): AnsiString; overload;
    function  UnicodeToUsAscii(const Str: UnicodeString): AnsiString; overload;
    function  UsAsciiToUnicode(const Str: RawByteString; FailCh: AnsiChar): UnicodeString; overload;
    function  UsAsciiToUnicode(const Str: RawByteString): UnicodeString; overload;
    function  UnicodeToAnsi(const Str: PWideChar; ACodePage: LongWord; SetCodePage: Boolean = False): RawByteString; overload;
    function  UnicodeToAnsi(const Str: UnicodeString; ACodePage: LongWord; SetCodePage: Boolean = False): RawByteString; overload;
    function  UnicodeToAnsi(const Str: UnicodeString): RawByteString; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  AnsiToUnicode(const Str: PAnsiChar; ACodePage: LongWord): UnicodeString; overload;
    function  AnsiToUnicode(const Str: RawByteString; ACodePage: LongWord): UnicodeString; overload;
    function  AnsiToUnicode(const Str: RawByteString): UnicodeString; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  AnsiToUnicode(const Buffer; BufferSize: Integer; ACodePage: LongWord): UnicodeString; overload;  { V8.67 }
    { Returns a UnicodeString and the number of not translated bytes at the end of the source buffer }
    { BufferCodePage includes Ansi as well as Unicode code page IDs }
    function  IcsBufferToUnicode(const Buffer; BufferSize: Integer; BufferCodePage: LongWord; out FailedByteCount: Integer): UnicodeString; overload;
    { Returns a UnicodeString and optionally raises an exception if there are any number of not translated bytes at the end of the source buffer }
    { BufferCodePage includes Ansi as well as Unicode code page IDs }
    function  IcsBufferToUnicode(const Buffer; BufferSize: Integer; BufferCodePage: LongWord; RaiseFailedBytes: Boolean = FALSE): UnicodeString; overload;
    { Returns the number of WideChars, and the number of not translated bytes at the end of the source buffer }
    { BufferCodePage includes Ansi as well as Unicode code page IDs }
    function  IcsGetWideCharCount(const Buffer; BufferSize: Integer; BufferCodePage: LongWord; out InvalidEndByteCount: Integer): Integer;
    { Returns a Unicode string, ByteCount and CharCount must match, no length checks are done }
    { BufferCodePage includes Ansi as well as Unicode code page IDs }
    function  IcsGetWideChars(const Buffer; BufferSize: Integer; BufferCodePage: LongWord; Chars: PWideChar; CharCount: Integer): Integer;
    function  StreamWriteString(AStream: TStream; Str: PWideChar; cLen: Integer; ACodePage: LongWord; WriteBOM: Boolean): Integer; overload;
    function  StreamWriteString(AStream: TStream; Str: PWideChar; cLen: Integer; ACodePage: LongWord): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  StreamWriteString(AStream: TStream; const Str: UnicodeString; ACodePage: LongWord; WriteBOM: Boolean): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  StreamWriteString(AStream: TStream; const Str: UnicodeString; ACodePage: LongWord): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  StreamWriteString(AStream: TStream; const Str: UnicodeString): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsUsAscii(const Str: RawByteString): Boolean; overload;
    function  IsUsAscii(const Str: UnicodeString): Boolean; overload;
    procedure IcsAppendStr(var Dest: RawByteString; const Src: RawByteString);
    function  atoi(const Str: RawByteString): Integer; overload;
    function  atoi(const Str: UnicodeString): Integer; overload;
{$IFDEF STREAM64}
    function  atoi64(const Str: RawByteString): Int64; overload;
    function  atoi64(const Str: UnicodeString): Int64; overload;
{$ENDIF}
    function  StringToUtf8(const Str: UnicodeString): RawByteString; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  StringToUtf8(const Str: RawByteString; ACodePage: LongWord = CP_ACP): RawByteString; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  StringToUtf8TB(const Str: UnicodeString): TBytes; {$IFDEF USE_INLINE} inline; {$ENDIF}                       { V8.71 }
    function  Utf8ToStringW(const Str: RawByteString): UnicodeString; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  Utf8ToStringA(const Str: RawByteString; ACodePage: LongWord = CP_ACP): AnsiString; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  Utf8ToStringTB(const Str: TBytes): UnicodeString; {$IFDEF USE_INLINE} inline; {$ENDIF}              { V9.1 }
    function  CheckUnicodeToAnsi(const Str: UnicodeString; ACodePage: LongWord = CP_ACP): Boolean;
    { This is a weak check, it does not detect whether it's a valid UTF-8 byte }
    function  IsUtf8TrailByte(const B: Byte): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IsUtf8LeadByte(const B: Byte): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsUtf8Size(const LeadByte: Byte): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF}
{$IFNDEF COMPILER12_UP}
    function  IsLeadChar(Ch: WideChar): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
{$ENDIF}
    function  IsUtf8Valid(const Str: RawByteString): Boolean; overload; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IsUtf8Valid(const Buf: Pointer; Len: Integer): Boolean; overload; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  CharsetDetect(const Buf: Pointer; Len: Integer): TCharsetDetectResult; overload;
    function  CharsetDetect(const Str: RawByteString): TCharsetDetectResult; overload; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsCharNextUtf8(const Str: PAnsiChar): PAnsiChar; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  IcsCharPrevUtf8(const Start, Current: PAnsiChar): PAnsiChar; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  ConvertCodepage(const Str: RawByteString; SrcCodePage: LongWord; DstCodePage: LongWord = CP_ACP): RawByteString;
    function  GetBomFromCodePage(ACodePage: LongWord) : TBytes;  { V8.60 }
    function  htoin(Value : PWideChar; Len : Integer) : Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  htoin(Value : PAnsiChar; Len : Integer) : Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  htoi2(value : PWideChar): Integer; overload;
    function  htoi2(value : PAnsiChar): Integer; overload;
    function  IcsBufferToHex(const Buf; Size: Integer): String; overload;
    function  IcsBufferToHex(const Buf; Size: Integer; Separator: Char): String; overload;
    function  IcsBufferToHex(const BufStr: AnsiString): String; overload;    { V8.53 }
    function  IcsTBToHex(const BufTB: TBytes): String; overload;             { V9.1 }
    function  IcsHexToBin(const HexBuf: AnsiString): AnsiString;             { V8.53 }
    function IcsHexToTB(const HexBuf: AnsiString): TBytes;                   { V9.5 }
    function  IcsFormatHexStr(const HexStr: String; GroupLen: Integer = 8; LineLen: Integer = 64): String;     { V9.1 }
    function  IsXDigit(Ch : WideChar): Boolean; overload;
    function  IsXDigit(Ch : AnsiChar): Boolean; overload;
    function  XDigit(Ch : WideChar): Integer; overload;
    function  XDigit(Ch : AnsiChar): Integer; overload;
    function  IsCharInSysCharSet(Ch : WideChar; const ASet : TSysCharSet) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsCharInSysCharSet(Ch : AnsiChar; const ASet : TSysCharSet) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsDigit(Ch : WideChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsDigit(Ch : AnsiChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsSpace(Ch : WideChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsSpace(Ch : AnsiChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsCRLF(Ch : WideChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsCRLF(Ch : AnsiChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsSpaceOrCRLF(Ch : WideChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsSpaceOrCRLF(Ch : AnsiChar) : Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IsPathSep(Ch : WideChar) : Boolean;{$IFDEF USE_INLINE} inline; {$ENDIF} overload;   { V8.57  }
    function  IsPathSep(Ch : AnsiChar) : Boolean;{$IFDEF USE_INLINE} inline; {$ENDIF} overload;   { V8.57  }
    function  XDigit2(S : PChar) : Integer; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function  stpblk(PValue : PWideChar) : PWideChar; overload;
    function  stpblk(PValue : PAnsiChar) : PAnsiChar; overload;
    { Retrieves the pointer to the next character in a string. This function }
    { can handle strings consisting of either single- or multi-byte          }
    { characters. including UTF-8. The return value is a pointer to the next }
    { character in the string, or to the terminating null character if at    }
    { the end of the string.                                                 }
    function  IcsStrNextChar(const Str: PAnsiChar; ACodePage: LongWord = CP_ACP): PAnsiChar;
    { Retrieves the pointer to the preceding character in a string. This     }
    { function can handle strings consisting of either single- or multi-byte }
    { characters including UTF-8. The return value is a pointer to the       }
    { preceding character in the string, or to the first character in the    }
    { string if the Current parameter equals the Start parameter.            }
    function  IcsStrPrevChar(const Start, Current: PAnsiChar; ACodePage: LongWord = CP_ACP): PAnsiChar;
    function  IcsStrCharLength(const Str: PAnsiChar; ACodePage: LongWord = CP_ACP): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IcsNextCharIndex(const S: RawByteString; Index: Integer; ACodePage: LongWord = CP_ACP): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function  IcsGetBomBytes(ACodePage: LongWord): TBytes;
    function  IcsGetBufferCodepage(Buf: PAnsiChar; ByteCount: Integer): LongWord; overload;
    function  IcsGetBufferCodepage(Buf: PAnsiChar; ByteCount: Integer; out BOMSize: Integer): LongWord; overload;  { V8.07 }
    function  IcsSwap16(Value: Word): Word;
    procedure IcsSwap16Buf(Src, Dst: PWord; WordCount: Integer);
    function  IcsSwap32(Value: LongWord): LongWord;
    procedure IcsSwap32Buf(Src, Dst: PLongWord; LongWordCount: Integer);
    function  IcsSwap64(Value: Int64): Int64;
    procedure IcsSwap64Buf(Src, Dst: PInt64; QuadWordCount: Integer);
    procedure IcsNameThreadForDebugging(AThreadName: AnsiString; AThreadID: TThreadID = TThreadID(-1));
    function  IcsNormalizeString(const S: UnicodeString; NormForm: TIcsNormForm): UnicodeString;
    function IcsCryptGenRandom(var Buf; BufSize: Integer): Boolean;
    function IcsRandomInt(const ARange: Integer): Integer;
    function IcsFileUtcModified(const FileName: String) : TDateTime;
    function IcsInterlockedCompareExchange(var Destination: Pointer;
        Exchange: Pointer; Comperand: Pointer): Pointer;
{ Wide library }
    function IcsFileCreateW(const FileName: UnicodeString): {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; overload;
    function IcsFileCreateW(const Utf8FileName: UTF8String): {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFileCreateW(const FileName: UnicodeString; Rights: LongWord): {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; overload;
    function IcsFileCreateW(const Utf8FileName: UTF8String; Rights: LongWord): {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFileOpenW(const FileName: UnicodeString; Mode: LongWord): {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; overload;
    function IcsFileOpenW(const Utf8FileName: UTF8String; Mode: LongWord): {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsStrScanW(const Str: PWideChar; Ch: WideChar): PWideChar;
    function IcsExtractFilePathW(const FileName: UnicodeString): UnicodeString;
    function IcsExtractFileDirW(const FileName: UnicodeString): UnicodeString;
    function IcsExtractFileDriveW(const FileName: UnicodeString): UnicodeString;
    function IcsExtractFileNameW(const FileName: UnicodeString): UnicodeString;
    function IcsExtractFileExtW(const FileName: UnicodeString): UnicodeString;
    function IcsExpandFileNameW(const FileName: UnicodeString): UnicodeString;
    function IcsExtractNameOnlyW(FileName: UnicodeString): UnicodeString; // angus
    function IcsChangeFileExtW(const FileName, Extension: UnicodeString): UnicodeString;  // angus
    function IcsStrAllocW(Len: Cardinal): PWideChar;
    function IcsStrLenW(Str: PWideChar): Cardinal;
    function IcsAnsiCompareFileNameW(const S1, S2: UnicodeString): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsAnsiCompareFileNameW(const Utf8S1, Utf8S2: UTF8String): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsDirExists(const FileName: String): Boolean;                                  { V8.67 }
    function IcsDirExistsW(const FileName: PWideChar): Boolean; overload;
    function IcsDirExistsW(const FileName: UnicodeString): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsDirExistsW(const Utf8FileName: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFindFirstW(const Path: UnicodeString; Attr: Integer; var F: TIcsSearchRecW): Integer; overload;
    function IcsFindFirstW(const Utf8Path: UTF8String; Attr: Integer; var F: TIcsSearchRecW): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    procedure IcsFindCloseW(var F: TIcsSearchRecW);
    function IcsFindNextW(var F: TIcsSearchRecW): Integer;
    function IcsIncludeTrailingPathDelimiterW(const S: UnicodeString): UnicodeString;
    function IcsExcludeTrailingPathDelimiterW(const S: UnicodeString): UnicodeString;
    function IcsExtractLastDir (const Path: RawByteString): RawByteString ; overload;   // angus
    function IcsExtractLastDir (const Path: UnicodeString): UnicodeString ; overload;   // angus
{$IFDEF MSWINDOWS}
    function IcsFileGetAttrW(const FileName: UnicodeString): Integer; overload;
    function IcsFileGetAttrW(const Utf8FileName: UTF8String): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFileSetAttrW(const FileName: UnicodeString; Attr: Integer): Integer; overload;
    function IcsFileSetAttrW(const Utf8FileName: UTF8String; Attr: Integer): Integer;  {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
{$ENDIF}
    function IcsDeleteFileW(const FileName: UnicodeString): Boolean; overload;
    function IcsDeleteFileW(const Utf8FileName: UTF8String): Boolean; overload;
    function IcsRenameFileW(const OldName, NewName: UnicodeString): Boolean; overload;
    function IcsRenameFileW(const Utf8OldName, Utf8NewName: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsForceDirectoriesW(Dir: UnicodeString): Boolean; overload;
    function IcsForceDirectoriesW(Utf8Dir: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsCreateDirW(const Dir: UnicodeString): Boolean; overload;
    function IcsCreateDirW(const Utf8Dir: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsRemoveDirW(const Dir: UnicodeString): Boolean; overload;
    function IcsRemoveDirW(const Utf8Dir: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFileAgeW(const FileName: UnicodeString): Integer; overload;
    function IcsFileAgeW(const Utf8FileName: UTF8String): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsFileExistsW(const FileName: UnicodeString): Boolean; overload;
    function IcsFileExistsW(const Utf8FileName: UTF8String): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF} overload;
    function IcsGetUAgeSizeFile (const filename: string; var FileUDT: TDateTime;
                                                    var FSize: Int64): boolean;   { V8.49 moved from FtpSrvT }
    function IcsGetFileSize(const FileName : String) : Int64;                     { V8.49 moved from FtpSrvT }
    function IcsGetFileUAge(const FileName : String) : TDateTime;            { V8.51 }
    function IcsAnsiLowerCaseW(const S: UnicodeString): UnicodeString;     // angus
    function IcsAnsiUpperCaseW(const S: UnicodeString): UnicodeString;     // angus
    function IcsMakeLongLong(L, H: LongWord): Int64;                     { V8.65 }
    function IcsMakeWord(L, H: Byte): Word; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function IcsMakeLong(L, H: Word): Integer;  { V8.65 }{$IFDEF USE_INLINE} inline; {$ENDIF}
    function IcsHiWord(LW: LongWord): Word; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function IcsHiByte(W: Word): Byte; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function IcsLoByte(W: Word): Byte; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function IcsLoWord(LW: LongWord): Word; {$IFDEF USE_INLINE} inline; {$ENDIF}
    procedure IcsCheckOSError(ALastError: Integer); {$IFDEF USE_INLINE} inline; {$ENDIF}
    function IcsCheckTrueFalse(const Value: string): boolean;    { V8.47 }
{ we receive socket as single byte raw data into TBytes buffer without a
  character set, then convertit onto Delphi Strings for ease of processing }
{ Beware - this function treats buffers as ANSI, no Unicode conversion }
{$IFDEF UNICODE}
    procedure IcsMoveTBytesToString(const Buffer: TBytes; OffsetFrom: Integer;
                                                var Dest: String; OffsetTo: Integer; Count: Integer); overload; { V8.49 }
{$ENDIF}
    procedure IcsMoveTBytesToString(const Buffer: TBytes; OffsetFrom: Integer;
                                               var Dest: AnsiString; OffsetTo: Integer; Count: Integer); overload; { V9.1 }
{ this function converts buffers to Unicode }
    procedure IcsMoveTBytesToString(const Buffer: TBytes; OffsetFrom: Integer;
        var Dest: UnicodeString; OffsetTo: Integer; Count: Integer; ACodePage: LongWord); overload; { V8.50 }
{ this function converts buffers to Unicode }
    procedure IcsMoveTBytesToString(const Buffer: TBytes; OffsetFrom: Integer;
        var Dest: AnsiString; OffsetTo: Integer; Count: Integer; ACodePage: LongWord); overload; { V8.50 }
    function IcsTBytesToString(const Buffer: TBytes; Count: Integer=0; ACodePage: LongWord = CP_UTF8): UnicodeString;  { V8.71 V9.1 added = 0 }
    function IcsTBytesToStringA(const Buffer: TBytes; Count: Integer= 0): AnsiString;            { V9.1 }
{ Beware - this function treats buffers as ANSI, no Unicode conversion }
{$IFDEF UNICODE}
    function IcsMoveStringToTBytes(const Source: String; var Buffer: TBytes; Count: Integer): Integer; overload;  { V8.50 }
{$ENDIF}
    function IcsMoveStringToTBytes(const Source: AnsiString; var Buffer: TBytes; Count: Integer): integer; overload;  { V8.69 }
    function IcsMoveStringToTBytes(const Source: UnicodeString; var Buffer: TBytes;
                                      Count: Integer; ACodePage: LongWord; Bom: Boolean = false): Integer; overload;  { V8.50 }
    procedure IcsMoveTBytes(var Buffer: TBytes; OffsetFrom: Integer; OffsetTo: Integer;
                                                                  Count: Integer); {$IFDEF USE_INLINE} inline; {$ENDIF}   { V8.49 }
    procedure IcsMoveTBytesEx(const BufferFrom: TBytes; var BufferTo: TBytes;
                                               OffsetFrom, OffsetTo, Count: Integer); {$IFDEF USE_INLINE} inline; {$ENDIF}  { V8.49 }
    function IcsStringToTBytes(const Source: String; ACodePage: LongWord = CP_UTF8): TBytes;   { V9.1 }
    function IcsStringAToTBytes(const Source: AnsiString): TBytes;                             { V9.1 }
{ Pos that ignores nulls in the TBytes buffer, so avoid PAnsiChar functions }
    function IcsTBytesPos(const Substr: String; const S: TBytes; Offset, Count: Integer): Integer;  { V8.49 }
    function IcsTBytesStarts(const Source: TBytes; Find: PAnsiChar) : Boolean;    { V8.49, V8.64 }
    function IcsTBytesContains(const Source : TBytes; Find : PAnsiChar) : Boolean;   { V8.49, V8.64 }
    function IcsTBytesCompare(const Input1, Input2: TBytes): Boolean;                { V9.4 }
    function IcsFmtIpv6Addr (const Addr: string): string;              { V8.52 }
    function IcsFmtIpv6AddrPort (const Addr, Port: string): string;    { V8.52 }
    function IcsStripIpv6Addr (const Addr: string): string;            { V8.52 }
    function IntToKbyte (Value: Int64; Bytes: boolean = false): String; { V8.54  moved here from OverbyteIcsFtpSrvT }
    function IcsIntToKbyte (Value: Int64; Bytes: boolean = false): String; { V9.5 better name for IntToKbyte }
    function IcsWireFmtToStrList(const Buffer: TBytes; Len: Integer; SList: TStrings): Integer;  { V8.57, V8.64 }
    function IcsWireFmtToCSV(const Buffer: TBytes; Len: Integer): String;   { V8.64 }
    function IcsStrListToWireFmt(SList: TStrings; var Buffer: TBytes): Integer;            { V8.57 }
    function IcsEscapeCRLF(const Value: String): String;               { V8.57 }
    function IcsUnEscapeCRLF(const Value: String): String;             { V8.57 }
    function IcsSetToInt(const aSet; const aSize: Integer): Integer;      { V8.57 }
    procedure IcsIntToSet(const Value: Integer; var aSet; const aSize: Integer);    { V8.57 }
    function IcsSetToStr(TypInfo: PTypeInfo; const aSet; const aSize: Integer): string;   { V8.57 }
    procedure IcsStrToSet(TypInfo: PTypeInfo; const Values: String; var aSet; const aSize: Integer);  { V8.57 }
    function IcsExtractNameOnly(const FileName: String): String; { V8.57 }
    function IcsGetExceptMess(ExceptObject: TObject): string;   { V8.59 }
    function IcsAddThouSeps (const S: String): String;          { V8.60 }
    function IcsInt64ToCStr (const N: Int64): String ;          { V8.60 }
    function IcsIntToCStr (const N: Integer): String ;          { V8.60 }
    function IcsDeleteFile(const Fname: string; const ReadOnly: boolean): Integer;   { V8.60 }
    function IcsRenameFile(const OldName, NewName: string; const Replace, ReadOnly: boolean): Integer; overload; { V8.60 }
    function IcsForceDirsEx(const Dir: String): Boolean;  { V8.60 }
    function IcsTransChar(const S: string; FromChar, ToChar: Char): string;  { V8.60 }
    function IcsTransCharW(const S: UnicodeString; FromChar, ToChar: WideChar): UnicodeString;  { V8.60 }
    function IcsPathUnixToDos(const Path: string): string;   { V8.60 }
    function IcsPathDosToUnix(const Path: string): string;   { V8.60 }
    function IcsPathUnixToDosW(const Path: UnicodeString): UnicodeString;   { V8.60 }
    function IcsPathDosToUnixW(const Path: UnicodeString): UnicodeString;   { V8.60 }
    function IcsSecsToStr(Seconds: Integer): String;         { V8.60 }
    function IcsGetTempPath: String;                         { V8.60 }
    function IcsGetCompName: String;                         { V8.57, V9.3 Posix }
    function IcsPunyDecode(const Input: String; var ErrFlag: Boolean): UnicodeString;    { V8.64 }
    function IcsPunyEncode(const Input: UnicodeString; var ErrFlag: Boolean): String;    { V8.64 }
    function IcsPunyToASCII(const Input: UnicodeString; UseSTD3AsciiRules: Boolean; var ErrFlag: Boolean): String; overload;     { V8.64 } { V9.1 added Puny }
    function IcsIDNAToASCII(const Input: UnicodeString; UseSTD3AsciiRules: Boolean; var ErrFlag: Boolean): String; overload; { V8.64 }
    function IcsPunyToASCII(const Input: UnicodeString): String; overload;        { V8.64 } { V9.1 added Puny }
    function IcsIDNAToASCII(const Input: UnicodeString): String; overload;    { V8.64 }
    function IcsPunyToUnicode(const Input: String; var ErrFlag: Boolean): UnicodeString; overload;     { V8.64 }   { V9.1 added Puny }
    function IcsIDNAToUnicode(const Input: String; var ErrFlag: Boolean): UnicodeString; overload; { V8.64 }
    function IcsPunyToUnicode(const Input: String): UnicodeString; overload;      { V8.64 } { V9.1 added Puny }
    function IcsIDNAToUnicode(const Input: String): UnicodeString; overload;  { V8.64 }
    function IcsAnsiPosEx(const SubStr, Str: AnsiString; Offset: Integer = 1): Integer; { V8.65 }
    function IcsPosEx(const SubStr, Str: UnicodeString; Offset: Integer = 1): Integer;  { V8.65 }
    function IcsFileInUse(FileName: String): Boolean;                          { V8.68 }
    function IcsTruncateFile(const FName: String; NewSize: int64): int64;      { V8.68 }
    function IcsAddLongPath(const S: UnicodeString): UnicodeString;            { V8.70 }
    function IcsBuiltWith: String;                                             { V8.70 }
    function IcsBuiltWithEx: String;                                           { V8.70 }
    function IcsTextOnStart( const ATextOnStart, AText : String ): Boolean;      { V8.71 }
    function IcsTextOnStartA( const ATextOnStart, AText : AnsiString ): Boolean; { V8.71 }
{$IFDEF MSWINDOWS}
    function IcsIsProgAdmin: Boolean;                                            { V8.71 }
{$ENDIF}
    function IcsStrRemCntlsA(const S: AnsiString; LeaveCRLF: Boolean = True): String; { V9.1 }
    function IcsStrRemCntls(const S: String; LeaveCRLF: Boolean = True): String;      { V9.1 }
    function IcsStrRemCntlsTB(const TB: TBytes; LeaveCRLF: Boolean = True): String;   { V9.1 }
    function IcsStrBeakup(const S: String; MaxLine: Integer = 132): String;           { V9.1 }
    function IcsTimeToZStr(const DT: TDateTime): string;                              { V9.1 }
    function IcsResourceGetTB(const ResName: String; const ResType: PChar = RT_RCDATA): TBytes;          { V9.1 }
    function IcsResourceSaveFile(const ResName, FileName: String; Replace: Boolean = False): Integer;    { V9.1 }
    function IcsDataSaveFile(const Data: TBytes; const FileName: String; Replace: Boolean = False): Boolean; { V9.1 }
    function IcsDataLoadFile(const FileName: String; MaxLen: Integer = 10240000): TBytes;                    { V9.1 }
    function IcsAbsolutisePath(const Path : String) : String;          { V9.1 moved from HttpSrv }
    function IcsParseEmail(FriendlyEmail: String; var FriendlyName : String) : String;  { V9.3 moved from SmtpProt }
    procedure IcsSimpleLogging (const FNameMask, Msg: String);                          { V9.3 moved from Blacklist }
    procedure IcsOutputDebugStr(const AMsg: String);                                    { V9.4 was in Logger }
    function IcsLinesToDynArray(const Lines: String): TStringDynArray;                 { V9.5 }



 { V8.54 Tick and Trigger functions for timing stuff moved here from OverbyteIcsFtpSrvT   }
 { V8.71 none of these 32-bit tick functions are used in ICS, only 64-bit functions in OverbyteIcsTicks64 }
    function IcsGetTickCount: LongWord;
    function IcsCalcTickDiff(const StartTick, EndTick: LongWord): LongWord; {$IFDEF USE_INLINE} inline; {$ENDIF}
    function IcsGetTickCountX: longword ;
    function IcsDiffTicks (const StartTick, EndTick: longword): longword ;
    function IcsElapsedTicks (const StartTick: longword): longword ;
    function IcsElapsedMsecs (const StartTick: longword): longword ;
    function IcsElapsedSecs (const StartTick: longword): integer ;
    function IcsElapsedMins (const StartTick: longword): integer ;
    function IcsWaitingSecs (const EndTick: longword): integer ;
    function IcsGetTrgMSecs (const MilliSecs: integer): longword ;
    function IcsGetTrgSecs (const DurSecs: integer): longword ;
    function IcsGetTrgMins (const DurMins: integer): longword ;
    function IcsTestTrgTick (const TrgTick: longword): boolean ;
    function IcsAddTrgMsecs (const TickCount, MilliSecs: longword): longword ;
    function IcsAddTrgSecs (const TickCount, DurSecs: integer): longword ;

{ Moved from OverbyteIcsLibrary.pas prefix "_" replaced by "Ics" }
    function IcsIntToStrA(N : Integer): AnsiString;
    function IcsIntToHexA(N : Integer; Digits: Byte) : AnsiString;
    function IcsTrim(const Str : AnsiString) : AnsiString; {$IFDEF COMPILER12_UP} overload;
    function IcsTrim(const Str : UnicodeString) : UnicodeString; overload;
                    {$ENDIF}
    function IcsLowerCase(const S: AnsiString): AnsiString; {$IFDEF COMPILER12_UP} overload;
    function IcsLowerCase(const S: UnicodeString): UnicodeString; overload;
                    {$ENDIF}
    function IcsUpperCase(const S: AnsiString): AnsiString; {$IFDEF COMPILER12_UP} overload;
    function IcsUpperCase(const S: UnicodeString): UnicodeString; overload;
                    {$ENDIF}
    function IcsUpperCaseA(const S: AnsiString): AnsiString;
    function IcsLowerCaseA(const S: AnsiString): AnsiString;
    function IcsCompareTextA(const S1, S2: AnsiString): Integer;
    function IcsTrimA(const Str: AnsiString): AnsiString;
    function IcsSameTextA(const S1, S2: AnsiString): Boolean;
    function IcsCompareStr(const S1, S2: AnsiString): Integer; {$IFDEF COMPILER12_UP} overload;
    function IcsCompareStr(const S1, S2: UnicodeString): Integer; overload;
                    {$ENDIF}
    function IcsCompareText(const S1, S2: AnsiString): Integer;{$IFDEF COMPILER12_UP} overload;
    function IcsCompareText(const S1, S2: UnicodeString): Integer; overload;
                    {$ENDIF}
    function IcsStrLen(const Str: PAnsiChar): Cardinal;
  {$IFDEF COMPILER12_UP} overload;
    function IcsStrLen(const Str: PWideChar): Cardinal; overload;
  {$ENDIF}
    function IcsStrPas(const Str: PAnsiChar): AnsiString;
  {$IFDEF COMPILER12_UP} overload;
    function IcsStrPas(const Str: PWideChar): string; overload;
  {$ENDIF}
    function IcsStrCopy(Dest: PAnsiChar; const Source: PAnsiChar): PAnsiChar;
  {$IFDEF COMPILER12_UP} overload;
    function IcsStrCopy(Dest: PWideChar; const Source: PWideChar): PWideChar; overload;
  {$ENDIF}
    function IcsStrPCopy(Dest: PChar; const Source: string): PChar;
  {$IFDEF COMPILER12_UP} overload;
    function IcsStrPCopy(Dest: PAnsiChar; const Source: AnsiString): PAnsiChar; overload;
  {$ENDIF}
    function IcsStrPLCopy(Dest: PChar; const Source: String; MaxLen: Cardinal): PChar;
  {$IFDEF COMPILER12_UP} overload;
    function IcsStrPLCopy(Dest: PAnsiChar; const Source: AnsiString; MaxLen: Cardinal): PAnsiChar; overload;
  {$ENDIF}
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ end Moved from OverbyteIcsLibrary.pas }

{$IFDEF MSWINDOWS}
    // NT4 and better
    function IcsStrCompOrdinalW(Str1: PWideChar; Str1Length: Integer; Str2: PWideChar; Str2Length: Integer; IgnoreCase: Boolean): Integer;
    function  RtlCompareUnicodeString(String1 : PUNICODE_STRING;
        String2 : PUNICODE_STRING; CaseInsensitive : BOOLEAN): Integer; stdcall;   { V8.65 }
  {$IF CompilerVersion < 21}
    function IsDebuggerPresent: BOOL; stdcall;
    {$EXTERNALSYM IsDebuggerPresent}
 {$IFEND}
{$ENDIF}

type
    TIcsIntegerList = class(TObject)
    private
        FList     : TList;
        function  GetCount: Integer;
        function  GetFirst: Integer;
        function  GetLast: Integer;
        function  GetItem(Index: Integer): Integer;
        procedure SetItem(Index: Integer; const Value: Integer);
    public
        constructor Create; virtual;
        destructor  Destroy; override;
        function    IndexOf(Item: Integer): Integer;
        function    Add(Item: Integer): Integer; virtual;
        procedure   Assign(Source: TIcsIntegerList); virtual;
        procedure   Clear; virtual;
        procedure   Delete(Index: Integer); virtual;
        property    Count: Integer read GetCount;
        property    First: Integer read GetFirst;
        property    Last : Integer read GetLast;
        property    Items[Index: Integer] : Integer read  GetItem
                                                    write SetItem; default;
    end;

    TIcsCriticalSection = class
    protected
        FSection: {$IFDEF MSWINDOWS} TRTLCriticalSection; {$ELSE} pthread_mutex_t; {$ENDIF}
    public
        constructor Create;
        destructor Destroy; override;
        procedure Enter; {$IFDEF USE_INLINE} inline; {$ENDIF}
        procedure Leave; {$IFDEF USE_INLINE} inline; {$ENDIF}
        function TryEnter: Boolean;
    end;

{ V8.38 handle for wintrust.dll }
var
    WinTrustHandle : THandle;

{$IFDEF MSWINDOWS}
{ V8.38 moved from OverbyteIcsSSLEAY }
function IcsGetFileVerInfo(
    const AppName         : String;
    out   FileVersion     : String;
    out   FileDescription : String): Boolean;
{$ENDIF}

{$IFDEF MSWINDOWS}
{ V8.38 constants and records for Wintrust }
{ V8.45 added $EXTERNALSYM to satisfy C++ }
const
  WINTRUST_ACTION_GENERIC_VERIFY_V2: TGUID = '{00AAC56B-CD44-11d0-8CC2-00C04FC295EE}' ;
  {$EXTERNALSYM WINTRUST_ACTION_GENERIC_VERIFY_V2}

  TRUST_E_NOSIGNATURE = HRESULT($800B0100);
  {$EXTERNALSYM TRUST_E_NOSIGNATURE}
  CERT_E_EXPIRED = HRESULT($800B0101);
  {$EXTERNALSYM CERT_E_EXPIRED}
  CERT_E_VALIDITYPERIODNESTING = HRESULT($800B0102);
  {$EXTERNALSYM CERT_E_VALIDITYPERIODNESTING}
  CERT_E_ROLE = HRESULT($800B0103);
   {$EXTERNALSYM CERT_E_ROLE}
  CERT_E_PATHLENCONST = HRESULT($800B0104);
   {$EXTERNALSYM CERT_E_PATHLENCONST}
  CERT_E_CRITICAL = HRESULT($800B0105);
   {$EXTERNALSYM CERT_E_CRITICAL}
  CERT_E_PURPOSE = HRESULT($800B0106);
   {$EXTERNALSYM CERT_E_PURPOSE}
  CERT_E_ISSUERCHAINING = HRESULT($800B0107);
   {$EXTERNALSYM CERT_E_ISSUERCHAINING}
  CERT_E_MALFORMED = HRESULT($800B0108);
   {$EXTERNALSYM CERT_E_MALFORMED}
  CERT_E_UNTRUSTEDROOT = HRESULT($800B0109);
   {$EXTERNALSYM CERT_E_UNTRUSTEDROOT}
  CERT_E_CHAINING = HRESULT($800B010A);
   {$EXTERNALSYM CERT_E_CHAINING}
  TRUST_E_FAIL = HRESULT($800B010B);
   {$EXTERNALSYM TRUST_E_FAIL}
  CERT_E_REVOKED = HRESULT($800B010C);
   {$EXTERNALSYM CERT_E_REVOKED}
  CERT_E_UNTRUSTEDTESTROOT = HRESULT($800B010D);
   {$EXTERNALSYM CERT_E_UNTRUSTEDTESTROOT}
  CERT_E_REVOCATION_FAILURE = HRESULT($800B010E);
   {$EXTERNALSYM CERT_E_REVOCATION_FAILURE}
  CERT_E_CN_NO_MATCH = HRESULT($800B010F);
   {$EXTERNALSYM CERT_E_CN_NO_MATCH}
  CERT_E_WRONG_USAGE = HRESULT($800B0110);
   {$EXTERNALSYM CERT_E_WRONG_USAGE}
  TRUST_E_EXPLICIT_DISTRUST = HRESULT($800B0111);
   {$EXTERNALSYM TRUST_E_EXPLICIT_DISTRUST}
  CERT_E_UNTRUSTEDCA = HRESULT($800B0112);
   {$EXTERNALSYM CERT_E_UNTRUSTEDCA}
  CERT_E_INVALID_POLICY = HRESULT($800B0113);
   {$EXTERNALSYM CERT_E_INVALID_POLICY}
  CERT_E_INVALID_NAME = HRESULT($800B0114);
   {$EXTERNALSYM CERT_E_INVALID_NAME}
  TRUST_E_SYSTEM_ERROR = HRESULT($80096001);
   {$EXTERNALSYM TRUST_E_SYSTEM_ERROR}
  TRUST_E_NO_SIGNER_CERT = HRESULT($80096002);
   {$EXTERNALSYM TRUST_E_NO_SIGNER_CERT}
  TRUST_E_COUNTER_SIGNER = HRESULT($80096003);
   {$EXTERNALSYM TRUST_E_COUNTER_SIGNER}
  TRUST_E_CERT_SIGNATURE = HRESULT($80096004);
   {$EXTERNALSYM TRUST_E_CERT_SIGNATURE}
  TRUST_E_TIME_STAMP = HRESULT($80096005);
   {$EXTERNALSYM TRUST_E_TIME_STAMP}
  TRUST_E_BAD_DIGEST = HRESULT($80096010);
   {$EXTERNALSYM TRUST_E_BAD_DIGEST}
  TRUST_E_BASIC_CONSTRAINTS = HRESULT($80096019);
   {$EXTERNALSYM TRUST_E_BASIC_CONSTRAINTS}
  TRUST_E_FINANCIAL_CRITERIA = HRESULT($8009601E);
   {$EXTERNALSYM TRUST_E_FINANCIAL_CRITERIA}
  CRYPT_E_SECURITY_SETTINGS = HRESULT($80092026);
   {$EXTERNALSYM CRYPT_E_SECURITY_SETTINGS}

  WTCI_DONT_OPEN_STORES = $00000001 ; // only open dummy "root" all other are in pahStores.
   {$EXTERNALSYM WTCI_DONT_OPEN_STORES}
  WTCI_OPEN_ONLY_ROOT = $00000002 ;
   {$EXTERNALSYM WTCI_OPEN_ONLY_ROOT}

// _WINTRUST_DATA.dwUIChoice
    WTD_UI_ALL    = 1 ;
   {$EXTERNALSYM WTD_UI_ALL}
    WTD_UI_NONE   = 2 ;
   {$EXTERNALSYM WTD_UI_NONE}
    WTD_UI_NOBAD  = 3 ;
   {$EXTERNALSYM WTD_UI_NOBAD}
    WTD_UI_NOGOOD = 4 ;
   {$EXTERNALSYM WTD_UI_NOGOOD}

// _WINTRUST_DATA.fdwRevocationChecks
    WTD_REVOKE_NONE       = $00000000 ;
   {$EXTERNALSYM WTD_REVOKE_NONE}
    WTD_REVOKE_WHOLECHAIN = $00000001 ;
   {$EXTERNALSYM WTD_REVOKE_WHOLECHAIN}

// _WINTRUST_DATA.dwUnionChoice
    WTD_CHOICE_FILE    = 1 ;
   {$EXTERNALSYM WTD_CHOICE_FILE}
    WTD_CHOICE_CATALOG = 2 ;
   {$EXTERNALSYM WTD_CHOICE_CATALOG}
    WTD_CHOICE_BLOB    = 3 ;
   {$EXTERNALSYM WTD_CHOICE_BLOB}
    WTD_CHOICE_SIGNER  = 4 ;
   {$EXTERNALSYM WTD_CHOICE_SIGNER}
    WTD_CHOICE_CERT    = 5 ;
   {$EXTERNALSYM WTD_CHOICE_CERT}

// _WINTRUST_DATA.dwStateAction
    WTD_STATEACTION_IGNORE  = $00000000 ;
   {$EXTERNALSYM WTD_STATEACTION_IGNORE}
    WTD_STATEACTION_VERIFY  = $00000001 ;
   {$EXTERNALSYM WTD_STATEACTION_VERIFY}
    WTD_STATEACTION_CLOSE   = $00000002 ;
   {$EXTERNALSYM WTD_STATEACTION_CLOSE}
    WTD_STATEACTION_AUTO_CACHE       = $00000003 ;
   {$EXTERNALSYM WTD_STATEACTION_AUTO_CACHE}
    WTD_STATEACTION_AUTO_CACHE_FLUSH = $00000004 ;
   {$EXTERNALSYM WTD_STATEACTION_AUTO_CACHE_FLUSH}
    WTD_PROV_FLAGS_MASK     = $0000FFFF ;
   {$EXTERNALSYM WTD_PROV_FLAGS_MASK}
    WTD_USE_IE4_TRUST_FLAG  = $00000001 ;
   {$EXTERNALSYM WTD_USE_IE4_TRUST_FLAG}
    WTD_NO_IE4_CHAIN_FLAG   = $00000002 ;
   {$EXTERNALSYM WTD_NO_IE4_CHAIN_FLAG}
    WTD_NO_POLICY_USAGE_FLAG = $00000004 ;
   {$EXTERNALSYM WTD_NO_POLICY_USAGE_FLAG}
    WTD_REVOCATION_CHECK_NONE = $00000010 ;
   {$EXTERNALSYM WTD_REVOCATION_CHECK_NONE}
    WTD_REVOCATION_CHECK_END_CERT = $00000020 ;
   {$EXTERNALSYM WTD_REVOCATION_CHECK_END_CERT}
    WTD_REVOCATION_CHECK_CHAIN    = $00000040 ;
   {$EXTERNALSYM WTD_REVOCATION_CHECK_CHAIN}
    WTD_REVOCATION_CHECK_CHAIN_EXCLUDE_ROOT = $00000080 ;
   {$EXTERNALSYM WTD_REVOCATION_CHECK_CHAIN_EXCLUDE_ROOT}
    WTD_SAFER_FLAG                 = $00000100 ;
   {$EXTERNALSYM WTD_SAFER_FLAG}
    WTD_HASH_ONLY_FLAG             = $00000200 ;
   {$EXTERNALSYM WTD_HASH_ONLY_FLAG}
    WTD_USE_DEFAULT_OSVER_CHECK    = $00000400 ;
   {$EXTERNALSYM WTD_USE_DEFAULT_OSVER_CHECK}
    WTD_LIFETIME_SIGNING_FLAG      = $00000800 ;
   {$EXTERNALSYM WTD_LIFETIME_SIGNING_FLAG}
    WTD_CACHE_ONLY_URL_RETRIEVAL   = $00001000 ; { affects CRL retrieval and AIA retrieval }
   {$EXTERNALSYM WTD_CACHE_ONLY_URL_RETRIEVAL}
    WTD_UICONTEXT_EXECUTE = 0 ;
   {$EXTERNALSYM WTD_UICONTEXT_EXECUTE}
    WTD_UICONTEXT_INSTALL = 1 ;
   {$EXTERNALSYM WTD_UICONTEXT_INSTALL}

type
    PVOID           = Pointer;
   {$EXTERNALSYM PVOID}

  WINTRUST_FILE_INFO_ = record
    cbStruct: DWORD;
    pcwszFilePath: LPCWSTR;
    hFile: THandle;
    pgKnownSubject: PGUID;
  end {WINTRUST_FILE_INFO_};
  TWinTrustFileInfo = WINTRUST_FILE_INFO_ ;
  PWinTrustFileInfo = ^WINTRUST_FILE_INFO_ ;

type
  _WINTRUST_DATA = record
    cbStruct: DWORD;                // = sizeof(WINTRUST_DATA)
    pPolicyCallbackData: PVOID;     // optional: used to pass data between the app and policy
    pSIPClientData: PVOID;          // optional: used to pass data between the app and SIP.
    dwUIChoice: DWORD;              // required: UI choice, one of WTD_UI_xx
    fdwRevocationChecks: DWORD;     // required: certificate revocation check options, one of WTD_REVOKE_xx
    dwUnionChoice: DWORD;           // required: which structure is being passed in, one of WTD_CHOICE_xx
    Info: record {union part of the original struct }
    case integer of
        0: (pFile: PWinTrustFileInfo);           // individual file
  //      1: (pCatalog: PWinTrustCatalogInfo);     // member of a Catalog File
  //      2: (pBlob: PWinTrustBlobInfo);           // memory blob
  //      3: (pSgnr: PWinTrustSgnrInfo);           // signer structure only
  //      4: (pCert: PWinTrustCertInfo);
    end ;
// end union
    dwStateAction: DWORD;       // optional (Catalog File Processing), WTD_STATEACTION_xx
    hWVTStateData: THANDLE;     // optional (Catalog File Processing)
    pwszURLReference: LPCWSTR ; // angus ???  // optional: (future) used to determine zone.
    dwProvFlags: DWORD;         // optional:  WTD_PROV_FLAGS, etc
    dwUIContext: DWORD;         // optional: used to determine action text in UI. WTD_UICONTEXT_xx
  end {_WINTRUST_DATA};
  TWinTrustData = _WINTRUST_DATA ;
  PWinTrustData = ^_WINTRUST_DATA ;

var
  WinVerifyTrust: function(hwnd: HWND; var pgActionID: TGUID;
                                      pWVTData: Pointer): DWORD stdcall ;

{ V8.38 Windows API to check authenticode code signing digital certificate on EXE and DLL files }
  function IcsVerifyTrust (const Fname: string; const HashOnly,
                          Expired: boolean; var Response: string): integer;

var
{ V8.67 copied from OverbyteIcsIniFiles and made general purpose }
    hSHFolderDLL: HMODULE;
    f_SHGetFolderPath: function(hwndOwner: HWND; nFolder: Integer;
        hToken: THandle; dwFlags: DWORD; pszPath: PWideChar): HRESULT; stdcall;
{ returns a shell path according to the CSIDL literals, ie CSIDL_LOCAL_APPDATA }
    function IcsGetShellPath(CSIDL: Integer): UnicodeString;
{$ENDIF}

{ V8.67 Literals for IcsGetShellPath, to get the windows path to specified system shell directories. }
{ V8.68 externals for C++ }
{$EXTERNALSYM CSIDL_DESKTOP}
{$EXTERNALSYM CSIDL_INTERNET}
{$EXTERNALSYM CSIDL_PROGRAMS}
{$EXTERNALSYM CSIDL_CONTROLS}
{$EXTERNALSYM CSIDL_PRINTERS}
{$EXTERNALSYM CSIDL_PERSONAL}
{$EXTERNALSYM CSIDL_FAVORITES}
{$EXTERNALSYM CSIDL_STARTUP}
{$EXTERNALSYM CSIDL_RECENT}
{$EXTERNALSYM CSIDL_SENDTO}
{$EXTERNALSYM CSIDL_BITBUCKET}
{$EXTERNALSYM CSIDL_STARTMENU}
{$EXTERNALSYM CSIDL_MYDOCUMENTS}
{$EXTERNALSYM CSIDL_MYMUSIC}
{$EXTERNALSYM CSIDL_MYVIDEO}
{$EXTERNALSYM CSIDL_DESKTOPDIRECTORY}
{$EXTERNALSYM CSIDL_DRIVES}
{$EXTERNALSYM CSIDL_NETWORK}
{$EXTERNALSYM CSIDL_NETHOOD}
{$EXTERNALSYM CSIDL_FONTS}
{$EXTERNALSYM CSIDL_TEMPLATES}
{$EXTERNALSYM CSIDL_COMMON_STARTMENU}
{$EXTERNALSYM CSIDL_COMMON_PROGRAMS}
{$EXTERNALSYM CSIDL_COMMON_STARTUP}
{$EXTERNALSYM CSIDL_COMMON_DESKTOPDIRECTORY}
{$EXTERNALSYM CSIDL_APPDATA}
{$EXTERNALSYM CSIDL_PRINTHOOD}
{$EXTERNALSYM CSIDL_LOCAL_APPDATA}
{$EXTERNALSYM CSIDL_ALTSTARTUP}
{$EXTERNALSYM CSIDL_COMMON_ALTSTARTUP}
{$EXTERNALSYM CSIDL_COMMON_FAVORITES}
{$EXTERNALSYM CSIDL_INTERNET_CACHE}
{$EXTERNALSYM CSIDL_COOKIES}
{$EXTERNALSYM CSIDL_HISTORY}
{$EXTERNALSYM CSIDL_COMMON_APPDATA}
{$EXTERNALSYM CSIDL_WINDOWS}
{$EXTERNALSYM CSIDL_SYSTEM}
{$EXTERNALSYM CSIDL_PROGRAM_FILES}
{$EXTERNALSYM CSIDL_MYPICTURES}
{$EXTERNALSYM CSIDL_PROFILE}
{$EXTERNALSYM CSIDL_SYSTEMX86}
{$EXTERNALSYM CSIDL_PROGRAM_FILESX86}
{$EXTERNALSYM CSIDL_PROGRAM_FILES_COMMON}
{$EXTERNALSYM CSIDL_PROGRAM_FILES_COMMONX86}
{$EXTERNALSYM CSIDL_COMMON_TEMPLATES}
{$EXTERNALSYM CSIDL_COMMON_DOCUMENTS}
{$EXTERNALSYM CSIDL_COMMON_ADMINTOOLS}
{$EXTERNALSYM CSIDL_ADMINTOOLS}
{$EXTERNALSYM CSIDL_CONNECTIONS}
{$EXTERNALSYM CSIDL_COMMON_MUSIC}
{$EXTERNALSYM CSIDL_COMMON_PICTURES}
{$EXTERNALSYM CSIDL_COMMON_VIDEO}
{$EXTERNALSYM CSIDL_RESOURCES}
{$EXTERNALSYM CSIDL_RESOURCES_LOCALIZED}
{$EXTERNALSYM CSIDL_COMMON_OEM_LINKS}
{$EXTERNALSYM CSIDL_CDBURN_AREA}
{$EXTERNALSYM CSIDL_COMPUTERSNEARME}
{$EXTERNALSYM CSIDL_PLAYLISTS}
{$EXTERNALSYM CSIDL_SAMPLE_MUSIC}
{$EXTERNALSYM CSIDL_SAMPLE_PLAYLISTS}
{$EXTERNALSYM CSIDL_SAMPLE_PICTURES}
{$EXTERNALSYM CSIDL_SAMPLE_VIDEOS}
{$EXTERNALSYM CSIDL_PHOTOALBUMS}

{$EXTERNALSYM CSIDL_FLAG_CREATE}
{$EXTERNALSYM CSIDL_FLAG_DONT_VERIFY}
{$EXTERNALSYM CSIDL_FLAG_NO_ALIAS}
{$EXTERNALSYM CSIDL_FLAG_PER_USER_INIT}
{$EXTERNALSYM CSIDL_FLAG_MASK}

const
    CSIDL_DESKTOP                 = $0000 ;     // <desktop>
    CSIDL_INTERNET                = $0001 ;     // Internet Explorer (icon on desktop)
    CSIDL_PROGRAMS                = $0002 ;     // Start Menu\Programs
    CSIDL_CONTROLS                = $0003 ;     // My Computer\Control Panel
    CSIDL_PRINTERS                = $0004 ;     // My Computer\Printers
    CSIDL_PERSONAL                = $0005 ;     // My Documents
    CSIDL_FAVORITES               = $0006 ;     // <user name>\Favorites
    CSIDL_STARTUP                 = $0007 ;     // Start Menu\Programs\Startup
    CSIDL_RECENT                  = $0008 ;     // <user name>\Recent
    CSIDL_SENDTO                  = $0009 ;     // <user name>\SendTo
    CSIDL_BITBUCKET               = $000a ;     // <desktop>\Recycle Bin
    CSIDL_STARTMENU               = $000b ;     // <user name>\Start Menu
    CSIDL_MYDOCUMENTS             = $000c ;     // the user's My Documents folder
    CSIDL_MYMUSIC                 = $000d ;
    CSIDL_MYVIDEO                 = $000e ;
    CSIDL_DESKTOPDIRECTORY        = $0010 ;     // <user name>\Desktop         16
    CSIDL_DRIVES                  = $0011 ;     // My Computer
    CSIDL_NETWORK                 = $0012 ;     // Network Neighborhood
    CSIDL_NETHOOD                 = $0013 ;     // <user name>\nethood
    CSIDL_FONTS                   = $0014 ;     // windows\fonts               20
    CSIDL_TEMPLATES               = $0015 ;
    CSIDL_COMMON_STARTMENU        = $0016 ;     // All Users\Start Menu
    CSIDL_COMMON_PROGRAMS         = $0017 ;     // All Users\Programs
    CSIDL_COMMON_STARTUP          = $0018 ;     // All Users\Startup           24
    CSIDL_COMMON_DESKTOPDIRECTORY = $0019 ;     // All Users\Desktop
    CSIDL_APPDATA                 = $001a ;     // <user name>\Application Data
    CSIDL_PRINTHOOD               = $001b ;     // <user name>\PrintHood
    CSIDL_LOCAL_APPDATA           = $001C ;     // non roaming, user\Local Settings\Application Data
    CSIDL_ALTSTARTUP              = $001d ;     // non localized startup
    CSIDL_COMMON_ALTSTARTUP       = $001e ;     // non localized common startup 30
    CSIDL_COMMON_FAVORITES        = $001f ;
    CSIDL_INTERNET_CACHE          = $0020 ;
    CSIDL_COOKIES                 = $0021 ;
    CSIDL_HISTORY                 = $0022 ;     //                                34
    CSIDL_COMMON_APPDATA          = $0023 ;     // All Users\Application Data    aka ProgramData
    CSIDL_WINDOWS                 = $0024 ;     // GetWindowsDirectory()
    CSIDL_SYSTEM                  = $0025 ;     // GetSystemDirectory()
    CSIDL_PROGRAM_FILES           = $0026 ;     // C:\Program Files,
    CSIDL_MYPICTURES              = $0027 ;     // My Pictures
    CSIDL_PROFILE                 = $0028 ;     // USERPROFILE
    CSIDL_SYSTEMX86               = $0029 ;     // x86 system directory on RISC
    CSIDL_PROGRAM_FILESX86        = $002a ;     // x86 C:\Program Files on RISC
    CSIDL_PROGRAM_FILES_COMMON    = $002b ;     // C:\Program Files\Common
    CSIDL_PROGRAM_FILES_COMMONX86 = $002c ;     // x86 Program Files\Common on RISC
    CSIDL_COMMON_TEMPLATES        = $002d ;     // All Users\Templates
    CSIDL_COMMON_DOCUMENTS        = $002e ;     // All Users\Documents          46
    CSIDL_COMMON_ADMINTOOLS       = $002f ;     // All Users\Start Menu\Programs\Administrative Tools
    CSIDL_ADMINTOOLS              = $0030 ;     // <user name>\Start Menu\Programs\Administrative Tools  48
    CSIDL_CONNECTIONS             = $0031 ;     // Network and Dial-up Connections - not Win9x           49
    CSIDL_COMMON_MUSIC            = $0035 ;
    CSIDL_COMMON_PICTURES         = $0036 ;
    CSIDL_COMMON_VIDEO            = $0037 ;
    CSIDL_RESOURCES               = $0038 ;
    CSIDL_RESOURCES_LOCALIZED     = $0039 ;
    CSIDL_COMMON_OEM_LINKS        = $003A ;
    CSIDL_CDBURN_AREA             = $003B ;
    CSIDL_COMPUTERSNEARME         = $003D ;
    CSIDL_PLAYLISTS               = $003F ;
    CSIDL_SAMPLE_MUSIC            = $0040 ;
    CSIDL_SAMPLE_PLAYLISTS        = $0041 ;
    CSIDL_SAMPLE_PICTURES         = $0042 ;
    CSIDL_SAMPLE_VIDEOS           = $0043 ;
    CSIDL_PHOTOALBUMS             = $0045 ;
    CSIDL_FLAG_CREATE             = $8000 ;     // combine with CSIDL_ value to force folder creation in SHGetFolderPath()
    CSIDL_FLAG_DONT_VERIFY        = $4000 ;     // combine with CSIDL_ value to return an unverified folder path
    CSIDL_FLAG_NO_ALIAS           = $1000 ;
    CSIDL_FLAG_PER_USER_INIT      = $0800 ;
    CSIDL_FLAG_MASK               = $FF00 ;     // mask for all possible flag values

type
{ V8.60 descendent of TList added a Find function using binary search identical to sorting }
    TIcsFindList = class(TList)
    private
      { Private declarations }
    protected
      { Protected declarations }
    public
      { Public declarations }
      Sorted: boolean ;
      function AddSorted(const Item2: Pointer; Compare: TListSortCompare): Integer; virtual;    { V8.65 result matches Find }
      function Find(const Item2: Pointer; Compare: TListSortCompare;
                                                      var index: Integer): Boolean; virtual;     { V8.65 }
  end;

  function IcsCompareGTMem (P1, P2: Pointer; Length: Integer): Integer ;    { V9.5 added Ics }
  function IcsCompareTBytes(const T1, T2: TBytes): Integer; // 0=equal, >=1 T1 more than T2, <=-1 T1 less than T2  { V9.5 }

{ V8.67 TIcsStringBuild Class moved from OverbyteIcsBlacklist }
type
  TIcsStringBuild = class(TObject)
  private
    FBuffMax: integer;
    FBuffSize: integer;
    FIndex: integer;
    FBuffer: TBytes;
    FCharSize: integer;
    procedure ExpandBuffer;
  public
    constructor Create (ABufferSize: integer = 4096; Wide: Boolean = False) ;
    destructor Destroy; override;
    procedure AppendBuf(const AString: UnicodeString);
    procedure AppendBufA(const AString: AnsiString);         { V8.67 was overload }
    procedure AppendBufW(const AString: UnicodeString);
    procedure AppendLine(const AString: UnicodeString);
    procedure AppendLineA(const AString: AnsiString);        { V8.67 was overload }
    procedure AppendLineW(const AString: UnicodeString);
    procedure Clear ;
    function GetAString: AnsiString;
    function GetWString: UnicodeString;
    function GetString: String;
    procedure Capacity (ABufferSize: integer);
    property Len: integer            read FIndex;
    property Buffer: TBytes          read FBuffer;
    property CharSize: integer       read  FCharSize
                                     write FCharSize;    { V8.67 }
  end;


{ V8.67 moved from OverbyteIcsMimeUtils to ease circular references,
  less CLR versions }
const
 {   Base64Out: array [0..64] of Char = (
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/', '='
    );    }
    Base64OutA: array [0..64] of AnsiChar = (
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/', '='
    );
    Base64In: array[0..127] of Byte = (
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255,  62, 255, 255, 255,  63,  52,  53,  54,  55,
         56,  57,  58,  59,  60,  61, 255, 255, 255,  64, 255, 255, 255,
          0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,
         13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,
        255, 255, 255, 255, 255, 255,  26,  27,  28,  29,  30,  31,  32,
         33,  34,  35,  36,  37,  38,  39,  40,  41,  42,  43,  44,  45,
         46,  47,  48,  49,  50,  51, 255, 255, 255, 255, 255
    );

{ V9.4 Base 64 encoding, old versions working with AnsiChars, ICS does not used any of these
  but retained as deprecated for user applications, please update to the IcsBase versions }
function  Base64Encode(const Input : AnsiString) : AnsiString; overload; deprecated;
function  Base64Encode(const Input : PAnsiChar; Len : Integer) : AnsiString; overload; deprecated;
{$IFDEF COMPILER12_UP}
function  Base64Encode(const Input : UnicodeString; ACodePage: LongWord) : UnicodeString; overload; deprecated;
function  Base64Encode(const Input : UnicodeString) : UnicodeString; overload; deprecated;
{$ENDIF}
function  Base64Decode(const Input : AnsiString) : AnsiString; overload; deprecated;
{$IFDEF COMPILER12_UP}
function  Base64Decode(const Input : UnicodeString; ACodePage: LongWord) : UnicodeString; overload; deprecated;
function  Base64Decode(const Input : UnicodeString) : UnicodeString; overload; deprecated;
{$ENDIF}
function Base64EncodeTB(Input: TBytes) : String; deprecated;                        { V9.1 }
function Base64EncodeA(const Input : AnsiString) : AnsiString; deprecated;          { V9.1 avoid overload confusion }
function Base64DecodeTB(const Input : AnsiString): TBytes; overload; deprecated;    { V9.1 }
{$IFDEF COMPILER12_UP}
function Base64DecodeTB(const Input : UniCodeString): TBytes; overload; deprecated;  { V9.1 }
{$ENDIF}


{ V9.4 Base 64 encoding, new versions working with TBytes }
{ encode binary TBytes into ASCII Base64 Ansistring }
function IcsBase64EncodeTB(const Input: TBytes): AnsiString;       { V9.4 }

{ encode binary AnsiChar pointer buffer with length into ASCII Base64 AnsiString  (replaces old Base64Encode) }
function IcsBase64EncodeAC(const Input: PAnsiChar; Len: Integer): AnsiString;   { V9.4 }

{ encode non binary content String ASCII Base64 String }
function IcsBase64Encode(const Input: String): String;             { V9.4 }

{ encode binary content AnsiString ASCII Base64 Ansistring }
function IcsBase64EncodeA(const Input: AnsiString): AnsiString;    { V9.4 }

{ decode ASCII Base64 in AnsiString to binary TBytes }
function IcsBase64DecodeTB(const Input: AnsiString): TBytes;       { V9.4 }

{ decode ASCII Base64 in AnsiString to binary AnsiString }
function IcsBase64DecodeA(const Input: AnsiString): AnsiString;    { V9.4 }

{ decode ASCII Base64 in String to binary AnsiString }
function IcsBase64Decode(const Input: String): AnsiString;      { V9.4 }

{$IFDEF COMPILER12_UP}
{ decode ASCII Base64 in UnicodeString to UnicodeString with specific CodePage, not binary }
function IcsBase64DecodeU(const Input : UnicodeString; ACodePage: LongWord) : UnicodeString; overload;  { V9.4 }

{ decode ASCII Base64 in UnicodeString to UnicodeString with default CodePage, not binary }
function IcsBase64DecodeU(const Input : UnicodeString) : UnicodeString; overload;    { V9.4 }
{$ENDIF}

{ V8.67 moved from OverbyteIcsSslJose to ease circular references }
function IcsJsonPair(const S1, S2: String): String;

{ RFC4658 base64 decode with trailing == removed, need to add them back  }
function IcsBase64UrlDecode(const Input: String): String;
function IcsBase64UrlDecodeA(const Input: AnsiString): AnsiString;    { V8.67 }
function IcsBase64UrlDecodeTB(const Input: String): TBytes;           { V9.1 }
function IcsBase64UrlDecodeATB(const Input: AnsiString): TBytes;      { V9.1 }

{ RFC4658 base64 encode with trailing == removed and made URL safe, no CRLF allowed either  }
function IcsBase64UrlEncode(const Input: String): String;
function IcsBase64UrlEncodeA(const Input: AnsiString): AnsiString;    { V8.67 }
function IcsBase64UrlEncodeTB(const Input: TBytes): String;           { V9.1 }
function IcsBase64UrlEncodeATB(const Input: TBytes): AnsiString;      { V9.1 }

{ V9.3 moved from OverbyteIcsWSocket, so may be used without sockets }
function  WSocketIsDottedIP(const S : AnsiString) : Boolean; overload;       { V8.70 }
function  WSocketIsDottedIP(const S : UnicodeString) : Boolean; overload;    { V8.70 }
function  WSocketIPv4ToStr(const AIcsIPv4Addr: TIcsIPv4Address): string;
function  WSocketIPv6ToStr(const AIcsIPv6Addr: TIcsIPv6Address): string; overload;
function  WSocketIPv6Same(const IP1, IP2: TIcsIPv6Address): Boolean;          { V8.71 }
function  WSocketStrToIPv4(const S: string; out Success: Boolean): TIcsIPv4Address;
function  WSocketStrToIPv6(const S: string; out Success: Boolean): TIcsIPv6Address; overload;
function  WSocketStrToIPv6(const S: string; out Success : Boolean; out ScopeID : Cardinal): TIcsIPv6Address; overload;
function  WSocketIsIPv4(const S: string): Boolean;
function  WSocketIsIP(const S: string; out ASocketFamily: TSocketFamily): Boolean;
function  WSocketIsIPEx(const S: string; out ASocketFamily: TSocketFamily): Boolean;  { V8.01 }
function  IcsReverseIP(const IP : String) : AnsiString;                       { V8.71 moved from DnsQuery }
function  IcsReverseIPv6(const IPv6: String): AnsiString;                     { V8.71 moved from DnsQuery }
function  IcsReverseIPArpa(const IP: String): AnsiString;                     { V9.5 }
function  IcsSocIpBytes(const ASockAddr: TSockAddrIn6): TTcsIpBytes;          { V9.5 }
function  IcsIpBytesToStr(IpBytes: TTcsIpBytes): String;                      { V9.5 }
function  WSocketIPv6ToStr(const AIn6: PSockAddrIn6): string; overload;
function  WSocketSockAddrToStr(const ASockAddr: TSockAddrIn6): string;        { V8.71 }
function  WSocketIPv4ToSocAddr(IPv4: Integer; Port: Integer = 0): TSockAddrIn6; overload;   { V8.71 }  { V9.5 added port }
function  WSocketIPv4ToSocAddr(IPv4: Cardinal; Port: Integer = 0): TSockAddrIn6; overload;  { V8.71 }  { V9.5 added port }
function  WSocketIPv6ToSocAddr(AIPv6Addr: TIcsIPv6Address; Port: Integer = 0): TSockAddrIn6;              { V9.5 }
function  WSocketIPStrToSocAddr(const S: string; out Success: Boolean; Port: Integer = 0): TSockAddrIn6;  { V9.5 }
function  WSocketFamilyToAF(AFamily: TSocketFamily): Integer;                         { V8.71 }
function  IcsIPv6AddrFromAddrInfo(AddrInfo: PAddrInfo): TIcsIPv6Address;
function  IcsIPv4AddrFromSocAddr(const ASockAddr: TSockAddrIn6): TIcsIPv4Address;     { V9.5 }
function  IcsIPv6AddrFromSocAddr(const ASockAddr: TSockAddrIn6): TIcsIPv6Address;     { V9.5 }
function  IcsFamilyFromSocAddr(const ASockAddr: TSockAddrIn6): TSocketFamily;         { V9.5 }
function  WSocketFamilyFromAF(AFamily: Integer): TSocketFamily;                       { V9.5 }
procedure IcsInitializeAddr(var AAddr: TSockAddrIn6; AIPVersion: TSocketFamily); {$IFDEF USE_INLINE} inline; {$ENDIF} { V9.5 moved from WSocket }
procedure IcsInitializeIpv6(var IPv6: TIcsIPv6Address); { V9.5 }
function  IcsSizeOfAddr(const AAddr: TSockAddrIn6): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} { V9.5 moved from WSocket }
function  IcsMaskIpv4Addr(const IpStr, IpMask: String): String;                      { V9.5 }

function  WSocketErrorDesc(ErrCode: Integer) : String;
function  WSocketProxyErrorDesc(ErrCode : Integer) : String;
function  WSocketIsProxyErrorCode(ErrCode: Integer): Boolean; {$IFDEF USE_INLINE} inline; {$ENDIF}
function  WSocketHttpTunnelErrorDesc(ErrCode : Integer) : String;
function  WSocketSocksErrorDesc(ErrCode : Integer) : String;
function  WSocketErrorMsgFromErrorCode(ErrCode : Integer) : String;
function  WSocketGetErrorMsgFromErrorCode(ErrCode : Integer) : String;
function  GetWinsockErr(ErrCode: Integer) : String;
function  GetWindowsErr(ErrCode: Integer): String;



var
    GSeed32 : LongWord = 0;   { V8.65 moved to top }

implementation

const
    DefaultFailChar : AnsiChar  = '?';
    MAX_UTF8_SIZE       = 4;

    IcsPathDelimW       : WideChar  = {$IFDEF MSWINDOWS} '\'; {$ELSE} '/'; {$ENDIF}
    IcsPathSepW         : WideChar  = {$IFDEF MSWINDOWS} ';'; {$ELSE} ':'; {$ENDIF}
    IcsPathDriveDelimW  : PWideChar = {$IFDEF MSWINDOWS} '\:';{$ELSE} '/'; {$ENDIF}
    IcsPathDelimA       : AnsiChar  = {$IFDEF MSWINDOWS} '\'; {$ELSE} '/'; {$ENDIF}
{$IFDEF MSWINDOWS}
    IcsDriveDelimW      : WideChar  =  ':';
{$ENDIF}

{$IFDEF MSWINDOWS}
var
    hNtDll : THandle = 0;
    _RtlCompareUnicodeString : Pointer = nil;
  {$IF CompilerVersion < 21}
    function IsDebuggerPresent; external kernel32 name 'IsDebuggerPresent';
  {$IFEND}
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetDefaultWindowsUnicodeChar(CodePage: LongWord): WideChar;
begin
    case CodePage of
        932,   // (ANSI/OEM - Japanese Shift-JIS) DBCS Lead Bytes: 81..9F E0..FC UnicodeDefaultChar: 0x30FB
        50220..50222, 51932, { Actually the same as for 932 with both MultiByteToWideChar and MLang.dll.}
        10001, // (MAC - Japanese) DBCS Lead Bytes: 81..9F E0..FC UnicodeDefaultChar: 0x30FB
        20932: // (JIS X 0208-1990 & 0212-1990) DBCS Lead Bytes: 8E..8E A1..FE UnicodeDefaultChar: 0x30FB
            Result := #$30FB;
    else
        if {$IFDEF MSWINDOWS} (Win32MajorVersion >= 6) and {$ENDIF}
           ((CodePage = 65000) or (CodePage = 65001)) then
            Result := #$FFFD
        else
            Result := #$003F;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetDefaultWindowsAnsiChar(CodePage: LongWord): AnsiChar;
begin
    case CodePage of
        37, 500, 875, 1026, 1140, 1141, 1142, 1143, 1144, 1145, 1147, 1149,
        20273, 20277, 20278, 20280, 20284, 20285, 20290, 20297, 20420, 20423,
        20424, 20833, 20838, 20871, 20880, 20905, 20924, 21025, 21027
          : Result := #$6F;
    else
        Result := #$3F;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF POSIX}
 type
    TCpAlias = record
        C : LongWord;
        A : AnsiString;
    end;

const
    { Sorted by CP-ID for binary search, probably some mappings are incorrect }
    IconvCodepageMapping : array [0..44] of TCpAlias = (

    (C : 1200;        A : 'UTF-16LE'),
    (C : 1201;        A : 'UTF-16BE'),

    (C : 10000;       A : 'MAC'),         { MAC Roman; Western European (Mac) }

    (C : 10004;       A : 'MACARABIC'),   { Arabic (Mac) }
    (C : 10005;       A : 'MACHEBREW'),   { Hebrew (Mac) }
    (C : 10006;       A : 'MACGREEK'),    { Greek (Mac) }
    (C : 10007;       A : 'MACCYRILLIC'), { Cyrillic (Mac) }
    (C : 10010;       A : 'MACROMANIA'),  { Romanian (Mac) }
    (C : 10017;       A : 'MACUKRAINE'),  { Ukrainian (Mac) }
    (C : 10021;       A : 'MACTHAI'),     { Thai (Mac) }
    (C : 10029;       A : 'MACCENTRALEUROPE'), { MAC Latin 2; Central European (Mac) }
    (C : 10079;       A : 'MACICELAND'),  { Icelandic (Mac) }
    (C : 10081;       A : 'MACTURKISH'),  { Turkish (Mac) }
    (C : 10082;       A : 'MACCROATIAN'), { Croatian (Mac) }

    (C : 12000;       A : 'UTF-32LE'),
    (C : 12001;       A : 'UTF-32BE'),

    (C : 20127;       A : 'US-ASCII'),
    (C : 20866;       A : 'KOI8-R'),   { Russian (KOI8-R); Cyrillic (KOI8-R) }

    (C : 20932;       A : 'EUC-JP'),   { Japanese (JIS 0208-1990 and 0121-1990) }

    (C : 21866;       A : 'KOI8-U'),   { Ukrainian (KOI8-U); Cyrillic (KOI8-U) }

    (C : 28591;       A : 'iso-8859-1'), { ISO 8859-1 Latin 1; Western European (ISO) }
    (C : 28592;       A : 'iso-8859-2'), { ISO 8859-2 Central European; Central European (ISO) }
    (C : 28593;       A : 'iso-8859-3'), { ISO 8859-3 Latin 3 }
    (C : 28594;       A : 'iso-8859-4'), { ISO 8859-4 Baltic }
    (C : 28595;       A : 'iso-8859-5'), { ISO 8859-5 Cyrillic }
    (C : 28596;       A : 'iso-8859-6'), { ISO 8859-6 Arabic }
    (C : 28597;       A : 'iso-8859-7'), { ISO 8859-7 Greek }
    (C : 28598;       A : 'iso-8859-8'), { ISO 8859-8 Hebrew; Hebrew (ISO-Visual) }
    (C : 28599;       A : 'iso-8859-9'), { ISO 8859-9 Turkish }
    (C : 28603;       A : 'iso-8859-13'), { ISO 8859-13 Estonian }
    (C : 28605;       A : 'iso-8859-15'), { ISO 8859-15 Latin 9 }
    (C : 38598;       A : 'iso-8859-8-i'), { ISO 8859-8 Hebrew; Hebrew (ISO-Logical) }

    (C : 50220;       A : 'iso-2022-jp'), { ? ISO 2022 Japanese with no halfwidth Katakana; Japanese (JIS) }
    (C : 50221;       A : 'iso-2022-jp'), { ? ISO 2022 Japanese with halfwidth Katakana; Japanese (JIS-Allow 1 byte Kana) }
    (C : 50222;       A : 'iso-2022-jp'), { ? ISO 2022 Japanese JIS X 0201-1989; Japanese (JIS-Allow 1 byte Kana - SO/SI) }

    (C : 50225;       A : 'iso-2022-kr'), { ISO 2022 Korean }
    (C : 50227;       A : 'iso-2022-cn'), { ISO 2022 Simplified Chinese; Chinese Simplified (ISO 2022) }
    (C : 50229;       A : 'ISO-2022-CN-EXT'), { ? ISO 2022 Traditional Chinese }

    (C : 51932;       A : 'euc-jp'), { EUC Japanese }
    (C : 51936;       A : 'EUC-CN'), { EUC Simplified Chinese; Chinese Simplified (EUC) }
    (C : 51949;       A : 'euc-kr'), { EUC Korean }

    (C : 52936;       A : 'hz-gb-2312'), { HZ-GB2312 Simplified Chinese; Chinese Simplified (HZ) }
    (C : 54936;       A : 'GB18030'), { Windows XP and later: GB18030 Simplified Chinese (4 byte); Chinese Simplified (GB18030) }

    (C : 65000;       A : 'UTF-7'),
    (C : 65001;       A : 'UTF-8')
    );

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIconvNameFromCodePage(CodePage: LongWord): AnsiString;
var
    L, H, I: Integer;

begin
    if CodePage = CP_ACP then
        IcsGetAcp(CodePage);
    { Quick pre-check }
    if not ((CodePage >= 1250) and (CodePage <= 1258)) then
    begin
        { Binary search ? }
        L := 0;
        H := High(IconvCodepageMapping);
        while L <= H do
        begin
            I := (L + H) shr 1;
            if IconvCodepageMapping[I].C < CodePage then
                L := I + 1
            else begin
                H := I - 1;
                if IconvCodepageMapping[I].C = CodePage then
                begin
                    Result := IconvCodepageMapping[I].A;
                    Exit;
                end;
            end;
        end;
    end;
    Str(CodePage, Result);
    Result := 'CP' + Result;
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIsValidAnsiCodePage(const CP: LongWord): Boolean;
{$IFDEF MSWINDOWS}
begin
    Result := IsValidCodePage(CP);
end;
{$ENDIF}
{$IFDEF POSIX}
var
  Encoding: TEncoding;
  CodePageStr: AnsiString;
  I: Integer;
begin
    Result := (CP <> 1200) and (CP <> 1201) and (CP <> 12000) and (CP <> 12001);
    if Result then
    begin
        // Find the corresponding character encoding for the code page
        for I := Low(IconvCodepageMapping) to High(IconvCodepageMapping) do
        begin
            if IconvCodepageMapping[I].C = CP then
            begin
                CodePageStr := IconvCodepageMapping[I].A;
                Break;
            end;
        end;

        // Try to get the encoding for the code page
        try
            Encoding := TEncoding.GetEncoding(CodePageStr);
            Result := Assigned(Encoding);
        except
            on E: EEncodingError do
                Result := False;
        end;
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsCharLowerA(var ACh: AnsiChar);
begin
    if ACh in [#$41..#$5A] then
        ACh := AnsiChar(Ord(ACh) + 32);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function  IcsGetCurrentThreadID: TThreadID;
begin
  {$IFDEF MSWINDOWS}
    Result := {$IFDEF RTL_NAMESPACES}Winapi.{$ENDIF}Windows.GetCurrentThreadID;
  {$ENDIF}
  {$IFDEF POSIX}
    Result := Posix.PThread.GetCurrentThreadID;
  {$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetTickCount: LongWord;
begin
{$IFDEF MSWINDOWS}
    Result := {$IFDEF RTL_NAMESPACES}Winapi.{$ENDIF}Windows.GetTickCount;
{$ENDIF}
{$IFDEF POSIX}
{$IFDEF MACOS}
    Result := AbsoluteToNanoseconds(UpTime) div 1000000;
{$ELSE}
    Result := System.Classes.TThread.GetTickCount; { V8.65 system.pas provides this for all OS }
{$ENDIF MACOS}
{$ENDIF POSIX}
    if Result = 0 then
        Result := 1;        { V8.71 ensure never zero }
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetFreeDiskSpace(const APath: String): Int64;
{$IFDEF MSWINDOWS}
var
    TotalSpace, FreeSpace : Int64;
begin
    if GetDiskFreeSpaceEx (PChar(APath), FreeSpace, TotalSpace, nil) then
        Result := FreeSpace
    else
        Result := -1;
{$ENDIF}
{$IFDEF POSIX}
{$IFDEF MACOS}
var
    FN  : RawByteString; // Path or file name
    Buf : _statvfs;
begin
    FN := UnicodeToAnsi(APath, CP_UTF8);
    if statvfs(PAnsiChar(FN), Buf) = 0 then
        Result := Int64(Buf.f_bfree) * Int64(Buf.f_frsize)  { V8.65 }
    else
        Result := -1;
{$ELSE}
begin
 //   Result := SysUtils.DiskFree(APath);   // Windows only
      {$MESSAGE 'TODO DiskFree for Android'}
        Result := -1;
{$ENDIF MACOS}
{$ENDIF POSIX}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Get time zone bias a signed integer in minutes }
function IcsGetLocalTimeZoneBias: Integer;  { V8.65 }
{$IFDEF MSWINDOWS}
var
    tzInfo : TTimeZoneInformation;
begin
    case GetTimeZoneInformation(tzInfo) of
        TIME_ZONE_ID_STANDARD: Result := tzInfo.Bias + tzInfo.StandardBias;
        TIME_ZONE_ID_DAYLIGHT: Result := tzInfo.Bias + tzInfo.DaylightBias;
    //    TIME_ZONE_ID_DAYLIGHT: Result := tzInfo.Bias + tzInfo.StandardBias;  // cheating winter
        TIME_ZONE_ID_UNKNOWN : Result := tzInfo.Bias;
    else
        Result := 0; // Error
    end;
end;
{$ENDIF WINDOWS}
{$IFDEF POSIX}
{$IFDEF MACOS}
var
    LTZ: CFTimeZoneRef;
    LNow: CFAbsoluteTime;
    LSecFromUTC: CFTimeInterval;
    LSecInt: Integer;
    // DLSOffs: CFTimeInterval;
begin
    LTZ := CFTimeZoneCopyDefault;
    try
        LNow := CFAbsoluteTimeGetCurrent;
        LSecFromUTC := CFTimeZoneGetSecondsFromGMT(LTZ, LNow); // Includes DaylightSavingTime for me
        {if CFTimeZoneIsDaylightSavingTime(LTZ, LNow) then
        begin
            DLSOffs := CFTimeZoneGetDaylightSavingTimeOffset(LTZ, LNow);
        end;}
        LSecInt := Trunc(LSecFromUTC);
        if LSecInt <> 0 then
            Result := -(LSecInt div 60) // Minutes bias as windows, works for me, ToBeChecked
        else
            Result := 0;
    finally
        CFRelease(LTZ);
    end;
end;
{$ELSE}
var
    TimeZone: TTimeZone;
begin
    TimeZone := TTimeZone.Local;
    Result := -Round(TimeZone.GetUtcOffset(Now).TotalMinutes);
end;
{$ENDIF MACOS}
{$ENDIF POSIX}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.62 Get time zone bias as string, ie -0730 }
function IcsGetLocalTZBiasStr: String;
var
    Bias: Integer;
    Sign: String;
begin
    Bias := IcsGetLocalTimeZoneBias;
    if Bias > 0 then
        Sign := '-'
    else
        Sign := '+';
    Bias := Abs(Bias);
    Result := Format('%s%.2d%.2d', [Sign, Bias div 60, Bias mod 60]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert local date/time to UTC/GMT }
function IcsDateTimeToUTC (dtDT: TDateTime): TDateTime;
begin
    Result := dtDT + (IcsGetLocalTimeZoneBias / MinutesPerDay);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert UTC/GMT to local date/time }
function IcsUTCToDateTime (dtDT: TDateTime): TDateTime;
begin
    Result := dtDT - (IcsGetLocalTimeZoneBias / MinutesPerDay);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ RFC1123/RFC822 TDateTime to short alpha time, HTTP and SMPT headers }
{ V8.62 optionally add time zone }
const
   RFC1123_StrWeekDay : String = 'MonTueWedThuFriSatSun';
   RFC1123_StrMonth   : String = 'JanFebMarAprMayJunJulAugSepOctNovDec';
{ We cannot use Delphi own function because the date must be specified in   }
{ english and Delphi use the current language.                              }
function RFC1123_Date(aDate : TDateTime; AddTZ: Boolean = False) : String;
var
    Year, Month, Day       : Word;
    Hour, Min,   Sec, MSec : Word;
    DayOfWeek              : Word;
begin
    DecodeDate(aDate, Year, Month, Day);
    DecodeTime(aDate, Hour, Min,   Sec, MSec);
    DayOfWeek := ((Trunc(aDate) - 2) mod 7);
    Result := Copy(RFC1123_StrWeekDay, 1 + DayOfWeek * 3, 3) + ', ' +
             Format('%2.2d %s %4.4d %2.2d:%2.2d:%2.2d',
                    [Day, Copy(RFC1123_StrMonth, 1 + 3 * (Month - 1), 3),
                     Year, Hour, Min, Sec]);
    { Tue, 11 Jun 2019 12:24:13 +0100 }
    if AddTZ then Result := Result + ' ' + IcsGetLocalTZBiasStr;  { V8.62 }
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.62 RFC1123/RFC822 TDateTime to UTC then to string, HTTP and SMPT headers, add Z or GMT }
function RFC1123_UtcDate(aDate : TDateTime): String;
begin
    Result := RFC1123_Date(IcsDateTimeToUTC(aDate), False);
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ RFC1123 5.2.14 redefine RFC822 Section 5.                                 }
{ The syntax for the date is hereby changed to:  date = 1*2DIGIT month 2*4DIGIT }
{ V8.62 optionally process time zone and convert to local time }
function RFC1123_StrToDate(aDate : String; UseTZ: Boolean = False) : TDateTime;
var
    Year, Month, Day : Word;
    Hour, Min,   Sec : Word;
    tzvalue: Integer;
    sign: String;
    timeDT: TDateTime;
begin
    Result := 0;
    if Length(aDate) < 17 then Exit ;  // V8.63 must have date
    { Fri, 30 Jul 2004 10:10:35 GMT }
    { Tue, 11 Jun 2019 12:24:13 +0100 }
    { Mon, 3 Aug 2020 12:48:38 +0100 }    // illegal RFC1123 but common
    if aDate[7] = IcsSpace then Insert('0', aDate, 6);  { V8.65 allow single digit date }
    Day    := StrToIntDef(Copy(aDate, 6, 2), 0);
    Month  := (Pos(Copy(aDate, 9, 3), RFC1123_StrMonth) + 2) div 3;
    Year   := StrToIntDef(Copy(aDate, 13, 4), 0);
    if NOT TryEncodeDate(Year, Month, Day, Result) then Exit;

    if Length(aDate) < 25 then Exit ;  // V8.63 no time
    Hour   := StrToIntDef(Copy(aDate, 18, 2), 0);
    Min    := StrToIntDef(Copy(aDate, 21, 2), 0);
    Sec    := StrToIntDef(Copy(aDate, 24, 2), 0);
    if NOT TryEncodeTime(Hour, Min, Sec, 0, timeDT) then Exit;
    Result := Result + timeDT;   // V8.63 add time

{ V8.62 check for time zone, GMT, +0700, -1000, -0330 }
    if NOT UseTZ then Exit;
    if Length(aDate) < 29 then Exit ;  // no time zone
    sign := aDate [27];
    if (sign = '-') or (sign = '+') then begin // ignore GMT/UTC
        tzvalue := StrToIntDef(copy (aDate, 28, 2), 0) * 60;
        if (aDate [30] = '3') then
            tzvalue := tzvalue + 30;
        if sign = '-' then
            Result := Result + (tzvalue / MinutesPerDay)
        else
            Result := Result - (tzvalue / MinutesPerDay);
    end;
    Result := Result - (IcsGetLocalTimeZoneBias / MinutesPerDay);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.53 RFC3339 string date to TDateTime, aka ISO 8601 date }
{ note ISO 8601 requires T for time separator, RFC3339 allows space instead }
{ V8.62 optionally process time zone and convert to local time }
{  yyyy-mm-ddThh:nn:ssZ (ISODateTimeMask), might be NULL
   yyyy-mm-ddThh:nn:ss.sss (milliseconds on end
   yyyy-mm-ddThh:nn:ss-hh:mm (time offset on end
   or just yyyy-mm-dd
   or just hh:nn:ss }
function RFC3339_StrToDate(aDate: String; UseTZ: Boolean = False): TDateTime;
var
    yy, mm, dd, hh, nn, ss, sss: Word;
    timeDT: TDateTime;
    tzoffset, tzvalue: Integer;
    sign: String;
begin
    Result := 0;
    aDate := Trim(aDate);
    if Length(aDate) = 8 then // check time only
    begin
        if aDate[3] <> ':' then Exit;
        if aDate[6] <> ':' then Exit;
        hh := StrToIntDef(copy (aDate, 1, 2), 0);
        nn := StrToIntDef(copy (aDate, 4, 2), 0);
        ss := StrToIntDef(copy (aDate, 7, 2), 0);
        if NOT TryEncodeTime(hh, nn, ss, 0, Result) then exit ;
        Exit ;
    end;
    if Length(aDate) < 10 then Exit ;  // must have date
    if aDate[5] <> '-' then Exit ;
    if aDate[8] <> '-' then Exit ;
    yy := StrToIntDef(copy (aDate, 1, 4), 0);
    mm := StrToIntDef(copy (aDate, 6, 2), 0);
    dd := StrToIntDef(copy (aDate, 9, 2), 0);
    if NOT TryEncodeDate(yy, mm, dd, Result) then
    begin
        Result := -1 ;
        Exit ;
    end ;
    if Length(aDate) < 19 then Exit ;  // no time
    if aDate[14] <> ':' then Exit ;
    if aDate[17] <> ':' then Exit ;
    hh := StrToIntDef(copy (aDate, 12, 2), 0);
    nn := StrToIntDef(copy (aDate, 15, 2), 0);
    ss := StrToIntDef(copy (aDate, 18, 2), 0);
    sss := 0;
    tzoffset := 20;
{ V8.62 check for milliseconds }
    if Length(aDate) >= 23 then begin  // check for MS
        if (aDate [20] = '.') or (aDate [20] = ',') then begin
            sss := StrToIntDef(copy (aDate, 21, 3), 0);
            tzoffset := 24;
        end;
    end;
    if NOT TryEncodeTime(hh, nn, ss, sss, timeDT) then Exit ;
    Result := Result + timeDT ;
    if NOT UseTZ then Exit;

{ V8.62 check for time zone, Z, GMT, +07:00, +0200, -1000, -03:30 }
    if Length(aDate) < (tzoffset + 2) then Exit ;  // no time zone
    sign := aDate [tzoffset];
    if (sign = '-') or (sign = '+') then begin // ignore Z which means +0000
        tzvalue := StrToIntDef(copy (aDate, tzoffset + 1, 2), 0) * 60;
        if Length(aDate) > (tzoffset + 4) then begin
            if (aDate [tzoffset + 3] = '3') or (aDate [tzoffset + 4] = '3') then
                tzvalue := tzvalue + 30;
        end;
        if sign = '-' then
            Result := Result + (tzvalue / MinutesPerDay)
        else
            Result := Result - (tzvalue / MinutesPerDay);
    end;
    Result := Result - (IcsGetLocalTimeZoneBias / MinutesPerDay);  // correct for summer time
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.53 RFC3339 Local Time TDateTime to string, aka ISO 8601 date }
{ TDateTime to to yyyy-mm-ddThh:nn:ss - no quotes }
{ V8.62 optionally add time zone +0000 }
{ V8.71 RFC3359 requires +00:00, ISO accepts either }
function RFC3339_DateToStr(DT: TDateTime; AddTZ: Boolean = False): String;
var
    MyTZ: String;
begin
    Result := FormatDateTime(ISODateTimeMask, DT);
    if AddTZ then begin                                { V8.62 }
        MyTZ := IcsGetLocalTZBiasStr;  // returns +0000, but we need +00:00
        Result := Result + Copy(MyTZ, 1, 3) + ':' + Copy(MyTZ, 4, 2);  { V8.71 }
    end;
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.62 RFC3339 TDateTime to UTC then to time zone string, aka ISO 8601 date }
{ TDateTime to to yyyy-mm-ddThh:nn:ss - no quotes, no Z }
function RFC3339_DateToUtcStr(DT: TDateTime): String;
begin
    Result := RFC3339_DateToStr(IcsDateTimeToUTC(DT), False);
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.4 TDateTimne to string with short alphabetic month and time, ie 01-Jan-2025 14:15:16, mainly for logging  }
function IcsDateTimeToAStr(const DateTime: TDateTime): string;
begin
  DateTimeToString(Result, DateTimeAlphaMask, DateTime);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.4 TDateTimne to string with short alphabetic month, ie 01-Jan-2025, mainly for logging  }
function IcsDateToAStr(const DateTime: TDateTime): string;
begin
  DateTimeToString(Result, DateAlphaMask, DateTime);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 get system date and time as UTC/GMT into Delphi time }
{ V8.64 TSystemTime is windows only, alternate for Linux }
function IcsGetUTCTime: TDateTime;
  {$IFDEF MSWINDOWS}
var
    SystemTime: TSystemTime;
begin
    GetSystemTime(SystemTime);
    with SystemTime do begin
        Result := EncodeTime (wHour, wMinute, wSecond, wMilliSeconds) +
                                              EncodeDate (wYear, wMonth, wDay);
    end ;
  {$ENDIF}
  {$IFDEF POSIX}
begin
    Result := IcsDateTimeToUTC(Now);
  {$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 set system date and time as UTC/GMT, requires administrator rights }
{ V8.64 TSystemTime is windows only, alternate for Linux }
function IcsSetUTCTime (DateTime: TDateTime): boolean;
  {$IFDEF MSWINDOWS}
var
    SystemTime: TSystemTime;
begin
    with SystemTime do DecodeDateTime (DateTime, wYear, wMonth,
                                 wDay, wHour, wMinute, wSecond, wMilliSeconds);
    Result := SetSystemTime (SystemTime);
  {$ENDIF}
  {$IFDEF POSIX}
begin
    Result := False;  { V8.64 pending, do we care? }
  {$ENDIF}
end ;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 get time adjusted by a difference }
function IcsGetNewTime (DateTime, Difference: TDateTime): TDateTime;
begin
    result := DateTime + Difference;
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 change PC system time by a difference, requires administrator rights }
function IcsChangeSystemTime (Difference: TDateTime): boolean;
var
    NewUTCTime: TDateTime;
begin
    NewUTCTime := IcsGetUTCTime + Difference;
    Result := IcsSetUTCTime (NewUTCTime);
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 get current Unix time (in UTC) -}
function IcsGetUnixTime: Int64;
begin
    result := DateTimeToUnix (IcsGetUTCTime);
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function  IcsWcToMb(CodePage: LongWord; Flags: Cardinal; WStr: PWideChar;
  WStrLen: Integer; MbStr: PAnsiChar; MbStrLen: Integer; DefaultChar: PAnsiChar;
  UsedDefaultChar: PLongBool): Integer;
begin
{$IFDEF COMPILER16_UP}
    Result := LocaleCharsFromUnicode(CodePage, Flags, WStr, WStrLen, MbStr,
                                  MbStrLen, DefaultChar, PLongBool(UsedDefaultChar));  { V8.71 cross platform version }
{$ELSE}
    Result := WideCharToMultibyte(CodePage, Flags, WStr, WStrLen, MbStr,
                                  MbStrLen, DefaultChar, PBool(UsedDefaultChar));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function  IcsMbToWc(CodePage: LongWord; Flags: Cardinal; MbStr: PAnsiChar;
  MbStrLen: Integer; WStr: PWideChar; WStrLen: Integer): Integer;
begin
{$IFDEF COMPILER16_UP}
    Result := UnicodeFromLocaleChars(CodePage, Flags, MbStr, MbStrLen, WStr, WStrLen);    { V8.71 cross platform version }
{$ELSE}
    Result := MultiByteToWideChar(CodePage, Flags, MbStr, MbStrLen, WStr, WStrLen);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFNDEF COMPILER12_UP}
var
    DefaultAnsiCodePage : LongWord = 0;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsGetAcp(var CodePage: LongWord);
begin
{$IFNDEF COMPILER12_UP}
    if DefaultAnsiCodePage = 0 then
        DefaultAnsiCodePage := Windows.GetACP;
    CodePage := DefaultAnsiCodePage;
{$ELSE}
    CodePage := System.DefaultSystemCodePage;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIsDBCSCodePage(CodePage: LongWord): Boolean;
begin
    { From Win 7 }
    case CodePage of
        932,   // (ANSI/OEM - Japanese Shift-JIS) DBCS Lead Bytes: 81..9F E0..FC UnicodeDefaultChar:30FB
        936,   // (ANSI/OEM - Simplified Chinese GBK) DBCS Lead Bytes: 81..FE
        949,   // (ANSI/OEM - Korean) DBCS Lead Bytes: 81..FE
        950,   // (ANSI/OEM - Traditional Chinese Big5) DBCS Lead Bytes: 81..FE
        1361,  // (Korean - Johab) DBCS Lead Bytes: 84..D3 D8..DE E0..F9
        {
        10001, // (MAC - Japanese) DBCS Lead Bytes: 81..9F E0..FC UnicodeDefaultChar:30FB
        10002, // (MAC - Traditional Chinese Big5) DBCS Lead Bytes: 81..FC
        10003, // (MAC - Korean) DBCS Lead Bytes: A1..AC B0..C8 CA..FD
        }
        10001..10003,
        10008, // (MAC - Simplified Chinese GB 2312) DBCS Lead Bytes: A1..A9 B0..F7
        {
        20000, // (CNS - Taiwan) DBCS Lead Bytes: A1..FE
        20001, // (TCA - Taiwan) DBCS Lead Bytes: 81..84 91..D8 DF..FC
        20002, // (Eten - Taiwan) DBCS Lead Bytes: 81..AF DD..FE
        20003, // (IBM5550 - Taiwan) DBCS Lead Bytes: 81..84 87..87 89..E8 F9..FB
        20004, // (TeleText - Taiwan) DBCS Lead Bytes: A1..FE
        20005, // (Wang - Taiwan) DBCS Lead Bytes: 8D..F5 F9..FC
        }
        20000..20005,
        20261, // (T.61) DBCS Lead Bytes: C1..CF
        20932, // (JIS X 0208-1990 & 0212-1990) DBCS Lead Bytes: 8E..8E A1..FE UnicodeDefaultChar: 30FB
        20936, // (Simplified Chinese GB2312) DBCS Lead Bytes: A1..A9 B0..F7
        51949: // (EUC-Korean) DBCS Lead Bytes: A1..AC B0..C8 CA..FD
            Result := TRUE;
    else
        Result := FALSE;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIsDBCSLeadByte(Ch: AnsiChar; CodePage: LongWord): Boolean;
begin
    case CodePage of
        932   : Result := Ch in ICS_LEAD_BYTES_932;
        936,
        949,
        950   : Result := Ch in ICS_LEAD_BYTES_936_949_950;
        1361  : Result := Ch in ICS_LEAD_BYTES_1361;
        10001 : Result := Ch in ICS_LEAD_BYTES_10001;
        10002 : Result := Ch in ICS_LEAD_BYTES_10002;
        10003 : Result := Ch in ICS_LEAD_BYTES_10003;
        10008 : Result := Ch in ICS_LEAD_BYTES_10008;
        20000 : Result := Ch in ICS_LEAD_BYTES_20000;
        20001 : Result := Ch in ICS_LEAD_BYTES_20001;
        20002 : Result := Ch in ICS_LEAD_BYTES_20002;
        20003 : Result := Ch in ICS_LEAD_BYTES_20003;
        20004 : Result := Ch in ICS_LEAD_BYTES_20004;
        20005 : Result := Ch in ICS_LEAD_BYTES_20005;
        20261 : Result := Ch in ICS_LEAD_BYTES_20261;
        20932 : Result := Ch in ICS_LEAD_BYTES_20932;
        20936 : Result := Ch in ICS_LEAD_BYTES_20936;
        51949 : Result := Ch in ICS_LEAD_BYTES_51949;
    else
        Result := FALSE;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetLeadBytes(CodePage: LongWord): TIcsDbcsLeadBytes;
begin
    case CodePage of
        932   : Result := ICS_LEAD_BYTES_932;
        936,
        949,
        950   : Result := ICS_LEAD_BYTES_936_949_950;
        1361  : Result := ICS_LEAD_BYTES_1361;
        10001 : Result := ICS_LEAD_BYTES_10001;
        10002 : Result := ICS_LEAD_BYTES_10002;
        10003 : Result := ICS_LEAD_BYTES_10003;
        10008 : Result := ICS_LEAD_BYTES_10008;
        20000 : Result := ICS_LEAD_BYTES_20000;
        20001 : Result := ICS_LEAD_BYTES_20001;
        20002 : Result := ICS_LEAD_BYTES_20002;
        20003 : Result := ICS_LEAD_BYTES_20003;
        20004 : Result := ICS_LEAD_BYTES_20004;
        20005 : Result := ICS_LEAD_BYTES_20005;
        20261 : Result := ICS_LEAD_BYTES_20261;
        20932 : Result := ICS_LEAD_BYTES_20932;
        20936 : Result := ICS_LEAD_BYTES_20936;
        51949 : Result := ICS_LEAD_BYTES_51949;
    else
        Result := [];
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIsMBCSCodePage(CodePage: LongWord): Boolean;
begin
    { Reminder: MBCS do not support MBTOWC flag "MB_ERR_INVALID_CHARS" }
    case CodePage of
        {
        50220, // (ISO-2022 Japanese with no halfwidth Katakana) MBCS Max Size: 5
        50221, // (ISO-2022 Japanese with halfwidth Katakana) MBCS Max Size: 5
        50222, // (ISO-2022 Japanese JIS X 0201-1989) MBCS Max Size: 5
        }
        50220..50222,  // 7-Bit
        50225, // (ISO-2022 Korean) MBCS Max Size: 5 7-Bit
        50227, // (ISO-2022 Simplified Chinese) MBCS Max Size: 5 7-Bit
        50229, // (ISO-2022 Traditional Chinese) MBCS Max Size: 5 7-Bit

        51932, // (euc-jp  EUC Japanese MBCS Max Size: 3 // ** MLang.Dll only **  8-Bit
        52936, // (HZ-GB2312 Simplified Chinese) MBCS Max Size: 5  7-Bit
        54936, // (GB18030 Simplified Chinese) MBCS Max Size: 4   8-Bit


        //65000  // (UTF-7) MBCS Max Size: 5 UnicodeDefaultChar: FFFD, 003F XP 7-Bit
        //65001  // (UTF-8) MBCS Max Size: 4 UnicodeDefaultChar: FFFD, 003F XP 8-Bit

        {
        57002, // (ISCII - Devanagari) MBCS Max Size: 4
        57003, // (ISCII - Bengali) MBCS Max Size: 4
        57004, // (ISCII - Tamil) MBCS Max Size: 4
        57005, // (ISCII - Telugu) MBCS Max Size: 4
        57006, // (ISCII - Assamesisch) MBCS Max Size: 4
        57007, // (ISCII - Oriya) MBCS Max Size: 4
        57008, // (ISCII - Kannada) MBCS Max Size: 4
        57009, // (ISCII - Malayalam) MBCS Max Size: 4
        57010, // (ISCII - Gujarati) MBCS Max Size: 4
        57011  // (ISCII - Punjabi (Gurmukhi)) MBCS Max Size: 4
        }
        57002..57011 : Result := TRUE;   // 8-Bit
    else
        Result := FALSE;
    end;
end;


function IcsIsSBCSCodePage(CodePage: LongWord): Boolean;
begin
    case CodePage of
        {
        1250  (ANSI - Mitteleuropa) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        1251  (ANSI - Kyrillisch)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        1252  (ANSI - Lateinisch I) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        1253  (ANSI - Griechisch)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        1254  (ANSI - Türkisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        1255  (ANSI - Hebräisch)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        1256  (ANSI - Arabisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        1257  (ANSI - Baltisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        1258  (ANSI/OEM - Vietnam)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        }
        1250..1258,
        20127, // (US-ASCII)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        21866, // (Ukrainisch - KOI8-U) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        {
        28591 (ISO 8859-1 Lateinisch I) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        28592 (ISO 8859-2 Mitteleuropa) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        28593 (ISO 8859-3 Lateinisch 3) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        28594 (ISO 8859-4 Baltisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        28595 (ISO 8859-5 Kyrillisch)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        28596 (ISO 8859-6 Arabisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        28597 (ISO 8859-7 Griechisch)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        28598 (ISO 8859-8 Hebräisch: Visuelle Sortierung)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        28599 (ISO 8859-9 Lateinisch 5) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        }
        28591..28599,
        28605, // (ISO 8859-15 Lateinisch 9)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        38598, // (ISO 8859-8 Hebräisch: Logische Sortierung)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        20866, // (Russisch - KOI8) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F

        37,   // (IBM EBCDIC - USA/Kanada)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        437,  // (OEM - Vereinigte Staaten) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        500,  // (IBM EBCDIC - International)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        708,  // (Arabisch - ASMO)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        720,  // (Arabisch- Transparent ASMO)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        737,  // (OEM - Griechisch 437G)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        775,  // (OEM - Baltisch)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        850,  // (OEM - Multilingual Lateinisch I)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        852,  // (OEM - Lateinisch II)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        855,  // (OEM - Kyrillisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        857,  // (OEM - Türkisch)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        858,  // (OEM - Multilingual Lateinisch I + Euro)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        {
        860   (OEM - Portugisisch)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        861   (OEM - Isländisch)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        862   (OEM - Hebräisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        863   (OEM - Französch (Kanada))    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        864   (OEM - Arabisch)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        865   (OEM - Nordisch)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        866   (OEM - Russisch)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        }
        860..866,
        869,  // (OEM - Modernes Griechisch)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        //874,  // (ANSI/OEM - Thai)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        874..875,  // (IBM EBCDIC - Modernes Griechisch)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        1026, // (IBM EBCDIC - Türkisch (Lateinisch-5)) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        {
        1140  (IBM EBCDIC - USA/Kanada (37 + Euro)) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        1141  (IBM EBCDIC - Deutschland (20273 + Euro)) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        1142  (IBM EBCDIC - Dänemark/Norwegen (20277 + Euro))   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        1143  (IBM EBCDIC - Finnland/Schweden (20278 + Euro))   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        1144  (IBM EBCDIC - Italien (20280 + Euro)) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        1145  (IBM EBCDIC - Lateinamerika/Spanien (20284 + Euro))   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        }
        1140..1145,
        1147, // (IBM EBCDIC - Frankreich (20297 + Euro))   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        1149, // (IBM EBCDIC - Isländisch (20871 + Euro))   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F


        10000, // (MAC - Roman) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        {
        10004 (MAC - Arabisch)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        10005 (MAC - Hebräisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        10006 (MAC - Griechisch I)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        10007 (MAC - Kyrillisch)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        }
        10004..10007,
        10010, // (MAC - Rumänisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        10017, // (MAC - Ukrainisch)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        10021, // (MAC - Thai)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        10029, // (MAC - Lateinisch II) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        10079, // (MAC - Isländisch)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        10081, // (MAC - Türkisch)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        10082, // (MAC - Kroatisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        {
        20105 (IA5 IRV Internationales Alphabet Nr. 5)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        20106 (IA5 Deutsch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        20107 (IA5 Swedisch)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        20108 (IA5 Norwegisch)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        }
        20105..20108,

        20269, // (ISO 6937 Akzent ohne Zwischenraum)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:003F
        20273, // (IBM EBCDIC - Deutschland)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        {
        20277 (IBM EBCDIC - Dänemark/Norwegen)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        20278 (IBM EBCDIC - Finnland/Schweden)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        }
        20277..20278,
        20280, // (IBM EBCDIC - Italien)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        {
        20284, // (IBM EBCDIC - Lateinamerika/Spanien)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        20285, // (IBM EBCDIC - Großbritannien) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        }
        20284..20285,
        20290, // (IBM EBCDIC - Japanisch (erweitertes Katakana))   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        20297, // (IBM EBCDIC - Frankreich) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        20420, // (IBM EBCDIC - Arabisch)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        {
        20423, // (IBM EBCDIC - Griechisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        20424, // (IBM EBCDIC - Hebräisch)  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        }
        20423..20424,
        20833, // (IBM EBCDIC - erweitertes Koreanisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        20838, // (IBM EBCDIC - Thai)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        20871, // (IBM EBCDIC - Isländisch) SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        20880, // (IBM EBCDIC - Kyrillisch (Russisch))  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        20905, // (IBM EBCDIC - Türkisch)   SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        20924, // (IBM EBCDIC - Lateinisch-1/Offenes System (1047 + Euro))  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        21025, // (IBM EBCDIC - Kyrillisch (Serbisch, Bulgarisch))  SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        21027 // (Ext Alpha Kleinbuchstaben)    SBCS Size: 1    UnicodeDefaultChar: 003F    DefaultChar:006F
        : Result := TRUE;
    else
        Result := FALSE;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUsAscii(const Str: RawByteString): Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
var
    I : Integer;
begin
    for I := 1 to Length(Str) do
        if Byte(Str[I]) > 127 then begin
            Result := FALSE;
            Exit;
        end;
    Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUsAscii(const Str: UnicodeString): Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
var
    I : Integer;
begin
    for I := 1 to Length(Str) do
        if Ord(Str[I]) > 127 then begin
            Result := FALSE;
            Exit;
        end;
    Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Assumes parameter Str does not contain any 8Bit characters otherwise they   }
{ are replaced by FailCh. When we use plain ASCII payload this could be the   }
{ fastes cast. Sometimes we handle 7 bit strings only.                        }
function UnicodeToUsAscii(const Str: UnicodeString; FailCh: AnsiChar): AnsiString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    I   : Integer;
    Len : Integer;
begin
    Len := Length(Str);
    SetLength(Result, Len);
    for I := 1 to Len do begin
        if Ord(Str[I]) > 127 then
            Result[I] := FailCh
        else
            Result[I] := AnsiChar(Str[I]);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function UnicodeToUsAscii(const Str: UnicodeString): AnsiString; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := UnicodeToUsAscii(Str, DefaultFailChar);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Converts an UnicodeString to an AnsiString.                                 }
function UnicodeToAnsi(const Str: UnicodeString; ACodePage: LongWord; SetCodePage: Boolean = False): RawByteString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    Len, Len2 : Integer;
begin
    Len := Length(Str);
    if Len > 0 then begin
        Len := IcsWcToMb(ACodePage, 0, Pointer(Str), Len, nil, 0, nil, nil);
        SetLength(Result, Len);
        if Len > 0 then begin
            Len2 := IcsWcToMb(ACodePage, 0, Pointer(Str), Length(Str),
                                Pointer(Result), Len, nil, nil);
            if Len2 <> Len then // May happen, very rarely
                SetLength(Result, Len2);
        {$IFDEF COMPILER12_UP}
            if SetCodePage and (ACodePage <> CP_ACP) then
                PWord(INT_PTR(Result) - 12)^ := ACodePage;
        {$ENDIF}
        end;
    end
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Converts an UnicodeString to an AnsiString using current code page.         }
function UnicodeToAnsi(const Str: UnicodeString): RawByteString; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := UnicodeToAnsi(Str, CP_ACP);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.67 overload with specified size buffer that may include nulls }
function AnsiToUnicode(const Buffer; BufferSize: Integer; ACodePage: LongWord): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    Len, Len2 : Integer;
begin
    if (@Buffer <> nil) and (BufferSize > 0) then begin
        Len := IcsMbToWc(ACodePage, 0, PAnsiChar(Buffer), BufferSize, nil, 0);
        if Len > 0 then begin // no null-terminator
            SetLength(Result, Len);
            Len2 := IcsMbToWc(ACodePage, 0, PAnsiChar(Buffer), BufferSize, Pointer(Result), Len);
            if Len2 <> Len then  // May happen, very rarely
            begin
                if Len2 > 0 then
                    SetLength(Result, Len2)
                else
                    Result := '';
            end;
        end
        else
            Result := '';
    end
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function AnsiToUnicode(const Str: PAnsiChar; ACodePage: LongWord): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    Len, Len2 : Integer;
begin
    if (Str <> nil) then begin
        Len := IcsMbToWc(ACodePage, 0, Str, -1, nil, 0);
        if Len > 1 then begin // counts the null-terminator
            SetLength(Result, Len - 1);
            Len2 := IcsMbToWc(ACodePage, 0, Str, -1, Pointer(Result), Len);
            if Len2 <> Len then  // May happen, very rarely
            begin
                if Len2 > 0 then
                    SetLength(Result, Len2 - 1)
                else
                    Result := '';
            end;
        end
        else
            Result := '';
    end
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function UnicodeToAnsi(const Str: PWideChar; ACodePage: LongWord;
  SetCodePage: Boolean = False): RawByteString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    Len, Len2 : Integer;
begin
    if (Str <> nil) then begin
        Len := IcsWcToMb(ACodePage, 0, Str, -1, nil, 0, nil, nil);
        if Len > 1 then begin // counts the null-terminator
            SetLength(Result, Len - 1);
            Len2 := IcsWcToMb(ACodePage, 0, Str, -1, Pointer(Result), Len,
                                nil, nil);
            if Len2 <> Len then // May happen, very rarely
            begin
                if Len2 > 0 then
                    SetLength(Result, Len2 - 1)
                else
                    Result := '';
            end;
        {$IFDEF COMPILER12_UP}
            if SetCodePage and (ACodePage <> CP_ACP) then
                PWord(INT_PTR(Result) - 12)^ := ACodePage;
        {$ENDIF}
        end
        else
            Result := '';
    end
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function AnsiToUnicode(const Str: RawByteString; ACodePage: LongWord): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
{var
    Len, Len2 : Integer;  }
begin
    Result := AnsiToUnicode(Pointer(Str), Length(Str), ACodePage);   { V8.67 }
  {  Len := Length(Str);
    if Len > 0 then begin
        Len := IcsMbToWc(ACodePage, 0, Pointer(Str),
                                   Len, nil, 0);
        SetLength(Result, Len);
        if Len > 0 then
        begin
            Len2 := IcsMbToWc(ACodePage, 0, Pointer(Str), Length(Str),
                                Pointer(Result), Len);
            if Len2 <> Len then // May happen, very rarely
                SetLength(Result, Len2);
        end;
    end
    else
        Result := '';   }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function AnsiToUnicode(const Str: RawByteString): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := AnsiToUnicode(Pointer(Str), Length(Str), CP_ACP);     { V8.67 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function UsAsciiToUnicode(const Str: RawByteString; FailCh: AnsiChar): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    I  : Integer;
    P  : PSmallInt;
begin
    SetLength(Result, Length(Str));
    P := Pointer(Result);
    for I := 1 to Length(Str) do begin
        if Byte(Str[I]) > 127 then
            P^ := Byte(FailCh)
        else
            P^ := Byte(Str[I]);
        Inc(P);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function UsAsciiToUnicode(const Str: RawByteString): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := UsAsciiToUnicode(Str, DefaultFailChar);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsSwap16(Value: Word): Word;
{$IFDEF PUREPASCAL}
begin
    Result := (Value shr 8) or (Value shl 8);
{$ELSE}
asm
{$IFDEF CPUX64}
    MOV   AX, CX
{$ENDIF}
    XCHG  AL, AH
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsSwap16Buf(Src, Dst: PWord; WordCount: Integer);
{$IFDEF PUREPASCAL}
var
    I : Integer;
begin
    for I := 1 to WordCount do
    begin
        Dst^ := (Src^ shr 8) or (Src^ shl 8);
        Inc(Src);
        Inc(Dst);
    end;
{$ELSE}
asm
{$IFDEF CPUX64}
{ Src in RCX
  Dst in RDX
  WordCount in R8D }

       SUB    RCX, RDX
       SUB    R8D, 4
       JS     @@2
@@1:
       MOV    EAX, [RCX + RDX]
       MOV    R9D, [RCX + RDX + 4]
       BSWAP  EAX
       BSWAP  R9D
       MOV    WORD PTR [RDX + 2], AX
       MOV    WORD PTR [RDX + 6], R9W
       SHR    EAX, 16
       SHR    R9D, 16
       MOV    WORD PTR [RDX], AX
       MOV    WORD PTR [RDX + 4], R9W
       ADD    RDX, 8
       SUB    R8D, 4
       JNS    @@1
@@2:
       ADD    R8D, 2
       JS     @@3
       MOV    EAX, [RCX + RDX]
       BSWAP  EAX
       MOV    WORD PTR [RDX + 2], AX
       SHR    EAX, 16
       MOV    WORD PTR [EDX], AX
       ADD    RDX, 4
       SUB    R8D, 2
@@3:
       INC    R8D
       JNZ    @@Exit
       MOV    RAX, [RCX + RDX]
       XCHG   AL, AH
       MOV    WORD PTR [RDX], AX
@@Exit:

{$ELSE}
{ Thanks to Jens Dierks for this code }
{ Src in EAX
  Dst in EDX
  WordCount in ECX }

       PUSH   ESI
       PUSH   EBX
       SUB    EAX,EDX
       SUB    ECX,4
       JS     @@2
@@1:
       MOV    EBX,[EAX + EDX]
       MOV    ESI,[EAX + EDX + 4]
       BSWAP  EBX
       BSWAP  ESI
       MOV    [EDX + 2],BX
       MOV    [EDX + 6],SI
       SHR    EBX, 16
       SHR    ESI, 16
       MOV    [EDX],BX
       MOV    [EDX + 4],SI
       ADD    EDX, 8
       SUB    ECX, 4
       JNS    @@1
@@2:
       ADD    ECX, 2
       JS     @@3
       MOV    EBX,[EAX + EDX]
       BSWAP  EBX
       MOV    [EDX + 2],BX
       SHR    EBX, 16
       MOV    [EDX],BX
       ADD    EDX, 4
       SUB    ECX, 2
@@3:
       INC    ECX
       JNZ    @@4
       MOV    BX,[EAX + EDX]
       XCHG   BL,BH
       MOV    [EDX],BX
@@4:
       POP    EBX
       POP    ESI
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsSwap32(Value: LongWord): LongWord;
{$IFDEF PUREPASCAL}
begin
    Result := Word(((Value shr 16) shr 8) or ((Value shr 16) shl 8)) or
              Word((Word(Value) shr 8) or (Word(Value) shl 8)) shl 16;
{$ELSE}
asm
{$IFDEF CPUX64}
    MOV    EAX, ECX
{$ENDIF}
    BSWAP  EAX
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsSwap32Buf(Src, Dst: PLongWord; LongWordCount: Integer);
{$IFDEF PUREPASCAL}
var
    I : Integer;
begin
    for I := 1 to LongWordCount do
    begin
        Dst^ := Word(((Src^ shr 16) shr 8) or ((Src^ shr 16) shl 8)) or
                Word((Word(Src^) shr 8) or (Word(Src^) shl 8)) shl 16;
        Inc(Src);
        Inc(Dst);
    end;
{$ELSE}
asm
{$IFDEF CPUX64}
{ Src in RCX
  Dst in RDX
  LongWordCount in R8D }

       SUB    RCX, RDX
       SUB    R8D, 2
       JS     @@2
@@1:
       MOV    EAX, [RCX + RDX]
       MOV    R9D, [RCX + RDX + 4]
       BSWAP  EAX
       BSWAP  R9D
       MOV    DWORD PTR [RDX], EAX
       MOV    DWORD PTR [RDX + 4], R9D
       ADD    RDX, 8
       SUB    R8D, 2
       JNS    @@1
@@2:
       INC    R8D
       JS     @Exit
       MOV    EAX, [RCX + RDX]
       BSWAP  EAX
       MOV    DWORD PTR [RDX], EAX
@Exit:

{$ELSE}
{ Src in EAX
  Dst in EDX
  LongWordCount in ECX }

       PUSH   ESI
       PUSH   EBX
       SUB    EAX, EDX
       SUB    ECX, 2
       JS     @@2
@@1:
       MOV    EBX,[EAX + EDX]
       MOV    ESI,[EAX + EDX + 4]
       BSWAP  EBX
       BSWAP  ESI
       MOV    [EDX], EBX
       MOV    [EDX + 4], ESI
       ADD    EDX, 8
       SUB    ECX, 2
       JNS    @@1
@@2:
       INC    ECX
       JS     @Exit
       MOV    EBX,[EAX + EDX]
       BSWAP  EBX
       MOV    [EDX], EBX
@Exit:
       POP    EBX
       POP    ESI
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsSwap64(Value: Int64): Int64;
{$IFDEF PUREPASCAL}
var
    H, L: LongWord;
begin
    H := LongWord(Value shr 32);
    L := LongWord(Value);
    H := Word(((H shr 16) shr 8) or ((H shr 16) shl 8)) or
         Word((Word(H) shr 8) or (Word(H) shl 8)) shl 16;
    L := Word(((L shr 16) shr 8) or ((L shr 16) shl 8)) or
         Word((Word(L) shr 8) or (Word(L) shl 8)) shl 16;
    Result := Int64(H) or Int64(L) shl 32;
{$ELSE}
asm
{$IFDEF CPUX64}
    MOV    RAX, RCX
    BSWAP  RAX
{$ELSE}
    MOV   EDX,  [EBP + $08]
    MOV   EAX,  [EBP + $0C]
    BSWAP EAX
    BSWAP EDX
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsSwap64Buf(Src, Dst: PInt64; QuadWordCount: Integer);
{$IFDEF PUREPASCAL}
var
    H, L: LongWord;
    I : Integer;
begin
    for I := 1 to QuadWordCount do
    begin
        H := LongWord(Src^ shr 32);
        L := LongWord(Src^);
        H := Word(((H shr 16) shr 8) or ((H shr 16) shl 8)) or
             Word((Word(H) shr 8) or (Word(H) shl 8)) shl 16;
        L := Word(((L shr 16) shr 8) or ((L shr 16) shl 8)) or
             Word((Word(L) shr 8) or (Word(L) shl 8)) shl 16;
        Dst^ := Int64(H) or Int64(L) shl 32;
        Inc(Src);
        Inc(Dst);
    end;
{$ELSE}
asm
{$IFDEF CPUX64}
{ Src in RCX
  Dst in RDX
  QuadWordCount in R8D }

       SUB    RCX, RDX
       SUB    R8D, 2
       JS     @@2
@@1:
       MOV    RAX, [RCX + RDX]
       MOV    R9,  [RCX + RDX + 8]
       BSWAP  RAX
       BSWAP  R9
       MOV    [RDX], RAX
       MOV    [RDX + 8], R9
       ADD    RDX, 16
       SUB    R8D, 2
       JNS    @@1
@@2:
       INC    R8D
       JS     @Exit
       MOV    RAX, [RCX + RDX]
       BSWAP  RAX
       MOV    [RDX], RAX
@Exit:

{$ELSE}
{ Src in EAX
  Dst in EDX
  QuadWordCount in ECX }

       PUSH   ESI
       PUSH   EBX
       SUB    EAX, EDX
       DEC    ECX
       JS     @Exit
@@1:
       MOV    EBX,[EAX + EDX]
       MOV    ESI,[EAX + EDX + 4]
       BSWAP  EBX
       BSWAP  ESI
       MOV    [EDX], ESI
       MOV    [EDX + 4], EBX
       ADD    EDX, 8
       DEC    ECX
       JNS    @@1
@Exit:
       POP    EBX
       POP    ESI
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Result is the number of translated WideChars, InvalidEndByteCount returns   }
{ the number of untranslated bytes at the end of the source buffer only       }
{ (if any). If there were invalid byte sequences somewhere else they may be   }
{ translated/counted or not depending on the OS version and code page.        }
{ BufferCodePage may include CP_UTF16, CP_UTF16Be, CP_UTF32 and CP_UTF32Be    }
function IcsGetWideCharCount(const Buffer; BufferSize: Integer;
  BufferCodePage: LongWord; out InvalidEndByteCount: Integer): Integer;

    function GetMbcsInvalidEndBytes(const EndBuf: PAnsiChar): Integer;
    var
        P : PAnsiChar;
        Utf8Size : Integer;
    begin
        { If last byte equals NULL this function always returns "0"           }
        if INT_PTR(@Buffer) < INT_PTR(EndBuf) then
        begin
            { Try to get a pointer to the last lead byte, see comment in      }
            { IcsStrPrevChar()                                                }
            P := IcsStrPrevChar(@Buffer, EndBuf, BufferCodePage);
            Result := INT_PTR(EndBuf) - INT_PTR(P);
            if (Result > 0) and (BufferCodePage = CP_UTF8) then
            begin
                Utf8Size := IcsUtf8Size(Byte(P^));
                if (Utf8Size > 0) and (Utf8Size < Result) then
                begin { Looks like we got a complete and a trunkated sequence }
                    if (Utf8Size = 1) { should always translate } or
                       (IcsMbToWc(BufferCodePage, MB_ERR_INVALID_CHARS,
                                            P, Utf8Size, nil, 0) > 0) then
                    begin
                        Inc(P, Utf8Size);
                        Dec(Result, Utf8Size);
                    end;
                end;
            end;
            if (Result > 0) and
               (IcsMbToWc(BufferCodePage, MB_ERR_INVALID_CHARS,
                           P, Result, nil, 0) > 0) then
                Result := 0;
        end
        else
            Result := 0;
    end;

var
    I     : Integer;
    Bytes : PByte;
    LastErr : LongWord;
begin
    Bytes := @Buffer;
    case BufferCodePage of
        CP_UTF16,
        CP_UTF16Be  :
            begin
                Result := BufferSize div SizeOf(WideChar);
                InvalidEndByteCount := BufferSize mod SizeOf(WideChar);
            end;
        CP_UTF32    :
            begin
                Result := BufferSize div SizeOf(UCS4Char);
                InvalidEndByteCount := BufferSize mod SizeOf(UCS4Char);
                for I := 1 to Result do
                begin
                    if PLongWord(Bytes)^ > $10000 then
                        Inc(Result); // Surrogate pair
                    Inc(Bytes, SizeOf(UCS4Char));
                end;
            end;
        CP_UTF32Be  :
            begin
                Result := BufferSize div SizeOf(UCS4Char);
                InvalidEndByteCount := BufferSize mod SizeOf(UCS4Char);
                for I := 1 to Result do
                begin
                    if IcsSwap32(PLongWord(Bytes)^) > $10000 then
                        Inc(Result); // Surrogate pair
                    Inc(Bytes, SizeOf(UCS4Char));
                end;
            end;
        else
            InvalidEndByteCount := 0;
            Result := IcsMbToWc(BufferCodePage, MB_ERR_INVALID_CHARS,
                                          PAnsiChar(Bytes), BufferSize, nil, 0);
            { Not every code page supports flag MB_ERR_INVALID_CHARS.         }
            { Depends on the Windows version as well, see SDK-docs.           }
            { However mbtowc's doc is not correct regarding older Windows.    }
            { Some tests with UTF-8 showed that in W2K SP4 and XP SP3 mbtowc  }
            { happily takes this flag and seems to skip invalid source bytes  }
            { silently if they are NOT at the end of the source buffer. If    }
            { they are at the end mbtowc fails as documented. Other MBCS seem }
            { to work as documented (tested 932 only). Windows Vista seems to }
            { work as documented too.                                         }
            if Result = 0 then
            begin
                LastErr := GetLastError;
                if LastErr = ERROR_INVALID_FLAGS then
                    { Try again with flags "0", nothing else can be done      }
                    Result := IcsMbToWc(BufferCodePage, 0,
                                        PAnsiChar(Bytes), BufferSize, nil, 0)
                else if LastErr = ERROR_NO_UNICODE_TRANSLATION then
                begin
                    { There's some invalid bytes but we don't know where in  }
                    { the source buffer. Try to get the number of            }
                    { untranslated bytes at the end of the source buffer     }
                    {(if any). It won't work with all code pages correctly.  }
                    { According to Mrs. Kaplan, code pages 932, 936, 949,    }
                    { 950, and 1361 are supported. UTF-8 support is an ICS   }
                    { home-grown routine.                                    }
                    InvalidEndByteCount := GetMbcsInvalidEndBytes(
                                              PAnsiChar(Bytes) + BufferSize);
                    { Then call mbtowc with a shorter source buffer and flag }
                    { "0".                                                   }
                    Result := IcsMbToWc(BufferCodePage, 0,
                        PAnsiChar(Bytes), BufferSize - InvalidEndByteCount,
                        nil, 0);
                end;
            end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ BufferCodePage may include CP_UTF16, CP_UTF16Be, CP_UTF32 and CP_UTF32Be }
function IcsGetWideChars(const Buffer; BufferSize: Integer;
   BufferCodePage: LongWord; Chars: PWideChar; CharCount: Integer): Integer;
var
    PUCS4 : PUCS4Char;
    I     : Integer;

    procedure UCS4ToU16;
    begin
        I := 0;
        while I < CharCount do begin
            if PUCS4^ > $10000 then
            begin
                { Encode Surrogate pair }
                Inc(I);
                Chars^ := WideChar((((PUCS4^ - $00010000) shr 10) and
                                   $000003FF) or $D800);
                Inc(I);
                Inc(Chars);
                Chars^ := WideChar(((PUCS4^ - $00010000) and $000003FF) or
                                   $DC00);
            end
            else begin
                Inc(I);
                Chars^ := WideChar(PUCS4^);
            end;
            Inc(PUCS4);
            Inc(Chars);
        end;
    end;

begin
    case BufferCodePage of
        CP_UTF16    :
            begin
                Move(Buffer, Chars^, BufferSize);
                Result := CharCount;
            end;
        CP_UTF16Be  :
            begin
                IcsSwap16Buf(@Buffer, Pointer(Chars), CharCount);
                Result := CharCount;
            end;
        CP_UTF32    :
            begin
                PUCS4 := @Buffer;
                UCS4ToU16;
                Result := CharCount;
            end;
        CP_UTF32Be  :
            begin
                IcsSwap32Buf(@Buffer, @Buffer, BufferSize div SizeOf(UCS4Char));
                PUCS4 := @Buffer;
                UCS4ToU16;
                Result := CharCount;
            end;

        else
           Result := IcsMbToWc(BufferCodePage, 0, @Buffer,
                                         BufferSize, Chars, CharCount);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ BufferCodePage may include CP_UTF16, CP_UTF16Be, CP_UTF32 and CP_UTF32Be, or CP_UTF8 etc }
function IcsBufferToUnicode(const Buffer; BufferSize: Integer;
  BufferCodePage: LongWord; out FailedByteCount: Integer): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    WCharCnt: Integer;
begin
    FailedByteCount := 0;
    if (@Buffer = nil) or (BufferSize <= 0) then
        Result := ''
    else begin
        WCharCnt := IcsGetWideCharCount(Buffer, BufferSize, BufferCodePage,
                                        FailedByteCount);
        SetLength(Result, WCharCnt);
        if WCharCnt > 0 then
            IcsGetWideChars(Buffer, BufferSize - FailedByteCount,
                            BufferCodePage, PWideChar(Result), WCharCnt);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ BufferCodePage may include CP_UTF16, CP_UTF16Be, CP_UTF32 and CP_UTF32Be, or CP_UTF8 etc }
function IcsBufferToUnicode(const Buffer; BufferSize: Integer;
  BufferCodePage: LongWord; RaiseFailedBytes: Boolean = FALSE): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    FailedBytes : Integer;
begin
    FailedBytes := 0;
    Result := IcsBufferToUnicode(Buffer, BufferSize, BufferCodePage, FailedBytes);
    if RaiseFailedBytes and (FailedBytes > 0) then
        raise EIcsStringConvertError.CreateFmt(
                        'Invalid bytes in source buffer. %d bytes untranslated',
                                                 [FailedBytes]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsAppendStr(var Dest: RawByteString; const Src: RawByteString);
begin
{$IFDEF COMPILER12_UP}
    SetLength(Dest, Length(Dest) + Length(Src));
    Move(Pointer(Src)^, Dest[Length(Dest) - Length(Src) + 1], Length(Src));
{$ELSE}
    Dest := Dest + Src;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetBomBytes(ACodePage: LongWord): TBytes;
begin
    case ACodePage of
        CP_UTF16 :
        begin
            SetLength(Result, 2);
            Result[0] := $FF;
            Result[1] := $FE;
        end;
        CP_UTF16Be :
        begin
            SetLength(Result, 2);
            Result[0] := $FE;
            Result[1] := $FF;
        end;
        CP_UTF8    :
        begin
            SetLength(Result, 3);
            Result[0] := $EF;
            Result[1] := $BB;
            Result[2] := $BF;
        end;
        CP_UTF32   :
        begin
            SetLength(Result, 4);
            Result[0] := $FF;
            Result[1] := $FE;
            Result[2] := $00;
            Result[3] := $00;
        end;
        CP_UTF32Be :
        begin
            SetLength(Result, 4);
            Result[0] := $00;
            Result[1] := $00;
            Result[2] := $FE;
            Result[3] := $FF;
        end;
        else
            SetLength(Result, 0);
    end;
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function  IcsGetBufferCodepage(Buf: PAnsiChar; ByteCount: Integer): LongWord; {$IFDEF ANDROID} overload; {$ENDIF} { V8.07 }
var
  LBOMSize: Integer;
begin
  Result := IcsGetBufferCodepage(Buf, ByteCount, LBOMSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetBufferCodepage(Buf: PAnsiChar; ByteCount: Integer; out BOMSize: Integer): LongWord; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := CP_ACP;
    BOMSize := 0;
    if (Buf = nil) then
        Exit;
    if (ByteCount > 3) and (Buf[0] = #$FF) and (Buf[1] = #$FE) and
       (Buf[2] = #0) and (Buf[3] = #0) then begin
        Result := CP_UTF32;
        BOMSize := 4;
    end
    else if (ByteCount > 3) and (Buf[0] = #0) and (Buf[1] = #0) and
            (Buf[2] = #$FE) and (Buf[3] = #$FF) then begin
        Result := CP_UTF32Be;
        BOMSize := 4;
    end
    else if (ByteCount > 2) and (Buf[0] = #$EF) and (Buf[1] = #$BB) and
            (Buf[2] = #$BF)  then begin
        Result := CP_UTF8;
        BOMSize := 3;
    end
    else if (ByteCount > 1) and (Buf[0] = #$FF) and (Buf[1] = #$FE) then begin
        Result := CP_UTF16;
        BOMSize := 2;
    end
    else if (ByteCount > 1) and (Buf[0] = #$FE) and (Buf[1] = #$FF) then begin
        Result := CP_UTF16Be;
        BOMSize := 2;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Assumes that the string is a Windows, UTF-16 little endian wide string      }
function StreamWriteString(AStream: TStream; Str: PWideChar; cLen: Integer;
  ACodePage: LongWord; WriteBOM: Boolean): Integer; {$IFDEF ANDROID} overload; {$ENDIF}
var
    SBuf  : array [0..2047] of Byte;
    Len   : Integer;
    HBuf  : PAnsiChar;
    Bom   : TBytes;
    CurCP : Word;
    Swap  : Boolean;
    Dump  : Boolean;
begin
    Result := 0;
    if (Str = nil) or (cLen <= 0) then
        Exit;
    CurCP := CP_UTF16; //PWord(Integer(Str) - 12)^;
    case ACodePage of
        CP_UTF16  :
            begin
                if WriteBOM then begin
                    SetLength(BOM, 2);
                    BOM[0] := $FF;
                    BOM[1] := $FE;
                end;
                Swap := CurCP = CP_UTF16Be;
                Dump := (CurCP = ACodePage) or Swap;
            end;
        CP_UTF16Be :
            begin
                if WriteBOM then begin
                    SetLength(BOM, 2);
                    BOM[0] := $FE;
                    BOM[1] := $FF;
                end;
                Swap := CurCP = CP_UTF16;
                Dump := (CurCP = ACodePage) or Swap;
            end;
        CP_UTF8 :
            begin
                if WriteBOM then begin
                    SetLength(BOM, 3);
                    BOM[0] := $EF;
                    BOM[1] := $BB;
                    BOM[2] := $BF;
                end;
                Dump := FALSE;
                Swap := FALSE;
            end;
        else
            SetLength(BOM, 0);
            Dump := FALSE;
            Swap := FALSE;
    end; // case

    if Dump and not Swap then
    begin // No conversion needed
        if Bom <> nil then
            AStream.Write(Bom[0], Length(Bom));
        Result := AStream.Write(Pointer(Str)^, cLen * 2); //Use const char length
    end
    else begin
        if Dump and Swap then
        begin // We need to swap bytes and write them to the stream
            if Bom <> nil then
                AStream.Write(Bom[0], Length(Bom));
            IcsSwap16Buf(Pointer(Str), Pointer(Str), cLen);
            Result := Result + AStream.Write(Str^, cLen * 2);
        end
        else begin // Charset conversion
            Len := IcsWcToMb(ACodePage, 0, Pointer(Str), cLen,
                                       nil, 0, nil, nil);
            if Len <= SizeOf(SBuf) then begin
                Len := IcsWcToMb(ACodePage, 0, Pointer(Str), cLen,
                                           @SBuf, Len, nil, nil);
                if (Len > 0) then begin
                    if Bom <> nil then
                        AStream.Write(Bom[0], Length(Bom));
                    Result := AStream.Write(SBuf[0], Len);
                end;
            end
            else begin
                GetMem(HBuf, Len);
                try
                    Len := IcsWcToMb(ACodePage, 0, Pointer(Str), cLen,
                                               HBuf, Len, nil, nil);
                    if (Len > 0) then begin
                        if Bom <> nil then
                            AStream.Write(Bom[0], Length(Bom));
                        Result := AStream.Write(HBuf^, Len);
                    end;
                finally
                    FreeMem(HBuf);
                end;
            end;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StreamWriteString(AStream: TStream; Str: PWideChar; cLen: Integer;
  ACodePage: LongWord): Integer; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := StreamWriteString(AStream, Str, cLen, ACodePage, FALSE);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StreamWriteString(AStream: TStream; const Str: UnicodeString;
 ACodePage: LongWord; WriteBOM: Boolean): Integer; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := StreamWriteString(AStream, Pointer(Str), Length(Str),
                                ACodePage, WriteBom);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StreamWriteString(AStream: TStream; const Str: UnicodeString): Integer; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result:= StreamWriteString(AStream, Pointer(Str), Length(Str),
                               CP_ACP, FALSE);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StreamWriteString(AStream: TStream; const Str: UnicodeString; ACodePage: LongWord): Integer; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result:= StreamWriteString(AStream, Pointer(Str), Length(Str),
                               ACodePage, FALSE);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This one is around 3-4 times faster } { AG }
function atoi(const Str : RawByteString): Integer; {$IFDEF ANDROID} overload; {$ENDIF}
var
    P : PAnsiChar;
begin
    Result := 0;
    P := Pointer(Str);
    if P = nil then
        Exit;
    while P^ = #$20 do Inc(P);
    while True do
    begin
        case P^ of
            '0'..'9' : Result := Result * 10 + Byte(P^) - Byte('0');
        else
            Exit;
        end;
        Inc(P);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This one is around 3-4 times faster } { AG }
function atoi(const Str : UnicodeString): Integer; {$IFDEF ANDROID} overload; {$ENDIF}
var
    P : PWideChar;
begin
    Result := 0;
    P := Pointer(Str);
    if P = nil then
        Exit;
    while P^ = #$0020 do Inc(P);
    while True do
    begin
        case P^ of
            '0'..'9' : Result := Result * 10 + Ord(P^) - Ord('0');
        else
            Exit;
        end;
        Inc(P);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF STREAM64}

{ This one is around 3-4 times faster } { AG }
function atoi64(const Str : RawByteString): Int64; {$IFDEF ANDROID} overload; {$ENDIF}
var
    P : PAnsiChar;
begin
    Result := 0;
    P := Pointer(Str);
    if P = nil then
        Exit;
    while P^ = #$20 do Inc(P);
    while True do
    begin
        case P^ of
            '0'..'9' : Result := Result * 10 + Byte(P^) - Byte('0');
        else
            Exit;
        end;
        Inc(P);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This one is around 3-4 times faster } { AG }
function atoi64(const Str : UnicodeString): Int64; {$IFDEF ANDROID} overload; {$ENDIF}
var
    P : PWideChar;
begin
    Result := 0;
    P := Pointer(Str);
    if P = nil then
        Exit;
    while P^ = #$0020 do Inc(P);
    while True do
    begin
        case P^ of
            '0'..'9' : Result := Result * 10 + Ord(P^) - Ord('0');
        else
            Exit;
        end;
        Inc(P);
    end;
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCalcTickDiff(const StartTick, EndTick : LongWord): LongWord;
begin
    if EndTick >= StartTick then
        Result := EndTick - StartTick
    else
        Result := High(LongWord) - StartTick + EndTick;
end;


{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }
function StringToUtf8(const Str: UnicodeString): RawByteString; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := UnicodeToAnsi(Str, CP_UTF8, True);
end;


{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }
function StringToUtf8TB(const Str: UnicodeString): TBytes;                        { V8.71 }
var
    AString: AnsiString;
begin
    AString := StringToUtf8(Str);
    IcsMoveStringToTBytes(AString, Result, Length(AString));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ConvertCodepage(const Str: RawByteString; SrcCodePage: LongWord;
  DstCodePage: LongWord = CP_ACP): RawByteString;
var
    SBuf : array[0..2047] of WideChar;
    P    : PWideChar;
    sLen : Integer;
    dLen : Integer;
    FreeFlag : Boolean;
begin
    sLen := Length(Str);
    if (sLen = 0) or (SrcCodePage = DstCodePage) then
    begin
        Result := Str;
        Exit;
    end;
    dLen := IcsMbToWc(SrcCodePage, 0, Pointer(Str), sLen, nil, 0);
    if dLen = 0 then
    begin
        Result := '';
        Exit;
    end;
    if dLen > Length(SBuf) then
    begin
        GetMem(P, dLen * 2);
        FreeFlag := TRUE;
    end
    else begin
        FreeFlag := FALSE;
        P := SBuf;
    end;
    dLen := IcsMbToWc(SrcCodePage, 0, Pointer(Str), sLen, P, dLen);
    if dLen > 0 then
    begin
        sLen := IcsWcToMb(DstCodePage, 0, P, dLen, nil, 0, nil, nil);
        SetLength(Result, sLen);
        if sLen > 0 then
        begin
            dLen := IcsWcToMb(DstCodePage, 0, P, dLen, Pointer(Result), sLen, nil, nil);
            if dLen <> sLen then
                SetLength(Result, dLen);
        {$IFDEF COMPILER12_UP}
            if DstCodePage <> CP_ACP then
                PWord(INT_PTR(Result) - 12)^ := DstCodePage;
        {$ENDIF}
        end;
    end
    else
        Result := '';
    if FreeFlag then FreeMem(P);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StringToUtf8(const Str: RawByteString; ACodePage: LongWord = CP_ACP): RawByteString; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := ConvertCodepage(Str, ACodePage, CP_UTF8);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Utf8ToStringW(const Str: RawByteString): UnicodeString;
begin
    Result := AnsiToUnicode(Pointer(Str), Length(Str), CP_UTF8);         { V8.67 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Utf8ToStringTB(const Str: TBytes): UnicodeString;               { V9.1 }
begin
    Result := AnsiToUnicode(Pointer(Str), Length(Str), CP_UTF8);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Utf8ToStringA(const Str: RawByteString; ACodePage: LongWord = CP_ACP): AnsiString;
begin
    Result := ConvertCodepage(Str, CP_UTF8, ACodePage);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function CheckUnicodeToAnsi(const Str: UnicodeString; ACodePage: LongWord = CP_ACP): Boolean;
var
    Len : Integer;
    B   : LongBool;
begin
    Len := Length(Str);
    if Len > 0 then begin
        Len := IcsWcToMb(ACodePage, 0, Pointer(Str), Len, nil, 0, nil, @B);
        { MS-docs: For the CP_UTF7 and CP_UTF8 settings for CodePage, parameter }
        { lpUsedDefaultChar must be set to NULL. Otherwise, the function fails  }
        { with ERROR_INVALID_PARAMETER.                                         }
        if (Len = 0) and (GetLastError = ERROR_INVALID_PARAMETER) then
            Result := IcsWcToMb(ACodePage, 0, Pointer(Str),
                                          Len, nil, 0, nil, nil) > 0
        else
            Result := (not B) and (Len > 0);
    end
    else
        Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Returns size of a UTF-8 byte sequence calculated from the UTF-8 lead byte   }
{ Returns "0" if LeadByte is not valid UTF-8 lead byte.                       }
function IcsUtf8Size(const LeadByte: Byte): Integer;
begin
    case LeadByte of
        $00..$7F : Result := 1;
        $C2..$DF : Result := 2;
        $E0..$EF : Result := 3;
        $F0..$F4 : Result := 4;
    else
        Result := 0; // Invalid lead byte
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUtf8LeadByte(const B: Byte): Boolean;
begin
    Result := (B < $80) or (B in [$C2..$F4]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUtf8TrailByte(const B: Byte): Boolean;
begin
    Result := B in [$80..$BF];
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFNDEF COMPILER12_UP}
function IsLeadChar(Ch: WideChar): Boolean;
begin
    Result := (Ch >= #$D800) and (Ch <= #$DFFF);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function CharsetDetect(const Buf: Pointer; Len: Integer): TCharsetDetectResult; {$IFDEF ANDROID} overload; {$ENDIF}
var
    PEndBuf   : PByte;
    PBuf      : PByte;
    Byte2Mask : Byte;
    Ch        : Byte;
    Trailing  : Integer; // trailing (continuation) bytes to follow
begin
    PBuf        := Buf;
    PEndBuf     := Pointer(INT_PTR(Buf) + Len);
    Byte2Mask   := $00;
    Trailing    := 0;
    Result      := cdrAscii;
    while (PBuf <> PEndBuf) do
    begin
        Ch := PBuf^;
        Inc(PBuf);
        if Trailing <> 0 then
        begin
            if Ch and $C0 = $80 then // Does trailing byte follow UTF-8 format?
            begin
                if (Byte2Mask <> 0) then // Need to check 2nd byte for proper range?
                    if Ch and Byte2Mask <> 0 then // Are appropriate bits set?
                        Byte2Mask := 0
                    else begin
                        Result := cdrUnknown;
                        Exit;
                    end;
                Dec(Trailing);
                Result := cdrUtf8;
            end
            else begin
                Result := cdrUnknown;
                Exit;
            end;
        end
        else begin
            if Ch and $80 = 0 then
                Continue                      // valid 1 byte UTF-8
            else if Ch and $E0 = $C0 then     // valid 2 byte UTF-8
            begin
                if Ch and $1E <> 0 then       // Is UTF-8 byte in proper range?
                    Trailing := 1
                else begin
                    Result := cdrUnknown;
                    Exit;
                end;
            end
            else if Ch and $F0 = $E0 then     // valid 3 byte UTF-8
            begin
                if Ch and $0F = 0 then        // Is UTF-8 byte in proper range?
                    Byte2Mask := $20;         // If not set mask to check next byte
                Trailing := 2;
            end
            else if Ch and $F8 = $F0 then     // valid 4 byte UTF-8
            begin
                if Ch and $07 = 0 then        // Is UTF-8 byte in proper range?
                    Byte2Mask := $30;         // If not set mask to check next byte
                Trailing := 3;
            end
          { 4 byte is the maximum today, see ISO 10646, so let's break here }
          { else if Ch and $FC = $F8 then     // valid 5 byte UTF-8
            begin
                if Ch and $03 = 0 then        // Is UTF-8 byte in  proper range?
                    Byte2Mask := $38;         // If not set mask to check next byte
                Trailing := 4;
            end
            else if Ch and $FE = $FC then     // valid 6 byte UTF-8
            begin
                if ch and $01 = 0 then        // Is UTF-8 byte in proper range?
                    Byte2Mask := $3C;         // If not set mask to check next byte
                Trailing := 5;
            end}
            else begin
                Result := cdrUnknown;
                Exit;
            end;
        end;
    end;// while

    case Result of
      cdrUtf8, cdrAscii : if Trailing <> 0 then Result := cdrUnknown;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function CharsetDetect(const Str: RawByteString): TCharsetDetectResult; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := CharsetDetect(Pointer(Str), Length(Str));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUtf8Valid(const Str: RawByteString): Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := CharSetDetect(Pointer(Str), Length(Str)) <> cdrUnknown;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsUtf8Valid(const Buf: Pointer; Len: Integer): Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := CharSetDetect(Buf, Len) <> cdrUnknown;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ The return value is a pointer to the preceding character in the string,   }
{ or to the first character in the string if the Current parameter equals   }
{ the Start parameter.                                                      }
function IcsCharPrevUtf8(const Start, Current: PAnsiChar): PAnsiChar;
var
    Cnt : Integer;
begin
    Cnt := 0;
    Result := Current;
    while (Result > Start) and (Cnt < MAX_UTF8_SIZE) do
    begin
        Dec(Result);
        if IsUtf8LeadByte(Byte(Result^)) then
            Break;
        Inc(Cnt);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCharNextUtf8(const Str: PAnsiChar): PAnsiChar;
var
    Cnt : Integer;
begin
    Result := Str;
    if (Result = nil) or (Result^ = #0) then
        Exit;
    for Cnt := 1 to MAX_UTF8_SIZE do
    begin
        Inc(Result);
        if (Result^ = #0) or IsUtf8LeadByte(Byte(Result^)) then
            Break;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This doesn't work with stateful charsets like true MBCS. Such as          }
{ iso-2022-xy or UTF-7                                                      }
function IcsStrNextChar(const Str: PAnsiChar;
  ACodePage: LongWord = CP_ACP): PAnsiChar;
begin
    if ACodePage = CP_ACP then
        IcsGetAcp(ACodePage);
    if ACodePage = CP_UTF8 then
        Result := IcsCharNextUtf8(Str)
    else
       (*
        Result := CharNextExA(Word(ACodePage), Str, 0);
        { From Mitch Kaplan's blog                                        }
        { http://blogs.msdn.com/michkap/archive/2007/04/19/2190207.aspx): }
        { Neither CharNextExA nor CharPrevExA are broken in any version   }
        { of Windows, but neither one was designed with UTF-8 in mind.    }
        {...                                                              }
        { It is completely dependent on the behavior of IsDBCSLeadByteEx, }
        { which is an NLS function that is (for obvious reasons) only     }
        { dealing with East Asian, DBCS code page.                        }

        { Comment: Poor design isn't it? IsDBCSLeadByteEx validates lead  }
        { byte values only in code pages 932, 936, 949, 950, and 1361.    }
       *)
        if (Str <> nil) and (Str^ <> #0) then
        begin
            if IcsIsDBCSLeadByte(Str^, ACodePage) and
              (PAnsiChar(Str + 2)^ <> #0) then
                Result := Str + 2
            else
                Result := Str + 1;
        end
        else
            Result := Str;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrPrevChar(const Start, Current: PAnsiChar;
  ACodePage: LongWord = CP_ACP): PAnsiChar;
begin
    if ACodePage = CP_ACP then
        IcsGetAcp(ACodePage);
    if ACodePage = CP_UTF8 then
        Result := IcsCharPrevUtf8(Start, Current)
    else begin
        Result := Current;
        if Result - 1 >= Start then
        begin
            Dec(Result);
            if (Result - 1 >= Start) and
               IcsIsDBCSLeadByte(PAnsiChar(Result - 1)^, ACodePage) then
                Dec(Result);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrCharLength(const Str: PAnsiChar;
  ACodePage: LongWord = CP_ACP): Integer;
begin
    Result := INT_PTR(IcsStrNextChar(Str, ACodePage)) - INT_PTR(Str);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsNextCharIndex(const S: RawByteString; Index: Integer;
  ACodePage: LongWord = CP_ACP): Integer;
begin
    Assert((Index > 0) and (Index <= Length(S)));
    Result := Index + 1;
    if (ACodePage = CP_ACP) and not (S[Index] in LeadBytes) then
        Exit;
    Result := Index + IcsStrCharLength(PAnsiChar(S) + Index - 1, ACodePage);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function XDigit(Ch : WideChar) : Integer; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    case Ch of
        '0'..'9' : Result := Ord(Ch) - Ord('0');
    else
        Result := (Ord(Ch) and 15) + 9;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function XDigit(Ch : AnsiChar) : Integer; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    case Ch of
        '0'..'9' : Result := Ord(Ch) - Ord('0');
    else
        Result := (Ord(Ch) and 15) + 9;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function XDigit2(S : PChar) : Integer;
begin
    Result := 16 * XDigit(S[0]) + XDigit(S[1]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsXDigit(Ch : WideChar) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := ((Ch >= '0') and (Ch <= '9')) or
              ((Ch >= 'a') and (Ch <= 'f')) or
              ((Ch >= 'A') and (Ch <= 'F'));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsXDigit(Ch : AnsiChar) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := ((Ch >= '0') and (Ch <= '9')) or
              ((Ch >= 'a') and (Ch <= 'f')) or
              ((Ch >= 'A') and (Ch <= 'F'));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htoin(Value : PWideChar; Len : Integer) : Integer; {$IFDEF ANDROID} overload; {$ENDIF}
var
    I : Integer;
begin
    Result := 0;
    I      := 0;
    while (I < Len) and (Value[I] = ' ') do
        I := I + 1;
    while (I < len) and (IsXDigit(Value[I])) do begin
        Result := Result * 16 + XDigit(Value[I]);
        I := I + 1;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htoin(Value : PAnsiChar; Len : Integer) : Integer; {$IFDEF ANDROID} overload; {$ENDIF}
var
    I : Integer;
begin
    Result := 0;
    I      := 0;
    while (I < Len) and (Value[I] = ' ') do
        I := I + 1;
    while (I < len) and (IsXDigit(Value[I])) do begin
        Result := Result * 16 + XDigit(Value[I]);
        I := I + 1;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htoi2(Value : PWideChar) : Integer; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := htoin(Value, 2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htoi2(Value : PAnsiChar) : Integer; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := htoin(Value, 2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
const
    HexTable : array[0..15] of Char =
    ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

function IcsBufferToHex(const Buf; Size: Integer; Separator: Char): String; {$IFDEF ANDROID} overload; {$ENDIF}
const
    Fact = 3;
var
    I : Integer;
    P : PChar;
    B : PAnsiChar;
begin
    if Size <= 0 then
        Result := ''
    else begin
        SetLength(Result, (Fact * Size) - 1);
        P := PChar(Result);
        B := @Buf;
        for I := 0 to Size -1 do begin
            P[I * Fact]     := HexTable[(Ord(B[I]) shr 4) and 15];
            P[I * Fact + 1] := HexTable[Ord(B[I]) and 15];
            if (I < Size -1) then
                P[I * Fact + 2] := Separator;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsBufferToHex(const Buf; Size: Integer): String; {$IFDEF ANDROID} overload; {$ENDIF}
const
    Fact = 2;
var
    I : Integer;
    P : PChar;
    B : PAnsiChar;
begin
    if (Size <= 0) then
        Result := ''
    else begin
        SetLength(Result, (Fact * Size));
        P := PChar(Result);
        B := @Buf;
        if (NOT Assigned(B)) then  { V8.53 sanity test }
            Result := ''
        else begin
            for I := 0 to Size -1 do begin
                P[I * Fact]     := HexTable[(Ord(B[I]) shr 4) and 15];
                P[I * Fact + 1] := HexTable[Ord(B[I]) and 15];
            end;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsBufferToHex(const BufStr: AnsiString): String; overload;    { V8.53 }
begin
    Result := '';
    if Length(BufStr) > 0 then
        Result := IcsBufferToHex(BufStr[1], Length(BufStr));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsTBToHex(const BufTB: TBytes): String;                      { V9.1 }
begin
    Result := '';
    if Length(BufTB) > 0 then
        Result := IcsBufferToHex(BufTB[0], Length(BufTB));    { V9.4 fixed 1>0 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsHexToBin(const HexBuf: AnsiString): AnsiString;             { V8.53 }
var
    Source: PAnsiChar;
    I, binlen: integer;
begin
    binlen := Length(HexBuf) div 2;
    SetLength(Result, binlen);
    Source := Pointer (HexBuf) ;
    for I := 1 to binlen do begin
        Result[I] := AnsiChar(htoin(Source, 2));
        Inc (Source, 2);
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsHexToTB(const HexBuf: AnsiString): TBytes;             { V9.5 }
var
    Source: PAnsiChar;
    I, binlen, hexlen: integer;
begin
    hexlen := Length(hexBuf);
    SetLength(Result, hexlen);
    binlen := 0;
    I := 1;
    Source := Pointer (HexBuf) ;
    while (I < hexlen) do begin
        Result[binlen] := htoin(Source, 2);
        I := I + 2;
        Inc (Source, 2);
        binlen := binlen + 1;
        if HexBuf[I] = ':'  then begin   { skip colon separators }
            I := I + 1;
            Inc (Source, 1);
        end;
    end;
    SetLength(Result, binlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ break long hex string (or anything really) into groups and lines, 0=none }
function IcsFormatHexStr(const HexStr: String; GroupLen: Integer = 8; LineLen: Integer = 64): String;     { V9.1 }
var
    Len, Offset, NewLen: Integer;
begin
    Result := HexStr;
    Len := Length(HexStr);
    if (Len = 0) then
        Exit;
    if (GroupLen > 1) then begin
        Offset := 1;
        Result := '';
        while OffSet <= Length(HexStr) do begin
            if Offset > 1 then
                Result := Result + IcsSpace;
            Result := Result + Copy(HexStr, Offset, GroupLen);
            Offset := Offset + GroupLen;
        end;
    end;
    if (LineLen > 1) then begin
        NewLen := LineLen;
        if GroupLen > 0 then
            NewLen := NewLen + (LineLen div GroupLen);
        Offset := NewLen + 1;
        while OffSet <= Length(Result) do begin
            Insert(IcsCRLF, Result, Offset);
            Offset := Offset + NewLen + 2;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsCharInSysCharSet(Ch : WideChar; const ASet : TSysCharSet) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := (Ord(Ch) < 256) and (AnsiChar(Ch) in ASet);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsCharInSysCharSet(Ch : AnsiChar; const ASet : TSysCharSet) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := Ch in ASet;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsDigit(Ch : WideChar) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := (Ch >= '0') and (Ch <= '9');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsDigit(Ch : AnsiChar) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := Ch in ['0'..'9'];
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsSpace(Ch : WideChar) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := (Ch = ' ') or (Ch = #9);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsSpace(Ch : AnsiChar) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := Ch in [' ', #9];
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsCRLF(Ch : WideChar) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := (Ch = #10) or (Ch = #13);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsCRLF(Ch : AnsiChar) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := Ch in [#10, #13];
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsSpaceOrCRLF(Ch : WideChar) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := (Ch = ' ') or (Ch = #9) or (Ch = #10) or (Ch = #13);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsSpaceOrCRLF(Ch : AnsiChar) : Boolean; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := Ch in [' ', #9, #10, #13];

end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function stpblk(PValue : PWideChar) : PWideChar; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := PValue;
    while IsSpaceOrCRLF(Result^) do
        Inc(Result);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function stpblk(PValue : PAnsiChar) : PAnsiChar; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := PValue;
    while IsSpaceOrCRLF(Result^) do
        Inc(Result);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsNameThreadForDebugging(AThreadName: AnsiString; AThreadID: TThreadID);
{$IFNDEF COMPILER14_UP}
type
    TThreadNameInfo = record
        FType: LongWord;     // must be 0x1000
        FName: PAnsiChar;    // pointer to name (in user address space)
        FThreadID: LongWord; // thread ID (-1 indicates caller thread)
        FFlags: LongWord;    // reserved for future use, must be zero
    end;
var
    ThreadNameInfo: TThreadNameInfo;
begin
    if IsDebuggerPresent then
    begin
        ThreadNameInfo.FType := $1000;
        ThreadNameInfo.FName := PAnsiChar(AThreadName);
        ThreadNameInfo.FThreadID := AThreadID;
        ThreadNameInfo.FFlags := 0;
        try
            RaiseException($406D1388, 0,
                  SizeOf(ThreadNameInfo) div SizeOf(LongWord), @ThreadNameInfo);
        except
        end;
    end;
{$ELSE}
begin
    TThread.NameThreadForDebugging(AThreadName, AThreadID);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsNormalizeString(const S: UnicodeString; NormForm: TIcsNormForm): UnicodeString;
{$IFDEF MSWINDOWS}
var
    Cnt   : Integer;
    Flags : DWORD;
begin
    Result := '';
    if S = '' then
        Exit;
    if (Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion < 6) then
    begin
        { Available since D7 in Windows.pas }
        case NormForm of
            icsNormalizationD  : Flags := MAP_COMPOSITE;
            icsNormalizationC  : Flags := MAP_PRECOMPOSED;
            icsNormalizationKD : Flags := MAP_FOLDCZONE;
            icsNormalizationKC : Flags := MAP_FOLDCZONE or MAP_COMPOSITE;
            else
              Result := S;
              Exit;
        end;
        Cnt := FoldStringW(Flags, PWideChar(S), Length(S), nil, 0);
        if Cnt > 0 then
        begin
            SetLength(Result, Cnt);
            Cnt := FoldStringW(Flags, PWideChar(S), Length(S),
                               PWideChar(Result), Cnt);
            SetLength(Result, Cnt);
        end;
    end
    else begin
        { Vista+, not yet available in Windows.pas }
        if IsNormalizedString(TNormForm(NormForm), PWideChar(S), Length(S)) then
            Result := S
        else begin
            Cnt := NormalizeString(TNormForm(NormForm), PWideChar(S),
                                   Length(S), nil, 0);
            if Cnt > 0 then
            begin
                SetLength(Result, Cnt);
                Cnt := NormalizeString(TNormForm(NormForm), PWideChar(S),
                                       Length(S), PWideChar(Result), Cnt);
                SetLength(Result, Cnt);
            end;
        end;
    end;
{$ELSE MSWINDOWS}

{$IFDEF MACOS}
    function CFStringToStr(StringRef: CFStringRef): string;
    var
        Range: CFRange;
    begin
        if StringRef = nil then Exit('');
        Range := CFRangeMake(0, CFStringGetLength(StringRef));
        if Range.Length > 0 then
        begin
            SetLength(Result, Range.Length);
            CFStringGetCharacters(StringRef, Range, @Result[1]);
        end
        else
            Result := EmptyStr;
    end;

var
    MutableStringRef        : CFMutableStringRef;
    kCFStringNormalization  : Integer;
begin
    Result := '';
    if S = '' then
        Exit;
    case NormForm of
        icsNormalizationD  :
            kCFStringNormalization := kCFStringNormalizationFormD;
        icsNormalizationC  :
            kCFStringNormalization := kCFStringNormalizationFormC;
        icsNormalizationKD :
            kCFStringNormalization := kCFStringNormalizationFormKD;
        icsNormalizationKC :
            kCFStringNormalization := kCFStringNormalizationFormKC;
      else
          Result := S;
          Exit;
    end;
    MutableStringRef := CFStringCreateMutable(kCFAllocatorDefault, 0);
    try
        CFStringAppendCharacters(MutableStringRef, PWideChar(S), Length(S));
        CFStringNormalize(MutableStringRef, kCFStringNormalization);
        Result := CFStringToStr(CFStringRef(MutableStringRef));
    finally
        CFRelease(MutableStringRef);
    end;
{$ELSE MACOS}
  begin
    raise Exception.Create('Not implemented');
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCryptGenRandom(var Buf; BufSize: Integer): Boolean;
{$IFDEF MSWINDOWS}
var
    F_Acquire  : function (var hProv: THandle; pszContainer: PWideChar;
        pszProvider: PWideChar; dwProvType: DWORD; dwFlags: DWORD): BOOL; stdcall;
    F_Gen      : function (hProv: THandle; dwLen: DWORD; pbBuffer: PByte): BOOL; stdcall;
    F_Release  : function (hProv: THandle; dwFlags: ULONG_PTR): BOOL; stdcall;

    hLib       : HMODULE;
    hCryptProv : THandle;
begin
    Result := False;
    hLib := LoadLibrary(advapi32);
    if hLib <> 0 then
    begin
        @F_Acquire := GetProcAddress(hLib, 'CryptAcquireContextW');
        @F_Gen     := GetProcAddress(hLib, 'CryptGenRandom');
        @F_Release := GetProcAddress(hLib, 'CryptReleaseContext');
        if (@F_Acquire <> nil) and (@F_Gen <> nil) and (@F_Release <> nil) then
        begin
            // PROV_RSA_FULL = 1; CRYPT_VERIFYCONTEXT  = DWORD($F0000000);
            if F_Acquire(hCryptProv, nil, nil, 1, DWORD($F0000000)) then
            begin
                Result := F_Gen(hCryptProv, BufSize, @Buf);
                F_Release(hCryptProv, 0);
            end;
        end;
        FreeLibrary(hLib);
    end;
end;
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
begin
    Result := False; // ToDo
end;
{$ENDIF MACOS}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function RandSeed32: LongWord;
const
    DEFAULT_SEED32 = 2463534242;
var
    I   : Integer;
    Buf : Int64;
    Md  : TMD5Digest;
    Ctx : TMD5Context;
begin
    MD5DigestInit(Md);
    MD5Init(Ctx);

{$IFDEF MSWINDOWS}
    if QueryPerformanceCounter(Buf) then
        MD5Update(Ctx, Buf, SizeOf(Buf))
    else begin
        Buf := GetTickCount;
        MD5Update(Ctx, Buf, SizeOf(Buf));
    end;
{$ENDIF MSWINDOWS}
{$IFDEF MACOS}
    Buf := AbsoluteToNanoseconds(UpTime);
    MD5Update(Ctx, Buf, SizeOf(Buf));
{$ENDIF MACOS}
    { Add eight additional cryptographically random bytes }
    if IcsCryptGenRandom(Buf, SizeOf(Buf)) then // So far Win only
        MD5Update(Ctx, Buf, SizeOf(Buf));
    MD5Final(Md, Ctx);
    for I := Low(Md) to High(Md) - SizeOf(LongWord) do
    begin
        Result := PLongWord(@Md[I])^;
        if Result <> 0 then
            Exit;
    end;
    Result := DEFAULT_SEED32;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
//var
//    GSeed32 : LongWord = 0;   { V8.65 moved to top }

{ This makes us independent from System.Random() and we do no longer screw  }
{ up RTL's global var RandSeed by various calls to Randomize.               }
{ The PRNG below is a XorShift RNG by George Marsaglia.                     }
{ It uses one of his favorite choices, [a, b, c] = [13, 17, 5], and will    }
{ pass almost all tests of randomness, except the binary rank test in       }
{ Diehard. It is much better than System.Random() however as thread-        }
{ unsafe as System.Random() is. See also PrngTst.dpr in MiscDemos.    AG    }
function IcsRandomInt(const ARange: Integer): Integer;
var
    x : LongWord;
begin
    if GSeed32 = 0 then
        x := RandSeed32  // MUST be <> 0
    else
        x := GSeed32;
    x := x xor (x shl 13);
    x := x xor (x shr 17);
    x := x xor (x shl 5);
    GSeed32 := x;
    Result := (UInt64(LongWord(ARange)) * UInt64(x)) shr 32;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileUtcModified(const FileName : String) : TDateTime;
var
    SearchRec : TSearchRec;
    Status    : Integer;
{$IFDEF POSIX}
    LUT       : tm;
{$ENDIF}
{$IFDEF MSWINDOWS}
    LInt64    : Int64;
const
    FileTimeBase = -109205.0;   // days between years 1601 and 1900
    FileTimeStep: Extended = 24.0 * 60.0 * 60.0 * 1000.0 * 1000.0 * 10.0; // 100 nsec per Day
{$ENDIF}
begin
    Status := FindFirst(FileName, faAnyFile, SearchRec);
    try
        if Status <> 0 then
            Result := 0
        else begin
          {$IFDEF MSWINDOWS}
            Move(SearchRec.FindData.ftLastWriteTime, LInt64, SizeOf(LInt64));
            Result := (LInt64 / FileTimeStep) + FileTimeBase;
          {$ENDIF}
          {$IFDEF POSIX}
            gmtime_r(SearchRec.Time, LUT);
            Result := EncodeDate(LUT.tm_year + 1900, LUT.tm_mon + 1, LUT.tm_mday) +
                      EncodeTime(LUT.tm_hour, LUT.tm_min, LUT.tm_sec, 0);
          {$ENDIF}
        end;
    finally
        FindClose(SearchRec);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsInterlockedCompareExchange(
    var Destination : Pointer;
    Exchange        : Pointer;
    Comperand       : Pointer): Pointer;
begin
{$IFDEF COMPILER12_UP}
  {$IFDEF COMPILER16_UP}
    Result := TInterlocked.CompareExchange(Destination, Exchange, Comperand);
  {$ELSE}
    Result := InterlockedCompareExchangePointer(Destination, Exchange, Comperand);
  {$ENDIF}
{$ELSE}
  {$IFDEF COMPILER10_UP} // Possibly even COMPILER9_UP - Delphi 2005?
    Result := Pointer(InterlockedCompareExchange(Integer(Destination),
                                        Integer(Exchange), Integer(Comperand)));
  {$ELSE} { Delphi 7 }
    Result := InterlockedCompareExchange(Destination, Exchange, Comperand);
  {$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsFindCloseW(var F: TIcsSearchRecW);
begin
{$IFDEF COMPILER12_UP}
    {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FindClose(F);
{$ELSE}
    if F.FindHandle <> INVALID_HANDLE_VALUE then
    begin
        Windows.FindClose(F.FindHandle);
        F.FindHandle := INVALID_HANDLE_VALUE;
    end;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFNDEF COMPILER12_UP}
function IcsFindMatchingFileW(var F: TIcsSearchRecW): Integer;
var
    LocalFileTime : TFileTime;
begin
    with F do
    begin
        while FindData.dwFileAttributes and ExcludeAttr <> 0 do
            if not FindNextFileW(FindHandle, FindData) then
        begin
            Result := GetLastError;
            Exit;
        end;
        FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
        FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi, LongRec(Time).Lo);
        Size := FindData.nFileSizeLow;
        Attr := FindData.dwFileAttributes;
        Name := FindData.cFileName;
    end;
    Result := 0;
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFindNextW(var F: TIcsSearchRecW): Integer;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FindNext(F);
{$ELSE}
    if FindNextFileW(F.FindHandle, F.FindData) then
        Result := IcsFindMatchingFileW(F)
    else
        Result := GetLastError;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFindFirstW(const Path: UnicodeString; Attr: Integer;
  var  F: TIcsSearchRecW): Integer; overload;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FindFirst(Path, Attr, F);
{$ELSE}
const
    faSpecial = faHidden or faSysFile or faDirectory;
begin
    F.ExcludeAttr := not Attr and faSpecial;
    F.FindHandle := FindFirstFileW(PWideChar(Path), F.FindData);
    if F.FindHandle <> INVALID_HANDLE_VALUE then
    begin
        Result := IcsFindMatchingFileW(F);
        if Result <> 0 then IcsFindCloseW(F);
    end else
        Result := GetLastError;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFindFirstW(const Utf8Path: UTF8String; Attr: Integer;
  var  F: TIcsSearchRecW): Integer; overload;
begin
    Result := IcsFindFirstW(AnsiToUnicode(Utf8Path, CP_UTF8), Attr, F);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCreateDirW(const Dir: UnicodeString): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.CreateDir(Dir);
{$ELSE}
    Result := CreateDirectoryW(PWideChar(Dir), nil);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCreateDirW(const Utf8Dir: UTF8String): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.CreateDir(Utf8Dir);
{$ELSE}
    Result := CreateDirectoryW(PWideChar(AnsiToUnicode(Utf8Dir, CP_UTF8)), nil);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsForceDirectoriesW(Dir: UnicodeString): Boolean; overload;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.ForceDirectories(Dir);
{$ELSE}
var
    E: EInOutError;
begin
    Result := True;
    if Length(Dir) = 0 then
    begin
        E := EInOutError.CreateRes(@SCannotCreateDir);
        E.ErrorCode := 3;
        raise E;
    end;
    Dir := IcsExcludeTrailingPathDelimiterW(Dir);
    if (Length(Dir) < 3) or IcsDirExistsW(Dir)
        or (IcsExtractFilePathW(Dir) = Dir) then Exit;
    Result := IcsForceDirectoriesW(IcsExtractFilePathW(Dir)) and IcsCreateDirW(Dir);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsForceDirectoriesW(Utf8Dir: UTF8String): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.ForceDirectories(Utf8Dir);
{$ELSE}
    Result := IcsForceDirectoriesW(AnsiToUnicode(Utf8Dir, CP_UTF8));
{$ENDIF}
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDirExists(const FileName: String): Boolean;                                  { V8.67 }
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.DirectoryExists(FileName);
{$ELSE}
var
    Res : DWord;
begin
    Res := GetFileAttributes(PChar(FileName));
    Result := (Res <> INVALID_HANDLE_VALUE) and
              ((Res and FILE_ATTRIBUTE_DIRECTORY) <> 0);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDirExistsW(const FileName: PWideChar): Boolean; overload;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.DirectoryExists(UnicodeString(FileName));
{$ELSE}
var
    Res : DWord;
begin
    Res := GetFileAttributesW(FileName);
    Result := (Res <> INVALID_HANDLE_VALUE) and
              ((Res and FILE_ATTRIBUTE_DIRECTORY) <> 0);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDirExistsW(const FileName: UnicodeString): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.DirectoryExists(FileName);
{$ELSE}
    Result := IcsDirExistsW(PWideChar(FileName));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDirExistsW(const Utf8FileName: UTF8String): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.DirectoryExists(Utf8FileName);
{$ELSE}
    Result := IcsDirExistsW(PWideChar(AnsiToUnicode(Utf8FileName, CP_UTF8)));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF MSWINDOWS}
function RtlCompareUnicodeString(String1, String2: PUnicode_String;
  CaseInSensitive: Boolean): Integer; stdcall;
begin
    { Supported OS: NT4 and better! }
    if _RtlCompareUnicodeString = nil then
    begin
        if hNtDll = 0 then
        begin
            hNtDll := GetModuleHandle('ntdll.dll');
            if hNtDll = 0 then
                RaiseLastOsError;
        end;
        _RtlCompareUnicodeString := GetProcAddress(hNtDll, 'RtlCompareUnicodeString');
        if _RtlCompareUnicodeString = nil then
            RaiseLastOsError;
    end;
    Result := TRtlCompareUnicodeString(_RtlCompareUnicodeString)(
                                        String1, String2, CaseInsensitive);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Borrowed from Jordan Russell }
function IcsStrCompOrdinalW(Str1: PWideChar; Str1Length: Integer;
  Str2: PWideChar; Str2Length: Integer; IgnoreCase: Boolean): Integer;
var
    S1, S2: TUnicode_String;
    Len: Integer;
begin
    S1.Buffer := Str1;
    S2.Buffer := Str2;
    while True do
    begin
        if Str1Length <= Str2Length then
            Len := Str1Length
        else
            Len := Str2Length;
        if Len <= 0 then
            Break;
        // Can only process 32K characters at a time
        if Len > $7FF0 then
            Len := $7FF0;

        S1.Length        := Len * 2;   // Length is in bytes
        S1.MaximumLength := S1.Length;
        S2.Length        := S1.Length;
        S2.MaximumLength := S1.Length;
        Result := RtlCompareUnicodeString(@S1, @S2, IgnoreCase);
        if Result <> 0 then
            Exit;

        Dec(Str1Length, Len);
        Dec(Str2Length, Len);
        Inc(S1.Buffer, Len);
        Inc(S2.Buffer, Len);
    end;
    Result := Str1Length - Str2Length;
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsAnsiCompareFileNameW(const S1, S2: UnicodeString): Integer; overload;
begin
{$IFDEF MSWINDOWS}
    Result := IcsStrCompOrdinalW(PWideChar(S1), Length(S1), PWideChar(S2),
                             Length(S2), True);
{$ELSE}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.AnsiCompareFileName(S1, S2);  { V8.08 }
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsAnsiCompareFileNameW(const Utf8S1, Utf8S2: UTF8String): Integer; overload;
begin
    Result := IcsAnsiCompareFileNameW(AnsiToUnicode(Utf8S1, CP_UTF8),
                                      AnsiToUnicode(Utf8S2, CP_UTF8));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrAllocW(Len: Cardinal): PWideChar;
begin
    Len := (Len * 2) + 4;
    GetMem(Result, Len);
    FillChar(Result^, Len, #0);
    Cardinal(Pointer(Result)^) := Len;
    Inc(Result, 2);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrScanW(const Str: PWideChar; Ch: WideChar): PWideChar;
begin
    Result := Str;
    while Result^ <> Ch do
    begin
        if Result^ = #0 then
        begin
            Result := nil;
            Exit;
        end;
        Inc(Result);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIsDelimiterW(const Delimiters: PWideChar;
  S : UnicodeString; Index: Integer): Boolean;
begin
    Result := False;
    if (Index <= 0) or (Index > Length(S)) then
        Exit;
    Result := IcsStrScanW(Delimiters, S[Index]) <> nil;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsLastDelimiterW(const Delimiters: PWideChar;
  S: UnicodeString): Integer;
begin
    Result := Length(S);
    while Result >= 0 do
    begin
        if (S[Result] <> #0) and (IcsStrScanW(Delimiters, S[Result]) <> nil) then
            Exit;
        Dec(Result);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsMakeLongLong(L, H: LongWord): Int64;  { V8.65 }
begin
    Result := L or H shl 32;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsMakeLong(L, H: Word): Integer;  { V8.65 }
begin
    Result := L or H shl 16;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsMakeWord(L, H: Byte): Word;
begin
    Result := L or H shl 8;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsHiWord(LW: LongWord): Word;
begin
    Result := LW shr 16;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsLoWord(LW: LongWord): Word;
begin
    Result := Word(LW);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsHiByte(W: Word): Byte;
begin
    Result := W shr 8;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsLoByte(W: Word): Byte;
begin
    Result := Byte(W);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsCheckOSError(ALastError: Integer);
var
    Error: EOSError;
begin
    if ALastError <> 0 then begin
        Error := EOSError.CreateResFmt(@SOSError, [ALastError,
                                       SysErrorMessage(ALastError)]);
        Error.ErrorCode := ALastError;
        raise Error;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Author Arno Garrels - Needs optimization!      }
{ It's a bit slower that the RTL routine.        }
{ We should realy use a FastCode function here.  }
function IntToStrA(N : Integer) : AnsiString;
var
    I : Integer;
    Buf : array [0..11] of AnsiChar;
    Sign : Boolean;
begin
    if N >= 0 then
        Sign := FALSE
    else begin
        Sign := TRUE;
        if N = Low(Integer) then
        begin
            Result := '-2147483648';
            Exit;
        end
        else
            N := Abs(N);
    end;
    I := Length(Buf);
    repeat
        Dec(I);
        Buf[I] := AnsiChar(N mod 10 + $30);
        N := N div 10;
    until N = 0;
    if Sign then begin
        Dec(I);
        Buf[I] := '-';
    end;
    SetLength(Result, Length(Buf) - I);
    Move(Buf[I], Pointer(Result)^, Length(Buf) - I);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIntToStrA(N : Integer) : AnsiString;
begin
{$IFDEF USE_ICS_RTL}
    Result := IntToStrA(N);
{$ELSE}
{$IFNDEF COMPILER12_UP}
    Result := SysUtils.IntToStr(N);
{$ELSE}
    Result := IntToStrA(N);
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Author Arno Garrels - Feel free to optimize!                }
{ It's anyway faster than the RTL routine.                    }
function IntToHexA(N : Integer; Digits: Byte) : AnsiString;
var
    Buf : array [0..7] of Byte;
    V : Cardinal;
    I : Integer;
begin
    V := Cardinal(N);
    I := Length(Buf);
    if Digits > I then Digits := I;
    repeat
        Dec(I);
        Buf[I] := V mod 16;
        if Buf[I] < 10 then
            Inc(Buf[I], $30)
        else
            Inc(Buf[I], $37);
        V := V div 16;
    until V = 0;
    while Digits > Length(Buf) - I do begin
       Dec(I);
       Buf[I] := $30;
    end;
    SetLength(Result, Length(Buf) - I);
    Move(Buf[I], Pointer(Result)^, Length(Buf) - I);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIntToHexA(N : Integer; Digits: Byte) : AnsiString;
begin
{$IFDEF USE_ICS_RTL}
    Result := IntToHexA(N, Digits);
{$ELSE}
{$IFNDEF COMPILER12_UP}
    Result := SysUtils.IntToHex(N, Digits);
{$ELSE}
    Result := IntToHexA(N, Digits);
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Author Arno Garrels - Feel free to optimize!                }
{ It's a bit faster than the RTL routine.                     }
function IcsTrimA(const Str: AnsiString): AnsiString;
var
    I, L : Integer;
begin
    L := Length(Str);
    I := 1;
    while (I <= L) and (Str[I] <= ' ') do
        Inc(I);
    if I > L then
        Result := ''
    else begin
        while Str[L] <= ' ' do
            Dec(L);
        SetLength(Result, L - I + 1);
        Move(Str[I], Pointer(Result)^, L - I + 1);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsTrim(const Str: AnsiString): AnsiString; overload;
begin
{$IFDEF USE_ICS_RTL}
    Result := IcsTrimA(Str);
{$ELSE}
{$IFNDEF COMPILER12_UP}
    Result := SysUtils.Trim(Str);
{$ELSE}
    Result := IcsTrimA(Str);
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF COMPILER12_UP}
function IcsTrim(const Str : UnicodeString) : UnicodeString; overload;
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.Trim(Str);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Author Arno Garrels - Feel free to optimize!                }
{ It's anyway faster than the RTL routine.                    }
function IcsLowerCaseA(const S: AnsiString): AnsiString;
var
    Ch : AnsiChar;
    L, I  : Integer;
    Source, Dest: PAnsiChar;
begin
    L := Length(S);
    if L = 0  then
        Result := ''
    else begin
        SetLength(Result, L);
        Source := Pointer(S);
        Dest := Pointer(Result);
        for I := 1 to L do begin
            Ch := Source^;
            if Ch in ['A'..'Z'] then Inc(Ch, 32);
            Dest^ := Ch;
            Inc(Source);
            Inc(Dest);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsLowerCase(const S: AnsiString): AnsiString; overload;
begin
{$IFDEF USE_ICS_RTL}
    Result := IcsLowerCaseA(S);
{$ELSE}
{$IFNDEF COMPILER12_UP}
    Result := SysUtils.LowerCase(S);
{$ELSE}
    Result := IcsLowerCaseA(S);
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF COMPILER12_UP}
function IcsLowerCase(const S: UnicodeString): UnicodeString; overload;
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.LowerCase(S);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Author Arno Garrels - Feel free to optimize!                }
{ It's anyway faster than the RTL routine.                    }
function IcsUpperCaseA(const S: AnsiString): AnsiString;
var
    Ch : AnsiChar;
    L, I : Integer;
    Source, Dest: PAnsiChar;
begin
    L := Length(S);
    if L = 0  then
        Result := ''
    else begin
        SetLength(Result, L);
        Source := Pointer(S);
        Dest := Pointer(Result);
        for I := 1 to L do begin
            Ch := Source^;
            if Ch in ['a'..'z'] then Dec(Ch, 32);
            Dest^ := Ch;
            Inc(Source);
            Inc(Dest);
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsUpperCase(const S: AnsiString): AnsiString; overload;
begin
{$IFDEF USE_ICS_RTL}
    Result := IcsUpperCaseA(S);
{$ELSE}
{$IFNDEF COMPILER12_UP}
    Result := SysUtils.UpperCase(S);
{$ELSE}
    Result := IcsUpperCaseA(S);
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF COMPILER12_UP}
function IcsUpperCase(const S: UnicodeString): UnicodeString; overload;
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.UpperCase(S);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsSameTextA(const S1, S2: AnsiString): Boolean;
begin
    Result := (IcsCompareTextA(S1, S2) = 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Author Arno Garrels - Feel free to optimize!                }
{ It's anyway faster than the RTL routine.                    }
function IcsCompareTextA(const S1, S2: AnsiString): Integer;
var
    L1, L2, I : Integer;
    MinLen : Integer;
    Ch1, Ch2 : AnsiChar;
    P1, P2 : PAnsiChar;
begin
    L1 := Length(S1);
    L2 := Length(S2);
    if L1 > L2 then
        MinLen := L2
    else
        MinLen := L1;
    P1 := Pointer(S1);
    P2 := Pointer(S2);
    for I := 0 to MinLen -1 do
    begin
        Ch1 := P1[I];
        Ch2 := P2[I];
        if (Ch1 <> Ch2) then
        begin
            { Strange, but this is how the original works, }
            { for instance, "a" is smaller than "[" .      }
            if (Ch1 > Ch2) then
            begin
                if Ch1 in ['a'..'z'] then
                    Dec(Byte(Ch1), 32);
            end
            else begin
                if Ch2 in ['a'..'z'] then
                    Dec(Byte(Ch2), 32);
            end;
        end;
        if (Ch1 <> Ch2) then
        begin
            Result := Byte(Ch1) - Byte(Ch2);
            Exit;
        end;
    end;
    Result := L1 - L2;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCompareText(const S1, S2: AnsiString): Integer; overload;
begin
{$IFDEF USE_ICS_RTL}
    Result := IcsCompareTextA(S1, S2);
{$ELSE}
{$IFNDEF COMPILER12_UP}
    Result := SysUtils.CompareText(S1, S2);
{$ELSE}
    Result := IcsCompareTextA(S1, S2);
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF COMPILER12_UP}
function IcsCompareText(const S1, S2: UnicodeString): Integer; overload;
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.CompareText(S1, S2);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCompareStrA(const S1, S2: AnsiString): Integer;
var
    L1, L2, I : Integer;
    MinLen    : Integer;
    P1, P2    : PAnsiChar;
begin
    L1 := Length(S1);
    L2 := Length(S2);
    if L1 > L2 then
        MinLen := L2
    else
        MinLen := L1;
    P1 := Pointer(S1);
    P2 := Pointer(S2);
    for I := 0 to MinLen -1 do
    begin
        if (P1[I] <> P2[I]) then
        begin
            Result := Ord(P1[I]) - Ord(P2[I]);
            Exit;
        end;
    end;
    Result := L1 - L2;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsCompareStr(const S1, S2: AnsiString): Integer; overload;
begin
{$IFDEF USE_ICS_RTL}
    Result := IcsCompareStrA(S1, S2);
{$ELSE}
{$IFNDEF COMPILER12_UP}
    Result := SysUtils.CompareStr(S1, S2);
{$ELSE}
    Result := IcsCompareStrA(S1, S2);
{$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF COMPILER12_UP}
function IcsCompareStr(const S1, S2: UnicodeString): Integer; overload;
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.CompareStr(S1, S2);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrLen(const Str: PAnsiChar): Cardinal; overload;
begin
{$IFDEF COMPILER18_UP}
  Result := System.AnsiStrings.StrLen(Str);
{$ELSE}
  Result := StrLen(Str);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF COMPILER12_UP}
function IcsStrLen(const Str: PWideChar): Cardinal; overload;
begin
  Result := StrLen(Str);
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrPas(const Str: PAnsiChar): AnsiString; overload;
begin
  Result := Str;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF COMPILER12_UP}
function IcsStrPas(const Str: PWideChar): string; overload;
begin
  Result := Str;
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrCopy(Dest: PAnsiChar; const Source: PAnsiChar): PAnsiChar; overload;
begin
{$IFDEF COMPILER18_UP}
  Result := System.AnsiStrings.StrCopy(Dest, Source);
{$ELSE}
  Result := StrCopy(Dest, Source);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF COMPILER12_UP}
function IcsStrCopy(Dest: PWideChar; const Source: PWideChar): PWideChar; overload;
begin
  Result := StrCopy(Dest, Source);
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrPCopy(Dest: PChar; const Source: string): PChar; overload;
begin
  Result := StrLCopy(Dest, PChar(Source), Length(Source));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF COMPILER12_UP}
function IcsStrPCopy(Dest: PAnsiChar; const Source: AnsiString): PAnsiChar; overload;
begin
{$IFDEF COMPILER18_UP}
  Result := System.AnsiStrings.StrLCopy(Dest, PAnsiChar(Source), Length(Source));
{$ELSE}
  Result := StrLCopy(Dest, PAnsiChar(Source), Length(Source));
{$ENDIF}
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrPLCopy(Dest: PChar; const Source: String; MaxLen: Cardinal): PChar; overload;
begin
  Result := StrPLCopy(Dest, PChar(Source), MaxLen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF COMPILER12_UP}
function IcsStrPLCopy(Dest: PAnsiChar; const Source: AnsiString; MaxLen: Cardinal): PAnsiChar; overload;
begin
{$IFDEF COMPILER18_UP}
  Result := System.AnsiStrings.StrLCopy(Dest, PAnsiChar(Source), MaxLen);
{$ELSE}
  Result := StrLCopy(Dest, PAnsiChar(Source), MaxLen);
{$ENDIF}
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractFilePathW(const FileName: UnicodeString): UnicodeString;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.ExtractFilePath(FileName);
{$ELSE}
var
    I: Integer;
begin
    I := IcsLastDelimiterW(IcsPathDriveDelimW, FileName);
    Result := Copy(FileName, 1, I);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractFileDirW(const FileName: UnicodeString): UnicodeString;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.ExtractFileDir(FileName);
{$ELSE}
var
    I: Integer;
begin
    I := IcsLastDelimiterW(IcsPathDriveDelimW, Filename);
    if (I > 1) and (FileName[I] = IcsPathDelimW) and
    (not IcsIsDelimiterW(IcsPathDriveDelimW, FileName, I - 1)) then
      Dec(I);
    Result :=Copy(FileName, 1, I);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractFileDriveW(const FileName: UnicodeString): UnicodeString;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.ExtractFileDrive(FileName);
{$ELSE}
var
    I, J: Integer;
    Len : Integer;
begin
    Len := Length(FileName);
    if (Len >= 2) and (FileName[2] = DriveDelim) then
        Result := Copy(FileName, 1, 2)
    else if (Len >= 2) and (FileName[1] = PathDelim) and
            (FileName[2] = PathDelim) then
    begin
        J := 0;
        I := 3;
        while (I < Len) and (J < 2) do
        begin
            if FileName[I] = PathDelim then
                Inc(J);
            if J < 2 then
                Inc(I);
        end;
        if FileName[I] = PathDelim then
            Dec(I);
        Result := Copy(FileName, 1, I);
    end
    else
        Result := '';
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractFileNameW(const FileName: UnicodeString): UnicodeString;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.ExtractFileName(FileName);
{$ELSE}
var
    I: Integer;
begin
    I := IcsLastDelimiterW(IcsPathDriveDelimW, FileName);
    Result := Copy(FileName, I + 1, MaxInt);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractFileExtW(const FileName: UnicodeString): UnicodeString;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.ExtractFileExt(FileName);
{$ELSE}
const
    Delim : PWideChar = '.\:';
var
    I: Integer;
begin
    I := IcsLastDelimiterW(Delim, FileName);
    if (I > 0) and (FileName[I] = '.') then
        Result := Copy(FileName, I, MaxInt)
    else
        Result := '';
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractNameOnlyW(FileName: UnicodeString): UnicodeString; // angus
var
    I: Integer;

    function IsPathSep (Ch: WideChar): Boolean;
    begin
        Result := (Ch = IcsPathDelimW)
          {$IFDEF MSWINDOWS} or (Ch = IcsDriveDelimW) {$ENDIF} or (Ch = '.');
    end;

begin
    FileName := IcsExtractFileNameW (FileName);  // remove path
    I := Length(FileName);
    while (I > 0) and not (IsPathSep (FileName[I])) do Dec(I);  // find .
    if (I = 0) or (FileName[I] <> '.') then I := MaxInt;
    Result := Copy(FileName, 1, I - 1) ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsChangeFileExtW(const FileName, Extension: UnicodeString): UnicodeString;  // angus
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.ChangeFileExt(FileName, Extension);
{$ELSE}
const
    Delim : PWideChar = '.\:';
var
    I: Integer;
begin
    I := IcsLastDelimiterW(Delim, Filename);
    if (I = 0) or (FileName[I] <> '.') then I := MaxInt;
    Result := Copy(FileName, 1, I - 1) + Extension;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsStrLenW(Str: PWideChar): Cardinal;
var
    BeginP : Pointer;
begin
    Result := 0;
    if Str <> nil then
    begin
        BeginP := Str;
        while Str^ <> #0 do
            Inc(Str);
        Result := (INT_PTR(Str) - INT_PTR(BeginP)) div 2;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExpandFileNameW(const FileName: UnicodeString): UnicodeString;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.ExpandFileName(FileName);
{$ELSE}
var
    Name: PWideChar;
    Buf: array[0..MAX_PATH - 1] of WideChar;
begin
    if GetFullPathNameW(PWideChar(FileName), Length(Buf), @Buf[0], Name) > 0 then
    begin
        SetLength(Result, IcsStrLenW(Buf));
        Move(Buf, Result[1], IcsStrLenW(Buf) * 2);
    end
    else
        Result := '';
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIncludeTrailingPathDelimiterW(const S : UnicodeString): UnicodeString;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.IncludeTrailingPathDelimiter(S);
{$ELSE}
    if (Length(S) > 0) and (S[Length(S)] <> IcsPathDelimW) then
        Result := S + IcsPathDelimW
    else
        Result := S;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExcludeTrailingPathDelimiterW(const S : UnicodeString): UnicodeString;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.ExcludeTrailingPathDelimiter(S);
{$ELSE}
    Result := S;
    if (Length(S) > 0) and (S[Length(S)] = IcsPathDelimW) then
        SetLength(Result, Length(Result) -1);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDeleteFileW(const FileName: UnicodeString): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.DeleteFile(FileName);
{$ELSE}
    Result := Windows.DeleteFileW(PWideChar(FileName));
{$ENDIF}
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractLastDir (const Path: RawByteString): RawByteString ; overload;   // angus
var
    I, Len: integer;
begin
    Len := Length (Path);
    if Path [Len] = IcsPathDelimA then Dec (Len) ;
    for I := Len downto 1 do begin
        if Path [I] = IcsPathDelimA then begin
            Result := Copy (Path, I + 1, Len - I);
            exit;
        end;
    end;
    Result := Copy (Path, 1, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsExtractLastDir (const Path: UnicodeString): UnicodeString ; overload;    // angus
var
    I, Len: integer;
begin
    Len := Length (Path);
    if Path [Len] = IcsPathDelimW then Dec (Len) ;
    for I := Len downto 1 do begin
        if Path [I] = IcsPathDelimW then begin
            Result := Copy (Path, I + 1, Len - I);
            exit;
        end;
    end;
    Result := Copy (Path, 1, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDeleteFileW(const Utf8FileName: UTF8String): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.DeleteFile(Utf8FileName);
{$ELSE}
    Result := Windows.DeleteFileW(PWideChar(AnsiToUnicode(Utf8FileName, CP_UTF8)));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF MSWINDOWS}
function IcsFileGetAttrW(const FileName: UnicodeString): Integer;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileGetAttr(FileName);
{$ELSE}
    Result := GetFileAttributesW(PWideChar(FileName));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileGetAttrW(const Utf8FileName: UTF8String): Integer;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileGetAttr(Utf8FileName);
{$ELSE}
    Result := GetFileAttributesW(PWideChar(AnsiToUnicode(Utf8FileName, CP_UTF8)));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileSetAttrW(const FileName: UnicodeString; Attr: Integer): Integer;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileSetAttr(FileName, Attr);
{$ELSE}
    Result := 0;
    if not SetFileAttributesW(PWideChar(FileName), Attr) then
        Result := GetLastError;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileSetAttrW(const Utf8FileName: UTF8String; Attr: Integer): Integer;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileSetAttr(Utf8FileName, Attr);
{$ELSE}
    Result := 0;
    if not SetFileAttributesW(PWideChar(AnsiToUnicode(Utf8FileName, CP_UTF8)), Attr) then
        Result := GetLastError;
{$ENDIF}
end;
{$ENDIF MSWINDOWS}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileCreateW(const FileName: UnicodeString):
  {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileCreate(FileName);
{$ELSE}
    Result := Integer(CreateFileW(PWideChar(FileName),
                                  GENERIC_READ or GENERIC_WRITE,
                                  0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileCreateW(const Utf8FileName: UTF8String):
  {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileCreate(Utf8FileName);
{$ELSE}
    Result := IcsFileCreateW(AnsiToUnicode(Utf8FileName, CP_UTF8));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileCreateW(const FileName: UnicodeString; Rights: LongWord):
  {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileCreate(FileName, Rights);
{$ELSE}
    Result := IcsFileCreateW(FileName);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileCreateW(const Utf8FileName: UTF8String; Rights: LongWord):
  {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileCreate(Utf8FileName, Rights);
{$ELSE}
    Result := IcsFileCreateW(AnsiToUnicode(Utf8FileName, CP_UTF8));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileOpenW(const FileName: UnicodeString; Mode: LongWord):
  {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; overload;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileOpen(FileName, Mode);
{$ELSE}
const
    AccessMode: array[0..2] of LongWord = (
                                            GENERIC_READ,
                                            GENERIC_WRITE,
                                            GENERIC_READ or GENERIC_WRITE);
    ShareMode: array[0..4] of LongWord = (
                                            0,
                                            0,
                                            FILE_SHARE_READ,
                                            FILE_SHARE_WRITE,
                                            FILE_SHARE_READ or FILE_SHARE_WRITE);
begin
    Result := -1;
    if ((Mode and 3) <= fmOpenReadWrite) and
       ((Mode and $F0) <= fmShareDenyNone) then
    Result := Integer(CreateFileW(PWideChar(FileName),
                      AccessMode[Mode and 3],
                      ShareMode[(Mode and $F0) shr 4], nil, OPEN_EXISTING,
                      FILE_ATTRIBUTE_NORMAL, 0));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

function IcsFileOpenW(const Utf8FileName: UTF8String; Mode: LongWord):
  {$IFDEF COMPILER16_UP} THandle {$ELSE} Integer {$ENDIF}; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileOpen(Utf8FileName, Mode);
{$ELSE}
    Result := IcsFileOpenW(AnsiToUnicode(Utf8FileName, CP_UTF8), Mode);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsRemoveDirW(const Dir: UnicodeString): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.RemoveDir(Dir);
{$ELSE}
    Result := RemoveDirectoryW(PWideChar(Dir));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsRemoveDirW(const Utf8Dir: UTF8String): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.RemoveDir(Utf8Dir);
{$ELSE}
    Result := RemoveDirectoryW(PWideChar(AnsiToUnicode(Utf8Dir, CP_UTF8)));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsRenameFileW(const OldName, NewName: UnicodeString): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.RenameFile(OldName, NewName);
{$ELSE}
    Result := MoveFileW(PWideChar(OldName), PWideChar(NewName));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsRenameFileW(const Utf8OldName, Utf8NewName: UTF8String): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.RenameFile(Utf8OldName, Utf8NewName);
{$ELSE}
    Result := MoveFileW(PWideChar(AnsiToUnicode(Utf8OldName, CP_UTF8)),
                        PWideChar(AnsiToUnicode(Utf8NewName, CP_UTF8)));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileAgeW(const FileName: UnicodeString): Integer; overload;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileAge(FileName);
{$ELSE}
var
    Handle        : THandle;
    FindData      : TWin32FindDataW;
    LocalFileTime : TFileTime;
begin
    Handle := FindFirstFileW(PWideChar(FileName), FindData);
    if Handle <> INVALID_HANDLE_VALUE then
    begin
        Windows.FindClose(Handle);
        if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
        begin
            FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
            if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi,
                LongRec(Result).Lo) then Exit;
        end;
    end;
    Result := -1;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileAgeW(const Utf8FileName: UTF8String): Integer; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileAge(Utf8FileName);
{$ELSE}
    Result := IcsFileAgeW(AnsiToUnicode(Utf8FileName, CP_UTF8));
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileExistsW(const FileName: UnicodeString): Boolean; overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileExists(FileName);
{$ELSE}
    Result := IcsFileAgeW(FileName) <> -1;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileExistsW(const Utf8FileName: UTF8String): Boolean;overload;
begin
{$IFDEF COMPILER12_UP}
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FileExists(Utf8FileName);
{$ELSE}
    Result := IcsFileAgeW(Utf8FileName) <> -1;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF MSWINDOWS}
function FileTimeToInt64 (const FileTime: TFileTime): Int64 ;    { V8.49 moved from FtpSrvT }
begin
    Move (FileTime, Result, SizeOf (Result));    // 29 Sept 2004, poss problem with 12/00 mixup
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Int64ToFileTime (const FileTime: Int64): TFileTime ;     { V8.49 moved from FtpSrvT }
begin
    Move (FileTime, Result, SizeOf (Result));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
const
  FileTimeBase = -109205.0;   // days between years 1601 and 1900
  FileTimeStep: Extended = 24.0 * 60.0 * 60.0 * 1000.0 * 1000.0 * 10.0; // 100 nsec per Day


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function FileTimeToDateTime(const FileTime: TFileTime): TDateTime;    { V8.49 moved from FtpSrvT }
begin
    Result := FileTimeToInt64 (FileTime) / FileTimeStep ;
    Result := Result + FileTimeBase ;
end;
{$ENDIF MSWINDOWS}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ get file written UTC DateTime and size in bytes - no change for summer time }
function IcsGetUAgeSizeFile (const FileName: string; var FileUDT: TDateTime;
                                                    var FSize: Int64): boolean;   { V8.49 moved from FtpSrvT }
var
    SResult: integer ;
    SearchRec: TSearchRec ;
    LongFile: String;    { V8.70 support paths longer than 254 odd }
{$IFDEF MSWINDOWS}
   TempSize: ULARGE_INTEGER; { V8.42 was TULargeInteger } { 64-bit integer record }
{$ENDIF}
begin
    Result := FALSE ;
    FSize := -1;
    FileUDT := 0;   { V8.51 }
    LongFile := IcsAddLongPath(FileName);                         { V8.70 }
    SResult := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FindFirst(LongFile, faAnyFile, SearchRec);
    if SResult = 0 then begin
     {$IFDEF MSWINDOWS}
        TempSize.QuadPart := 0;  { V9.5 }
        TempSize.LowPart  := SearchRec.FindData.nFileSizeLow ;
        TempSize.HighPart := SearchRec.FindData.nFileSizeHigh ;
        FSize             := Int64(TempSize.QuadPart);  { V9.5 unsigned to signed cast }
        FileUDT := FileTimeToDateTime (SearchRec.FindData.ftLastWriteTime);
      {$ENDIF}
      {$IFDEF POSIX}
        FSize := SearchRec.Size;
        FileUDT := SearchRec.TimeStamp;
      {$ENDIF}
        Result            := TRUE ;
    end;
    {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.FindClose(SearchRec);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetFileSize(const FileName : String) : Int64;            { V8.49 moved from FtpSrvT }
var
    FileUDT: TDateTime;
begin
    Result := -1 ;
    IcsGetUAgeSizeFile (FileName, FileUDT, Result);
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetFileUAge(const FileName : String) : TDateTime;            { V8.51 }
var
    FSize: Int64;
begin
    Result := 0 ;
    IcsGetUAgeSizeFile (FileName, Result, FSize);
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Note: despite the name, this is a full Unicode function changing non-ANSI characters }
function IcsAnsiLowerCaseW(const S: UnicodeString): UnicodeString;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.AnsiLowerCase(S);
{$ELSE}
var
    Len: Integer;
begin
    Len := Length(S);
    SetString(Result, PWideChar(S), Len);
    if Len > 0 then CharLowerBuffW(Pointer(Result), Len);
{$ENDIF}
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Note: despite the name, this is a full Unicode function changing non-ANSI characters }
function IcsAnsiUpperCaseW(const S: UnicodeString): UnicodeString;
{$IFDEF COMPILER12_UP}
begin
    Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}SysUtils.AnsiUpperCase(S);
{$ELSE}
var
    Len: Integer;
begin
    Len := Length(S);
    SetString(Result, PWideChar(S), Len);
    if Len > 0 then CharUpperBuffW(Pointer(Result), Len);
{$ENDIF}
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ TIcsFileStreamW }
{$IFNDEF UNICODE}     { V9.1 not needed for unicode compilers }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsFileStreamW.Create(const FileName: UnicodeString; Mode: Word);
begin
{$IFDEF COMPILER12_UP}
    inherited Create(FileName, Mode);
    FFileName := FileName;
{$ELSE}
    Create(Filename, Mode, 0);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsFileStreamW.Create(const FileName: UnicodeString; Mode: Word;
  Rights: Cardinal);
begin
{$IFDEF COMPILER12_UP}
    inherited Create(FileName, Mode, Rights);
    FFileName := FileName;
{$ELSE}
    if Mode = fmCreate then
    begin
        inherited Create(IcsFileCreateW(FileName));
        if Cardinal(FHandle) = INVALID_HANDLE_VALUE then
        {$IFDEF COMPILER12_UP}
            raise Exception.CreateResFmt(@SFCreateErrorEx,
                                [ExpandFileName(FileName),
                                SysErrorMessage(GetLastError)]);
        {$ELSE}
            raise Exception.CreateResFmt(@SFCreateErrorEx,
                                [IcsExpandFileNameW(FileName),
                                SysErrorMessage(GetLastError)]);
        {$ENDIF}

    end
    else begin
        inherited Create(IcsFileOpenW(FileName, Mode));
        if Cardinal(FHandle) = INVALID_HANDLE_VALUE then
        {$IFDEF COMPILER12_UP}
            raise Exception.CreateResFmt(@SFCreateErrorEx,
                                [ExpandFileName(FileName),
                                SysErrorMessage(GetLastError)]);
        {$ELSE}
            raise Exception.CreateResFmt(@SFCreateErrorEx,
                                [IcsExpandFileNameW(FileName),
                                SysErrorMessage(GetLastError)]);
        {$ENDIF}
    end;
    FFileName := FileName;
{$ENDIF}
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsFileStreamW.Create(const Utf8FileName: UTF8String;
  Mode: Word);
begin
{$IFDEF COMPILER12_UP}
    FFileName := Utf8FileName;
    inherited Create(FFileName, Mode);
{$ELSE}
    Create(AnsiToUnicode(Utf8FileName, CP_UTF8), Mode, 0);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsFileStreamW.Create(const Utf8FileName: UTF8String; Mode: Word;
  Rights: Cardinal);
begin
{$IFDEF COMPILER12_UP}
    FFileName := Utf8FileName;
    inherited Create(FFileName, Mode, Rights);
{$ELSE}
    Create(AnsiToUnicode(Utf8FileName, CP_UTF8), Mode, Rights);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TIcsFileStreamW.Destroy;
begin
{$IFNDEF COMPILER12_UP}
    if Integer(FHandle) >= 0 then
        FileClose(FHandle);
{$ENDIF}
    inherited Destroy;
end;
{$ENDIF UNICODE}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ TIcsIntegerList }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.Add(Item: Integer): Integer;
begin
    Result := FList.Add(Pointer(Item));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsIntegerList.Clear;
begin
    FList.Clear;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsIntegerList.Create;
begin
    FList := TList.Create;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsIntegerList.Delete(Index: Integer);
begin
    FList.Delete(Index);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TIcsIntegerList.Destroy;
begin
    FreeAndNil(FList);
    inherited;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.GetCount: Integer;
begin
    Result := FList.Count;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.GetFirst: Integer;
begin
    Result := Integer(FList.First);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.GetLast: Integer;
begin
    Result := Integer(FList.Last);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.GetItem(Index: Integer): Integer;
begin
    Result := Integer(FList[Index]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsIntegerList.SetItem(Index: Integer; const Value: Integer);
begin
    FList[Index] := Pointer(Value);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsIntegerList.IndexOf(Item: Integer): Integer;
begin
    Result := FList.IndexOf(Pointer(Item));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsIntegerList.Assign(Source: TIcsIntegerList);
var
    I: Integer;
begin
    Clear;
    if Assigned(Source) then
        for I := 0 to Source.Count -1 do
            Add(Source[I]);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsCriticalSection.Create;
{$IFDEF POSIX}
var
    LAttr: pthread_mutexattr_t;
{$ENDIF}
begin
    inherited;
  {$IFDEF MSWINDOWS}
    InitializeCriticalSection(FSection);
  {$ENDIF}
  {$IFDEF POSIX}
    IcsCheckOSError(pthread_mutexattr_init(LAttr));
    IcsCheckOSError(pthread_mutexattr_settype(LAttr, PTHREAD_MUTEX_RECURSIVE));
    IcsCheckOSError(pthread_mutex_init(FSection, LAttr));
    pthread_mutexattr_destroy(LAttr);
  {$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TIcsCriticalSection.Destroy;
begin
  {$IFDEF MSWINDOWS}
    DeleteCriticalSection(FSection);
  {$ENDIF}
  {$IFDEF POSIX}
    pthread_mutex_destroy(FSection);
  {$ENDIF}
    inherited;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsCriticalSection.Enter;
begin
  {$IFDEF MSWINDOWS}
    EnterCriticalSection(FSection);
  {$ENDIF}
  {$IFDEF POSIX}
    IcsCheckOSError(pthread_mutex_lock(FSection));
  {$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsCriticalSection.Leave;
begin
  {$IFDEF MSWINDOWS}
    LeaveCriticalSection(FSection);
  {$ENDIF}
  {$IFDEF POSIX}
    IcsCheckOSError(pthread_mutex_unlock(FSection));
  {$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsCriticalSection.TryEnter: Boolean;
begin
  {$IFDEF MSWINDOWS}
    Result := TryEnterCriticalSection(FSection);
  {$ENDIF}
  {$IFDEF POSIX}
    Result := pthread_mutex_trylock(FSection) = 0;
  {$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF MSWINDOWS}
function IcsGetFileVerInfo(      { V8.27 added Ics to prevent conflicts }
    const AppName         : String;
    out   FileVersion     : String;
    out   FileDescription : String): Boolean;
const
    DEFAULT_LANG_ID       = $0409;
    DEFAULT_CHAR_SET_ID   = $04E4;
type
    TTranslationPair = packed record
        Lang, CharSet: WORD;
    end;
    PTranslationIDList = ^TTranslationIDList;
    TTranslationIDList = array[0..MAXINT div SizeOf(TTranslationPair) - 1]
                             of TTranslationPair;
var
    Buffer, PStr    : PChar;
    BufSize         : DWORD;
    StrSize, IDsLen : DWORD;
    Status          : Boolean;
    LangCharSet     : String;
    IDs             : PTranslationIDList;
begin
    Result          := FALSE;
    FileVersion     := '';
    FileDescription := '';
    BufSize         := GetFileVersionInfoSize(PChar(AppName), StrSize);
    if BufSize = 0 then
        Exit;
    GetMem(Buffer, BufSize);
    try
        // get all version info into Buffer
        Status := GetFileVersionInfo(PChar(AppName), 0, BufSize, Buffer);
        if not Status then
            Exit;
        // set language Id
        LangCharSet := '040904E4';
        if VerQueryValue(Buffer, PChar('\VarFileInfo\Translation'),
                         Pointer(IDs), IDsLen) then begin
            if IDs^[0].Lang = 0 then
                IDs^[0].Lang := DEFAULT_LANG_ID;
            if IDs^[0].CharSet = 0 then
                IDs^[0].CharSet := DEFAULT_CHAR_SET_ID;
            LangCharSet := Format('%.4x%.4x',
                                  [IDs^[0].Lang, IDs^[0].CharSet]);
        end;

        // now read real information
        Status := VerQueryValue(Buffer, PChar('\StringFileInfo\' +
                                LangCharSet + '\FileVersion'),
                                Pointer(PStr), StrSize);
        if Status then begin
            FileVersion := StrPas(PStr);
            Result      := TRUE;
        end;
        Status := VerQueryValue(Buffer, PChar('\StringFileInfo\' +
                                LangCharSet + '\FileDescription'),
                                Pointer(PStr), StrSize);
        if Status then
            FileDescription := StrPas(PStr);
    finally
        FreeMem(Buffer);
    end;
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF MSWINDOWS}
{ V8.38 Windows API to check authenticode code signing digital certificate on EXE and DLL files }
{ HashOnly ignores certificate, Expired ignores expired certificate }
{ note currently ignores rovoked certificate check since very slow }
function IcsVerifyTrust (const Fname: string; const HashOnly,
                          Expired: boolean; var Response: string): integer;
var
    ActionID: TGUID ;
    WinTrustData: TWinTrustData ;
    WinTrustFileInfo: TWinTrustFileInfo ;
    WFname: WideString ;
begin
    result := -1;
    WinTrustHandle := LoadLibrary('WINTRUST.DLL');
    if WinTrustHandle = 0 then begin
        response := 'WINTRUST.DLL Not Found' ;
        exit;
    end ;
    @WinVerifyTrust := GetProcAddress(WinTrustHandle, 'WinVerifyTrust');
    if (@WinVerifyTrust = nil) then begin
        response := 'WinVerifyTrust Not Found';
        exit;
    end ;
    if NOT FileExists (Fname) then  begin
        Response := 'Program File Not Found - ' + Fname;
        exit;
    end ;
    WinTrustFileInfo.cbStruct := SizeOf (TWinTrustFileInfo);
    WFname := Fname;
    WinTrustFileInfo.pcwszFilePath := @WFname [1];
    WinTrustFileInfo.hFile := 0;
    WinTrustFileInfo.pgKnownSubject := Nil;
    WinTrustData.cbStruct := SizeOf (TWinTrustData);
    WinTrustData.pPolicyCallbackData := Nil;
    WinTrustData.pSIPClientData := Nil;
    WinTrustData.dwUIChoice := WTD_UI_NONE;
    WinTrustData.fdwRevocationChecks := WTD_REVOKE_NONE;   // revoke check is horribly slow
    WinTrustData.dwUnionChoice := WTD_CHOICE_FILE;
    WinTrustData.Info.pFile := @WinTrustFileInfo;
    WinTrustData.dwStateAction := 0;
    WinTrustData.hWVTStateData := 0;
    WinTrustData.pwszURLReference := Nil;
    WinTrustData.dwProvFlags := WTD_REVOCATION_CHECK_NONE;
    if HashOnly then WinTrustData.dwProvFlags :=
                            WinTrustData.dwProvFlags OR WTD_HASH_ONLY_FLAG;      // ignore certificate
    if Expired then WinTrustData.dwProvFlags :=
                        WinTrustData.dwProvFlags OR WTD_LIFETIME_SIGNING_FLAG;   // check expired date
    WinTrustData.dwUIContext := WTD_UICONTEXT_EXECUTE;
    ActionID := WINTRUST_ACTION_GENERIC_VERIFY_V2;
    Result := WinVerifyTrust (INVALID_HANDLE_VALUE, ActionID, @WinTrustData);
    case Result of
      ERROR_SUCCESS:
         response := 'Trusted Code';
      TRUST_E_SUBJECT_NOT_TRUSTED:
         response := 'Not Trusted Code';
      TRUST_E_PROVIDER_UNKNOWN:
         response := 'Trust Provider Unknown';
      TRUST_E_ACTION_UNKNOWN:
         response := 'Trust Provider Action Unknown';
      TRUST_E_SUBJECT_FORM_UNKNOWN:
         response := 'Trust Provider Form Unknown';
      TRUST_E_NOSIGNATURE:
         response := 'Unsigned Code';
      TRUST_E_EXPLICIT_DISTRUST:
         response := 'Certificate Marked as Untrusted by the User';
      TRUST_E_BAD_DIGEST:
         response := 'Code has been Modified' ;
      CERT_E_EXPIRED:
        response := 'Signed Code But Certificate Expired' ;
      CERT_E_CHAINING:
        response := 'Signed Code But Certificate Chain Not Trusted' ;
      CERT_E_UNTRUSTEDROOT:
        response := 'Signed Code But Certificate Root Not Trusted' ;
      CERT_E_UNTRUSTEDTESTROOT:
        response := 'Signed Code But With Untrusted Test Certificate' ;
      CRYPT_E_SECURITY_SETTINGS:
         response := 'Local Security Options Prevent Verification';
      else
         response := 'Trust Error: ' + SysErrorMessage (Result);
    end ;
end ;
{$ENDIF}



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ INI file support read TRUE, true or 1 for a boolean }
function IcsCheckTrueFalse(const Value: string): boolean;   { V8.47 }
begin
    result := (IcsLowerCase((Copy(Value, 1, 1))) = 't') OR (Value = '1') ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ we receive socket as single byte raw data into TBytes buffer without a
  character set, then convert it onto Delphi Strings for ease of processing }
{ Beware - this function treats buffers as ANSI, no Unicode conversion }
{ beware Dest string is not cleared, and may be partiallly overritten according to offsets }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF UNICODE}
{ V9.1 separate Unicode and Ansi versions so both can be used in unicode apps }
procedure IcsMoveTBytesToString(const Buffer: TBytes; OffsetFrom: Integer; var Dest: String; OffsetTo: Integer; Count: Integer);  { V8.49 }
var
    PSrc  : PByte;
    PDest : PChar;
begin
    PSrc  := Pointer(Buffer);
    if (Count <= 0) or (Count > Length(Buffer)) then   { V9.1 sanity check }
        Count := Length(Buffer);
    if OffsetTo = 0 then
        OffsetTo := 1;
    if Length(Dest) < (OffsetTo + Count - 1) then
        SetLength(Dest, OffsetTo + Count - 1);
    PDest := Pointer(Dest);
    Dec(OffsetTo); // String index!
    while Count > 0 do begin
        PDest[OffsetTo] := Char(PSrc[OffsetFrom]);
        Inc(OffsetTo);
        Inc(OffsetFrom);
        Dec(Count);
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert TBytes into AnsiString }
{ beware Dest string is not cleared, and may be partiallly overritten according to offsets }
procedure IcsMoveTBytesToString(const Buffer: TBytes; OffsetFrom: Integer; var Dest: AnsiString; OffsetTo: Integer; Count: Integer);  { V9.1 }
begin
    if (Count <= 0) or (Count > Length(Buffer)) then
        Count := Length(Buffer);
    if OffsetTo = 0 then
        OffsetTo := 1;
    if Length(Dest) < (OffsetTo + Count - 1) then
        SetLength(Dest, OffsetTo + Count - 1);
    Move(Buffer[OffsetFrom], Dest[OffsetTo], Count);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ we receive socket as single byte raw data into TBytes buffer without a
  character set, then convert it onto Delphi Strings for ease of processing }
{ this function handles Unicode conversion, returns widestring }
{ beware Dest string is not cleared, and may be partiallly overritten according to offsets }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsMoveTBytesToString(const Buffer: TBytes; OffsetFrom: Integer;
                           var Dest: UnicodeString; OffsetTo: Integer; Count: Integer; ACodePage: LongWord);  { V8.50 }
var
    WS: UnicodeString;
    FailedByteCount: Integer;
begin
    Dest := '';
    if NOT Assigned(Buffer) then   { V9.1 sanity check }
        Exit;
    if (Count <= 0) or (Count > Length(Buffer)) then   { V9.1 sanity check }
        Count := Length(Buffer);
//    if (ACodePage = CP_UTF16) or (ACodePage = CP_UTF16Be) then
    WS := IcsBufferToUnicode(Pointer(@Buffer[OffsetFrom])^, Count, ACodePage, FailedByteCount);
//     else
//        WS := AnsiToUnicode(PAnsiChar(@Buffer[OffsetFrom]), ACodePage);  // no 16-bit unicode
    if (OffsetTo > 1) and (Length(Dest) > 0) then
        Dest := Copy (Dest, 1, OffsetTo) + WS
    else
        Dest := WS;
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ we receive socket as single byte raw data into TBytes buffer without a
  character set, then convertit onto Delphi Strings for ease of processing }
{ this function handles Unicode conversion, returns AnsiString }
{ beware Dest string is not cleared, and may be partiallly overritten according to offsets }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsMoveTBytesToString(const Buffer: TBytes; OffsetFrom: Integer;
        var Dest: AnsiString; OffsetTo: Integer; Count: Integer; ACodePage: LongWord);  { V8.50 }
var
    WS: UnicodeString;
begin
    IcsMoveTBytesToString(Buffer, OffsetFrom, WS, OffsetTo, Count, ACodePage);
    Dest := String(WS);   { ? may appear for non-ANSI characters }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ simple conversion of TBytes to unicode string }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsTBytesToString(const Buffer: TBytes; Count: Integer = 0; ACodePage: LongWord = CP_UTF8): UnicodeString;  { V8.71 V9.1 added = 0 }
begin
    Result := '';
    IcsMoveTBytesToString(Buffer, 0, Result, 1, Count, ACodePage);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ simple conversion of TBytes to Ansistring }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsTBytesToStringA(const Buffer: TBytes; Count: Integer= 0): AnsiString;            { V9.1 }
begin
    Result := '';
    IcsMoveTBytesToString(Buffer, 0, Result, 1, Count);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Converts a Unicode String to a TBytes buffer as ANSI, no Unicode conversion }
{$IFDEF UNICODE}
function IcsMoveStringToTBytes(const Source: String; var Buffer: TBytes; Count: Integer): integer;  { V8.69 }
var
    PDest : PByte;
    PSrc  : PChar;
    I     : Integer;
begin
    PSrc  := Pointer(Source);
    if (Count = 0) or (Count > Length(Source)) then
        Count := Length(Source);
    if Length(Buffer) < Count then
        SetLength(Buffer, Count);
    PDest := Pointer(Buffer);
    for I := 0 to Count - 1 do begin
        PDest[I] := Byte(PSrc[I]);
    end;
    Result := Count;
end;
{$ENDIF}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Converts an ANSI String to a TBytes buffer }
function IcsMoveStringToTBytes(const Source: AnsiString; var Buffer: TBytes; Count: Integer): integer;  { V8.69 }
begin
    if (Count = 0) or (Count > Length(Source)) then
        Count := Length(Source);
    if Length(Buffer) < Count then
        SetLength(Buffer, Count);
    Move(Source[1], Buffer[0], Count);
    Result := Count;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Converts an UnicodeString to a TBytes buffer with correct codepage }
function IcsMoveStringToTBytes(const Source: UnicodeString; var Buffer: TBytes;
                                               Count: Integer; ACodePage: LongWord; Bom: Boolean = false): Integer;  { V8.50 }
var
    Len2, Offset: Integer;
    Newbom: TBytes;
begin
    if (Count = 0) or (Count > Length(Source)) then
         Count := Length(Source);

  // two byte code page, cheat and copy unicode string with CP_UTF16 BOM
    if (ACodePage = CP_UTF16) or (ACodePage = CP_UTF16Be) then begin
        Newbom := IcsGetBomBytes(CP_UTF16);
        Offset := Length(Newbom);
        Result := (Count * 2) + Offset;
        if Length(Buffer) < Result then
            SetLength(Buffer, Result);
        Move(newbom[0], Buffer[0], Offset);
        Move(Source[1], Buffer[2], Count);
    end

 // handle all other codepages
    else begin
        Result := IcsWcToMb(ACodePage, 0, Pointer(Source), Count, nil, 0, nil, nil);
        Offset := 0;
        SetLength(NewBom, 0); { V8.54 keep D7 happy }
        if Bom then begin
            Newbom := IcsGetBomBytes(ACodePage);
            Offset := Length(Newbom);
            Result := Result + Offset;
        end;
        if Length(Buffer) < Result then
            SetLength(Buffer, Result);
        if Result > 0 then begin
            if Bom and (Length(NewBom) > 0) then begin { V8.54 keep D7 happy }
                Move(NewBom[0], Buffer[0], Offset);
            end;
            Len2 := IcsWcToMb(ACodePage, 0, Pointer(Source), Count, PAnsiChar(@Buffer[Offset]), Result, nil, nil);
            if Len2 <> Result then begin // May happen, very rarely
                Result := Len2 + Offset;
                SetLength(Buffer, Result);
            end;
        end
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Converts an UnicodeString to a TBytes buffer with correct codepage }
function IcsStringToTBytes(const Source: String; ACodePage: LongWord = CP_UTF8): TBytes;   { V9.1 }
begin
    SetLength(Result, 0);
    IcsMoveStringToTBytes(Source, Result, Length(Source), ACodePage, False);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Converts an ANSI String to a TBytes buffer }
function IcsStringAToTBytes(const Source: AnsiString): TBytes;                         { V9.1 }
begin
    SetLength(Result, 0);
    IcsMoveStringToTBytes(Source, Result, Length(Source));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsMoveTBytes(var Buffer: TBytes; OffsetFrom: Integer; OffsetTo: Integer; Count: Integer); {$IFDEF USE_INLINE} inline; {$ENDIF}   { V8.49 }
begin
    Move(Buffer[OffsetFrom], Buffer[OffsetTo], Count);
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsMoveTBytesEx(const BufferFrom: TBytes; var BufferTo: TBytes;
              OffsetFrom, OffsetTo, Count: Integer); {$IFDEF USE_INLINE} inline; {$ENDIF}  { V8.49 }
begin
    Move(BufferFrom[OffsetFrom], BufferTo[OffsetTo], Count);
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Pos that ignores nulls in the TBytes buffer base 0, so avoid PAnsiChar functions, returns -1 not found }
function IcsTBytesPos(const Substr: String; const S: TBytes; Offset, Count: Integer): Integer;  { V8.49 }
var
    Ch: Byte;
    SubLen, I, J: Integer;
    Found: Boolean;
begin
    Result := -1;
    SubLen := Length(Substr);
    if SubLen = 0 then
        Exit;
    if Length(S) = 0 then
        Exit;
    if (Count <= 0) or (Count > Length(S)) then   { V9.1 sanity check }
        Count := Length(S);
    if (Offset >= Count) then
        Offset := 0;
    Ch := Byte(SubStr[1]);
    for I := Offset to Count - SubLen do begin
        if S[I] = Ch then begin
            Found := True;
            if SubLen > 1 then begin
                for J := 2 to SubLen do begin
                    if Byte(Substr[J]) <> S[I+J-1] then begin
                        Found := False;
                        Break;
                     end;
                end;
            end;
            if Found then begin
                Result := I;
                Exit;
            end;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ case insensitive check for null terminated Find at start of buffer }
function IcsTBytesStarts(const Source: TBytes; Find: PAnsiChar) : Boolean;    { V8.49, V8.64 }
begin
    Result := FALSE;
{$IFDEF COMPILER18_UP}
    if (System.AnsiStrings.StrLIComp(PAnsiChar(Source), Find, Length(Find)) = 0) then
       Result := TRUE;
{$ELSE}
    if (StrLIComp(PAnsiChar(Source), Find, Length(Find)) = 0) then
       Result := TRUE;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ case sensitive check for Find within null terminated buffer }
function IcsTBytesContains(const Source: TBytes; Find : PAnsiChar) : Boolean;   { V8.49, V8.64 }
begin
    Result := FALSE;
{$IFDEF COMPILER18_UP}
    if (System.AnsiStrings.StrPos(PAnsiChar(Source), Find) <> nil) then
      Result := TRUE;
{$ELSE}
    if (StrPos(PAnsiChar(Source), Find) <> nil) then
      Result := TRUE;
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ case sensitive comparison of two TBytes }
 function IcsTBytesCompare(const Input1, Input2: TBytes): Boolean;                { V9.4 }
 begin
    Result := False;
    if (Length(Input1) <> Length(Input2)) then
        Exit;
    Result := CompareMem(@Input1[0], @Input2[0], Length(Input1));
 end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ format an IPv6 address with browser friendly [] }
function IcsFmtIpv6Addr (const Addr: string): string;    { V8.52 }
begin
    if (Pos ('.', Addr) = 0) and (Pos ('[', Addr) = 0) and (Pos (':', Addr) > 0) then
        result := '[' + Addr + ']'
    else
        result := Addr;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ format an IPv6 address with browser friendly [] and port }
function IcsFmtIpv6AddrPort (const Addr, Port: string): string;    { V8.52 }
begin
    result := IcsFmtIpv6Addr (Addr) + ':' + Port;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ strip [] off IPv6 address }
function IcsStripIpv6Addr (const Addr: string): string;         { V8.52 }
begin
    if (Pos ('[', Addr) = 1) and (Addr [Length (Addr)] = ']') then
        result := Copy (Addr, 2, Length (Addr) - 2)
    else
        result := Addr;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IntToKbyte (Value: Int64; Bytes: boolean = false): String;
var
    float, float2: Extended;
    mask, suffix: string;
const
    KBYTE = Sizeof(Byte) shl 10;
    MBYTE = KBYTE shl 10;
    GBYTE = MBYTE shl 10;
begin
    float := Value;
    if (float / 100) >= GBYTE then
    begin
        mask := '%5.0f';
        suffix := 'G';
        float2 := float / GBYTE;  // 134G
    end
    else if (float / 10) >= GBYTE then
    begin
        mask := '%5.1f';
        suffix := 'G';
        float2 := float / GBYTE;  // 13.4G
    end
    else if float >= GBYTE then
    begin
        mask := '%5.2f';
        suffix := 'G';
        float2 := float / GBYTE;  // 3.44G
    end
    else if float >= (MBYTE * 100) then
    begin
        mask := '%5.0f';
        suffix := 'M';
        float2 := float / MBYTE;  // 234M
    end
    else if float >= (MBYTE * 10) then
    begin
        mask := '%5.1f' ;
        suffix := 'M';
        float2 := float / MBYTE;  // 12.4M
    end
    else if float >= MBYTE then
    begin
        mask := '%5.2f';
        suffix := 'M';
        float2 := float / MBYTE;  // 12.4M
    end
    else if float >= (KBYTE * 100) then
    begin
        mask := '%5.0f';
        suffix := 'K';
        float2 := float / KBYTE;  // 678K
    end
    else if float >= (KBYTE * 10) then
    begin
        mask := '%5.1f';
        suffix := 'K';
        float2 := float / KBYTE ;  // 76.5K
    end
    else if float >= KBYTE then
    begin
        mask := '%5.2f';
        suffix := 'K';
        float2 := float / KBYTE;  // 4.78K
    end
    else
    begin
        mask := '%5.0f';
        suffix := '';
        float2 := float;  // 123
    end ;
    Result := Trim(Format (mask, [float2]));
    if Bytes then  { V8.54 improve result a little }
        Result := Result + IcsSPACE + suffix + 'bytes'
    else
        Result := Result + suffix;
end ;

function IcsIntToKbyte (Value: Int64; Bytes: boolean = false): String;  { V9.5 better name }
begin
    Result := IntToKbyte (Value, Bytes);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ helper functions for timers and triggers using GetTickCount - which wraps after 49 days }
{ note: Vista/2008 and later have GetTickCount64 which returns 64-bits }
{ V8.54 moved here from OverbyteIcsFtpSrvT }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
var
   TicksTestOffset: longword ;  { testing GetTickCount wrapping }

function IcsGetTickCountX: longword ;
var
    newtick: Int64 ;
begin
    Result := IcsGetTickCount ;
  {ensure special trigger values never returned - V7.07 }
    if (Result = TriggerDisabled) or (Result = TriggerImmediate) then Result := 1 ;
    if TicksTestOffset = 0 then
        exit;  { no testing, bye bye }

{ TicksTestOffset is set in initialization so that the counter wraps five mins after startup }
    newtick := Int64 (Result) + Int64 (TicksTestOffset);
    if newtick >= $FFFFFFFF then
        Result := newtick - $FFFFFFFF
    else
        Result := newtick ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsDiffTicks (const StartTick, EndTick: longword): longword ;
begin
    if (StartTick = TriggerImmediate) or (StartTick = TriggerDisabled) then
        Result := 0
    else
    begin
        if EndTick >= StartTick then
            Result := EndTick - StartTick
        else
            Result := ($FFFFFFFF - StartTick) + EndTick ;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsElapsedMSecs (const StartTick: longword): longword ;
begin
    Result := IcsDiffTicks (StartTick, IcsGetTickCountX);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsElapsedTicks (const StartTick: longword): longword ;
begin
    Result := IcsDiffTicks (StartTick, IcsGetTickCountX);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsElapsedSecs (const StartTick: longword): integer ;
begin
    Result := (IcsDiffTicks (StartTick, IcsGetTickCountX)) div TicksPerSecond ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsWaitingSecs (const EndTick: longword): integer ;
begin
    if (EndTick = TriggerImmediate) or (EndTick = TriggerDisabled) then
        Result := 0
    else
        Result := (IcsDiffTicks (IcsGetTickCountX, EndTick)) div TicksPerSecond ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsElapsedMins (const StartTick: longword): integer ;
begin
    Result := (IcsDiffTicks (StartTick, IcsGetTickCountX)) div TicksPerMinute ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsAddTrgMsecs (const TickCount, MilliSecs: longword): longword ;
begin
    Result := MilliSecs ;
    if Result > ($FFFFFFFF - TickCount) then
        Result := ($FFFFFFFF - TickCount) + Result
    else
        Result := Result + TickCount ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsAddTrgSecs (const TickCount, DurSecs: integer): longword ;
begin
    Result := TickCount ;
    if DurSecs < 0 then
        exit;
    Result := IcsAddTrgMsecs (TickCount, longword (DurSecs) * TicksPerSecond);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetTrgMsecs (const MilliSecs: integer): longword ;
begin
    Result := TriggerImmediate ;
    if MilliSecs < 0 then
        exit;
    Result := IcsAddTrgMsecs (IcsGetTickCountX,  MilliSecs);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetTrgSecs (const DurSecs: integer): longword ;
begin
    Result := TriggerImmediate ;
    if DurSecs < 0 then
        exit;
    Result := IcsAddTrgMsecs (IcsGetTickCountX, longword (DurSecs) * TicksPerSecond);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetTrgMins (const DurMins: integer): longword ;
begin
    Result := TriggerImmediate ;
    if DurMins < 0 then
        exit;
    Result := IcsAddTrgMsecs (IcsGetTickCountX, longword (DurMins) * TicksPerMinute);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsTestTrgTick (const TrgTick: longword): boolean ;
var
    curtick: longword ;
begin
    Result := FALSE ;
    if TrgTick = TriggerDisabled then
        exit;  { special case for trigger disabled }
    if TrgTick = TriggerImmediate then begin
        Result := TRUE ;  { special case for now }
        exit;
    end;
    curtick := IcsGetTickCountX ;
    if curtick <= $7FFFFFFF then  { less than 25 days, keep it simple }
    begin
        if curtick >= TrgTick then Result := TRUE ;
        exit;
    end;
    if TrgTick <= $7FFFFFFF then
        exit;  { trigger was wrapped, can not have been reached  }
    if curtick >= TrgTick then
        Result := TRUE ;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.57 convert wire-format concactanted length prefixed strings to TStrings }
{ V8.64 added const so Buffer reference count not updated, might be cast }
function IcsWireFmtToStrList(const Buffer: TBytes; Len: Integer; SList: TStrings): Integer;
var
    offset, mylen: integer;
    AStr: AnsiString;
begin
    Result := 0;
    if NOT Assigned(SList) then Exit;
    SList.Clear;
    offset := 0;
    while offset < Len do begin
        mylen := Buffer[offset];
        if (mylen = 0) or (mylen + offset >= Len) then Exit;  // illegal, V8.64 check not outside buffer
        offset := offset + 1;
        SetLength(AStr, mylen);
        Move(Buffer[offset], AStr[1], mylen);
        SList.Add(String(AStr));
        offset := offset + mylen;
    end;
    Result := Slist.Count;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.64 convert wire-format concactanted length prefixed strings to CSV }
function IcsWireFmtToCSV(const Buffer: TBytes; Len: Integer): String;
var
    offset, mylen: integer;
    AStr: AnsiString;
begin
    Result := '';
    offset := 0;
    while offset < Len do begin
        mylen := Buffer[offset];
        if (mylen = 0) or (mylen + offset >= Len) then Exit;  // illegal, V8.64 check not outside buffer
        offset := offset + 1;
        SetLength(AStr, mylen);
        Move(Buffer[offset], AStr[1], mylen);
        if Result <> '' then Result := Result + ',';
        Result := Result + String(AStr);
        offset := offset + mylen;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.57 convert TStrings to wire-format concactanted length prefixed strings  }
function IcsStrListToWireFmt(SList: TStrings; var Buffer: TBytes): Integer;
var
    I, offset, mylen: integer;
    AStr: AnsiString;
begin
    Result := 0;
    if NOT Assigned(SList) then Exit;
    if SList.Count = 0 then Exit;
    for I := 0 to SList.Count - 1 do
        Result := Result + Length(SList[I]) + 1;
    SetLength(Buffer, Result);
    offset := 0;
    for I := 0 to SList.Count - 1 do  begin
        AStr := SList[I];     { V8.64 support Unicode }
        mylen := Length(AStr);
        if mylen > 0 then begin
            Buffer[offset] := mylen;
            offset := offset + 1;
            Move(AStr[1], Buffer[offset], mylen);
            offset := offset + mylen;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.57 convert CRLF to \n  }
function IcsEscapeCRLF(const Value: String): String;
var
    I: Integer;
begin
    Result := Value;
    while True do begin
        I := Pos(IcsCRLF, Result);
        if I <= 0 then Exit;
        Result[I] := '\';
        Result[I+1] := 'n';
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.57 convert \n to CRLF  }
function IcsUnEscapeCRLF(const Value: String): String;
var
    I: Integer;
begin
    Result := Value;
    while True do begin
        I := Pos('\n', Result);
        if I <= 0 then Exit;
        Result[I] := IcsCR;
        Result[I+1] := IcsLF;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.57 convert Set bit map to Integer }
function IcsSetToInt(const aSet; const aSize: Integer): Integer;
begin
    Result := 0;
    Move(aSet, Result, aSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.57 convert Integer to Set bit map }
procedure IcsIntToSet(const Value: Integer; var aSet; const aSize: Integer);
begin
    Move(Value, aSet, aSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.57 convert Set bit map to [] comma string with enumerated names,
 ie [OutFmtSep,OutFmtBudl,OutFmtP12] for TCertOutFmt }
function IcsSetToStr(TypInfo: PTypeInfo; const aSet; const aSize: Integer): string;
var
    I, W: Integer;
begin
    if TypInfo.Kind <> tkEnumeration then begin  { V8.63 sanity check }
        Result := '[]';
        Exit;
    end;
    W := IcsSetToInt(aSet, aSize);
    Result := '[';
    for I := 0 to (aSize * 8) - 1 do begin
        if I in TIntegerSet(W) then begin
            if Length(Result) <> 1 then Result := Result + ',';
            Result := Result + GetEnumName (TypInfo, I);
        end;
    end;
  Result := Result + ']';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.57 convert [] comma string with enumerated names to Set bit map,
 ie [OutFmtSep,OutFmtBudl,OutFmtP12] for TCertOutFmt }
procedure IcsStrToSet(TypInfo: PTypeInfo; const Values: String; var aSet; const aSize: Integer);
var
    ValueList: TStringList;
    I, J, W: Integer;
begin
    W := 0;
    ValueList := TStringList.Create;
    try
        if TypInfo.Kind <> tkEnumeration then Exit;  { V8.63 sanity check }
        if Length(Values) < 3 then Exit;
        if Pos('[', Values) <> 1 then Exit;
        ValueList.CommaText := Copy (Values, 2, Length(Values) - 2);
        if ValueList.Count = 0 then Exit;
        for J := 0 to ValueList.Count - 1 do begin
            try
                if ValueList[J] = '' then Continue;
                I := GetEnumValue (TypInfo, ValueList[J]);
                if I >= 0 then Include(TIntegerSet(W), I);
            except
            end;
        end;
    finally
        IcsIntToSet(W, aSet, aSize);
        ValueList.Free;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsPathSep(Ch : WideChar) : Boolean;   { V8.57  }
begin
    Result := (Ch = '.') or (Ch = '\') or (Ch = ':') ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsPathSep(Ch : AnsiChar) : Boolean;    { V8.57  }
begin
    Result := (Ch = '.') or (Ch = '\') or (Ch = ':') ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.57 extract file name less extension, drive and path }
function IcsExtractNameOnly(const FileName: String): String;
var
    I: Integer;
begin
    Result := ExtractFileName(FileName);  // remove path
    I := Length(Result);
    while (I > 0) and (NOT (IsPathSep (Result[I]))) do
        Dec(I);
    if (I > 1) and (Result[I] = '.') then
        Result := Copy(Result, 1, I - 1) ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.57 get the computer name from networking, moved from web sample }
{ V9.3 supported on Posix }
function IcsGetCompName: String;
{$IFDEF MSWINDOWS}   { V8.64 not MacOS }
var
    Buffer: array[0..255] of WideChar ;
    NLen: DWORD ;
begin
    Buffer [0] := #0 ;
    result := '' ;
    NLen := Length (Buffer) ;
    if GetComputerNameW (Buffer, NLen) then Result := Buffer ;
end ;
{$ELSE}
var
    Hostname: TBytes;   // ?? should this be a global
begin
    Hostname := IcsDataLoadFile('/etc/hostname', 32);
    Result := IcsTBytesToString(Hostname);
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.59 get exception literal message }
function IcsGetExceptMess(ExceptObject: TObject): string;
var
    MsgPtr: PChar;
    MsgEnd: PChar;
    MsgLen: Integer;
    MessEnd: String;
begin
    MsgPtr := '';
    MsgEnd := '';
    if ExceptObject is Exception then begin
        MsgPtr := PChar(Exception(ExceptObject).Message);
        MsgLen := StrLen(MsgPtr);
        if (MsgLen <> 0) and (MsgPtr[MsgLen - 1] <> '.') then MsgEnd := '.';
    end;
    result := Trim (MsgPtr);
    MessEnd := Trim (MsgEnd);
    if Length (MessEnd) > 5 then
        result := result + ' - ' + MessEnd;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 add thousand separators to a string of numbers (not checked }
function IcsAddThouSeps (const S: String): String;
var
    LS, L2, I, N: Integer;
    Temp: String;
begin
    Result := S;
    LS := Length(S);
    N := 1;
    if LS > 1 then begin
        if S [1] = '-' then begin // check for negative value
            N := 2;
            LS := LS - 1;
        end ;
    end ;
    if LS <= 3 then exit;
    L2 := (LS - 1) div 3;
    Temp := '';
    for I := 1 to L2 do
        Temp := IcsFormatSettings.ThousandSeparator + Copy (S, LS - 3 * I + 1, 3) + Temp;
    Result := Copy (S, N, (LS - 1) mod 3 + 1) + Temp;
    if N > 1 then Result := '-' + Result;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 integer to string with thousand separators }
function IcsIntToCStr (const N: Integer): String ;
begin
    result := IcsAddThouSeps (IntToStr (N)) ;
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 int64 to string with thousand separators }
function IcsInt64ToCStr (const N: Int64): String ;
begin
    result := IcsAddThouSeps (IntToStr (N)) ;
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 get format settings, allowing compatability all compilers }
procedure GetIcsFormatSettings;
begin
{$IF CompilerVersion >= 23.0}   // XE2 and later
  {$IFDEF MSWINDOWS}
     IcsFormatSettings := TFormatSettings.Create (GetThreadLocale) ;
  {$ELSE}
     IcsFormatSettings := TFormatSettings.Create ; { V8.64 MacOs no GetThreadLocale }
  {$ENDIF}
{$ELSE}
     GetLocaleFormatSettings (GetThreadLocale, IcsFormatSettings) ;
{$IFEND}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.5 compare two binary TByes, used by sorting functions }
function IcsCompareTBytes(const T1, T2: TBytes): Integer; // 0=equal, >=1 T1 more than T2, <=-1 T1 less than T2  { V9.5 }
var
    Len1, Len2, Last, Idx: Integer;
begin
    Len1 := Length(T1);
    Len2 := Length(T2);
    if (Len1 = Len2) then begin
        if (Len1 = 0) or CompareMem(@T1[0], @T2[0], Len1) then begin
            Result := 0;   // compared same
            Exit;
        end;
    end;
    Result := Len1 - Len2;
    if (Len1 > 0) and (Len2 > 0) then begin
        if (Result < 0) then
            Last := Len1
        else
            Last := Len2;
        Idx := 0;
        while (Idx < Last) do begin
            if T1[Idx] <> T2[Idx] then begin  // exit at first mismatch
                Result := T1[Idx] - T2[Idx];
                Exit;
            end;
            Idx := Idx + 1;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 compare two memory buffers, used for sorting.
 ideally ASM SysUtils.CompareMem should be modified to return less or greater }
function IcsCompareGTMem (P1, P2: Pointer; Length: Integer): Integer;       { V9.5 added Ics }
var
    I: Integer;
    PC1, PC2: PAnsiChar;
begin
    result := 0;   // equals
    if Length <= 0 then exit;
    PC1 := P1;
    PC2 := P2;
    for I := 1 to Length do begin
        if (PC1^ <> PC2^) then begin
            if (PC1^ < PC2^) then
                result := -1   // less than
            else
                result := 1;  // greater than
            exit ;
        end ;
        Inc (PC1);
        Inc (PC2);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 descendent of TList, adding sorted, works on sorted list }
function TIcsFindList.AddSorted(const Item2: Pointer; Compare: TListSortCompare): Integer;  { V8.65 result matches Find }
begin
    if NOT Sorted then
        Result := Count
    else begin
       if Find (Item2, Compare, Result) then exit;
    end ;
    Insert (Result, Item2) ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 adding binary FIND works on sorted list }
function TIcsFindList.Find(const Item2: Pointer; Compare: TListSortCompare;
                                                    var Index: Integer): Boolean;    { V8.65 }
var
    l, h, i, c: Integer; { V8.65 }
begin
    Result := False;
    Index := 0 ;
    if (List = nil) or (Count = 0) then exit ;
    l := 0;
    h := Count - 1;
    while (l <= h) do begin
        i := (l + h) shr 1;  // binary shifting
        c := Compare (List[i], Item2) ;
        if c < 0 then
            l := i + 1
        else begin
            h := i - 1;
            if c = 0 then begin
                Result := True;
                l := i;
            end;
        end;
    end;
    Index := l;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60  Delete a single file, optionally read only }
function IcsDeleteFile(const Fname: string; const ReadOnly: boolean): Integer;
var
    attrs: integer ;
    LongFile: String;    { V8.70 support paths longer than 254 odd }
begin
    result := -1 ;    // file not found
    LongFile := IcsAddLongPath(Fname);                         { V8.70 }
    attrs := FileGetAttr (LongFile);
    if attrs < 0 then exit;
{$IFDEF MSWINDOWS}
    if ((attrs and faReadOnly) <> 0) and ReadOnly then begin
        result := FileSetAttr (LongFile, 0);   { V8.65 windows only }
        if result <> 0 then result := 1;
        if result <> 0 then exit;  // 1 could not change file attribute, ignore system error
    end ;
{$ENDIF}
    if DeleteFile (LongFile) then
        result := 0   // OK
    else
        result := GetLastError; // system error
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 Rename a single file, optionally replacing, optionally read only }
function IcsRenameFile(const OldName, NewName: string; const Replace, ReadOnly: boolean): Integer;
var
    LongOld, LongNew: String;    { V8.70 support paths longer than 254 odd }
begin
    LongOld := IcsAddLongPath(OldName);                         { V8.70 }
    LongNew := IcsAddLongPath(NewName);                         { V8.70 }
    if FileExists (LongNew) then begin
        result := 2 ;  // rename failed, new file exists
        if NOT Replace then exit;
        result := IcsDeleteFile (LongNew, ReadOnly);
        if result <> 0 then exit ;  // 1 could not change file attribute, higher could not delete file
    end ;
    if RenameFile (LongOld, LongNew) then
        result := 0   // OK
    else
        result := GetLastError; // system error
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ force sub directories, replacing file of same name if necessary }
function IcsForceDirsEx(const Dir: String): Boolean;  { V8.60 }
var
    LongDir: String;    { V8.70 support paths longer than 254 odd }
begin
    Result := True;
    if Length(Dir) = 0 then begin
        Result := False;
        Exit;
    end;
    if (Pos ('\', Dir) = 0) and (Pos (':', Dir) = 0) then Exit;
    LongDir := IcsAddLongPath(Dir);                         { V8.70 }
    if DirectoryExists (LongDir) then Exit;
    if FileExists(ExcludeTrailingPathDelimiter(LongDir)) then
            IcsDeleteFile(ExcludeTrailingPathDelimiter(LongDir), True);
    Result := ForceDirectories (LongDir);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.60 borrowed from IcsStreams }
function GetBomFromCodePage(ACodePage: LongWord) : TBytes;
begin
    case ACodePage of
        CP_UTF16 :
            begin
                SetLength(Result, 2);
                Result[0] := $FF;
                Result[1] := $FE;
            end;
        CP_UTF16Be :
            begin
                SetLength(Result, 2);
                Result[0] := $FE;
                Result[1] := $FF;
            end;
        CP_UTF8    :
            begin
                SetLength(Result, 3);
                Result[0] := $EF;
                Result[1] := $BB;
                Result[2] := $BF;
            end;
        else
            SetLength(Result, 0);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsTransChar(const S: string; FromChar, ToChar: Char): string;  { V8.60 }
var
    I: Integer;
begin
    Result := S;
    for I := 1 to Length(Result) do begin
        if Result[I] = FromChar then
            Result[I] := ToChar;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsPathUnixToDos(const Path: string): string;   { V8.60 }
begin
  Result := IcsTransChar(Path, '/', '\');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsPathDosToUnix(const Path: string): string;   { V8.60 }
begin
  Result := IcsTransChar(Path, '\', '/');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsTransCharW(const S: UnicodeString; FromChar, ToChar: WideChar): UnicodeString;  { V8.60 }
var
    I: Integer;
begin
    Result := S;
    for I := 1 to Length(Result) do begin
        if Result[I] = FromChar then
            Result[I] := ToChar;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsPathUnixToDosW(const Path: UnicodeString): UnicodeString;   { V8.60 }
begin
  Result := IcsTransCharW(Path, '/', '\');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsPathDosToUnixW(const Path: UnicodeString): UnicodeString;   { V8.60 }
begin
  Result := IcsTransCharW(Path, '\', '/');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ converts a seconds duration to hours, minutes and seconds string, ie 37:12:30 }
function IcsSecsToStr(Seconds: Integer): String;  { V8.60 }
var
    DurationDT: TDateTime;
    Hours: Integer;
    S: String;
begin
    Result := '0';
    if Seconds <= 0 then Exit;
    DurationDT := Seconds / SecsPerDay ;
    S := Copy(FormatDateTime ('hh:mm:ss', Frac(DurationDT)), 4, 5);
    Hours := Trunc(DurationDT * 24) ;
    if (Hours = 0) then begin
        if (Length (S) > 0) and (S [1] = '0') then
            Result := Copy(S, 2, 9)
        else
            result := S;
    end
    else
        Result := IntToStr(Hours) + String(IcsFormatSettings.TimeSeparator) + S;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsGetTempPath: String;      { V8.60 }
{$IFDEF MSWINDOWS}
var
    Buffer: array [0..MAX_PATH] of WideChar;
begin
    SetString(Result, Buffer, GetTempPathW (Length (Buffer) - 1, Buffer));
{$ELSE}
begin
    Result := TPath.GetTempPath;   { V8.64 MacOS }
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ V8.64 Bootstring parameters for Punycode and International Domain Names }
const
  PUNY_TMIN:Integer=1;
  PUNY_TMAX:Integer=26;
  PUNY_BASE:Integer = 36;
  PUNY_INITIAL_N:Integer = 128;
  PUNY_INITIAL_BIAS:Integer = 72;
  PUNY_DAMP:Integer = 700;
  PUNY_SKEW:Integer = 38;
  PUNY_DELIMITER:char = '-';

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Bias adaptation function }
 function IcsPunyAdapt(Delta, Numpoints: Integer; First: Boolean): Integer;
var
    K:Integer;
begin
    if First then
        Delta := Delta div PUNY_DAMP
    else
        Delta := Delta div 2;
    Delta := Delta + (Delta div Numpoints);
    K := 0;
    while (Delta > ((PUNY_BASE - PUNY_TMIN) * PUNY_TMAX) div 2) do begin
        Delta := Delta div (PUNY_BASE - PUNY_TMIN);
        K := K + PUNY_BASE;
    end;
    Result := K + ((PUNY_BASE - PUNY_TMIN + 1) * Delta) div (Delta + PUNY_SKEW);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Returns the numeric value of a basic code point (for use in representing
  integers) in the range 0 to BASE-1, }
function IcsPunyCodepoint2Digit(C: Integer): Integer;
begin
    if C - Ord('0') < 10 then
        Result := C - Ord('0') + 26
    else if C - Ord('a') < 26 then
        Result := C - Ord('a')
    else
        Result := -1;   // error BAD_INPUT
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Returns the basic code point whose value (when used for representing
  integers) is d, which needs to be in the range 0 to BASE-1.
  0..25 map to ASCII a..z or A..Z
  26..35 map to ASCII 0..9         }
function IcsPunyDigit2Codepoint(D: Integer): Integer;
begin
    if D < 26 then
        Result := D + Ord('a')
    else if D < 36 then
        Result := D - 26 + Ord('0')
    else
        Result := -1;  // error BAD_INPUT
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsPunyIsBasic(const C: WideChar): Boolean;{$IFDEF USE_INLINE} inline; {$ENDIF}   { V8.65 }
begin
    Result := Ord(C) < $80;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ converts ASCII Punycode to Unicode }
function IcsPunyDecode(const Input: String; var ErrFlag: Boolean): UnicodeString;
var
    N, I, J, Bias, D, Oldi, W, K, Digit, T, Outlen: Integer;
    Ch: Char;
begin
    N := PUNY_INITIAL_N;
    I := 0;
    Bias := PUNY_INITIAL_BIAS;
    ErrFlag := True;
    Result := '';
    D := LastDelimiter(PUNY_DELIMITER, Input);
    if D > 1 then begin
        for J := 1 to D-1 do begin
            Ch := Input[J];
            if Ord(Ch) >= $80 then Exit; // error, only allowed ASCII
            Result := Result + Ch;
        end;
        inc (D);
    end
    else
        D := 1;
    Outlen := Length(Result);
    while D <= Length(Input) do begin // was <
        Oldi := I;
        W := 1;
        K := PUNY_BASE;
        while True do  begin
            if D = Length(input) + 1 then Exit; // error BAD_INPUT
            Ch := Input[D];
            Inc (D);
            Digit := IcsPunyCodepoint2Digit(Ord(Ch));
            if Digit < 0 then Exit;
            if Digit > (MAXINT - I) div W then Exit;  // error OVERFLOW
            I := I + Digit * W;
            if K <= Bias then
                T := PUNY_TMIN
            else if K >= Bias + PUNY_TMAX then
                T := PUNY_TMAX
            else
                T := K - Bias;
            if Digit < T then Break;
            W := W * (PUNY_BASE - T);
            Inc(K, PUNY_BASE);
        end;
        Bias := IcsPunyAdapt(I - Oldi, Outlen + 1, (Oldi = 0));
        if I div (Outlen + 1) > MAXINT - N then Exit; // error OVERFLOW
        N := N + I div (Outlen + 1);
        I := I mod (Outlen + 1);
        Insert(Chr(N), Result, I + 1);
        inc(Outlen);
        Inc (I);
    end;
    ErrFlag := False;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ converts Unicode to A-Label (Punycode ASCII) }
function IcsPunyEncode(const Input: UnicodeString; var ErrFlag: Boolean): String;
var
    N, B, Delta, Bias, M, I, H, J, Q, K, T, V: Integer;
    Ch: WideChar;
begin
    N := PUNY_INITIAL_N;
    Delta := 0;
    Bias := PUNY_INITIAL_BIAS;
    ErrFlag := True;
    Result := '';
    B := 0;
    for I := 1 to Length(Input) do begin
        Ch := Input[I];
        if IcsPunyIsBasic(Ch) then  begin
            Result := Result + Ch;
            Inc(B);
        end;
    end;
    if B > 0 then
        Result := Result + PUNY_DELIMITER;
    H := B;
    while H < Length(Input) do begin
        M := MaxInt;
        for I := 1 to Length(Input) do begin
            Ch := Input[I];
            if (Ord(Ch) >= N) and (Ord(Ch) < M) then M := Ord(Ch);
        end;
        if M - N > (MaxInt - Delta) div (H + 1) then Exit; // error OVERFLOW
        Delta := Delta + (M - N) * (H + 1);
        N := M;
        for J := 1 to Length(Input) do begin
            Ch := Input[J];
            if Ord(Ch) < N then begin
                Inc(Delta);
                if Delta = 0 then Exit;  // error OVERFLOW
            end;
            if Ord(Ch) = N then begin
                Q := Delta;
                K := PUNY_BASE;
                while True do begin
                //    t := 0;
                    if K <= Bias then
                        T := PUNY_TMIN
                    else if K >= Bias + PUNY_TMAX then
                        T := PUNY_TMAX
                    else
                        T := K - Bias;
                    if Q < T then Break;  // done with this character
                    V := IcsPunyDigit2Codepoint(T + (Q - T) mod (PUNY_BASE - T));
                    if V <= 0 then Exit;  // error BAD_INPUT
                    Result := Result + chr(V);
                    Q := (Q - T) div (PUNY_BASE - T);
                    Inc(K, PUNY_BASE);
                end;
                V := IcsPunyDigit2Codepoint(Q);
                if V <= 0 then Exit;  // error BAD_INPUT
                Result := Result + chr(V);
                Bias := IcsPunyAdapt(Delta, H + 1, (H = B));
                Delta := 0;
                Inc(H);
              end;
        end;
        Inc(Delta);
        Inc(N);
    end;
    ErrFlag := False;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsIsSTD3Ascii(C: Integer): Boolean;
begin
    Result := NOT ((C <= $2c) or (C = $2e) or (C = $2f) or
                   ((C >= $3a) and (C <= $40)) or
                     ((C >= $5b) and (C <= $60)) or
                           ((C >= $7b) and (C <= $7f)));
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ RFC 3490 ToASCII consists of the following steps:
   1. If the sequence contains any code points outside the ASCII range
      (0..7F) then proceed to step 2, otherwise skip to step 3.
   2. Perform the steps specified in [NAMEPREP] and fail if there is an
      error.  The AllowUnassigned flag is used in [NAMEPREP].
   3. If the UseSTD3ASCIIRules flag is set, then perform these checks:
     (a) Verify the absence of non-LDH ASCII code points; that is, the
         absence of 0..2C, 2E..2F, 3A..40, 5B..60, and 7B..7F.
     (b) Verify the absence of leading and trailing hyphen-minus; that
         is, the absence of U+002D at the beginning and end of the sequence.
   4. If the sequence contains any code points outside the ASCII range
      (0..7F) then proceed to step 5, otherwise skip to step 8.
   5. Verify that the sequence does NOT begin with the ACE prefix.
   6. Encode the sequence using the encoding algorithm in [PUNYCODE] and
      fail if there is an error.
   7. Prepend the ACE prefix.
   8. Verify that the number of code points is in the range 1 to 63 inclusive.  }

{ converts a Unicode label (no dota) into A-Label (Punycode ASCII) if any characters over x7F,
  preceding with ASCII Compatible Encoding (ACE) prefix xn-- }
function IcsPunyToASCII(const Input: UnicodeString; UseSTD3AsciiRules: Boolean; var ErrFlag: Boolean): String;    { V9.1 added Puny }
var
    Nonascii: Boolean;
    I: Integer;
    Output: AnsiString;
begin
    ErrFlag := True;
    Result := AnsiString(input);

  // should do Nameprep algorithm to check valid unicode characters
  // including converting uppercase to lowercase, not trivial for unicode.

    if UseSTD3AsciiRules then begin
        for I := 1 to Length(Input) do begin
            if NOT IcsIsSTD3Ascii(Ord(Input[I])) then Exit;  // error CONTAINS_NON_LDH
        end;
        if (Pos('-', Input) = 1) or (Pos('-', Input) = Length(Input)) then Exit;  // error CONTAINS_HYPHEN
    end;
    Nonascii := false;
    for I := 1 to Length(Input) do begin
        if Ord(Input[I]) > $7f then  begin
            Nonascii := true;
            break;
        end;
    end;
    Output := AnsiString(Input);
    if Nonascii then begin
      { if ACE found with unicode characters, we are in trouble }
        if Pos(ACE_PREFIX, input) = 1 then Exit;  // error CONTAINS_ACE_PREFIX)
        Output:= IcsPunyEncode(input, ErrFlag);
        if ErrFlag then Exit;    // error
        Output := ACE_PREFIX + Output;
    end;
    if (Length(Output) < 1) or (Length(Output) > 63) then Exit;  // error TOO_LONG
    ErrFlag := False;
    Result := Output;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ converts a Unicode domain or host name into A-Label (Punycode ASCII) if any characters
  over x7F, preceding with ASCII Compatible Encoding (ACE) prefix xn-- }
function IcsIDNAToASCII(const Input: UnicodeString; UseSTD3AsciiRules: Boolean; var ErrFlag: Boolean): String;
var
    Nonascii: Boolean;
    I, C: Integer;
    Ch: WideChar;
    Node: UnicodeString;
begin
    Result := '';
    Node := '';
    ErrFlag := True;
    Nonascii := False;
    for I := 1 to Length(Input) do begin
        C := Ord(Input[I]);
        if C > $7f then begin
            Nonascii := True;
            break;
        end;
        if UseSTD3AsciiRules then begin  // don't check . now
            if (C <> $2e) AND (NOT IcsIsSTD3Ascii(C)) then Exit; // error CONTAINS_NON_LDH
        end;
    end;
    if NOT Nonascii then begin
        Result := AnsiString(Input);
        ErrFlag := False;
    end
    else begin
        for I := 1 to Length(Input) do begin
            Ch:=Input[I];
            if (Ch = '.')  or (Ch = #$3002)  or (Ch = #$ff0e) or (Ch = #$ff61) then  begin
                Result := Result + IcsPunyToASCII(Node, UseSTD3AsciiRules, ErrFlag) + '.';
                if ErrFlag then Exit;
                Node := '';
            end
            else
                Node := Node + Ch;
        end;
        Result := Result + IcsPunyToASCII(Node, True, ErrFlag);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ converts a Unicode label (no dota) into A-Label (Punycode ASCII) if any characters over x7F,
  preceding with ASCII Compatible Encoding (ACE) prefix xn-- }
function IcsPunyToASCII(const Input: UnicodeString): String;          { V9.1 added Puny }
var
    ErrFlag: Boolean;
begin
    Result := IcsPunyToASCII(Input, False, ErrFlag);
    if ErrFlag then Result := AnsiString(Input);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ converts a Unicode domain or host name into A-Label (Punycode ASCII) if any characters
  over x7F, preceding with ASCII Compatible Encoding (ACE) prefix xn-- }
function IcsIDNAToASCII(const Input: UnicodeString): String;
var
    ErrFlag: Boolean;
begin
    Result := IcsIDNAToASCII(Input, False, ErrFlag);
    if ErrFlag then Result := AnsiString(Input);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ RFC 3490 ToUnicode are a sequence of code points, the
   AllowUnassigned flag, and the UseSTD3ASCIIRules flag.  The output of
   ToUnicode is always a sequence of Unicode code points.
   1. If all code points in the sequence are in the ASCII range (0..7F)
      then skip to step 3.
   2. Perform the steps specified in [NAMEPREP] and fail if there is an
      error.  (If step 3 of ToASCII is also performed here, it will not
      affect the overall behavior of ToUnicode, but it is not
      necessary.)  The AllowUnassigned flag is used in [NAMEPREP].
   3. Verify that the sequence begins with the ACE prefix, and save a
      copy of the sequence.
   4. Remove the ACE prefix.
   5. Decode the sequence using the decoding algorithm in [PUNYCODE] and
      fail if there is an error.  Save a copy of the result of this step.
   6. Apply ToASCII.
   7. Verify that the result of step 6 matches the saved copy from step
      3, using a case-insensitive ASCII comparison.
   8. Return the saved copy from step 5.  }

{ converts an A-Label (Punycode ASCII) into Unicode label if ACE (ASCII Compatible
  Encoding) prefix xn-- found, returns unchanged if conversion fails }
function IcsPunyToUnicode(const Input: String; var ErrFlag: Boolean): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF} { V9.1 added Puny }
var
  Original, Working, Newone: String;
  Output: UnicodeString;
begin
    Original := Input;
    Result := UnicodeString(Original);

  // skip setps 1 and 2 since our input should be ANSI

    if Pos(ACE_PREFIX, Input) <> 1 then begin
        ErrFlag := False;
        exit;
    end;
    Working:= Copy(Input, Length(ACE_PREFIX) + 1, 999);
    Output := IcsPunyDecode(Working, ErrFlag);
    if ErrFlag then begin
        exit;
    end;

 // now convert it back to ASCII to confirm our decoding worked
    Newone := IcsPunyToASCII(Output, false, ErrFlag);
    if ErrFlag then begin
        exit;
    end;
    if IcsUpperCaseA(Newone) <> IcsUpperCaseA(Input) then begin
        exit;
    end;
    ErrFlag := False;
    result := Output;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ converts a A-Label (Punycode ASCII) domain or host name into Unicode if any ACE (ASCII
  Compatible Encoding) prefixes xn-- are found, returns unchanged if conversion fails }
function IcsIDNAToUnicode(const Input: String; var ErrFlag: Boolean): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    Ch: Char;
    I: Integer;
    Node: String;
begin
    if (Pos(ACE_PREFIX, Input) <= 0) then begin
        Result := UnicodeString(Input);
        ErrFlag := False;
    end
    else begin
        Result := '';
        Node := '';
        for I := 1 to Length(Input) do begin
            Ch := Input[I];
            if (Ch = '.') then begin
                Result := Result + IcsPunyToUnicode(Node, ErrFlag) + Ch;
                Node := '';
            end
            else
                Node := Node + Ch;
        end;
        Result := Result + IcsPunyToUnicode(Node, ErrFlag);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ converts an A-Label (Punycode ASCII) into Unicode label if ACE (ASCII Compatible
  Encoding) prefix xn-- found, returns unchanged if conversion fails }
function IcsPunyToUnicode(const Input: String): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    ErrFlag: Boolean;
begin
    Result := IcsPunyToUnicode(Input, ErrFlag);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ converts a A-Label (Punycode ASCII) domain or host name into Unicode if any ACE (ASCII
  Compatible Encoding) prefixes xn-- are found, returns unchanged if conversion fails }
function IcsIDNAToUnicode(const Input: String): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    ErrFlag: Boolean;
begin
    Result := IcsIDNAToUnicode(Input, ErrFlag);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsAnsiPosEx(const SubStr, Str: AnsiString; Offset: Integer = 1): Integer;   { V8.65 }
begin
{$IFDEF COMPILER17_UP}    { XE3 and later have improved Pos }
    Result := Pos(SubStr, Str, Offset);
{$ELSE}
  {$IFDEF UNICODE}
     Result := {$IFDEF RTL_NAMESPACES}System.{$ENDIF}AnsiStrings.PosEx(SubStr, Str, Offset);
  {$ELSE}
     Result := PosEx(SubStr, Str, Offset);
  {$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

function IcsPosEx(const SubStr, Str: UnicodeString; Offset: Integer = 1): Integer;  { V8.65 }
begin
{$IFDEF COMPILER17_UP}
    Result := Pos(SubStr, Str, Offset);
{$ELSE}
  {$IFDEF UNICODE}
      Result := StrUtils.PosEx(SubStr, Str, Offset);
  {$ELSE}
      Result := PosEx(AnsiString(SubStr), AnsiString(Str), Offset);
  {$ENDIF}
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.67 IcsStringBuild Class moved from OverbyteIcsBlacklist }
{ TIcsStringBuild will efficiently build ANSI or Unicode strings on all
  versions of Delphi, allowing access to the TBytes buffer to allow
  efficient extraction for writing to streams. }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TIcsStringBuild.Create (ABufferSize: integer = 4096; Wide: Boolean = False) ;
begin
    inherited Create;
    FIndex := 0;
    if Wide then
        FCharSize := 2
    else
        FCharSize := SizeOf(Char);
    Capacity(ABufferSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsStringBuild.Capacity(ABufferSize: integer);
begin
    if ABufferSize <= 1024 then ABufferSize := 1024;
    if ABufferSize < FBuffSize then exit;  // not smaller
    if ABufferSize <= FIndex then exit;    // sanity check
    FBuffSize := ABufferSize * FCharSize;
    FBuffMax := FBuffSize - 1;
    SetLength(FBuffer, FBuffSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsStringBuild.ExpandBuffer ;
begin
    FBuffSize := FBuffSize shl 1;
    Capacity(FBuffSize);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TIcsStringBuild.Destroy;
begin
    SetLength(FBuffer, 0);
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsStringBuild.AppendBufA(const AString: AnsiString);
var
    Len: integer;
begin
    Len := length (AString);
    if ((Len + FIndex) >= FBuffMax) then begin
        Capacity(Len + FIndex + 32);
        ExpandBuffer ;
    end;
    Move(AString[1], FBuffer[FIndex], Len);
    Inc(FIndex, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsStringBuild.AppendBufW(const AString: UnicodeString);
var
    Len : integer;
begin
    FCharSize := 2;
    Len := Length (AString) * FCharSize;
    if ((Len + FIndex) >= FBuffMax) then begin
        Capacity(Len + FIndex + 32);
        ExpandBuffer ;
    end;
    Move(AString[1], FBuffer[FIndex], Len);
    Inc(FIndex, Len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsStringBuild.AppendBuf(const AString: UnicodeString);
begin
    AppendBufW(AString);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsStringBuild.AppendLineA(const AString: AnsiString);
begin
    AppendBufA(AString);
    AppendBufA(IcsCRLF);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsStringBuild.AppendLine(const AString: UnicodeString);
begin
    AppendBuf(AString);
    AppendBuf(UnicodeString(IcsCRLF));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsStringBuild.AppendLineW(const AString: UnicodeString);
begin
    AppendBufW(AString);
    AppendBufW(UnicodeString(IcsCRLF));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsStringBuild.GetAString: AnsiString;
begin
    if FCharSize <> 1 {SizeOf (Char)} then begin
        Result := 'Need WideString Result';
        exit ;
    end;
    SetLength(Result, FIndex {div FCharSize});
    Move(FBuffer[0], Result[1], FIndex);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsStringBuild.GetWString: UnicodeString;
begin
    if FCharSize <> 2 then begin
        Result := 'Need AnsiString Result';
        exit ;
    end;
    SetLength(Result, FIndex div FCharSize);
    Move(FBuffer[0], Result[1], FIndex);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TIcsStringBuild.GetString: String;
begin
    if FCharSize = 2 then
        Result := String(GetWString)
    else
        Result := String(GetAString);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TIcsStringBuild.Clear;
begin
    FIndex := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.67 copied from OverbyteIcsIniFiles and made general purpose }
{ returns a shell path according to the CSIDL literals, ie CSIDL_LOCAL_APPDATA }
function IcsGetShellPath(CSIDL: Integer): UnicodeString;
{$IFDEF MSWINDOWS}
var
    Buf: array[0..MAX_PATH - 1] of WideChar;
const
    SHGFP_TYPE_CURRENT  = 0;
begin
    Result := '';
    if hSHFolderDLL = 0 then
        hSHFolderDLL := LoadLibrary('shfolder.dll');
    if hSHFolderDLL = 0 then
        Exit;
    @f_SHGetFolderPath := GetProcAddress(hSHFolderDLL, 'SHGetFolderPathW');
    if @f_SHGetFolderPath = nil then
        Exit;
    if Succeeded(f_SHGetFolderPath(0, CSIDL, 0, SHGFP_TYPE_CURRENT, Buf)) then
        Result := Buf;
{$ELSE}
begin
    if CSIDL = CSIDL_COMMON_APPDATA then    { V9.1 look for TPath equivalents }
        Result := TPath.GetPublicPath
    else if CSIDL = CSIDL_LOCAL_APPDATA then
        Result := TPath.GetHomePath
    else
        Result := TPath.GetCachePath;
{$ENDIF MSWINDOWS}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.4 Base 64 encoding, old versions working with AnsiChars, ICS does not used any of these
  but retained as deprecated for user applications, please update to the IcsBase versions }
function  Base64Encode(const Input : AnsiString) : AnsiString; overload; deprecated;
begin
    Result := AnsiString(IcsBase64Encode(String(Input)));
end;

function  Base64Encode(const Input : PAnsiChar; Len : Integer) : AnsiString; overload; deprecated;
begin
    Result := IcsBase64EncodeAC(Input, Len);
end;

{$IFDEF COMPILER12_UP}
function  Base64Encode(const Input : UnicodeString; ACodePage: LongWord) : UnicodeString; overload; deprecated;
begin
    Result := IcsBase64Encode(Input);
end;

function  Base64Encode(const Input : UnicodeString) : UnicodeString; overload; deprecated;
begin
    Result := IcsBase64Encode(Input);
end;
{$ENDIF}

function  Base64Decode(const Input : AnsiString) : AnsiString; overload; deprecated;
begin
    Result := IcsBase64DecodeA(Input);
end;

{$IFDEF COMPILER12_UP}
function  Base64Decode(const Input : UnicodeString; ACodePage: LongWord) : UnicodeString; overload; deprecated;
begin
    Result := IcsBase64DecodeU(Input, ACodePage);
end;

function  Base64Decode(const Input : UnicodeString) : UnicodeString; overload; deprecated;
begin
    Result := IcsBase64DecodeU(Input);
end;
{$ENDIF}

function Base64EncodeTB(Input: TBytes) : String; deprecated;                        { V9.1 }
begin
    Result := IcsBase64EncodeTB(Input);
end;

function Base64EncodeA(const Input : AnsiString) : AnsiString; deprecated;          { V9.1 avoid overload confusion }
begin
    Result := IcsBase64EncodeA(Input);
end;

function Base64DecodeTB(const Input : AnsiString): TBytes; overload; deprecated;    { V9.1 }
begin
    Result := IcsBase64DecodeTB(Input);
end;

{$IFDEF COMPILER12_UP}
function Base64DecodeTB(const Input : UniCodeString): TBytes; overload; deprecated;  { V9.1 }
begin
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ encode binary TBytes into ASCII Base64 Ansistring }
function IcsBase64EncodeTB(const Input: TBytes): AnsiString;       { V9.4 }
var
    Count, Len, I: Integer;
begin
    Count := 0;  // TBytes input  is base0
    Len := Length(Input);
    if Len = 0 then begin    { V9.5 }
        SetLength(Result, 0);
        Exit;
    end;
    I := Len;
    while (I mod 3) > 0 do
        Inc(I);
    I := (I div 3) * 4;
    SetLength(Result, I);
    I := 0;  // AnsString is base1
    while Count < Len do begin
        Inc(I);
        Result[I] := Base64OutA[(Input[Count] and $FC) shr 2];
        if (Count + 1) < Len then begin
            Inc(I);
            Result[I] := Base64OutA[((Input[Count] and $03) shl 4) + ((Input[Count + 1] and $F0) shr 4)];
            if (Count + 2) < Len then begin
                Inc(I);
                Result[I] := Base64OutA[((Input[Count + 1] and $0F) shl 2) + ((Input[Count + 2] and $C0) shr 6)];
                Inc(I);
                Result[I] := Base64OutA[(Input[Count + 2] and $3F)];
            end
            else begin
                Inc(I);
                Result[I] := Base64OutA[(Input[Count + 1] and $0F) shl 2];
                Inc(I);
                Result[I] := '=';
            end
        end
        else begin
            Inc(I);
            Result[I] := Base64OutA[(Input[Count] and $03) shl 4];
            Inc(I);
            Result[I] := '=';
            Inc(I);
            Result[I] := '=';
        end;
        Inc(Count, 3);
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ encode binary buffer into ASCII Base64 Ansistring }
function IcsBase64EncodeAC(const Input: PAnsiChar; Len: Integer): AnsiString;   { V9.4 }
var
    Buffer: TBytes;
begin
    SetLength(Buffer, Len);
    Move(Input[0], Buffer[0], Len);
    Result := IcsBase64EncodeTB(Buffer);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ encode binary content AnsiString ASCII Base64 Ansistring }
function IcsBase64EncodeA(const Input: AnsiString): AnsiString;            { V9.4 }
var
    Buffer: TBytes;
    Len: Integer;
begin
    Len := Length(Input);
    SetLength(Buffer, Len);
    Move(Input[1], Buffer[0], Len);
    Result := IcsBase64EncodeTB(Buffer);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ encode non-binary content String ASCII Base64 string }
function IcsBase64Encode(const Input: String): String;            { V9.4 }
begin
    Result := String(IcsBase64EncodeA(AnsiString(Input)));
end;


(*
{$IFDEF COMPILER12_UP}
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Converts the UnicodeString to AnsiString using the code page specified,   }
{ converts the Base64 AnsiString result to Unicode using default code page. }
function Base64Encode(const Input : UnicodeString; ACodePage: LongWord) : UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := String(Base64EncodeA(UnicodeToAnsi(Input, ACodePage)));          { V9.1 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Converts the UnicodeString to AnsiString using the default code page,     }
{ converts the Base64 AnsiString result to Unicode using default code page. }
function Base64Encode(const Input : UnicodeString) : UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := String(Base64EncodeA(AnsiString(Input)));                      { V9.1 }
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Base64Decode(const Input : AnsiString) : AnsiString;
var
    Count   : Integer;
    Len     : Integer;
    I       : Integer;
    DataIn0 : Byte;
    DataIn1 : Byte;
    DataIn2 : Byte;
    DataIn3 : Byte;
begin
    Count := 1;
    Len   := Length(Input);
    I     := 0;
    SetLength(Result, Len + 2);
    while Count <= Len do begin
        if Byte(Input[Count]) in [13, 10] then
            Inc(Count)
        else begin
            DataIn0 := Base64In[Byte(Input[Count])];
            DataIn1 := Base64In[Byte(Input[Count+1])];
            DataIn2 := Base64In[Byte(Input[Count+2])];
            DataIn3 := Base64In[Byte(Input[Count+3])];
            Inc(I);
            Result[I] := AnsiChar(((DataIn0 and $3F) shl 2) + ((DataIn1 and $30) shr 4));
            if DataIn2 <> $40 then begin
                Inc(I);
                Result[I] := AnsiChar(((DataIn1 and $0F) shl 4) + ((DataIn2 and $3C) shr 2));
                if DataIn3 <> $40 then begin
                    Inc(I);
                    Result[I] :=  AnsiChar(((DataIn2 and $03) shl 6) + (DataIn3 and $3F));
                end;
            end;
            Count := Count + 4;
        end;
    end;
    SetLength(Result, I);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ input ASCII base64, output binary TBytes }
function Base64DecodeTB(const Input : AnsiString): TBytes;            { V9.1 }
begin
    Result := IcsStringAToTBytes(Base64Decode(Input));
end;
*)

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ decode ASCII Base64 in AnsiString to binary TBytes }
function IcsBase64DecodeTB(const Input: AnsiString): TBytes;    { V9.4 }
var
    Count   : Integer;
    Len     : Integer;
    I       : Integer;
    DataIn0 : Byte;
    DataIn1 : Byte;
    DataIn2 : Byte;
    DataIn3 : Byte;
begin
    Count := 1;  // base1 string
    Len   := Length(Input);
    I     := -1;  // base0
    SetLength(Result, Len + 2);
    while Count <= Len do begin
        if Byte(Input[Count]) in [13, 10] then   // skip CR and LF
            Inc(Count)
        else begin
            DataIn0 := Base64In[Byte(Input[Count])];
            DataIn1 := Base64In[Byte(Input[Count+1])];
            DataIn2 := Base64In[Byte(Input[Count+2])];
            DataIn3 := Base64In[Byte(Input[Count+3])];
            Inc(I);
            Result[I] := ((DataIn0 and $3F) shl 2) + ((DataIn1 and $30) shr 4);
            if DataIn2 <> $40 then begin
                Inc(I);
                Result[I] := ((DataIn1 and $0F) shl 4) + ((DataIn2 and $3C) shr 2);
                if DataIn3 <> $40 then begin
                    Inc(I);
                    Result[I] := ((DataIn2 and $03) shl 6) + (DataIn3 and $3F);
                end;
            end;
            Count := Count + 4;
        end;
    end;
    SetLength(Result, I + 1);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ decode ASCII Base64 in AnsiString to binary AnsiString }
function IcsBase64DecodeA(const Input: AnsiString): AnsiString;      { V9.4 }
var
    Output: TBytes;
begin
    Output := IcsBase64DecodeTB(Input);
    Result := IcsTBytesToStringA(Output);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ decode ASCII Base64 in String to binary AnsiString }
function IcsBase64Decode(const Input: String): AnsiString;      { V9.4 }
begin
    Result := IcsBase64DecodeA(AnsiString(Input));
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Input must not be converted since it is plain US-ASCII, assumes one input }
{ char can safely be casted to one byte.                                    }
{$IFDEF COMPILER12_UP}
(*
function Base64Decode(const Input : UnicodeString; ACodePage: LongWord) : UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
var
    Count   : Integer;
    Len     : Integer;
    I       : Integer;
    DataIn0 : Byte;
    DataIn1 : Byte;
    DataIn2 : Byte;
    DataIn3 : Byte;
    Buf     : AnsiString;
begin
    Count := 1;
    Len   := Length(Input);
    I     := 0;
    SetLength(Buf, Len + 2);
    while Count <= Len do begin
        if Ord(Input[Count]) in [13, 10] then
            Inc(Count)
        else begin
            DataIn0 := Base64In[Byte(Input[Count])];
            DataIn1 := Base64In[Byte(Input[Count+1])];
            DataIn2 := Base64In[Byte(Input[Count+2])];
            DataIn3 := Base64In[Byte(Input[Count+3])];
            Inc(I);
            Buf[I] := AnsiChar(((DataIn0 and $3F) shl 2) + ((DataIn1 and $30) shr 4));
            if DataIn2 <> $40 then begin
                Inc(I);
                Buf[I] := AnsiChar(((DataIn1 and $0F) shl 4) + ((DataIn2 and $3C) shr 2));
                if DataIn3 <> $40 then begin
                    Inc(I);
                    Buf[I] :=  AnsiChar(((DataIn2 and $03) shl 6) + (DataIn3 and $3F));
                end;
            end;
            Count := Count + 4;
        end;
    end;
    SetLength(Buf, I);
    Result := AnsiToUnicode(Buf, ACodePage);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Base64Decode(const Input : UnicodeString) : UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}
begin
    Result := Base64Decode(Input, CP_ACP);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ input ASCII base64, output binary TBytes }
function Base64DecodeTB(const Input : UniCodeString): TBytes; {$IFDEF ANDROID} overload; {$ENDIF}        { V9.1 }
begin
    Result := IcsStringToTBytes(Base64Decode(Input));
end;
*)

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ decode ASCII Base64 in UnicodeString to binary UnicodeString with specific CodePage }
function IcsBase64DecodeU(const Input: UnicodeString; ACodePage: LongWord): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF} { V9.4 }
var
    Output: AnsiString;
begin
    Output := IcsBase64DecodeA(Ansistring(Input));
    Result := AnsiToUnicode(Output, ACodePage);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ decode ASCII Base64 in UnicodeString to binary UnicodeString with default CodePage }
function IcsBase64DecodeU(const Input: UnicodeString): UnicodeString; {$IFDEF ANDROID} overload; {$ENDIF}   { V9.4 }
begin
    Result := IcsBase64DecodeU(Input, CP_ACP);
end;

{$ENDIF COMPILER12_UP}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ create Json name:value pair, quoting if necessary }
{ WARNING - this function ignores Json character escaping and UTF8 encoding,
  and is only intended to build simple Json for JWS and JKW, not payloads,
  use ISuperObject, TRestParams or proper Json libraries.  }
{ input and output, strings, no conversion }
function IcsJsonPair(const S1, S2: String): String;   { V8.65 }
var
    Len: Integer;
begin
    Result := IcsDQUOTE + Trim(S1) + IcsDQUOTE + IcsCOLON;
    Len := Length(S2);
    if (Len >= 2) and ((S2[1]='{') and (S2[Len]='}')) or
                      ((S2[1]='[') and (S2[Len]=']')) then
        Result := Result + S2  // no quotes for array or json
    else
        Result := Result + IcsDQUOTE + S2 + IcsDQUOTE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ V8.67 RFC4658 base64 with trailing == removed, need to add them back  }
{ decode ASCII Base64Url in AnsiString to binary TBytes, use for binary fields }
function IcsBase64UrlDecodeATB(const Input: AnsiString): TBytes;      { V9.4 reworked }
var
    Work: AnsiString;
    NewLen, OldLen, I: Integer;
begin
    Work := Input;
    OldLen := Length(Work);
    NewLen := ((3 + OldLen) div 4) * 4;   { V8.64 too long }
    SetLength(Work, NewLen);
    while (OldLen < NewLen) do begin   // pad too short input so decoding works
        OldLen := OldLen + 1;
        Work [OldLen] := '=';
    end;
    for I := 1 to NewLen do begin
        if Work[I] = '-' then
            Work[I] := '+';
        if Work[I] = '_' then
            Work[I] := '/';
    end;
    Result := IcsBase64DecodeTB(Work);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ V8.67 RFC4658 base64 with trailing == removed, need to add them back  }
{ decode ASCII Base64Url in String to binary TBytes, use for binary fields }
function IcsBase64UrlDecodeTB(const Input: String): TBytes;           { V9.4 reworked }
begin
    Result := IcsBase64UrlDecodeATB(AnsiString(Input));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ RFC4658 base64 with trailing == removed and made URL safe, no CRLF allowed either  }
{ input binary TBytes, output ASCII Base64Url in Ansistring, use for binary stuff that may have nulls }
function IcsBase64UrlEncodeATB(const Input: TBytes): AnsiString;      { V9.4 reworked }
var
    I: Integer;
begin
    Result := IcsBase64EncodeTB(Input);
    while (Length(Result) > 0) and (Result[Length(Result)] = '=') do
        SetLength(Result, Length(Result) - 1);
    for I := 1 to Length(Result) do begin
        if Result[I] = '+' then
            Result[I] := '-';
        if Result[I] = '/' then
            Result[I] := '_';
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ RFC4658 base64 with trailing == removed and made URL safe, no CRLF allowed either  }
{ input binary TBytes, output ASCII Base64Url in string }
function IcsBase64UrlEncodeTB(const Input: TBytes): String;           { V9.1 }
begin
   Result := String(IcsBase64UrlEncodeATB(Input));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ RFC4658 base64 with trailing == removed, need to add them back  }
{ input ASCII Base64Url, output binary in string, don't use for binary !!! }
function IcsBase64UrlDecode(const Input: String): String;
var
    Work: TBytes;
//    S: String;
//    NewLen, I: Integer;
begin
{    S := Input;
    NewLen := ((3 + Length(S)) div 4) * 4;
    while (NewLen > Length(S)) do
        S := S + '=';
    for I := 1 to Length(S) do begin
        if S[I] = '-' then S[I] := '+';
        if S[I] = '_' then S[I] := '/';
    end;
    Result := Base64Decode(S);  }

    Work := IcsBase64UrlDecodeTB(Input);   { V9.4 reworked }
    Result := IcsTBytesToString(Work);
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ V8.67 RFC4658 base64 with trailing == removed, need to add them back  }
{ input ASCII base64, output binary in AnsiString, use for binary }
function IcsBase64UrlDecodeA(const Input: AnsiString): AnsiString;
var
    Work: TBytes;
//    S: String;
//    NewLen, I: Integer;
begin
 {   S := Input;
    NewLen := ((3 + Length(S)) div 4) * 4;
    while (NewLen > Length(S)) do
        S := S + '=';
    for I := 1 to Length(S) do begin
        if S[I] = '-' then S[I] := '+';
        if S[I] = '_' then S[I] := '/';
    end;
    Result := Base64Decode(S);   }

    Work := IcsBase64UrlDecodeATB(Input);          { V9.4 reworked }
    Result := IcsTBytesToString(Work);
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ RFC4658 base64 with trailing == removed and made URL safe, no CRLF allowed either  }
{ input binary AnsiString, output ASCII base64 in Ansistring, use for binary stuff that may have nulls }
function IcsBase64UrlEncodeA(const Input: AnsiString): AnsiString;
var
    Buffer: TBytes;
    Len: Integer;
begin
    Len := Length(Input);
    SetLength(Buffer, Len);
    Move(Input[1], Buffer[0], Len);
    Result := IcsBase64UrlEncodeATB(Buffer);                         { V9.4 reworked }

{    Result := Base64Encode(PAnsiChar(Input), Length(Input));
    while (Length(Result) > 0) and (Result[Length(Result)] = '=') do
        SetLength(Result, Length(Result) - 1);
    for I := 1 to Length(Result) do begin
        if Result[I] = '+' then Result[I] := '-';
        if Result[I] = '/' then Result[I] := '_';
    end;   }
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ RFC4658 base64 with trailing == removed and made URL safe, no CRLF allowed either  }
{ input binary string, output ASCII base64 in string, don't use for binary stuff, unicode gets converted }
function IcsBase64UrlEncode(const Input: String): String;
//var
//    I: Integer;
begin
   Result := String(IcsBase64UrlEncodeA(AnsiString(Input)));        { V9.4 reworked }

{    Result := Base64Encode(Input);
    while (Length(Result) > 0) and (Result[Length(Result)] = '=') do
        SetLength(Result, Length(Result) - 1);
    for I := 1 to Length(Result) do begin
        if Result[I] = '+' then Result[I] := '-';
        if Result[I] = '/' then Result[I] := '_';
    end;  }
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsFileInUse(FileName: String): Boolean;
{$IFDEF MSWINDOWS}
var
    hFileRes: HFILE;
{$ENDIF}
begin
    Result := False;
{$IFDEF MSWINDOWS}
    if IcsGetFileSize (FileName) < 0 then exit;
    hFileRes := CreateFile (PChar (FileName), GENERIC_READ or GENERIC_WRITE, 0,  nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0) ;
    Result := (hFileRes = INVALID_HANDLE_VALUE);
    if NOT Result then CloseHandle(hFileRes);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
// truncate file
function IcsTruncateFile(const FName: String; NewSize: int64): int64;
{$IFDEF MSWINDOWS}
var
    H: Integer;
{$ENDIF}
begin
    result := -1;   // file not found
{$IFDEF MSWINDOWS}
    if IcsGetFileSize (FName) < 0 then exit;  // unicode
    H := Integer(CreateFile (PChar (FName), GENERIC_READ or GENERIC_WRITE, 0,
                                   nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)) ;
    if H < 0 then exit;
    result := FileSeek (H, Int64 (0), soFromEnd) ;   // size of file
    if NewSize < result then
    begin
        result := FileSeek (H, NewSize, soFromBeginning) ;   // seek from start
        if result >= 0 then SetEndOfFile (H) ;   // change file size
    end ;
    FileClose(H);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.70 adjust long file names to allow use of more than 260 characters, if
  supported by the disk file system, unicode APIs only  }
function IcsAddLongPath(const S: UnicodeString): UnicodeString;
begin
  // see if trying to copy very long file names, add \\?\ to bypass file system checks
{$IFDEF MSWINDOWS}
    if (Length(S) > (IcsMaxPath - 20)) and (Pos(sPathExtended, S) <> 1) then begin
        if Pos('\\', S) = 1 then
            Result := sPathExtendedUNC + Copy(S, 3, 9999)  // \\?\UNC\server\share\file
        else
            Result := sPathExtended + S                    // \\?\c:\file
    end
    else
{$ENDIF MSWINDOWS}
        Result := S;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.70 returns a short compiler version number or name as a string  }
function IcsBuiltWith: String;
begin
    Result := '?';
{$IFDEF VER380}
    Result := '14.0';        { V9.5 future }
{$ENDIF}
{$IFDEF Ver370}
    Result := '13.0'         { V9.5 }
    {$IF Declared(RTLVersion131)}Result := '13.1';{$IFEND}    // guessing
{$ENDIF}
{$IFDEF VER360}
    Result := '12.0';
    {$IF Declared(RTLVersion121)}Result := '12.1';{$IFEND}
    {$IF Declared(RTLVersion122)}Result := '12.2';{$IFEND}   // V9.3
    {$IF Declared(RTLVersion123)}Result := '12.3';{$IFEND}   // V9.4
{$ENDIF}
{$IFDEF VER350}
    Result := '11.0';
    {$IF Declared(RTLVersion111)}Result := '11.1';{$IFEND}
    {$IF Declared(RTLVersion112)}Result := '11.2';{$IFEND}  // all declared
    {$IF Declared(RTLVersion113)}Result := '11.3';{$IFEND}  // all declared V8.71
{$ENDIF}
{$IFDEF VER340}
    Result := '10.4';
    {$IF Declared(RTLVersion1041)}Result := '10.41';{$IFEND}
    {$IF Declared(RTLVersion1042)}Result := '10.42';{$IFEND}  // both declared
{$ENDIF}
{$IFDEF VER330}Result := '10.3';{$ENDIF}
{$IFDEF VER320}Result := '10.2';{$ENDIF}
{$IFDEF VER310}Result := '10.1';{$ENDIF}
{$IFDEF VER300}Result := '10';{$ENDIF}
{$IFDEF VER290}Result := 'XE8';{$ENDIF}
{$IFDEF VER280}Result := 'XE7';{$ENDIF}
{$IFDEF VER270}Result := 'XE6';{$ENDIF}
{$IFDEF VER260}Result := 'XE5';{$ENDIF}
{$IFDEF VER250}Result := 'XE4';{$ENDIF}
{$IFDEF VER240}Result := 'XE3';{$ENDIF}
{$IFDEF VER230}Result := 'XE2';{$ENDIF}
{$IFDEF VER220}Result := 'XE';{$ENDIF}
{$IFDEF VER210}Result := '2010';{$ENDIF}
{$IFDEF VER200}Result := '2009';{$ENDIF}
{$IFDEF VER190}Result := '2007.NET'{$ENDIF}
{$IFDEF VER180}{$IFDEF VER185} Result := '2007';{$ELSE}Result := '2006';{$ENDIF}{$ENDIF}
{$IFDEF VER170} Result := '2005';{$ENDIF}
{$IFDEF VER160}Result := '8.NET';{$ENDIF}
{$IFDEF VER150}Result := '7';{$ENDIF}
{$IFDEF VER140}Result := '6';{$ENDIF}
{$IFDEF VER130} Result := '5';{$ENDIF}
{$IFDEF VER125}Result := '4';{$ENDIF}
{$IFDEF VER120}Result := '4';{$ENDIF}
{$IFDEF VER110}Result := '3';{$ENDIF}
{$IFDEF VER100}Result := '3';{$ENDIF}
{$IFDEF VER93}Result := '2';{$ENDIF}
{$IFDEF VER90}Result := '2';{$ENDIF}
{$IFDEF VER80}Result := '1';{$ENDIF}
{$IFDEF LCL}Result := 'Lazarus ' + lcl_version;{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.70 returns an extended compiler version number or name and platform  }
function IcsBuiltWithEx: String;
begin
{$IFDEF BCB}Result := 'BCB ';{$ELSE}Result := 'Delphi ';{$ENDIF}
Result := Result + IcsBuiltWith;
{$IFDEF WIN32}Result := Result + ' Win32';{$ENDIF}
{$IFDEF WIN64}Result := Result + ' Win64';{$ENDIF}
{$IFDEF MACOS32}Result := Result + ' macOS32';{$ENDIF}
{$IFDEF MACOS64}Result := Result + ' macOS64';{$ENDIF}
{$IFDEF Linux32}Result := Result + ' Linux32';{$ENDIF}      { V9.1 }
{$IFDEF Linux64}Result := Result + ' Linux64';{$ENDIF}
{$IFDEF Android32}Result := Result + ' Android32';{$ENDIF}  { V9.1 }
{$IFDEF Android64}Result := Result + ' Android64';{$ENDIF}  { V9.1 }
{$IFDEF IOS}Result := Result + ' IOS';{$ENDIF}              { V9.1 }
{$IFDEF OSX}Result := Result + ' OSX';{$ENDIF}              { V9.1 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ case insensitive text at start of line }
function IcsTextOnStart(const ATextOnStart, AText : String ): Boolean;   { V8.71 }
var
  LText, LTextStart, i : Longint;
begin
  Result := False;

  LTextStart := Length(ATextOnStart);
  LText      := Length(AText);

  if LText < LTextStart then Exit; // start must have >= length as scanned string

  for i := 1 to LTextStart do
    if UpCase(ATextOnStart[i]) <> UpCase(AText[i]) then Exit;

  Result := True;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ case insensitive text at start of line }
function IcsTextOnStartA(const ATextOnStart, AText : AnsiString ): Boolean;  { V8.71 }
var
  LText, LTextStart, i : Longint;
begin
  Result := False;
  LTextStart := Length(ATextOnStart);
  LText      := Length(AText);
  if LText < LTextStart then Exit; // start must have >= length as scanned string
  for i := 1 to LTextStart do
    if UpCase(ATextOnStart[i]) <> UpCase(AText[i]) then Exit;
  Result := True;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.67 does program have administrator access }
{ V8.71 moved from OverbyteIcsMsSslUtils }
{$IFDEF MSWINDOWS}
function IcsIsProgAdmin: Boolean;
var
    psidAdmin: Pointer;
    Token: THandle;
    Count: DWORD;
    TokenInfo: PTokenGroups;
    HaveToken: Boolean;
    I: Integer;
const
    SE_GROUP_USE_FOR_DENY_ONLY  = $00000010;
    SECURITY_NT_AUTHORITY: TSidIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
    SECURITY_BUILTIN_DOMAIN_RID  = ($00000020);
    DOMAIN_ALIAS_RID_ADMINS      = ($00000220);
begin
    Result := False;
    if Win32Platform <> VER_PLATFORM_WIN32_NT then
    begin
       result := true ;
       exit ;
    end ;
    psidAdmin := nil;
    TokenInfo := nil;
    HaveToken := False;
    try
        HaveToken := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, Token);
        if (not HaveToken) and (GetLastError = ERROR_NO_TOKEN) then
            HaveToken := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, Token);
        if HaveToken then begin
            Win32Check(AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
                SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, psidAdmin));
            if GetTokenInformation(Token, TokenGroups, nil, 0, Count) or
                                (GetLastError <> ERROR_INSUFFICIENT_BUFFER) then
                RaiseLastOSError;
            TokenInfo := PTokenGroups(AllocMem(Count));
            Win32Check(GetTokenInformation(Token, TokenGroups, TokenInfo, Count, Count));
            for I := 0 to TokenInfo^.GroupCount - 1 do begin
            {$RANGECHECKS OFF} // Groups is an array [0..0] of TSIDAndAttributes, ignore ERangeError
                Result := EqualSid(psidAdmin, TokenInfo^.Groups[I].Sid) and
                      (TokenInfo^.Groups[I].Attributes and SE_GROUP_USE_FOR_DENY_ONLY = 0); //Vista??
            {$IFDEF RANGECHECKS_ON}
            {$RANGECHECKS ON}
            {$ENDIF RANGECHECKS_ON}
                if Result then
                    Break;
            end;
        end;
    finally
        if TokenInfo <> nil then
            FreeMem(TokenInfo);
        if HaveToken then
            CloseHandle(Token);
        if psidAdmin <> nil then
            FreeSid(psidAdmin);
    end;
end;
{$ENDIF}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.1 replace control codes (< space) in String with ~, result is String }
function IcsStrRemCntls(const S: String; LeaveCRLF: Boolean = True): String;
var
    Len, Offset: Integer;
    Source: PChar;
begin
    Result := S;
    Len := Length(Result);
    Source := Pointer (Result);
    Offset := 1;
    while Offset <= Len do
    begin
        if (Source^ < IcsSpace) then begin
            if (Source^ = IcsNull) then
                Source^ := '~'
            else if ((Source^ <> IcsCR) and (Source^ <> IcsLF)) then
                Source^ := '~'
            else if (NOT (LeaveCRLF)) then
                Source^ := '~' ;
        end;
        Inc (Source) ;
        Inc (Offset) ;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.1 replace control codes (< space) in AnsiString with ~, result is String }
function IcsStrRemCntlsA(const S: AnsiString; LeaveCRLF: Boolean = True): String;
var
    Work: AnsiString;
    Len, Offset: Integer;
    Source: PAnsiChar;
begin
    Work := S;
    Len := Length(Work);
    Source := Pointer (Work);
    Offset := 1;
    while Offset <= Len do
    begin
        if (Source^ < IcsSpace) then begin
            if (Source^ = IcsNull) then
                Source^ := '~'
            else if ((Source^ <> IcsCR) and (Source^ <> IcsLF)) then
                Source^ := '~'
            else if (NOT (LeaveCRLF)) then
                Source^ := '~' ;
        end;
        Inc (Source) ;
        Inc (Offset) ;
    end;
    Result := String(Work);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.1 replace control codes (< space) in TBytes with ~, result is String }
function IcsStrRemCntlsTB(const TB: TBytes; LeaveCRLF: Boolean = True): String;
var
    Work: AnsiString;
begin
    SetLength(Work, Length(TB));
    Move(TB[0], Work[1], Length(TB));
    Result := IcsStrRemCntlsA(Work, LeaveCRLF);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.1 break up text into multiple lines ol specified length, default 132, no CRLF at end }
function IcsStrBeakup(const S: String; MaxLine: Integer = 132): String;
var
    LfPos, LLen, Offset, SLen: Integer;
begin
    Result := '';
    SLen := Length(S);
    if SLen = 0 then
        Exit;
    if MaxLine < 8 then
        MaxLine := 8;
    Offset := 1;
    while Offset < SLen do begin
        LfPos := IcsPosEx(IcsCRLF, S, Offset);
        LLen := LfPos - Offset + 2;  // add CRLF
        if (LfPos = 0) or (LLen > (MaxLine + 2)) then begin
            LLen := MaxLine;
            Result := Result + Copy (S, Offset, Llen) + IcsCRLF;
        end
        else
            Result := Result + Copy (S, Offset, Llen);
        Offset := Offset + LLen;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.1 convert DataTime to string hh:mm:ss:zzz }
function IcsTimeToZStr(const DT: TDateTime): string;
begin
    DateTimeToString(Result, ISOLongTimeMask, DT);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.1 read TBytes from a named resource }
function IcsResourceGetTB(const ResName: String; const ResType: PChar = RT_RCDATA): TBytes;
var
    ResStream : TResourceStream;
    ActualRead: Integer;
begin
    SetLength(Result, 0);
    try
        ResStream := TResourceStream.Create(HInstance, ResName, ResType);
        try
            if Assigned(ResStream) then begin
                SetLength(Result, ResStream.Size);
                if ResStream.Size > 0 then begin
                    ActualRead := ResStream.Read(Result[0], ResStream.Size);
                    SetLength(Result, ActualRead);
                end;
            end;
        finally
            ResStream.Free;
        end;
    except
        SetLength(Result, 0);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.1 save file from a named resource, optionally replace, returns size or 0 for error }
{ for no replace, if old file exists and is same size, skips save and returns size, ie OK }
function IcsResourceSaveFile(const ResName, FileName: String; Replace: Boolean = False): Integer;
var
    ResStream : TResourceStream;
    OldSize: Integer;
begin
    Result := 0;
    try
        ResStream := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
        try
            OldSize := IcsGetFileSize(FileName);
            if Replace then begin
                if (OldSize <> 0) then
                    IcsDeleteFile(FileName, True);
                ResStream.SaveToFile(FileName);
            end
            else begin
                if (OldSize <> ResStream.Size) then   // skip if same size
                    ResStream.SaveToFile(FileName);
            end;
            Result := ResStream.Size;
        finally
            ResStream.Free;
        end;
    except
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.1 write TBytes to a file, optionally replacing, true is OK }
function IcsDataSaveFile(const Data: TBytes; const FileName: String; Replace: Boolean = False): Boolean; { V9.1 }
var
    NewFStream: TFileStream;
    Attempts: integer;
begin
    Result := False ; ;
    if Length(Data) = 0 then
        Exit;
    for Attempts := 1 to 3 do begin
        try
            if FileExists(FileName) then begin
                if NOT Replace then
                    Exit;
                if NOT DeleteFile(FileName) then
                    exit ;
            end;
            if NOT ForceDirectories(ExtractFileDir (FileName)) then
                continue;
            try
                NewFStream := TFileStream.Create (FileName, fmCreate) ;
                NewFStream.WriteBuffer(Data[0], Length(Data)) ;
                Result := true ;
                Exit;
            finally
                FreeAndNil(NewFStream) ;
            end;
        except
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.1 read TBytes from a file, blank for failure, default max 10MB }
function IcsDataLoadFile(const FileName: String; MaxLen: Integer = 10240000): TBytes;  { V9.1 }
var
    OldFStream: TFileStream;
    FSize: Int64;
begin
    SetLength(Result, 0);
    if FileExists(FileName) then
    try
        try
            OldFStream := TFileStream.Create (FileName, fmShareDenyNone) ;
            FSize := OldFStream.Size;
            if FSize > MaxLen then
                FSize := MaxLen;
            SetLength(Result, FSize);
            if FSize  > 0 then
                OldFStream.Read(Result[0], Fsize);
        finally
            FreeAndNil(OldFStream) ;
        end;
    except
    end;
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ removes /. and /.. from path to absolutise it, used by ICS demos }
{ ie "C:\DelphiComp\ics\demos-delphi-vcl\bin\Win32\Release\..\..\..\app.ini" to "C:\DelphiComp\ics\demos-delphi-vcl\app.ini" }
{ ie "C:\DelphiComp\ics\demos-delphi-vcl\bin\Win32\Release\..\..\..\..\demos-data\WebServData" to "C:\DelphiComp\ics\demos-data\WebServData" }
function IcsAbsolutisePath(const Path : String) : String;          { V9.1 moved from HttpSrv }
var
    I, J, N : Integer;
begin
    if (Path = '') or (Path = '.') or  (Path = '..') then begin
        Result := '';
        Exit;
    end;

    Result := Path;
    N      := 0;
    if (Length(Result) > 2) and
       (Copy(Result, Length(Result) - 1, 2) = {$IFDEF MSWINDOWS} '\.' {$ELSE} '/.' {$ENDIF}) then
       Result := Copy(Result, 1, Length(Result) - 2);

    if Length(Result) > 1 then begin
       if (Result[1] = PathDelim) and (Result[2] = PathDelim) then begin
            N := 2;
            while (N < Length(Result)) and (Result[N + 1] <> PathDelim) do
                Inc(N);
       end
       else if Result[2] = ':' then
           N := 2;
    end;

    if (Copy(Result, N + 1, 5) = PathDelim) or
       (Copy(Result, N + 1, 5) = {$IFDEF MSWINDOWS} '\.' {$ELSE} '/.' {$ENDIF}) then begin
       Result := Copy(Result, 1, N + 1);
       Exit;
    end;

    while TRUE do begin
        I := Pos({$IFDEF MSWINDOWS} '\.\' {$ELSE} '/./' {$ENDIF}, Result);
        if I <= N then
            break;
        Delete(Result, I, 2);
    end;
    while TRUE do begin
        I := Pos({$IFDEF MSWINDOWS} '\..' {$ELSE} '/..' {$ENDIF}, Result);
        if I <= N then
            break;
        J := I - 1;
        while (J > N) and (Result[J] <> PathDelim) do
            Dec(J);
        if J <= N then
            Delete(Result, J + 2, I - J + 2)
        else
            Delete(Result, J, I - J + 3);
    end;
end;

{ V9.3 moved various IPv4/6 conversion functions here from OverbyteIcsWSocket }

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Check for a valid numeric dotted IPv4 address such as 192.161.65.25         }
{ Accept leading and trailing spaces.                                       }
{ Note. full numeric IP not supported. ie 3650250390                        }
function WSocketIsDottedIP(const S : AnsiString) : Boolean;
var
    I          : Integer;
    DotCount   : Integer;
    NumVal     : Integer;
begin
    Result     := FALSE;
    DotCount   := 0;
    NumVal     := 0;
    I          := 1;

    { Skip leading spaces }
    while (I <= Length(S)) and (S[I] = ' ') do
        Inc(I);
    { Can't begin with a dot }
    if (I <= Length(S)) and (S[I] = '.') then
        Exit;
    { Scan full string }
    while I <= Length(S) do begin
        if S[I] = '.' then begin
            Inc(DotCount);
            if (DotCount > 3) or (NumVal > 255) then
                Exit;
            NumVal := 0;
            { A dot must be followed by a digit }
            if (I >= Length(S)) or (not (AnsiChar(S[I + 1]) in ['0'..'9'])) then
                Exit;
        end
        else if AnsiChar(S[I]) in ['0'..'9'] then begin
            NumVal := NumVal * 10 + Ord(S[I]) - Ord('0');
            if NumVal > 255 then
                Exit;  { V8.66 max IPv4 address, stop integer overflow }
        end
        else begin
            { Not a digit nor a dot. Accept spaces until end of string }
            while (I <= Length(S)) and (S[I] = ' ') do
                Inc(I);
            if I <= Length(S) then
                Exit;  { Not a space, do not accept }
            break;     { Only spaces, accept        }
        end;
        Inc(I);
    end;
    { We must have exactly 3 dots }
    if (DotCount <> 3) or (NumVal > 255) then
        Exit;
    Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketIsDottedIP(const S : UnicodeString) : Boolean;     { V8.70 }
begin
    Result := WSocketIsDottedIP(AnsiString(S));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketIsIPv4(const S: string): Boolean;
var
    I      : Integer;
    DotCnt : Integer;
    NumVal : Integer;
    Ch     : Char;
    P      : PChar;
begin
    Result := FALSE;
    DotCnt := 0;
    NumVal := -1;
    P      := PChar(S);
    for I := 1 to Length(S) do
    begin
        Ch := P[I - 1];
        case Ch of
          '.' :
              begin
                  Inc(DotCnt);
                  if (DotCnt > 3) or (NumVal = -1) then
                      Exit;
                  NumVal := -1;
              end;
          '0'..'9':
              begin
                  if NumVal = -1 then
                      NumVal := Ord(Ch) - Ord('0')
                  else
                      NumVal := NumVal * 10 + Ord(Ch) - Ord('0');
                  if NumVal > 255 then
                      Exit;
              end;
          else
              Exit;
        end;
    end;

    Result := DotCnt = 3;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Byte order translated }
function WSocketIPv4ToStr(const AIcsIPv4Addr: TIcsIPv4Address): string;
begin
{$IFNDEF BIG_ENDIAN}
    Result := IntToStr(AIcsIPv4Addr and $FF)+ '.' +
              IntToStr((AIcsIPv4Addr shr  8) and $FF) + '.' +
              IntToStr((AIcsIPv4Addr shr 16) and $FF) + '.' +
              IntToStr((AIcsIPv4Addr shr 24) and $FF);
{$ELSE}
    Result := IntToStr((AIcsIPv4Addr shr 24) and $FF) + '.' +
              IntToStr((AIcsIPv4Addr shr 16) and $FF) + '.' +
              IntToStr((AIcsIPv4Addr shr  8) and $FF) + '.' +
              IntToStr(AIcsIPv4Addr and $FF);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Byte order translated }
function WSocketStrToIPv4(const S: string; out Success: Boolean): TIcsIPv4Address;
var
    I          : Integer;
    DotCount   : Integer;
    NumVal     : Integer;
    Len        : Integer;
    Ch         : Char;
    Bytes      : array [0..3] of Byte;
begin
    Result    := TIcsIPv4Address($FFFFFFFF);
    Success   := FALSE;
    Len       := Length(S);
    if Len < 6 then
        Exit;
    DotCount  := 0;
    NumVal    := -1;
    for I := 1 to Len do
    begin
        Ch := S[I];
        case Ch of
          '.' :
              begin
                  if (NumVal > -1) and (DotCount < 3) then
                      Bytes[DotCount] := NumVal
                  else
                      Exit;
                  Inc(DotCount);
                  NumVal := -1;
              end;
          '0'..'9':
              begin
                  if NumVal < 0 then
                      NumVal := Ord(Ch) - Ord('0')
                  else
                      NumVal := NumVal * 10 + Ord(Ch) - Ord('0');
                  if NumVal > 255 then
                      Exit;
              end;
          else
              Exit;
        end;
    end;

    if (NumVal > -1) and (DotCount = 3) then
    begin
        Bytes[DotCount] := NumVal;
    {$IFNDEF BIG_ENDIAN}
        Result := PIcsIPv4Address(@Bytes)^;
    {$ELSE}
        Result := IcsSwap32(PIcsIPv4Address(@Bytes)^);
    {$ENDIF}
        Success := TRUE;
    end;

end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Byte order translated }
function WSocketIPv6ToStr(const AIcsIPv6Addr: TIcsIPv6Address): string;
var
    I : Integer;
    Zeros1, Zeros2 : set of Byte;
    Zeros1Cnt, Zeros2Cnt : Byte;
    OmitFlag : Boolean;
begin
    Result := '';
    Zeros1 := [];
    Zeros2 := [];
    Zeros1Cnt := 0;
    Zeros2Cnt := 0;
    for I := Low(AIcsIPv6Addr.Words) to High(AIcsIPv6Addr.Words) do
    begin
        if AIcsIPv6Addr.Words[I] = 0 then
        begin
            Include(Zeros1, I);
            Inc(Zeros1Cnt);
        end
        else if Zeros1Cnt > Zeros2Cnt then
        begin
            Zeros2Cnt := Zeros1Cnt;
            Zeros2    := Zeros1;
            Zeros1    := [];
            Zeros1Cnt := 0;
        end;
    end;
    if Zeros1Cnt > Zeros2Cnt then
    begin
        Zeros2    := Zeros1;
        Zeros2Cnt := Zeros1Cnt;
    end;

   if Zeros2Cnt = 0 then
   begin
        for I := Low(AIcsIPv6Addr.Words) to High(AIcsIPv6Addr.Words) do
        begin
            if I = 0 then
            {$IFNDEF BIG_ENDIAN}
                Result := IntToHex(IcsSwap16(AIcsIPv6Addr.Words[I]), 1)
            {$ELSE}
                Result := IntToHex(AIcsIPv6Addr.Words[I], 1)
            {$ENDIF}
            else
            {$IFNDEF BIG_ENDIAN}
                Result := Result + ':' + IntToHex(IcsSwap16(AIcsIPv6Addr.Words[I]), 1);
            {$ELSE}
                Result := Result + ':' + IntToHex(AIcsIPv6Addr.Words[I], 1);
            {$ENDIF}
        end;
    end
    else begin
        OmitFlag := FALSE;
        for I := Low(AIcsIPv6Addr.Words) to High(AIcsIPv6Addr.Words) do
        begin
            if not (I in Zeros2) then
            begin
                if OmitFlag then
                begin
                    if Result = '' then
                        Result := '::'
                    else
                        Result := Result + ':';
                    OmitFlag := FALSE;
                end;
                if I < High(AIcsIPv6Addr.Words) then
                {$IFNDEF BIG_ENDIAN}
                    Result := Result + IntToHex(IcsSwap16(AIcsIPv6Addr.Words[I]), 1) + ':'
                {$ELSE}
                    Result := Result + IntToHex(AIcsIPv6Addr.Words[I], 1) + ':'
                {$ENDIF}
                else
                {$IFNDEF BIG_ENDIAN}
                    Result := Result + IntToHex(IcsSwap16(AIcsIPv6Addr.Words[I]), 1);
                {$ELSE}
                    Result := Result + IntToHex(AIcsIPv6Addr.Words[I], 1);
                {$ENDIF}
            end
            else
                OmitFlag := TRUE;
        end;
        if OmitFlag then
        begin
            if Result = '' then
                Result := '::'
            else
                Result := Result + ':';
        end;
        if Result = '' then
            Result := '::';
    end;
    Result := IcsLowerCase(Result);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ TIcsIPv6Address is record of words, so need to compare memory }
function  WSocketIPv6Same(const IP1, IP2: TIcsIPv6Address): Boolean;         { V8.71 }
begin
    Result := CompareMem(@IP1, @IP2, SizeOf(TIcsIPv6Address));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Byte order translated }
function WSocketStrToIPv6(const S: string; out Success: Boolean): TIcsIPv6Address;
var
    ScopeID : Cardinal;
begin
    Result := WSocketStrToIPv6(S, Success, ScopeID);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Byte order translated }
function WSocketStrToIPv6(const S: string; out Success: Boolean; out ScopeID: Cardinal): TIcsIPv6Address;
const
    Colon       = ':';
    Percent     = '%';
var
    ColonCnt    : Integer;
    I           : Integer;
    NumVal      : Integer;
    Ch          : Char;
    P           : PChar;
    SLen        : Integer;
    OmitPos     : Integer;
    OmitCnt     : Integer;
    PartCnt     : Byte;
    ScopeFlag   : Boolean;
begin
    Success     := FALSE;
    FillChar(Result.Words[0], SizeOf(Result), 0);
    SLen := Length(S);
    if (SLen < 1) or (SLen > (4 * 8) + 7) then
        Exit;
    ColonCnt := 0;
    P := PChar(S);
    for I := 0 to SLen - 1 do
        if (P[I] = Colon) then
            Inc(ColonCnt);
    if ColonCnt > 7 then
        Exit;
    OmitPos := Pos('::', S) - 1;
    if OmitPos > -1 then
        OmitCnt := 8 - ColonCnt
    else begin
        OmitCnt := 0; // Make the compiler happy
        if (P[0] = Colon) or (P[SLen - 1] = Colon) then
            Exit;
    end;
    NumVal    := -1;
    ColonCnt  := 0;
    PartCnt   := 0;
    I         := 0;
    ScopeID   := 0;
    ScopeFlag := FALSE;
    while I < SLen do
    begin
        Ch := P[I];
        case Ch of
            Percent : // scope_id / interface ID follows
                begin
                    if ScopeFlag then
                        Exit
                    else
                        ScopeFlag := TRUE;

                    PartCnt := 0;
                    if NumVal > -1 then
                    begin
                    {$IFNDEF BIG_ENDIAN}
                        Result.Words[ColonCnt] := IcsSwap16(NumVal);
                    {$ELSE}
                        Result.Words[ColonCnt] := NumVal;
                    {$ENDIF}
                        NumVal := -1;
                    end;
                end;
            Colon :
                begin
                    if ScopeFlag then
                        Exit;
                    PartCnt := 0;
                    if NumVal > -1 then
                    begin
                    {$IFNDEF BIG_ENDIAN}
                        Result.Words[ColonCnt] := IcsSwap16(NumVal);
                    {$ELSE}
                        Result.Words[ColonCnt] := NumVal;
                    {$ENDIF}
                        NumVal := -1;
                    end;
                    if (OmitPos = I) then
                    begin
                        Inc(ColonCnt, OmitCnt);
                        Inc(I);
                    end;
                    Inc(ColonCnt);
                    if ColonCnt > 7 then
                        Exit;
                end;
            '0'..'9':
                begin
                    Inc(PartCnt);
                    if NumVal < 0 then
                        NumVal := (Ord(Ch) - Ord('0'))
                    else if ScopeFlag then
                        NumVal := NumVal * 10 + (Ord(Ch) - Ord('0'))
                    else
                        NumVal := NumVal * 16 + (Ord(Ch) - Ord('0'));
                    if (NumVal > High(Word)) or (PartCnt > 4) then
                        Exit;
                end;
            'a'..'z',
            'A'..'Z' :
                begin
                    if ScopeFlag then
                        Exit;
                    Inc(PartCnt);
                    if NumVal < 0 then
                        NumVal := ((Ord(Ch) and 15) + 9)
                    else
                        NumVal := NumVal * 16 + ((Ord(Ch) and 15) + 9);
                    if (NumVal > High(Word)) or (PartCnt > 4) then
                        Exit;
                end;
            else
                Exit;
        end;
        Inc(I);
    end;

    if (NumVal > -1) and (ColonCnt > 1) then
    begin
        if not ScopeFlag then
        begin
        {$IFNDEF BIG_ENDIAN}
            Result.Words[ColonCnt] := IcsSwap16(NumVal);
        {$ELSE}
            Result.Words[ColonCnt] := NumVal;
        {$ENDIF}
        end
        else
            ScopeID := NumVal;
    end;
    Success := ColonCnt > 1;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketIsIP(const S: string; out ASocketFamily: TSocketFamily): Boolean;
begin
    Result := WSocketIsIPv4(S);
    if Result then
        ASocketFamily := sfIPv4
    else begin
        WSocketStrToIPv6(S, Result);
        if Result then
            ASocketFamily := sfIPv6
        else
            ASocketFamily := sfAny;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketIsIPEx(const S: string; out ASocketFamily: TSocketFamily): Boolean;   { V8.01 }
begin
    Result := WSocketIsIP(S, ASocketFamily);
    if Result then begin
        if S = ICS_ANY_HOST_V4 then
            ASocketFamily := sfAnyIPv4
        else if S = ICS_ANY_HOST_V6 then
            ASocketFamily := sfAnyIPv6;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsReverseIP(const IP : String) : AnsiString;    { V8.71 moved from DnsQuery }
var
    I, J : Integer;
begin
    Result := '';
    if Length(IP) = 0 then
        Exit;
    J := Length(IP);
    I := J;
    while I >= 0 do begin
        if (I = 0) or (IP[I] = '.') then begin
            Result := Result + '.' + AnsiString(Copy(IP, I + 1, J - I));
            J := I - 1;
        end;
        Dec(I);
    end;
    if Result[1] = '.' then
        Delete(Result, 1, 1);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsReverseIPv6(const IPv6: String): AnsiString;    { V8.71 moved from DnsQuery }
var
    I, J: Integer;
    Pair: Word;
    IPv6Addr: TIcsIPv6Address;
    Success: Boolean;
    Hex: AnsiString;
begin
    Result := '';
    IPv6Addr := WSocketStrToIPv6(IPv6, Success);
    if NOT Success then Exit;
    for I := 7 downto 0 do begin
        pair := IPv6Addr.Words[I];
    {$IFNDEF BIG_ENDIAN}
        pair := IcsSwap16(pair);
    {$ENDIF}
        Hex := AnsiString(IntToHex(pair, 4));
        for J := 4 downto 1 do
            Result := Result + Hex[J] + '.';
    end;
    Result := IcsLowerCaseA(Result);
    SetLength(Result, Length(Result) - 1);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.5 convert an IPv4/v6 SocAddr into 4 or 16 byte binary address TBytes }
function  IcsSocIpBytes(const ASockAddr: TSockAddrIn6): TTcsIpBytes;            { V9.5 }
begin
    if ASockAddr.sin6_family = AF_INET6 then begin
        SetLength(Result, 16);
        Move(ASockAddr.sin6_addr.u6_addr16, Result[0], 16);
    end
    else if ASockAddr.sin6_family = AF_INET then begin
        SetLength(Result, 4);
        Move(PSockAddrIn(@ASockAddr).sin_addr.S_byte[0], Result[0], 4);
    end
    else
        SetLength(Result, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.5 convert 4 or 16 byte binary address TBytes into string IPv4/v6 address }
function IcsIpBytesToStr(IpBytes: TTcsIpBytes): String;   { V9.5 }
var
    AIPv6: TIcsIPv6Address;
    AIPv4: in_addr;
begin
    Result := '';
    if Length(IpBytes) = 16 then begin
        Move(IpBytes[0], AIPv6.Words[0], 16);
        Result := WSocketIPv6ToStr(AIPv6);
    end
    else if Length(IpBytes) = 4 then begin
        Move(IpBytes[0], AIPv4.S_byte[0], 4);
        Result := WSocketIPv4ToStr(AIPv4.S_addr);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.5 convert ASCII IP address to reverse DNS lookup arpa domain name, no period on end }
// IPv6  4321:0:1:2:3:4:567:89ab becomes  b.a.9.8.7.6.5.0.4.0.0.0.3.0.0.0.2.0.0.0.1.0.0.0.0.0.0.0.1.2.3.4.ip6.arpa
// IPv4  217.146.102.139 becomes 139.102.146.217.in-addr.arpa
function IcsReverseIPArpa(const IP: String): AnsiString;    { V9.5 }
var
    SocFamily: TSocketFamily;
begin
    Result := AnsiString(IP);
    if WSocketIsIP(IP, SocFamily) then begin
        if SocFamily = sfIPv6 then
            Result := IcsReverseIPv6(IP) + '.ip6.arpa'
        else if SocFamily = sfIPv4 then
            Result := IcsReverseIP(IP) + '.in-addr.arpa'
    end
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert IPv6 address in PSockAddrIn6 record to ASCII string }
{ Returns the scope ID as well, if not null }
function WSocketIPv6ToStr(const AIn6: PSockAddrIn6): string;
begin
    if (AIn6 <> nil) and (AIn6.sin6_family = AF_INET6) then begin   { V9.5 family check }
        if AIn6^.sin6_scope_id = 0 then
            Result := WSocketIPv6ToStr(PIcsIPv6Address(@AIn6^.sin6_addr)^)
        else
            Result := WSocketIPv6ToStr(PIcsIPv6Address(@AIn6^.sin6_addr)^) + '%' + IntToStr(AIn6^.sin6_scope_id);
    end
    else
        Result := '';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert binary IPV4 address and port into TSockAddrIn6 record for winsock APIs }
function  WSocketIPv4ToSocAddr(IPv4: Integer; Port: Integer = 0): TSockAddrIn6;       { V8.71 }  { V9.5 added port }
begin
    Result := WSocketIPv4ToSocAddr(Cardinal(IPv4), Port);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert binary IPV4 address and port into TSockAddrIn6 record for winsock APIs }
{ also works with TIcsIPv4Address }
function  WSocketIPv4ToSocAddr(IPV4: Cardinal; Port: Integer = 0): TSockAddrIn6;      { V8.71 } { V9.5 added port }
begin
    IcsInitializeAddr(Result, sfIPv4);
    PSockAddrIn(@Result)^.sin_addr.S_addr := IPv4;
    PSockAddrIn(@Result)^.sin_port := Port;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert binary IPv6 address and port into TSockAddrIn6 record for winsock APIs }
function  WSocketIPv6ToSocAddr(AIPv6Addr: TIcsIPv6Address; Port: Integer = 0): TSockAddrIn6;     { V9.5 }
begin
    IcsInitializeAddr(Result, sfIPv6);
    Move(AIPv6Addr.Words, Result.sin6_addr.u6_addr16, 16);
    Result.sin6_port := Port;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert ASCII IPv4 or IPv6 address and port into TSockAddrIn6 record for winsock APIs }
function  WSocketIPStrToSocAddr(const S: string; out Success: Boolean; Port: Integer = 0): TSockAddrIn6;  { V9.5 }
var
    ASocFamily: TSocketFamily;
    AIPv6: TIcsIPv6Address;
    AIPv4: TIcsIPv4Address;
begin
    IcsInitializeAddr(Result, sfAny);
    Success := WSocketIsIPEx(S, ASocFamily);
    if NOT Success then
        Exit;
    if ASocFamily = sfIPv4 then begin
        AIPv4 := WSocketStrToIPv4(S, Success);
        if NOT Success then
            Exit;
        Result := WSocketIPv4ToSocAddr(AIPv4, Port);
    end
    else if ASocFamily = sfIPv6 then begin
        AIPv6 := WSocketStrToIPv6(S, Success);
        if NOT Success then
            Exit;
        Result := WSocketIPv6ToSocAddr(AIPv6, Port);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert IP address from TSockAddrIn6 record from winsock APIs into string }
function  WSocketSockAddrToStr(const ASockAddr: TSockAddrIn6): string;          { V8.71 }
begin
    if ASockAddr.sin6_family = AF_INET6 then
        Result := WSocketIPv6ToStr(PIcsIPv6Address(@ASockAddr.sin6_addr)^)
    else
        Result := WSocketIPv4ToStr(PSockAddrIn(@ASockAddr).sin_addr.S_addr);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert IPv6 address from PAddrInfo record from winsock APIs into binary }
function IcsIPv6AddrFromAddrInfo(AddrInfo: PAddrInfo): TIcsIPv6Address; {$IFDEF USE_INLINE} inline; {$ENDIF}
begin
    Result := PIcsIPv6Address(@PSockAddrIn6(AddrInfo^.ai_addr)^.sin6_addr)^;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ find TSocketFamily from  TSockAddrIn6 record from winsock APIs }
function  IcsFamilyFromSocAddr(const ASockAddr: TSockAddrIn6): TSocketFamily;         { V9.5 }
begin
    if ASockAddr.sin6_family = AF_INET then
        Result := sfIPv4
    else if ASockAddr.sin6_family = AF_INET6 then
        Result := sfipv6
    else
        Result := sfAny;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert IPv4 address from TSockAddrIn6 record from winsock APIs into binary }
function IcsIPv4AddrFromSocAddr(const ASockAddr: TSockAddrIn6): TIcsIPv4Address; {$IFDEF USE_INLINE} inline; {$ENDIF}  { V9.5 }
begin
    if ASockAddr.sin6_family = AF_INET then
        Result := PSockAddrIn(@ASockAddr).sin_addr.S_addr
    else
        Result := 0;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ convert IPv6 address from TSockAddrIn6 record from winsock APIs into binary }
function IcsIPv6AddrFromSocAddr(const ASockAddr: TSockAddrIn6): TIcsIPv6Address; {$IFDEF USE_INLINE} inline; {$ENDIF}  { V9.5 }
begin
    if ASockAddr.sin6_family = AF_INET6 then
        Result := PIcsIPv6Address(@ASockAddr.sin6_addr)^
    else
        IcsInitializeIpv6(Result);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ find family for Windows APIs from TSocketFamily }
function  WSocketFamilyToAF(AFamily: TSocketFamily): Integer;         { V8.71 }
begin
    if AFamily in [sfIPv4, sfAnyIPv4] then
        Result := AF_INET
    else if AFamily in [sfIPv6, sfAnyIPv6] then
        Result := AF_INET6
    else
        Result := AF_UNSPEC;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ find TSocketFamily from family for Windows APIs  }
function  WSocketFamilyFromAF(AFamily: Integer): TSocketFamily;         { V9.5 }
begin
    if AFamily = AF_INET then
        Result := sfIPv4
    else if AFamily = AF_INET6 then
        Result := sfipv6
    else
        Result := sfAny;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsInitializeAddr(var AAddr: TSockAddrIn6; AIPVersion: TSocketFamily); {$IFDEF USE_INLINE} inline; {$ENDIF} { V9.5 moved from WSocket }
begin
    FillChar(AAddr, SizeOf(TSockAddrIn6), 0);
    if AIPVersion = sfIPv6 then
        AAddr.sin6_family := AF_INET6
    else
        AAddr.sin6_family := AF_INET;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsInitializeIpv6(var IPv6: TIcsIPv6Address); {$IFDEF USE_INLINE} inline; {$ENDIF} { V9.5 }
begin
    FillChar(IPv6, SizeOf(TIcsIPv6Address), 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IcsSizeOfAddr(const AAddr: TSockAddrIn6): Integer; {$IFDEF USE_INLINE} inline; {$ENDIF} { V9.5 moved from WSocket }
begin
    if AAddr.sin6_family = AF_INET6 then
        Result := SizeOf(TSockAddrIn6)
    else
        Result := SizeOf(TSockAddrIn);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketSocksErrorDesc(ErrCode : Integer) : String;
begin
    case ErrCode of
        socksNoError              : Result := 'No Error';
        socksProtocolError        : Result := 'Protocol Error';
        socksVersionError         : Result := 'Version Error';
        socksAuthMethodError      : Result := 'Authentication Method Error';
        socksGeneralFailure       : Result := 'General Failure';
        socksConnectionNotAllowed : Result := 'Connection Not Allowed';
        socksNetworkUnreachable   : Result := 'Network Unreachable';
        socksHostUnreachable      : Result := 'Host Unreachable';
        socksConnectionRefused    : Result := 'Connection Refused';
        socksTtlExpired           : Result := 'TTL Expired';
        socksUnknownCommand       : Result := 'Unknown Command';
        socksUnknownAddressType   : Result := 'Unknown Address Type';
        socksUnassignedError      : Result := 'Unassigned Error';
        socksInternalError        : Result := 'Internal Error';
        socksDataReceiveError     : Result := 'Data Receive Error';
        socksAuthenticationFailed : Result := 'Authentication Failed';
        socksRejectedOrFailed     : Result := 'Rejected Or Failed';
        socksHostResolutionFailed : Result := 'Host Resolution Failed';
        else
            Result := 'Not a SOCKS error';
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketHttpStatusCodeDesc(HttpStatusCode : Integer) : String;
const
    sHttpStatusCode = 'HTTP status code';
begin
    { Rather lengthy, I know, anyway RAM is cheap today. }
    if (HttpStatusCode >= 100) and (HttpStatusCode < 600) then
    begin
        case HttpStatusCode of
            100       : Result := 'Continue';
            101       : Result := 'Switching Protocols';
            102       : Result := 'Processing';

            200       : Result := 'OK';
            201       : Result := 'Created';
            202       : Result := 'Accepted';
            203       : Result := 'Non-Authoritative Information';
            204       : Result := 'No Content';
            205       : Result := 'Reset Content';
            206       : Result := 'Partial Content';
            207       : Result := 'Multi-Status (WebDAV)';

            300       : Result := 'Multiple Choices';
            301       : Result := 'Moved Permanently';
            302       : Result := 'Found';
            303       : Result := 'See Other';
            304       : Result := 'Not Modified';
            305       : Result := 'Use Proxy';
            306       : Result := 'Switch Proxy';
            307       : Result := 'Temporary Redirect';

            400       : Result := 'Bad Request';
            401       : Result := 'Unauthorized';
            402       : Result := 'Payment Required';
            403       : Result := 'Forbidden';
            404       : Result := 'Not Found';
            405       : Result := 'Method Not Allowed';
            406       : Result := 'Not Acceptable';
            407       : Result := 'Proxy Authentication Required';
            408       : Result := 'Request Timeout';
            409       : Result := 'Conflict';
            410       : Result := 'Gone';
            411       : Result := 'Length Required';
            412       : Result := 'Precondition Failed';
            413       : Result := 'Request Entity Too Large';
            414       : Result := 'Request-URI Too Long';
            415       : Result := 'Unsupported Media Type';
            416       : Result := 'Requested Range Not Satisfiable';
            417       : Result := 'Expectation Failed';
            418       : Result := 'I''m a teapot';
            422       : Result := 'Unprocessable Entity (WebDAV)';
            423       : Result := 'Locked (WebDAV)';
            424       : Result := 'Failed Dependency (WebDAV)';
            425       : Result := 'Unordered Collection';
            444       : Result := 'No Response';
            426       : Result := 'Upgrade Required';
            449       : Result := 'Retry With';
            450       : Result := 'Blocked by Windows Parental Controls';
            499       : Result := 'Client Closed Request';

            500       : Result := 'Internal Server Error';
            501       : Result := 'Not Implemented';
            502       : Result := 'Bad Gateway';
            503       : Result := 'Service Unavailable';
            504       : Result := 'Gateway Timeout';
            505       : Result := 'HTTP Version Not Supported';
            506       : Result := 'Variant Also Negotiates';
            507       : Result := 'Insufficient Storage (WebDAV)';
            509       : Result := 'Bandwidth Limit Exceeded';
            510       : Result := 'Not Extended';
            else
                Result := sHttpStatusCode + ' ' + IntToStr(HttpStatusCode);
        end;
    end
    else
        Result := 'Not a ' + sHttpStatusCode;

end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
//const
//  sHttpVersionError = 'Proxy server must support HTTP/1.1';

function WSocketHttpTunnelErrorDesc(ErrCode : Integer) : String;
const
    sNotAHttpTunnelError = 'Not a HTTP tunnel error';
var
    LErr : Integer;
begin
    if (ErrCode >= ICS_HTTP_TUNNEL_BASEERR) and
       (ErrCode <= ICS_HTTP_TUNNEL_MAXERR) then
    begin
        LErr := ErrCode - ICS_HTTP_TUNNEL_BASEERR;
        if (LErr >= 100) and (LErr < 600) then
        begin
            if LErr = 200 then
                Result := 'No Error'
            else
                Result := WSocketHttpStatusCodeDesc(LErr);
        end
        else begin
            case ErrCode of
                ICS_HTTP_TUNNEL_PROTERR :
                    Result := 'Protocol Error';
                ICS_HTTP_TUNNEL_GENERR  :
                    Result := 'General Failure';
                ICS_HTTP_TUNNEL_VERSIONERR :
                    Result := sHttpVersionError;
                else
                    Result := sNotAHttpTunnelError;
            end;
        end;
    end
    else
        Result := sNotAHttpTunnelError;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketProxyErrorDesc(ErrCode : Integer) : String;
begin
    if (ErrCode >= ICS_HTTP_TUNNEL_BASEERR) and (ErrCode <= ICS_HTTP_TUNNEL_MAXERR) then
        Result := 'HTTP Proxy - ' + WSocketHttpTunnelErrorDesc(ErrCode)
    else if (ErrCode >= ICS_SOCKS_BASEERR) and ((ErrCode <= ICS_SOCKS_MAXERR)) then
        Result := 'SOCKS - ' + WSocketSocksErrorDesc(ErrCode)
    else
        Result := 'Not a proxy error';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketIsProxyErrorCode(ErrCode: Integer): Boolean;
begin
    Result := ((ErrCode >= ICS_SOCKS_BASEERR) and
               (ErrCode <= ICS_SOCKS_MAXERR)) or
              ((ErrCode >= ICS_HTTP_TUNNEL_BASEERR) and
               (ErrCode <= ICS_HTTP_TUNNEL_MAXERR));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketErrorMsgFromErrorCode(ErrCode: Integer) : String;
begin
    if WSocketIsProxyErrorCode(ErrCode) then
        Result := WSocketProxyErrorDesc(ErrCode)
    else
        Result := {$IFDEF MSWINDOWS} 'Winsock - ' {$ELSE} 'Socket - ' {$ENDIF} +
                  WSocketErrorDesc(ErrCode);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketGetErrorMsgFromErrorCode(ErrCode : Integer) : String;
begin
    Result := WSocketErrorMsgFromErrorCode(ErrCode) + ' (#' + IntToStr(ErrCode) + ')';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function SocketErrorDesc(ErrCode : Integer) : String;
begin
    case ErrCode of
    0:
      Result := 'No Error';
    WSAEINTR:
      Result := 'Interrupted system call';
    WSAEBADF:
      Result := 'Bad file number';
    WSAEACCES:
      Result := 'Permission denied';
    WSAEFAULT:
      Result := 'Bad address';
    WSAEINVAL:
      Result := 'Invalid argument';
    WSAEMFILE:
      Result := 'Too many open files';
    WSAEWOULDBLOCK:
      Result := 'Operation would block';
    WSAEINPROGRESS:
      Result := 'Operation now in progress';
    WSAEALREADY:
      Result := 'Operation already in progress';
    WSAENOTSOCK:
      Result := 'Socket operation on non-socket';
    WSAEDESTADDRREQ:
      Result := 'Destination address required';
    WSAEMSGSIZE:
      Result := 'Message too long';
    WSAEPROTOTYPE:
      Result := 'Protocol wrong type for socket';
    WSAENOPROTOOPT:
      Result := 'Protocol not available';
    WSAEPROTONOSUPPORT:
      Result := 'Protocol not supported';
    WSAESOCKTNOSUPPORT:
      Result := 'Socket type not supported';
    WSAEOPNOTSUPP:
      Result := 'Operation not supported on socket';
    WSAEPFNOSUPPORT:
      Result := 'Protocol family not supported';
    WSAEAFNOSUPPORT:
      Result := 'Address family not supported by protocol family';
    WSAEADDRINUSE:
      Result := 'Address already in use';
    WSAEADDRNOTAVAIL:
      Result := 'Address not available';
    WSAENETDOWN:
      Result := 'Network is down';
    WSAENETUNREACH:
      Result := 'Network is unreachable';
    WSAENETRESET:
      Result := 'Network dropped connection on reset';
    WSAECONNABORTED:
      Result := 'Connection aborted';
    WSAECONNRESET:
      Result := 'Connection reset by peer';
    WSAENOBUFS:
      Result := 'No buffer space available';
    WSAEISCONN:
      Result := 'Socket is already connected';
    WSAENOTCONN:
      Result := 'Socket is not connected';
    WSAESHUTDOWN:
      Result := 'Can''t send after socket shutdown';
    WSAETOOMANYREFS:
      Result := 'Too many references: can''t splice';
    WSAETIMEDOUT:
      Result := 'Connection timed out';
    WSAECONNREFUSED:
      Result := 'Connection refused';
    WSAELOOP:
      Result := 'Too many levels of symbolic links';
    WSAENAMETOOLONG:
      Result := 'File name too long';
    WSAEHOSTDOWN:
      Result := 'Host is down';
    WSAEHOSTUNREACH:
      Result := 'No route to host';
    WSAENOTEMPTY:
      Result := 'Directory not empty';
    WSAEPROCLIM:
      Result := 'Too many processes';
    WSAEUSERS:
      Result := 'Too many users';
    WSAEDQUOT:
      Result := 'Disc quota exceeded';
    WSAESTALE:
      Result := 'Stale NFS file handle';
    WSAEREMOTE:
      Result := 'Too many levels of remote in path';
  {$IFDEF MSWINDOWS}
    WSASYSNOTREADY:
      Result := 'Network sub-system is unusable';
    WSAVERNOTSUPPORTED:
      Result := 'WinSock DLL cannot support this application';
    WSANOTINITIALISED:
      Result := 'WinSock not initialized';
  {$ENDIF}
    WSAHOST_NOT_FOUND:
      Result := 'Host not found';
    WSATRY_AGAIN:
      Result := 'Non-authoritative host not found';
    WSANO_RECOVERY:
      Result := 'Non-recoverable error';
    WSANO_DATA:
      Result := 'No Data';
    WSASERVICE_NOT_FOUND:
      Result := 'Service not found'; // Name resolution
    else
  {$IFDEF MSWINDOWS}
      Result := 'Not a Winsocket error';
  {$ELSE}
      Result := 'Not a socket error';
  {$ENDIF}
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSocketErrorDesc(ErrCode : Integer) : String;
begin
    Result := SocketErrorDesc(ErrCode);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetWinsockErr(ErrCode: Integer): String ;    { V5.26 }
begin
    Result := SocketErrorDesc(ErrCode) + ' (#' + IntToStr(ErrCode) + ')' ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetWindowsErr(ErrCode: Integer): String ;    { V5.26 }
    {$IFDEF USE_INLINE} inline; {$ENDIF}
begin
    Result := SysErrorMessage(ErrCode) + ' (#' + IntToStr(ErrCode) + ')' ;
end;

{ V9.3 moved from SmtpProt }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ FriendlyEmail                  FriendlyName   Result                      }
{ ----------------------------   ------------   --------------              }
{ myname <name@domain.com>       'myname'       name@domain.com             }
{ myname name@domain.com         'myname'       name@domain.com             }
{ "my name" <name@domain.com>    'my name'      name@domain.com             }
{ 'my name' <name@domain.com>    'my name'      name@domain.com             }
{ name@domain.com                empty          name@domain.com             }
{ <name@domain.com>              empty          name@domain.com             }
{ "name@domain.com"              empty          name@domain.com             }

function IcsParseEmail(FriendlyEmail: String; var FriendlyName : String) : String;
var
    I, J  : Integer;
    Flag  : Boolean;
    Delim : Char;
begin
    Result       := '';
    FriendlyName := '';
    Flag         := (Pos('<', FriendlyEmail) > 0);
    { Skip spaces }
    I := 1;
    while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] = ' ') do
        Inc(I);
    if I > Length(FriendlyEmail) then
        Exit;
    { Check if quoted string }
    if (FriendlyEmail[I] = '"') or (FriendlyEmail[I] = '''') then begin
        Delim := FriendlyEmail[I];
        { Skip opening quote }
        Inc(I);
        { Go to closing quote }
        J := I;
        while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> Delim) do
            Inc(I);
        FriendlyName := Copy(FriendlyEmail, J, I - J);
        Inc(I);
        if Flag then begin
            { Go to less-than sign }
            while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> '<') do
                Inc(I);
            Inc(I);
            J := I;
            while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> '>') do
                Inc(I);
            Result := Copy(FriendlyEmail, J, I - J);
        end
        else
            Result := Trim(Copy(FriendlyEmail, I, Length(FriendlyEmail)));
    end
    else begin
        if Flag then begin
            { Go to less-than sign }
            J := I;
            while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> '<') do
                Inc(I);
            FriendlyName := Trim(Copy(FriendlyEmail, J, I - J));
            Inc(I);
            { Go to greater-than sign }
            J := I;
            while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> '>') do
                Inc(I);
            Result := Copy(FriendlyEmail, J, I - J);
        end
        else begin
            { No <..>, goto next space }
            J := I;
            while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> ' ') do
                Inc(I);
            FriendlyName := Trim(Copy(FriendlyEmail, J, I - J));
            Result       := Trim(Copy(FriendlyEmail, I + 1, Length(FriendlyEmail)));
        end;
    end;
    if (Result = '') and (Pos('@', FriendlyName) > 0) then begin
        Result       := FriendlyName;
        FriendlyName := '';
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.3 moved from Blacklist }
{ V8.60 simple log file update, write text to end of old or new file, opening
  and closing file, ignores any errors, not designed for continual updating!
  The file name is date/time mask format, typically for one log file per day,
  avoid time unless you wants lots of files each day.
  Example FNameMask: "mylog-"yyyymmdd".log" or "c:\temp\mylog-"yyyymmdd".log"
  note any non-mask characters are quoted so path needed quote at start.
  If no drive or path is specified, writes to the program directory. }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsSimpleLogging (const FNameMask, Msg: String);
var
    LogFileName, S: String;
    F: TextFile;
begin
    S := FormatDateTime (ISOTimeMask, Time) + ' ' + Msg;
    try
        LogFileName := FormatDateTime (FNameMask, Date) ;
        if (Pos ('//', LogFileName) <> 1) and (Pos (':', LogFileName) <> 2) then
            LogFileName := IncludeTrailingPathDelimiter (ExtractFileDir (ParamStr (0))) + LogFileName ;
        AssignFile (F, LogFileName);
        if FileExists (LogFileName) then begin
            Append (F);
        end
        else begin
            Rewrite (F);
        end;
        Writeln (F, S);
        CloseFile(F);
    except
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure IcsOutputDebugStr(const AMsg: String); {$IFDEF USE_INLINE} inline; {$ENDIF}  { V9.4 was in Logger }
begin
  {$IFDEF POSIX}
    System.WriteLn(AMsg);
  {$ENDIF}
  {$IFDEF MSWINDOWS}
    {$IFDEF RTL_NAMESPACES}Winapi.{$ENDIF}Windows.OutputDebugString(PChar(AMsg));
  {$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.5 mask an ASCII IPv4 address }
{ ie 192.168.1.222/255.255.255.0 gives 192.168.1.0, 192.168.1.222/255.255.0.0 gives 192.168.0.0 }
function IcsMaskIpv4Addr(const IpStr, IpMask: String): String;      { V9.5 }
var
    AddrLong, MaskLong: LongWord;
    OK: Boolean;
begin
    Result :='';
    AddrLong := WSocketStrToIPv4(IpStr, OK);
    if NOT OK then
        Exit;
    MaskLong := WSocketStrToIPv4(IpMask, OK);
    if NOT OK then
        Exit;
     AddrLong := AddrLong AND MaskLong;
     Result :=  WSocketIPv4ToStr(AddrLong);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.5 convert multiple lines of text into multiple strings, one per line }
function IcsLinesToDynArray(const Lines: String): TStringDynArray;   { V9.5 }
var
    SL: TStringList;
    I: Integer;
begin
    SetLength(Result, 0);
    if Length(Lines) = 0 then
        Exit;
    SL := TStringList.Create;
    try
        SL.Text := Lines;
        SetLength(Result, SL.Count);
        for I := 0 to SL.Count - 1 do
            Result[I] := SL[I];
    finally
       SL.Free;
    end;
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

initialization
    TicksTestOffset := 0 ;    { V9.0 these ticks no longer used in ICS }
{ force GetTickCount wrap in 5 mins - next line normally commented out }
{    TicksTestOffset := MaxLongWord - GetTickCount - (5 * 60 * 1000);  }
    GetIcsFormatSettings;  { V8.60 }
finalization
{$IFDEF MSWINDOWS}
    if WinTrustHandle <> 0 then
        FreeLibrary (WinTrustHandle);
    WinTrustHandle := 0;
    if hSHFolderDLL <> 0 then
        FreeLibrary(hSHFolderDLL);  { V8.67 }
    hSHFolderDLL := 0;
{$ENDIF MSWINDOWS}
end.
