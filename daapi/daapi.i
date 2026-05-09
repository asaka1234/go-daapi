%module(directors="1", threads="1") daapi

// ========== 添加这部分：延迟初始化控制 ==========
%pragma(go) code %{
import (
    "runtime"
    "sync"
)

var (
    initOnce sync.Once
)

func init() {
    // 这个 init 不会立即执行 CGO 调用，只是注册
}

func ensureInitialized() {
    initOnce.Do(func() {
        runtime.LockOSThread()
        // 强制初始化但不调用任何实际 API
        _ = Swig_initialize()
    })
}
%}

// 添加一个空函数，用于触发 SWIG 内部初始化
%inline %{
    void Swig_initialize() {
        // 空函数，仅用于触发 SWIG 的内部初始化
    }
%}

// 添加这两行 - 控制 GIL（全局解释器锁）行为
%feature("nothreadallow");
%feature("director:except") {
    if ($error != NULL) {
        throw Swig::DirectorMethodException();
    }
}

%{
#include <stdint.h>
#include <string.h>

// 添加：控制静态初始化
namespace {
    class InitController {
    public:
        InitController() {
            // 禁止任何会调用 Go 的初始化代码
            // 仅做最基础的 C++ 初始化
        }
    };
    static InitController g_initController;
}

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

%feature("director") IMarketEvent;
%feature("director") IFutureEvent;

%include "Include\\DADataType.h"
%include "Include\\DAFutureApi.h"
%include "Include\\DAFutureStruct.h"
%include "Include\\DAMarketApi.h"
%include "Include\\DAMarketStruct.h"
%include "Include\\DAStockApi.h"
%include "Include\\DAStockStruct.h"