/*
 * Copyright (C) 2020-present Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */

#ifdef KRAKEN_ENABLE_JSA

#include "jsa/include/js_context.h"
#include "jsa/include/jsc/jsc_implementation.h"
#include "foundation/bridge_callback.h"
#include "bridge_jsa.h"
#include "gtest/gtest.h"
#include <chrono>
#include <memory>
#include <mutex>
#include <thread>

void normalPrint(int32_t contextId, const char *errmsg) {
  std::cerr << errmsg << std::endl;
  FAIL();
}

TEST(BridgeCallback, worksWithNoFunctionLeaks) {
  std::unique_ptr<kraken::JSBridge> bridge = std::make_unique<kraken::JSBridge>(0, normalPrint);
//  const std::unique_ptr<KRAKEN_JS_CONTEXT> &context = bridge->getContext();
//  std::mutex mutex;
//  std::condition_variable condition;
//  void *sharedData = nullptr;
//
//  auto producterThread = [&]() {
//    auto postToChildThread = [&](void *data) {
//      std::unique_lock<std::mutex> lock(mutex);
//      sharedData = data;
//      condition.notify_one();
//    };
//
//    jsa::HostFunctionType func = [](JSContext &context, const Value &thisVal, const Value *args,
//                                    size_t count) -> Value { return Value::undefined(); };
//    Function hostFunction = Function::createFromHostFunction(*context, PropNameID::forAscii(*context, "func"), 0, func);
//
//    std::shared_ptr<Value> callbackValue = std::make_shared<Value>(jsa::Value(*context, hostFunction));
//    auto callbackContext = std::make_unique<BridgeCallback::Context>(*context, callbackValue);
//    auto bridge = static_cast<kraken::JSBridge *>(context->getOwner());
//    bridge->bridgeCallback->registerCallback<void>(
//      std::move(callbackContext), [&postToChildThread](void *data, int32_t contextId) { postToChildThread(data); });
//  };
//
//  auto customerThread = [&]() {
//    std::unique_lock<std::mutex> lock(mutex);
//    condition.wait(lock);
//    std::this_thread::sleep_for(std::chrono::microseconds(1));
//    auto *ctx = static_cast<BridgeCallback::Context *>(sharedData);
//    JSContext &_context = ctx->_context;
//    ctx->_callback->getObject(_context).getFunction(_context).call(_context);
//  };
//
//  std::thread childA(producterThread);
//  std::thread childB(customerThread);
//
//  childA.join();
//  childB.join();
}

#endif
