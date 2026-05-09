%module daapi

/*************************************************
 * C/C++ includes (must be outside %{})
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
 * SWIG standard includes (GO SAFE SET)
 *************************************************/
%include <stdint.i>
%include <typemaps.i>

/*************************************************
 * IMPORTANT: DO NOT USE THESE (Go NOT supported)
 *************************************************/
// ❌ %include <cstring.i>   <-- REMOVED (causes your error)
// ❌ directors disabled completely
// %feature("director") Directaccess::IMarketEvent;

/*************************************************
 * Type mappings
 *************************************************/

/* INT64 mapping */
%apply long long { INT64 };

/*************************************************
 * SAFE string handling (char*)
 *************************************************/

/* C -> Go string */
%typemap(out) char* {
    if ($1) {
        $result = SWIG_FromCharPtr($1);
    } else {
        $result = SWIG_FromCharPtr("");
    }
}

/* const char* -> Go string */
%typemap(out) const char* {
    if ($1) {
        $result = SWIG_FromCharPtr($1);
    } else {
        $result = SWIG_FromCharPtr("");
    }
}

/*************************************************
 * wchar_t handling (SAFE fallback)
 * DO NOT expose raw wchar_t* to Go
 *************************************************/
%typemap(out) wchar_t* {
    if ($1) {
        $result = SWIG_FromCharPtr($1); // assumes UTF-8 compatible or pre-converted
    } else {
        $result = SWIG_FromCharPtr("");
    }
}

/*************************************************
 * Force ABI consistency marker (document only)
 *************************************************/
%define SWIGWINAPI __stdcall
%enddef

/*************************************************
 * API HEADERS
 *************************************************/
%include "Include\\DADataType.h"
%include "Include\\DAFutureApi.h"
%include "Include\\DAFutureStruct.h"
%include "Include\\DAMarketApi.h"
%include "Include\\DAMarketStruct.h"
%include "Include\\DAStockApi.h"
%include "Include\\DAStockStruct.h"