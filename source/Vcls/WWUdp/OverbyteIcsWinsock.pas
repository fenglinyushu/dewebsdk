{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE
Description:  WinSock API for Delphi 8 for the Microsoft .NET framework
              This is the subset needed for ICS components.
Creation:     December 2003
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
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:
May 2012 - V8.00 - Arno added FireMonkey cross platform support with POSIX/MacOS
                   also IPv6 support, include files now in sub-directory
Aug 08, 2023 V9.0  Updated version to major release 9.
Feb 23, 2024 V9.1  Copied content of two include files OverbyteIcsWinsockTypes.inc
                     and OverbyteIcsWinsockImpl.inc here to make debugging
                     easier, proper IDE highlighting.
Aug 2, 2024  V9.3  Moved many types and constants to OverbyteIcsTypes for consolidation.
                   Moved couple of IPv6 testing functions to OverbyteIcsWSocket.
Feb 20, 2025 V9.4  Removed old commented out code to keep old compilers happy.
Jul 23, 2025 V9.5  Added Ics_WSAAccept.



 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit OverbyteIcsWinsock;

interface
{$I Include\OverbyteIcsDefs.inc}

{$IFDEF MSWINDOWS}
uses
  {$IFDEF RTL_NAMESPACES}Winapi.Windows{$ELSE}Windows{$ENDIF},
  {$IFDEF RTL_NAMESPACES}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  OverbyteIcsTypes;  { V9.3 consolidated types and constants }

{$IFDEF WIN32}
  {$ALIGN 4}
{$ELSE}
  {$ALIGN ON}
{$ENDIF}
{$MINENUMSIZE 4}


{ Oct 21, 2016 V8.36 - Angus added new SO_xxx types }
{ Aug 08, 2023 V9.0  Updated version to major release 9. }

(*$HPPEMIT '#include <Winsock2.h>'*)
(*$HPPEMIT '#include <Mswsock.h>'*)
(*$HPPEMIT '#include <Ws2tcpip.h>'*)

// the following emits are a workaround to the name conflict with
// procedure FD_SET and struct fd_set in winsock.h
(*$HPPEMIT 'namespace OverbyteIcsWinsock'*)
(*$HPPEMIT '{'*)
(*$HPPEMIT 'typedef fd_set *PFDSet;'*) // due to name conflict with procedure FD_SET
(*$HPPEMIT 'typedef fd_set TFDSet;'*)  // due to name conflict with procedure FD_SET
(*$HPPEMIT '}'*)


{ V9.3 moved most declarations to OverbyteIcsTypes }

{$EXTERNALSYM IN6ADDR_ANY_INIT}
function  IN6ADDR_ANY_INIT: TIn6Addr; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6ADDR_LOOPBACK_INIT}
function  IN6ADDR_LOOPBACK_INIT: TIn6Addr; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6ADDR_SETANY}
procedure IN6ADDR_SETANY(sa: PSockAddrIn6); {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6ADDR_SETLOOPBACK}
procedure IN6ADDR_SETLOOPBACK(sa: PSockAddrIn6); {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6ADDR_ISANY}
function  IN6ADDR_ISANY(sa: PSockAddrIn6): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6ADDR_ISLOOPBACK}
function  IN6ADDR_ISLOOPBACK(sa: PSockAddrIn6): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_ADDR_EQUAL}
function  IN6_ADDR_EQUAL(const a: PIn6Addr; const b: PIn6Addr): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_IS_ADDR_UNSPECIFIED}
function  IN6_IS_ADDR_UNSPECIFIED(const a: PIn6Addr): Boolean;{$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_IS_ADDR_LOOPBACK}
function  IN6_IS_ADDR_LOOPBACK(const a: PIn6Addr): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_IS_ADDR_MULTICAST}
function  IN6_IS_ADDR_MULTICAST(const a: PIn6Addr): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_IS_ADDR_LINKLOCAL}
function  IN6_IS_ADDR_LINKLOCAL(const a: PIn6Addr): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_IS_ADDR_SITELOCAL}
function  IN6_IS_ADDR_SITELOCAL(const a: PIn6Addr): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}

{$EXTERNALSYM IN6_IS_ADDR_V4MAPPED}
function  IN6_IS_ADDR_V4MAPPED(const a: PIn6Addr): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_IS_ADDR_V4COMPAT}
function  IN6_IS_ADDR_V4COMPAT(const a: PIn6Addr): Boolean;{$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_IS_ADDR_MC_NODELOCAL}
function  IN6_IS_ADDR_MC_NODELOCAL(const a: PIn6Addr): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_IS_ADDR_MC_LINKLOCAL}
function  IN6_IS_ADDR_MC_LINKLOCAL(const a: PIn6Addr): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_IS_ADDR_MC_SITELOCAL}
function  IN6_IS_ADDR_MC_SITELOCAL(const a: PIn6Addr): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_IS_ADDR_MC_ORGLOCAL}
function  IN6_IS_ADDR_MC_ORGLOCAL(const a: PIn6Addr): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}
{$EXTERNALSYM IN6_IS_ADDR_MC_GLOBAL}
function  IN6_IS_ADDR_MC_GLOBAL(const a: PIn6Addr): Boolean; {$IFDEF USE_INLINE}inline;{$ENDIF}


function WSAStartup(wVersionRequested: WORD; var lpWSAData: TWSAData): Integer; stdcall;
{$EXTERNALSYM WSAStartup}
function WSACleanup: Integer; stdcall;
{$EXTERNALSYM WSACleanup}
procedure WSASetLastError(iError: Integer); stdcall;
{$EXTERNALSYM WSASetLastError}
function WSAGetLastError: Integer; stdcall;
{$EXTERNALSYM WSAGetLastError}
function WSACancelAsyncRequest(hAsyncTaskHandle: THandle): Integer; stdcall;
{$EXTERNALSYM WSACancelAsyncRequest}
function WSAAsyncGetHostByName(HWindow: HWND; wMsg: u_int; name, buf: PAnsiChar;
                               buflen: Integer): THandle; stdcall;
{$EXTERNALSYM WSAAsyncGetHostByName}
function WSAAsyncGetHostByAddr(HWindow: HWND; wMsg: u_int; addr: PAnsiChar;
               len, Struct: Integer; buf: PAnsiChar; buflen: Integer): THandle; stdcall;
{$EXTERNALSYM WSAAsyncGetHostByAddr}
function WSAAsyncSelect(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer; stdcall;
{$EXTERNALSYM WSAAsyncSelect}
function getservbyname(name, proto: PAnsiChar): PServEnt; stdcall;
{$EXTERNALSYM getservbyname}
function getprotobyname(name: PAnsiChar): PProtoEnt; stdcall;
{$EXTERNALSYM getprotobyname}
function gethostbyname(name: PAnsiChar): PHostEnt; stdcall;
{$EXTERNALSYM gethostbyname}
function gethostbyaddr(addr: Pointer; len, Struct: Integer): PHostEnt; stdcall;
{$EXTERNALSYM gethostbyaddr}
function gethostName(name: PAnsiChar; len: Integer): Integer; stdcall;
{$EXTERNALSYM gethostName}
function socket(af, Struct, protocol: Integer): TSocket; stdcall;
{$EXTERNALSYM socket}
function shutdown(s: TSocket; how: Integer): Integer; stdcall;
{$EXTERNALSYM shutdown}
function setsockopt(s: TSocket; level, optname: Integer; optval: PAnsiChar;
                    optlen: Integer): Integer; stdcall;
{$EXTERNALSYM setsockopt}
function getsockopt(s: TSocket; level, optname: Integer; optval: PAnsiChar;
                    var optlen: Integer): Integer; stdcall;
{$EXTERNALSYM getsockopt}
function sendto(s: TSocket; var Buf; len, flags: Integer; var addrto: TSockAddr;
                tolen: Integer): Integer; stdcall;
{$EXTERNALSYM sendto}
function send(s: TSocket; var Buf; len, flags: Integer): Integer; stdcall;
{$EXTERNALSYM send}
function recv(s: TSocket; var Buf; len, flags: Integer): Integer; stdcall;
{$EXTERNALSYM recv}
function recvfrom(s: TSocket; var Buf; len, flags: Integer; var from: TSockAddr;
                  var fromlen: Integer): Integer; stdcall;
{$EXTERNALSYM recvfrom}
function ntohs(netshort: u_short): u_short; stdcall;
{$EXTERNALSYM ntohs}
function ntohl(netlong: u_long): u_long; stdcall;
{$EXTERNALSYM ntohl}
function listen(s: TSocket; backlog: Integer): Integer; stdcall;
{$EXTERNALSYM listen}
function ioctlsocket(s: TSocket; cmd: DWORD; var arg: u_long): Integer; stdcall;
{$EXTERNALSYM ioctlsocket}
function WSAIoctl(s                 : TSocket;
                  IoControlCode     : DWORD;
                  InBuffer          : Pointer;
                  InBufferSize      : DWORD;
                  OutBuffer         : Pointer;
                  OutBufferSize     : DWORD;
                  var BytesReturned : DWORD;
                  Overlapped        : POverlapped;
                  CompletionRoutine : FARPROC): Integer; stdcall;
{$EXTERNALSYM WSAIoctl}

function inet_ntoa(inaddr: TInAddr): PAnsiChar; stdcall;
{$EXTERNALSYM inet_ntoa}
function inet_addr(cp: PAnsiChar): u_long; stdcall;
{$EXTERNALSYM inet_addr}
function htons(hostshort: u_short): u_short; stdcall;
{$EXTERNALSYM htons}
function htonl(hostlong: u_long): u_long; stdcall;
{$EXTERNALSYM htonl}
function getsockname(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer; stdcall;
{$EXTERNALSYM getsockname}
function getpeername(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer; stdcall;
{$EXTERNALSYM getpeername}
function connect(s: TSocket; var name: TSockAddr; namelen: Integer): Integer; stdcall;
{$EXTERNALSYM connect}
function closesocket(s: TSocket): Integer; stdcall;
{$EXTERNALSYM closesocket}
function bind(s: TSocket; var addr: TSockAddr; namelen: Integer): Integer; stdcall;
{$EXTERNALSYM bind}
function accept(s: TSocket; addr: PSockAddr; addrlen: PInteger): TSocket; stdcall;
{$EXTERNALSYM accept}

function GetAddrInfoA(NodeName: PAnsiChar; ServName: PAnsiChar; Hints: PADDRINFOA;
                     var AddrInfo: PADDRINFOA): Integer; stdcall;
{$EXTERNALSYM GetAddrInfoA}

function GetAddrInfoW(NodeName: PWideChar; ServName: PWideChar; Hints: PADDRINFOW;
                     var AddrInfo: PADDRINFOW): Integer; stdcall;
{$IFDEF UNICODE}
function GetAddrInfo(NodeName: PWideChar; ServName: PWideChar; Hints: PADDRINFOW;
                     var AddrInfo: PADDRINFOW): Integer; stdcall;
{$ELSE}
function GetAddrInfo(NodeName: PAnsiChar; ServName: PAnsiChar; Hints: PADDRINFOA;
                     var AddrInfo: PADDRINFOA): Integer; stdcall;
{$ENDIF}
{$EXTERNALSYM GetAddrInfo}

procedure FreeAddrInfoA(ai: PADDRINFOA); stdcall;
{$EXTERNALSYM FreeAddrInfoA}
procedure FreeAddrInfoW(ai: PADDRINFOW); stdcall;
{$EXTERNALSYM FreeAddrInfoW}

{$IFDEF UNICODE}
procedure FreeAddrInfo(ai: PADDRINFOW); stdcall;
{$ELSE}
procedure FreeAddrInfo(ai: PADDRINFOA); stdcall;
{$ENDIF}
{$EXTERNALSYM FreeAddrInfo}

function GetNameInfoA(addr: PSockAddr; namelen: Integer; host: PAnsiChar;
   hostlen: DWORD; serv: PAnsiChar; servlen: DWORD; flags: Integer): Integer; stdcall;
{$EXTERNALSYM GetNameInfoA}
function GetNameInfoW(addr: PSockAddr; namelen: Integer; host: PWideChar;
   hostlen: DWORD; serv: PWideChar; servlen: DWORD; flags: Integer): Integer; stdcall;
{$EXTERNALSYM GetNameInfoW}

{$IFDEF UNICODE}
function GetNameInfo(addr: PSockAddr; namelen: Integer; host: PWideChar;
   hostlen: DWORD; serv: PWideChar; servlen: DWORD; flags: Integer): Integer; stdcall;
{$ELSE}
function GetNameInfo(addr: PSockAddr; namelen: Integer; host: PAnsiChar;
   hostlen: DWORD; serv: PAnsiChar; servlen: DWORD; flags: Integer): Integer; stdcall;
{$ENDIF}
{$EXTERNALSYM GetNameInfo}

{ Called by OverbyteIcsWSocket.pas in order to enable dynamic DLL loading with }
{ BCB as well as in previous ICS versions.                                     }
function Ics_WSAStartup(wVersionRequested: WORD; var lpWSAData: TWSAData): Integer;
function Ics_WSACleanup: Integer;
procedure Ics_WSASetLastError(iError: Integer);
function Ics_WSAGetLastError: Integer;
function Ics_WSACancelAsyncRequest(hAsyncTaskHandle: THandle): Integer;
function Ics_WSAAsyncGetHostByName(HWindow: HWND; wMsg: u_int; name, buf: PAnsiChar;
                               buflen: Integer): THandle;
function Ics_WSAAsyncGetHostByAddr(HWindow: HWND; wMsg: u_int; addr: PAnsiChar;
               len, Struct: Integer; buf: PAnsiChar; buflen: Integer): THandle;
function Ics_WSAAsyncSelect(s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer;
function Ics_getservbyname(name, proto: PAnsiChar): PServEnt;
function Ics_getprotobyname(name: PAnsiChar): PProtoEnt;
function Ics_gethostbyname(name: PAnsiChar): PHostEnt;
function Ics_gethostbyaddr(addr: Pointer; len, Struct: Integer): PHostEnt;
function Ics_gethostName(name: PAnsiChar; len: Integer): Integer;
function Ics_socket(af, Struct, protocol: Integer): TSocket;
function Ics_shutdown(s: TSocket; how: Integer): Integer;
function Ics_setsockopt(s: TSocket; level, optname: Integer; optval: PAnsiChar;
                    optlen: Integer): Integer;
function Ics_getsockopt(s: TSocket; level, optname: Integer; optval: PAnsiChar;
                    var optlen: Integer): Integer;
function Ics_sendto(s: TSocket; var Buf; len, flags: Integer; var addrto: TSockAddr;
                tolen: Integer): Integer;
function Ics_send(s: TSocket; var Buf; len, flags: Integer): Integer;
function Ics_recv(s: TSocket; var Buf; len, flags: Integer): Integer;
function Ics_recvfrom(s: TSocket; var Buf; len, flags: Integer; var from: TSockAddr;
                  var fromlen: Integer): Integer;
function Ics_ntohs(netshort: u_short): u_short;
function Ics_ntohl(netlong: u_long): u_long;
function Ics_listen(s: TSocket; backlog: Integer): Integer;
function Ics_ioctlsocket(s: TSocket; cmd: DWORD; var arg: u_long): Integer;
function Ics_WSAIoctl(s                 : TSocket;
                  IoControlCode     : DWORD;
                  InBuffer          : Pointer;
                  InBufferSize      : DWORD;
                  OutBuffer         : Pointer;
                  OutBufferSize     : DWORD;
                  var BytesReturned : DWORD;
                  Overlapped        : POverlapped;
                  CompletionRoutine : FARPROC): Integer;

function Ics_inet_ntoa(inaddr: TInAddr): PAnsiChar;
function Ics_inet_addr(cp: PAnsiChar): u_long;
function Ics_htons(hostshort: u_short): u_short;
function Ics_htonl(hostlong: u_long): u_long;
function Ics_getsockname(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer;
function Ics_getpeername(s: TSocket; var name: TSockAddr; var namelen: Integer): Integer;
function Ics_connect(s: TSocket; var name: TSockAddr; namelen: Integer): Integer;
function Ics_closesocket(s: TSocket): Integer;
function Ics_bind(s: TSocket; var addr: TSockAddr; namelen: Integer): Integer;
function Ics_accept(s: TSocket; addr: PSockAddr; addrlen: PInteger): TSocket;
function Ics_WSAAccept(s: TSocket; addr: PSockAddr; addrlen: PInteger; lpfnCondition: Pointer; dwCallbackData: Pointer): TSocket; { V9.5 }
function Ics_GetAddrInfoA(NodeName: PAnsiChar; ServName: PAnsiChar; Hints: PADDRINFOA;
                     var AddrInfo: PADDRINFOA): Integer;
function Ics_GetAddrInfoW(NodeName: PWideChar; ServName: PWideChar; Hints: PADDRINFOW;
                     var AddrInfo: PADDRINFOW): Integer;
{$IFDEF UNICODE}
function Ics_GetAddrInfo(NodeName: PWideChar; ServName: PWideChar; Hints: PADDRINFOW;
                     var AddrInfo: PADDRINFOW): Integer;

{$ELSE}
function Ics_GetAddrInfo(NodeName: PAnsiChar; ServName: PAnsiChar; Hints: PADDRINFOA;
                     var AddrInfo: PADDRINFOA): Integer;
{$ENDIF}
procedure Ics_FreeAddrInfoA(ai: PADDRINFOA);
procedure Ics_FreeAddrInfoW(ai: PADDRINFOW);
{$IFDEF UNICODE}
procedure Ics_FreeAddrInfo(ai: PADDRINFOW);
{$ELSE}
procedure Ics_FreeAddrInfo(ai: PAddrInfo);
{$ENDIF}
function Ics_GetNameInfoA(addr: PSockAddr; namelen: Integer; host: PAnsiChar;
   hostlen: DWORD; serv: PAnsiChar; servlen: DWORD; flags: Integer): Integer;
function Ics_GetNameInfoW(addr: PSockAddr; namelen: Integer; host: PWideChar;
   hostlen: DWORD; serv: PWideChar; servlen: DWORD; flags: Integer): Integer;
{$IFDEF UNICODE}
function Ics_GetNameInfo(addr: PSockAddr; namelen: Integer; host: PWideChar;
   hostlen: DWORD; serv: PWideChar; servlen: DWORD; flags: Integer): Integer;
{$ELSE}
function Ics_GetNameInfo(addr: PSockAddr; namelen: Integer; host: PAnsiChar;
   hostlen: DWORD; serv: PAnsiChar; servlen: DWORD; flags: Integer): Integer;
{$ENDIF}

{ ICS Helpers }

type
  ESocketAPIException = class(Exception);

procedure ForceLoadWinsock;
procedure CancelForceLoadWinsock;
procedure UnloadWinsock;
function  SocketErrorDesc(ErrCode : Integer) : String;
function  WinsockAPIInfo : TWSADATA;
function  IsSocketAPILoaded : Boolean;

{ Record TScopeID includes bitfields, these are helper functions }
function  ScopeIdGetLevel(const AScopeId: ULONG): ULONG;
function  ScopeIdGetZone(const AScopeId: ULONG): ULONG;
procedure ScopeIdSetLevel(var AScopeId: ULONG; const ALevel: ULONG);
procedure ScopeIdSetZone(var AScopeId: ULONG; const AZone: ULONG);
function  MakeScopeId(const AZone: ULONG; const ALevel: ULONG): ULONG;

{$ENDIF MSWINDOWS}

implementation
{$IFDEF MSWINDOWS}
  { Include\OverbyteIcsWinsockImpl.inc   V9.1 content copied here }

{ Oct 5, 2018 - V8.57 - fixed compiler hints in GetProc }
{ Aug 08, 2023 V9.0  Updated version to major release 9. }

const
  GWsDLLName      = 'wsock32.dll';      { 32 bits TCP/IP system DLL }
  GWs2DLLName     = 'ws2_32.dll';       { 32 bits TCP/IP system DLL version 2}
  GWship6DLLName  = 'wship6.dll';       { IPv6 }

var
  WSocketGForced  : Boolean = FALSE;

  GWsDLLHandle      : HMODULE  = 0;
  GWs2DLLHandle     : HMODULE  = 0;
  GWship6DllHandle  : HMODULE  = 0;
  GWs2IPv6ProcHandle: HMODULE  = 0;
  GInitData         : TWSADATA;

type
    TWSAStartup            = function (wVersionRequired: word;
                                       var WSData: TWSAData): Integer; stdcall;
    TWSACleanup            = function : Integer; stdcall;
    TWSASetLastError       = procedure (iError: Integer); stdcall;
    TWSAGetLastError       = function : Integer; stdcall;
    TWSACancelAsyncRequest = function (hAsyncTaskHandle: THandle): Integer; stdcall;
    TWSAAsyncGetHostByName = function (HWindow: HWND;
                                       wMsg: u_int;
                                       name, buf: PAnsiChar;
                                       buflen: Integer): THandle; stdcall;
    TWSAAsyncGetHostByAddr = function (HWindow: HWND;
                                       wMsg: u_int; addr: PAnsiChar;
                                       len, Struct: Integer;
                                       buf: PAnsiChar;
                                       buflen: Integer): THandle; stdcall;
    TWSAAsyncSelect        = function (s: TSocket;
                                       HWindow: HWND;
                                       wMsg: u_int;
                                       lEvent: Longint): Integer; stdcall;
    TGetServByName         = function (name, proto: PAnsiChar): PServEnt; stdcall;
    TGetProtoByName        = function (name: PAnsiChar): PProtoEnt; stdcall;
    TGetHostByName         = function (name: PAnsiChar): PHostEnt; stdcall;
    TGetHostByAddr         = function (addr: Pointer; len, Struct: Integer): PHostEnt; stdcall;
    TGetHostName           = function (name: PAnsiChar; len: Integer): Integer; stdcall;
    TOpenSocket            = function (af, Struct, protocol: Integer): TSocket; stdcall;
    TShutdown              = function (s: TSocket; how: Integer): Integer; stdcall;
    TSetSockOpt            = function (s: TSocket; level, optname: Integer;
                                       optval: PAnsiChar;
                                       optlen: Integer): Integer; stdcall;
    TGetSockOpt            = function (s: TSocket; level, optname: Integer;
                                       optval: PAnsiChar;
                                       var optlen: Integer): Integer; stdcall;
    TSendTo                = function (s: TSocket; var Buf;
                                       len, flags: Integer;
                                       var addrto: TSockAddr;
                                       tolen: Integer): Integer; stdcall;
    TSend                  = function (s: TSocket; var Buf;
                                       len, flags: Integer): Integer; stdcall;
    TRecv                  = function (s: TSocket;
                                       var Buf;
                                       len, flags: Integer): Integer; stdcall;
    TRecvFrom              = function (s: TSocket;
                                       var Buf; len, flags: Integer;
                                       var from: TSockAddr;
                                       var fromlen: Integer): Integer; stdcall;
    Tntohs                 = function (netshort: u_short): u_short; stdcall;
    Tntohl                 = function (netlong: u_long): u_long; stdcall;
    TListen                = function (s: TSocket;
                                       backlog: Integer): Integer; stdcall;
    TIoctlSocket           = function (s: TSocket; cmd: DWORD;
                                       var arg: u_long): Integer; stdcall;
    TWSAIoctl              = function (s                 : TSocket;
                                       IoControlCode     : DWORD;
                                       InBuffer          : Pointer;
                                       InBufferSize      : DWORD;
                                       OutBuffer         : Pointer;
                                       OutBufferSize     : DWORD;
                                       var BytesReturned : DWORD;
                                       Overlapped        : POverlapped;
                                       CompletionRoutine : FARPROC): Integer; stdcall;
    TInet_ntoa             = function (inaddr: TInAddr): PAnsiChar; stdcall;
    TInet_addr             = function (cp: PAnsiChar): u_long; stdcall;
    Thtons                 = function (hostshort: u_short): u_short; stdcall;
    Thtonl                 = function (hostlong: u_long): u_long; stdcall;
    TGetSockName           = function (s: TSocket; var name: TSockAddr;
                                       var namelen: Integer): Integer; stdcall;
    TGetPeerName           = function (s: TSocket; var name: TSockAddr;
                                       var namelen: Integer): Integer; stdcall;
    TConnect               = function (s: TSocket; var name: TSockAddr;
                                       namelen: Integer): Integer; stdcall;
    TCloseSocket           = function (s: TSocket): Integer; stdcall;
    TBind                  = function (s: TSocket; var addr: TSockAddr;
                                       namelen: Integer): Integer; stdcall;
    TAccept                = function (s: TSocket; addr: PSockAddr;
                                       addrlen: PInteger): TSocket; stdcall;
    TWSAAccept             = function (s: TSocket; addr: PSockAddr; addrlen: PInteger; lpfnCondition: Pointer;
                                                                             dwCallbackData: Pointer): TSocket; stdcall;   { V9.5 }
    TGetAddrInfoA          = function(NodeName: PAnsiChar; ServName: PAnsiChar;
                                      Hints: PAddrInfoA;
                                      var Addrinfo: PAddrInfoA): Integer; stdcall;
    TGetAddrInfoW          = function(NodeName: PWideChar; ServName: PWideChar;
                                      Hints: PAddrInfoW;
                                      var Addrinfo: PAddrInfoW): Integer; stdcall;
    TFreeAddrInfoA         = procedure(ai: PAddrInfoA); stdcall;
    TFreeAddrInfoW         = procedure(ai: PAddrInfoW); stdcall;
    TGetNameInfoA          = function(addr: PSockAddr; namelen: Integer;
                                      host: PAnsiChar; hostlen: DWORD;
                                      serv: PAnsiChar; servlen: DWORD;
                                      flags: Integer): Integer; stdcall;
    TGetNameInfoW          = function(addr: PSockAddr; namelen: Integer;
                                      host: PWideChar; hostlen: DWORD;
                                      serv: PWideChar; servlen: DWORD;
                                      flags: Integer): Integer; stdcall;
var
   FWSAStartup            : TWSAStartup = nil;
   FWSACleanup            : TWSACleanup = nil;
   FWSASetLastError       : TWSASetLastError = nil;
   FWSAGetLastError       : TWSAGetLastError = nil;
   FWSACancelAsyncRequest : TWSACancelAsyncRequest = nil;
   FWSAAsyncGetHostByName : TWSAAsyncGetHostByName = nil;
   FWSAAsyncGetHostByAddr : TWSAAsyncGetHostByAddr = nil;
   FWSAAsyncSelect        : TWSAAsyncSelect = nil;
   FGetServByName         : TGetServByName = nil;
   FGetProtoByName        : TGetProtoByName = nil;
   FGetHostByName         : TGetHostByName = nil;
   FGetHostByAddr         : TGetHostByAddr = nil;
   FGetHostName           : TGetHostName = nil;
   FOpenSocket            : TOpenSocket = nil;
   FShutdown              : TShutdown = nil;
   FSetSockOpt            : TSetSockOpt = nil;
   FGetSockOpt            : TGetSockOpt = nil;
   FSendTo                : TSendTo = nil;
   FSend                  : TSend = nil;
   FRecv                  : TRecv = nil;
   FRecvFrom              : TRecvFrom = nil;
   Fntohs                 : Tntohs = nil;
   Fntohl                 : Tntohl = nil;
   FListen                : TListen = nil;
   FIoctlSocket           : TIoctlSocket = nil;
   FWSAIoctl              : TWSAIoctl = nil;
   FInet_ntoa             : TInet_ntoa = nil;
   FInet_addr             : TInet_addr = nil;
   Fhtons                 : Thtons = nil;
   Fhtonl                 : Thtonl = nil;
   FGetSockName           : TGetSockName = nil;
   FGetPeerName           : TGetPeerName = nil;
   FConnect               : TConnect = nil;
   FCloseSocket           : TCloseSocket = nil;
   FBind                  : TBind = nil;
   FAccept                : TAccept = nil;
   FWSAAccept             : TWSAAccept = nil;          { V9.5 }
   FGetAddrInfoA          : TGetAddrInfoA = nil;
   FGetAddrInfoW          : TGetAddrInfoW = nil;
   FFreeAddrInfoA         : TFreeAddrInfoA = nil;
   FFreeAddrInfoW         : TFreeAddrInfoW = nil;
   FGetNameInfoA          : TGetNameInfoA = nil;
   FGetNameInfoW          : TGetNameInfoW = nil;


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
    WSASYSNOTREADY:
      Result := 'Network sub-system is unusable';
    WSAVERNOTSUPPORTED:
      Result := 'WinSock DLL cannot support this application';
    WSANOTINITIALISED:
      Result := 'WinSock not initialized';
    WSAHOST_NOT_FOUND:
      Result := 'Host not found';
    WSATRY_AGAIN:
      Result := 'Non-authoritative host not found';
    WSANO_RECOVERY:
      Result := 'Non-recoverable error';
    WSANO_DATA:
      Result := 'No Data';
    WSASERVICE_NOT_FOUND:
      Result := 'Service not found';
    else
      Result := 'Not a WinSock error';
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetWinsockErr(ErrCode: Integer): String ;    { V5.26 }
begin
    Result := SocketErrorDesc(ErrCode) + ' (#' + IntToStr(ErrCode) + ')' ;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetProc(const ProcName : AnsiString) : Pointer;
var
    LastError : Longint;
begin
    { Prevents compiler warning "Return value might be undefined"  }
  {$IFNDEF COMPILER24_UP}
    Result := nil;
  {$ENDIF}
    EnterCriticalSection(GWSockCritSect);
    try
        if GWsDLLHandle = 0 then begin
            GWsDLLHandle := LoadLibrary(GWsDLLName);
            if GWsDLLHandle = 0 then
                raise Exception.Create('Unable to load ' + GWsDLLName +
                              ' - ' + SysErrorMessage(GetLastError));
            LastError := Ics_WSAStartup(MAKEWORD(GReqVerLow, GReqVerHigh), GInitData);
            if LastError <> 0 then
                raise ESocketAPIException.Create('Winsock startup error ' +
                               GWs2DLLName + ' - ' + GetWinsockErr (LastError));
        end;
        if Length(ProcName) = 0 then
            Result := nil
        else begin
            Result := GetProcAddress(GWsDLLHandle, PAnsiChar(ProcName));
            if Result = nil then
                raise ESocketAPIException.Create('Procedure ' + String(ProcName) +
                                              ' not found in ' + GWsDLLName +
                                   ' - ' + SysErrorMessage(GetLastError));
        end;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetProc2(const ProcName : AnsiString) : Pointer;
begin
  {$IFNDEF COMPILER24_UP}
    Result := nil;
  {$ENDIF}
    EnterCriticalSection(GWSockCritSect);
    try
        if GWs2DLLHandle = 0 then begin
                GetProc('');
            GWs2DLLHandle := LoadLibrary(GWs2DLLName);
            if GWs2DLLHandle = 0 then
                raise Exception.Create('Unable to load ' + GWs2DLLName +
                              ' - ' + SysErrorMessage(GetLastError));
        end;
        if Length(ProcName) = 0 then
            Result := nil
        else begin
            Result := GetProcAddress(GWs2DLLHandle, PAnsiChar(ProcName));
            if Result = nil then
                raise ESocketAPIException.Create('Procedure ' + String(ProcName) +
                                              ' not found in ' + GWs2DLLName +
                                ' - ' + SysErrorMessage(GetLastError));
        end;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetProc3(const ProcName : AnsiString) : Pointer;
begin
  {$IFNDEF COMPILER24_UP}
    Result := nil;
  {$ENDIF}
    EnterCriticalSection(GWSockCritSect);
    try
        if GWs2IPv6ProcHandle = 0 then begin
                GetProc2('');
            GWs2IPv6ProcHandle := GWs2DLLHandle;
            @FGetAddrInfoA := GetProcAddress(GWs2IPv6ProcHandle,'getaddrinfo');
            if @FGetAddrInfoA = nil then begin
                GWship6DllHandle := LoadLibrary(GWship6DLLname);
                if GWship6DllHandle = 0 then
                    raise Exception.Create('Unable to load ' + GWship6DLLname +
                              ' - ' + SysErrorMessage(GetLastError));
                GWs2IPv6ProcHandle := GWship6DllHandle;
            end;
        end;
        if Length(ProcName) = 0 then
            Result := nil
        else begin
            Result := GetProcAddress(GWs2IPv6ProcHandle, PAnsiChar(ProcName));
            if Result = nil then
                raise ESocketAPIException.Create('Procedure ' + String(ProcName) +
                                                 ' not found in ' + GWs2DLLName +
                                ' - ' + SysErrorMessage(GetLastError));
        end;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function IsSocketAPILoaded : Boolean;
begin
    EnterCriticalSection(GWSockCritSect);
    try
        Result := GWsDLLHandle <> 0;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Winsock is dynamically loaded and unloaded when needed. In some cases     }
{ you may find winsock being loaded and unloaded very often in your app     }
{ This happend for example when you dynamically create a TWSocket and       }
{ destroy a TWSocket when there is no "permanant" TWSocket (that is a       }
{ TWSocket dropped on a persitant form). It is the very inefficiant.        }
{ Calling WSocketForceLoadWinsock will increament the reference count so    }
{ that winsock will not be unloaded when the last TWSocket is destroyed.    }
procedure ForceLoadWinsock;
begin
    EnterCriticalSection(GWSockCritSect);
    try
        if not WSocketGForced then begin
            WSocketGForced := TRUE;
            Inc(WSocketGCount);
            GetProc('');
        end;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Cancel the operation done with WSocketForceLoadWinsock.                   }
procedure CancelForceLoadWinsock;
begin
    EnterCriticalSection(GWSockCritSect);
    try
        if WSocketGForced then begin
            WSocketGForced := FALSE;
            Dec(WSocketGCount);
            if WSocketGCount <= 0 then
                UnloadWinsock;
        end;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure UnloadWinsock;
begin
    EnterCriticalSection(GWSockCritSect);
    try
        if (GWsDLLHandle <> 0) and (WSocketGCount = 0) then begin
            Ics_WSACleanup;
            if GWs2DLLHandle <> 0 then begin
                FreeLibrary(GWs2DLLHandle);
                GWs2DLLHandle      := 0;
                GWs2IPv6ProcHandle := 0;
                FWSAIoctl          := nil;
                if GWship6DllHandle <> 0 then begin
                    FreeLibrary(GWship6DllHandle);
                    GWship6DllHandle := 0;
                end;
                FGetAddrInfoA      := nil;
                FGetAddrInfoW      := nil;
                FFreeAddrInfoA     := nil;
                FFreeAddrInfoW     := nil;
                FGetNameInfoA      := nil;
                FGetNameInfoW      := nil;
            end;
            FreeLibrary(GWsDLLHandle);
            GWsDLLHandle           := 0;
            FWSAStartup            := nil;
            FWSACleanup            := nil;
            FWSASetLastError       := nil;
            FWSAGetLastError       := nil;
            FWSACancelAsyncRequest := nil;
            FWSAAsyncGetHostByName := nil;
            FWSAAsyncGetHostByAddr := nil;
            FWSAAsyncSelect        := nil;
            FGetServByName         := nil;
            FGetProtoByName        := nil;
            FGetHostByName         := nil;
            FGetHostByAddr         := nil;
            FGetHostName           := nil;
            FOpenSocket            := nil;
            FShutdown              := nil;
            FSetSockOpt            := nil;
            FGetSockOpt            := nil;
            FSendTo                := nil;
            FSend                  := nil;
            FRecv                  := nil;
            FRecvFrom              := nil;
            Fntohs                 := nil;
            Fntohl                 := nil;
            FListen                := nil;
            FIoctlSocket           := nil;
            FWSAIoctl              := nil;
            FInet_ntoa             := nil;
            FInet_addr             := nil;
            Fhtons                 := nil;
            Fhtonl                 := nil;
            FGetSockName           := nil;
            FGetPeerName           := nil;
            FConnect               := nil;
            FCloseSocket           := nil;
            FBind                  := nil;
            FAccept                := nil;
        end;
        WSocketGForced := FALSE;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WinsockAPIInfo : TWSADATA;
begin
    { Load winsock and initialize it as needed }
    EnterCriticalSection(GWSockCritSect);
    try
        GetProc('');
        Result := GInitData;
        { If no socket created, then unload winsock immediately }
        if WSocketGCount <= 0 then
            UnloadWinsock;
    finally
        LeaveCriticalSection(GWSockCritSect);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAStartup(
    wVersionRequested: WORD;
    var lpWSAData: TWSAData): Integer; stdcall;
begin
    Result := Ics_WSAStartup(wVersionRequested, lpWSAData);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSACleanup : Integer; stdcall;
begin
    Result := Ics_WSACleanup;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure WSASetLastError(iError: Integer); stdcall;
begin
    Ics_WSASetLastError(iError);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAGetLastError: Integer; stdcall;
begin
    Result := Ics_WSAGetLastError;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSACancelAsyncRequest(hAsyncTaskHandle: THandle): Integer; stdcall;
begin
    Result := Ics_WSACancelAsyncRequest(hAsyncTaskHandle);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAAsyncGetHostByName(
    HWindow: HWND; wMsg: u_int;
    name, buf: PAnsiChar;
    buflen: Integer): THandle; stdcall;
begin
    Result := Ics_WSAAsyncGetHostByName(HWindow, wMsg, name, buf, buflen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAAsyncGetHostByAddr(
    HWindow: HWND;
    wMsg: u_int; addr: PAnsiChar;
    len, Struct: Integer;
    buf: PAnsiChar;
    buflen: Integer): THandle; stdcall;
begin
    Result := Ics_WSAAsyncGetHostByAddr(HWindow, wMsg, addr, len, struct, buf, buflen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAAsyncSelect(
    s: TSocket;
    HWindow: HWND;
    wMsg: u_int;
    lEvent: Longint): Integer; stdcall;
begin
    Result := Ics_WSAAsyncSelect(s, HWindow, wMsg, lEvent);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function getservbyname(name, proto: PAnsiChar): PServEnt; stdcall;
begin
    Result := Ics_getservbyname(name, proto);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function getprotobyname(name: PAnsiChar): PProtoEnt; stdcall;
begin
    Result := Ics_getprotobyname(PAnsiChar(Name));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function gethostbyname(name: PAnsiChar): PHostEnt; stdcall;
begin
    Result := Ics_gethostbyname(name);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function gethostbyaddr(addr: Pointer; len, Struct: Integer): PHostEnt; stdcall;
begin
    Result := Ics_gethostbyaddr(addr, len, Struct);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function gethostname(name: PAnsiChar; len: Integer): Integer; stdcall;
begin
    Result := Ics_gethostname(name, len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function socket(af, Struct, protocol: Integer): TSocket; stdcall;
begin
    Result := Ics_socket(af, Struct, protocol);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function shutdown(s: TSocket; how: Integer): Integer; stdcall;
begin
    Result := Ics_shutdown(s, how);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function setsockopt(s: TSocket; level, optname: Integer;
  optval: PAnsiChar; optlen: Integer): Integer; stdcall;
begin
    Result := Ics_setsockopt(s, level, optname, optval, optlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function getsockopt(
    s: TSocket; level, optname: Integer;
    optval: PAnsiChar; var optlen: Integer): Integer; stdcall;
begin
    Result := Ics_getsockopt(s, level, optname, optval, optlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function sendto(
    s          : TSocket;
    var Buf;
    len, flags : Integer;
    var addrto : TSockAddr;
    tolen      : Integer): Integer; stdcall;
begin
    Result := Ics_sendto(s, Buf, len, flags, addrto, tolen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function send(s: TSocket; var Buf;
  len, flags: Integer): Integer; stdcall;
begin
    Result := Ics_send(s, Buf, len, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ntohs(netshort: u_short): u_short; stdcall;
begin
    Result := Ics_ntohs(netshort);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ntohl(netlong: u_long): u_long; stdcall;
begin
    Result := Ics_ntohl(netlong);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function listen(s: TSocket; backlog: Integer): Integer; stdcall;
begin
    Result := Ics_listen(s, backlog);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ioctlsocket(s: TSocket; cmd: DWORD; var arg: u_long): Integer; stdcall;
begin
    Result := Ics_ioctlsocket(s, cmd, arg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function WSAIoctl(
    s                 : TSocket; IoControlCode : DWORD;
    InBuffer          : Pointer; InBufferSize  : DWORD;
    OutBuffer         : Pointer; OutBufferSize : DWORD;
    var BytesReturned : DWORD; Overlapped      : POverlapped;
    CompletionRoutine : FARPROC): Integer; stdcall;
begin
    Result := Ics_WSAIoctl(s, IoControlCode, InBuffer, InBufferSize, OutBuffer,
                   OutBufferSize, BytesReturned, Overlapped, CompletionRoutine);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function inet_ntoa(inaddr: TInAddr): PAnsiChar; stdcall;
begin
    Result := Ics_inet_ntoa(inaddr);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function inet_addr(cp: PAnsiChar): u_long; stdcall;
begin
    Result := Ics_inet_addr(cp);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htons(hostshort: u_short): u_short; stdcall;
begin
    Result := Ics_htons(hostshort);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function htonl(hostlong: u_long): u_long; stdcall;
begin
    Result := Ics_htonl(hostlong);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function getsockname(
    s           : TSocket;
    var name    : TSockAddr;
    var namelen : Integer): Integer; stdcall;
begin
    Result := Ics_getsockname(s, name, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function getpeername(
    s           : TSocket;
    var name    : TSockAddr;
    var namelen : Integer): Integer; stdcall;
begin
    Result := Ics_getpeername(s, name, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function connect(
    s        : TSocket;
    var name : TSockAddr;
    namelen  : Integer): Integer; stdcall;
begin
    Result := Ics_connect(s, name, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function closesocket(s: TSocket): Integer; stdcall;
begin
    Result := Ics_closesocket(s);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function bind(
    s: TSocket;
    var addr: TSockAddr;
    namelen: Integer): Integer; stdcall;
begin
    Result := Ics_bind(s, addr, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function accept(
    s: TSocket;
    addr: PSockAddr;
    addrlen: PInteger): TSocket; stdcall;
begin
    Result := Ics_accept(s, addr, addrlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function recv(s: TSocket; var Buf;
  len, flags: Integer): Integer; stdcall;
begin
    Result := Ics_recv(s, Buf, len, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function recvfrom(
    s: TSocket;
    var Buf; len, flags: Integer;
    var from: TSockAddr;
    var fromlen: Integer): Integer; stdcall;
begin
    Result := Ics_recvfrom(s, Buf, len, flags, from, fromlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetAddrInfoA(
    NodeName    : PAnsiChar;
    ServName    : PAnsiChar;
    Hints       : PADDRINFOA;
    var Addrinfo: PADDRINFOA): Integer; stdcall;
begin
    Result := Ics_GetAddrInfoA(NodeName, ServName, Hints, Addrinfo);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetAddrInfoW(
    NodeName    : PWideChar;
    ServName    : PWideChar;
    Hints       : PADDRINFOW;
    var Addrinfo: PADDRINFOW): Integer; stdcall;
begin
    Result := Ics_GetAddrInfoW(NodeName, ServName, Hints, Addrinfo);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetAddrInfo(
    NodeName    : PChar;
    ServName    : PChar;
    Hints       : PAddrInfo;
    var Addrinfo: PAddrInfo): Integer; stdcall;
begin
    Result := Ics_GetAddrInfo(NodeName, ServName, Hints, Addrinfo);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure FreeAddrInfoA(ai: PADDRINFOA); stdcall;
begin
    Ics_FreeAddrInfoA(ai);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure FreeAddrInfoW(ai: PADDRINFOW); stdcall;
begin
    Ics_FreeAddrInfoW(ai);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure FreeAddrInfo(ai: PAddrInfo); stdcall;
begin
    Ics_FreeAddrInfo(ai);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetNameInfoA(
    addr    : PSockAddr;
    namelen : Integer;
    host    : PAnsiChar;
    hostlen : LongWord;
    serv    : PAnsiChar;
    servlen : LongWord;
    flags   : Integer): Integer; stdcall;
begin
    Result := Ics_GetNameInfoA(addr, namelen, host, hostlen, serv, servlen, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetNameInfoW(
    addr    : PSockAddr;
    namelen : Integer;
    host    : PWideChar;
    hostlen : LongWord;
    serv    : PWideChar;
    servlen : LongWord;
    flags   : Integer): Integer; stdcall;
begin
    Result := Ics_GetNameInfoW(addr, namelen, host, hostlen, serv, servlen, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function GetNameInfo(
    addr    : PSockAddr;
    namelen : Integer;
    host    : PChar;
    hostlen : LongWord;
    serv    : PChar;
    servlen : LongWord;
    flags   : Integer): Integer; stdcall;
begin
    Result := Ics_GetNameInfo(addr, namelen, host, hostlen, serv, servlen, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_WSAStartup(
    wVersionRequested: WORD;
    var lpWSAData: TWSAData): Integer;
begin
    if @FWSAStartup = nil then
        @FWSAStartup := GetProc('WSAStartup');
    Result := FWSAStartup(wVersionRequested, lpWSAData);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_WSACleanup : Integer;
begin
    if @FWSACleanup = nil then
        @FWSACleanup := GetProc('WSACleanup');
    Result := FWSACleanup;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Ics_WSASetLastError(iError: Integer);
begin
    if @FWSASetLastError = nil then
        @FWSASetLastError := GetProc('WSASetLastError');
    FWSASetLastError(iError);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_WSAGetLastError: Integer;
begin
    if @FWSAGetLastError = nil then
        @FWSAGetLastError := GetProc('WSAGetLastError');
    Result := FWSAGetLastError;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_WSACancelAsyncRequest(hAsyncTaskHandle: THandle): Integer;
begin
    if @FWSACancelAsyncRequest = nil then
        @FWSACancelAsyncRequest := GetProc('WSACancelAsyncRequest');
    Result := FWSACancelAsyncRequest(hAsyncTaskHandle);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_WSAAsyncGetHostByName(
    HWindow: HWND; wMsg: u_int;
    name, buf: PAnsiChar;
    buflen: Integer): THandle;
begin
    if @FWSAAsyncGetHostByName = nil then
        @FWSAAsyncGetHostByName := GetProc('WSAAsyncGetHostByName');
    Result := FWSAAsyncGetHostByName(HWindow, wMsg, name, buf, buflen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_WSAAsyncGetHostByAddr(
    HWindow: HWND;
    wMsg: u_int; addr: PAnsiChar;
    len, Struct: Integer;
    buf: PAnsiChar;
    buflen: Integer): THandle;
begin
    if @FWSAAsyncGetHostByAddr = nil then
        @FWSAAsyncGetHostByAddr := GetProc('WSAAsyncGetHostByAddr');
    Result := FWSAAsyncGetHostByAddr(HWindow, wMsg, addr, len, struct, buf, buflen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_WSAAsyncSelect(
    s: TSocket;
    HWindow: HWND;
    wMsg: u_int;
    lEvent: Longint): Integer;
begin
    if @FWSAAsyncSelect = nil then
        @FWSAAsyncSelect := GetProc('WSAAsyncSelect');
    Result := FWSAAsyncSelect(s, HWindow, wMsg, lEvent);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_getservbyname(name, proto: PAnsiChar): PServEnt;
begin
    if @Fgetservbyname = nil then
        @Fgetservbyname := GetProc('getservbyname');
    Result := Fgetservbyname(name, proto);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_getprotobyname(name: PAnsiChar): PProtoEnt;
begin
    if @Fgetprotobyname = nil then
        @Fgetprotobyname := GetProc('getprotobyname');
    Result := Fgetprotobyname(PAnsiChar(Name));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_gethostbyname(name: PAnsiChar): PHostEnt;
begin
    if @Fgethostbyname = nil then
        @Fgethostbyname := GetProc('gethostbyname');
    Result := Fgethostbyname(name);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_gethostbyaddr(addr: Pointer; len, Struct: Integer): PHostEnt;
begin
    if @Fgethostbyaddr = nil then
        @Fgethostbyaddr := GetProc('gethostbyaddr');
    Result := Fgethostbyaddr(addr, len, Struct);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_gethostname(name: PAnsiChar; len: Integer): Integer;
begin
    if @Fgethostname = nil then
        @Fgethostname := GetProc('gethostname');
    Result := Fgethostname(name, len);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_socket(af, Struct, protocol: Integer): TSocket;
begin
    if @FOpenSocket= nil then
        @FOpenSocket := GetProc('socket');
    Result := FOpenSocket(af, Struct, protocol);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_shutdown(s: TSocket; how: Integer): Integer;
begin
    if @FShutdown = nil then
        @FShutdown := GetProc('shutdown');
    Result := FShutdown(s, how);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_setsockopt(s: TSocket; level, optname: Integer;
  optval: PAnsiChar; optlen: Integer): Integer;
begin
    if @FSetSockOpt = nil then
        @FSetSockOpt := GetProc('setsockopt');
    Result := FSetSockOpt(s, level, optname, optval, optlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_getsockopt(
    s: TSocket; level, optname: Integer;
    optval: PAnsiChar; var optlen: Integer): Integer;
begin
    if @FGetSockOpt = nil then
        @FGetSockOpt := GetProc('getsockopt');
    Result := FGetSockOpt(s, level, optname, optval, optlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_sendto(
    s          : TSocket;
    var Buf;
    len, flags : Integer;
    var addrto : TSockAddr;
    tolen      : Integer): Integer;
begin
    if @FSendTo = nil then
        @FSendTo := GetProc('sendto');
    Result := FSendTo(s, Buf, len, flags, addrto, tolen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_send(s: TSocket; var Buf;
  len, flags: Integer): Integer;
begin
    if @FSend = nil then
        @FSend := GetProc('send');
    Result := FSend(s, Buf, len, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_ntohs(netshort: u_short): u_short;
begin
    if @Fntohs = nil then
        @Fntohs := GetProc('ntohs');
    Result := Fntohs(netshort);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_ntohl(netlong: u_long): u_long;
begin
    if @Fntohl = nil then
        @Fntohl := GetProc('ntohl');
    Result := Fntohl(netlong);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_listen(s: TSocket; backlog: Integer): Integer;
begin
    if @FListen = nil then
        @FListen := GetProc('listen');
    Result := FListen(s, backlog);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_ioctlsocket(s: TSocket; cmd: DWORD; var arg: u_long): Integer;
begin
    if @FIoctlSocket = nil then
        @FIoctlSocket := GetProc('ioctlsocket');
    Result := FIoctlSocket(s, cmd, arg);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_WSAIoctl(
    s                 : TSocket; IoControlCode : DWORD;
    InBuffer          : Pointer; InBufferSize  : DWORD;
    OutBuffer         : Pointer; OutBufferSize : DWORD;
    var BytesReturned : DWORD; Overlapped      : POverlapped;
    CompletionRoutine : FARPROC): Integer;
begin
    if @FWSAIoctl = nil then
        @FWSAIoctl := GetProc2('WSAIoctl');
    Result := FWSAIoctl(s, IoControlCode, InBuffer, InBufferSize, OutBuffer,
                        OutBufferSize, BytesReturned, Overlapped, CompletionRoutine);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_inet_ntoa(inaddr: TInAddr): PAnsiChar;
begin
    if @FInet_ntoa = nil then
        @FInet_ntoa := GetProc('inet_ntoa');
    Result := FInet_ntoa(inaddr);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_inet_addr(cp: PAnsiChar): u_long;
begin
    if @FInet_addr = nil then
        @FInet_addr := GetProc('inet_addr');
    Result := FInet_addr(cp);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_htons(hostshort: u_short): u_short;
begin
    if @Fhtons = nil then
        @Fhtons := GetProc('htons');
    Result := Fhtons(hostshort);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_htonl(hostlong: u_long): u_long;
begin
    if @Fhtonl = nil then
        @Fhtonl := GetProc('htonl');
    Result := Fhtonl(hostlong);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_getsockname(
    s           : TSocket;
    var name    : TSockAddr;
    var namelen : Integer): Integer;
begin
    if @FGetSockName = nil then
        @FGetSockName := GetProc('getsockname');
    Result := FGetSockName(s, name, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_getpeername(
    s           : TSocket;
    var name    : TSockAddr;
    var namelen : Integer): Integer;
begin
    if @FGetPeerName = nil then
        @FGetPeerName := GetProc('getpeername');
    Result := FGetPeerName(s, name, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_connect(
    s        : TSocket;
    var name : TSockAddr;
    namelen  : Integer): Integer;
begin
    if @FConnect= nil then
        @FConnect := GetProc('connect');
    Result := FConnect(s, name, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_closesocket(s: TSocket): Integer;
begin
    if @FCloseSocket = nil then
        @FCloseSocket := GetProc('closesocket');
    Result := FCloseSocket(s);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_bind(
    s: TSocket;
    var addr: TSockAddr;
    namelen: Integer): Integer;
begin
    if @FBind = nil then
        @FBind := GetProc('bind');
    Result := FBind(s, addr, namelen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_accept(
    s: TSocket;
    addr: PSockAddr;
    addrlen: PInteger): TSocket;
begin
    if @FAccept = nil then
        @FAccept := GetProc('accept');
    Result := FAccept(s, addr, addrlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_WSAAccept(s: TSocket; addr: PSockAddr; addrlen: PInteger; lpfnCondition: Pointer; dwCallbackData: Pointer): TSocket; { V9.5 }
begin
    if @FWSAAccept = nil then
        @FWSAAccept := GetProc2('WSAAccept');
    Result := FWSAAccept(s, addr, addrlen, lpfnCondition, dwCallbackData);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_recv(s: TSocket; var Buf;
  len, flags: Integer): Integer;
begin
    if @FRecv= nil then
        @FRecv := GetProc('recv');
    Result := FRecv(s, Buf, len, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_recvfrom(
    s: TSocket;
    var Buf; len, flags: Integer;
    var from: TSockAddr;
    var fromlen: Integer): Integer;
begin
    if @FRecvFrom = nil then
        @FRecvFrom := GetProc('recvfrom');
    Result := FRecvFrom(s, Buf, len, flags, from, fromlen);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_GetAddrInfoA(
    NodeName    : PAnsiChar;
    ServName    : PAnsiChar;
    Hints       : PADDRINFOA;
    var Addrinfo: PADDRINFOA): Integer;
begin
    if @FGetAddrInfoA = nil then
        @FGetAddrInfoA := GetProc3('getaddrinfo');
    Result := FGetAddrInfoA(NodeName, ServName, Hints, Addrinfo);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_GetAddrInfoW(
    NodeName    : PWideChar;
    ServName    : PWideChar;
    Hints       : PADDRINFOW;
    var Addrinfo: PADDRINFOW): Integer;
begin
    if @FGetAddrInfoW = nil then
        @FGetAddrInfoW := GetProc3('GetAddrInfoW');
    Result := FGetAddrInfoW(NodeName, ServName, Hints, Addrinfo);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_GetAddrInfo(
    NodeName    : PChar;
    ServName    : PChar;
    Hints       : PAddrInfo;
    var Addrinfo: PAddrInfo): Integer;
begin
{$IFDEF UNICODE}
    if @FGetAddrInfoW = nil then
        @FGetAddrInfoW := GetProc3('GetAddrInfoW');
    Result := FGetAddrInfoW(NodeName, ServName, Hints, Addrinfo);
{$ELSE}
    if @FGetAddrInfoA = nil then
        @FGetAddrInfoA := GetProc3('getaddrinfo');
    Result := FGetAddrInfoA(NodeName, ServName, Hints, Addrinfo);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Ics_FreeAddrInfoA(ai: PADDRINFOA);
begin
    if @FFreeAddrInfoA = nil then
        @FFreeAddrInfoA := GetProc3('freeaddrinfo');
    FFreeAddrInfoA(ai);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Ics_FreeAddrInfoW(ai: PADDRINFOW);
begin
    if @FFreeAddrInfoW = nil then
        @FFreeAddrInfoW := GetProc3('FreeAddrInfoW');
    FFreeAddrInfoW(ai);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure Ics_FreeAddrInfo(ai: PAddrInfo);
begin
{$IFDEF UNICODE}
    if @FFreeAddrInfoW = nil then
        @FFreeAddrInfoW := GetProc3('FreeAddrInfoW');
    FFreeAddrInfoW(ai);
{$ELSE}
    if @FFreeAddrInfoA = nil then
        @FFreeAddrInfoA := GetProc3('freeaddrinfo');
    FFreeAddrInfoA(ai);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_GetNameInfoA(
    addr    : PSockAddr;
    namelen : Integer;
    host    : PAnsiChar;
    hostlen : LongWord;
    serv    : PAnsiChar;
    servlen : LongWord;
    flags   : Integer): Integer;
begin
    if @FGetNameInfoA = nil then
        @FGetNameInfoA := GetProc3('getnameinfo');
    Result := FGetNameInfoA(addr, namelen, host, hostlen, serv, servlen, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_GetNameInfoW(
    addr    : PSockAddr;
    namelen : Integer;
    host    : PWideChar;
    hostlen : LongWord;
    serv    : PWideChar;
    servlen : LongWord;
    flags   : Integer): Integer;
begin
    if @FGetNameInfoW = nil then
        @FGetNameInfoW := GetProc3('GetNameInfoW');
    Result := FGetNameInfoW(addr, namelen, host, hostlen, serv, servlen, flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function Ics_GetNameInfo(
    addr    : PSockAddr;
    namelen : Integer;
    host    : PChar;
    hostlen : LongWord;
    serv    : PChar;
    servlen : LongWord;
    flags   : Integer): Integer;
begin
{$IFDEF UNICODE}
    if @FGetNameInfoW = nil then
        @FGetNameInfoW := GetProc3('GetNameInfoW');
    Result := FGetNameInfoW(addr, namelen, host, hostlen, serv, servlen, flags);
{$ELSE}
    if @FGetNameInfoA = nil then
        @FGetNameInfoA := GetProc3('getnameinfo');
    Result := FGetNameInfoA(addr, namelen, host, hostlen, serv, servlen, flags);
{$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Custom macro helpers }

{const
  NZoneMask   = $0FFFFFFF;
  NLevelMask  = $F0000000;
  NLevelShift = 28;}

function ScopeIdGetLevel(const AScopeId: ULONG): ULONG;
begin
    Result := (AScopeId and $F0000000) shr 28;
end;

function ScopeIdGetZone(const AScopeId: ULONG): ULONG;
begin
    Result := AScopeId and $0FFFFFFF;
end;

procedure ScopeIdSetLevel(var AScopeId: ULONG; const ALevel: ULONG);
begin
    AScopeId := (AScopeId and $0FFFFFFF) or ((ALevel shl 28) and $F0000000);
end;

procedure ScopeIdSetZone(var AScopeId: ULONG; const AZone: ULONG);
begin
    AScopeId := (AZone and $0FFFFFFF) or (AScopeId and $F0000000);
end;

function MakeScopeId(const AZone: ULONG; const ALevel: ULONG): ULONG;
begin
    ScopeIdSetZone(Result, AZone);
    ScopeIdSetLevel(Result, ALevel);
end;

{ Macros }

function IN6ADDR_ANY_INIT: TIn6Addr;
begin
    with Result do
        FillChar(s6_addr, SizeOf(TIn6Addr), 0);
end;

function IN6ADDR_LOOPBACK_INIT: TIn6Addr;
begin
    with Result do
    begin
        FillChar(s6_addr, SizeOf(TIn6Addr), 0);
        s6_addr[15] := $01;
    end;
end;

procedure IN6ADDR_SETANY(sa: PSockAddrIn6);
begin
    if sa <> nil then
        with sa^ do
        begin
            sin6_family := AF_INET6;
            sin6_port := 0;
            sin6_flowinfo := 0;
            PULONG(@sin6_addr.s6_addr[0])^  := 0;
            PULONG(@sin6_addr.s6_addr[4])^  := 0;
            PULONG(@sin6_addr.s6_addr[8])^  := 0;
            PULONG(@sin6_addr.s6_addr[12])^ := 0;
        end;
end;

procedure IN6ADDR_SETLOOPBACK(sa: PSockAddrIn6);
begin
    if sa <> nil then begin
        with sa^ do begin
          sin6_family := AF_INET6;
          sin6_port := 0;
          sin6_flowinfo := 0;
          PULONG(@sin6_addr.s6_addr[0])^ := 0;
          PULONG(@sin6_addr.s6_addr[4])^ := 0;
          PULONG(@sin6_addr.s6_addr[8])^ := 0;
          PULONG(@sin6_addr.s6_addr[12])^ := 1;
        end;
    end;
end;

function IN6ADDR_ISANY(sa: PSockAddrIn6): Boolean;
begin
    if sa <> nil then begin
        with sa^ do begin
            Result := (sin6_family = AF_INET6) and
                      (PULONG(@sin6_addr.s6_addr[0])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[4])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[8])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[12])^ = 0);
        end;
    end
    else
      Result := False;
end;

function IN6ADDR_ISLOOPBACK(sa: PSockAddrIn6): Boolean;
begin
    if sa <> nil then begin
        with sa^ do begin
            Result := (sin6_family = AF_INET6) and
                      (PULONG(@sin6_addr.s6_addr[0])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[4])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[8])^ = 0) and
                      (PULONG(@sin6_addr.s6_addr[12])^ = 1);
        end;
    end
    else
      Result := False;
end;

function IN6_ADDR_EQUAL(const a: PIn6Addr; const b: PIn6Addr): Boolean;
begin
    Result := CompareMem(a, b, SizeOf(TIn6Addr));
end;

function IN6_IS_ADDR_UNSPECIFIED(const a: PIn6Addr): Boolean;
begin
    Result := IN6_ADDR_EQUAL(a, @in6addr_any);
end;

function IN6_IS_ADDR_LOOPBACK(const a: PIn6Addr): Boolean;
begin
    Result := IN6_ADDR_EQUAL(a, @in6addr_loopback);
end;

function IN6_IS_ADDR_MULTICAST(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := (a^.s6_addr[0] = $FF)
    else
        Result := False;
end;

function IN6_IS_ADDR_LINKLOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := (a^.s6_addr[0] = $FE) and ((a^.s6_addr[1] and $C0) = $80)
    else
        Result := False;
end;

function IN6_IS_ADDR_SITELOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := (a^.s6_addr[0] = $FE) and ((a^.s6_addr[1] and $C0) = $C0)
    else
        Result := False;
end;

function IN6_IS_ADDR_V4MAPPED(const a: PIn6Addr): Boolean;
begin
    if a <> nil then begin
        with a^ do begin
            Result := (Word[0] = 0) and
                      (Word[1] = 0) and
                      (Word[2] = 0) and
                      (Word[3] = 0) and
                      (Word[4] = 0) and
                      (Word[5] = $FFFF);
        end;
    end
    else
        Result := False;
end;

function IN6_IS_ADDR_V4COMPAT(const a: PIn6Addr): Boolean;
begin
    if a <> nil then begin
        with a^ do begin
          Result := (Word[0] = 0) and
                    (Word[1] = 0) and
                    (Word[2] = 0) and
                    (Word[3] = 0) and
                    (Word[4] = 0) and
                    (Word[5] = 0) and
                    not ((Word[6] = 0) and (s6_addr[14] = 0) and
                    ((s6_addr[15] = 0) or (s6_addr[15] = 1)));
        end;
    end
    else
        Result := False;
end;

function IN6_IS_ADDR_MC_NODELOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := IN6_IS_ADDR_MULTICAST(a) and ((a^.s6_addr[1] and $F) = 1)
    else
        Result := False;
end;

function IN6_IS_ADDR_MC_LINKLOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := IN6_IS_ADDR_MULTICAST(a) and ((a^.s6_addr[1] and $F) = 2)
    else
        Result := False;
end;

function IN6_IS_ADDR_MC_SITELOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := IN6_IS_ADDR_MULTICAST(a) and ((a^.s6_addr[1] and $F) = 5)
    else
        Result := False;
end;

function IN6_IS_ADDR_MC_ORGLOCAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := IN6_IS_ADDR_MULTICAST(a) and ((a^.s6_addr[1] and $F) = 8)
    else
        Result := False;
end;

function IN6_IS_ADDR_MC_GLOBAL(const a: PIn6Addr): Boolean;
begin
    if a <> nil then
        Result := IN6_IS_ADDR_MULTICAST(a) and ((a^.s6_addr[1] and $F) = $E)
    else
        Result := False;
end;

{$ENDIF MSWINDOWS}   { V9.4 }

initialization
{$IFDEF MSWINDOWS}     { V9.4 }
    InitializeCriticalSection(GWSockCritSect);
    in6addr_any := IN6ADDR_ANY_INIT;
    in6addr_loopback := IN6ADDR_LOOPBACK_INIT;

finalization
    DeleteCriticalSection(GWSockCritSect);

{$ENDIF MSWINDOWS}

end.




