// // package com.dropbox.android.external.store4

// // import kotlin.time.Duration
// // import kotlin.time.ExperimentalTime

// // import 'package:flutter/cupertino.dart';

// // @ExperimentalTime
// import 'package:flutter/widgets.dart';

// @protected
// class StoreDefaults {
//   /**
//      * Cache TTL (default is 24 hours), can be overridden
//      *
//      * @return memory cache TTL
//      */
//   static final Duration cacheTTL = Duration(hours: 24);

//   /**
//      * Cache size (default is 100), can be overridden
//      *
//      * @return memory cache size
//      */
//   static final cacheSize = 100.0;

//   static final MemoryPolicy memoryPolicy = MemoryPolicy.builder<Any, Any>()
//       .setMaxSize(cacheSize)
//       .setExpireAfterWrite(cacheTTL)
//       .build();
// }
