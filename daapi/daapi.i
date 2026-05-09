%module(directors="1") daapi


%typemap(cstype) wchar_t* "string"

%{
// 平台调用约定强制定义
#if defined(_WIN32) || defined(__CYGWIN__)
# define SWIG_WINAPI __stdcall
# ifdef __MINGW32__
#  define SWIG_EXPORT __declspec(dllexport)
# else
#  define SWIG_EXPORT
# endif
#else
# define SWIG_WINAPI
# define SWIG_EXPORT
#endif


#define _WINSOCKAPI_        // 禁止 winsock.h
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX

#include <winsock2.h>       // 必须在 windows.h 前
#include <windows.h>

#include "Include\DADataType.h"
#include "Include\DAFutureApi.h"
#include "Include\DAFutureStruct.h"
#include "Include\DAMarketApi.h"
#include "Include\DAMarketStruct.h"
#include "Include\DAStockApi.h"
#include "Include\DAStockStruct.h"
using namespace Directaccess;
%}


%include <typemaps.i>
%include "carrays.i"
//-------------------------------------
%include <stdint.i>
%include <wchar.i>


%apply long long { INT64 };


// 启用 director 功能以支持从 Go 继承 C++ 类
%feature("director") Directaccess::IMarketEvent;
%feature("director") Directaccess::IFutureEvent;


//-------------------------------------


%inline %{
#define LPCSTR char*
#define LPCWSTR const wchar_t*
%}


typedef __time32_t time_t;
typedef long long __time32_t;


%include "windows.i"

%include "Include\\DADataType.h"
%include "Include\\DAFutureApi.h"
%include "Include\\DAFutureStruct.h"
%include "Include\\DAMarketApi.h"
%include "Include\\DAMarketStruct.h"
%include "Include\\DAStockApi.h"
%include "Include\\DAStockStruct.h"