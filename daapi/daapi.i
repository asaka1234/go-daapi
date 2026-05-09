%module daapi

%{
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

/* INT64 mapping */
%apply long long { INT64 };

%include "Include\\DADataType.h"
%include "Include\\DAFutureApi.h"
%include "Include\\DAFutureStruct.h"
%include "Include\\DAMarketApi.h"
%include "Include\\DAMarketStruct.h"
%include "Include\\DAStockApi.h"
%include "Include\\DAStockStruct.h"