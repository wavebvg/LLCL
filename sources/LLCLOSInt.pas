unit LLCLOSInt;

{
         LLCL - FPC/Lazarus Light LCL
               based upon
         LVCL - Very LIGHT VCL
         ----------------------------

    This file is a part of the Light LCL (LLCL).

    This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

    This Source Code Form is “Incompatible With Secondary Licenses”,
  as defined by the Mozilla Public License, v. 2.0.

  Copyright (c) 2015 ChrisF

  Based upon the Very LIGHT VCL (LVCL):
  Copyright (c) 2008 Arnaud Bouchez - http://bouchez.info
  Portions Copyright (c) 2001 Paul Toth - http://tothpaul.free.fr

   Version 1.00:
    * File creation.
    * Windows API and structures (only a subset)
    * String conversions (Ansi and Unicode strings)

   ** Warning ** This unit is not supposed to be used/included
                 directly into the user's programs
}

{$IFDEF FPC}
  {$define LLCL_FPC_MODESECTION}
  {$I LLCLFPCInc.inc}             // For mode
  {$undef LLCL_FPC_MODESECTION}
{$ENDIF}
{$ifdef FPC_OBJFPC} {$define LLCL_OBJFPC_MODE} {$endif} // Object pascal mode

{$I LLCLOptions.inc}      // Options

// OS API (Windows)
{$IFDEF FPC}
  {$IFDEF DisableWindowsUnicodeSupport}
    {$DEFINE LLCL_UNICODE_API_A}        // Ansi only
  {$ELSE}               // (Ansi already means Ansi only)
    {$DEFINE LLCL_UNICODE_API_W}        // Ansi and Wide
  {$ENDIF}
{$ELSE FPC}
  {$IFDEF UNICODE}      // Defined insided Delphi
    {$DEFINE LLCL_UNICODE_API_W}        //
    {$DEFINE LLCL_UNICODE_API_W_ONLY}   // Wide only
  {$ELSE}               // (Ansi already means Ansi only)
    {$DEFINE LLCL_UNICODE_API_A}        // Ansi only
  {$ENDIF}
{$ENDIF FPC}

// If APIs type are overriden in LLCLOptions.inc
{$IFDEF LLCL_OPT_UNICODE_API_A}
  {$UNDEF LLCL_UNICODE_API_W}
  {$UNDEF LLCL_UNICODE_API_W_ONLY}
  {$DEFINE LLCL_UNICODE_API_A}
{$ENDIF}

{$IFDEF LLCL_OPT_UNICODE_API_W}
  {$UNDEF LLCL_UNICODE_API_A}
  {$UNDEF LLCL_UNICODE_API_W_ONLY}
  {$DEFINE LLCL_UNICODE_API_W}
{$ENDIF}

{$IFDEF LLCL_OPT_UNICODE_API_W_ONLY}
  {$UNDEF LLCL_UNICODE_API_A}
  {$DEFINE LLCL_UNICODE_API_W_ONLY}
  {$DEFINE LLCL_UNICODE_API_W_ONLY_ONLY}
{$ENDIF}

{$IFDEF LLCL_UNICODE_API_W_ONLY}      // (Sanity)
  {$DEFINE LLCL_UNICODE_API_W}
{$ENDIF}

//{$DEFINE LLCL_API_ALLMAPPING}   // Mapping for non Ansi/Unicode API too

// Standard strings definition

{$IFDEF FPC}
  {$IFDEF UNICODE}
    {$DEFINE LLCL_UNICODE_STR_UTF16}  // UTF16
  {$ELSE}                             //
    {$DEFINE LLCL_UNICODE_STR_UTF8}   //   or UTF8
  {$ENDIF}
{$ELSE FPC}
  {$IFDEF UNICODE}
    {$DEFINE LLCL_UNICODE_STR_UTF16}  // UTF16
  {$ELSE}                             //
    {$DEFINE LLCL_UNICODE_STR_ANSI}   //   or Ansi
  {$ENDIF}
{$ENDIF FPC}

//------------------------------------------------------------------------------

interface

uses
{$IFNDEF FPC}
  ShellApi,
{$ENDIF NFPC}
  Windows, CommDlg;

{$IFDEF FPC}
  {$I LLCLFPCInc.inc}   // (for LLCL_MISSING_WINDOWS_DEC, LLCL_EXTWIN_WIDESTRUCT, LLCL_FPC_UTF8RTL, LLCL_FPC_CPSTRING, LLCL_FPC_ANSISYS or LLCL_FPC_UNISYS)
{$ELSE FPC}
  {$if not Declared(CompilerVersion)}
    const CompilerVersion = 1;  // Before Delphi 6
  {$ifend}
  {$if CompilerVersion<20}      // Before Delphi 2009
    type NativeInt = Integer;
    type unicodestring = widestring;
    type PUnicodeChar = PWideChar;
  {$ifend}
  {$if CompilerVersion<21}      // Before Delphi 2010
    type NativeUInt = Cardinal;
  {$ifend}
  {$if CompilerVersion>=24}     // Delphi XE3 or after
    {$zerobasedstrings off}
  {$ifend}
  {$if CompilerVersion>=20}     // Delphi 2009 or after
    {$define LLCL_EXTWIN_WIDESTRUCT}  // External Windows wide structures
  {$ifend}
{$ENDIF FPC}

// Message strings used in LLCL (mostly error/exception and debug)
//   Though they are not supposed to be seen by the final user, it's
//   possible to use an external include file for translation purposes

// Constant message strings (language adaptation)
//{$DEFINE LLCL_STR_USE_EXTINC}
{$IFDEF LLCL_STR_USE_EXTINC}
{$if Defined(FPC) or Defined(UNICODE)}
  {$I LLCLSTREXTInc_UTF8.inc}
{$else}
  {$I LLCLSTREXTInc_ANSI.inc}
{$ifend}
{$ELSE}
const
  LLCL_STR_CLAS_TLISTINDEXOUTRANGE      = 'TList: Index %d out of range';
  LLCL_STR_CLAS_TSTRLISTINDEXOUTRANGE   = 'TStringList: Index %d out of range';
  LLCL_STR_CLAS_SETSIZE                 = 'SetSize';
  LLCL_STR_CLAS_BOOL                    = 'boolean?';
  LLCL_STR_CLAS_ORDINAL                 = 'ordinal?';
  LLCL_STR_CLAS_STRING                  = 'string? %d';
  LLCL_STR_CLAS_COLOR                   = 'color?';
  LLCL_STR_CLAS_BINARY                  = 'binary?';
  LLCL_STR_CLAS_IDENT                   = 'ident?';
  LLCL_STR_CLAS_SET                     = 'set?';
  LLCL_STR_CLAS_SETOF                   = 'set of? %d';
  LLCL_STR_CLAS_LIST                    = 'list?';
  LLCL_STR_CLAS_BYTES                   = ' bytes)';
  LLCL_STR_CLAS_BADVALUETYPE            = 'Bad value type ';
  LLCL_STR_CLAS_UNKNVALUETYPE           = '%s.%s: unknown value type = %d';
  LLCL_STR_CLAS_SCLASS                  = '%s?';
  LLCL_STR_CLAS_LOAD                    = 'Load';
  LLCL_STR_FORM_RESOURCESIZE            = 'ResSize %s';
  LLCL_STR_CTRL_METHOD                  = 'method?';
  LLLC_STR_GRAP_BITMAPFILEERR           = 'Error bitmap file';
  LLCL_STR_SYSU_CANTCREATEDIR           = 'Cannot create directory';      // Also used in LazFileUtils
  LLCL_STR_SYSU_OUTOFMEMORY             = 'Error %d';
  LLCL_STR_SYSU_ABORT                   = 'Operation aborted';
  LLCL_STR_SYSU_OSERROR                 = 'OSError %d (%s)';
  LLCL_STR_SYSU_ERROR                   = 'Error %d at %x';
  LLCL_STR_SYSU_ASSERTERROR             = '%s in %s (%d) at %x';
{$ENDIF}

const
  LLCL_WIN98ME_MAJ  = 4; LLCL_WIN98ME_MIN  = 90;    // Only a few of them
  LLCL_WIN2000_MAJ  = 5; LLCL_WIN2000_MIN  = 00;
  LLCL_WINXP_MAJ    = 5; LLCL_WINXP_MIN    = 01;
  LLCL_WINVISTA_MAJ = 6; LLCL_WINVISTA_MIN = 00;

// API Redefinitions
{$IFDEF FPC}
type
  TFNTimerProc = TIMERPROC;
{$ELSE FPC}
type
  HANDLE = THandle;
  LPSECURITY_ATTRIBUTES = PSecurityAttributes;
{$ENDIF FPC}

// Some Specific Declarations (To not include Messages/LMessages)
{$IFNDEF FPC}
const
  WM_SETTEXT          = $000C;
  WM_GETTEXT          = $000D;
  WM_GETTEXTLENGTH    = $000E;
{$ENDIF NFPC}

// Common Controls
type
  PInitCommonControlsEx = ^TInitCommonControlsEx;
  TInitCommonControlsEx = record
    dwSize: cardinal;
    dwICC:  cardinal;
  end;

// Modified or Specified Structures (If Ansi/Unicode involved)
type
  TCustomNonClientMetrics = record    // Reduced version of TNonClientMetricsA/W
    iBorderWidth:     integer;
    iCaptionHeight:   integer;
    iMenuHeight:      integer;
  end;
{$IFDEF LLCL_MISSING_WINDOWS_DEC}
// Note: currently (FPC 2.6.4/2.7.x/3.x.x) TNonClientMetricsA and TNonClientMetricsW
//       are not both defined. So,
type
  TNonClientMetricsA = record
    cbSize:           cardinal;
    iBorderWidth:     integer;
    iScrollWidth:     integer;
    iScrollHeight:    integer;
    iCaptionWidth:    integer;
    iCaptionHeight:   integer;
    lfCaptionFont:    TLogFontA;
    iSmCaptionWidth:  integer;
    iSmCaptionHeight: integer;
    lfSmCaptionFont:  TLogFontA;
    iMenuWidth:       integer;
    iMenuHeight:      integer;
    lfMenuFont:       TLogFontA;
    lfStatusFont:     TLogFontA;
    lfMessageFont:    TLogFontA;
    // Only if WINVER >= LLCL_WINVISTA_MAJ
    // iPaddedBorderWidth: integer;
  end;

  TNonClientMetricsW = record
    cbSize:           cardinal;
    iBorderWidth:     integer;
    iScrollWidth:     integer;
    iScrollHeight:    integer;
    iCaptionWidth:    integer;
    iCaptionHeight:   integer;
    lfCaptionFont:    TLogFontW;
    iSmCaptionWidth:  integer;
    iSmCaptionHeight: integer;
    lfSmCaptionFont:  TLogFontW;
    iMenuWidth:       integer;
    iMenuHeight:      integer;
    lfMenuFont:       TLogFontW;
    lfStatusFont:     TLogFontW;
    lfMessageFont:    TLogFontW;
    // Only if WINVER >= LLCL_WINVISTA_MAJ
    // iPaddedBorderWidth: integer;
  end;
{$ENDIF LLCL_MISSING_WINDOWS_DEC}

// Various additions
const
  INVALID_SET_FILE_POINTER  = -1;
  INVALID_FILE_ATTRIBUTES   = -1;
{$IFDEF LLCL_MISSING_WINDOWS_DEC}
// Note: currently (FPC 2.6.4/2.7.x/3.x.x), PBM_GETPOS absent (WM_USER+8), and can't use CmmCtrl
const
  PBM_GETPOS          = 1032;
{$ENDIF LLCL_MISSING_WINDOWS_DEC}

type
{$IFNDEF LLCL_UNICODE_API_W_ONLY}   // (Internal only structure)
  TCustomLogFont        = TLogFontA;
{$ELSE}
  TCustomLogFont        = TLogFontW;
{$ENDIF}

type
  TCustomNotifyIconData = record
    cbSize:           cardinal;
    Wnd:              HWND;
    uID:              cardinal;
    uFlags:           cardinal;
    uCallbackMessage: cardinal;
    hIcon:            HICON;
  end;
  PCustomNotifyIconData = ^TCustomNotifyIconData;

// Different origins, different versions. Redefined here...
  TCustomNotifyIconDataA = record
    cbSize:           cardinal;
    Wnd:              HWND;
    uID:              cardinal;
    uFlags:           cardinal;
    uCallbackMessage: cardinal;
    hIcon:            HICON;
    szTip:            array [0..63] of AnsiChar;
  end;
  PCustomNotifyIconDataA = ^TCustomNotifyIconDataA;
  TCustomNotifyIconDataExtA = record
    cbSize:           cardinal;
    Wnd:              HWND;
    uID:              cardinal;
    uFlags:           cardinal;
    uCallbackMessage: cardinal;
    hIcon:            HICON;
    szTip:            array [0..127] of AnsiChar;
    dwState:          cardinal;
    dwStateMask:      cardinal;
    szInfo:           array [0..255] of AnsiChar;
    TOVUnion:         record
      case integer of
      0: (uTimeOut:   cardinal);
      1: (uVersion:   cardinal);
      end;
    szInfoTitle:      array [0..63] of AnsiChar;
    dwInfoFlags:      cardinal;
    // Only if WINVER >= LLCL_WINXP_MAJ
    // guidItem:         GUID;
    // Only if WINVER >= LLCL_WINVISTA_MAJ
    // hBalloonIcon:     HICON;
  end;
  PCustomNotifyIconDataExtA = ^TCustomNotifyIconDataExtA;
  TCustomNotifyIconDataW = record
    cbSize:           cardinal;
    Wnd:              HWND;
    uID:              cardinal;
    uFlags:           cardinal;
    uCallbackMessage: cardinal;
    hIcon:            HICON;
    szTip:            array [0..63] of WideChar;
  end;
  PCustomNotifyIconDataW = ^TCustomNotifyIconDataW;
  TCustomNotifyIconDataExtW = record
    cbSize:           cardinal;
    Wnd:              HWND;
    uID:              cardinal;
    uFlags:           cardinal;
    uCallbackMessage: cardinal;
    hIcon:            HICON;
    szTip:            array [0..127] of WideChar;
    dwState:          cardinal;
    dwStateMask:      cardinal;
    szInfo:           array [0..255] of WideChar;
    TOVUnion:         record
      case integer of
      0: (uTimeOut:   cardinal);
      1: (uVersion:   cardinal);
      end;
    szInfoTitle:      array [0..63] of WideChar;
    dwInfoFlags:      cardinal;
    // Only if WINVER >= LLCL_WINXP_MAJ
    // guidItem:         GUID;
    // Only if WINVER >= LLCL_WINVISTA_MAJ
    // hBalloonIcon:     HICON;
  end;
  PCustomNotifyIconDataExtW = ^TCustomNotifyIconDataExtW;

  TOpenStrParam = record
    sFilter:          string;
    sFileName:        string;
    sInitialDir:      string;
    sTitle:           string;
    sDefExt:          string;
    NbrFileNames:     integer;
  end;

type
{$IFNDEF LLCL_EXTWIN_WIDESTRUCT}
  TCustomWin32FindData  = TWin32FindDataA;
{$ELSE}
  TCustomWin32FindData  = TWin32FindDataW;
{$ENDIF}
const
  LLCLC_LENCOM_WIN32FINDDATA = 44;    // Common beginning part, before variable (Ansi/Wide) part

// API Declarations with both Ansi/Unicode versions

const
  CKERNEL32         = 'kernel32.dll';
  CUSER32           = 'user32.dll';
  CGDI32            = 'gdi32.dll';
  CCOMCTL32         = 'comctl32.dll';
  CCOMDLG32         = 'comdlg32.dll';
  CSHELL32          = 'shell32.dll';
  CVERSION          = 'version.dll';

function  GetVersionExW(var lpVersionInformation: TOSVersionInfoW): BOOL; stdcall; external CKERNEL32 name 'GetVersionExW';
function  GetModuleHandleW(lpModuleName: LPCWSTR): HMODULE; stdcall; external CKERNEL32 name 'GetModuleHandleW';
function  GetModuleFileNameW(hModule: HINST; lpFilename: LPCWSTR; nSize: DWORD): DWORD; stdcall; external CKERNEL32 name 'GetModuleFileNameW';
function  CreateFileW(lpFileName: LPCWSTR; dwDesiredAccess, dwShareMode: DWORD; lpSecurityAttributes: LPSECURITY_ATTRIBUTES; dwCreationDisposition: DWORD; dwFlagsAndAttributes: DWORD; hTemplateFile: HANDLE): HANDLE; stdcall; external CKERNEL32 name 'CreateFileW';
function  GetFileAttributesW(lpFileName: LPCWSTR): DWORD; stdcall; external CKERNEL32 name 'GetFileAttributesW';
function  GetFileAttributesExW(lpFileName: LPCWSTR; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer): BOOL; stdcall; external CKERNEL32 name 'GetFileAttributesExW';
function  FindFirstFileW(lpFileName: LPCWSTR; var lpFindFileData: TWin32FindDataW): HANDLE; stdcall; external CKERNEL32 name 'FindFirstFileW';
function  FindNextFileW(hFindFile: HANDLE; var lpFindFileData: TWin32FindDataW): BOOL; stdcall; external CKERNEL32 name 'FindNextFileW';
function  FindResourceW(hModule: HMODULE; lpName, lpType: LPCWSTR): HRSRC; stdcall; external CKERNEL32 name 'FindResourceW';
function  GetCurrentDirectoryW(nBufferLength: DWORD; lpBuffer: LPCWSTR): DWORD; stdcall; external CKERNEL32 name 'GetCurrentDirectoryW';
function  SetCurrentDirectoryW(lpPathName: LPCWSTR): BOOL; stdcall; external CKERNEL32 name 'SetCurrentDirectoryW';
function  CreateDirectoryW(lpPathName: LPCWSTR; lpSecurityAttributes: PSecurityAttributes): BOOL; stdcall; external CKERNEL32 name 'CreateDirectoryW';
function  RemoveDirectoryW(lpPathName: LPCWSTR): BOOL; stdcall; external CKERNEL32 name 'RemoveDirectoryW';
function  GetFullPathNameW(lpFileName: LPCWSTR; nBufferLength: DWORD; lpBuffer: LPCWSTR; var lpFilePart: LPCWSTR): DWORD; stdcall; external CKERNEL32 name 'GetFullPathNameW';
function  GetDiskFreeSpaceW(lpRootPathName: LPCWSTR; var lpSectorsPerCluster, lpBytesPerSector, lpNumberOfFreeClusters, lpTotalNumberOfClusters: DWORD): BOOL; stdcall; external CKERNEL32 name 'GetDiskFreeSpaceW';
function  GetDiskFreeSpaceExW(lpDirectoryName: LPCWSTR; lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes: PInt64): BOOL; stdcall; external CKERNEL32 name 'GetDiskFreeSpaceExW';
function  FormatMessageW(dwFlags: DWORD; lpSource: Pointer; dwMessageId: DWORD; dwLanguageId: DWORD; lpBuffer: LPCWSTR; nSize: DWORD; Arguments: Pointer): DWORD; stdcall; external CKERNEL32 name 'FormatMessageW';
function  CharToOemW(lpszSrc: LPCWSTR; lpszDst: LPCSTR): BOOL; stdcall; external CUSER32 name 'CharToOemW';
function  CompareStringW(Locale: LCID; dwCmpFlags: DWORD; lpString1: LPCWSTR; cchCount1: Integer; lpString2: LPCWSTR; cchCount2: Integer): Integer; stdcall; external CKERNEL32 name 'CompareStringW';
function  LoadLibraryW(lpLibFileName: LPCWSTR): HMODULE; stdcall; external CKERNEL32 name 'LoadLibraryW';
function  CreateEventW(lpEventAttributes: LPSECURITY_ATTRIBUTES; bManualReset: BOOL; bInitialState: BOOL; lpName: LPCWSTR): HANDLE; stdcall; external CKERNEL32 name 'CreateEventW';
function  RegisterClassW(const lpWndClass: TWndClassW): ATOM; stdcall; external CUSER32 name 'RegisterClassW';
function  UnregisterClassW(lpClassName: LPCWSTR; hInstance: HINST): BOOL; stdcall; external CUSER32 name 'UnregisterClassW';
function  CreateWindowExW(dwExStyle: DWORD; lpClassName: LPCWSTR; lpWindowName: LPCWSTR;
  dwStyle: DWORD; X, Y, nWidth, nHeight: Integer; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND; stdcall; external CUSER32 name 'CreateWindowExW';
function  DefWindowProcW(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external CUSER32 name 'DefWindowProcW';
function  CallWindowProcW(lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external CUSER32 name 'CallWindowProcW';
function  PeekMessageW(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; stdcall; external CUSER32 name 'PeekMessageW';
function  DispatchMessageW(const lpMsg: TMsg): longint; stdcall; external CUSER32 name 'DispatchMessageW';
function  SendMessageW(hWnd: HWND; Msg: Cardinal; WParam: WPARAM; LParam: LPARAM): LRESULT; stdcall; external CUSER32 name 'SendMessageW';
function  PostMessageW(hWnd: HWND; Msg: Cardinal; WParam: WPARAM; LParam: LPARAM): LRESULT; stdcall; external CUSER32 name 'PostMessageW';
function  GetWindowLongW(hWnd: HWND; nIndex: Integer): longint; stdcall; external CUSER32 name 'GetWindowLongW';
function  SetWindowLongW(hWnd: HWND; nIndex: Integer; dwNewLong: longint): longint; stdcall; external CUSER32 name 'SetWindowLongW';
{$ifdef cpu64}
function  GetClassLongPtrW(hWnd: HWND; nIndex: Integer): NativeUInt; stdcall; external CUSER32 name 'GetClassLongPtrW';
function  SetClassLongPtrW(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt; stdcall; external CUSER32 name 'SetClassLongPtrW';
function  GetWindowLongPtrW(hWnd: HWND; nIndex: Integer): NativeUInt; stdcall; external CUSER32 name 'GetWindowLongPtrW';
function  SetWindowLongPtrW(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt; stdcall; external CUSER32 name 'SetWindowLongPtrW';
{$else}
function  GetClassLongPtrW(hWnd: HWND; nIndex: Integer): NativeUInt; stdcall; external CUSER32 name 'GetClassLongW';
function  SetClassLongPtrW(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt; stdcall; external CUSER32 name 'SetClassLongW';
function  GetWindowLongPtrW(hWnd: HWND; nIndex: Integer): NativeUInt; stdcall; external CUSER32 name 'GetWindowLongW';
function  SetWindowLongPtrW(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt; stdcall; external CUSER32 name 'SetWindowLongW';
{$endif}
function  DrawTextW(hDC: HDC; lpString: LPCWSTR; nCount: Integer; var lpRect: TRect; uFormat: UINT): Integer; stdcall; external CUSER32 name 'DrawTextW';
function  LoadIconW(hInstance: HINST; lpIconName: LPCWSTR): HICON; stdcall; external CUSER32 name 'LoadIconW';
function  LoadCursorW(hInstance: HINST; lpCursorName: LPCWSTR): HCURSOR; stdcall;  external CUSER32 name 'LoadCursorW';
function  SystemParametersInfoW(uiAction, uiParam: UINT; pvParam: Pointer; fWinIni: UINT): BOOL; stdcall; external CUSER32 name 'SystemParametersInfoW';
function  MessageBoxW(hWnd: HWND; lpText, lpCaption: LPCWSTR; uType: UINT): Integer; stdcall; external CUSER32 name 'MessageBoxW';
function  AppendMenuW(hMenu: HMENU; uFlags, uIDNewItem: UINT; lpNewItem: LPCWSTR): BOOL; stdcall; external CUSER32 name 'AppendMenuW';
function  ModifyMenuW(hMnu: HMENU; uPosition, uFlags, uIDNewItem: UINT; lpNewItem: LPCWSTR): BOOL; stdcall; external CUSER32 name 'ModifyMenuW';
function  CharUpperBuffW(lpsz: LPCWSTR; cchLength: DWORD): DWORD; stdcall; external CUSER32 name 'CharUpperBuffW';
function  CharLowerBuffW(lpsz: LPCWSTR; cchLength: DWORD): DWORD; stdcall; external CUSER32 name 'CharLowerBuffW';
function  TextOutW(DC: HDC; X, Y: Integer; lpString: LPCWSTR; Count: Integer): BOOL; stdcall; external CGDI32 name 'TextOutW';
function  ExtTextOutW(DC: HDC; X, Y: Integer; Options: longint; Rect: PRect; Str: LPCWSTR; Count: longint; Dx: PInteger): BOOL; stdcall; external CGDI32 name 'ExtTextOutW';
function  GetTextExtentPoint32W(DC: HDC; Str: LPCWSTR; Count: Integer; var Size: TSize): BOOL; stdcall; external CGDI32 name 'GetTextExtentPoint32W';
function  CreateFontIndirectW(const p1: TLogFontW): HFONT; stdcall; external CGDI32 name 'CreateFontIndirectW';
function  Shell_NotifyIconW(dwMessage: DWORD; lpData: PNotifyIconDataW): BOOL; stdcall; external CSHELL32 name 'Shell_NotifyIconW';
function  GetOpenFileNameW(var OpenFile: TOpenFilenameW): BOOL; stdcall; external CCOMDLG32 name 'GetOpenFileNameW';
function  GetSaveFileNameW(var OpenFile: TOpenFilenameW): BOOL; stdcall; external CCOMDLG32 name 'GetSaveFileNameW';
function  GetFileVersionInfoSizeW(lptstrFilename: LPCWSTR; var lpdwHandle: DWORD): DWORD; stdcall; external CVERSION name 'GetFileVersionInfoSizeW';
function  GetFileVersionInfoW(lptstrFilename: LPCWSTR; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL; stdcall; external CVERSION name 'GetFileVersionInfoW';
function  VerQueryValueW(pBlock: Pointer; lpSubBlock: LPCWSTR; var lplpBuffer: Pointer; var puLen: UINT): BOOL; stdcall; external CVERSION name 'VerQueryValueW';

function  GetVersionExA(var lpVersionInformation: TOSVersionInfoA): BOOL; stdcall; external CKERNEL32 name 'GetVersionExA';
function  GetModuleHandleA(lpModuleName: LPCSTR): HMODULE; stdcall; external CKERNEL32 name 'GetModuleHandleA';
function  GetModuleFileNameA(hModule: HINST; lpFilename: LPCSTR; nSize: DWORD): DWORD; stdcall; external CKERNEL32 name 'GetModuleFileNameA';
function  CreateFileA(lpFileName: LPCSTR; dwDesiredAccess, dwShareMode: DWORD; lpSecurityAttributes: LPSECURITY_ATTRIBUTES; dwCreationDisposition: DWORD; dwFlagsAndAttributes: DWORD; hTemplateFile: HANDLE): HANDLE; stdcall; external CKERNEL32 name 'CreateFileA';
function  GetFileAttributesA(lpFileName: LPCSTR): DWORD; stdcall; external CKERNEL32 name 'GetFileAttributesA';
function  GetFileAttributesExA(lpFileName: LPCSTR; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer): BOOL; stdcall; external CKERNEL32 name 'GetFileAttributesExA';
function  FindFirstFileA(lpFileName: LPCSTR; var lpFindFileData: TWin32FindDataA): HANDLE; stdcall; external CKERNEL32 name 'FindFirstFileA';
function  FindNextFileA(hFindFile: HANDLE; var FindFileData: TWin32FindDataA): BOOL; stdcall; external CKERNEL32 name 'FindNextFileA';
function  FindResourceA(hModule: HMODULE; lpName, lpType: LPCSTR): HRSRC; stdcall; external CKERNEL32 name 'FindResourceA';
function  GetCurrentDirectoryA(nBufferLength: DWORD; lpBuffer: LPCSTR): DWORD; stdcall; external CKERNEL32 name 'GetCurrentDirectoryA';
function  SetCurrentDirectoryA(lpPathName: LPCSTR): BOOL; stdcall; external CKERNEL32 name 'SetCurrentDirectoryA';
function  CreateDirectoryA(lpPathName: LPCSTR; lpSecurityAttributes: PSecurityAttributes): BOOL; stdcall; external CKERNEL32 name 'CreateDirectoryA';
function  RemoveDirectoryA(lpPathName: LPCSTR): BOOL; stdcall; external CKERNEL32 name 'RemoveDirectoryA';
function  GetFullPathNameA(lpFileName: LPCSTR; nBufferLength: DWORD; lpBuffer: LPCSTR; var lpFilePart: LPCSTR): DWORD; stdcall; external CKERNEL32 name 'GetFullPathNameA';
function  GetDiskFreeSpaceA(lpRootPathName: LPCSTR; var lpSectorsPerCluster, lpBytesPerSector, lpNumberOfFreeClusters, lpTotalNumberOfClusters: DWORD): BOOL; stdcall; external CKERNEL32 name 'GetDiskFreeSpaceA';
function  GetDiskFreeSpaceExA(lpDirectoryName: LPCSTR; lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes: PInt64): BOOL; stdcall; external CKERNEL32 name 'GetDiskFreeSpaceExA';
function  FormatMessageA(dwFlags: DWORD; lpSource: Pointer; dwMessageId: DWORD; dwLanguageId: DWORD; lpBuffer: LPCSTR; nSize: DWORD; Arguments: Pointer): DWORD; stdcall; external CKERNEL32 name 'FormatMessageA';
function  CharToOemA(lpszSrc: LPCSTR; lpszDst: LPCSTR): BOOL; stdcall; external CUSER32 name 'CharToOemA';
function  CompareStringA(Locale: LCID; dwCmpFlags: DWORD; lpString1: LPCSTR; cchCount1: Integer; lpString2: PAnsiChar; cchCount2: Integer): Integer; stdcall; external CKERNEL32 name 'CompareStringA';
function  LoadLibraryA(lpLibFileName: LPCSTR): HMODULE; stdcall; external CKERNEL32 name 'LoadLibraryA';
function  CreateEventA(lpEventAttributes: LPSECURITY_ATTRIBUTES; bManualReset: BOOL; bInitialState: BOOL; lpName: LPCSTR): HANDLE; stdcall; external CKERNEL32 name 'CreateEventA';
function  RegisterClassA(const lpWndClass: TWndClassA): ATOM; stdcall; external CUSER32 name 'RegisterClassA';
function  UnregisterClassA(lpClassName: LPCSTR; hInstance: HINST): BOOL; stdcall; external CUSER32 name 'UnregisterClassA';
function  CreateWindowExA(dwExStyle: DWORD; lpClassName: LPCSTR; lpWindowName: LPCSTR;
  dwStyle: DWORD; X, Y, nWidth, nHeight: Integer; hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND; stdcall; external CUSER32 name 'CreateWindowExA';
function DefWindowProcA(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external CUSER32 name 'DefWindowProcA';
function  CallWindowProcA(lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; external CUSER32 name 'CallWindowProcA';
function  PeekMessageA(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; stdcall; external CUSER32 name 'PeekMessageA';
function  DispatchMessageA(const lpMsg: TMsg): longint; stdcall; external CUSER32 name 'DispatchMessageA';
function  SendMessageA(hWnd: HWND; Msg: Cardinal; WParam: WPARAM; LParam: LPARAM): LRESULT; stdcall; external CUSER32 name 'SendMessageA';
function  PostMessageA(hWnd: HWND; Msg: Cardinal; WParam: WPARAM; LParam: LPARAM): LRESULT; stdcall; external CUSER32 name 'PostMessageA';
function  GetWindowLongA(hWnd: HWND; nIndex: Integer): longint; stdcall; external CUSER32 name 'GetWindowLongA';
function  SetWindowLongA(hWnd: HWND; nIndex: Integer; dwNewLong: longint): longint; stdcall; external CUSER32 name 'SetWindowLongA';
{$ifdef cpu64}
function  GetClassLongPtrA(hWnd: HWND; nIndex: Integer): NativeUInt; stdcall; external CUSER32 name 'GetClassLongPtrA';
function  SetClassLongPtrA(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt; stdcall; external CUSER32 name 'SetClassLongPtrA';
function  GetWindowLongPtrA(hWnd: HWND; nIndex: Integer): NativeUInt; stdcall; external CUSER32 name 'GetWindowLongPtrA';
function  SetWindowLongPtrA(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt; stdcall; external CUSER32 name 'SetWindowLongPtrA';
{$else}
function  GetClassLongPtrA(hWnd: HWND; nIndex: Integer): NativeUInt; stdcall; external CUSER32 name 'GetClassLongA';
function  SetClassLongPtrA(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt; stdcall; external CUSER32 name 'SetClassLongA';
function  GetWindowLongPtrA(hWnd: HWND; nIndex: Integer): NativeUInt; stdcall; external CUSER32 name 'GetWindowLongA';
function  SetWindowLongPtrA(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt; stdcall; external CUSER32 name 'SetWindowLongA';
{$endif}
function  DrawTextA(hDC: HDC; lpString: LPCSTR; nCount: Integer; var lpRect: TRect; uFormat: UINT): Integer; stdcall; external CUSER32 name 'DrawTextA';
function  LoadIconA(hInstance: HINST; lpIconName: LPCSTR): HICON; stdcall; external CUSER32 name 'LoadIconA';
function  LoadCursorA(hInstance: HINST; lpCursorName: LPCSTR): HCURSOR; stdcall;  external CUSER32 name 'LoadCursorA';
function  SystemParametersInfoA(uiAction, uiParam: UINT; pvParam: Pointer; fWinIni: UINT): BOOL; stdcall; external CUSER32 name 'SystemParametersInfoA';
function  MessageBoxA(hWnd: HWND; lpText, lpCaption: LPCSTR; uType: UINT): Integer; stdcall; external CUSER32 name 'MessageBoxA';
function  AppendMenuA(hMenu: HMENU; uFlags, uIDNewItem: UINT; lpNewItem: LPCSTR): BOOL; stdcall; external CUSER32 name 'AppendMenuA';
function  ModifyMenuA(hMnu: HMENU; uPosition, uFlags, uIDNewItem: UINT; lpNewItem: LPCSTR): BOOL; stdcall; external CUSER32 name 'ModifyMenuA';
function  CharUpperBuffA(lpsz: LPCSTR; cchLength: DWORD): DWORD; stdcall; external CUSER32 name 'CharUpperBuffA';
function  CharLowerBuffA(lpsz: LPCSTR; cchLength: DWORD): DWORD; stdcall; external CUSER32 name 'CharLowerBuffA';
function  TextOutA(DC: HDC; X, Y: Integer; lpString: LPCSTR; Count: Integer): BOOL; stdcall; external CGDI32 name 'TextOutA';
function  ExtTextOutA(DC: HDC; X, Y: Integer; Options: longint; Rect: PRect; Str: LPCSTR; Count: longint; Dx: PInteger): BOOL; stdcall; external CGDI32 name 'ExtTextOutA';
function  GetTextExtentPoint32A(DC: HDC; Str: LPCSTR; Count: Integer; var Size: TSize): BOOL; stdcall; external CGDI32 name 'GetTextExtentPoint32A';
function  CreateFontIndirectA(const p1: TLogFontA): HFONT; stdcall; external CGDI32 name 'CreateFontIndirectA';
function  Shell_NotifyIconA(dwMessage: DWORD; lpData: PNotifyIconDataA): BOOL; stdcall; external CSHELL32 name 'Shell_NotifyIconA';
function  GetOpenFileNameA(var OpenFile: TOpenFilenameA): BOOL; stdcall; external CCOMDLG32 name 'GetOpenFileNameA';
function  GetSaveFileNameA(var OpenFile: TOpenFilenameA): BOOL; stdcall; external CCOMDLG32 name 'GetSaveFileNameA';
function  GetFileVersionInfoSizeA(lptstrFilename: LPCSTR; var lpdwHandle: DWORD): DWORD; stdcall; external CVERSION name 'GetFileVersionInfoSizeA';
function  GetFileVersionInfoA(lptstrFilename: LPCSTR; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL; stdcall; external CVERSION name 'GetFileVersionInfoA';
function  VerQueryValueA(pBlock: Pointer; lpSubBlock: LPCSTR; var lplpBuffer: Pointer; var puLen: UINT): BOOL; stdcall; external CVERSION name 'VerQueryValueA';

// Other API Declarations (Non Ansi/Unicode versions)

function  GetLastError(): DWORD; stdcall; external CKERNEL32 name 'GetLastError';
function  GetCurrentThreadId(): DWORD; stdcall; external CKERNEL32 name 'GetCurrentThreadId';
function  SetThreadPriority(hThread: HANDLE; nPriority: Integer): BOOL; stdcall; external CKERNEL32 name 'SetThreadPriority';
function  SuspendThread(hThread: HANDLE): DWORD; stdcall; external CKERNEL32 name 'SuspendThread';
function  ResumeThread(hThread: HANDLE): DWORD; stdcall; external CKERNEL32 name 'ResumeThread';
function  CloseHandle(hObject: HANDLE): BOOL; stdcall; external CKERNEL32 name 'CloseHandle';
function  SetEvent(hEvent: HANDLE): BOOL; stdcall; external CKERNEL32 name'SetEvent';
function  ResetEvent(hEvent: HANDLE): BOOL; stdcall; external CKERNEL32 name 'ResetEvent';
function  WaitForSingleObject(hHandle: HANDLE; dwMilliseconds: DWORD): DWORD; stdcall; external CKERNEL32 name 'WaitForSingleObject';
function  GetExitCodeThread(hThread: HANDLE; var lpExitCode: DWORD): BOOL; stdcall; external CKERNEL32 name 'GetExitCodeThread';
function  ReadFile(hFile: HANDLE; var Buffer; nNumberOfBytesToRead: DWORD; var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped): BOOL; stdcall; external CKERNEL32 name 'ReadFile';
function  WriteFile(hFile: HANDLE; const Buffer; nNumberOfBytesToWrite: DWORD; var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped): BOOL; stdcall; external CKERNEL32 name 'WriteFile';
function  SetFilePointer(hFile: HANDLE; lDistanceToMove: longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD): DWORD; stdcall; external CKERNEL32 name 'SetFilePointer';
function  SetEndOfFile(hFile: HANDLE): BOOL; stdcall; external CKERNEL32 name 'SetEndOfFile';
function  GetFileSize(hFile: HANDLE; var lpFileSizeHigh: DWORD): DWORD; stdcall; external CKERNEL32 name 'GetFileSize';
function  GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall; external CKERNEL32 name 'GetProcAddress'; // (No Ansi/Wide versions: GetProcAddress=GetProcAddressA)
procedure GetLocalTime(var lpSystemTime: TSystemTime); stdcall; external CKERNEL32 name 'GetLocalTime';
function  GetFileTime(hFile: HANDLE; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall; external CKERNEL32 name 'GetFileTime';
function  SetFileTime(hFile: HANDLE; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall; external CKERNEL32 name 'SetFileTime';
function  FileTimeToLocalFileTime(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime): BOOL; stdcall; external CKERNEL32 name 'FileTimeToLocalFileTime';
function  FileTimeToSystemTime(const lpFileTime: TFileTime; var lpSystemTime: TSystemTime): BOOL; stdcall; external CKERNEL32 name 'FileTimeToSystemTime';
function  FileTimeToDosDateTime(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word): BOOL; stdcall; external CKERNEL32 name 'FileTimeToDosDateTime';
function  LocalFileTimeToFileTime(const lpLocalFileTime: TFileTime; var lpFileTime: TFileTime): BOOL; stdcall; external CKERNEL32 name 'LocalFileTimeToFileTime';
function  SystemTimeToFileTime(const lpSystemTime: TSystemTime; var lpFileTime: TFileTime): BOOL; stdcall; external CKERNEL32 name 'SystemTimeToFileTime';
function  DosDateTimeToFileTime(wFatDate, wFatTime: Word; var lpFileTime: TFileTime): BOOL; stdcall; external CKERNEL32 name 'DosDateTimeToFileTime';
procedure Sleep(dwMilliseconds: DWORD); stdcall; external CKERNEL32 name 'Sleep';
function  SetErrorMode(uMode: UINT): UINT; stdcall; external CKERNEL32 name 'SetErrorMode';
function  FindClose(hFindFile: HANDLE): BOOL; stdcall; external CKERNEL32 name 'FindClose';
function  GetACP(): UINT; stdcall; external CKERNEL32 name 'GetACP';
function  GetOEMCP(): UINT; stdcall; external CKERNEL32 name 'GetOEMCP';
function  LoadResource(hModule: HINST; hResInfo: HRSRC): HGLOBAL; stdcall; external CKERNEL32 name 'LoadResource';
function  LockResource(hResData: HGLOBAL): pointer; stdcall; external CKERNEL32 name 'LockResource';
function  FreeResource(hResData: HGLOBAL): BOOL; stdcall; external CKERNEL32 name 'FreeResource';
function  TranslateMessage(const lpMsg: TMsg): BOOL; stdcall; external CUSER32 name 'TranslateMessage';
function  WaitMessage: BOOL; stdcall; external CUSER32 name 'WaitMessage';
procedure PostQuitMessage(nExitCode: Integer); stdcall; external CUSER32 name 'PostQuitMessage';
function  IsWindowVisible(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'IsWindowVisible';
function  ShowWindow(hWnd: HWND; nCmdShow: Integer): BOOL; stdcall; external CUSER32 name 'ShowWindow';
function  IsWindowEnabled(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'IsWindowEnabled';
function  EnableWindow(hWnd: HWND; bEnable: BOOL): BOOL; stdcall; external CUSER32 name 'EnableWindow';
function  DestroyWindow(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'DestroyWindow';
function  SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT): BOOL; stdcall; external CUSER32 name 'SetWindowPos';
function  MoveWindow(hWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL): BOOL; stdcall; external CUSER32 name 'MoveWindow';
function  GetActiveWindow: HWND; stdcall; external CUSER32 name 'GetActiveWindow';
function  SetActiveWindow(hWnd: HWND): HWND; stdcall; external CUSER32 name 'SetActiveWindow';
function  GetFocus: HWND; stdcall; external CUSER32 name 'GetFocus';
function  SetFocus(hWnd: HWND): HWND; stdcall; external CUSER32 name 'SetFocus';
function  GetForegroundWindow(): HWND; stdcall; external CUSER32 name 'GetForegroundWindow';
function  SetForegroundWindow(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'SetForegroundWindow';
function  GetKeyState(nVirtKey: Integer): SHORT; stdcall; external CUSER32 name 'GetKeyState';
function  GetCursorPos(var lpPoint: TPoint): BOOL; stdcall; external CUSER32 name 'GetCursorPos';
function  SetCursorPos(X, Y: Integer): BOOL; stdcall; external CUSER32 name 'SetCursorPos';
function  GetWindowRect(hWnd: HWND; var lpRect: TRect): BOOL; stdcall; external CUSER32 name 'GetWindowRect';
function  GetClientRect(hWnd: HWND; var lpRect: TRect): BOOL; stdcall; external CUSER32 name 'GetClientRect';
function  InvalidateRect(hWnd: HWND; lpRect: PRect; bErase: BOOL): BOOL; stdcall;  external CUSER32 name 'InvalidateRect';
function  FillRect(hDC: HDC; const lprc: TRect; hbr: HBRUSH): Integer; stdcall; external CUSER32 name 'FillRect';
function  RedrawWindow(hWnd: HWND; lprcUpdate: PRect; hrgnUpdate: HRGN; flags: UINT): BOOL; stdcall; external CUSER32 name 'RedrawWindow';
function  UpdateWindow(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'UpdateWindow';
function  GetDC(hWnd: HWND): HDC; stdcall; external CUSER32 name 'GetDC';
function  ReleaseDC(hWnd: HWND; hDC: HDC): Integer; stdcall; external CUSER32 name 'ReleaseDC';
function  BeginPaint(hWnd: HWND; var lpPaint: TPaintStruct): HDC; stdcall; external CUSER32 name 'BeginPaint';
function  EndPaint(hWnd: HWND; const lpPaint: TPaintStruct): BOOL; stdcall; external CUSER32 name 'EndPaint';
function  GetSystemMetrics(nIndex: Integer): Integer; stdcall; external CUSER32 name 'GetSystemMetrics';
function  GetComboBoxInfo(hwndCombo: HWND; var pcbi: TComboBoxInfo): BOOL; stdcall; external CUSER32 name 'GetComboBoxInfo';
function  SetTimer(hWnd: HWND; nIDEvent, uElapse: UINT; lpTimerFunc: TFNTimerProc): UINT; stdcall; external CUSER32 name 'SetTimer';
function  KillTimer(hWnd: HWND; uIDEvent: UINT): BOOL; stdcall; external CUSER32 name 'KillTimer';
function  CreateIconFromResource(presbits: PByte; dwResSize: DWORD; fIcon: BOOL; dwVer: DWORD): HICON; stdcall; external CUSER32 name 'CreateIconFromResource';
function  DestroyCursor(hCursor: HICON): BOOL; stdcall; external CUSER32 name 'DestroyCursor';
function  DestroyIcon(hIcon: HICON): BOOL; stdcall; external CUSER32 name 'DestroyIcon';
function  CreateMenu: HMENU; stdcall; external CUSER32 name 'CreateMenu';
function  CreatePopupMenu: HMENU; stdcall; external CUSER32 name 'CreatePopupMenu';
function  SetMenu(hWnd: HWND; hMenu: HMENU): BOOL; stdcall; external CUSER32 name 'SetMenu';
function  EnableMenuItem(hMenu: HMENU; uIDEnableItem: UINT; uEnable: UINT): BOOL; stdcall; external CUSER32 name 'EnableMenuItem';
function  CheckMenuItem(hMenu: HMENU; uIDCheckItem: UINT; uCheck: UINT): DWORD; stdcall; external CUSER32 name 'CheckMenuItem';
function  DrawMenuBar(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'DrawMenuBar';
function  TrackPopupMenu(hMenu: HMENU; uFlags: UINT; x: longint; y: longint; nReserved: longint; hWnd: HWND; const prcRect: PRect): BOOl; stdcall; external CUSER32 name 'TrackPopupMenu';
function  GetSystemMenu(hWnd: HWND; bRevert: BOOL): HMENU; stdcall; external CUSER32 name 'GetSystemMenu';
function  DeleteMenu(hMenu: HMENU; uPosition, uFlags: UINT): BOOL; stdcall; external CUSER32 name 'DeleteMenu';
function  DestroyMenu(hMenu: HMENU): BOOL; stdcall; external CUSER32 name 'DestroyMenu';
function  GetSysColor(nIndex: Integer): DWORD; stdcall; external CUSER32 name 'GetSysColor';
function  MessageBeep(uType: UINT): BOOL; stdcall; external CUSER32 name 'MessageBeep';
function  SetBkMode(DC: HDC; BkMode: Integer): Integer; stdcall; external CGDI32 name 'SetBkMode';
function  SetBkColor(DC: HDC; Color: COLORREF): COLORREF; stdcall; external CGDI32 name 'SetBkColor';
function  SelectObject(DC: HDC; p2: HGDIOBJ): HGDIOBJ; stdcall; external CGDI32 name 'SelectObject';
function  DeleteObject(p1: HGDIOBJ): BOOL; stdcall; external CGDI32 name 'DeleteObject';
function  CreatePen(Style, Width: Integer; Color: COLORREF): HPEN; stdcall; external CGDI32 name 'CreatePen';
function  CreateSolidBrush(p1: COLORREF): HBRUSH; stdcall; external CGDI32 name 'CreateSolidBrush';
function  Rectangle(DC: HDC; X1, Y1, X2, Y2: Integer): BOOL; stdcall; external CGDI32 name 'Rectangle';
function  ExcludeClipRect(DC: HDC; LeftRect, TopRect, RightRect, BottomRect: Integer): Integer; stdcall; external CGDI32 name 'ExcludeClipRect';
function  RectVisible(hDC: HDC; const lprc: TRect): BOOL; stdcall; external CGDI32 name 'RectVisible';
function  MoveToEx(DC: HDC; p2, p3: Integer; p4: PPoint): BOOL; stdcall; external CGDI32 name 'MoveToEx';
function  LineTo(DC: HDC; X, Y: Integer): BOOL; stdcall; external CGDI32 name 'LineTo';
function  SetTextColor(DC: HDC; Color: COLORREF): COLORREF; stdcall; external CGDI32 name 'SetTextColor';
function  SetStretchBltMode(DC: HDC; StretchMode: Integer): Integer; stdcall; external CGDI32 name 'SetStretchBltMode';
function  StretchDIBits(DC: HDC; DestX, DestY, DestWidth, DestHeight, SrcX, SrcY, SrcWidth, SrcHeight: Integer; Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: UINT; Rop: DWORD): Integer; stdcall; external CGDI32 name 'StretchDIBits';
function  SetDIBitsToDevice(DC: HDC; DestX, DestY: Integer; Width, Height: DWORD; SrcX, SrcY: Integer; nStartScan, NumScans: UINT; Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: UINT): Integer; stdcall; external CGDI32 name 'SetDIBitsToDevice';
procedure InitCommonControls(); stdcall; external CCOMCTL32 name 'InitCommonControls';

// API Functions mapping

function  LLCL_GetModuleHandle(lpModuleName: PChar): HMODULE;
function  LLCL_RegisterClass(const lpWndClass: TWndClass): ATOM;
function  LLCL_UnregisterClass(lpClassName: PChar; hInstance: HINST): BOOL;
function  LLCL_CreateWindowEx(dwExStyle: DWORD; lpClassName: PChar;
  lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer;
  hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;
function  LLCL_DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
function  LLCL_CallWindowProc(lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
function  LLCL_PeekMessage(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL;
function  LLCL_DispatchMessage(const lpMsg: TMsg): longint;
function  LLCL_SendMessage(hWnd: HWND; Msg: Cardinal; WParam: WPARAM; LParam: LPARAM): LRESULT;
function  LLCL_PostMessage(hWnd: HWND; Msg: Cardinal; WParam: WPARAM; LParam: LPARAM): LRESULT;
function  LLCL_GetWindowLong(hWnd: HWND; nIndex: Integer): longint;
function  LLCL_SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: longint): longint;
function  LLCL_GetClassLongPtr(hWnd: HWND; nIndex: Integer): NativeUInt;
function  LLCL_SetClassLongPtr(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt;
function  LLCL_GetWindowLongPtr(hWnd: HWND; nIndex: Integer): NativeUInt;
function  LLCL_SetWindowLongPtr(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt;
function  LLCL_DrawText(hDC: HDC; lpString: PChar; nCount: Integer; var lpRect: TRect; uFormat: UINT): Integer;
function  LLCL_LoadIcon(hInstance: HINST; lpIconName: PChar): HICON;
function  LLCL_LoadCursor(hInstance: HINST; lpCursorName: PChar): HCURSOR;
function  LLCL_SystemParametersInfo(uiAction, uiParam: UINT; pvParam: Pointer; fWinIni: UINT): BOOL;
function  LLCL_MessageBox(hWnd: HWND; lpText, lpCaption: PChar; uType: UINT): Integer;
function  LLCL_AppendMenu(hMenu: HMENU; uFlags, uIDNewItem: UINT; lpNewItem: PChar): BOOL;
function  LLCL_ModifyMenu(hMnu: HMENU; uPosition, uFlags, uIDNewItem: UINT; lpNewItem: PChar): BOOL;
function  LLCL_TextOut(DC: HDC; X, Y: Integer; lpString: PChar; Count: Integer): BOOL;
function  LLCL_ExtTextOut(DC: HDC; X, Y: Integer; Options: longint; Rect: PRect; Str: PChar; Count: longint; Dx: PInteger): BOOL;
function  LLCL_GetTextExtentPoint32(DC: HDC; Str: PChar; Count: Integer; var Size: TSize): BOOL;
function  LLCL_CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: DWORD; lpSecurityAttributes: LPSECURITY_ATTRIBUTES; dwCreationDisposition: DWORD; dwFlagsAndAttributes: DWORD; hTemplateFile: HANDLE; var LastOSError: DWORD): HANDLE;
function  LLCL_GetFileAttributes(lpFileName: PChar): DWORD;
function  LLCL_GetFileAttributesEx(lpFileName: PChar; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer; var LastOSError: DWORD): BOOL;
function  LLCL_SetCurrentDirectory(lpPathName: PChar): BOOL;
function  LLCL_CreateDirectory(lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes): BOOL;
function  LLCL_RemoveDirectory(lpPathName: PChar): BOOL;
function  LLCL_FindResource(hModule: HMODULE; lpName, lpType: PChar): HRSRC;
function  LLCL_CompareStringA(Locale: LCID; dwCmpFlags: DWORD; lpString1: LPCSTR; cchCount1: Integer; lpString2: LPCSTR; cchCount2: Integer): Integer;
function  LLCL_CharUpperBuffA(lpsz: LPCSTR; cchLength: DWORD): DWORD;
function  LLCL_CharLowerBuffA(lpsz: LPCSTR; cchLength: DWORD): DWORD;
function  LLCL_CompareStringW(Locale: LCID; dwCmpFlags: DWORD; lpString1: LPCWSTR; cchCount1: Integer; lpString2: LPCWSTR; cchCount2: Integer): Integer;
function  LLCL_CharUpperBuffW(lpsz: LPCWSTR; cchLength: DWORD): DWORD;
function  LLCL_CharLowerBuffW(lpsz: LPCWSTR; cchLength: DWORD): DWORD;
function  LLCL_GetFileVersionInfoSize(lptstrFilename: PChar; var lpdwHandle: DWORD): DWORD;
function  LLCL_GetFileVersionInfo(lptstrFilename: PChar; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL;
function  LLCL_VerQueryValue(pBlock: Pointer; lpSubBlock: PChar; var lplpBuffer: Pointer; var puLen: UINT): BOOL;
function  LLCL_LoadLibrary(lpLibFileName: PChar): HMODULE;
function  LLCL_CreateEvent(lpEventAttributes: LPSECURITY_ATTRIBUTES; bManualReset: BOOL; bInitialState: BOOL; lpName: PChar): HANDLE;

{$IFDEF LLCL_API_ALLMAPPING}
function  LLCL_GetLastError(): DWORD; stdcall;
function  LLCL_GetCurrentThreadId(): DWORD; stdcall;
function  LLCL_SetThreadPriority(hThread: HANDLE; nPriority: Integer): BOOL; stdcall;
function  LLCL_SuspendThread(hThread: HANDLE): DWORD; stdcall;
function  LLCL_ResumeThread(hThread: HANDLE): DWORD; stdcall;
function  LLCL_CloseHandle(hObject: HANDLE): BOOL; stdcall;
function  LLCL_SetEvent(hEvent: HANDLE): BOOL; stdcall;
function  LLCL_ResetEvent(hEvent: HANDLE): BOOL; stdcall;
function  LLCL_WaitForSingleObject(hHandle: HANDLE; dwMilliseconds: DWORD): DWORD; stdcall;
function  LLCL_GetExitCodeThread(hThread: HANDLE; var lpExitCode: DWORD): BOOL; stdcall;
function  LLCL_ReadFile(hFile: HANDLE; var Buffer; nNumberOfBytesToRead: DWORD; var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped): BOOL; stdcall;
function  LLCL_WriteFile(hFile: HANDLE; const Buffer; nNumberOfBytesToWrite: DWORD; var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped): BOOL; stdcall;
function  LLCL_SetFilePointer(hFile: HANDLE; lDistanceToMove: longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD): DWORD; stdcall;
function  LLCL_SetEndOfFile(hFile: HANDLE): BOOL; stdcall;
function  LLCL_GetFileSize(hFile: HANDLE; var lpFileSizeHigh: DWORD): DWORD; stdcall;
function  LLCL_GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
procedure LLCL_GetLocalTime(var lpSystemTime: TSystemTime); stdcall;
function  LLCL_GetFileTime(hFile: HANDLE; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall;
function  LLCL_SetFileTime(hFile: HANDLE; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall;
function  LLCL_FileTimeToLocalFileTime(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime): BOOL; stdcall;
function  LLCL_FileTimeToSystemTime(const lpFileTime: TFileTime; var lpSystemTime: TSystemTime): BOOL; stdcall;
function  LLCL_FileTimeToDosDateTime(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word): BOOL; stdcall;
function  LLCL_LocalFileTimeToFileTime(const lpLocalFileTime: TFileTime; var lpFileTime: TFileTime): BOOL; stdcall;
function  LLCL_SystemTimeToFileTime(const lpSystemTime: TSystemTime; var lpFileTime: TFileTime): BOOL; stdcall;
function  LLCL_DosDateTimeToFileTime(wFatDate, wFatTime: Word; var lpFileTime: TFileTime): BOOL; stdcall;
procedure LLCL_Sleep(dwMilliseconds: DWORD); stdcall;
function  LLCL_SetErrorMode(uMode: UINT): UINT; stdcall;
function  LLCL_FindClose(hFindFile: HANDLE): BOOL; stdcall;
function  LLCL_GetACP(): UINT; stdcall;
function  LLCL_GetOEMCP(): UINT; stdcall;
function  LLCL_LoadResource(hModule: HINST; hResInfo: HRSRC): HGLOBAL; stdcall;
function  LLCL_LockResource(hResData: HGLOBAL): pointer; stdcall;
function  LLCL_FreeResource(hResData: HGLOBAL): BOOL; stdcall;
function  LLCL_TranslateMessage(const lpMsg: TMsg): BOOL; stdcall;
function  LLCL_WaitMessage: BOOL; stdcall;
procedure LLCL_PostQuitMessage(nExitCode: Integer); stdcall;
function  LLCL_IsWindowVisible(hWnd: HWND): BOOL; stdcall;
function  LLCL_ShowWindow(hWnd: HWND; nCmdShow: Integer): BOOL; stdcall;
function  LLCL_IsWindowEnabled(hWnd: HWND): BOOL; stdcall;
function  LLCL_EnableWindow(hWnd: HWND; bEnable: BOOL): BOOL; stdcall;
function  LLCL_DestroyWindow(hWnd: HWND): BOOL; stdcall;
function  LLCL_SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT): BOOL; stdcall;
function  LLCL_MoveWindow(hWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL): BOOL; stdcall;
function  LLCL_GetActiveWindow: HWND; stdcall;
function  LLCL_SetActiveWindow(hWnd: HWND): HWND; stdcall;
function  LLCL_GetFocus: HWND; stdcall;
function  LLCL_SetFocus(hWnd: HWND): HWND; stdcall;
function  LLCL_GetForegroundWindow(): HWND; stdcall;
function  LLCL_SetForegroundWindow(hWnd: HWND): BOOL; stdcall;
function  LLCL_GetKeyState(nVirtKey: Integer): SHORT; stdcall;
function  LLCL_GetCursorPos(var lpPoint: TPoint): BOOL; stdcall;
function  LLCL_SetCursorPos(X, Y: Integer): BOOL; stdcall;
function  LLCL_GetWindowRect(hWnd: HWND; var lpRect: TRect): BOOL; stdcall;
function  LLCL_GetClientRect(hWnd: HWND; var lpRect: TRect): BOOL; stdcall;
function  LLCL_InvalidateRect(hWnd: HWND; lpRect: PRect; bErase: BOOL): BOOL; stdcall;
function  LLCL_FillRect(hDC: HDC; const lprc: TRect; hbr: HBRUSH): Integer; stdcall;
function  LLCL_RedrawWindow(hWnd: HWND; lprcUpdate: PRect; hrgnUpdate: HRGN; flags: UINT): BOOL; stdcall;
function  LLCL_UpdateWindow(hWnd: HWND): BOOL; stdcall;
function  LLCL_GetDC(hWnd: HWND): HDC; stdcall;
function  LLCL_ReleaseDC(hWnd: HWND; hDC: HDC): Integer; stdcall;
function  LLCL_BeginPaint(hWnd: HWND; var lpPaint: TPaintStruct): HDC; stdcall;
function  LLCL_EndPaint(hWnd: HWND; const lpPaint: TPaintStruct): BOOL; stdcall;
function  LLCL_GetSystemMetrics(nIndex: Integer): Integer; stdcall;
function  LLCL_GetComboBoxInfo(hwndCombo: HWND; var pcbi: TComboBoxInfo): BOOL; stdcall;
function  LLCL_SetTimer(hWnd: HWND; nIDEvent, uElapse: UINT; lpTimerFunc: TFNTimerProc): UINT; stdcall;
function  LLCL_KillTimer(hWnd: HWND; uIDEvent: UINT): BOOL; stdcall;
function  LLCL_CreateIconFromResource(presbits: PByte; dwResSize: DWORD; fIcon: BOOL; dwVer: DWORD): HICON; stdcall;
function  LLCL_DestroyCursor(hCursor: HICON): BOOL; stdcall;
function  LLCL_DestroyIcon(hIcon: HICON): BOOL; stdcall;
function  LLCL_CreateMenu: HMENU; stdcall;
function  LLCL_CreatePopupMenu: HMENU; stdcall;
function  LLCL_SetMenu(hWnd: HWND; hMenu: HMENU): BOOL; stdcall;
function  LLCL_EnableMenuItem(hMenu: HMENU; uIDEnableItem: UINT; uEnable: UINT): BOOL; stdcall;
function  LLCL_CheckMenuItem(hMenu: HMENU; uIDCheckItem: UINT; uCheck: UINT): DWORD; stdcall;
function  LLCL_DrawMenuBar(hWnd: HWND): BOOL; stdcall;
function  LLCL_TrackPopupMenu(hMenu: HMENU; uFlags: UINT; x: longint; y: longint; nReserved: longint; hWnd: HWND; const prcRect: PRect): BOOl; stdcall;
function  LLCL_GetSystemMenu(hWnd: HWND; bRevert: BOOL): HMENU; stdcall;
function  LLCL_DeleteMenu(hMenu: HMENU; uPosition, uFlags: UINT): BOOL; stdcall;
function  LLCL_DestroyMenu(hMenu: HMENU): BOOL; stdcall;
function  LLCL_GetSysColor(nIndex: Integer): DWORD; stdcall;
function  LLCL_MessageBeep(uType: UINT): BOOL; stdcall;
function  LLCL_SetBkMode(DC: HDC; BkMode: Integer): Integer; stdcall;
function  LLCL_SetBkColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
function  LLCL_SelectObject(DC: HDC; p2: HGDIOBJ): HGDIOBJ; stdcall;
function  LLCL_DeleteObject(p1: HGDIOBJ): BOOL; stdcall;
function  LLCL_CreatePen(Style, Width: Integer; Color: COLORREF): HPEN; stdcall;
function  LLCL_CreateSolidBrush(p1: COLORREF): HBRUSH; stdcall;
function  LLCL_Rectangle(DC: HDC; X1, Y1, X2, Y2: Integer): BOOL; stdcall;
function  LLCL_ExcludeClipRect(DC: HDC; LeftRect, TopRect, RightRect, BottomRect: Integer): Integer; stdcall;
function  LLCL_RectVisible(hDC: HDC; const lprc: TRect): BOOL; stdcall;
function  LLCL_MoveToEx(DC: HDC; p2, p3: Integer; p4: PPoint): BOOL; stdcall;
function  LLCL_LineTo(DC: HDC; X, Y: Integer): BOOL; stdcall;
function  LLCL_SetTextColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
function  LLCL_SetStretchBltMode(DC: HDC; StretchMode: Integer): Integer; stdcall;
function  LLCL_StretchDIBits(DC: HDC; DestX, DestY, DestWidth, DestHeight, SrcX, SrcY, SrcWidth, SrcHeight: Integer; Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: UINT; Rop: DWORD): Integer; stdcall;
function  LLCL_SetDIBitsToDevice(DC: HDC; DestX, DestY: Integer; Width, Height: DWORD; SrcX, SrcY: Integer; nStartScan, NumScans: UINT; Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: UINT): Integer; stdcall;
procedure LLCL_InitCommonControls(); stdcall;
{$ELSE}
function  LLCL_GetLastError(): DWORD; stdcall; external CKERNEL32 name 'GetLastError';
function  LLCL_GetCurrentThreadId(): DWORD; stdcall; external CKERNEL32 name 'GetCurrentThreadId';
function  LLCL_SetThreadPriority(hThread: HANDLE; nPriority: Integer): BOOL; stdcall; external CKERNEL32 name 'SetThreadPriority';
function  LLCL_SuspendThread(hThread: HANDLE): DWORD; stdcall; external CKERNEL32 name 'SuspendThread';
function  LLCL_ResumeThread(hThread: HANDLE): DWORD; stdcall; external CKERNEL32 name 'ResumeThread';
function  LLCL_CloseHandle(hObject: HANDLE): BOOL; stdcall; external CKERNEL32 name 'CloseHandle';
function  LLCL_SetEvent(hEvent: HANDLE): BOOL; stdcall; external CKERNEL32 name 'SetEvent';
function  LLCL_ResetEvent(hEvent: HANDLE): BOOL; stdcall; external CKERNEL32 name 'ResetEvent';
function  LLCL_WaitForSingleObject(hHandle: HANDLE; dwMilliseconds: DWORD): DWORD; stdcall; external CKERNEL32 name 'WaitForSingleObject';
function  LLCL_GetExitCodeThread(hThread: HANDLE; var lpExitCode: DWORD): BOOL; stdcall; external CKERNEL32 name 'GetExitCodeThread';
function  LLCL_ReadFile(hFile: HANDLE; var Buffer; nNumberOfBytesToRead: DWORD; var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped): BOOL; stdcall; external CKERNEL32 name 'ReadFile';
function  LLCL_WriteFile(hFile: HANDLE; const Buffer; nNumberOfBytesToWrite: DWORD; var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped): BOOL; stdcall; external CKERNEL32 name 'WriteFile';
function  LLCL_SetFilePointer(hFile: HANDLE; lDistanceToMove: longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD): DWORD; stdcall; external CKERNEL32 name 'SetFilePointer';
function  LLCL_SetEndOfFile(hFile: HANDLE): BOOL; stdcall; external CKERNEL32 name 'SetEndOfFile';
function  LLCL_GetFileSize(hFile: HANDLE; var lpFileSizeHigh: DWORD): DWORD; stdcall; external CKERNEL32 name 'GetFileSize';
function  LLCL_GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall; external CKERNEL32 name 'GetProcAddress';
procedure LLCL_GetLocalTime(var lpSystemTime: TSystemTime); stdcall; external CKERNEL32 name 'GetLocalTime';
function  LLCL_GetFileTime(hFile: HANDLE; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall; external CKERNEL32 name 'GetFileTime';
function  LLCL_SetFileTime(hFile: HANDLE; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall; external CKERNEL32 name 'SetFileTime';
function  LLCL_FileTimeToLocalFileTime(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime): BOOL; stdcall; external CKERNEL32 name 'FileTimeToLocalFileTime';
function  LLCL_FileTimeToSystemTime(const lpFileTime: TFileTime; var lpSystemTime: TSystemTime): BOOL; stdcall; external CKERNEL32 name 'FileTimeToSystemTime';
function  LLCL_FileTimeToDosDateTime(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word): BOOL; stdcall; external CKERNEL32 name 'FileTimeToDosDateTime';
function  LLCL_LocalFileTimeToFileTime(const lpLocalFileTime: TFileTime; var lpFileTime: TFileTime): BOOL; stdcall; external CKERNEL32 name 'LocalFileTimeToFileTime';
function  LLCL_SystemTimeToFileTime(const lpSystemTime: TSystemTime; var lpFileTime: TFileTime): BOOL; stdcall; external CKERNEL32 name 'SystemTimeToFileTime';
function  LLCL_DosDateTimeToFileTime(wFatDate, wFatTime: Word; var lpFileTime: TFileTime): BOOL; stdcall; external CKERNEL32 name 'DosDateTimeToFileTime';
procedure LLCL_Sleep(dwMilliseconds: DWORD); stdcall; external CKERNEL32 name 'Sleep';
function  LLCL_SetErrorMode(uMode: UINT): UINT; stdcall; external CKERNEL32 name 'SetErrorMode';
function  LLCL_FindClose(hFindFile: HANDLE): BOOL; stdcall; external CKERNEL32 name 'FindClose';
function  LLCL_GetACP(): UINT; stdcall; external CKERNEL32 name 'GetACP';
function  LLCL_GetOEMCP(): UINT; stdcall; external CKERNEL32 name 'GetOEMCP';
function  LLCL_LoadResource(hModule: HINST; hResInfo: HRSRC): HGLOBAL; stdcall; external CKERNEL32 name 'LoadResource';
function  LLCL_LockResource(hResData: HGLOBAL): pointer; stdcall; external CKERNEL32 name 'LockResource';
function  LLCL_FreeResource(hResData: HGLOBAL): BOOL; stdcall; external CKERNEL32 name 'FreeResource';
function  LLCL_TranslateMessage(const lpMsg: TMsg): BOOL; stdcall; external CUSER32 name 'TranslateMessage';
function  LLCL_WaitMessage: BOOL; stdcall; external CUSER32 name 'WaitMessage';
procedure LLCL_PostQuitMessage(nExitCode: Integer); stdcall; external CUSER32 name 'PostQuitMessage';
function  LLCL_IsWindowVisible(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'IsWindowVisible';
function  LLCL_ShowWindow(hWnd: HWND; nCmdShow: Integer): BOOL; stdcall; external CUSER32 name 'ShowWindow';
function  LLCL_IsWindowEnabled(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'IsWindowEnabled';
function  LLCL_EnableWindow(hWnd: HWND; bEnable: BOOL): BOOL; stdcall; external CUSER32 name 'EnableWindow';
function  LLCL_DestroyWindow(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'DestroyWindow';
function  LLCL_SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT): BOOL; stdcall; external CUSER32 name 'SetWindowPos';
function  LLCL_MoveWindow(hWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL): BOOL; stdcall; external CUSER32 name 'MoveWindow';
function  LLCL_GetActiveWindow: HWND; stdcall; external CUSER32 name 'GetActiveWindow';
function  LLCL_SetActiveWindow(hWnd: HWND): HWND; stdcall; external CUSER32 name 'SetActiveWindow';
function  LLCL_GetFocus: HWND; stdcall; external CUSER32 name 'GetFocus';
function  LLCL_SetFocus(hWnd: HWND): HWND; stdcall; external CUSER32 name 'SetFocus';
function  LLCL_GetForegroundWindow(): HWND; stdcall; external CUSER32 name 'GetForegroundWindow';
function  LLCL_SetForegroundWindow(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'SetForegroundWindow';
function  LLCL_GetKeyState(nVirtKey: Integer): SHORT; stdcall; external CUSER32 name 'GetKeyState';
function  LLCL_GetCursorPos(var lpPoint: TPoint): BOOL; stdcall; external CUSER32 name 'GetCursorPos';
function  LLCL_SetCursorPos(X, Y: Integer): BOOL; stdcall; external CUSER32 name 'SetCursorPos';
function  LLCL_GetWindowRect(hWnd: HWND; var lpRect: TRect): BOOL; stdcall; external CUSER32 name 'GetWindowRect';
function  LLCL_GetClientRect(hWnd: HWND; var lpRect: TRect): BOOL; stdcall; external CUSER32 name 'GetClientRect';
function  LLCL_InvalidateRect(hWnd: HWND; lpRect: PRect; bErase: BOOL): BOOL; stdcall;  external CUSER32 name 'InvalidateRect';
function  LLCL_FillRect(hDC: HDC; const lprc: TRect; hbr: HBRUSH): Integer; stdcall; external CUSER32 name 'FillRect';
function  LLCL_RedrawWindow(hWnd: HWND; lprcUpdate: PRect; hrgnUpdate: HRGN; flags: UINT): BOOL; stdcall; external CUSER32 name 'RedrawWindow';
function  LLCL_UpdateWindow(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'UpdateWindow';
function  LLCL_GetDC(hWnd: HWND): HDC; stdcall; external CUSER32 name 'GetDC';
function  LLCL_ReleaseDC(hWnd: HWND; hDC: HDC): Integer; stdcall; external CUSER32 name 'ReleaseDC';
function  LLCL_BeginPaint(hWnd: HWND; var lpPaint: TPaintStruct): HDC; stdcall; external CUSER32 name 'BeginPaint';
function  LLCL_EndPaint(hWnd: HWND; const lpPaint: TPaintStruct): BOOL; stdcall; external CUSER32 name 'EndPaint';
function  LLCL_GetSystemMetrics(nIndex: Integer): Integer; stdcall; external CUSER32 name 'GetSystemMetrics';
function  LLCL_GetComboBoxInfo(hwndCombo: HWND; var pcbi: TComboBoxInfo): BOOL; stdcall; external CUSER32 name 'GetComboBoxInfo';
function  LLCL_SetTimer(hWnd: HWND; nIDEvent, uElapse: UINT; lpTimerFunc: TFNTimerProc): UINT; stdcall; external CUSER32 name 'SetTimer';
function  LLCL_KillTimer(hWnd: HWND; uIDEvent: UINT): BOOL; stdcall; external CUSER32 name 'KillTimer';
function  LLCL_CreateIconFromResource(presbits: PByte; dwResSize: DWORD; fIcon: BOOL; dwVer: DWORD): HICON; stdcall; external CUSER32 name 'CreateIconFromResource';
function  LLCL_DestroyCursor(hCursor: HICON): BOOL; stdcall; external CUSER32 name 'DestroyCursor';
function  LLCL_DestroyIcon(hIcon: HICON): BOOL; stdcall; external CUSER32 name 'DestroyIcon';
function  LLCL_CreateMenu: HMENU; stdcall; external CUSER32 name 'CreateMenu';
function  LLCL_CreatePopupMenu: HMENU; stdcall; external CUSER32 name 'CreatePopupMenu';
function  LLCL_SetMenu(hWnd: HWND; hMenu: HMENU): BOOL; stdcall; external CUSER32 name 'SetMenu';
function  LLCL_EnableMenuItem(hMenu: HMENU; uIDEnableItem: UINT; uEnable: UINT): BOOL; stdcall; external CUSER32 name 'EnableMenuItem';
function  LLCL_CheckMenuItem(hMenu: HMENU; uIDCheckItem: UINT; uCheck: UINT): DWORD; stdcall; external CUSER32 name 'CheckMenuItem';
function  LLCL_DrawMenuBar(hWnd: HWND): BOOL; stdcall; external CUSER32 name 'DrawMenuBar';
function  LLCL_TrackPopupMenu(hMenu: HMENU; uFlags: UINT; x: longint; y: longint; nReserved: longint; hWnd: HWND; const prcRect: PRect): BOOl; stdcall; external CUSER32 name 'TrackPopupMenu';
function  LLCL_GetSystemMenu(hWnd: HWND; bRevert: BOOL): HMENU; stdcall; external CUSER32 name 'GetSystemMenu';
function  LLCL_DeleteMenu(hMenu: HMENU; uPosition, uFlags: UINT): BOOL; stdcall; external CUSER32 name 'DeleteMenu';
function  LLCL_DestroyMenu(hMenu: HMENU): BOOL; stdcall; external CUSER32 name 'DestroyMenu';
function  LLCL_GetSysColor(nIndex: Integer): DWORD; stdcall; external CUSER32 name 'GetSysColor';
function  LLCL_MessageBeep(uType: UINT): BOOL; stdcall; external CUSER32 name 'MessageBeep';
function  LLCL_SetBkMode(DC: HDC; BkMode: Integer): Integer; stdcall; external CGDI32 name 'SetBkMode';
function  LLCL_SetBkColor(DC: HDC; Color: COLORREF): COLORREF; stdcall; external CGDI32 name 'SetBkColor';
function  LLCL_SelectObject(DC: HDC; p2: HGDIOBJ): HGDIOBJ; stdcall; external CGDI32 name 'SelectObject';
function  LLCL_DeleteObject(p1: HGDIOBJ): BOOL; stdcall; external CGDI32 name 'DeleteObject';
function  LLCL_CreatePen(Style, Width: Integer; Color: COLORREF): HPEN; stdcall; external CGDI32 name 'CreatePen';
function  LLCL_CreateSolidBrush(p1: COLORREF): HBRUSH; stdcall; external CGDI32 name 'CreateSolidBrush';
function  LLCL_Rectangle(DC: HDC; X1, Y1, X2, Y2: Integer): BOOL; stdcall; external CGDI32 name 'Rectangle';
function  LLCL_ExcludeClipRect(DC: HDC; LeftRect, TopRect, RightRect, BottomRect: Integer): Integer; stdcall; external CGDI32 name 'ExcludeClipRect';
function  LLCL_RectVisible(hDC: HDC; const lprc: TRect): BOOL; stdcall; external CGDI32 name 'RectVisible';
function  LLCL_MoveToEx(DC: HDC; p2, p3: Integer; p4: PPoint): BOOL; stdcall; external CGDI32 name 'MoveToEx';
function  LLCL_LineTo(DC: HDC; X, Y: Integer): BOOL; stdcall; external CGDI32 name 'LineTo';
function  LLCL_SetTextColor(DC: HDC; Color: COLORREF): COLORREF; stdcall; external CGDI32 name 'SetTextColor';
function  LLCL_SetStretchBltMode(DC: HDC; StretchMode: Integer): Integer; stdcall; external CGDI32 name 'SetStretchBltMode';
function  LLCL_StretchDIBits(DC: HDC; DestX, DestY, DestWidth, DestHeight, SrcX, SrcY, SrcWidth, SrcHeight: Integer; Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: UINT; Rop: DWORD): Integer; stdcall; external CGDI32 name 'StretchDIBits';
function  LLCL_SetDIBitsToDevice(DC: HDC; DestX, DestY: Integer; Width, Height: DWORD; SrcX, SrcY: Integer; nStartScan, NumScans: UINT; Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: UINT): Integer; stdcall; external CGDI32 name 'SetDIBitsToDevice';
procedure LLCL_InitCommonControls(); stdcall; external CCOMCTL32 name 'InitCommonControls';
{$ENDIF}

{$IFDEF LLCL_FPC_ANSISYS}
// Ansi APIs without any transformations (for FPC SysUtils only)
//   (Not sensible to LLCL_UNICODE_API_xxxx)
function  LLCLSys_CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: DWORD; lpSecurityAttributes: LPSECURITY_ATTRIBUTES; dwCreationDisposition: DWORD; dwFlagsAndAttributes: DWORD; hTemplateFile: HANDLE; var LastOSError: DWORD): HANDLE;
function  LLCLSys_FindFirstNextFile(sFileName: string; hFindFile: HANDLE; var lpFindFileData: TCustomWin32FindData; var OutFileName: string; var LastOSError: DWORD): HANDLE;
function  LLCLSys_GetFileAttributes(lpFileName: PChar): DWORD;
function  LLCLSys_GetFileAttributesEx(lpFileName: PChar; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer; var LastOSError: DWORD): BOOL;
function  LLCLSys_CreateDirectory(lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes): BOOL;
function  LLCLSys_RemoveDirectory(lpPathName: PChar): BOOL;
function  LLCLSys_GetModuleFileName(hModule: HINST): string;
function  LLCLSys_GetFullPathName(const sFileName: string): string;
function  LLCLSys_GetDiskSpace(const sDrive: string; var TotalSpace, FreeSpaceAvailable: int64): BOOL;
function  LLCLSys_FormatMessage(dwFlags: DWORD; lpSource: Pointer; dwMessageId: DWORD; dwLanguageId: DWORD; Arguments: Pointer): string;
function  LLCLSys_GetFileVersionInfoSize(lptstrFilename: PChar; var lpdwHandle: DWORD): DWORD;
function  LLCLSys_GetFileVersionInfo(lptstrFilename: PChar; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL;
function  LLCLSys_VerQueryValue(pBlock: Pointer; lpSubBlock: PChar; var lplpBuffer: Pointer; var puLen: UINT): BOOL;
function  LLCLSys_LoadLibrary(lpLibFileName: PChar): HMODULE;
//
function  LLCLSys_CompareString(Locale: LCID; dwCmpFlags: DWORD; String1: string; cchCount1: Integer; String2: string; cchCount2: Integer): Integer;
function  LLCLSys_CharUpperBuff(const sText: string): string;
function  LLCLSys_CharLowerBuff(const sText: string): string;
{$ENDIF}
{$IFDEF LLCL_FPC_UNISYS}
// Unicode APIs without any transformations (for FPC SysUtils only)
//   (Not sensible to LLCL_UNICODE_API_xxxx)
function  LLCLSys_CreateFile(lpFileName: PUnicodeChar; dwDesiredAccess, dwShareMode: DWORD; lpSecurityAttributes: LPSECURITY_ATTRIBUTES; dwCreationDisposition: DWORD; dwFlagsAndAttributes: DWORD; hTemplateFile: HANDLE; var LastOSError: DWORD): HANDLE;
function  LLCLSys_FindFirstNextFile(sFileName: unicodestring; hFindFile: HANDLE; var lpFindFileData: TCustomWin32FindData; var OutFileName: unicodestring; var LastOSError: DWORD): HANDLE;
function  LLCLSys_GetFileAttributes(lpFileName: PUnicodeChar): DWORD;
function  LLCLSys_GetFileAttributesEx(lpFileName: PUnicodeChar; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer; var LastOSError: DWORD): BOOL;
function  LLCLSys_CreateDirectory(lpPathName: PUnicodeChar; lpSecurityAttributes: PSecurityAttributes): BOOL;
function  LLCLSys_RemoveDirectory(lpPathName: PUnicodeChar): BOOL;
function  LLCLSys_GetModuleFileName(hModule: HINST): unicodestring;
function  LLCLSys_GetFullPathName(const sFileName: unicodestring): unicodestring;
function  LLCLSys_GetDiskSpace(const sDrive: unicodestring; var TotalSpace, FreeSpaceAvailable: int64): BOOL;
function  LLCLSys_FormatMessage(dwFlags: DWORD; lpSource: Pointer; dwMessageId: DWORD; dwLanguageId: DWORD; Arguments: Pointer): unicodestring;
function  LLCLSys_GetFileVersionInfoSize(lptstrFilename: PUnicodeChar; var lpdwHandle: DWORD): DWORD;
function  LLCLSys_GetFileVersionInfo(lptstrFilename: PUnicodeChar; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL;
function  LLCLSys_VerQueryValue(pBlock: Pointer; lpSubBlock: PUnicodeChar; var lplpBuffer: Pointer; var puLen: UINT): BOOL;
function  LLCLSys_LoadLibrary(lpLibFileName: PUnicodeChar): HMODULE;
// (string instead of unicodestring)
function  LLCLSys_CompareString(Locale: LCID; dwCmpFlags: DWORD; String1: string; cchCount1: Integer; String2: string; cchCount2: Integer): Integer;
function  LLCLSys_CharUpperBuff(const sText: string): string;
function  LLCLSys_CharLowerBuff(const sText: string): string;
{$ENDIF}

function  LLCL_UnlockResource(hResData: THandle): BOOL; stdcall;

// Specific functions, and functions that cannot be directly mapped

procedure LLCLS_GetOSVersionA(var aPlatform, aMajorVersion, aMinorVersion, aBuildNumber: integer; var aCSDVersion: string);
procedure LLCLS_Init(aPlatForm: integer);
function  LLCLS_InitCommonControl(CC: integer): BOOL;
function  LLCLS_GetModuleFileName(hModule: HINST): string;
function  LLCLS_SetProcessDefaultLayout(dwDefaultLayout: DWORD): BOOL;
function  LLCLS_GetNonClientMetrics(var NonClientMetrics: TCustomNonClientMetrics): BOOL;
function  LLCLS_CreateFontIndirect(const lpLogFont: TCustomLogFont; const sName: string): HFONT;
function  LLCLS_SendMessageSetText(hWnd: HWND; Msg: Cardinal; const sText: string): LRESULT;
function  LLCLS_SendMessageGetText(hWnd: HWND): string;
function  LLCLS_CompareString(Locale: LCID; dwCmpFlags: DWORD; String1: string; cchCount1: Integer; String2: string; cchCount2: Integer): Integer;
function  LLCLS_CharUpperBuff(const sText: string): string;
function  LLCLS_CharLowerBuff(const sText: string): string;
function  LLCLS_Shell_NotifyIcon(dwMessage: DWORD; lpData: PCustomNotifyIconData; UseExtStruct: boolean; const sTip: string): BOOL;
function  LLCLS_Shell_NotifyIconBalloon(dwMessage: DWORD; lpData: PCustomNotifyIconData; UseExtStruct: boolean; InfoFlags: DWORD; const Timeout: UINT; const sInfoTitle: string; const sInfo: string): BOOL;
function  LLCLS_GetOpenSaveFileName(var OpenFile: TOpenFilename; OpenSave: integer; var OpenStrParam: TOpenStrParam): BOOL;
function  LLCLS_FindFirstNextFile(sFileName: string; hFindFile: HANDLE; var lpFindFileData: TCustomWin32FindData; var OutFileName: string; var LastOSError: DWORD): HANDLE;
function  LLCLS_GetCurrentDirectory(): string;
function  LLCLS_GetFullPathName(const sFileName: string): string;
function  LLCLS_GetDiskSpace(const sDrive: string; var TotalSpace, FreeSpaceAvailable: int64): BOOL;
function  LLCLS_FormatMessage(dwFlags: DWORD; lpSource: Pointer; dwMessageId: DWORD; dwLanguageId: DWORD; Arguments: Pointer): string;
function  LLCLS_StringToOem(const sText: string): ansistring;
function  LLCLS_GetTextSize(hWnd: HWND; const sText: string; FontHandle: THandle; var Size: TSize): BOOL;
function  LLCLS_IsAccel(VK: word; const Str: string): BOOL;
function  LLCLS_CharCodeToChar(const CharCode: word): Char;
function  LLCLS_FormUTF8ToString(const S: utf8string): string;
function  LLCLS_FormStringToString(const S: ansistring): string;

{$IFDEF FPC}
{$IFDEF UNICODE}
function  LLCLS_UTF8ToSys(const S: utf8string): ansistring;
function  LLCLS_SysToUTF8(const S: ansistring): utf8string;
function  LLCLS_UTF8ToWinCP(const S: utf8string): ansistring;
function  LLCLS_WinCPToUTF8(const S: ansistring): utf8string;
{$ELSE UNICODE}
function  LLCLS_UTF8ToSys(const S: string): string;
function  LLCLS_SysToUTF8(const S: string): string;
function  LLCLS_UTF8ToWinCP(const S: string): string;
function  LLCLS_WinCPToUTF8(const S: string): string;
{$ENDIF UNICODE}
{$ENDIF}

var
  UnicodeEnabledOS:   boolean = false;    // (Could also be used with Delphi - not standard)

//------------------------------------------------------------------------------

implementation

{$IFDEF FPC}
  {$PUSH} {$HINTS OFF}
{$ENDIF}

// Other functions/procedures used only here
{$IFDEF LLCL_UNICODE_API_W}
function  LLCLS_FFNF_W(lpFileName: PChar; hFindFile: HANDLE; var lpFindFileData: TWin32FindDataW; var OutFileName: string; var ResFunc: HANDLE; var LastOSError: DWORD): boolean; forward;
{$ENDIF}
function  LLCLS_FFNF_A(lpFileName: PChar; hFindFile: HANDLE; var lpFindFileData: TWin32FindDataA; var OutFileName: string; var ResFunc: HANDLE; var LastOSError: DWORD): boolean; forward;
procedure LLCLS_FFNF_AToW(const aWin32FindData: TWin32FindDataA; var wWin32FindData: TWin32FindDataW); forward;
procedure LLCLS_FFNF_WToA(const wWin32FindData: TWin32FindDataW; var aWin32FindData: TWin32FindDataA); forward;
{$IFDEF LLCL_FPC_UNISYS}
function  LLCLS_FFNF_WW(lpFileName: PUnicodeChar; hFindFile: HANDLE; var lpFindFileData: TWin32FindDataW; var OutFileName: unicodestring; var ResFunc: HANDLE; var LastOSError: DWORD): boolean; forward;
{$ENDIF}

function  StrToTextDispA(const S: string): ansistring; forward;
function  StrToTextDispW(const S: string): unicodestring; forward;
function  StrFromTextDispA(const S: ansistring): string; forward;
function  StrFromTextDispW(const S: unicodestring): string; forward;
function  PointerToNativeUInt(p: Pointer): NativeUInt; forward;
procedure StrLCopyA(var Dest: array of AnsiChar; const Source: ansistring; MaxLen: cardinal); forward;
procedure StrLCopyW(var Dest: array of WideChar; const Source: unicodestring; MaxLen: cardinal); forward;

function  ValAccelStr(const Str: string): word; forward;

{$IFDEF LLCL_FPC_UTF8RTL}     // (FPC only)
procedure CallInit(); forward;

var InitDone: boolean = false;
{$ENDIF}

//------------------------------------------------------------------------------

function LLCL_GetModuleHandle(lpModuleName: PChar): HMODULE;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(lpModuleName);
      result := GetModuleHandleW(@wStr[1]);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
  begin
    aStr := StrToTextDispA(lpModuleName);
    result := GetModuleHandleA(@aStr[1]);
    end;
{$ENDIF}
end;

function LLCL_RegisterClass(const lpWndClass: TWndClass): ATOM;
{$IFDEF LLCL_UNICODE_API_W}
var lpWndClassW: TWndClassW;
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var lpWndClassA: TWndClassA;
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      Move(lpWndClass, lpWndClassW, SizeOf(lpWndClassW));   // All versions have same size
      wStr := StrToTextDispW(lpWndClass.lpszClassName);
      lpWndClassW.lpszClassName := @wStr[1];
      result := RegisterClassW(lpWndClassW);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      Move(lpWndClass, lpWndClassA, SizeOf(lpWndClassA));   // All versions have same size
      aStr := StrToTextDispA(lpWndClass.lpszClassName);
      lpWndClassA.lpszClassName := @aStr[1];
      result := RegisterClassA(lpWndClassA);
    end;
{$ENDIF}
end;

function LLCL_UnregisterClass(lpClassName: PChar; hInstance: HINST): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(lpClassName);
      result := UnregisterClassW(@wStr[1], hInstance);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      aStr := StrToTextDispA(lpClassName);
      result := UnregisterClassA(@aStr[1], hInstance);
    end;
{$ENDIF}
end;

function LLCL_CreateWindowEx(dwExStyle: DWORD; lpClassName: PChar;
  lpWindowName: PChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer;
  hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;
{$IFDEF LLCL_UNICODE_API_W}
var wClassName, wWindowName: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aClassName, aWindowName: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wClassName := StrToTextDispW(lpClassName);
      wWindowName := StrToTextDispW(lpWindowName);
      result := CreateWindowExW(dwExStyle, @wClassName[1], @wWindowName[1],
        dwStyle, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      aClassName := StrToTextDispA(lpClassName);
      aWindowName := StrToTextDispA(lpWindowName);
      result := CreateWindowExA(dwExStyle, @aClassName[1], @aWindowName[1],
        dwStyle, X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
    end;
{$ENDIF}
end;

// Stdcall required here
function LLCL_DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := DefWindowProcW(hWnd, Msg, wParam, lParam)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    result := DefWindowProcA(hWnd, Msg, wParam, lParam);
{$ENDIF}
end;

function LLCL_CallWindowProc(lpPrevWndFunc: TFNWndProc; hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := CallWindowProcW({$IFDEF LLCL_OBJFPC_MODE}WNDPROC(lpPrevWndFunc){$ELSE}lpPrevWndFunc{$ENDIF}, hWnd, Msg, wParam, lParam)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    result := CallWindowProcA({$IFDEF LLCL_OBJFPC_MODE}WNDPROC(lpPrevWndFunc){$ELSE}lpPrevWndFunc{$ENDIF}, hWnd, Msg, wParam, lParam);
{$ENDIF}
end;

function LLCL_PeekMessage(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := PeekMessageW(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax, wRemoveMsg)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    result := PeekMessageA(lpMsg, hWnd, wMsgFilterMin, wMsgFilterMax, wRemoveMsg);
{$ENDIF}
end;

function LLCL_DispatchMessage(const lpMsg: TMsg): longint;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := DispatchMessageW(lpMsg)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    result := DispatchMessageA(lpMsg);
{$ENDIF}
end;

function LLCL_SendMessage(hWnd: HWND; Msg: Cardinal; WParam: WPARAM; LParam: LPARAM): LRESULT;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := SendMessageW(hWnd, Msg, WParam, LParam)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    result := SendMessageA(hWnd, Msg, WParam, LParam);
{$ENDIF}
end;

function LLCL_PostMessage(hWnd: HWND; Msg: Cardinal; WParam: WPARAM; LParam: LPARAM): LRESULT;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := longint(PostMessageW(hWnd, Msg, WParam, LParam))
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    result := longint(PostMessageA(hWnd, Msg, WParam, LParam));
{$ENDIF}
end;

function LLCL_GetWindowLong(hWnd: HWND; nIndex: Integer): longint;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := GetWindowLongW(hWnd, nIndex)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    result := GetWindowLongA(hWnd, nIndex);
{$ENDIF}
end;

function LLCL_SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: longint): longint;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := SetWindowLongW(hWnd, nIndex, dwNewLong)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    result := SetWindowLongA(hWnd, nIndex, dwNewLong);
{$ENDIF}
end;

function LLCL_GetClassLongPtr(hWnd: HWND; nIndex: Integer): NativeUInt;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := GetClassLongPtrW(hWnd, nIndex)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    result := GetClassLongPtrA(hWnd, nIndex);
{$ENDIF}
end;

function LLCL_SetClassLongPtr(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := SetClassLongPtrW(hWnd, nIndex, dwNewLong)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    result := SetClassLongPtrA(hWnd, nIndex, dwNewLong);
{$ENDIF}
end;

function LLCL_GetWindowLongPtr(hWnd: HWND; nIndex: Integer): NativeUInt;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := GetWindowLongPtrW(hWnd, nIndex)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    result := GetWindowLongPtrA(hWnd, nIndex);
{$ENDIF}
end;

function LLCL_SetWindowLongPtr(hWnd: HWND; nIndex: Integer; dwNewLong: NativeUInt): NativeUInt;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := SetWindowLongPtrW(hWnd, nIndex, dwNewLong)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    result := SetWindowLongPtrA(hWnd, nIndex, dwNewLong);
{$ENDIF}
end;

function LLCL_DrawText(hDC: HDC; lpString: PChar; nCount: Integer; var lpRect: TRect; uFormat: UINT): Integer;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
var iCount: integer;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(lpString);
      if nCount=-1 then iCount := -1 else iCount := Length(wStr);
      result := DrawTextW(hDC, @wStr[1], iCount, lpRect, uFormat);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      aStr := StrToTextDispA(lpString);
      if nCount=-1 then iCount := -1 else iCount := Length(aStr);
      result := DrawTextA(hDC, @aStr[1], iCount, lpRect, uFormat);
    end;
{$ENDIF}
end;

function LLCL_LoadIcon(hInstance: HINST; lpIconName: PChar): HICON;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      if (PointerToNativeUInt(lpIconName) shr 16)<>0 then    // Highword(s) non null
        begin
          wStr := StrToTextDispW(lpIconName);
          result := LoadIconW(hInstance, @wStr[1]);
        end
      else
        result := LoadIconW(hInstance, Pointer(lpIconName));
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      if (PointerToNativeUInt(lpIconName) shr 16)<>0 then    // Highword(s) non null
        begin
          aStr := StrToTextDispA(lpIconName);
          result := LoadIconA(hInstance, @aStr[1]);
        end
      else
        result := LoadIconA(hInstance, Pointer(lpIconName));
    end;
{$ENDIF}
end;

function LLCL_LoadCursor(hInstance: HINST; lpCursorName: PChar): HCURSOR;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      if (PointerToNativeUInt(lpCursorName) shr 16)<>0 then    // Highword(s) non null
        begin
          wStr := StrToTextDispW(lpCursorName);
          result := LoadCursorW(hInstance, @wStr[1]);
        end
      else
        result := LoadCursorW(hInstance, Pointer(lPCursorName));
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      if (PointerToNativeUInt(lpCursorName) shr 16)<>0 then    // Highword(s) non null
        begin
          aStr := StrToTextDispA(lpCursorName);
          result := LoadCursorA(hInstance, @aStr[1]);
        end
      else
        result := LoadCursorA(hInstance, Pointer(lPCursorName));
    end;
{$ENDIF}
end;

function LLCL_SystemParametersInfo(uiAction, uiParam: UINT; pvParam: Pointer; fWinIni: UINT): BOOL;
begin
  // (pvParam must be of the corresponding Ansi/Wide type)
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := SystemParametersInfoW(uiAction, uiParam, pvParam, fWinIni)
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    result := SystemParametersInfoA(uiAction, uiParam, pvParam, fWinIni);
{$ENDIF}
end;

function LLCL_MessageBox(hWnd: HWND; lpText, lpCaption: PChar; uType: UINT): Integer;
{$IFDEF LLCL_UNICODE_API_W}
var wText, wCaption: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aText, aCaption: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wText := StrToTextDispW(lpText);
      wCaption := StrToTextDispW(lpCaption);
      result := MessageBoxW(hWnd, @wText[1], @wCaption[1], uType);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      aText := StrToTextDispA(lpText);
      aCaption := StrToTextDispA(lpCaption);
      result := MessageBoxA(hWnd, @aText[1], @aCaption[1], uType);
    end;
{$ENDIF}
end;

function LLCL_AppendMenu(hMenu: HMENU; uFlags, uIDNewItem: UINT; lpNewItem: PChar): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(lpNewItem);
      result := AppendMenuW(hMenu, uFlags, uIDNewItem, @wStr[1]);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      aStr := StrToTextDispA(lpNewItem);
      result := AppendMenuA(hMenu, uFlags, uIDNewItem, @aStr[1]);
    end;
{$ENDIF}
end;

function LLCL_ModifyMenu(hMnu: HMENU; uPosition, uFlags, uIDNewItem: UINT; lpNewItem: PChar): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(lpNewItem);
      result := ModifyMenuW(hMnu, uPosition, uFlags, uIDNewItem, @wStr[1]);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      aStr := StrToTextDispA(lpNewItem);
      result := ModifyMenuA(hMnu, uPosition, uFlags, uIDNewItem, @aStr[1]);
    end;
{$ENDIF}
end;

function LLCL_TextOut(DC: HDC; X, Y: Integer; lpString: PChar; Count: Integer): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
var iCount: integer;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(lpString);
      if Count=-1 then iCount := -1 else iCount := Length(wStr);
      result := TextOutW(DC, X, Y, @wStr[1], iCount);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      aStr := StrToTextDispA(lpString);
      if Count=-1 then iCount := -1 else iCount := Length(aStr);
      result := TextOutA(DC, X, Y, @aStr[1], iCount);
    end;
{$ENDIF}
end;

function LLCL_ExtTextOut(DC: HDC; X, Y: Integer; Options: longint; Rect: PRect; Str: PChar; Count: longint; Dx: PInteger): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
var iCount: integer;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(Str);
      if Count=-1 then iCount := -1 else iCount := Length(wStr);
      result := ExtTextOutW(DC, X, Y, Options, Rect, @wStr[1], iCount, Dx);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      aStr := StrToTextDispA(Str);
      if Count=-1 then iCount := -1 else iCount := Length(aStr);
      result := ExtTextOutA(DC, X, Y, Options, Rect, @aStr[1], iCount, Dx);
    end;
{$ENDIF}
end;

function LLCL_GetTextExtentPoint32(DC: HDC; Str: PChar; Count: Integer; var Size: TSize): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
var iCount: integer;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(Str);
      if Count=-1 then iCount := -1 else iCount := Length(wStr);
      result := GetTextExtentPoint32W(DC, @wStr[1], iCount, Size);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      aStr := StrToTextDispA(Str);
      if Count=-1 then iCount := -1 else iCount := Length(aStr);
      result := GetTextExtentPoint32A(DC, @aStr[1], iCount, Size);
    end;
{$ENDIF}
end;

function LLCL_CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: DWORD; lpSecurityAttributes: LPSECURITY_ATTRIBUTES; dwCreationDisposition: DWORD; dwFlagsAndAttributes: DWORD; hTemplateFile: HANDLE; var LastOSError: DWORD): HANDLE;
{$IFDEF LLCL_UNICODE_API_W}
var wFileName: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aFileName: ansistring;
{$ENDIF}
begin
  LastOSError := 0;
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wFileName := StrToTextDispW(lpFileName);
      result := CreateFileW(@wFileName[1], dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    begin
      result := INVALID_HANDLE_VALUE;
      LastOSError := ERROR_NOT_SUPPORTED;
      exit;
    end;
{$ELSE}
    begin
      aFileName := StrToTextDispA(lpFileName);
      result := CreateFileA(@aFileName[1], dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
    end;
{$ENDIF}
  if result = INVALID_HANDLE_VALUE then
    LastOSError := LLCL_GetLastError();
end;

function LLCL_GetFileAttributes(lpFileName: PChar): DWORD;
{$IFDEF LLCL_UNICODE_API_W}
var wFileName: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aFileName: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wFileName := StrToTextDispW(lpFileName);
      result := GetFileAttributesW(@wFileName[1]);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := DWORD(INVALID_FILE_ATTRIBUTES);
{$ELSE}
    begin
      aFileName := StrToTextDispA(lpFileName);
      result := GetFileAttributesA(@aFileName[1]);
    end;
{$ENDIF}
end;

function LLCL_GetFileAttributesEx(lpFileName: PChar; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer; var LastOSError: DWORD): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wFileName: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aFileName: ansistring;
{$ENDIF}
begin
  LastOSError := 0;
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wFileName := StrToTextDispW(lpFileName);
      result := GetFileAttributesExW(@wFileName[1], fInfoLevelId, lpFileInformation);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    begin
      result := false;
      LastOSError := ERROR_NOT_SUPPORTED;
      exit;
    end;
{$ELSE}
    begin
      aFileName := StrToTextDispA(lpFileName);
      result := GetFileAttributesExA(@aFileName[1], fInfoLevelId, lpFileInformation);
    end;
{$ENDIF}
  if not result then
    LastOSError := LLCL_GetLastError();
end;

function LLCL_SetCurrentDirectory(lpPathName: PChar): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wPathName: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aPathName: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wPathName := StrToTextDispW(lpPathName);
      result := SetCurrentDirectoryW(@wPathName[1]);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      aPathName := StrToTextDispA(lpPathName);
      result := SetCurrentDirectoryA(@aPathName[1]);
    end;
{$ENDIF}
end;

function LLCL_CreateDirectory(lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wPathName: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aPathName: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wPathName := StrToTextDispW(lpPathName);
      result := CreateDirectoryW(@wPathName[1], lpSecurityAttributes);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      aPathName := StrToTextDispA(lpPathName);
      result := CreateDirectoryA(@aPathName[1], lpSecurityAttributes);
    end;
{$ENDIF}
end;

function LLCL_RemoveDirectory(lpPathName: PChar): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wPathName: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aPathName: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wPathName := StrToTextDispW(lpPathName);
      result := RemoveDirectoryW(@wPathName[1]);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      aPathName := StrToTextDispA(lpPathName);
      result := RemoveDirectoryA(@aPathName[1]);
    end;
{$ENDIF}
end;

function  LLCL_FindResource(hModule: HMODULE; lpName, lpType: PChar): HRSRC;
{$IFDEF LLCL_UNICODE_API_W}
var wName, wType: unicodestring;
var lpwName, lpwType: PUnicodeChar;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aName, aType: ansistring;
var lpaName, lpaType: PAnsiChar;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      if (PointerToNativeUInt(lpName) shr 16)<>0 then    // Highword(s) non null
        begin
          wName := StrToTextDispW(lpName);
          lpwName := @wName[1];
        end
      else
        lpwName := PUnicodeChar(lpName);
      if (PointerToNativeUInt(lpType) shr 16)<>0 then    // Highword(s) non null
        begin
          wType := StrToTextDispW(lpType);
          lpwType := @wType[1];
        end
      else
        lpwType := PUnicodeChar(lpType);
      result := FindResourceW(hModule, lpwName, lpwType);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      if (PointerToNativeUInt(lpName) shr 16)<>0 then    // Highword(s) non null
        begin
          aName := StrToTextDispA(lpName);
          lpaName := @aName[1];
        end
      else
        lpaName := PAnsiChar(lpName);
      if (PointerToNativeUInt(lpType) shr 16)<>0 then    // Highword(s) non null
        begin
          aType := StrToTextDispA(lpType);
          lpaType := @aType[1];
        end
      else
        lpaType := PAnsiChar(lpType);
      result := FindResourceA(hModule, lpaName, lpaType);
    end;
{$ENDIF}
end;

function LLCL_CompareStringA(Locale: LCID; dwCmpFlags: DWORD; lpString1: LPCSTR; cchCount1: Integer; lpString2: LPCSTR; cchCount2: Integer): Integer;
begin
{$IFDEF LLCL_UNICODE_API_W_ONLY}
  result := 0;
{$ELSE}
  result := CompareStringA(Locale, dwCmpFlags, lpString1, cchCount1, lpString2, cchCount2);
{$ENDIF}
end;

function LLCL_CharUpperBuffA(lpsz: LPCSTR; cchLength: DWORD): DWORD;
begin
{$IFDEF LLCL_UNICODE_API_W_ONLY}
  result := 0;
{$ELSE}
  result := CharUpperBuffA(lpsz, cchLength);
{$ENDIF}
end;

function LLCL_CharLowerBuffA(lpsz: LPCSTR; cchLength: DWORD): DWORD;
begin
{$IFDEF LLCL_UNICODE_API_W_ONLY}
  result := 0;
{$ELSE}
  result := CharLowerBuffA(lpsz, cchLength);
{$ENDIF}
end;

function LLCL_CompareStringW(Locale: LCID; dwCmpFlags: DWORD; lpString1: LPCWSTR; cchCount1: Integer; lpString2: LPCWSTR; cchCount2: Integer): Integer;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := CompareStringW(Locale, dwCmpFlags, lpString1, cchCount1, lpString2, cchCount2)
  else
{$ENDIF}
    result := 0;
end;

function LLCL_CharUpperBuffW(lpsz: LPCWSTR; cchLength: DWORD): DWORD;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := CharUpperBuffW(lpsz, cchLength)
  else
{$ENDIF}
    result := 0;
end;

function LLCL_CharLowerBuffW(lpsz: LPCWSTR; cchLength: DWORD): DWORD;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := CharLowerBuffW(lpsz, cchLength)
  else
{$ENDIF}
    result := 0;
end;

function LLCL_GetFileVersionInfoSize(lptstrFilename: PChar; var lpdwHandle: DWORD): DWORD;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(lptstrFilename);
      result := GetFileVersionInfoSizeW(@wStr[1], lpdwHandle);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      aStr := StrToTextDispA(lptstrFilename);
      result := GetFileVersionInfoSizeA(@aStr[1], lpdwHandle);
    end;
{$ENDIF}
end;

function LLCL_GetFileVersionInfo(lptstrFilename: PChar; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(lptstrFilename);
      result := GetFileVersionInfoW(@wStr[1], dwHandle, dwLen, lpData);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      aStr := StrToTextDispA(lptstrFilename);
      result := GetFileVersionInfoA(@aStr[1], dwHandle, dwLen, lpData);
    end;
{$ENDIF}
end;

function LLCL_VerQueryValue(pBlock: Pointer; lpSubBlock: PChar; var lplpBuffer: Pointer; var puLen: UINT): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(lpSubBlock);
      result := VerQueryValueW(pBlock, @wStr[1], lplpBuffer, puLen);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      aStr := StrToTextDispA(lpSubBlock);
      result := VerQueryValueA(pBlock, @aStr[1], lplpBuffer, puLen);
    end;
{$ENDIF}
end;

function LLCL_LoadLibrary(lpLibFileName: PChar): HMODULE;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(lpLibFileName);
      result := LoadLibraryW(@wStr[1]);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      aStr := StrToTextDispA(lpLibFileName);
      result := LoadLibraryA(@aStr[1]);
    end;
{$ENDIF}
end;

function LLCL_CreateEvent(lpEventAttributes: LPSECURITY_ATTRIBUTES; bManualReset: BOOL; bInitialState: BOOL; lpName: PChar): HANDLE;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(lpName);
      result := CreateEventW(lpEventAttributes, bManualReset, bInitialState, @wStr[1]);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      aStr := StrToTextDispA(lpName);
      result := CreateEventA(lpEventAttributes, bManualReset, bInitialState, @aStr[1]);
    end;
{$ENDIF}
end;

//------------------------------------------------------------------------------

{$IFDEF LLCL_API_ALLMAPPING}
function LLCL_GetLastError(): DWORD; stdcall;
begin
  result := GetLastError();
end;

function LLCL_GetCurrentThreadId(): DWORD; stdcall;
begin
  result := GetCurrentThreadId();
end;

function LLCL_SetThreadPriority(hThread: HANDLE; nPriority: Integer): BOOL; stdcall;
begin
  result := SetThreadPriority(hThread, nPriority);
end;

function LLCL_SuspendThread(hThread: HANDLE): DWORD; stdcall;
begin
  result := SuspendThread(hThread);
end;

function LLCL_ResumeThread(hThread: HANDLE): DWORD; stdcall;
begin
  result := ResumeThread(hThread);
end;

function LLCL_SetEvent(hEvent: HANDLE): BOOL; stdcall;
begin
  result := SetEvent(hEvent);
end;

function LLCL_ResetEvent(hEvent: HANDLE): BOOL; stdcall;
begin
  result := ResetEvent(hEvent);
end;

function LLCL_CloseHandle(hObject: HANDLE): BOOL; stdcall;
begin
  result := CloseHandle(hObject);
end;

function LLCL_WaitForSingleObject(hHandle: HANDLE; dwMilliseconds: DWORD): DWORD; stdcall;
begin
  result := WaitForSingleObject(hHandle, dwMilliseconds);
end;

function LLCL_GetExitCodeThread(hThread: HANDLE; var lpExitCode: DWORD): BOOL; stdcall;
begin
  result := GetExitCodeThread(hThread, lpExitCode);
end;

function LLCL_ReadFile(hFile: HANDLE; var Buffer; nNumberOfBytesToRead: DWORD; var lpNumberOfBytesRead: DWORD; lpOverlapped: POverlapped): BOOL; stdcall;
begin
  result := ReadFile(hFile, Buffer, nNumberOfBytesToRead, lpNumberOfBytesRead, lpOverlapped);
end;

function LLCL_WriteFile(hFile: HANDLE; const Buffer; nNumberOfBytesToWrite: DWORD; var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped): BOOL; stdcall;
begin
  result := WriteFile(hFile, Buffer, nNumberOfBytesToWrite, lpNumberOfBytesWritten, lpOverlapped);
end;

function LLCL_SetFilePointer(hFile: HANDLE; lDistanceToMove: longint; lpDistanceToMoveHigh: Pointer; dwMoveMethod: DWORD): DWORD; stdcall;
begin
  result := SetFilePointer(hFile, lDistanceToMove, lpDistanceToMoveHigh, dwMoveMethod);
end;

function LLCL_SetEndOfFile(hFile: HANDLE): BOOL; stdcall;
begin
  result := SetEndOfFile(hFile);
end;

function LLCL_GetFileSize(hFile: HANDLE; var lpFileSizeHigh: DWORD): DWORD; stdcall;
begin
  result := GetFileSize(hFile, lpFileSizeHigh);
end;

function LLCL_GetProcAddress(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
begin
  result := GetProcAddress(hModule, lpProcName);
end;

procedure LLCL_GetLocalTime(var lpSystemTime: TSystemTime); stdcall;
begin
  GetLocalTime(lpSystemTime);
end;

function LLCL_GetFileTime(hFile: HANDLE; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall;
begin
  result := GetFileTime(hFile, lpCreationTime, lpLastAccessTime, lpLastWriteTime);
end;

function LLCL_SetFileTime(hFile: HANDLE; lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall;
begin
  result := SetFileTime(hFile, lpCreationTime, lpLastAccessTime, lpLastWriteTime);
end;

function LLCL_FileTimeToLocalFileTime(const lpFileTime: TFileTime; var lpLocalFileTime: TFileTime): BOOL; stdcall;
begin
  result := FileTimeToLocalFileTime(lpFileTime, lpLocalFileTime);
end;

function LLCL_FileTimeToSystemTime(const lpFileTime: TFileTime; var lpSystemTime: TSystemTime): BOOL; stdcall;
begin
  result := FileTimeToSystemTime(lpFileTime, lpSystemTime);
end;

function LLCL_FileTimeToDosDateTime(const lpFileTime: TFileTime; var lpFatDate, lpFatTime: Word): BOOL; stdcall;
begin
  result := FileTimeToDosDateTime(lpFileTime, lpFatDate, lpFatTime);
end;

function LLCL_LocalFileTimeToFileTime(const lpLocalFileTime: TFileTime; var lpFileTime: TFileTime): BOOL; stdcall;
begin
  result := LocalFileTimeToFileTime(lpLocalFileTime, lpFileTime);
end;

function LLCL_SystemTimeToFileTime(const lpSystemTime: TSystemTime; var lpFileTime: TFileTime): BOOL; stdcall;
begin
  result := SystemTimeToFileTime(lpSystemTime, lpFileTime);
end;

function LLCL_DosDateTimeToFileTime(wFatDate, wFatTime: Word; var lpFileTime: TFileTime): BOOL; stdcall;
begin
  result := DosDateTimeToFileTime(wFatDate, wFatTime, lpFileTime);
end;

procedure LLCL_Sleep(dwMilliseconds: DWORD); stdcall;
begin
  Sleep(dwMilliseconds);
end;

function LLCL_SetErrorMode(uMode: UINT): UINT; stdcall;
begin
  result := SetErrorMode(uMode);
end;

function LLCL_FindClose(hFindFile: HANDLE): BOOL; stdcall;
begin
  result := FindClose(hFindFile);
end;

function LLCL_GetACP(): UINT; stdcall;
begin
  result := GetACP();
end;

function  LLCL_GetOEMCP(): UINT; stdcall;
begin
  result := GetOEMCP();
end;

function  LLCL_LoadResource(hModule: HINST; hResInfo: HRSRC): HGLOBAL; stdcall;
begin
  result := LoadResource(hModule, hResInfo);
end;

function  LLCL_LockResource(hResData: HGLOBAL): pointer; stdcall;
begin
  result := LockResource(hResData);
end;

function  LLCL_FreeResource(hResData: HGLOBAL): BOOL; stdcall;
begin
  result := FreeResource(hResData);
end;

function LLCL_TranslateMessage(const lpMsg: TMsg): BOOL; stdcall;
begin
  result := TranslateMessage(lpMsg);
end;

function LLCL_WaitMessage: BOOL; stdcall;
begin
  result := WaitMessage();
end;

procedure LLCL_PostQuitMessage(nExitCode: Integer); stdcall;
begin
  PostQuitMessage(nExitCode);
end;

function LLCL_IsWindowVisible(hWnd: HWND): BOOL; stdcall;
begin
  result := IsWindowVisible(hWnd);
end;

function LLCL_ShowWindow(hWnd: HWND; nCmdShow: Integer): BOOL; stdcall;
begin
  result := ShowWindow(hWnd, nCmdShow);
end;

function LLCL_IsWindowEnabled(hWnd: HWND): BOOL; stdcall;
begin
  result := IsWindowEnabled(hWnd);
end;

function LLCL_EnableWindow(hWnd: HWND; bEnable: BOOL): BOOL; stdcall;
begin
  result := EnableWindow(hWnd, bEnable);
end;

function LLCL_DestroyWindow(hWnd: HWND): BOOL; stdcall;
begin
  result := DestroyWindow(hWnd);
end;

function LLCL_SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT): BOOL; stdcall;
begin
  result := SetWindowPos(hWnd, hWndInsertAfter, X, Y, cx, cy, uFlags);
end;

function LLCL_MoveWindow(hWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL): BOOL; stdcall;
begin
  result := MoveWindow(hWnd, X, Y, nWidth, nHeight, bRepaint);
end;

function LLCL_GetActiveWindow: HWND; stdcall;
begin
  result := GetActiveWindow();
end;

function LLCL_SetActiveWindow(hWnd: HWND): HWND; stdcall;
begin
  result := SetActiveWindow(hWnd);
end;

function LLCL_GetFocus: HWND; stdcall;
begin
  result := GetFocus();
end;

function LLCL_SetFocus(hWnd: HWND): HWND; stdcall;
begin
  result := SetFocus(hWnd);
end;

function LLCL_GetForegroundWindow(): HWND; stdcall;
begin
  result := GetForegroundWindow();
end;

function LLCL_SetForegroundWindow(hWnd: HWND): BOOL; stdcall;
begin
  result := SetForegroundWindow(hWnd);
end;

function LLCL_GetKeyState(nVirtKey: Integer): SHORT; stdcall;
begin
  result := GetKeyState(nVirtKey);
end;

function LLCL_GetCursorPos(var lpPoint: TPoint): BOOL; stdcall;
begin
  result := GetCursorPos(lpPoint);
end;

function LLCL_SetCursorPos(X, Y: Integer): BOOL; stdcall;
begin
  result := SetCursorPos(X, Y);
end;

function LLCL_GetWindowRect(hWnd: HWND; var lpRect: TRect): BOOL; stdcall;
begin
  result := GetWindowRect(hWnd, lpRect);
end;

function LLCL_GetClientRect(hWnd: HWND; var lpRect: TRect): BOOL; stdcall;
begin
  result := GetClientRect(hWnd, lpRect);
end;

function LLCL_InvalidateRect(hWnd: HWND; lpRect: PRect; bErase: BOOL): BOOL; stdcall;
begin
  result := InvalidateRect(hWnd, lpRect, bErase);
end;

function LLCL_FillRect(hDC: HDC; const lprc: TRect; hbr: HBRUSH): Integer; stdcall;
begin
  result := FillRect(hDC, lprc, hbr);
end;

function LLCL_RedrawWindow(hWnd: HWND; lprcUpdate: PRect; hrgnUpdate: HRGN; flags: UINT): BOOL; stdcall;
begin
  result := RedrawWindow(hWnd, lprcUpdate, hrgnUpdate, flags);
end;

function LLCL_UpdateWindow(hWnd: HWND): BOOL; stdcall;
begin
  result := UpdateWindow(hWnd);
end;

function LLCL_GetDC(hWnd: HWND): HDC; stdcall;
begin
  result := GetDC(hWnd);
end;

function LLCL_ReleaseDC(hWnd: HWND; hDC: HDC): Integer; stdcall;
begin
  result := ReleaseDC(hWnd, hDC);
end;

function LLCL_BeginPaint(hWnd: HWND; var lpPaint: TPaintStruct): HDC; stdcall;
begin
  result := BeginPaint(hWnd, lpPaint);
end;

function LLCL_EndPaint(hWnd: HWND; const lpPaint: TPaintStruct): BOOL; stdcall;
begin
  result := EndPaint(hWnd, lpPaint);
end;

function LLCL_GetSystemMetrics(nIndex: Integer): Integer; stdcall;
begin
  result := GetSystemMetrics(nIndex);
end;

function LLCL_GetComboBoxInfo(hwndCombo: HWND; var pcbi: TComboBoxInfo): BOOL; stdcall;
begin
  result := GetComboBoxInfo(hwndCombo, pcbi);
end;

function LLCL_SetTimer(hWnd: HWND; nIDEvent, uElapse: UINT; lpTimerFunc: TFNTimerProc): UINT; stdcall;
begin
  result := SetTimer(hWnd, nIDEvent, uElapse, lpTimerFunc);
end;

function LLCL_KillTimer(hWnd: HWND; uIDEvent: UINT): BOOL; stdcall;
begin
  result := KillTimer(hWnd, uIDEvent);
end;

function LLCL_CreateIconFromResource(presbits: PByte; dwResSize: DWORD; fIcon: BOOL; dwVer: DWORD): HICON; stdcall;
begin
  result := CreateIconFromResource(presbits, dwResSize, fIcon, dwVer);
end;

function LLCL_DestroyCursor(hCursor: HICON): BOOL; stdcall;
begin
  result := DestroyCursor(hCursor);
end;

function LLCL_DestroyIcon(hIcon: HICON): BOOL; stdcall;
begin
  result := DestroyIcon(hIcon);
end;

function LLCL_CreateMenu: HMENU; stdcall;
begin
  result := CreateMenu();
end;

function LLCL_CreatePopupMenu: HMENU; stdcall;
begin
  result := CreatePopupMenu();
end;

function LLCL_SetMenu(hWnd: HWND; hMenu: HMENU): BOOL; stdcall;
begin
  result := SetMenu(hWnd, hMenu);
end;

function LLCL_EnableMenuItem(hMenu: HMENU; uIDEnableItem: UINT; uEnable: UINT): BOOL; stdcall;
begin
  result := EnableMenuItem(hMenu, uIDEnableItem, uEnable);
end;

function LLCL_CheckMenuItem(hMenu: HMENU; uIDCheckItem: UINT; uCheck: UINT): DWORD; stdcall;
begin
  result := CheckMenuItem(hMenu, uIDCheckItem, uCheck);
end;

function LLCL_DrawMenuBar(hWnd: HWND): BOOL; stdcall;
begin
  result := DrawMenuBar(hWnd);
end;

function LLCL_TrackPopupMenu(hMenu: HMENU; uFlags: UINT; x: longint; y: longint; nReserved: longint; hWnd: HWND; const prcRect: PRect): BOOl; stdcall;
begin
  result := TrackPopupMenu(hMenu, uFlags, x, y, nReserved, hWnd, prcRect);
end;

function LLCL_GetSystemMenu(hWnd: HWND; bRevert: BOOL): HMENU; stdcall;
begin
  result := GetSystemMenu(hWnd, bRevert);
end;

function LLCL_DeleteMenu(hMenu: HMENU; uPosition, uFlags: UINT): BOOL; stdcall;
begin
  result := DeleteMenu(hMenu, uPosition, uFlags);
end;

function LLCL_DestroyMenu(hMenu: HMENU): BOOL; stdcall;
begin
  result := DestroyMenu(hMenu);
end;

function LLCL_GetSysColor(nIndex: Integer): DWORD; stdcall;
begin
  result := GetSysColor(nIndex);
end;

function LLCL_MessageBeep(uType: UINT): BOOL; stdcall;
begin
  result := MessageBeep(uType);
end;

function LLCL_SetBkMode(DC: HDC; BkMode: Integer): Integer; stdcall;
begin
  result := SetBkMode(DC, BkMode);
end;

function LLCL_SetBkColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
begin
  result := SetBkColor(DC, Color);
end;

function LLCL_SelectObject(DC: HDC; p2: HGDIOBJ): HGDIOBJ; stdcall;
begin
  result := SelectObject(DC, p2);
end;

function LLCL_DeleteObject(p1: HGDIOBJ): BOOL; stdcall;
begin
  result := DeleteObject(p1);
end;

function LLCL_CreatePen(Style, Width: Integer; Color: COLORREF): HPEN; stdcall;
begin
  result := CreatePen(Style, Width, Color);
end;

function LLCL_CreateSolidBrush(p1: COLORREF): HBRUSH; stdcall;
begin
  result := CreateSolidBrush(p1);
end;

function LLCL_Rectangle(DC: HDC; X1, Y1, X2, Y2: Integer): BOOL; stdcall;
begin
  result := Rectangle(DC, X1, Y1, X2, Y2);
end;

function LLCL_ExcludeClipRect(DC: HDC; LeftRect, TopRect, RightRect, BottomRect: Integer): Integer; stdcall;
begin
  result := ExcludeClipRect(DC, LeftRect, TopRect, RightRect, BottomRect);
end;

function LLCL_RectVisible(hDC: HDC; const lprc: TRect): BOOL; stdcall;
begin
  result := RectVisible(hDC, lprc);
end;

function LLCL_MoveToEx(DC: HDC; p2, p3: Integer; p4: PPoint): BOOL; stdcall;
begin
  result := MoveToEx(DC, p2, p3, p4);
end;

function LLCL_LineTo(DC: HDC; X, Y: Integer): BOOL; stdcall;
begin
  result := LineTo(DC, X, Y);
end;

function LLCL_SetTextColor(DC: HDC; Color: COLORREF): COLORREF; stdcall;
begin
  result := SetTextColor(DC, Color);
end;

function LLCL_SetStretchBltMode(DC: HDC; StretchMode: Integer): Integer; stdcall;
begin
  result := SetStretchBltMode(DC, StretchMode);
end;

function LLCL_StretchDIBits(DC: HDC; DestX, DestY, DestWidth, DestHeight, SrcX, SrcY, SrcWidth, SrcHeight: Integer; Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: UINT; Rop: DWORD): Integer; stdcall;
begin
  result := StretchDIBits(DC, DestX, DestY, DestWidth, DestHeight, SrcX, SrcY, SrcWidth, SrcHeight, Bits, BitsInfo, Usage, Rop);
end;

function LLCL_SetDIBitsToDevice(DC: HDC; DestX, DestY: Integer; Width, Height: DWORD; SrcX, SrcY: Integer; nStartScan, NumScans: UINT; Bits: Pointer; var BitsInfo: TBitmapInfo; Usage: UINT): Integer; stdcall;
begin
  result := SetDIBitsToDevice(DC, DestX, DestY, Width, Height, SrcX, SrcY, nStartScan, NumScans, Bits, BitsInfo, Usage);
end;

procedure LLCL_InitCommonControls(); stdcall;
begin
  InitCommonControls();
end;
{$ENDIF}

//------------------------------------------------------------------------------

{$IFDEF LLCL_FPC_ANSISYS}
//
// Ansi APIs without any transformations (for FPC SysUtils only)
//   (Not sensible to LLCL_UNICODE_API_xxxx)
//
function LLCLSys_CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: DWORD; lpSecurityAttributes: LPSECURITY_ATTRIBUTES; dwCreationDisposition: DWORD; dwFlagsAndAttributes: DWORD; hTemplateFile: HANDLE; var LastOSError: DWORD): HANDLE;
begin
  LastOSError := 0;
  result := CreateFileA(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
  if result = INVALID_HANDLE_VALUE then
    LastOSError := LLCL_GetLastError();
end;

function LLCLSys_FindFirstNextFile(sFileName: string; hFindFile: HANDLE; var lpFindFileData: TCustomWin32FindData; var OutFileName: string; var LastOSError: DWORD): HANDLE;
// Always TWin32FindData = TWin32FindDataA (no LLCL_EXTWIN_WIDESTRUCT defined)
begin
  // (Can use same Ansi function as for LLCLS_FindFirstNextFile)
  if not LLCLS_FFNF_A(@sFileName[1], hFindFile, lpFindFileData, OutFileName, result, LastOSError) then
    exit;
end;

function LLCLSys_GetFileAttributes(lpFileName: PChar): DWORD;
begin
  result := GetFileAttributesA(lpFileName);
end;

function LLCLSys_GetFileAttributesEx(lpFileName: PChar; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer; var LastOSError: DWORD): BOOL;
begin
  LastOSError := 0;
  result := GetFileAttributesExA(lpFileName, fInfoLevelId, lpFileInformation);
  if not result then
    LastOSError := LLCL_GetLastError();
end;

function LLCLSys_CreateDirectory(lpPathName: PChar; lpSecurityAttributes: PSecurityAttributes): BOOL;
begin
  result := CreateDirectoryA(lpPathName, lpSecurityAttributes);
end;

function LLCLSys_RemoveDirectory(lpPathName: PChar): BOOL;
begin
  result := RemoveDirectoryA(lpPathName);
end;

function LLCLSys_GetModuleFileName(hModule: HINST): string;
var Buffer: array[0..MAX_PATH+1] of Char; // (Including terminating null character, plus one)
var icount: integer;
begin
  result := '';
  icount := GetModuleFileNameA(hModule, @Buffer, Length(Buffer)-1);
  if icount>0 then
    begin
      Buffer[icount] := Char(0); // (may be absent)
      result := string(Buffer);
    end;
end;

function LLCLSys_GetFullPathName(const sFileName: string): string;
var Buffer: array[0..MAX_PATH+1] of Char; // (Including terminating null character, plus one)
var lpPart: PAnsiChar;
var icount: integer;
begin
  result := '';
  icount := GetFullPathNameA(@sFileName[1], Length(Buffer)-1, @Buffer, lpPart);
  if icount>0 then
    begin
      Buffer[icount] := Char(0); // (may be absent)
      result := string(Buffer);
    end;
end;

function LLCLSys_GetDiskSpace(const sDrive: string; var TotalSpace, FreeSpaceAvailable: int64): BOOL;
var PAddrGetDiskFreeSpaceEx: function(lpDirectoryName: LPCSTR; lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes: PInt64): BOOL; stdcall;
var lpDrive: PAnsiChar;
var AllFree: int64;
begin
  result := false;
  if sDrive='' then
    lpDrive := nil
  else
    lpDrive := @sDrive[1];
  {$IFDEF LLCL_OBJFPC_MODE}FARPROC(PAddrGetDiskFreeSpaceEx){$ELSE}@PAddrGetDiskFreeSpaceEx{$ENDIF}
    := LLCL_GetProcAddress(LLCL_GetModuleHandle(CKERNEL32), 'GetDiskFreeSpaceExA');
  if Assigned(PAddrGetDiskFreeSpaceEx) then
    result := PAddrGetDiskFreeSpaceEx(lpDrive, @FreeSpaceAvailable, @TotalSpace, @AllFree)
  else
    ;   // Returns false for Win95 before OSR2 (should use GetDiskFreeSpaceA otherwise)
end;

function LLCLSys_FormatMessage(dwFlags: DWORD; lpSource: Pointer; dwMessageId: DWORD; dwLanguageId: DWORD; Arguments: Pointer): string;
var Buffer: array[0..255+1] of Char;      // (Including terminating null character, plus one)
var iCount: integer;
begin
  result := '';
  iCount := FormatMessageA(dwFlags, lpSource, dwMessageId, dwLanguageId, @Buffer, Length(Buffer)-1, Arguments);
  if iCount>0 then
    begin
      Buffer[iCount] := Char(0); // (may be absent)
      result := string(Buffer);
    end;
end;

function LLCLSys_GetFileVersionInfoSize(lptstrFilename: PChar; var lpdwHandle: DWORD): DWORD;
begin
  result := GetFileVersionInfoSizeA(lptstrFilename, lpdwHandle);
end;

function LLCLSys_GetFileVersionInfo(lptstrFilename: PChar; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL;
var aStr: ansistring;
begin
  aStr := ansistring(lptstrFilename);     // GetFileVersionInfo modify filename data ?
  result := GetFileVersionInfoA(@aStr[1], dwHandle, dwLen, lpData);
end;

function LLCLSys_VerQueryValue(pBlock: Pointer; lpSubBlock: PChar; var lplpBuffer: Pointer; var puLen: UINT): BOOL;
begin
  result := VerQueryValueA(pBlock, lpSubBlock, lplpBuffer, puLen);
end;

function LLCLSys_LoadLibrary(lpLibFileName: PChar): HMODULE;
begin
  result := LoadLibraryA(lpLibFileName);
end;

function LLCLSys_CompareString(Locale: LCID; dwCmpFlags: DWORD; String1: string; cchCount1: Integer; String2: string; cchCount2: Integer): Integer;
begin
  result := CompareStringA(Locale, dwCmpFlags, @String1[1], cchCount1, @String2[2], cchCount2);
end;

function LLCLSys_CharUpperBuff(const sText: string): string;
var iCount: integer;
begin
  iCount := Length(sText);
  SetString(result, PChar(sText), iCount);
  if iCount<>0 then
    CharUpperBuffA(PChar(result), iCount);
end;

function LLCLSys_CharLowerBuff(const sText: string): string;
var iCount: integer;
begin
  iCount := Length(sText);
  SetString(result, PChar(sText), iCount);
  if iCount<>0 then
    CharLowerBuffA(PChar(result), iCount);
end;
{$ENDIF LLCL_FPC_ANSISYS}
{$IFDEF LLCL_FPC_UNISYS}
// Unicode APIs without any transformations (for FPC SysUtils only)
//   (Not sensible to LLCL_UNICODE_API_xxxx)
function LLCLSys_CreateFile(lpFileName: PUnicodeChar; dwDesiredAccess, dwShareMode: DWORD; lpSecurityAttributes: LPSECURITY_ATTRIBUTES; dwCreationDisposition: DWORD; dwFlagsAndAttributes: DWORD; hTemplateFile: HANDLE; var LastOSError: DWORD): HANDLE;
begin
  LastOSError := 0;
  result := CreateFileW(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes, dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
  if result = INVALID_HANDLE_VALUE then
    LastOSError := LLCL_GetLastError();
end;

function LLCLSys_FindFirstNextFile(sFileName: unicodestring; hFindFile: HANDLE; var lpFindFileData: TCustomWin32FindData; var OutFileName: unicodestring; var LastOSError: DWORD): HANDLE;
// Always TWin32FindData = TWin32FindDataW (LLCL_EXTWIN_WIDESTRUCT defined)
begin
  // (Can't use same Wide function as for LLCLS_FindFirstNextFile)
  if not LLCLS_FFNF_WW(@sFileName[1], hFindFile, lpFindFileData, OutFileName, result, LastOSError) then
    exit;
end;
//
function LLCLS_FFNF_WW(lpFileName: PUnicodeChar; hFindFile: HANDLE; var lpFindFileData: TWin32FindDataW; var OutFileName: unicodestring; var ResFunc: HANDLE; var LastOSError: DWORD): boolean;
begin
  result := false;
  LastOSError := 0;
  if hFindFile=0 then
    begin
      ResFunc := FindFirstFileW(lpFileName, lpFindFileData);
      if ResFunc=INVALID_HANDLE_VALUE then
        begin
          LastOSError := LLCL_GetLastError();
          exit;
        end;
    end
  else
    begin
      ResFunc := HANDLE(FindNextFileW(hFindFile, lpFindFileData));   // (False=0)
      if ResFunc=HANDLE(false) then
        begin
          LastOSError := LLCL_GetLastError();
          exit;
        end;
    end;
  OutFileName := unicodestring(lpFindFileData.cFileName);
  result := true;
end;

function LLCLSys_GetFileAttributes(lpFileName: PUnicodeChar): DWORD;
begin
  result := GetFileAttributesW(lpFileName);
end;

function LLCLSys_GetFileAttributesEx(lpFileName: PUnicodeChar; fInfoLevelId: TGetFileExInfoLevels; lpFileInformation: Pointer; var LastOSError: DWORD): BOOL;
begin
  LastOSError := 0;
  result := GetFileAttributesExW(lpFileName, fInfoLevelId, lpFileInformation);
  if not result then
    LastOSError := LLCL_GetLastError();
end;

function LLCLSys_CreateDirectory(lpPathName: PUnicodeChar; lpSecurityAttributes: PSecurityAttributes): BOOL;
begin
  result := CreateDirectoryW(lpPathName, lpSecurityAttributes);
end;

function LLCLSys_RemoveDirectory(lpPathName: PUnicodeChar): BOOL;
begin
  result := RemoveDirectoryW(lpPathName);
end;

function LLCLSys_GetModuleFileName(hModule: HINST): unicodestring;
var Buffer: array[0..MAX_PATH+1] of WideChar; // (Including terminating null character, plus one)
var icount: integer;
begin
  result := '';
  icount := GetModuleFileNameW(hModule, @Buffer, Length(Buffer)-1);
  if icount>0 then
    begin
      Buffer[icount] := WideChar(0); // (may be absent)
      result := unicodestring(Buffer);
    end;
end;

function LLCLSys_GetFullPathName(const sFileName: unicodestring): unicodestring;
var Buffer: array[0..MAX_PATH+1] of WideChar; // (Including terminating null character, plus one)
var lpPart: PUnicodeChar;
var icount: integer;
begin
  result := '';
  icount := GetFullPathNameW(@sFileName[1], Length(Buffer)-1, @Buffer, lpPart);
  if icount>0 then
    begin
      Buffer[icount] := WideChar(0); // (may be absent)
      result := unicodestring(Buffer);
    end;
end;

function LLCLSys_GetDiskSpace(const sDrive: unicodestring; var TotalSpace, FreeSpaceAvailable: int64): BOOL;
var lpDrive: PUnicodeChar;
var AllFree: int64;
begin
  if sDrive='' then
    lpDrive := nil
  else
    lpDrive := @sDrive[1];
  result := GetDiskFreeSpaceExW(lpDrive, @FreeSpaceAvailable, @TotalSpace, @AllFree)
end;

function LLCLSys_FormatMessage(dwFlags: DWORD; lpSource: Pointer; dwMessageId: DWORD; dwLanguageId: DWORD; Arguments: Pointer): unicodestring;
var Buffer: array[0..255+1] of WideChar;      // (Including terminating null character, plus one)
var iCount: integer;
begin
  result := '';
  iCount := FormatMessageW(dwFlags, lpSource, dwMessageId, dwLanguageId, @Buffer, Length(Buffer)-1, Arguments);
  if iCount>0 then
    begin
      Buffer[iCount] := WideChar(0); // (may be absent)
      result := unicodestring(Buffer);
    end;
end;

function LLCLSys_GetFileVersionInfoSize(lptstrFilename: PUnicodeChar; var lpdwHandle: DWORD): DWORD;
begin
  result := GetFileVersionInfoSizeW(lptstrFilename, lpdwHandle);
end;

function LLCLSys_GetFileVersionInfo(lptstrFilename: PUnicodeChar; dwHandle, dwLen: DWORD; lpData: Pointer): BOOL;
var wStr: unicodestring;
begin
  wStr := unicodestring(lptstrFilename);  // GetFileVersionInfo modify filename data ?
  result := GetFileVersionInfoW(@wStr[1], dwHandle, dwLen, lpData);
end;

function LLCLSys_VerQueryValue(pBlock: Pointer; lpSubBlock: PUnicodeChar; var lplpBuffer: Pointer; var puLen: UINT): BOOL;
begin
  result := VerQueryValueW(pBlock, lpSubBlock, lplpBuffer, puLen);
end;

function LLCLSys_LoadLibrary(lpLibFileName: PUnicodeChar): HMODULE;
begin
  result := LoadLibraryW(lpLibFileName);
end;

function LLCLSys_CompareString(Locale: LCID; dwCmpFlags: DWORD; String1: string; cchCount1: Integer; String2: string; cchCount2: Integer): Integer;
var sString1, sString2: unicodestring;
begin
  sString1 := unicodestring(String1);
  sString2 := unicodestring(String2);
  result := CompareStringW(Locale, dwCmpFlags, @sString1[1], cchCount1, @sString2[1], cchCount2);
end;

function LLCLSys_CharUpperBuff(const sText: string): string;
var sIn, sOut: unicodestring;
var iCount: integer;
begin
  sIn := unicodestring(sText);
  iCount := Length(sIn);
  SetString(sOut, PUnicodeChar(sIn), iCount);
  if iCount<>0 then
    CharUpperBuffW(PUnicodeChar(sOut), iCount);
  result := string(sOut);
end;

function LLCLSys_CharLowerBuff(const sText: string): string;
var sIn, sOut: unicodestring;
var iCount: integer;
begin
  sIn := unicodestring(sText);
  iCount := Length(sIn);
  SetString(sOut, PUnicodeChar(sIn), iCount);
  if iCount<>0 then
    CharLowerBuffW(PUnicodeChar(sOut), iCount);
  result := string(sOut);
end;
{$ENDIF}

//------------------------------------------------------------------------------

// No such Windows API (provided here for compatibility)
function LLCL_UnlockResource(hResData: THandle): BOOL; stdcall;
begin
  result := true;
end;

//
// Specific functions
//

// Exceptionally, only Ansi version here
procedure LLCLS_GetOSVersionA(var aPlatform, aMajorVersion, aMinorVersion, aBuildNumber: integer; var aCSDVersion: string);
var OSVersion: TOSVersionInfoA;
var aStr: ansistring;
begin
  {$IFDEF LLCL_FPC_UTF8RTL}     // (FPC only)
  CallInit();   // (Probably not done)
  {$ENDIF}
  OSVersion.dwOSVersionInfoSize := SizeOf(OSVersion);
  if GetVersionExA(OSVersion) then
    with OSVersion do
      begin
        aPlatform := dwPlatformId;
        aMajorVersion := dwMajorVersion;
        aMinorVersion := dwMinorVersion;
        if aPlatform = VER_PLATFORM_WIN32_WINDOWS then
          aBuildNumber := dwBuildNumber and $FFFF
        else
          aBuildNumber := dwBuildNumber;
        aStr := ansistring(szCSDVersion);
        aCSDVersion := StrFromTextDispA(aStr);
      end;
end;

// Initializations (Can't be done in Initialization block)
procedure LLCLS_Init(aPlatForm: integer);
begin
{$IFDEF LLCL_UNICODE_API_W_ONLY}
  UnicodeEnabledOS := True;
{$ELSE}
  {$IFDEF LLCL_UNICODE_API_A}
  UnicodeEnabledOS := False;
  {$ELSE}
  UnicodeEnabledOS := (aPlatform>=VER_PLATFORM_WIN32_NT);
  {$ENDIF}
{$ENDIF}
end;

// Initialization for Common Controls
function LLCLS_InitCommonControl(CC: integer): BOOL;
var PAddrInitCommonControlsEx: function(var ICC: TInitCommonControlsEx): longbool stdcall;
var ICC: TInitCommonControlsEx;
begin
  LLCL_InitCommonControls();
  result := false;
  {$IFDEF LLCL_OBJFPC_MODE}FARPROC(PAddrInitCommonControlsEx){$ELSE}@PAddrInitCommonControlsEx{$ENDIF}
    := LLCL_GetProcAddress(LLCL_GetModuleHandle(CCOMCTL32), 'InitCommonControlsEx');
  if Assigned(PAddrInitCommonControlsEx) then
    begin
      ICC.dwSize := SizeOf(ICC);
      ICC.dwICC := CC;
      result := PAddrInitCommonControlsEx(ICC);
    end;
end;

function LLCLS_GetModuleFileName(hModule: HINST): string;
{$IFDEF LLCL_UNICODE_API_W}
var wBuffer: array[0..MAX_PATH+1] of WideChar;  // (Including terminating null character, plus one)
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aBuffer: array[0..MAX_PATH+1] of AnsiChar;  // (Including terminating null character, plus one)
{$ENDIF}
var icount: integer;
begin
  result := '';
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      icount := GetModuleFileNameW(hModule, @wBuffer, Length(wBuffer)-1);
      if icount>0 then
        begin
          wBuffer[icount] := WideChar(0); // (may be absent)
          result := StrFromTextDispW(wBuffer);
        end;
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    ;   // (result='' already set)
{$ELSE}
  begin
      icount := GetModuleFileNameA(hModule, @aBuffer, Length(aBuffer)-1);
      if icount>0 then
        begin
          aBuffer[icount] := AnsiChar(0); // (may be absent)
          result := StrFromTextDispA(aBuffer);
        end;
    end;
{$ENDIF}
end;

// Change windows default layout
function LLCLS_SetProcessDefaultLayout(dwDefaultLayout: DWORD): BOOl;
var PAddrSetProcessDefaultLayout: function(dwDefaultLayout: cardinal): longbool; stdcall;
begin
  result := false;
  {$IFDEF LLCL_OBJFPC_MODE}FARPROC(PAddrSetProcessDefaultLayout){$ELSE}@PAddrSetProcessDefaultLayout{$ENDIF}
    := LLCL_GetProcAddress(LLCL_GetModuleHandle(CUSER32), 'SetProcessDefaultLayout');
  if Assigned(PAddrSetProcessDefaultLayout) then
    result := PAddrSetProcessDefaultLayout(dwDefaultLayout);
end;

// Get NonClientMetrics (Reduced) Data (Using custom NonClientMetrics)
function LLCLS_GetNonClientMetrics(var NonClientMetrics: TCustomNonClientMetrics): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wNonClientMetrics: TNonClientMetricsW;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aNonClientMetrics: TNonClientMetricsA;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      FillChar(wNonClientMetrics,SizeOf(wNonClientMetrics),0);
      wNonClientMetrics.cbSize := SizeOf(wNonClientMetrics);
      result := SystemParametersInfoW(SPI_GETNONCLIENTMETRICS, wNonClientMetrics.cbSize, @wNonClientMetrics, 0);
      NonClientMetrics.iBorderWidth := wNonClientMetrics.iBorderWidth;
      NonClientMetrics.iCaptionHeight := wNonClientMetrics.iCaptionHeight;
      NonClientMetrics.iMenuHeight := wNonClientMetrics.iMenuHeight;
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      FillChar(aNonClientMetrics,SizeOf(aNonClientMetrics),0);
      aNonClientMetrics.cbSize := SizeOf(aNonClientMetrics);
      result := SystemParametersInfoA(SPI_GETNONCLIENTMETRICS, aNonClientMetrics.cbSize, @aNonClientMetrics, 0);
      NonClientMetrics.iBorderWidth := aNonClientMetrics.iBorderWidth;
      NonClientMetrics.iCaptionHeight := aNonClientMetrics.iCaptionHeight;
      NonClientMetrics.iMenuHeight := aNonClientMetrics.iMenuHeight;
    end;
{$ENDIF}
end;

function LLCLS_CreateFontIndirect(const lpLogFont: TCustomLogFont; const sName: string): HFONT;
{$IFDEF LLCL_UNICODE_API_W}
var wLogFont: TLogFontW;
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aLogFont: TLogFontA;
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      Move(lpLogFont, wLogFont, SizeOf(lpLogFont));     // TCustomLogFont=TLogFontA is smaller than TlogFontW (or eventually TCustomLogFont=TLogFontW; identical size)
      wStr := StrToTextDispW(sName);
      StrLCopyW(wLogFont.lfFaceName, wStr, Length(wLogFont.lfFaceName));
      result := CreateFontIndirectW(wLogFont);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      Move(lpLogFont, aLogFont, SizeOf(aLogFont));      // Same size for both
      aStr := StrToTextDispA(sName);
      StrLCopyA(aLogFont.lfFaceName, aStr, Length(aLogFont.lfFaceName));
      result := CreateFontIndirectA(aLogFont);
    end;
{$ENDIF}
end;

function LLCLS_SendMessageSetText(hWnd: HWND; Msg: Cardinal; const sText: string): LRESULT;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(sText);
      result := SendMessageW(hWnd, Msg, 0, NativeUInt(wStr));   // NativeUInt because of SendMessage
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      aStr := StrToTextDispA(sText);
      result := SendMessageA(hWnd, Msg, 0, NativeUInt(aStr));   // NativeUInt because of SendMessage
    end;
{$ENDIF}
end;

function LLCLS_SendMessageGetText(hWnd: HWND): string;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
var ilen: cardinal;
begin
  ilen := LLCL_SendMessage(hWnd, WM_GETTEXTLENGTH, 0, 0);
  if ilen = 0 then
    result := ''
  else begin
    Inc(ilen);    // Terminating null character
{$IFDEF LLCL_UNICODE_API_W}
    if UnicodeEnabledOS then
      begin
        SetLength(wStr, ilen);
        SetLength(wStr, SendMessageW(hWnd, WM_GETTEXT, ilen, NativeUInt(wStr)));   // NativeUInt because of SendMessage
        result := StrFromTextDispW(wStr);
      end
    else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := '';
{$ELSE}
      begin
        SetLength(aStr, ilen);
        SetLength(aStr, SendMessageA(hWnd, WM_GETTEXT, ilen, NativeUInt(aStr)));   // NativeUInt because of SendMessage
        result := StrFromTextDispA(aStr);
      end;
{$ENDIF}
  end;
end;

function LLCLS_CompareString(Locale: LCID; dwCmpFlags: DWORD; String1: string; cchCount1: Integer; String2: string; cchCount2: Integer): Integer;
{$IFDEF LLCL_UNICODE_API_W}
var wString1, wString2: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aString1, aString2: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wString1 := StrToTextDispW(String1);
      wString2 := StrToTextDispW(String2);
      result := CompareStringW(Locale, dwCmpFlags, @wString1[1], cchCount1, @wString2[1], cchCount2);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := 0;
{$ELSE}
    begin
      aString1 := StrToTextDispA(String1);
      aString2 := StrToTextDispA(String2);
      result := CompareStringA(Locale, dwCmpFlags, @aString1[1], cchCount1, @aString2[1], cchCount2);
    end;
{$ENDIF}
end;

function LLCLS_CharUpperBuff(const sText: string): string;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
  result := '';
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(sText);
      if CharUpperBuffW(@wStr[1], length(wStr))<>0 then
        result := StrFromTextDispW(wStr);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    ;   // (result='' already set)
{$ELSE}
    begin
      aStr := StrToTextDispA(sText);
      if CharUpperBuffA(@aStr[1], length(aStr))<>0 then
        result := StrFromTextDispA(aStr);
    end;
{$ENDIF}
end;

function LLCLS_CharLowerBuff(const sText: string): string;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
begin
  result := '';
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(sText);
      if CharLowerBuffW(@wStr[1], length(wStr))<>0 then
        result := StrFromTextDispW(wStr);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    ;   // (result='' already set)
{$ELSE}
    begin
      aStr := StrToTextDispA(sText);
      if CharLowerBuffA(@aStr[1], length(aStr))<>0 then
        result := StrFromTextDispA(aStr);
    end;
{$ENDIF}
end;

function LLCLS_Shell_NotifyIcon(dwMessage: DWORD; lpData: PCustomNotifyIconData; UseExtStruct: boolean; const sTip: string): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wNotifyIconData: TCustomNotifyIconDataW;
var wNotifyIconDataExt: TCustomNotifyIconDataExtW;
var lpDataW: PCustomNotifyIconDataW;
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aNotifyIconData: TCustomNotifyIconDataA;
var aNotifyIconDataExt: TCustomNotifyIconDataExtA;
var lpDataA: PCustomNotifyIconDataA;
var aStr: ansistring;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      if UseExtStruct then
        lpDataW := @wNotifyIconDataExt
      else
        lpDataW := @wNotifyIconData;
      Move(lpData^, lpDataW^, SizeOf(TCustomNotifyIconData));   // TCustomNotifyIconData is smaller than all NotifyIconData structures
      wStr := StrToTextDispW(sTip);
      if UseExtStruct then
        begin
          wNotifyIconDataExt.cbSize := SizeOf(wNotifyIconDataExt);
          StrLCopyW(LPCWSTR(@wNotifyIconDataExt.szTip)^, wStr, Length(wNotifyIconDataExt.szTip));
        end
      else
        begin
          wNotifyIconData.cbSize := SizeOf(wNotifyIconData);
          StrLCopyW(LPCWSTR(@wNotifyIconData.szTip)^, wStr, Length(wNotifyIconData.szTip));
        end;
      result := Shell_NotifyIconW(dwMessage, PNotifyIconDataW(lpDataW));
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      if UseExtStruct then
        lpDataA := @aNotifyIconDataExt
      else
        lpDataA := @aNotifyIconData;
      Move(lpData^, lpDataA^, SizeOf(TCustomNotifyIconData));   // TCustomNotifyIconData is smaller than all NotifyIconData structures
      aStr := StrToTextDispA(sTip);
      if UseExtStruct then
        begin
          aNotifyIconDataExt.cbSize := SizeOf(aNotifyIconDataExt);
          StrLCopyA(LPCSTR(@aNotifyIconDataExt.szTip)^, aStr, Length(aNotifyIconDataExt.szTip));
        end
      else
        begin
          aNotifyIconData.cbSize := SizeOf(aNotifyIconData);
          StrLCopyA(LPCSTR(@aNotifyIconData.szTip)^, aStr, Length(aNotifyIconData.szTip));
        end;
      result := Shell_NotifyIconA(dwMessage, PNotifyIconDataA(lpDataA));
    end;
{$ENDIF}
end;

function LLCLS_Shell_NotifyIconBalloon(dwMessage: DWORD; lpData: PCustomNotifyIconData; UseExtStruct: boolean; InfoFlags: DWORD; const Timeout: UINT; const sInfoTitle: string; const sInfo: string): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wNotifyIconDataExt: TCustomNotifyIconDataExtW;
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aNotifyIconDataExt: TCustomNotifyIconDataExtA;
var aStr: ansistring;
{$ENDIF}
begin
  result := false;
  if not UseExtStruct then exit;
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      Move(lpData^, wNotifyIconDataExt, SizeOf(TCustomNotifyIconData));   // TCustomNotifyIconData is smaller than all NotifyIconData structures
      wNotifyIconDataExt.cbSize := SizeOf(wNotifyIconDataExt);
      wNotifyIconDataExt.TOVUnion.uTimeOut := TimeOut;
      wNotifyIconDataExt.dwInfoFlags := InfoFlags;
      wStr := StrToTextDispW(sInfo);
      StrLCopyW(LPCWSTR(@wNotifyIconDataExt.szInfo)^, wStr, Length(wNotifyIconDataExt.szInfo));
      wStr := StrToTextDispW(sInfoTitle);
      StrLCopyW(LPCWSTR(@wNotifyIconDataExt.szInfoTitle)^, wStr, Length(wNotifyIconDataExt.szInfoTitle));
      result := Shell_NotifyIconW(dwMessage, PNotifyIconDataW(@wNotifyIconDataExt));
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      Move(lpData^, aNotifyIconDataExt, SizeOf(TCustomNotifyIconData));   // TCustomNotifyIconData is smaller than all NotifyIconData structures
      aNotifyIconDataExt.cbSize := SizeOf(aNotifyIconDataExt);
      aNotifyIconDataExt.TOVUnion.uTimeOut := TimeOut;
      aNotifyIconDataExt.dwInfoFlags := InfoFlags;
      aStr := StrToTextDispA(sInfo);
      StrLCopyA(LPCSTR(@aNotifyIconDataExt.szInfo)^, aStr, Length(aNotifyIconDataExt.szInfo));
      aStr := StrToTextDispA(sInfoTitle);
      StrLCopyA(LPCSTR(@aNotifyIconDataExt.szInfoTitle)^, aStr, Length(aNotifyIconDataExt.szInfoTitle));
      result := Shell_NotifyIconA(dwMessage, PNotifyIconDataA(@aNotifyIconDataExt));
    end;
{$ENDIF}
end;

// As LLCL doesn't use any hook function, using the GetOpenFileName/GetSaveFileName
//    API should result into the new File Dialogs for Windows Vista+
function LLCLS_GetOpenSaveFileName(var OpenFile: TOpenFilename; OpenSave: integer; var OpenStrParam: TOpenStrParam): BOOL;
const MULTI_MAXLEN = ((MAX_PATH+1)*100); // Arbitrarily limited to (at least) 100 for multiselection
{$IFDEF LLCL_UNICODE_API_W}
var wOpenFile: TOpenFilenameW;
var wFilter, wFileName, wInitialDir, wTitle, wDefExt: unicodestring;
var pwFileNameBuffer, pw1, pw2: LPCWSTR;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aOpenFile: TOpenFilenameA;
var aFilter, aFileName, aInitialDir, aTitle, aDefExt: ansistring;
var paFileNameBuffer, pa1, pa2: LPCSTR;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      Move(OpenFile, wOpenFile, SizeOf(wOpenFile));   // All versions have same size
      wFilter := StrToTextDispW(OpenStrParam.sFilter)+WideChar(0)+WideChar(0);
      wOpenFile.lpstrFilter := @wFilter[1];
      GetMem(pwFileNameBuffer, (MULTI_MAXLEN+1)*2);
      wFileName := StrToTextDispW(OpenStrParam.sFileName);
      StrLCopyW(pwFileNameBuffer^, wFileName, MULTI_MAXLEN+1);
      wOpenFile.lpstrFile := pwFileNameBuffer;
      wOpenFile.nMaxFile := MULTI_MAXLEN+1;
      wInitialDir := StrToTextDispW(OpenStrParam.sInitialDir);
      wOpenFile.lpstrInitialDir := @wInitialDir[1];
      wTitle := StrToTextDispW(OpenStrParam.sTitle);
      wOpenFile.lpstrTitle := @wTitle[1];
      wDefExt := StrToTextDispW(OpenStrParam.sDefExt);
      wOpenFile.lpstrDefExt := @wDefExt[1];
      if OpenSave=0 then
        result := GetOpenFileNameW(wOpenFile)
      else
        result := GetSaveFileNameW(wOpenFile);
      OpenStrParam.NbrFileNames := 0;
      OpenStrParam.sFileName := '';
      if result then
        begin
          pw1 := pwFileNameBuffer;
          pw2 := pwFileNameBuffer;
          while pw1<=pwFileNameBuffer+(((MULTI_MAXLEN+1)*2)-(2*2)) do
            begin
              if pw2^=WideChar(0) then
                  begin
                    wFileName := unicodestring(pw1);
                    OpenStrParam.sFileName := OpenStrParam.sFileName+StrFromTextDispW(wFileName)+'|';
                    Inc(OpenStrParam.NbrFileNames);
                    Inc(pw2);
                    if (pw2^=WideChar(0)) or ((wOpenFile.Flags and OFN_ALLOWMULTISELECT)=0) then break;
                    pw1 := pw2;
                  end
              else
                Inc(pw2);
            end;
        end;
      FreeMem(pwFileNameBuffer);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    result := false;
{$ELSE}
    begin
      Move(OpenFile, aOpenFile, SizeOf(aOpenFile));   // All versions have same size
      aFilter := StrToTextDispA(OpenStrParam.sFilter)+AnsiChar(0)+AnsiChar(0);
      aOpenFile.lpstrFilter := @aFilter[1];
      GetMem(paFileNameBuffer, (MULTI_MAXLEN+1));
      aFileName := StrToTextDispA(OpenStrParam.sFileName);
      StrLCopyA(paFileNameBuffer^, aFileName, MULTI_MAXLEN+1);
      aOpenFile.lpstrFile := paFileNameBuffer;
      aOpenFile.nMaxFile := MULTI_MAXLEN+1;
      aInitialDir := StrToTextDispA(OpenStrParam.sInitialDir);
      aOpenFile.lpstrInitialDir := @aInitialDir[1];
      aTitle := StrToTextDispA(OpenStrParam.sTitle);
      aOpenFile.lpstrTitle := @aTitle[1];
      aDefExt := StrToTextDispA(OpenStrParam.sDefExt);
      aOpenFile.lpstrDefExt := @aDefExt[1];
      if OpenSave=0 then
        result := GetOpenFileNameA(aOpenFile)
      else
        result := GetSaveFileNameA(aOpenFile);
      OpenStrParam.NbrFileNames := 0;
      OpenStrParam.sFileName := '';
      if result then
        begin
          pa1 := paFileNameBuffer;
          pa2 := paFileNameBuffer;
          while pa1<=paFileNameBuffer+((MULTI_MAXLEN+1)-2) do
            begin
              if pa2^=AnsiChar(0) then
                  begin
                    aFileName := ansistring(pa1);
                    OpenStrParam.sFileName := OpenStrParam.sFileName+StrFromTextDispA(aFileName)+'|';
                    Inc(OpenStrParam.NbrFileNames);
                    Inc(pa2);
                    if (pa2^=AnsiChar(0)) or ((aOpenFile.Flags and OFN_ALLOWMULTISELECT)=0) then break;
                    pa1 := pa2;
                  end
              else
                Inc(pa2);
            end;
        end;
      FreeMem(paFileNameBuffer);
    end;
{$ENDIF}
end;

function LLCLS_FindFirstNextFile(sFileName: string; hFindFile: HANDLE; var lpFindFileData: TCustomWin32FindData; var OutFileName: string; var LastOSError: DWORD): HANDLE;
{$ifndef LLCL_EXTWIN_WIDESTRUCT}   // TWin32FindData = TWin32FindDataA
{$IFDEF LLCL_UNICODE_API_W}
var wWin32FindData: TWin32FindDataW;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      if not LLCLS_FFNF_W(@sFileName[1], hFindFile, wWin32FindData, OutFileName, result, LastOSError) then
          exit;
      LLCLS_FFNF_WToA(wWin32FindData, lpFindFileData);
      {$IFDEF LLCL_UNICODE_STR_UTF8}
      StrLCopyA(lpFindFileData.cFileName, OutFileName, Length(lpFindFileData.cFileName));   // Saves UTF8 string as Ansi string
      {$ENDIF}
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    begin
      if hFindFile=0 then
        result := INVALID_HANDLE_VALUE
      else
        result := HANDLE(false);
      LastOSError := ERROR_NOT_SUPPORTED;
    end;
{$ELSE}
    begin
      if not LLCLS_FFNF_A(@sFileName[1], hFindFile, lpFindFileData, OutFileName, result, LastOSError) then
          exit;
    end;
{$ENDIF}
end;
{$else}                         // TWin32FindData = TWin32FindDataW
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aWin32FindData: TWin32FindDataA;
{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      if not LLCLS_FFNF_W(@sFileName[1], hFindFile, lpFindFileData, OutFileName, result, LastOSError) then
          exit;
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    begin
      if hFindFile=0 then
        result := INVALID_HANDLE_VALUE
      else
        result := HANDLE(false);
      LastOSError := ERROR_NOT_SUPPORTED;
    end;
{$ELSE}
    begin
      if not LLCLS_FFNF_A(@sFileName[1], hFindFile, aWin32FindData, OutFileName, result, LastOSError) then
          exit;
      LLCLS_FFNF_AToW(aWin32FindData, lpFindFileData);
    end;
{$ENDIF}
end;
{$endif}
//
{$IFDEF LLCL_UNICODE_API_W}
function LLCLS_FFNF_W(lpFileName: PChar; hFindFile: HANDLE; var lpFindFileData: TWin32FindDataW; var OutFileName: string; var ResFunc: HANDLE; var LastOSError: DWORD): boolean;
var wStr: unicodestring;
begin
  result := false;
  LastOSError := 0;
  wStr := StrToTextDispW(lpFileName);
  if hFindFile=0 then
    begin
      ResFunc := FindFirstFileW(@wStr[1], lpFindFileData);
      if ResFunc=INVALID_HANDLE_VALUE then
        begin
          LastOSError := LLCL_GetLastError();
          exit;
        end;
    end
  else
    begin
      ResFunc := HANDLE(FindNextFileW(hFindFile, lpFindFileData));   // (False=0)
      if ResFunc=HANDLE(false) then
        begin
          LastOSError := LLCL_GetLastError();
          exit;
        end;
    end;
  wStr := unicodestring(lpFindFileData.cFileName);
  OutFileName := StrFromTextDispW(wStr);
  result := true;
end;
{$ENDIF}
//
function LLCLS_FFNF_A(lpFileName: PChar; hFindFile: HANDLE; var lpFindFileData: TWin32FindDataA; var OutFileName: string; var ResFunc: HANDLE; var LastOSError: DWORD): boolean;
var aStr: ansistring;
begin
  result := false;
  LastOSError := 0;
  aStr := StrToTextDispA(lpFileName);
  if hFindFile=0 then
    begin
      ResFunc := FindFirstFileA(@aStr[1], lpFindFileData);
      if ResFunc=INVALID_HANDLE_VALUE then
        begin
          LastOSError := LLCL_GetLastError();
          exit;
        end;
    end
  else
    begin
      ResFunc := HANDLE(FindNextFileA(hFindFile, lpFindFileData));   // (False=0)
      if ResFunc=HANDLE(false) then
        begin
          LastOSError := LLCL_GetLastError();
          exit;
        end;
    end;
  aStr := ansistring(lpFindFileData.cFileName);
  OutFileName := StrFromTextDispA(aStr);
  result := true;
end;
//
procedure LLCLS_FFNF_AToW(const aWin32FindData: TWin32FindDataA; var wWin32FindData: TWin32FindDataW);
var wStr: unicodestring;
var aStr: ansistring;
begin
  Move(aWin32FindData, wWin32FindData, LLCLC_LENCOM_WIN32FINDDATA); // Common beginning part
  aStr := ansistring(aWin32FindData.cAlternateFileName);
  wStr := unicodestring(aStr);
  StrLCopyW(wWin32FindData.cAlternateFileName, wStr, Length(wWin32FindData.cAlternateFileName));
  aStr := ansistring(aWin32FindData.cFileName);
  wStr := unicodestring(aStr);
  StrLCopyW(wWin32FindData.cFileName, wStr, Length(wWin32FindData.cFileName));
end;
//
procedure LLCLS_FFNF_WToA(const wWin32FindData: TWin32FindDataW; var aWin32FindData: TWin32FindDataA);
var wStr: unicodestring;
var aStr: ansistring;
begin
  Move(wWin32FindData, aWin32FindData, LLCLC_LENCOM_WIN32FINDDATA); // Common beginning part
  wStr := unicodestring(wWin32FindData.cAlternateFileName);
  aStr := ansistring(wStr);
  StrLCopyA(aWin32FindData.cAlternateFileName, aStr, Length(aWin32FindData.cAlternateFileName));
  wStr := unicodestring(wWin32FindData.cFileName);
  aStr := ansistring(wStr);
  StrLCopyA(aWin32FindData.cFileName, aStr, Length(aWin32FindData.cFileName));
end;

function LLCLS_GetCurrentDirectory(): string;
{$IFDEF LLCL_UNICODE_API_W}
var wBuffer: array[0..MAX_PATH+1] of WideChar;  // (Including terminating null character, plus one)
var wDirectory: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aBuffer: array[0..MAX_PATH+1] of AnsiChar;  // (Including terminating null character, plus one)
var aDirectory: ansistring;
{$ENDIF}
var icount: integer;
begin
  result := '';
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      icount := GetCurrentDirectoryW(Length(wBuffer)-1, @wBuffer);
      if icount>0 then
        begin
          wBuffer[icount] := WideChar(0); // (may be absent)
          wDirectory := unicodestring(wBuffer);
          result := StrFromTextDispW(wDirectory);
        end;
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    ;   // (result='' already set)
{$ELSE}
    begin
      icount := GetCurrentDirectoryA(Length(aBuffer)-1, @aBuffer);
      if icount>0 then
        begin
          aBuffer[icount] := AnsiChar(0); // (may be absent)
          aDirectory := ansistring(aBuffer);
          result := StrFromTextDispA(aDirectory);
        end;
    end;
{$ENDIF}
end;

function LLCLS_GetFullPathName(const sFileName: string): string;
{$IFDEF LLCL_UNICODE_API_W}
var wBuffer: array[0..MAX_PATH+1] of WideChar;  // (Including terminating null character, plus one)
var wName: unicodestring;
var lpwPart: PUnicodeChar;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aBuffer: array[0..MAX_PATH+1] of AnsiChar;  // (Including terminating null character, plus one)
var aName: ansistring;
var lpaPart: PAnsiChar;
{$ENDIF}
var icount: integer;
begin
  result := '';
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wName := StrToTextDispW(sFileName);
      icount := GetFullPathNameW(@wName[1], Length(wBuffer)-1, @wBuffer, lpwPart);
      if icount>0 then
        begin
          wBuffer[icount] := WideChar(0); // (may be absent)
          wName := unicodestring(wBuffer);
          result := StrFromTextDispW(wName);
        end;
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    ;   // (result='' already set)
{$ELSE}
    begin
      aName := StrToTextDispA(sFileName);
      icount := GetFullPathNameA(@aName[1], Length(aBuffer)-1, @aBuffer, lpaPart);
      if icount>0 then
        begin
          aBuffer[icount] := AnsiChar(0); // (may be absent)
          aName := ansistring(aBuffer);
          result := StrFromTextDispA(aName);
        end;
    end;
{$ENDIF}
end;

function LLCLS_GetDiskSpace(const sDrive: string; var TotalSpace, FreeSpaceAvailable: int64): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var PAddrGetDiskFreeSpaceExW: function(lpDirectoryName: LPCWSTR; lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes: PInt64): BOOL; stdcall;
var wDrive: unicodestring;
var lpwDrive: PUnicodeChar;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var PAddrGetDiskFreeSpaceExA: function(lpDirectoryName: LPCSTR; lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes: PInt64): BOOL; stdcall;
var aDrive: ansistring;
var lpaDrive: PAnsiChar;
{$ENDIF}
var AllFree: int64;
begin
  result := false;
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      if sDrive='' then
        lpwDrive := nil
      else
        begin
          wDrive := StrToTextDispW(sDrive);
          lpwDrive := @wDrive[1];
        end;
      {$IFDEF LLCL_OBJFPC_MODE}FARPROC(PAddrGetDiskFreeSpaceExW){$ELSE}@PAddrGetDiskFreeSpaceExW{$ENDIF}
        := LLCL_GetProcAddress(LLCL_GetModuleHandle(CKERNEL32), 'GetDiskFreeSpaceExW');
      if Assigned(PAddrGetDiskFreeSpaceExW) then
        result := PAddrGetDiskFreeSpaceExW(lpwDrive, @FreeSpaceAvailable, @TotalSpace, @AllFree)
      else
        ;   // Returns false for Win95 before OSR2 (should use GetDiskFreeSpaceW otherwise)
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    ;   // (result=false already set)
{$ELSE}
    begin
      if sDrive='' then
        lpaDrive := nil
      else
        begin
          aDrive := StrToTextDispA(sDrive);
          lpaDrive := @aDrive[1];
        end;
      {$IFDEF LLCL_OBJFPC_MODE}FARPROC(PAddrGetDiskFreeSpaceExA){$ELSE}@PAddrGetDiskFreeSpaceExA{$ENDIF}
        := LLCL_GetProcAddress(LLCL_GetModuleHandle(CKERNEL32), 'GetDiskFreeSpaceExA');
      if Assigned(PAddrGetDiskFreeSpaceExA) then
        result := PAddrGetDiskFreeSpaceExA(lpaDrive, @FreeSpaceAvailable, @TotalSpace, @AllFree)
      else
        ;   // Returns false for Win95 before OSR2 (should use GetDiskFreeSpaceA otherwise)
    end;
{$ENDIF}
end;

function LLCLS_FormatMessage(dwFlags: DWORD; lpSource: Pointer; dwMessageId: DWORD; dwLanguageId: DWORD; Arguments: Pointer): string;
{$IFDEF LLCL_UNICODE_API_W}
var wBuffer: array[0..255+1] of WideChar;  // (Including terminating null character, plus one)
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aBuffer: array[0..255+1] of AnsiChar;  // (Including terminating null character, plus one)
{$ENDIF}
var icount: integer;
begin
  result := '';
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      icount := FormatMessageW(dwFlags, lpSource, dwMessageId, dwLanguageId, @wBuffer, Length(wBuffer)-1, Arguments);
      if icount>0 then
        begin
          wBuffer[icount] := WideChar(0); // (may be absent)
          result := StrFromTextDispW(wBuffer);
        end;
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    ;   // (result='' already set)
{$ELSE}
  begin
      icount := FormatMessageA(dwFlags, lpSource, dwMessageId, dwLanguageId, @aBuffer, Length(aBuffer)-1, Arguments);
      if icount>0 then
        begin
          aBuffer[icount] := AnsiChar(0); // (may be absent)
          result := StrFromTextDispA(aBuffer);
        end;
    end;
{$ENDIF}
end;

function  LLCLS_StringToOem(const sText: string): ansistring;
{$IFDEF LLCL_UNICODE_API_W}
var wStrIn: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStrIn: ansistring;
{$ENDIF}
var aStrOut: ansistring;
begin
  result := '';
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStrIn := StrToTextDispW(sText);
      SetLength(aStrOut, length(wStrIn)+1);
      if CharToOEMW(@wStrIn[1], @aStrOut[1]) then
        result := aStrOut;
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    ;   // (result='' already set)
{$ELSE}
    begin
      aStrIn := StrToTextDispA(sText);
      SetLength(aStrOut, length(aStrIn)+1);
      if CharToOEMA(@aStrIn[1], @aStrOut[1]) then
        result := aStrOut;
    end;
{$ENDIF}
  {$if Defined(LLCL_FPC_CPSTRING) or Defined(UNICODE)}
  SetCodePage(rawbytestring(result), LLCL_GetOEMCP(), false);
  {$ifend}
end;


function LLCLS_GetTextSize(hWnd: HWND; const sText: string; FontHandle: THandle; var Size: TSize): BOOL;
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
var ADC: HDC;
var CurFontHandle: THandle;
begin
  ADC := GetDC(hWnd);
  CurFontHandle := SelectObject(ADC, FontHandle);
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr := StrToTextDispW(sText);
      result := GetTextExtentPoint32W(ADC, @wStr[1], Length(wStr), Size);
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    begin
      result := false;
      if CurFontHandle<>0 then      // (result=false already set
        result := false;            //  tricky instructions to avoid note)
    end;
{$ELSE}
    begin
      aStr := StrToTextDispA(sText);
      result := GetTextExtentPoint32A(ADC, @aStr[1], Length(aStr), Size);
    end;
  SelectObject(ADC, CurFontHandle);
  ReleaseDC(hWnd, ADC);
{$ENDIF}
end;

function LLCLS_IsAccel(VK: word; const Str: string): BOOL;
begin
  if VK in [ord('a')..ord('z')] then                        // Test uppercase
    result := ( (VK-32)=ValAccelStr(Str) )
  else
    result := ( VK=ValAccelStr(Str) );
end;
//
function ValAccelStr(const Str: string): word;
const AMPER = '&';
{$IFDEF LLCL_UNICODE_API_W}
var wStr: unicodestring;
{$ENDIF}
{$IFNDEF LLCL_UNICODE_API_W_ONLY}
var aStr: ansistring;
{$ENDIF}
var i: integer;
begin
  result := 0;
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    begin
      wStr:=StrToTextDispW(Str);
      for i := 1 to (length(wStr)-1) do
        if (wStr[i]=AMPER) and (wStr[i+1]<>AMPER) then
          begin
            result := Ord(wStr[i+1]);
            break;
          end;
    end
  else
{$ENDIF}
{$IFDEF LLCL_UNICODE_API_W_ONLY}
    ;   // (result=0 already set)
{$ELSE}
    begin
      aStr:=StrToTextDispA(Str);
      for i := 1 to (length(aStr)-1) do
        if (aStr[i]=AMPER) and (aStr[i+1]<>AMPER) then
          begin
            result := Ord(aStr[i+1]);
            break;
          end;
    end;
{$ENDIF}
  if result in [Ord('a')..ord('z')] then Dec(result, 32);   // Always uppercase
end;

function LLCLS_CharCodeToChar(const CharCode: word): Char;
begin
{$IFDEF LLCL_UNICODE_API_W}
  if UnicodeEnabledOS then
    result := Char(WideChar(CharCode))
  else
{$ENDIF}
    result := Char(CharCode);
end;

function LLCLS_FormUTF8ToString(const S: utf8string): string;
begin
{$IFDEF LLCL_UNICODE_STR_UTF8}
  result := S;
{$ELSE} {$IFDEF LLCL_UNICODE_STR_UTF16}
  result := UTF8Decode(S);
{$ELSE}
  result := UTF8ToAnsi(S);
{$ENDIF} {$ENDIF}
end;

function LLCLS_FormStringToString(const S: ansistring): string;
begin
{$IFDEF LLCL_UNICODE_STR_UTF8}
  result := S;      // UTF8 data are stored as string
{$ELSE} {$IFDEF LLCL_UNICODE_STR_UTF16}
  result := UTF8Decode(S);
{$ELSE}
  result := S;
{$ENDIF} {$ENDIF}
end;

{$IFDEF FPC}
// Functions specific to FPC/Lazarus (LazUTF8.pas)

{$IFDEF UNICODE}
function LLCLS_UTF8ToSys(const S: utf8string): ansistring;
{$ELSE UNICODE}
function LLCLS_UTF8ToSys(const S: string): string;
{$ENDIF UNICODE}
begin
{$IFDEF LLCL_FPC_UTF8RTL}
  result := S;
{$ELSE}
  result := UTF8ToAnsi(S);
{$ENDIF}
end;

{$IFDEF UNICODE}
function LLCLS_SysToUTF8(const S: ansistring): utf8string;
{$ELSE UNICODE}
function LLCLS_SysToUTF8(const S: string): string;
{$ENDIF UNICODE}
begin
{$IFDEF LLCL_FPC_UTF8RTL}
  result := S;
{$ELSE}
  result := AnsiToUTF8(S);
  {$IFDEF LLCL_FPC_CPSTRING}
  SetCodePage(rawbytestring(result), StringCodePage(S), false);
  {$ENDIF}
{$ENDIF}
end;

{$IFDEF UNICODE}
function LLCLS_UTF8ToWinCP(const S: utf8string): ansistring;
{$ELSE UNICODE}
function LLCLS_UTF8ToWinCP(const S: string): string;
{$ENDIF UNICODE}
begin
  {$IFDEF LLCL_UNICODE_STR_UTF16}
  result := StrToTextDispA(unicodestring(S));
  {$ELSE}
  result := StrToTextDispA(S);
  {$ENDIF}
  {$IFDEF LLCL_FPC_CPSTRING}
  SetCodePage(rawbytestring(result), CP_ACP, false);
  {$ENDIF}
end;

{$IFDEF UNICODE}
function LLCLS_WinCPToUTF8(const S: ansistring): utf8string;
{$ELSE UNICODE}
function LLCLS_WinCPToUTF8(const S: string): string;
{$ENDIF UNICODE}
begin
  {$IFDEF LLCL_UNICODE_STR_UTF16}
  result := utf8string(StrFromTextDispA(S));
  {$ELSE}
  result := StrFromTextDispA(S);
  {$ENDIF}
  {$IFDEF LLCL_FPC_CPSTRING}
  SetCodePage(rawbytestring(result), CP_ACP, false);
  {$ENDIF}
end;
{$ENDIF FPC}
//------------------------------------------------------------------------------

//
// String Conversion for Text Displaying (Ansi version)
//
function StrToTextDispA(const S: string): ansistring;
begin
{$IFDEF LLCL_UNICODE_STR_UTF8}
  {$IFDEF LLCL_FPC_CPSTRING}
  result := S;
  if StringCodePage(result)<>CP_UTF8 then
    SetCodePage(rawbytestring(result), CP_UTF8, false);
  SetCodePage(rawbytestring(result), LLCL_GetACP(), true);
  {$ELSE}
  result := UTF8ToAnsi(S);
  {$ENDIF}
{$ELSE} {$IFDEF LLCL_UNICODE_STR_UTF16}
  result := ansistring(S);
{$ELSE}
  result := S;
{$ENDIF} {$ENDIF}
end;

//
// String Conversion for Text Displaying (Unicode wide version)
//
function StrToTextDispW(const S: string): unicodestring;
{$IFDEF LLCL_UNICODE_STR_UTF8}{$IFDEF LLCL_FPC_CPSTRING}
var STemp: string;
{$ENDIF}{$ENDIF}
begin
{$IFDEF LLCL_UNICODE_STR_UTF8}
  {$IFDEF LLCL_FPC_CPSTRING}
  if StringCodePage(S)=CP_UTF8 then
    result := unicodestring(S)
  else
    begin
      STemp := S;
      SetCodePage(rawbytestring(STemp), CP_UTF8, false);
      result := unicodestring(STemp);
    end;
  {$ELSE}
  result := UTF8Decode(S);
  {$ENDIF}
{$ELSE} {$IFDEF LLCL_UNICODE_STR_UTF16}
  result := S;
{$ELSE}
  result := unicodestring(S);
{$ENDIF} {$ENDIF}
end;

//
// String Conversion from Text Display (Ansi version)
//
function StrFromTextDispA(const S: ansistring): string;
begin
{$IFDEF LLCL_UNICODE_STR_UTF8}
  {$IFDEF LLCL_FPC_CPSTRING}
  result := S;
  SetCodePage(rawbytestring(result), LLCL_GetACP(), false);
  SetCodePage(rawbytestring(result), CP_UTF8, true);
  SetCodePage(rawbytestring(result), StringCodePage(' '), false);
  {$ELSE}
  result := AnsiToUTF8(S);
  {$ENDIF}
{$ELSE} {$IFDEF LLCL_UNICODE_STR_UTF16}
  result := unicodestring(S);
{$ELSE}
  result := S;
{$ENDIF} {$ENDIF}
end;

//
// String Conversion from Text Display (Unicode wide version)
//
function StrFromTextDispW(const S: unicodestring): string;
begin
{$IFDEF LLCL_UNICODE_STR_UTF8}
  {$IFDEF LLCL_FPC_CPSTRING}
  result := string(S);
  if StringCodePage(result)<>CP_UTF8 then
    begin
      SetCodePage(rawbytestring(result), CP_UTF8, true);
      SetCodePage(rawbytestring(result), StringCodePage(' '), false);
    end;
  {$ELSE}
  result := UTF8Encode(S);
  {$ENDIF}
{$ELSE} {$IFDEF LLCL_UNICODE_STR_UTF16}
  result := S;
{$ELSE}
  result := ansistring(S);
{$ENDIF} {$ENDIF}
end;

// Pointer to NativeUInt (Avoid compilation warnings)
function PointerToNativeUInt(p: Pointer): NativeUInt;
begin
  result := NativeUInt(p);
end;

procedure StrLCopyA(var Dest: array of AnsiChar; const Source: ansistring; MaxLen: cardinal);
var ilen: cardinal;
begin
  ilen := Length(Source);
  if ilen>MaxLen-1 then ilen := MaxLen-1;
  Move(Source[1], Dest, ilen);
  Dest[iLen] := AnsiChar(0);
end;

procedure StrLCopyW(var Dest: array of WideChar; const Source: unicodestring; MaxLen: cardinal);
var ilen: cardinal;
begin
  ilen := Length(Source);
  if ilen>MaxLen-1 then ilen := MaxLen-1;
  Move(Source[1], Dest, ilen*2);
  Dest[iLen] := WideChar(0);
end;

//------------------------------------------------------------------------------

{$IFDEF LLCL_FPC_UTF8RTL}     // (FPC only)
procedure CallInit();
begin
  if InitDone then exit;
  SetMultiByteConversionCodePage(CP_UTF8);
  SetMultiByteRTLFileSystemCodePage(CP_UTF8);
  InitDone := true;
end;

initialization
  CallInit();
{$ENDIF}

{$IFDEF FPC}
  {$POP}
{$ENDIF}

end.
