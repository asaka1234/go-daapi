%module(directors="1", threads="1") daapi

// 添加这部分：控制Director的初始化时机
%pragma(go) code = %{
var directorInit sync.Once

func initDirectors() {
    directorInit.Do(func() {
        // 强制在Go运行时稳定后再初始化Director
        runtime.LockOSThread()
        runtime.GC()
    })
}
%}

// 包装每个Director类，延迟初始化
%typemap(gotype) IMarketEvent "interface{}"
%typemap(in) IMarketEvent * {
    initDirectors();  // 在每次使用前调用
    $1 = *($&1_type*)&$input;
}

%{
#include <stdint.h>
#include <string.h>

// 添加初始化标志
static bool g_swig_initialized = false;

void swig_ensure_init() {
    if (!g_swig_initialized) {
        // 仅设置标志，不进行实际初始化
        g_swig_initialized = true;
    }
}
%}

// 在所有构造函数中插入初始化检查
%feature("action") CMarketApi::CreateMarketApi {
    swig_ensure_init();
    $result = $function;
}

/* INT64 mapping */
%apply long long { INT64 };

%feature("director") IMarketEvent;

%include "Include\\DADataType.h"
%include "Include\\DAFutureApi.h"
%include "Include\\DAFutureStruct.h"
%include "Include\\DAMarketApi.h"
%include "Include\\DAMarketStruct.h"
%include "Include\\DAStockApi.h"
%include "Include\\DAStockStruct.h"