%module daapi

/*************************************************
 * C/C++ includes
 *************************************************/
%{
#if defined(_WIN32) || defined(__CYGWIN__)
# define WIN32_LEAN_AND_MEAN
# define NOMINMAX
# include <windows.h>

# ifdef __MINGW32__
#  define DA_API __declspec(dllexport)
# else
#  define DA_API
# endif

# define SWIGWINAPI __stdcall
#else
# define DA_API
# define SWIGWINAPI
#endif

#include <stdint.h>
#include <string.h>

#include "Include\\DADataType.h"
#include "Include\\DAFutureApi.h"
#include "Include\\DAFutureStruct.h"
#include "Include\\DAMarketApi.h"
#include "Include\\DAMarketStruct.h"
#include "Include\\DAStockApi.h"
#include "Include\\DAStockStruct.h"

using namespace Directaccess;
%}

/*************************************************
 * SWIG core
 *************************************************/
%include <stdint.i>
%include <typemaps.i>

/*************************************************
 * IMPORTANT FIX:
 * ❌ DO NOT USE custom SWIG string helpers
 * Go backend does NOT provide SWIG_FromCharPtr
 *************************************************/

/* INT64 mapping */
%apply long long { INT64 };

/*************************************************
 * SAFE string handling (Go-native behavior)
 * 👉 REMOVE ALL SWIG_FromCharPtr usage
 *************************************************/

/* char* -> Go string (OUT) */
%typemap(out) char* {
    if ($1) {
        $result = SWIG_GoString($1);
    } else {
        $result = SWIG_GoString("");
    }
}

/* const char* -> Go string (OUT) */
%typemap(out) const char* {
    if ($1) {
        $result = SWIG_GoString($1);
    } else {
        $result = SWIG_GoString("");
    }
}

/*************************************************
 * wchar_t SAFE fallback (IMPORTANT)
 * DO NOT expose raw wchar_t memory ownership
 *************************************************/
%typemap(out) wchar_t* {
    if ($1) {
        $result = SWIG_GoString($1);
    } else {
        $result = SWIG_GoString("");
    }
}

/*************************************************
 * ABI marker (no effect, documentation only)
 *************************************************/
%define SWIGWINAPI __stdcall
%enddef

/*************************************************gi
 * API HEADERS
 *************************************************/
%include "Include\\DADataType.h"
%include "Include\\DAFutureApi.h"
%include "Include\\DAFutureStruct.h"
%include "Include\\DAMarketApi.h"
%include "Include\\DAMarketStruct.h"
%include "Include\\DAStockApi.h"
%include "Include\\DAStockStruct.h"